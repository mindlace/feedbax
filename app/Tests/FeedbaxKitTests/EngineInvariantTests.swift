import XCTest
import Foundation
import Metal
import simd
@testable import FeedbaxKit

/// Per-frame readback statistics for one rendered accumulator.
struct FrameLuminance {
  /// Rec. 709 luminance averaged over every pixel.
  let mean: Double
  /// The single brightest pixel's luminance. 1.0 means *fully saturated white* — in an
  /// 8-bit accumulator that is r=g=b=255, i.e. every bit of headroom gone.
  let maxLum: Double
  /// Fraction of pixels at (or within 1/255 of) full white.
  let whiteFraction: Double
  /// Population variance of per-pixel luminance — the spread measure that distinguishes a
  /// picture from a flat field. Exactly zero for any uniform frame, white or black.
  let variance: Double

  init(pixels: [SIMD4<Float>]) {
    var sum = 0.0, sumSq = 0.0, peak = 0.0, white = 0
    for p in pixels {
      let lum = Double(0.2126 * p.x + 0.7152 * p.y + 0.0722 * p.z)
      sum += lum
      sumSq += lum * lum
      peak = max(peak, lum)
      if p.x >= 0.99 && p.y >= 0.99 && p.z >= 0.99 { white += 1 }
    }
    let n = Double(pixels.count)
    self.mean = sum / n
    self.maxLum = peak
    self.whiteFraction = Double(white) / n
    self.variance = max(0, sumSq / n - (sum / n) * (sum / n))
  }
}

/// Invariant tests for the feedback loop — the properties that must hold on EVERY run,
/// stated without reference to any blessed image.
///
/// # Why this file exists
///
/// The port shipped a launch-time wash to solid white with 98 green tests. Three bugs
/// stacked up, all fixed as of this file's creation:
///
/// 1. `maxScale` implemented Max's *modern* (`@classic 0`) formula instead of the default
///    classic mode, inflating every HSL per-frame delta by 2–73×.
/// 2. `ControlRouter.startupVector` used the webui's `loadbang` list, which the real patch
///    supersedes 137 ms after load. Under that list `bias` maps to a **positive** lightness
///    delta — a feedback integrator that gains energy every frame, forever.
/// 3. The HSL ramps cold-started from the shader-side `param` defaults (0.5 lightness as a
///    per-frame delta — 50× the largest value the bias map can produce), giving a 6-frame
///    all-white overshoot at every launch.
///
/// None of it was caught, because the suite's correctness rested on golden PNGs that had
/// been re-blessed from the port's own broken output, and on frame counts and hand-tuned
/// constants chosen to stop short of (or null out) the drift. A snapshot that can be
/// re-blessed asserts nothing. These tests assert *properties* instead: no amount of
/// regenerating files can satisfy them.
///
/// # Read this before loosening a threshold
///
/// Every assertion below is one the real bug violated. If one fails, the loop has changed
/// character — it is gaining energy, collapsing, or flattening into a solid field. Widening
/// a tolerance to make it pass reproduces precisely the process that let the whiteout ship.
/// Fix the loop, or delete the test with an explicit written argument for why the property
/// genuinely no longer holds. Do not nudge the number.
final class EngineInvariantTests: XCTestCase {
  /// The golden tests' canvas (design §9: "small canvases (192×108) keep references tiny").
  /// Readback cost is what bounds these tests, and 20 736 pixels is plenty of spatial
  /// signal for a variance floor.
  private static let size = SIMD2<Int>(192, 108)

  /// 600 frames = 10 s at 60 Hz. The historical whiteout was total inside ~90 frames, but a
  /// slow-integrating variant of the same bug (a lightness delta only slightly positive)
  /// needs a long run to show, so the invariant run is deliberately far longer than the
  /// failure it was written for. Measured cost of the whole run: ~1.9 s.
  private static let frameCount = 600

  // MARK: - The shared startup run

  /// One real-startup trajectory, rendered once and shared by the four tests that assert
  /// different properties of it (no reason to pay the GPU cost four times).
  ///
  /// Built exactly the way `AppBootstrap.start()` assembles the instrument — `MetalContext()`
  /// → `Engine(context:)` → `router.applyStartupDefaults(at: 0)` — and stepped at a fixed
  /// 1/60 s. `at: 0`, **not** the golden harness's settled `at: -1`: bug 3 (the cold-start
  /// ramp overshoot) exists only at `at: 0`, and a harness that applies the vector a second
  /// early cannot see it. That difference is exactly how the golden suite stayed green.
  private static let startupRun: [FrameLuminance] = {
    do { return try renderStartupRun() } catch { fatalError("startup run failed: \(error)") }
  }()

  private static func renderStartupRun() throws -> [FrameLuminance] {
    let context = try MetalContext()
    let engine = try Engine(context: context)
    engine.router.applyStartupDefaults(at: 0)
    engine.setResolution(size)

    var stats: [FrameLuminance] = []
    stats.reserveCapacity(frameCount)
    for i in 0..<frameCount {
      let commandBuffer = context.queue.makeCommandBuffer()!
      let texture = engine.step(at: Double(i) / 60, commandBuffer: commandBuffer)
      commandBuffer.commit()
      commandBuffer.waitUntilCompleted()
      context.pool.endFrame()
      stats.append(FrameLuminance(pixels: context.readPixels(texture)))
    }
    return stats
  }

  // MARK: - 1. No frame ever whites out

  /// **Guards: the whiteout itself.** Under the old `maxScale`/`startupVector`/ramp seeds
  /// the accumulator integrated to r=g=b=255 across the WHOLE canvas within ~90 frames, and
  /// frames 3–6 were 100 % white from the ramp overshoot alone. That is the property this
  /// test pins: the frame as a whole never runs out of headroom.
  ///
  /// This used to assert that no single pixel ever clips. That per-pixel property is not a
  /// property of the instrument (written argument, per this file's header): the parity seed
  /// set draws wave 2's ring at load, centred, and under the startup zoom (0.7) every
  /// generation of that ring lands closer to the centre than the last, so the centre pixels
  /// receive every surviving generation additively and saturate — Max's render window shows
  /// the same white convergence point and 4.5 % clipped pixels at the owner's settings
  /// (docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md; the whiteout write-up's
  /// own reframing: clipping is the instrument's bounded nonlinearity, and "never clips
  /// while a seed is permanently drawn" is deliberately not asserted). Measured on the parity
  /// loop: 0.09 % of pixels clipped by frame 575, none before frame 574.
  ///
  /// Threshold: `whiteFraction` below 1 % on every frame. The bug's signature is 100 %; a
  /// convergence point on a 192×108 canvas is a few dozen pixels (< 0.3 %). Not fitted —
  /// two orders of magnitude separate the two.
  func testNoFrameEverWhitesOut() throws {
    let run = Self.startupRun
    for (i, s) in run.enumerated() {
      XCTAssertLessThan(s.whiteFraction, 0.01,
        "frame \(i): \(String(format: "%.4f%%", s.whiteFraction * 100)) of pixels are fully " +
        "saturated white. The feedback loop is running out of headroom across the frame " +
        "(this is the launch whiteout). mean=\(s.mean), maxLum=\(s.maxLum)")
    }
  }

  // MARK: - 2. Bounded, not integrating

  /// **Guards: an integrator that never settles.** Under the bug the mean climbed
  /// monotonically at ~0.01 per frame until it hit the clip ceiling. A correct loop's mean
  /// stays bounded: the negative `bias` lightness delta retires every generation of content
  /// after ~66 frames at the startup vector, so nothing can integrate without limit.
  ///
  /// This used to assert frame-to-frame stationarity below 1e-5 from the halfway point —
  /// measured under bilinear resampling, which blurred every generation away within ~15
  /// frames and left a dead-still fixed point by frame 240. The parity loop reads the
  /// nearest texel (diagnosis doc, term 1): generations survive until the lightness term
  /// retires them, each lands on a slightly different pixel set as it rotates, and the mean
  /// keeps creeping (measured +4.7e-5 per frame over frames 300–600) while the content keeps
  /// evolving — which the original does too ("takes much longer to settle" is one of the
  /// owner's reports). Stationarity to 1e-5 is therefore not a property of the instrument;
  /// boundedness is (written argument, per this file's header).
  ///
  /// Threshold: the mean over the last 100 frames may exceed the mean over frames 300–400 by
  /// at most 0.05. The bug moves 0.05 in five frames; the parity loop's measured drift moves
  /// it ~0.01 over that span. Not fitted — an order of magnitude each way.
  func testMeanLuminanceIsBoundedNotIntegrating() throws {
    let run = Self.startupRun
    func windowMean(_ range: Range<Int>) -> Double {
      range.reduce(0.0) { $0 + run[$1].mean } / Double(range.count)
    }
    let early = windowMean(300..<400)
    let late = windowMean((run.count - 100)..<run.count)
    XCTAssertLessThan(late - early, 0.05,
      "mean luminance rose from \(early) (frames 300–400) to \(late) (last 100 frames) — the " +
      "loop is integrating toward the white rail rather than holding a bounded steady state")

    // A degenerate collapse (all black) or a saturated rail (all white) is also perfectly
    // "bounded", so pin the steady state into a plausible open interval. The bounds are
    // deliberately loose — they only exclude the two rails.
    let equilibrium = run[run.count - 1].mean
    XCTAssertGreaterThan(equilibrium, 0.02,
      "settled at mean luminance \(equilibrium) — the loop has collapsed to (near) black")
    XCTAssertLessThan(equilibrium, 0.98,
      "settled at mean luminance \(equilibrium) — the loop has pinned at (near) white")
  }

  // MARK: - 3. Bounded

  /// **Guards: both rails, on every frame — including the transient.** Invariant 2 only
  /// compares two late windows; bug 3's 6-frame all-white overshoot happened at frames 3–6
  /// and was gone by frame 10, so a tail-only test sails straight past it. This one checks
  /// every single frame from the very first.
  ///
  /// Thresholds: none to tune. Mean luminance must be strictly inside (0, 1). 0 means the
  /// canvas is literally black everywhere; 1 means it is literally white everywhere.
  func testMeanLuminanceStaysStrictlyBetweenBlackAndWhite() throws {
    for (i, s) in Self.startupRun.enumerated() {
      XCTAssertGreaterThan(s.mean, 0,
        "frame \(i): mean luminance is \(s.mean) — the canvas has collapsed to black")
      XCTAssertLessThan(s.mean, 1,
        "frame \(i): mean luminance is \(s.mean) — the canvas has washed out to white")
    }
  }

  // MARK: - 4. Restoring-term sign

  /// **Guards: the original bug, outright, in microseconds.** `bias` is the loop's restoring
  /// term: `lightDelta` is added to the warped past's lightness every frame, so its sign
  /// decides whether the feedback integrator decays or runs away. At the real
  /// `startupVector` value (raw 0.0) the classic-mode map gives −0.01 — negative, a decay.
  /// Under the discarded `loadbang` vector (raw 0.392857) the same map gives **+0.0018**,
  /// and under the old modern-mode `maxScale` it was larger still. Either way, positive: a
  /// loop that gains energy every frame until it clips.
  ///
  /// `MaxScaleTests` only ever checked the loadbang raw values — i.e. it pinned the map's
  /// arithmetic while asserting nothing whatsoever about the vector the instrument actually
  /// runs on. This is that missing assertion. It renders no pixels and needs no GPU.
  func testBiasMapsToANonPositiveLightnessDeltaAtTheRealStartupVector() throws {
    let biasRaw = ControlRouter.startupVector[ControlSlot.bias.rawValue]
    let lightDelta = ControlRouter.mappedTarget(for: .bias, raw: biasRaw, sInvert: 1)
    XCTAssertLessThanOrEqual(lightDelta, 0,
      "bias raw \(biasRaw) maps to lightDelta \(lightDelta) — POSITIVE. This is the " +
      "restoring term of the feedback loop; a positive per-frame lightness delta means the " +
      "accumulator integrates to white. This is the launch-whiteout bug.")

    // Saturation's slot is the same kind of check for the other axis that can bloom. The
    // startup raw is 0.5, the exact midpoint of the map's 0...1 domain onto -0.05...0.05, so
    // saturation must come out perfectly neutral — it neither bleaches nor over-saturates
    // the loop. A non-zero value here means either the vector or the map has moved, and a
    // POSITIVE one is a saturation runaway of the same family as the lightness one.
    // Tolerance is float rounding on a linear map, not slack: the exact answer is 0.
    let satRaw = ControlRouter.startupVector[ControlSlot.saturation.rawValue]
    let satDelta = ControlRouter.mappedTarget(for: .saturation, raw: satRaw, sInvert: 1)
    XCTAssertEqual(satDelta, 0, accuracy: 1e-7,
      "saturation raw \(satRaw) maps to satDelta \(satDelta), expected exactly 0 (the " +
      "midpoint of 0...1 mapped onto -0.05...0.05). Saturation is not neutral at startup.")
  }

  // MARK: - 5. Ramps never overshoot

  /// **Guards: bug 3, at the control layer, without rendering a pixel.** A `LinearRamp` is
  /// an interpolation between two endpoints; it has no business ever leaving the interval
  /// they span. The whiteout's third cause was a ramp *seeded* outside that interval (the
  /// shader-side `param` defaults, 0.5 where the map's outputs live at ±0.05), which made
  /// the ramp's early portion a 50×-too-large delta. This test states the property the ramp
  /// itself must have; `testStartupRampsStayInsideTheirMapOutputRange` below states the one
  /// the seeding must have.
  ///
  /// Thresholds: 1e-6 absolute, which is float32 rounding on a lerp of values of order 1.
  /// It is not slack for "a little" overshoot — there is no acceptable amount.
  func testLinearRampNeverLeavesTheIntervalBetweenItsEndpoints() throws {
    let cases: [(start: Float, target: Float)] = [
      (0, 1), (1, 0), (-0.05, 0.05), (0.05, -0.05), (0, -0.01), (0.5, 0.5), (-2000, 2000),
    ]
    for (start, target) in cases {
      var ramp = LinearRamp(initial: start)
      ramp.setTarget(target, at: 0)
      let lo = min(start, target), hi = max(start, target)
      let magnitude = max(abs(start), abs(target))
      // Sample the whole glide at 1 ms and 40 ms past its 100 ms end, so both the ramp's
      // interior and its settled tail are covered.
      for stepMs in 0...140 {
        let value = ramp.value(at: Double(stepMs) / 1000)
        XCTAssertGreaterThanOrEqual(value, lo - 1e-6,
          "ramp \(start)->\(target) read \(value) at \(stepMs) ms — BELOW its interval [\(lo), \(hi)]")
        XCTAssertLessThanOrEqual(value, hi + 1e-6,
          "ramp \(start)->\(target) read \(value) at \(stepMs) ms — ABOVE its interval [\(lo), \(hi)]")
        XCTAssertLessThanOrEqual(abs(value), magnitude + 1e-6,
          "ramp \(start)->\(target) read \(value) at \(stepMs) ms — magnitude exceeds " +
          "max(|start|, |target|) = \(magnitude)")
      }
    }
  }

  /// **Guards: bug 3 exactly as it happened.** The three HSL ramps are seeded at their
  /// mapped startup values, so every value they can ever produce during a cold start must
  /// lie inside the *map's own output range* — the `scale` ranges taken verbatim from the
  /// patch (spec §01 §4), not numbers chosen here. The old seeding produced ~+0.28
  /// lightness/frame against a bias range whose ceiling is +0.02: a 14× violation, and a
  /// visible white flash at every launch.
  ///
  /// Sampling covers the first 60 frames (the glide is 100 ms ≈ 6 frames; 60 gives a wide
  /// margin) at the real `at: 0` cold start. The 1e-6 tolerance is float32 rounding on the
  /// map's own arithmetic.
  func testStartupRampsStayInsideTheirMapOutputRange() throws {
    let router = ControlRouter()
    router.applyStartupDefaults(at: 0)
    // Verbatim from the patch's `scale` objects (see `ControlRouter.mappedTarget`).
    let hueRange: ClosedRange<Float> = -0.05...0.05
    let satRange: ClosedRange<Float> = -0.05...0.05
    let biasRange: ClosedRange<Float> = -0.04...0.02

    for i in 0..<60 {
      let p = router.tick(at: Double(i) / 60)
      func check(_ value: Float, _ range: ClosedRange<Float>, _ name: String) {
        XCTAssertTrue(value >= range.lowerBound - 1e-6 && value <= range.upperBound + 1e-6,
          "frame \(i): \(name) = \(value), outside its map's output range " +
          "\(range.lowerBound)...\(range.upperBound). A ramp seeded or retargeted outside " +
          "the map's range is the cold-start overshoot that flashed the canvas white.")
      }
      check(p.hueShift, hueRange, "hueShift")
      check(p.satDelta, satRange, "satDelta")
      check(p.lightDelta, biasRange, "lightDelta")
    }
  }

  // MARK: - 6. Non-degeneracy

  /// **Guards: the thing a snapshot was actually for.** A golden PNG's real job was "the
  /// frame looks like a picture." Its fatal weakness was that it could be re-blessed from
  /// broken output — and it was, from solid white. Per-pixel luminance variance catches the
  /// same class of failure (solid white *and* solid black are both variance 0) while
  /// blessing no particular image, so there is nothing to regenerate.
  ///
  /// Threshold: variance > 1e-3, i.e. a luminance standard deviation of ~0.03 — roughly 8
  /// of 255 levels of spread. Chosen as an order-of-magnitude "is there anything there"
  /// floor, not fitted: the measured minimum across the whole run is 0.0040 (frame 0, when
  /// the canvas is still mostly empty) and the settled value is 0.0093, so the real margin
  /// is 4–9×. If a future change legitimately renders a much flatter frame, that is a
  /// change to what the instrument *is*, and it deserves the failure and a conversation.
  func testFrameIsNeverAFlatField() throws {
    let floor = 1e-3
    for (i, s) in Self.startupRun.enumerated() {
      XCTAssertGreaterThan(s.variance, floor,
        "frame \(i): per-pixel luminance variance \(s.variance) is below \(floor) — the " +
        "frame is a flat field, not an image (mean=\(s.mean), maxLum=\(s.maxLum)). A mean " +
        "near 1 means solid white; near 0, solid black.")
    }
  }

  // MARK: - 7. No energy gain without input

  /// **Guards: the integrator that `FeedbackCoreTests` cuts out.**
  /// `testEraseResidualIsOneMinusAlphaPerFrame` proves decay with
  /// `feedbackPlaneEnabled = false` — that is, with the feedback plane removed from the
  /// loop. The bug lived *in* that plane's contribution. With the plane on and no fresh
  /// content, the loop must not manufacture energy.
  ///
  /// # Why this formulation, and what it deliberately excludes
  ///
  /// "Total energy must not increase" is NOT true of the full loop as shipped, and asserting
  /// it there would be wrong rather than strict: the warp is a spatial transform, and a zoom
  /// that magnifies a bright region genuinely raises mean luminance for a while without any
  /// energy being created — it is transport, not gain. (The startup vector's zoom is 0.7,
  /// so the real loop does exactly this.) A test that forbade it would fail on correct code
  /// and get "fixed" by loosening, which is the failure mode this whole file exists to
  /// prevent.
  ///
  /// So the geometry is pinned to identity (zoom 1, theta 0, no offset) while the HSL and
  /// erase parameters are taken **unmodified from the real router at its settled startup
  /// state**. With no spatial transport left, every remaining per-frame operation is
  /// pointwise, and the question becomes exactly the one that matters: does one trip through
  /// erase → warp-HSL → feedback-plane composite return more light than it took in? For the
  /// real parameters (`lightDelta` −0.01, `satDelta` 0, `eraseAlpha` 1.0) the answer must be
  /// no. Under the old `startupVector`, `lightDelta` was positive and the answer was yes,
  /// on every frame, forever.
  ///
  /// A mid-gray seed is drawn on frame 0 only; every later frame draws nothing, so the only
  /// thing in the loop is the loop's own past. The 1/255 tolerance is one 8-bit
  /// quantization step of the accumulator — the smallest difference it can represent — not
  /// a drift budget.
  func testFeedbackPlaneDoesNotGainEnergyWithoutInput() throws {
    let context = try MetalContext()
    let core = try FeedbackCore(context: context, size: SIMD2(64, 64))
    core.feedbackPlaneEnabled = true   // the state the real instrument runs in

    // Real settled startup params (`at: -1` so the ramps have arrived), geometry neutralised.
    let router = ControlRouter()
    router.applyStartupDefaults(at: -1)
    var params = router.tick(at: 0)
    params.zoom = 1
    params.theta = 0
    params.offsetPx = .zero
    XCTAssertLessThanOrEqual(params.lightDelta, 0, "precondition: restoring term must decay")

    func step(index: Int, seed: Bool) -> FrameLuminance {
      let cb = context.queue.makeCommandBuffer()!
      let frame = FrameContext(index: index, time: Double(index) / 60, delta: 1.0 / 60,
                               canvasSize: SIMD2(64, 64), commandBuffer: cb, pool: context.pool)
      let out = core.renderFrame(frame, params: params) { enc in
        if seed { core.drawSolid(enc, color: SIMD4(0.5, 0.5, 0.5, 1)) }
      }
      cb.commit(); cb.waitUntilCompleted(); context.pool.endFrame()
      return FrameLuminance(pixels: context.readPixels(out))
    }

    var previous = step(index: 0, seed: true)
    // Non-vacuity: if the seed never landed, "energy did not increase" would be trivially
    // true of an all-black canvas and this test would assert nothing.
    XCTAssertGreaterThan(previous.mean, 0.1,
      "seed frame mean luminance \(previous.mean) — the seed did not land, so the rest of " +
      "this test would be vacuous")

    for i in 1..<120 {
      let current = step(index: i, seed: false)
      XCTAssertLessThanOrEqual(current.mean, previous.mean + 1.0 / 255,
        "frame \(i): mean luminance rose from \(previous.mean) to \(current.mean) with the " +
        "feedback plane ON, identity geometry and NO fresh content. The loop is " +
        "manufacturing energy — with nothing to transport and nothing to draw, the only " +
        "source is the per-frame HSL delta. lightDelta=\(params.lightDelta), " +
        "eraseAlpha=\(params.eraseAlpha)")
      previous = current
    }
    // And it must actually have gone somewhere — a loop frozen at its seed value would pass
    // the non-increase check while proving nothing about decay.
    XCTAssertLessThan(previous.mean, 0.1,
      "after 120 frames with no input the canvas still reads \(previous.mean) — the loop is " +
      "not decaying at all")
  }
}
