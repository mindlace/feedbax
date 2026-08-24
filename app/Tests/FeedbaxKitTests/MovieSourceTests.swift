import XCTest
import AVFoundation
import CoreVideo
import simd
@testable import FeedbaxKit

/// Test-only failure for the fixture-movie writer below — distinct from `FeedbaxError`
/// (that enum is `FeedbaxKit`'s engine-init/shader-lookup errors, not a fit for
/// "AVAssetWriter refused to start").
private enum TestFixtureError: Error { case step(String) }

final class MovieSourceTests: XCTestCase {
  var fixtureURL: URL!

  override func setUpWithError() throws {
    fixtureURL = FileManager.default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
    try writeFixtureMovie(to: fixtureURL, frameCount: 12, size: 64, fps: 30)
  }

  override func tearDownWithError() throws {
    try? FileManager.default.removeItem(at: fixtureURL)
  }

  func testTickDeliversAdvancingFrames() throws {
    let ctx = try MetalContext()
    let src = MovieSource(context: ctx)
    src.load(url: fixtureURL)
    let first = try XCTUnwrap(firstFrame(src, ctx), "player produced no frame within 2 s")
    XCTAssertEqual(first.width, 64); XCTAssertEqual(first.height, 64)
    let redA = meanRed(ctx, first)
    Thread.sleep(forTimeInterval: 0.3)                       // ≥ 9 frames of the 30 fps sweep
    // `excluding: first` (see `firstFrame`'s doc comment) — without it this retry would
    // accept `tick`'s stale-cache fallback on its very first poll and never actually wait
    // for a fresh frame.
    let second = try XCTUnwrap(firstFrame(src, ctx, excluding: first))
    let redB = meanRed(ctx, second)
    XCTAssertGreaterThan(abs(redA - redB), 0.05,
                         "red sweep must advance — the movie plays on its own clock (design §5)")
  }

  /// `id`/`layer`/`transform` defaults, plus the AVPlayer-not-yet-loaded state — no real
  /// playback involved, so this is deterministic (unlike the timing test above).
  func testDefaultsMatchSeedSourceConventions() throws {
    let src = MovieSource(context: try MetalContext())
    XCTAssertEqual(src.id, "movie")
    XCTAssertEqual(src.layer.zOrder, 2)
    XCTAssertFalse(src.layer.enabled)
    XCTAssertEqual(src.transform.position, SIMD2<Float>.zero)
    XCTAssertFalse(src.isPlaying, "no file loaded yet")
  }

  // MARK: - Helpers (from the task-16 brief)

  func meanRed(_ ctx: MetalContext, _ tex: MTLTexture) -> Float {
    let px = ctx.readPixels(tex)
    return px.reduce(0) { $0 + $1.x } / Float(px.count)
  }

  /// Two documented deviations from the brief's literal helper (both sleep-mechanism
  /// tuning, per the task's "tune only the retry deadlines/sleeps" allowance — no assertion
  /// or threshold changed):
  ///
  /// 1. `Thread.sleep(forTimeInterval: 0.05)` → `RunLoop.current.run(until:)`. `swift test`
  ///    runs the test body synchronously on a thread whose run loop nothing else pumps;
  ///    confirmed with a throwaway debug harness that `AVPlayerItem.status` simply never
  ///    leaves `.unknown` — and `hasNewPixelBuffer` never turns true — under a bare
  ///    `Thread.sleep` loop, no matter how many iterations. `RunLoop.current.run(until:)`
  ///    blocks for the same wall-clock slice while also servicing AVFoundation's KVO/async
  ///    delivery, which is what actually lets the player reach `.readyToPlay`.
  /// 2. Added an `excluding:` parameter. `MovieSource.tick` is specified to fall back to
  ///    its cached texture whenever no new pixel buffer is ready (design §5's "repeats
  ///    frames" rule) — which means `tick` is non-nil on nearly every call once the first
  ///    frame has landed. The brief's plain `if let t = src.tick(frame) { return t }` would
  ///    therefore accept that stale cache on `second`'s very first poll and return
  ///    immediately, never actually waiting for playback to advance. `excluding:` keeps the
  ///    same "poll until non-nil, capped at `deadline`" contract, just also requiring the
  ///    result differ from a texture already sampled — the loose part (which frame, how
  ///    many polls) is untouched; only "must not be a no-op fallback" is added.
  func firstFrame(_ src: MovieSource, _ ctx: MetalContext, excluding previous: MTLTexture? = nil,
                  deadline: TimeInterval = 2) -> MTLTexture? {
    let end = Date().addingTimeInterval(deadline)
    while Date() < end {
      let cb = ctx.queue.makeCommandBuffer()!
      let frame = FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: SIMD2(64, 64),
                               commandBuffer: cb, pool: ctx.pool)
      if let t = src.tick(frame), t !== previous { return t }
      RunLoop.current.run(until: Date().addingTimeInterval(0.05))
    }
    return nil
  }

  // MARK: - Fixture generator

  /// Writes a `frameCount`-frame, `size`×`size`, H.264 movie at `fps` whose frames sweep
  /// red (frame 0) → black (the last frame) — `MovieSourceTests`' only external dependency,
  /// since the repo has no checked-in test movie. `AVAssetWriterInputPixelBufferAdaptor`
  /// hands each frame a pool-backed `CVPixelBuffer` already in the writer's chosen pixel
  /// format, so this never needs its own CVPixelBufferPool bookkeeping.
  func writeFixtureMovie(to url: URL, frameCount: Int, size: Int, fps: Int32) throws {
    let writer = try AVAssetWriter(outputURL: url, fileType: .mp4)
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
      throw TestFixtureError.step("startWriting: \(writer.error?.localizedDescription ?? "?")")
    }
    writer.startSession(atSourceTime: .zero)

    for i in 0..<frameCount {
      while !input.isReadyForMoreMediaData { Thread.sleep(forTimeInterval: 0.01) }
      guard let pool = adaptor.pixelBufferPool else { throw TestFixtureError.step("no pixel buffer pool") }
      var pixelBufferOut: CVPixelBuffer?
      CVPixelBufferPoolCreatePixelBuffer(nil, pool, &pixelBufferOut)
      guard let pixelBuffer = pixelBufferOut else { throw TestFixtureError.step("pixel buffer alloc") }
      // Red sweeps from full (frame 0) to black (the last frame); BGRA byte order matches
      // the pool's kCVPixelFormatType_32BGRA.
      let red = UInt8(255 * (frameCount - 1 - i) / max(frameCount - 1, 1))
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
      throw TestFixtureError.step("finishWriting: \(writer.error?.localizedDescription ?? "?")")
    }
  }
}
