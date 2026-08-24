import Metal
import Foundation
import CoreGraphics
import ImageIO
import simd

/// One golden-frame test case (design §9: "a preset file + a scripted control timeline + a
/// fixed clock"). `GoldenRunner.render` interprets this deterministically — no wall clock,
/// no live audio/video device polling beyond what `configure` injects synchronously — so two
/// renders of the same `Scenario` on the same machine land on the same (within-tolerance)
/// pixels, the property `EngineTests.testDeterministicHeadlessRun`'s own doc comment calls
/// out as what this harness is built on top of.
public struct Scenario {
  public var name: String
  public var preset: Preset
  /// Control writes fired at specific frame indices — the "scripted control timeline" (e.g.
  /// `sinvert-kaleidoscope`'s SInvert flip mid-run, checklist #7). Applied through
  /// `ControlRouter.apply` (ramped, exactly like a live gesture) immediately before that
  /// frame's `step`.
  public var timeline: [(frame: Int, write: ControlWrite)]
  public var frames: Int
  public var size: SIMD2<Int>
  /// One-shot setup hook: runs once, after the preset has been applied, before frame 0 —
  /// attach filter chains, flip `layerMode`, load a movie and wait for its first decoded
  /// frame, inject synthetic audio. Anything a `Preset`/`ControlWrite` can't express (design
  /// §9's "scenarios exist that attach the keyers/brcosa to a movie layer").
  public var configure: ((Engine) -> Void)?

  public init(name: String, preset: Preset, timeline: [(frame: Int, write: ControlWrite)] = [],
              frames: Int, size: SIMD2<Int>, configure: ((Engine) -> Void)? = nil) {
    self.name = name
    self.preset = preset
    self.timeline = timeline
    self.frames = frames
    self.size = size
    self.configure = configure
  }
}

/// The result of comparing a rendered frame against its committed reference (design §9).
public struct GoldenVerdict {
  public var passed: Bool
  /// Fraction (0...1) of pixels whose worst-of-4-channels delta exceeds
  /// `GoldenRunner.maxChannelDeltaTolerance`.
  public var failingPixelFraction: Double
  /// The single largest per-channel delta (0...255) observed anywhere in the frame —
  /// diagnostic only; `passed` is decided by `failingPixelFraction`, not this value alone,
  /// since a single hot outlier pixel (a GPU rounding edge case) shouldn't fail a frame that
  /// is otherwise pixel-perfect (design §9's "max channel delta ≤ 2/255 on ≥ 99.9% of
  /// pixels" — a per-pixel threshold applied over a population, not a single global max).
  public var maxChannelDelta: Int
}

enum GoldenRunnerError: Error {
  /// The reference PNG's dimensions don't match the rendered frame's — almost always means
  /// `Scenario.size` changed after the reference was committed; regenerate, don't debug.
  case sizeMismatch
  /// The reference PNG isn't the straight-alpha 8-bit-per-channel RGBA layout
  /// `writeReference` always produces — a hand-edited or corrupted reference file.
  case unreadableReference
}

/// Headless engine driver + PNG comparator for the P1 parity scenarios (design §9). Nothing
/// here is scenario-specific — `GoldenFrameTests.swift` (and its `Scenarios` namespace) own
/// what each of the seven scenarios actually configures; this type only knows how to run
/// *a* `Scenario` and grade the result.
public struct GoldenRunner {
  /// design §9: "max channel delta ≤ 2/255" — 2 (not 2.0/255 pre-scaled) because
  /// `compare` works in raw 0...255 byte space, matching `MetalContext.readPixels`'/
  /// `writeReference`'s own 8-bit rounding.
  public static let maxChannelDeltaTolerance = 2
  /// design §9: "on ≥ 99.9% of pixels" — expressed as the complementary failing fraction.
  public static let maxFailingPixelFraction = 0.001

  /// Runs one scenario to its last frame and reads it back.
  ///
  /// Order (design §9's "preset + timeline + fixed clock", `EngineTests`' own headless-run
  /// convention): build a fresh `Engine` at `scenario.size`, apply the preset (ramped, same
  /// glide a live recall gets — `Engine.applyPreset`), run `configure` once, then step frames
  /// `0..<scenario.frames` with the fixed clock `time = Double(i) / 60` (matching
  /// `EngineTests.testDeterministicHeadlessRun`'s own clock, NOT `engine.frameRate`, so a
  /// scenario's pixels don't shift if a caller ever changes that property), firing every
  /// timeline write scheduled for frame `i` immediately before that frame's `step`. Returns
  /// the final frame's pixels straight from `MetalContext.readPixels` — straight alpha, no
  /// premultiplication, the same convention `writeReference`/`compare` use.
  ///
  /// **The preset is applied a full second BEFORE frame 0's clock (`at: -1`, not `at: 0`) —
  /// load-bearing, found empirically while eyeballing the first generated references.**
  /// `ControlRouter`'s 7 ramped slots (`LinearRamp`, ~100 ms `smoothMs`) start every fresh
  /// `Engine` seeded at `coldStartTarget`'s LARGE pix defaults (hue 0.02, sat/light 0.5 —
  /// checklist #9) and glide toward the preset's (much smaller, ~0.02-0.05) MAPPED targets.
  /// Applying the preset AT frame 0's own timestamp means `LinearRamp.value(at:)` (its
  /// `elapsedMs <= 0` branch) hands back that huge pre-glide value on the very frame being
  /// captured — and because the feedback-plane's `(srcα,dstα)` blend is additive rather than
  /// interpolating once both alphas sit near 1 (checklist #3), applying an HSL delta that
  /// large every frame for even 2-3 frames blows saturation/lightness straight past their
  /// [0,1] clip into a STABLE WHITE fixed point (`hsl2rgb` at `l=1` is white regardless of
  /// hue/sat) — which is exactly what every non-movie scenario's first reference render did,
  /// byte-for-byte identical regardless of that scenario's own erase/zoom/theta/hue. Backing
  /// the preset's apply-time up by 1 s (≫ any `smoothMs`) means every ramp has already fully
  /// settled to its intended, small per-frame target before frame 0 ever samples it — the
  /// same "recall happens, THEN the performance starts" ordering a real session has, just
  /// made explicit here since this harness has no idle warm-up frames of its own.
  public static func render(_ scenario: Scenario, context: MetalContext) throws -> [SIMD4<Float>] {
    let engine = try Engine(context: context)
    engine.setResolution(scenario.size)
    engine.applyPreset(scenario.preset, at: -1)
    scenario.configure?(engine)

    let writesByFrame = Dictionary(grouping: scenario.timeline, by: { $0.frame })
    var last: MTLTexture!
    for i in 0..<scenario.frames {
      let time = Double(i) / 60
      for scheduled in writesByFrame[i] ?? [] {
        engine.router.apply(scheduled.write, at: time)
      }
      let commandBuffer = context.queue.makeCommandBuffer()!
      last = engine.step(at: time, commandBuffer: commandBuffer)
      commandBuffer.commit()
      commandBuffer.waitUntilCompleted()
      context.pool.endFrame()
    }
    return context.readPixels(last)
  }

  /// design §9's tolerance check: pass when at most `maxFailingPixelFraction` of pixels have
  /// a worst-channel delta exceeding `maxChannelDeltaTolerance`, against the PNG at
  /// `referencePNG`. Compares all 4 channels (RGB and alpha) — the accumulator's alpha is
  /// not always 1.0 (the past-plane composite is `(srcα, dstα)` blended, design §5/checklist
  /// #3), so it carries real per-frame state, not just an unused bookkeeping channel.
  public static func compare(_ result: [SIMD4<Float>], referencePNG: URL) throws -> GoldenVerdict {
    let (reference, refSize) = try readPNG(referencePNG)
    guard reference.count == result.count else { throw GoldenRunnerError.sizeMismatch }
    var failingPixels = 0
    var worstDelta = 0
    for i in 0..<result.count {
      let a = bytes(result[i])
      let b = bytes(reference[i])
      var pixelWorst = 0
      for channel in 0..<4 { pixelWorst = max(pixelWorst, abs(Int(a[channel]) - Int(b[channel]))) }
      worstDelta = max(worstDelta, pixelWorst)
      if pixelWorst > maxChannelDeltaTolerance { failingPixels += 1 }
    }
    _ = refSize   // dimensions already validated via the count check above
    let fraction = Double(failingPixels) / Double(result.count)
    return GoldenVerdict(passed: fraction <= maxFailingPixelFraction,
                         failingPixelFraction: fraction, maxChannelDelta: worstDelta)
  }

  /// Writes `result` as a straight-alpha (non-premultiplied) 8-bit RGBA PNG — the PNG file
  /// format's own native pixel layout, so `readPNG` can recover these exact byte values by
  /// reading the decoded `CGImage`'s backing store directly, with no premultiply/
  /// un-premultiply round trip (unlike `StickerSource.decodeImage`, which un-premultiplies
  /// because it draws through a `CGContext` — this never does).
  public static func writeReference(_ result: [SIMD4<Float>], size: SIMD2<Int>, to url: URL) throws {
    try FileManager.default.createDirectory(at: url.deletingLastPathComponent(),
                                            withIntermediateDirectories: true)
    var raw = [UInt8](); raw.reserveCapacity(result.count * 4)
    for p in result { raw.append(contentsOf: bytes(p)) }
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue)   // straight alpha
    guard let provider = CGDataProvider(data: Data(raw) as CFData) else {
      throw FeedbaxError.failedToCreateDataProvider
    }
    guard let cgImage = CGImage(width: size.x, height: size.y, bitsPerComponent: 8, bitsPerPixel: 32,
                                bytesPerRow: size.x * 4, space: colorSpace, bitmapInfo: bitmapInfo,
                                provider: provider, decode: nil, shouldInterpolate: false,
                                intent: .defaultIntent) else {
      throw FeedbaxError.failedToCreateCGImage
    }
    guard let destination = CGImageDestinationCreateWithURL(url as CFURL, "public.png" as CFString,
                                                             1, nil) else {
      throw FeedbaxError.failedToCreateImageDestination
    }
    CGImageDestinationAddImage(destination, cgImage, nil)
    guard CGImageDestinationFinalize(destination) else { throw FeedbaxError.failedToWriteImage }
  }

  /// 0...1 float → clamped, rounded 0...255 byte, one channel order (R,G,B,A) — the shared
  /// quantization `writeReference` (encode) and `compare` (decode via `readPNG`, and the
  /// live render) all go through, so nothing here can introduce a rounding mismatch between
  /// the two sides of a comparison.
  private static func bytes(_ p: SIMD4<Float>) -> [UInt8] {
    let c = p.clamped(lowerBound: .zero, upperBound: .one) * 255
    return [UInt8(c.x.rounded()), UInt8(c.y.rounded()), UInt8(c.z.rounded()), UInt8(c.w.rounded())]
  }

  /// Reads a PNG's raw RGBA8 bytes straight off its decoded `CGImage`'s data provider — NOT
  /// via a `CGContext` draw. A `CGContext` can only be backed by premultiplied (or alpha-
  /// free) bitmap layouts, so drawing through one would force a premultiply step this
  /// function has no business paying for (and, at alpha=0, one that's lossy — see
  /// `StickerSource.decodeImage`'s own note on that). PNG itself never stores premultiplied
  /// alpha (there is no such PNG color type), so a straight read of the decoded image's own
  /// bytes is both simpler and exact, for any PNG this codebase writes.
  private static func readPNG(_ url: URL) throws -> (pixels: [SIMD4<Float>], size: SIMD2<Int>) {
    guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
          let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
      throw FeedbaxError.failedToCreateCGImage
    }
    guard cgImage.bitsPerComponent == 8, cgImage.bitsPerPixel == 32,
          let data = cgImage.dataProvider?.data, let base = CFDataGetBytePtr(data) else {
      throw GoldenRunnerError.unreadableReference
    }
    let width = cgImage.width, height = cgImage.height
    let bytesPerRow = cgImage.bytesPerRow
    var pixels = [SIMD4<Float>](repeating: .zero, count: width * height)
    for y in 0..<height {
      let rowStart = y * bytesPerRow
      for x in 0..<width {
        let o = rowStart + x * 4
        pixels[y * width + x] = SIMD4(Float(base[o]) / 255, Float(base[o + 1]) / 255,
                                      Float(base[o + 2]) / 255, Float(base[o + 3]) / 255)
      }
    }
    return (pixels, SIMD2(width, height))
  }
}
