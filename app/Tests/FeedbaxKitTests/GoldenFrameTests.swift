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

/// The seven P1 parity scenarios (design §9, this task's brief) — one `Scenario` per look
/// the port has to keep pixel-stable release over release. Each attaches a short doc comment
/// citing the fidelity-checklist item(s) (design §6) it exists to pin, same convention as
/// `WarpParityTests`/`FilterTests`.
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
  /// sticker/movie defaults (`StickerSource`'s auto-selected index 0, `LayerTransform()`'s
  /// identity placement) are already what every scenario wants.
  ///
  /// `bias`/`saturation`, like `zoom`/`theta`/`hue`, default to nil — "leave the startup
  /// vector's own raw value alone." Long-running scenarios pass `bias: noDriftBias,
  /// saturation: noDriftSaturation` explicitly (see those constants' own doc) instead: found
  /// empirically (see `GoldenRunner.render`'s note on the `at: -1` settle-time fix) while
  /// eyeballing the first correctly-settled references — the startup vector's own bias/
  /// saturation raw values map to a small but PERSISTENT positive per-frame lightness/
  /// saturation delta (`ControlRouter.mappedTarget`'s `exp 0.05`/`exp 0.1` curves are heavily
  /// compressive, so nearly the whole raw domain maps close to the high end of their output
  /// range) — additive every frame, with nothing that ever pulls it back down, i.e. a
  /// monotonic integrator. Over the ~20-60 frames a delta this size takes to walk saturation/
  /// lightness into their `[0,1]` clip, ANY multi-second scenario converges to a stable,
  /// all-information-destroying WHITE fixed point (`hsl2rgb` at `l=1` is white regardless of
  /// hue/sat) — real, faithful-to-spec-§01-§4 engine behavior (a performer fights this in the
  /// original too, and `identityAccumulation`'s own short 10-frame run deliberately keeps the
  /// true startup-vector value to show it), not a bug — but it drowns out whatever a LONGER
  /// golden scenario exists to actually demonstrate (the spiral, the kaleidoscope, the hue
  /// wrap), so those opt out of it explicitly instead.
  static func preset(name: String, zoom: Float? = nil, theta: Float? = nil, hue: Float? = nil,
                     bias: Float? = nil, saturation: Float? = nil,
                     erase: Float, layerMode: LayerMode = .sticker,
                     layerEnabled: Bool = false, wave1: Bool = true, wave2: Bool = false,
                     worldBump: Bool = false, waveBump: Bool = false,
                     kittyBump: Bool = false) -> Preset {
    var slots = ControlRouter.startupVector
    if let zoom { slots[ControlSlot.zoom.rawValue] = zoom }
    if let theta { slots[ControlSlot.theta.rawValue] = theta }
    if let hue { slots[ControlSlot.hue.rawValue] = hue }
    if let bias { slots[ControlSlot.bias.rawValue] = bias }
    if let saturation { slots[ControlSlot.saturation.rawValue] = saturation }
    let toggles = PresetToggles(worldBump: worldBump, waveBump: waveBump, kittyBump: kittyBump,
                                wave1: wave1, wave2: wave2, layerEnabled: layerEnabled)
    return Preset(name: name, slots: slots, eraseControl: erase, toggles: toggles, layers: [],
                 layerMode: layerMode.presetIdentifier)
  }

  /// Raw `.bias` (→ `lightDelta`) that maps closest to a true zero per-frame delta —
  /// `maxScale(raw, -1, 1, -0.04, 0.02, exp: 0.05)` evaluated at `raw = -0.999` gives
  /// `+0.00103`, the smallest-magnitude value found by scanning the curve near its low end
  /// (the mapping is so compressive under `exp: 0.05` that `raw = -1` undershoots to a much
  /// larger `-0.04`, and everything above `-0.99` overshoots well into the positive teens of
  /// a percent — see `GoldenRunner`'s note on why near-zero, not "whatever the startup
  /// vector says," is what a long-running scenario needs here).
  static let noDriftBias: Float = -0.999
  /// Raw `.saturation` (→ `satDelta`, domain `0...1` unlike its `-1...1` siblings) that maps
  /// closest to zero — `maxScale(raw, 0, 1, -0.05, 0.05, exp: 0.1)` at `raw = 0.001` gives
  /// `+0.00012`, same reasoning as `noDriftBias`.
  static let noDriftSaturation: Float = 0.001

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

  /// 1. Startup defaults, nothing else touched — proves the cold-start recipe (erase's 1.0
  /// hard clear, no seed layer, wave 1 only) doesn't crash and settles to a stable image.
  /// 10 frames: past the ~100 ms/6-frame ramp-settle window (`LinearRamp`'s own `smoothMs`),
  /// so the captured frame reflects the SETTLED startup vector, not an in-flight glide — and
  /// deliberately short enough that the startup vector's own (undisturbed — `bias`/
  /// `saturation` are left at nil here, unlike the multi-second scenarios below) small
  /// per-frame HSL drift (see `preset`'s own doc) hasn't yet washed the frame to white.
  static var identityAccumulation: Scenario {
    Scenario(name: "identity-accumulation", preset: preset(name: "identity-accumulation", erase: 1.0),
            frames: 10, size: canvasSize)
  }

  /// 2. Sticker layer on the committed 32×32 glyph fixture (loaded via `GoldenFrameTests`'
  /// CWD setup, see its `setUpWithError`), zoom 0.9 / theta 0.2 / erase 0.55 raw, 120 frames
  /// — long enough for the fold-warp's repeated application to build the signature spiral
  /// (design §9's "golden-frame tests" example scenario). `bias`/`saturation` pinned to
  /// `noDriftBias`/`noDriftSaturation` (see `preset`'s own doc) — 120 frames is well past the
  /// point the startup vector's own HSL drift would otherwise wash this out to solid white.
  static var rotaSpiral: Scenario {
    Scenario(name: "rota-spiral",
            preset: preset(name: "rota-spiral", zoom: 0.9, theta: 0.2,
                          bias: noDriftBias, saturation: noDriftSaturation, erase: 0.55,
                          layerMode: .sticker, layerEnabled: true),
            frames: 120, size: canvasSize)
  }

  /// 3. Identical to `rotaSpiral` up to frame 60, where the control timeline flips SInvert —
  /// checklist #7: "negates zoom + offsets → point-mirror kaleidoscope; first-class toggle."
  /// Only 4 further frames (64 total, not 120): traced empirically (`DiagTests` scratch
  /// harness, since removed) frame by frame after the flip — negating zoom, unlike the
  /// positive-zoom fold `rotaSpiral` settles into a static self-referential fixed point
  /// under, does NOT converge; it keeps sampling genuinely new canvas regions each frame, and
  /// the additive `(srcα,dstα)` feedback-plane blend (checklist #3) compounds that into the
  /// same white fixed point `preset`'s doc describes, this time in under 10 frames instead of
  /// 20-60. Frame 64 is well inside the "clearly mirrored, not yet blown out" window (frame
  /// 69 was already solid white in that trace) — capturing sooner rather than fighting the
  /// instability with more `noDrift`-style tuning, since the point of this scenario is
  /// SInvert's mirror, not a long kaleidoscope performance.
  static var sinvertKaleidoscope: Scenario {
    Scenario(name: "sinvert-kaleidoscope",
            preset: preset(name: "sinvert-kaleidoscope", zoom: 0.9, theta: 0.2,
                          bias: noDriftBias, saturation: noDriftSaturation, erase: 0.55,
                          layerMode: .sticker, layerEnabled: true),
            timeline: [(frame: 60, write: ControlWrite(toggles: [.sInvert(true)]))],
            frames: 64, size: canvasSize)
  }

  /// 4. Hue slot pinned at 1.0 raw (the mapped ramp's extreme) for 180 frames against the
  /// same glyph/zoom/theta/erase setup as `rotaSpiral` — checklist #5: "HSL shift is
  /// additive in HSL space; hue wraps." A colorless (no seed layer) run would never visibly
  /// demonstrate a hue WRAP — a fully desaturated pixel renders the same regardless of its
  /// hue channel — so this scenario needs real chroma feeding the warp loop.
  ///
  /// `zoom`/`theta` are `rotaSpiral`'s own values, not left at the startup vector's default
  /// (traced empirically, `DiagTests` scratch harness since removed): the startup vector's
  /// own zoom does NOT settle the fold into a static spatial pattern the way `rotaSpiral`'s
  /// does, so pixels keep sampling genuinely different canvas regions every frame — same
  /// "additive blend never lets go" mechanism as `sinvertKaleidoscope`'s note, saturating to
  /// solid white by frame ~10 of 180. Under `rotaSpiral`'s zoom/theta the fold DOES settle to
  /// a static fractal-like pattern (each pixel's color stabilizes; the traced center pixel
  /// was already fixed by frame 10 and identical through frame 179) — a single final-frame
  /// PNG can't show hue CYCLING over time regardless (that needs the unit-level math tests,
  /// `HSLTests`, for the wrap arithmetic itself), but this at least gives a stable,
  /// non-degenerate, hue-heavy reference instead of a content-free white square. `bias`/
  /// `saturation` stay pinned to `noDriftBias`/`noDriftSaturation` for the same reason as
  /// `rotaSpiral` — 180 frames is otherwise ample time to wash out regardless of zoom.
  static var hslDrift: Scenario {
    Scenario(name: "hsl-drift",
            preset: preset(name: "hsl-drift", zoom: 0.9, theta: 0.2, hue: 1.0,
                          bias: noDriftBias, saturation: noDriftSaturation, erase: 0.55,
                          layerMode: .sticker, layerEnabled: true),
            frames: 180, size: canvasSize)
  }

  /// 5. Movie layer on the committed `sweep.mov` fixture, `BrcosaFilter` pinned on at its
  /// hot (camera-chain) defaults — design §10: "the brcosa/keyer filter IMPLEMENTATIONS land
  /// in P1, pinned by... golden-frame scenarios that attach them to a movie layer" (no P1
  /// parity default runs them live; this is that pin, ahead of the camera existing). 1 frame
  /// — see `primeMovie`'s note on why a movie scenario stays this short.
  static var brcosaOnMovie: Scenario {
    Scenario(name: "brcosa-on-movie",
            preset: preset(name: "brcosa-on-movie", erase: 0.55, layerMode: .movie, layerEnabled: true),
            frames: 1, size: canvasSize,
            configure: { engine in
              engine.loadMovie(url: Scenarios.sweepURL)
              primeMovie(engine)
              let brcosa = try! BrcosaFilter(context: engine.context)
              brcosa.enabled = true   // hot defaults 1.55/1.55/1.5 (spec §02 §7.2)
              engine.movieFilters = FilterChain([brcosa])
            })
  }

  /// 6. Same movie fixture, `LumaKeyFilter`'s two-pass midtone cascade pinned on instead —
  /// checklist #12: "luma = two-pass midtone cascade" — same design §10 rationale as
  /// `brcosaOnMovie`.
  static var keyersOnMovie: Scenario {
    Scenario(name: "keyers-on-movie",
            preset: preset(name: "keyers-on-movie", erase: 0.55, layerMode: .movie, layerEnabled: true),
            frames: 1, size: canvasSize,
            configure: { engine in
              engine.loadMovie(url: Scenarios.sweepURL)
              primeMovie(engine)
              let luma = try! LumaKeyFilter(context: engine.context)
              luma.enabled = true
              engine.movieFilters = FilterChain([luma])
            })
  }

  /// 7. Waveforms 1 and 2 both enabled, all three bump gates on, `AudioBands` fed a single
  /// fixed 46.7 + 144.3 Hz mixture (wave 1's and worldBump's own band centers, spec §03 §3 —
  /// wave 2's 60 Hz band is deliberately NOT part of the mixture) — checklists #10/#11.
  ///
  /// Exactly 1 frame, deliberately: `AudioBands.frameValues()`'s `waveBumpRaw`/`kittyBumpRaw`
  /// are "mean SINCE THE LAST CALL" accumulators that drain to zero the instant they're read
  /// (`Audio/AudioAnalysis.swift`'s own doc comment), and `Engine.step`'s kitty offset is
  /// explicitly non-persistent (its stage-3 comment: "must not still be sitting on
  /// `sticker.transform` once `step` has returned"). A single up-front `ingest` therefore
  /// only shows a live wave-bump/kitty-bump effect on the very FIRST `step` after it —
  /// `worldBump` has no such reset (`worldBumpSnapshot` persists indefinitely), so it alone
  /// would stay visible for any frame count, but capturing frame 0 is what keeps ALL THREE
  /// gates ("bumps on", checklist #10) live in the one frame this scenario grades.
  static var waveformsSynthetic: Scenario {
    Scenario(name: "waveforms-synthetic",
            preset: preset(name: "waveforms-synthetic", erase: 1.0, wave1: true, wave2: true,
                          worldBump: true, waveBump: true, kittyBump: true),
            frames: 1, size: canvasSize,
            configure: { engine in
              let mix = zip(sine(46.7, seconds: 1.0, sampleRate: 48000, amplitude: 0.6),
                            sine(144.3, seconds: 1.0, sampleRate: 48000, amplitude: 0.6)).map(+)
              engine.bands.ingest(mix)
            })
  }
}

/// Task 22: renders each of `Scenarios`' seven looks headlessly and compares against a
/// committed reference PNG (design §9's "golden-frame tests" — catches "the look drifted"
/// without eyeballs). `FEEDBAX_REGEN_GOLDEN=1` regenerates references into the SOURCE TREE
/// instead of comparing (see the `Bundle.url(forResource:withExtension:fallbackToSourceTree:)`
/// helper above) — the one manual gate in this file is eyeballing those PNGs before
/// committing them, per the brief.
final class GoldenFrameTests: XCTestCase {
  static let scenarios: [Scenario] = [
    Scenarios.identityAccumulation, Scenarios.rotaSpiral, Scenarios.sinvertKaleidoscope,
    Scenarios.hslDrift, Scenarios.brcosaOnMovie, Scenarios.keyersOnMovie, Scenarios.waveformsSynthetic,
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
        try GoldenRunner.writeReference(result, size: scenario.size, to: ref)
      } else {
        let verdict = try GoldenRunner.compare(result, referencePNG: ref)
        if !verdict.passed {
          failures.append("\(scenario.name): \(verdict.failingPixelFraction * 100)% pixels over tolerance")
        }
      }
    }
    if regen { XCTFail("references regenerated — eyeball the PNGs, then rerun without the flag") }
    XCTAssertEqual(failures, [], "the look drifted")
  }
}
