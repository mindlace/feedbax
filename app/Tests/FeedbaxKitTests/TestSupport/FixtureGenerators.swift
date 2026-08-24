import Foundation
import AVFoundation
import CoreVideo
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
import simd

/// Shared, test-target-wide fixture generators. `MovieSourceTests` (Task 16) originally kept
/// a private copy of the movie writer below to build its own disposable per-test fixture;
/// Task 22's golden-frame harness needs the identical H.264-sweep generator to produce the
/// ONE-TIME, committed `GoldenFrameTests/Fixtures/sweep.mov` — extracted here instead of
/// duplicated a second time, per that task's own brief.
enum FixtureGenerationError: Error { case step(String) }

/// Writes a `frameCount`-frame, `size`×`size`, H.264 movie at `fps` whose frames sweep red
/// from `redRange.high` (frame 0) down to `redRange.low` (the last frame) — the only
/// external dependency `MovieSourceTests` (a disposable temp-file fixture, default full
/// 255->0 range) and the golden `sweep.mov` fixture (generated once, committed) both have.
/// `AVAssetWriterInputPixelBufferAdaptor` hands each frame a pool-backed `CVPixelBuffer`
/// already in the writer's chosen pixel format, so this never needs its own
/// `CVPixelBufferPool` bookkeeping.
///
/// `sweep.mov` itself was generated with `redRange: (20, 90)`, narrower than the default —
/// see `Scenarios.primeMovie`'s doc (GoldenFrameTests.swift) for why: a wide sweep straddles
/// `LumaKeyFilter`'s low-pass keying threshold, turning ordinary frame-priming timing
/// variance into a binary "keyed out or not" difference in `keyers-on-movie`'s captured
/// output. Regenerating it (if the fixture is ever lost or needs to change) means writing a
/// throwaway XCTest that calls this function with that same `redRange` and deleting it
/// afterward — same one-time-script pattern Task 22 itself used, not a checked-in tool.
func writeFixtureMovie(to url: URL, frameCount: Int, size: Int, fps: Int32,
                       fileType: AVFileType = .mp4,
                       redRange: (low: UInt8, high: UInt8) = (0, 255)) throws {
  let writer = try AVAssetWriter(outputURL: url, fileType: fileType)
  let videoSettings: [String: Any] = [
    AVVideoCodecKey: AVVideoCodecType.h264,
    AVVideoWidthKey: size,
    AVVideoHeightKey: size,
  ]
  let input = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
  input.expectsMediaDataInRealTime = false
  let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: [
    kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
    kCVPixelBufferWidthKey as String: size,
    kCVPixelBufferHeightKey as String: size,
  ])
  writer.add(input)
  guard writer.startWriting() else {
    throw FixtureGenerationError.step("startWriting: \(writer.error?.localizedDescription ?? "?")")
  }
  writer.startSession(atSourceTime: .zero)

  for i in 0..<frameCount {
    while !input.isReadyForMoreMediaData { Thread.sleep(forTimeInterval: 0.01) }
    guard let pool = adaptor.pixelBufferPool else { throw FixtureGenerationError.step("no pixel buffer pool") }
    var pixelBufferOut: CVPixelBuffer?
    CVPixelBufferPoolCreatePixelBuffer(nil, pool, &pixelBufferOut)
    guard let pixelBuffer = pixelBufferOut else { throw FixtureGenerationError.step("pixel buffer alloc") }
    // Red sweeps from redRange.high (frame 0) to redRange.low (the last frame); BGRA byte
    // order matches the pool's kCVPixelFormatType_32BGRA.
    let span = Int(redRange.high) - Int(redRange.low)
    let red = UInt8(Int(redRange.low) + span * (frameCount - 1 - i) / max(frameCount - 1, 1))
    CVPixelBufferLockBaseAddress(pixelBuffer, [])
    if let base = CVPixelBufferGetBaseAddress(pixelBuffer) {
      let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
      let ptr = base.assumingMemoryBound(to: UInt8.self)
      for y in 0..<size {
        for x in 0..<size {
          let o = y * bytesPerRow + x * 4
          ptr[o] = 0; ptr[o + 1] = 0; ptr[o + 2] = red; ptr[o + 3] = 255   // B G R A
        }
      }
    }
    CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
    adaptor.append(pixelBuffer, withPresentationTime: CMTime(value: Int64(i), timescale: fps))
  }
  input.markAsFinished()
  let done = DispatchSemaphore(value: 0)
  writer.finishWriting { done.signal() }
  done.wait()
  guard writer.status == .completed else {
    throw FixtureGenerationError.step("finishWriting: \(writer.error?.localizedDescription ?? "?")")
  }
}

/// Writes a `width`×`height` PNG with STRAIGHT (non-premultiplied) alpha — the PNG spec's
/// own convention — where `pixel(x, y)` supplies each pixel's RGBA in 0...1 float. Task 15's
/// `StickerSourceTests.writePNG` is the solid-color special case of this; Task 22's 32×32
/// test glyph (`Fixtures/glyph.png`) needs actual internal structure (quadrant colors, a
/// partial-alpha region) to make the rota-fold/SInvert scenarios' output legible, hence the
/// per-pixel closure here rather than a single flat color.
func writePNG(_ url: URL, width: Int, height: Int, pixel: (Int, Int) -> SIMD4<Float>) throws {
  var raw = [UInt8](); raw.reserveCapacity(width * height * 4)
  for y in 0..<height {
    for x in 0..<width {
      let p = pixel(x, y).clamped(lowerBound: .zero, upperBound: .one) * 255
      raw.append(contentsOf: [UInt8(p.x.rounded()), UInt8(p.y.rounded()),
                              UInt8(p.z.rounded()), UInt8(p.w.rounded())])
    }
  }
  let colorSpace = CGColorSpaceCreateDeviceRGB()
  let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue)   // straight alpha
  guard let provider = CGDataProvider(data: Data(raw) as CFData) else {
    throw FixtureGenerationError.step("CGDataProvider")
  }
  guard let cgImage = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32,
                              bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmapInfo,
                              provider: provider, decode: nil, shouldInterpolate: false,
                              intent: .defaultIntent) else {
    throw FixtureGenerationError.step("CGImage")
  }
  guard let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else {
    throw FixtureGenerationError.step("CGImageDestination")
  }
  CGImageDestinationAddImage(dest, cgImage, nil)
  guard CGImageDestinationFinalize(dest) else { throw FixtureGenerationError.step("finalize") }
}
