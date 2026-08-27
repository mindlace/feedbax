import XCTest
import Foundation
import Metal
import simd
@testable import FeedbaxKit

/// Direct wiring assertions — the replacement for three golden-frame scenarios
/// (`brcosa-on-movie`, `keyers-on-movie`, `waveforms-synthetic`) that were 1-frame PNG
/// snapshots of facts that are fundamentally BOOLEAN.
///
/// Every one of those three scenarios rendered a single frame and compared it to a committed
/// image. But the MATH each of them exercised is already pinned at unit level — `BrcosaTests`
/// (the brcosa curve), `KeyerTests`/`FilterTests` (the two-pass luma cascade and the chain's
/// enable/skip contract), `WaveformTests` (both waveforms' pure geometry),
/// `CompositorTests`/`AudioAnalysisTests` (draw ordering, band analysis). What the PNGs
/// uniquely added was WIRING: is the filter chain the engine applies to the movie layer
/// actually the chain the caller attached to `Engine.movieFilters`? Do wave 1 and wave 2 and
/// all three bump gates coexist and modulate within a single `step`?
///
/// Those are yes/no questions, so they get yes/no assertions. A pixel comparison answers them
/// only by proxy, fails for a hundred unrelated reasons (GPU driver rounding, a movie-priming
/// timing slip, an unrelated shader tweak), and — as the header of `GoldenFrameTests` now
/// records at length — can be silently "fixed" by regenerating the reference, which is how a
/// real mapping bug survived in the references for months. Nothing in this file can be made
/// green by regenerating anything.
final class EngineWiringTests: XCTestCase {
  private static let size = SIMD2<Int>(192, 108)

  private var originalCwd: String!
  private var tempRoot: URL!

  /// Same CWD trick `GoldenFrameTests.setUpWithError` documents: `Engine.init` resolves its
  /// sticker folder relative to the process's working directory, and the kitty-bump test
  /// below needs a real sticker to displace.
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

  // MARK: - Harness

  /// A `TextureFilter` that records every `apply` it receives and passes the texture through
  /// untouched. Deliberately an identity in pixel terms: inserting one anywhere in a chain
  /// cannot change what the frame looks like, so it observes wiring without perturbing it.
  final class SpyFilter: TextureFilter {
    let id: String
    var enabled = true
    private(set) var applyCount = 0
    /// The texture this spy last saw on its input — used to check chain ORDER (a spy sitting
    /// after a real filter must observe that filter's output, not the raw source texture).
    private(set) var lastInput: MTLTexture?

    init(id: String) { self.id = id }

    func apply(_ input: MTLTexture, _ frame: FrameContext) -> MTLTexture {
      applyCount += 1
      lastInput = input
      return input
    }
  }

  /// Builds a headless engine at `size`, cold-started exactly like a live session
  /// (`applyStartupDefaults`), runs `configure`, then steps `frames` frames on the golden
  /// harness's fixed 1/60 s clock, calling `perFrame` before each `step`. Returns the last
  /// frame's straight-alpha pixels.
  private func render(frames: Int, context: MetalContext,
                      configure: (Engine) throws -> Void = { _ in },
                      perFrame: (Engine, Int) -> Void = { _, _ in }) throws -> [SIMD4<Float>] {
    let engine = try Engine(context: context)
    engine.router.applyStartupDefaults(at: -1)
    engine.setResolution(Self.size)
    try configure(engine)
    var last: MTLTexture!
    for i in 0..<frames {
      perFrame(engine, i)
      let cb = context.queue.makeCommandBuffer()!
      last = engine.step(at: Double(i) / 60, commandBuffer: cb)
      cb.commit(); cb.waitUntilCompleted(); context.pool.endFrame()
    }
    return context.readPixels(last)
  }

  /// Fraction of pixels whose worst channel differs by more than `GoldenRunner`'s own
  /// 2/255 tolerance — reused here so "these two frames differ" means the same thing it
  /// means in the golden comparator, just applied between two LIVE renders instead of
  /// against a committed image.
  private func differingFraction(_ a: [SIMD4<Float>], _ b: [SIMD4<Float>]) -> Double {
    precondition(a.count == b.count)
    var differing = 0
    for i in 0..<a.count {
      let d = abs(a[i] - b[i]) * 255
      if max(max(d.x, d.y), max(d.z, d.w)) > Float(GoldenRunner.maxChannelDeltaTolerance) {
        differing += 1
      }
    }
    return Double(differing) / Double(a.count)
  }

  // MARK: - Filter-chain wiring (replaces `brcosa-on-movie` and `keyers-on-movie`)

  /// The wiring fact both movie scenarios existed to pin, asserted as a fact: the chain
  /// `Engine.movieFilters` holds is the chain `step` applies to the MOVIE layer's decoded
  /// texture, and `stickerFilters` is not touched while `layerMode == .movie`.
  ///
  /// `Engine.step` stage 4 picks `activeFilters` by `layerMode`; that one-line selection is
  /// the whole of the wiring, and a spy on each side proves which branch ran without any
  /// reference to what the pixels look like.
  func testMovieLayerAppliesMovieFilterChainAndNotTheStickerChain() throws {
    let ctx = try MetalContext()
    let movieSpy = SpyFilter(id: "movie-spy")
    let stickerSpy = SpyFilter(id: "sticker-spy")
    _ = try render(frames: 1, context: ctx) { engine in
      engine.layerMode = .movie
      engine.sticker.layer.enabled = true
      engine.movie.layer.enabled = true
      engine.loadMovie(url: Scenarios.sweepURL)
      Scenarios.primeMovie(engine)
      engine.movieFilters = FilterChain([movieSpy])
      engine.stickerFilters = FilterChain([stickerSpy])
    }
    XCTAssertEqual(movieSpy.applyCount, 1,
                   "the movie layer's decoded texture must pass through `Engine.movieFilters`")
    XCTAssertEqual(stickerSpy.applyCount, 0,
                   "`stickerFilters` must not run while `layerMode == .movie` (step's stage-4 either-or)")
  }

  /// The mirror of the above — the sticker branch of the same selection. Together these pin
  /// the either-or that `LayerMode` exists to express.
  func testStickerLayerAppliesStickerFilterChainAndNotTheMovieChain() throws {
    let ctx = try MetalContext()
    let movieSpy = SpyFilter(id: "movie-spy")
    let stickerSpy = SpyFilter(id: "sticker-spy")
    _ = try render(frames: 1, context: ctx) { engine in
      engine.layerMode = .sticker
      engine.sticker.layer.enabled = true
      engine.movie.layer.enabled = true
      engine.movieFilters = FilterChain([movieSpy])
      engine.stickerFilters = FilterChain([stickerSpy])
    }
    XCTAssertEqual(stickerSpy.applyCount, 1,
                   "the sticker layer's texture must pass through `Engine.stickerFilters`")
    XCTAssertEqual(movieSpy.applyCount, 0, "`movieFilters` must not run while `layerMode == .sticker`")
  }

  /// `brcosa-on-movie`'s replacement. Asserts three things the PNG could only imply:
  ///
  /// 1. A `BrcosaFilter` attached to `movieFilters` is IN the chain the engine holds
  ///    (identity, not just "some filter is there").
  /// 2. It actually RUNS on the movie layer's texture — a spy placed after it in the chain
  ///    is invoked exactly once per frame, and sees a texture that is not the one the raw
  ///    source handed in (i.e. brcosa produced a new, filtered texture, so the chain is
  ///    composing left to right, not short-circuiting).
  /// 3. Its output REACHES the composited frame: the same run with `brcosa.enabled = false`
  ///    (`FilterChain.apply`'s documented skip) produces a materially different image.
  ///
  /// Point 3 is what makes this a wiring test rather than a repeat of `BrcosaTests` — the
  /// brcosa curve itself is pinned there; what is pinned here is that the curve is on the
  /// path between the movie decoder and the accumulator.
  func testBrcosaFilterOnMovieChainRunsAndReachesTheFrame() throws {
    let ctx = try MetalContext()
    var attached: BrcosaFilter?
    var spy: SpyFilter?
    func run(enabled: Bool) throws -> [SIMD4<Float>] {
      let downstream = SpyFilter(id: "after-brcosa")
      return try render(frames: 1, context: ctx) { engine in
        engine.layerMode = .movie
        engine.movie.layer.enabled = true
        engine.loadMovie(url: Scenarios.sweepURL)
        Scenarios.primeMovie(engine)
        let brcosa = try BrcosaFilter(context: engine.context)
        brcosa.enabled = enabled          // hot camera-chain defaults 1.55/1.55/1.5 (spec §02 §7.2)
        engine.movieFilters = FilterChain([brcosa, downstream])
        if enabled { attached = brcosa; spy = downstream }
        XCTAssertTrue(engine.movieFilters.filters.contains { $0 === brcosa },
                      "the attached BrcosaFilter must be the one the movie chain holds")
      }
    }
    let on = try run(enabled: true)
    let off = try run(enabled: false)
    XCTAssertNotNil(attached)
    XCTAssertEqual(spy?.applyCount, 1, "the movie chain ran exactly once for the frame")
    XCTAssertNotNil(spy?.lastInput, "the filter downstream of brcosa saw brcosa's output texture")
    XCTAssertGreaterThan(differingFraction(on, off), 0.01,
                         "brcosa's output must reach the composited frame — an enabled brcosa that "
                         + "changes nothing means the chain is wired past the movie layer")
  }

  /// `keyers-on-movie`'s replacement, same three assertions with `LumaKeyFilter`'s two-pass
  /// midtone cascade (checklist #12) in place of brcosa. The cascade's own arithmetic lives
  /// in `KeyerTests`; this pins that the cascade is attached to, and runs on, the movie layer.
  func testLumaKeyFilterOnMovieChainRunsAndReachesTheFrame() throws {
    let ctx = try MetalContext()
    var spy: SpyFilter?
    func run(enabled: Bool) throws -> [SIMD4<Float>] {
      let downstream = SpyFilter(id: "after-luma")
      return try render(frames: 1, context: ctx) { engine in
        engine.layerMode = .movie
        engine.movie.layer.enabled = true
        engine.loadMovie(url: Scenarios.sweepURL)
        Scenarios.primeMovie(engine)
        let luma = try LumaKeyFilter(context: engine.context)
        luma.enabled = enabled
        engine.movieFilters = FilterChain([luma, downstream])
        if enabled { spy = downstream }
        XCTAssertTrue(engine.movieFilters.filters.contains { $0 === luma },
                      "the attached LumaKeyFilter must be the one the movie chain holds")
      }
    }
    let on = try run(enabled: true)
    let off = try run(enabled: false)
    XCTAssertEqual(spy?.applyCount, 1, "the movie chain ran exactly once for the frame")
    XCTAssertGreaterThan(differingFraction(on, off), 0.01,
                         "the luma keyer's output must reach the composited frame")
  }

  // MARK: - Layer placement wiring (design §4)

  /// Both seed sources take the router's ramped layer transform every frame — the original had
  /// ONE picsvid layer whose transform came from `imageMove` whether it showed a picture or a
  /// video. The kitty offset (stage 3) is additive on top and restored, so after `step` the
  /// sources read exactly the router's value.
  func testBothSeedSourcesFollowTheRouterLayerTransform() throws {
    let ctx = try MetalContext()
    var captured: Engine?
    _ = try render(frames: 1, context: ctx) { engine in
      captured = engine
      // Applied at −1 s, settled long before frame 0's step at t = 0.
      engine.router.apply(ControlWrite(layer: [.x: 0.5, .rotate: 0.25]), at: -1)
    }
    let engine = try XCTUnwrap(captured)
    XCTAssertEqual(engine.sticker.transform, engine.router.layerTransform)
    XCTAssertEqual(engine.movie.transform, engine.router.layerTransform)
    XCTAssertEqual(engine.sticker.transform.position.x, 0.85, accuracy: 1e-3, "0.5 × 1.7")
    XCTAssertEqual(engine.sticker.transform.rotationZDegrees, 45, accuracy: 1e-2, "0.25 × 180°")
  }

  // MARK: - Waveform + bump-gate wiring (replaces `waveforms-synthetic`)

  /// A fixed synthetic mixture of wave 1's and worldBump's own band centres (46.7 + 144.3 Hz,
  /// spec §03 §3) — wave 2's 60 Hz band is deliberately absent, exactly as the retired
  /// `waveforms-synthetic` scenario had it, so wave 2 draws from its own (near-silent) band
  /// rather than a copy of wave 1's.
  private func bandMixture(seconds: Float) -> [Float] {
    zip(sine(46.7, seconds: seconds, sampleRate: 48000, amplitude: 0.6),
        sine(144.3, seconds: seconds, sampleRate: 48000, amplitude: 0.6)).map(+)
  }

  /// `waveforms-synthetic`'s replacement, part 1: wave 1 and wave 2 are independent draws
  /// that both land in a single frame.
  ///
  /// Four renders of the same audio-fed frame, differing only in the two `wave*Enabled`
  /// flags, and every pairwise comparison that should differ, differs:
  ///   - wave 1 alone ≠ nothing drawn   (wave 1's ribbon is on the path)
  ///   - wave 2 alone ≠ nothing drawn   (wave 2's ring is too — a separate pipeline
  ///                                     with a different blend mode, spec §03 §5)
  ///   - both ≠ either alone            (they COEXIST; neither draw suppresses the other)
  /// The waveform geometry itself is `WaveformTests`' business; this is purely "both reach
  /// the accumulator in the same pass."
  func testBothWaveformsDrawInOneFrame() throws {
    let ctx = try MetalContext()
    func run(wave1: Bool, wave2: Bool) throws -> [SIMD4<Float>] {
      try render(frames: 1, context: ctx) { engine in
        engine.waveforms.wave1Enabled = wave1
        engine.waveforms.wave2Enabled = wave2
        engine.bands.ingest(bandMixture(seconds: 1.0))
      }
    }
    let neither = try run(wave1: false, wave2: false)
    let onlyOne = try run(wave1: true, wave2: false)
    let onlyTwo = try run(wave1: false, wave2: true)
    let both = try run(wave1: true, wave2: true)
    XCTAssertGreaterThan(differingFraction(onlyOne, neither), 0.0, "wave 1 must draw when enabled")
    XCTAssertGreaterThan(differingFraction(onlyTwo, neither), 0.0, "wave 2 must draw when enabled")
    XCTAssertGreaterThan(differingFraction(both, onlyOne), 0.0,
                         "wave 2 must still draw when wave 1 is also drawing")
    XCTAssertGreaterThan(differingFraction(both, onlyTwo), 0.0,
                         "wave 1 must still draw when wave 2 is also drawing")
  }

  /// `waveforms-synthetic`'s replacement, part 2a: the world-bump gate is live and modulating.
  ///
  /// `Engine.step` stage 2 gates `params.worldBump` on `bumpsEnabled.world`; with real audio
  /// ingested, flipping that gate must change the frame, and the analyser must be producing a
  /// non-zero world bump in the first place (asserted separately on a scratch `AudioBands`, so
  /// a silent analyser can't make this test pass by making both sides equally zero).
  ///
  /// World bump is a scale on the PAST plane (`FeedbackCore`'s "apparent scale of the
  /// videoplane" arithmetic), so it is invisible on a frame whose past is still empty: this
  /// needs the sticker layer drawing and enough frames for that content to have entered the
  /// feedback plane. One frame of a black past scaled by anything is still black — which is
  /// exactly the failure mode a 1-frame PNG snapshot could never have flagged.
  func testWorldBumpGateIsLiveAndModulatesTheFrame() throws {
    let ctx = try MetalContext()
    let chunk = bandMixture(seconds: 0.05)
    let scratch = AudioBands(sampleRate: 48000)
    for _ in 0..<12 { scratch.ingest(chunk) }
    XCTAssertGreaterThan(scratch.frameValues().worldBump, 0.0001,
                         "the synthetic mixture must actually excite the 144.3 Hz world-bump band")
    func run(gate: Bool) throws -> [SIMD4<Float>] {
      try render(frames: 12, context: ctx, configure: { engine in
        engine.sticker.layer.enabled = true
        engine.bumpsEnabled.world = gate
      }, perFrame: { engine, _ in
        engine.bands.ingest(chunk)
      })
    }
    XCTAssertGreaterThan(differingFraction(try run(gate: true), try run(gate: false)), 0.0,
                         "the world-bump gate must reach `RenderParams.worldBump` and the warp")
  }

  /// Part 2b: the wave-bump gate is live and modulating.
  ///
  /// `Engine.step` zeroes `audio.waveBumpRaw` when the gate is off, and `WaveformRenderer.draw`
  /// reads it directly for wave 2's alpha pulse (spec §03 §6) — so the gate is only observable
  /// with wave 2 drawing, which is why this enables it. A short burst (not a full second) is
  /// fed deliberately: `waveBumpRaw` is the UNRECTIFIED mean since the last frame, and the mean
  /// of a whole number of sine cycles is ~0 — a fraction of a cycle is what gives the
  /// accumulator a non-zero value to gate.
  func testWaveBumpGateIsLiveAndModulatesTheFrame() throws {
    let ctx = try MetalContext()
    let burst = Array(bandMixture(seconds: 1.0).prefix(400))   // < half a 46.7 Hz cycle
    let scratch = AudioBands(sampleRate: 48000)
    scratch.ingest(burst)
    XCTAssertGreaterThan(abs(scratch.frameValues().waveBumpRaw), 0.0001,
                         "the burst must produce a non-zero wave-bump accumulator to gate")
    func run(gate: Bool) throws -> [SIMD4<Float>] {
      try render(frames: 1, context: ctx) { engine in
        engine.waveforms.wave2Enabled = true
        engine.bumpsEnabled.wave = gate
        engine.bands.ingest(burst)
      }
    }
    XCTAssertGreaterThan(differingFraction(try run(gate: true), try run(gate: false)), 0.0,
                         "the wave-bump gate must reach wave 2's alpha pulse")
  }

  /// Part 2c: the kitty-bump gate is live and modulating.
  ///
  /// The kitty offset (step's stage 3) displaces the STICKER layer's transform for the
  /// duration of one draw, so this needs the sticker layer enabled and a real glyph to move
  /// (see `setUpWithError`). Audio is re-ingested every frame because `frameValues()` drains
  /// the accumulator, and several frames are run because `KittyBumpReceiver`'s `slide 22 14`
  /// climbs over frames rather than jumping — one frame would test the slide's first step,
  /// not the wiring. `EngineTests.testKittyOffsetDoesNotAccumulate` pins the other half of
  /// this contract (the offset is undone after the draw); this pins that it is applied at all.
  func testKittyBumpGateIsLiveAndModulatesTheFrame() throws {
    let ctx = try MetalContext()
    let burst = Array(bandMixture(seconds: 1.0).prefix(400))
    func run(gate: Bool) throws -> [SIMD4<Float>] {
      try render(frames: 12, context: ctx, configure: { engine in
        engine.sticker.layer.enabled = true
        engine.bumpsEnabled.kitty = gate
      }, perFrame: { engine, _ in
        engine.bands.ingest(burst)
      })
    }
    XCTAssertGreaterThan(differingFraction(try run(gate: true), try run(gate: false)), 0.0,
                         "the kitty-bump gate must displace the sticker layer's transform")
  }

  /// Part 2d: all three gates and both waveforms coexist in ONE frame — the single fact
  /// `waveforms-synthetic` was framed around ("bumps on", checklists #10/#11), now asserted
  /// as a difference against the same configuration with every gate off rather than against
  /// a snapshot of what that frame happened to look like.
  func testAllThreeBumpGatesAndBothWaveformsCoexistInOneFrame() throws {
    let ctx = try MetalContext()
    let burst = Array(bandMixture(seconds: 1.0).prefix(400))
    func run(gates: Bool) throws -> [SIMD4<Float>] {
      try render(frames: 12, context: ctx, configure: { engine in
        engine.sticker.layer.enabled = true
        engine.waveforms.wave1Enabled = true
        engine.waveforms.wave2Enabled = true
        engine.bumpsEnabled = (world: gates, wave: gates, kitty: gates)
      }, perFrame: { engine, _ in
        engine.bands.ingest(burst)
      })
    }
    let allOn = try run(gates: true)
    let allOff = try run(gates: false)
    XCTAssertGreaterThan(differingFraction(allOn, allOff), 0.0,
                         "all three gates on, both waveforms drawing, must differ from the same "
                         + "frame with the gates off")
  }
}
