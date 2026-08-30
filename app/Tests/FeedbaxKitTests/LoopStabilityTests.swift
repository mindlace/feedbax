import XCTest
import Foundation
import Metal
import simd
@testable import FeedbaxKit

/// Behavioural tests for the feedback loop as a dynamical system, not as a snapshot.
///
/// The loop is a map `x' = F(x)` over the accumulator texture: each frame erases toward a
/// color, warps the previous frame, draws seed content under it, and composites the warped
/// past back over the top. A correctly-tuned instance of `F` is a contraction with a bounded,
/// non-degenerate fixed point for any configuration whose HSL lightness drift is non-positive
/// — geometry (zoom/theta/pan), hue, and erase are all free to vary; the restoring `bias`
/// term is what keeps the integrator from running away. Three properties are pinned here:
/// (1) the unseeded startup+rotation scenario — the instrument owner's own acceptance
/// scenario — is bounded (no clipping, headroom below white) and non-degenerate (structured,
/// not flat); (2) once injection is removed, the seeded loop relaxes under any geometry/hue/
/// erase the fuzz throws at it — retention stays <= 1 under real (non-identity) transport;
/// (3) with identity geometry and no injection at all, retention never exceeds unity across
/// the full erase range; (4) a permanently drawn sticker is a *stamp*, not an injection —
/// the loop never clips while it is on.
///
/// Property (4) used to be deliberately un-asserted, on the reasoning that the loop's
/// equations (`rgb' = warped_prev + A_dst*seed`, then clamp) saturate a permanent seed in
/// the original instrument too. That reasoning was wrong: it modelled the seed *under* the
/// additive past-plane composite, which is where the Max retrofit had mistakenly put it. In
/// Sean's patch the sticker `jit.gl.layer` draws on the render bang, *after* the plane,
/// alpha-blended on top — `rgb' = As*S + (1-As)*warped_prev`, a convex combination that can
/// never exceed the sticker's own brightness (spec §02 header; diagnosis finding J). Only the
/// waveform graphs sit under the plane and inject additively.
final class LoopStabilityTests: XCTestCase {
  private static let canvasSize = SIMD2<Int>(192, 108)

  private var originalCwd: String!
  private var tempRoot: URL!

  /// Same CWD trick as `GoldenFrameTests.setUpWithError`/`EngineWiringTests.setUpWithError`:
  /// `Engine.init` resolves its sticker folder against the process's current working
  /// directory, so every scenario here that seeds a sticker needs a real
  /// `input/transparent-background/` folder in place before the `Engine` is constructed.
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

  // MARK: - Shared harness

  /// Constructs and steps an `Engine` exactly as `GoldenRunner.render` does (`MetalContext()`
  /// -> `Engine(context:)` -> `setResolution` -> `applyPreset(preset, at: -1)`), then reads
  /// back every frame. `seedOn` is applied AFTER `applyPreset`, because `Engine.applyPreset`
  /// re-asserts `sticker.layer.enabled`/`movie.layer.enabled` from `preset.toggles
  /// .layerEnabled` (see `Engine.applyPreset`, `Sources/FeedbaxKit/Engine/Engine.swift:356
  /// -384) — setting it before would just be overwritten. `seedOffAtFrame`, when set, turns
  /// off EVERY injection source — the sticker layer and both waveforms (wave 1 is on in every
  /// preset and injects a ring each frame) — immediately before stepping that frame index, on
  /// the SAME `Engine`/`context` used for the whole run. This is how a test observes the loop
  /// relaxing once injection stops: what remains is retention, transport and the HSL drift,
  /// nothing else. A fresh engine would lose the accumulator state from the seeded phase.
  private func runSeeded(preset: Preset, frames: Int, seedOn: Bool,
                        waveformsOn: Bool = true,
                        seedOffAtFrame: Int? = nil) throws -> [FrameLuminance] {
    let context = try MetalContext()
    let engine = try Engine(context: context)
    engine.setResolution(Self.canvasSize)
    engine.applyPreset(preset, at: -1)
    engine.sticker.layer.enabled = seedOn
    if !waveformsOn {
      // Same post-`applyPreset` ordering as `seedOn`: the preset re-asserts both wave toggles.
      engine.waveforms.wave1Enabled = false
      engine.waveforms.wave2Enabled = false
    }

    var stats: [FrameLuminance] = []
    stats.reserveCapacity(frames)
    for i in 0..<frames {
      if let seedOffAtFrame, i == seedOffAtFrame {
        engine.sticker.layer.enabled = false
        engine.waveforms.wave1Enabled = false
        engine.waveforms.wave2Enabled = false
      }
      let commandBuffer = context.queue.makeCommandBuffer()!
      let texture = engine.step(at: Double(i) / 60, commandBuffer: commandBuffer)
      commandBuffer.commit()
      commandBuffer.waitUntilCompleted()
      context.pool.endFrame()
      stats.append(FrameLuminance(pixels: context.readPixels(texture)))
    }
    return stats
  }

  /// Index of the first frame with any clipped-white pixels, or nil if the run never clips.
  private func firstClippingFrame(_ run: [FrameLuminance]) -> Int? {
    run.firstIndex { $0.whiteFraction > 0 }
  }

  private func printRow(_ i: Int, _ s: FrameLuminance) {
    print(String(format: "%4d  %.4f  %.4f  %.4f  %.6f", i, s.mean, s.maxLum, s.whiteFraction, s.variance))
  }

  // MARK: - Test 1: real startup vector, rotated, no seed

  /// The instrument owner's acceptance scenario: from the real startup vector, change only
  /// theta — a performer rotating away from cold-start defaults — with NO sticker at all.
  /// Asserts three properties over the whole 240-frame run: no clipping, headroom below
  /// white, and (from frame 10 on, past the initial transient) non-degenerate structure.
  /// Each property is checked at EVERY frame but reported as a single aggregated failure at
  /// the first violating frame, not 240 separate failures.
  func testStartupWithRotationStaysBoundedAndStructured() throws {
    let preset = Scenarios.preset(name: "startup-rotate", theta: 0.2, erase: 1.0,
                                  layerMode: .sticker, layerEnabled: false)
    let series = try runSeeded(preset: preset, frames: 240, seedOn: false)

    print("frame  mean    maxLum  whiteFrac  variance")
    for i in 0..<min(20, series.count) { printRow(i, series[i]) }
    var i = 20
    while i < series.count { printRow(i, series[i]); i += 20 }

    if let clipFrame = firstClippingFrame(series) {
      let s = series[clipFrame]
      XCTFail("frame \(clipFrame): whiteFraction \(s.whiteFraction) is > 0 — the unseeded " +
        "startup-rotate loop clipped to white (mean=\(s.mean), maxLum=\(s.maxLum))")
    }
    if let overLum = series.firstIndex(where: { $0.maxLum > 1 - 1.0 / 255 }) {
      let s = series[overLum]
      XCTFail("frame \(overLum): maxLum \(s.maxLum) has less than one 8-bit step of headroom " +
        "below full white (mean=\(s.mean), whiteFraction=\(s.whiteFraction))")
    }
    if let flatFrame = (10..<series.count).first(where: { series[$0].variance <= 1e-3 }) {
      let s = series[flatFrame]
      XCTFail("frame \(flatFrame): variance \(s.variance) <= 1e-3 — the frame is a flat " +
        "field, not structured content (mean=\(s.mean), maxLum=\(s.maxLum))")
    }
  }

  // MARK: - Test 2: deterministic fuzz — relaxation once injection stops, over geometry, hue, and erase

  /// A tiny seeded PRNG (splitmix64) — never `SystemRandomNumberGenerator`, so the fuzz is
  /// reproducible run to run.
  struct SplitMix64: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { self.state = seed }
    mutating func next() -> UInt64 {
      state &+= 0x9E3779B97F4A7C15
      var z = state
      z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
      z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
      return z ^ (z >> 31)
    }
  }

  /// One fuzz trial's inputs and outcome, kept around so a failure message can list every
  /// offending trial's exact controls. `firstClip` is diagnostic only (see below) — it is
  /// printed but never asserted on.
  private struct FuzzTrial {
    let index: Int
    let zoom, theta, panX, panY, hue, erase: Float
    let firstClip: Int?
    let mean19, mean79, maxLum79: Double
    let whiteFraction79, variance79: Double
  }

  /// 12 deterministic trials, each starting from `ControlRouter.startupVector` and
  /// overriding only zoom/theta/panX/panY/hue/erase with uniform randoms — `bias`,
  /// `scalebright`, `nc`, and `saturation` stay at the startup vector, which keeps the HSL
  /// lightness drift non-positive (see `ControlRouter.startupVector`'s doc: raw bias 0.0 maps
  /// to lightDelta -0.01/frame) so a diverging trial cannot be blamed on a legitimately
  /// divergent user setting — only on geometry, hue, or erase.
  ///
  /// The sticker is ON for frames 0..<20 (an injection phase); at frame 20 EVERY injection
  /// source is switched off (sticker, wave 1, wave 2) — on the SAME engine, so the accumulator
  /// carries real state across the transition — and the loop runs to frame 80 on retention,
  /// transport and the HSL drift alone. What is asserted is the RELAXATION, not the injection
  /// phase, and only what the loop map guarantees when retention is at most 1: with the
  /// lightness delta at -0.01/frame, every pixel's HSL lightness at frame 79 is at most 0.4
  /// (it was at most 1.0 at frame 19), so (a) no pixel can still be clipped, (b) no channel
  /// can exceed 0.8, hence max luminance is at most 0.8 (0.85 with tolerance), and (c) from a
  /// near-saturated frame the mean luminance must have fallen by a wide margin (0.3 is far
  /// inside the 0.6-lightness loss). "Mean halves" is deliberately NOT asserted: hue drift can
  /// land on luminous hues, so mean luminance is not bounded by lightness alone.
  func testSeededLoopRelaxesOnceInjectionStopsUnderRandomGeometryAndErase() throws {
    var rng = SplitMix64(seed: 0x5EEDFEEDBA5)
    var trials: [FuzzTrial] = []

    print("trial  zoom     theta    panX     panY     hue      erase   firstClip  mean@19   mean@79   max@79    white@79  var@79")
    for t in 0..<12 {
      let zoom = Float.random(in: -1...1, using: &rng)
      let theta = Float.random(in: -1...1, using: &rng)
      let panX = Float.random(in: -0.3...0.3, using: &rng)
      let panY = Float.random(in: -0.3...0.3, using: &rng)
      let hue = Float.random(in: -1...1, using: &rng)
      let erase = Float.random(in: 0...1, using: &rng)

      var slots = ControlRouter.startupVector
      slots[ControlSlot.zoom.rawValue] = zoom
      slots[ControlSlot.theta.rawValue] = theta
      slots[ControlSlot.panX.rawValue] = panX
      slots[ControlSlot.panY.rawValue] = panY
      slots[ControlSlot.hue.rawValue] = hue

      let toggles = PresetToggles(worldBump: false, waveBump: false, kittyBump: false,
                                  wave1: true, wave2: false, layerEnabled: true)
      let preset = Preset(name: "fuzz-\(t)", slots: slots, eraseControl: erase,
                         toggles: toggles, layers: [], layerMode: LayerMode.sticker.presetIdentifier)

      let series = try runSeeded(preset: preset, frames: 80, seedOn: true, seedOffAtFrame: 20)
      // Diagnostic only: a permanently drawn opaque seed saturates its own pixels by the
      // loop's own equations (rgb' = warped_prev + A_dst*seed, then clamp at 1.0) — the same
      // thing happens in the original Max instrument — so clipping DURING the injection phase
      // is not a parity signal without a like-for-like Max measurement. It is printed, not
      // asserted on.
      let firstClip = firstClippingFrame(Array(series[0..<20]))
      let s19 = series[19]
      let s79 = series[79]
      trials.append(FuzzTrial(index: t, zoom: zoom, theta: theta, panX: panX, panY: panY,
                              hue: hue, erase: erase, firstClip: firstClip,
                              mean19: s19.mean, mean79: s79.mean, maxLum79: s79.maxLum,
                              whiteFraction79: s79.whiteFraction, variance79: s79.variance))
      print(String(format: "%5d  %+.4f  %+.4f  %+.4f  %+.4f  %+.4f  %.4f  %@         %.4f    %.4f    %.4f    %.4f     %.6f",
                  t, zoom, theta, panX, panY, hue, erase,
                  firstClip.map { "\($0)" } ?? "none", s19.mean, s79.mean, s79.maxLum,
                  s79.whiteFraction, s79.variance))
    }

    let maxLumCeiling = 0.85   // lightness <= 0.4 => every channel <= 0.8, plus tolerance
    let minMeanDrop = 0.3      // well inside the guaranteed 0.6 lightness loss over 60 frames
    let failing = trials.filter {
      $0.whiteFraction79 != 0 || $0.maxLum79 > maxLumCeiling || $0.mean79 > $0.mean19 - minMeanDrop
    }
    if !failing.isEmpty {
      let message = failing.map {
        "#\($0.index) (zoom=\($0.zoom), theta=\($0.theta), panX=\($0.panX), panY=\($0.panY), " +
        "hue=\($0.hue), erase=\($0.erase)): mean@19=\($0.mean19), mean@79=\($0.mean79) " +
        "(must be <= \($0.mean19 - minMeanDrop)), maxLum@79=\($0.maxLum79) (must be <= \(maxLumCeiling)), " +
        "whiteFraction@79=\($0.whiteFraction79)"
      }.joined(separator: "; ")
      XCTFail("loop failed to relax once injection stopped: \(message)")
    }
  }

  // MARK: - Test 3: retention with no injection, swept across erase values

  /// No sticker, no waveforms — the ONLY content in the loop is a single mid-gray solid
  /// drawn on frame 0, exactly the way `EngineInvariantTests
  /// .testFeedbackPlaneDoesNotGainEnergyWithoutInput` injects it, via a bare `FeedbackCore`
  /// and its `drawSeeds` closure. That mechanism (and the identity-geometry pin) is only
  /// reachable through the bare `FeedbackCore`/`ControlRouter` pair, not through `Engine`:
  /// `Engine.core` is private and `Engine.step` builds `RenderParams` from `router.tick`
  /// internally with no hook to override geometry or substitute a custom draw, so this test
  /// cannot be expressed against the full `Engine` at all — using the same bare harness the
  /// reused test does is the only way to pin geometry to identity and inject a single known
  /// frame of content. The real startup HSL values apply throughout (lightDelta ~ -0.01/
  /// frame, the restoring term), and `eraseControl` is swept across the full slider range.
  /// Loop-map prediction (not encoded — this tests behaviour, not the formula): retention =
  /// 1 + Ad*(1-a) where a is the mapped erase alpha, so every value below 1.0 should rise.
  func testRetentionWithoutInjectionNeverExceedsUnityAcrossEraseValues() throws {
    let eraseValues: [Float] = [1.0, 0.9, 0.75, 0.55, 0.25, 0.0]
    var rising: [(erase: Float, frame: Int, from: Double, to: Double)] = []

    print("erase  mappedAlpha  mean@f1   mean@f10  mean@f30  mean@f89  maxRise")
    for erase in eraseValues {
      let context = try MetalContext()
      let core = try FeedbackCore(context: context, size: Self.canvasSize)
      core.feedbackPlaneEnabled = true   // the state the real instrument runs in

      let router = ControlRouter()
      router.applyStartupDefaults(at: -1)   // real settled startup HSL
      router.eraseControl = erase
      var params = router.tick(at: 0)
      params.zoom = 1
      params.theta = 0
      params.offsetPx = .zero
      XCTAssertLessThanOrEqual(params.lightDelta, 0, "precondition: restoring term must decay")

      func step(index: Int, seed: Bool) -> FrameLuminance {
        let cb = context.queue.makeCommandBuffer()!
        let frame = FrameContext(index: index, time: Double(index) / 60, delta: 1.0 / 60,
                                 canvasSize: Self.canvasSize, commandBuffer: cb, pool: context.pool)
        let out = core.renderFrame(frame, params: params, under: { enc in
          if seed { core.drawSolid(enc, color: SIMD4(0.5, 0.5, 0.5, 1)) }
        })
        cb.commit(); cb.waitUntilCompleted(); context.pool.endFrame()
        return FrameLuminance(pixels: context.readPixels(out))
      }

      var series: [Double] = []
      var previous = step(index: 0, seed: true)
      series.append(previous.mean)
      XCTAssertGreaterThan(previous.mean, 0.1,
        "erase \(erase): seed frame mean luminance \(previous.mean) — the seed did not land, " +
        "so this trial would be vacuous")

      var maxRise = 0.0
      var firstRiseFrame: Int? = nil
      for i in 1..<90 {
        let current = step(index: i, seed: false)
        series.append(current.mean)
        let rise = current.mean - previous.mean
        if rise > maxRise { maxRise = rise }
        if rise > 1.0 / 255 && firstRiseFrame == nil { firstRiseFrame = i }
        previous = current
      }

      print(String(format: "%.2f   %.4f       %.4f    %.4f    %.4f    %.4f    %.6f",
                  erase, params.eraseAlpha, series[1], series[10], series[30], series[89], maxRise))

      if let f = firstRiseFrame {
        rising.append((erase, f, series[f - 1], series[f]))
      }
    }

    if !rising.isEmpty {
      let message = rising.map {
        "erase=\($0.erase): first rose at frame \($0.frame) (\($0.from) -> \($0.to))"
      }.joined(separator: "; ")
      XCTFail("mean luminance rose by more than 1/255 frame-over-frame for: \(message)")
    }
  }

  // MARK: - Test 4: a permanently drawn sticker is a stamp, not an injection

  /// The sticker layer on, both waveforms off, the real `rota-spiral` configuration
  /// (zoom 0.9, theta 0.2, erase 0.55) that `GoldenFrameTests`' header measured going 100 %
  /// clipped white by frame 10 — through the real `Engine`, with the committed glyph fixture
  /// as the sticker. With the sticker drawn *over* the feedback plane (the original's order)
  /// the per-pixel map at a sticker pixel is `As*S + (1-As)*warped_prev`, and everywhere else
  /// it is the transported, HSL-decayed past — nothing in that map can manufacture a value
  /// brighter than the sticker itself, and the glyph's brightest channel is 242/255. So over
  /// a 240-frame run: no clipped-white pixel ever, and at least one 8-bit step of headroom on
  /// the brightest pixel of every frame. Waveforms are off because they *are* additive
  /// injections (drawn under the plane, as in the original) and would muddy a test whose
  /// single subject is the sticker's side of the plane.
  func testPermanentStickerStampsOverTheLoopAndNeverClips() throws {
    let preset = Scenarios.preset(name: "sticker-stamp", zoom: 0.9, theta: 0.2, erase: 0.55,
                                  layerMode: .sticker, layerEnabled: true)
    let series = try runSeeded(preset: preset, frames: 240, seedOn: true, waveformsOn: false)

    print("frame  mean    maxLum  whiteFrac  variance")
    for i in 0..<min(12, series.count) { printRow(i, series[i]) }
    var i = 20
    while i < series.count { printRow(i, series[i]); i += 20 }

    // Non-vacuity: the glyph must actually be on the canvas from frame 0.
    XCTAssertGreaterThan(series[0].maxLum, 0.25,
      "frame 0 maxLum \(series[0].maxLum) — the sticker did not land, so the rest of this " +
      "test would be vacuous")

    if let clipFrame = firstClippingFrame(series) {
      let s = series[clipFrame]
      XCTFail("frame \(clipFrame): whiteFraction \(s.whiteFraction) is > 0 — a permanently " +
        "drawn sticker clipped the loop to white (mean=\(s.mean), maxLum=\(s.maxLum)); the " +
        "sticker is being added under the feedback plane instead of stamped over it")
    }
    if let overLum = series.firstIndex(where: { $0.maxLum > 1 - 1.0 / 255 }) {
      let s = series[overLum]
      XCTFail("frame \(overLum): maxLum \(s.maxLum) has less than one 8-bit step of headroom " +
        "below full white (mean=\(s.mean), whiteFraction=\(s.whiteFraction))")
    }
  }
}
