import XCTest
import Foundation
import simd
@testable import FeedbaxKit

/// Resolves a golden-reference PNG's URL. `Bundle.module`'s resources are copied into a
/// read-only build-products bundle — fine for a normal (non-regen) `compare` read, useless
/// for `FEEDBAX_REGEN_GOLDEN`'s write path, whose output has to land somewhere `git add app`
/// will actually find, and survive the NEXT `swift build` re-syncing `Bundle.module`'s copy
/// from source rather than the other way around. `fallbackToSourceTree: true` sidesteps that
/// entirely: it ignores `Bundle.module` and resolves straight to THIS file's own directory
/// (`#filePath`, captured at this declaration site) — `GoldenFrameTests.swift` lives in
/// `Tests/FeedbaxKitTests/`, the same directory `GoldenReferences/` sits in, so the answer is
/// identical (and correct) for both the read and write call sites in
/// `testAllScenariosMatchReferences` below.
extension Bundle {
  func url(forResource name: String, withExtension ext: String?,
          fallbackToSourceTree: Bool) -> URL? {
    guard fallbackToSourceTree else { return url(forResource: name, withExtension: ext) }
    let sourceDir = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    var candidate = sourceDir.appendingPathComponent(name)
    if let ext { candidate.appendPathExtension(ext) }
    return candidate
  }
}

/// The parity scenarios (design §9) — one `Scenario` per look this port renders through a
/// materially different path (positive-zoom fold, SInvert's point-mirror, a hue-heavy run).
/// Each attaches a short doc comment citing the fidelity-checklist item(s) (design §6) it
/// exists to pin, same convention as `WarpParityTests`/`FilterTests`.
///
/// Read `GoldenFrameTests`' own header before touching any frame count or slot value here:
/// these scenarios feed CHANGE DETECTORS, not correctness oracles, and their parameters were
/// once quietly bent around a real bug.
enum Scenarios {
  /// design §9: "small canvases (192×108) keep references tiny."
  static let canvasSize = SIMD2<Int>(192, 108)

  static var glyphURL: URL {
    Bundle.module.url(forResource: "Fixtures/glyph", withExtension: "png")!
  }
  static var sweepURL: URL {
    Bundle.module.url(forResource: "Fixtures/sweep", withExtension: "mov")!
  }

  /// Every scenario below starts from `ControlRouter.startupVector` (spec §04 §1.1 — the
  /// same cold-start every live session actually begins from, per `EngineTests`' own
  /// convention) and overrides only the slots/toggles it cares about, rather than each
  /// scenario hand-rolling all 9 slots. `layers: []`: no scenario here needs a `PresetLayer`
  /// entry — `sourceSelection`/`filters` restore is a no-op with an empty list, and the
  /// sticker defaults (`StickerSource`'s auto-selected index 0, `LayerTransform()`'s identity
  /// placement) are already what every scenario wants.
  ///
  /// **There is no `bias`/`saturation` override parameter, deliberately.** There used to be,
  /// with two `noDrift*` constants passed by the three long scenarios to null the HSL
  /// integrator out. Those constants were originally hand-tuned against the OLD, broken
  /// modern-mode `maxScale`, under which the startup vector's own bias mapped to a persistent
  /// POSITIVE per-frame lightness delta — a monotonic integrator with nothing pulling it
  /// back. Every multi-second scenario had to opt out of the real startup vector to stay
  /// legible, which is precisely how the broken mapping stayed invisible for months. Under
  /// the corrected classic-mode map the startup vector maps `bias` raw 0.0 to **-0.01**/frame
  /// (negative — the restoring term) and `saturation` raw 0.5 to **exactly 0**/frame, so
  /// these scenarios now run on the real cold-start HSL values and a future regression in
  /// that mapping shows up here instead of being pinned away. If a scenario ever seems to
  /// need an HSL crutch again, that is a finding about the engine, not a parameter to add
  /// back.
  static func preset(name: String, zoom: Float? = nil, theta: Float? = nil, hue: Float? = nil,
                     erase: Float, layerMode: LayerMode = .sticker,
                     layerEnabled: Bool = false) -> Preset {
    var slots = ControlRouter.startupVector
    if let zoom { slots[ControlSlot.zoom.rawValue] = zoom }
    if let theta { slots[ControlSlot.theta.rawValue] = theta }
    if let hue { slots[ControlSlot.hue.rawValue] = hue }
    let toggles = PresetToggles(worldBump: false, waveBump: false, kittyBump: false,
                                wave1: true, wave2: false, layerEnabled: layerEnabled)
    return Preset(name: name, slots: slots, eraseControl: erase, toggles: toggles, layers: [],
                 layerMode: layerMode.presetIdentifier)
  }

  /// `MovieSource` plays on `AVPlayer`'s own real (host) clock (design §5's load-bearing
  /// rule) — nothing pumps a display-link run loop in this headless harness, so without
  /// priming, `movie.tick()` could return nil for a scenario's ENTIRE run (the player never
  /// gets a chance to decode a first frame between back-to-back `step` calls).
  ///
  /// **A poll-then-stop-playing loop is required, not just poll-then-stop-polling** — found
  /// the hard way, empirically, chasing a self-consistency flake (Task 22's process
  /// requirement: two `swift test` runs must produce identical verdicts). The frame `tick`
  /// hands back is `output.itemTime(forHostTime:)`-mapped — a function of how much WALL-CLOCK
  /// time has elapsed since `load(url:)` called `play()` — which keeps advancing for as long
  /// as the player keeps running, `RunLoop` yields or not. A first version of this helper
  /// polled until the first non-nil `tick()` and stopped POLLING there, but the player kept
  /// PLAYING underneath — so by the time `GoldenRunner`'s own capture `step()` ran (however
  /// many more microseconds/milliseconds after that, itself not reproducible run to run), it
  /// could land on a different sweep frame, and — with a ~12 s `AVPlayerLooper` loop period —
  /// occasionally on a completely different lap. Two consecutive verify runs reproduced
  /// exactly that: an identical, large `keyers-on-movie` pixel-mismatch percentage both
  /// times, i.e. a real bimodal timing split, not sampling noise.
  ///
  /// `MovieSource.pause()` (added for this) is what actually fixes it: the moment this loop
  /// sees a real frame, it pauses the player right there (`rate = 0`), which freezes the
  /// host-time→item-time mapping — every subsequent `tick`, no matter how much LATER it's
  /// called, keeps returning that same cached texture (the documented repeat-frame fallback),
  /// so the golden capture is pinned to "whichever fixture frame happened to be current the
  /// instant priming succeeded." Some run-to-run variance in exactly WHICH early frame that
  /// is still exists (readiness timing isn't instant) — which is also why `sweep.mov`'s red
  /// sweep is deliberately narrowed to 20...90, not the full 0...255 (see
  /// `TestSupport/FixtureGenerators.swift`'s `writeFixtureMovie` doc for how it was
  /// generated): `LumaKeyFilter`'s low-pass keys out luminance below a hard threshold, so a
  /// wide sweep straddling that threshold turned "which early frame" into a BINARY
  /// difference (keyed out or not) even after pausing fixed everything else. A narrow range
  /// that never crosses either keyer's threshold makes neighboring frames land on the same
  /// side of it regardless.
  static func primeMovie(_ engine: Engine, deadline: TimeInterval = 5) {
    let end = Date().addingTimeInterval(deadline)
    while Date() < end {
      let cb = engine.context.queue.makeCommandBuffer()!
      let frame = FrameContext(index: 0, time: 0, delta: 1.0 / 60, canvasSize: engine.resolution,
                               commandBuffer: cb, pool: engine.context.pool)
      if engine.movie.tick(frame) != nil {
        engine.movie.pause()
        return
      }
      RunLoop.current.run(until: Date().addingTimeInterval(0.05))
    }
  }

  /// 1. Sticker layer on the committed 32×32 glyph fixture (loaded via `GoldenFrameTests`'
  /// CWD setup, see its `setUpWithError`), zoom 0.9 / theta 0.2 / erase 0.55 raw, 120 frames
  /// — long enough for the fold-warp's repeated application to build the signature spiral
  /// (design §9's "golden-frame tests" example scenario). HSL runs on the real startup
  /// vector's values (see `preset`'s own doc for why there is no longer a no-drift pin).
  static var rotaSpiral: Scenario {
    Scenario(name: "rota-spiral",
            preset: preset(name: "rota-spiral", zoom: 0.9, theta: 0.2, erase: 0.55,
                          layerMode: .sticker, layerEnabled: true),
            frames: 120, size: canvasSize)
  }

  /// 2. Identical to `rotaSpiral` up to frame 60, where the control timeline flips SInvert —
  /// checklist #7: "negates zoom + offsets → point-mirror kaleidoscope; first-class toggle."
  /// 120 frames, i.e. the same length as `rotaSpiral`, so the pair differ ONLY in the toggle:
  /// 60 frames of shared spiral build-up, then 60 frames of mirrored evolution.
  ///
  /// This scenario was once cut to 64 frames, on the reasoning that negated zoom "does not
  /// converge" and that frame 69 was already solid white. That whiteout was the broken
  /// `maxScale` mapping, not a property of SInvert — shortening the run hid the bug rather
  /// than reporting it. The length here is chosen for what the scenario needs to show; if it
  /// ever seems to need shortening again, investigate the engine first.
  static var sinvertKaleidoscope: Scenario {
    Scenario(name: "sinvert-kaleidoscope",
            preset: preset(name: "sinvert-kaleidoscope", zoom: 0.9, theta: 0.2, erase: 0.55,
                          layerMode: .sticker, layerEnabled: true),
            timeline: [(frame: 60, write: ControlWrite(toggles: [.sInvert(true)]))],
            frames: 120, size: canvasSize)
  }

  /// 3. Hue slot pinned at 1.0 raw (the mapped ramp's extreme) for 180 frames against the
  /// same glyph/zoom/theta/erase setup as `rotaSpiral` — checklist #5: "HSL shift is
  /// additive in HSL space; hue wraps." A colorless (no seed layer) run would never visibly
  /// demonstrate a hue WRAP — a fully desaturated pixel renders the same regardless of its
  /// hue channel — so this scenario needs real chroma feeding the warp loop.
  ///
  /// `zoom`/`theta` are `rotaSpiral`'s own values rather than the startup vector's: under
  /// `rotaSpiral`'s fold the pattern settles spatially, so what this reference shows is the
  /// hue endpoint's effect on a settled geometry rather than on a geometry still churning. A
  /// single final-frame PNG can't show hue CYCLING over time regardless — that is `HSLTests`'
  /// job for the wrap arithmetic and the invariant tests' job for the loop's behaviour over
  /// time; this pins the look at one hue extreme.
  static var hslDrift: Scenario {
    Scenario(name: "hsl-drift",
            preset: preset(name: "hsl-drift", zoom: 0.9, theta: 0.2, hue: 1.0, erase: 0.55,
                          layerMode: .sticker, layerEnabled: true),
            frames: 180, size: canvasSize)
  }
}

/// # These are CHANGE DETECTORS, not correctness oracles.
///
/// Every reference PNG in `GoldenReferences/` was blessed from THIS PORT'S OWN OUTPUT. None
/// of them was rendered by the original Max/Jitter patch, measured against it, or verified
/// against anything outside this repository. A green run here means exactly one thing: *the
/// image this port produces today is the image it produced when the reference was written.*
/// It does not mean the image is right.
///
/// So when a scenario goes red, the correct response is **look at the image and decide** —
/// open the rendered frame next to the reference and ask whether the change is the one you
/// intended. It is never "regenerate until green." Regeneration (`FEEDBAX_REGEN_GOLDEN=1`,
/// which writes into the SOURCE TREE via the
/// `Bundle.url(forResource:withExtension:fallbackToSourceTree:)` helper above) is the last
/// step of a deliberate decision, not a way to make a failure go away.
///
/// ## Why this warning exists
///
/// The previous generation of these references froze a real bug in place for months. The
/// port's `maxScale` was evaluating Max's `scale` in *modern* mode where the patch uses the
/// default *classic* mode, which flipped the sign of the startup vector's per-frame lightness
/// delta: instead of the restoring **-0.01**/frame the real mapping produces, the loop
/// integrated a persistent POSITIVE delta and washed every long run to solid white. The
/// golden suite never reported it. Instead the suite was progressively re-parameterized
/// AROUND it — its own comments recorded the retreat, step by step:
///
///   - `identity-accumulation` was held to 10 frames, "deliberately short enough that the
///     startup vector's own drift hasn't yet washed the frame to white";
///   - `sinvert-kaleidoscope` was cut from 120 frames to 64 because "frame 69 was already
///     solid white";
///   - `hsl-drift` borrowed another scenario's geometry because the startup zoom was
///     "saturating to solid white by frame ~10";
///   - three scenarios pinned `bias`/`saturation` to hand-tuned `noDrift*` constants that
///     nulled the HSL integrator entirely.
///
/// Each of those edits was locally reasonable and made the suite green. Collectively they
/// turned a loud, reproducible engine defect into a set of test parameters, and every
/// subsequent regeneration re-blessed the broken output as the standard. That is the specific
/// failure mode this header exists to prevent: a snapshot suite will happily encode any bug
/// you regenerate it against, and will then defend that bug against every future fix.
///
/// **A scenario that has to be shortened, pinned, or re-parameterized to stay legible is
/// reporting a finding about the engine. Chase the finding; do not tune the scenario.**
///
/// ## Where correctness actually lives
///
///   - `EngineInvariantTests` — the behavioural invariants of the feedback loop (drift sign,
///     boundedness, clipping, convergence) asserted as numbers, on the real startup vector,
///     with no image in the loop.
///   - `WarpParityTests`, `MaxScaleTests`, `HSLTests`, `RotaFoldTests`, `BrcosaTests`,
///     `KeyerTests`, `FilterTests`, `WaveformTests`, `AudioAnalysisTests` — the differential
///     parity tests, which check this port's math against the mapping the patch actually
///     implements.
///   - `EngineWiringTests` — the boolean wiring facts (which filter chain runs on which
///     layer, which gates modulate the frame) that used to be inferred from 1-frame PNGs.
///
/// These scenarios add one thing on top of that: an unplanned-visual-change alarm across the
/// whole pipeline at once. That is genuinely useful, and it is all this is.
///
/// ## BLOCKED — there are currently NO committed references, on purpose
///
/// `GoldenReferences/` is empty and this test therefore fails, deliberately. When the three
/// scenarios below were re-expressed on the real startup vector (dropping the `noDrift*`
/// pins) and regenerated, all three came out **solid white**: 192×108 of pure #FFFFFFFF,
/// meanLum 1.0000, variance 0.000000, one unique RGBA value in the whole image. That is not a
/// reference; that is the bug reappearing, and the rule above ("look at the image and decide")
/// says do not bless it.
///
/// The saturation is NOT the HSL mapping this port fixed. Measured frame by frame on the
/// `rota-spiral` configuration (192×108, sticker layer on, erase raw 0.55, zoom 0.9,
/// theta 0.2), the whole canvas reaches meanLum ≈ 1.0 with 100% of pixels clipped white by
/// **frame 10**, and it does so under every HSL setting tried:
///
///   - real startup HSL (`bias` raw 0 → lightDelta −0.01/frame): 100% white by frame 10
///   - the retired no-drift pins (lightDelta exactly 0): 100% white by frame 9
///   - hue raw 0 (hueShift ≈ 0): 100% white by frame 10
///   - `bias` raw −1, i.e. the MAXIMUM restoring lightness the map can produce
///     (−0.04/frame): still meanLum 0.9996 with 80.8% of pixels clipped, from frame 10 on
///
/// and under every geometry/erase variation tried (erase raw 1.0 full-clear: meanLum 0.9916;
/// the startup vector's own minifying zoom: 0.9874; pan raw 0.2/0.2 carrying content
/// off-screen: 0.9575). `DriftMeasurement` shows the same thing for the plain cold start with
/// no seed layer at all: 100% clipped white by frame 300. In other words the feedback
/// composite gains far more brightness per frame than any per-frame lightness decay the
/// control map can remove — a defect in the loop's gain (the additive `(srcα,dstα)`
/// past-plane composite and its interaction with the erase base's alpha), not in the control
/// mapping.
///
/// Until that is fixed there is nothing here worth pinning: a reference of a white square
/// detects no change that matters, and committing one would re-enact exactly the history
/// described above. Regenerate — and re-read this section — once the loop stays bounded.
final class GoldenFrameTests: XCTestCase {
  static let scenarios: [Scenario] = [
    Scenarios.rotaSpiral, Scenarios.sinvertKaleidoscope, Scenarios.hslDrift,
  ]

  private var originalCwd: String!
  private var tempRoot: URL!

  /// `Engine.init` resolves its sticker folder against the process's CURRENT WORKING
  /// DIRECTORY (that init's own doc comment — same trick
  /// `EngineTests.testPresetRoundTripsLayerModeBumpsAndSourceSelection` uses), so the sticker
  /// scenarios (`rotaSpiral`/`sinvertKaleidoscope`/`hslDrift`) need a real
  /// `input/transparent-background/` folder holding the committed glyph fixture, in place
  /// BEFORE `GoldenRunner.render` constructs each scenario's `Engine`. Done once here rather
  /// than per-scenario `configure`, since `StickerSource`'s constructor itself scans and
  /// auto-selects index 0 — nothing left for `configure` to do once the CWD is right.
  override func setUpWithError() throws {
    originalCwd = FileManager.default.currentDirectoryPath
    tempRoot = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let stickerFolder = tempRoot.appendingPathComponent("input/transparent-background")
    try FileManager.default.createDirectory(at: stickerFolder, withIntermediateDirectories: true)
    try FileManager.default.copyItem(at: Scenarios.glyphURL,
                                     to: stickerFolder.appendingPathComponent("glyph.png"))
    XCTAssertTrue(FileManager.default.changeCurrentDirectoryPath(tempRoot.path))
  }

  override func tearDownWithError() throws {
    FileManager.default.changeCurrentDirectoryPath(originalCwd)
    try? FileManager.default.removeItem(at: tempRoot)
  }

  /// Mean luminance / variance / clipped-white fraction of a rendered frame — the same
  /// three numbers the "did I just bless a solid colour?" check needs, computed in-process so
  /// a missing or degenerate reference reports itself instead of waiting for someone to open
  /// an image viewer.
  static func statistics(_ pixels: [SIMD4<Float>]) -> (mean: Double, variance: Double, white: Double) {
    var sum = 0.0, sumSq = 0.0, white = 0
    for p in pixels {
      let l = Double(0.2126 * p.x + 0.7152 * p.y + 0.0722 * p.z)
      sum += l; sumSq += l * l
      if p.x >= 0.99 && p.y >= 0.99 && p.z >= 0.99 { white += 1 }
    }
    let n = Double(pixels.count)
    let mean = sum / n
    return (mean, sumSq / n - mean * mean, Double(white) / n)
  }

  func testAllScenariosMatchReferences() throws {
    let ctx = try MetalContext()
    let regen = ProcessInfo.processInfo.environment["FEEDBAX_REGEN_GOLDEN"] == "1"
    var failures: [String] = []
    for scenario in Self.scenarios {
      let result = try GoldenRunner.render(scenario, context: ctx)
      let ref = try XCTUnwrap(Bundle.module.url(forResource: "GoldenReferences/\(scenario.name)",
                                                withExtension: "png",
                                                fallbackToSourceTree: true))   // helper: writes go to the source tree
      if regen {
        let stats = Self.statistics(result)
        // A blessed reference is a decision, and a degenerate frame is never the right one.
        // Refusing to WRITE it (rather than trusting a human to notice afterwards) is what
        // stops the historical failure mode this file's header describes: a whiteout being
        // quietly re-blessed as the new standard.
        if stats.variance < 1e-6 {
          failures.append(String(format: "%@: REFUSED to write reference — frame is a flat "
                                 + "featureless field (meanLum %.4f, variance %.8f, clipped-white "
                                 + "fraction %.4f). Fix the engine, not the reference.",
                                 scenario.name, stats.mean, stats.variance, stats.white))
          continue
        }
        try GoldenRunner.writeReference(result, size: scenario.size, to: ref)
      } else if !FileManager.default.fileExists(atPath: ref.path) {
        let stats = Self.statistics(result)
        failures.append(String(format: "%@: NO REFERENCE COMMITTED — deliberately absent, see this "
                               + "file's header. This scenario currently renders as meanLum %.4f, "
                               + "variance %.8f, clipped-white fraction %.4f; blessing is blocked "
                               + "until the feedback loop stops saturating.",
                               scenario.name, stats.mean, stats.variance, stats.white))
      } else {
        let verdict = try GoldenRunner.compare(result, referencePNG: ref)
        if !verdict.passed {
          failures.append("\(scenario.name): \(verdict.failingPixelFraction * 100)% pixels over tolerance")
        }
      }
    }
    if regen {
      XCTFail("references regenerated — OPEN the PNGs, decide whether the new look is the one "
              + "you intended (a solid/flat field is never it), then rerun without the flag")
    }
    XCTAssertEqual(failures, [], "the look changed — look at the images and decide whether the "
                   + "change is intended; do not regenerate to make this green")
  }
}
