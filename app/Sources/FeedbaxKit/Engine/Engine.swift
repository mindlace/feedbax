import Metal
import Foundation
import simd

/// Which of P1's two mutually-exclusive picsvid sources is currently live — the port's
/// resolution of the original's camera-vs-picture either/or into "the parity configuration
/// of *one* layer, a single explicit mode switch" (design §5's `SeedSource` section). `Engine
/// .step` ticks and draws only the active source; the inactive one is never touched, so
/// switching modes costs nothing beyond flipping this enum.
public enum LayerMode: Equatable {
  case sticker
  case movie

  /// `Preset.layerMode`'s persisted form (Task 19 fix — presets didn't capture/restore this
  /// at all until now). A plain string round trip, not `RawRepresentable`, so a preset file
  /// from a future build with a mode this one doesn't know degrades to `.sticker` on decode
  /// (`fromPresetIdentifier`'s fallback) instead of failing the whole preset load.
  public var presetIdentifier: String { self == .sticker ? "sticker" : "movie" }

  public static func fromPresetIdentifier(_ raw: String) -> LayerMode {
    raw == "movie" ? .movie : .sticker
  }
}

/// The assembled instrument (Task 19): owns every piece built in Tasks 1–18 and wires them
/// into one per-frame recipe. This is intentionally the *only* place that recipe is written
/// out — `step`'s five numbered stages below are, line for line, the frame algorithm from
/// design §4 and spec §01 §1.
///
/// `step` is pure with respect to its `time` argument and everything already set on `Engine`
/// (router state, toggles, layer mode, resolution): no wall clock, no live microphone, no
/// randomness. That purity is what makes `EngineTests.testDeterministicHeadlessRun` — two
/// engines fed an identical injected clock landing on byte-identical accumulators — hold, and
/// it's the property Task 22's golden-frame harness is built on top of. A live microphone
/// (`AudioAnalysis`) is deliberately NOT owned here; it's an app-layer concern
/// (`feedbax-dev/main.swift`) that feeds this engine's `bands` from the outside, exactly the
/// way `EngineTests` feeds synthetic silence by never calling it at all.
public final class Engine {
  public let context: MetalContext
  private let core: FeedbackCore
  public let compositor: Compositor
  public let router = ControlRouter()
  public let sticker: StickerSource
  public let movie: MovieSource
  public let bands: AudioBands
  public let waveforms: WaveformRenderer
  /// The webUI receiver half of the kittybump modulator (spec §04 §1.3) — `AudioBands`
  /// produces the raw, unrectified per-frame mean; this is the `abs` + `slide 22/14` that
  /// turns it into the offset actually applied to the sticker transform (step 3 of `step`).
  private let kittyReceiver = KittyBumpReceiver()

  /// Per-layer filter chains (design §5's `TextureFilter`/`FilterChain`) — owned here, not on
  /// `SeedSource`, because no source implementation exposes one yet (`Presets.swift`'s note on
  /// `PresetFilterParams.capture`). P1's parity default for both is EMPTY: sticker and movie
  /// pass file alpha straight through, matching the original (design §5's "Parity defaults per
  /// layer" table); golden scenarios (Task 22) attach filters to these explicitly.
  public var stickerFilters = FilterChain()
  public var movieFilters = FilterChain()

  /// The either-or switch (see `LayerMode`'s doc). Defaults to `.sticker` — the folder-scan
  /// source is populated without any network/file-selection action, so it's the more useful
  /// thing to be staring at on a cold start.
  public var layerMode: LayerMode = .sticker

  /// All three audio-follower gates, default OFF (spec §03 §7/§10 — "Bump enables: all three
  /// default OFF"). Kept as one grouped tuple, not three separate properties, because they're
  /// always read/written together (preset capture/recall, the toggle handler below).
  public var bumpsEnabled: (world: Bool, wave: Bool, kitty: Bool) = (false, false, false)

  /// Render tick rate — `FrameClock` (the display-link wrapper) reads this to pin its
  /// `preferredFrameRateRange`. Any of `frameRatePresets` in normal operation; not validated
  /// here (the operator UI, Task 20, is what constrains the picker) since a test harness may
  /// legitimately want an odd rate.
  public var frameRate: Int = 60

  /// Feedback resample filter (diagnosis doc, term 1). `.nearest` is parity; `.linear` exists
  /// only so the two can be A/B'd live from the operator panel.
  public var warpFilter: WarpFilter = .nearest

  /// One-line capture status for the HUD, set by whoever starts `AudioAnalysis`
  /// (`AppBootstrap`). Not engine state — the engine never touches the microphone.
  public var audioStatus = "mic: not started"

  /// Current canvas size — what `setResolution` changes and what every frame's `FrameContext
  /// .canvasSize` carries. Read-only from outside `Engine`; the only way to change it is
  /// `setResolution`, which also reallocates the accumulator (`FeedbackCore.resize`).
  public private(set) var resolution: SIMD2<Int>

  /// The movie layer's currently-loaded file, if any — `MovieSource` itself doesn't retain
  /// this (see `MovieSource.load(url:)`), but `capturePreset` needs a real path to save,
  /// not Task 12's `PresetStore.capture` placeholder empty string. Set only by `loadMovie`.
  public private(set) var currentMoviePath: String?

  private var frameIndex = 0

  /// Cold-start canvas: 1080p — the resolution `fst`'s creation string defaults to, and the
  /// one no `loadmess` ever overrides at patch load (spec §01 §1).
  private static let defaultResolution = SIMD2(1920, 1080)

  /// The 14 distinct `dim W H` presets wired to `s resolution` in the original (spec §04 §1
  /// table; one physical duplicate — `5120×1440` appears on two message boxes — collapses to
  /// one entry here, same as the spec's own "14 distinct resolutions" count). "Custom" (the
  /// Constants table's 15th list entry) isn't a fixed value, so it isn't represented as an
  /// array element — `setResolution` already accepts any size, custom or not.
  public static let resolutionPresets: [SIMD2<Int>] = [
    SIMD2(1024, 768),
    SIMD2(1280, 720),
    SIMD2(1280, 800),
    SIMD2(1366, 1024),
    SIMD2(1920, 1080),
    SIMD2(2560, 1080),
    SIMD2(2560, 1440),
    SIMD2(2560, 1600),
    SIMD2(2880, 1620),
    SIMD2(3440, 1440),
    SIMD2(3840, 2160),
    SIMD2(5120, 1440),
    SIMD2(7680, 4320),
    SIMD2(8192, 8192),
  ]

  /// The 5 `FPSconfig` presets (spec §01 §1: "five presets, not four" — `100`'s message box
  /// sits slightly off in the original's layout and is easy to miss on a first pass).
  public static let frameRatePresets = [30, 60, 90, 100, 120]

  /// Builds every owned component at their cold-start defaults. Does NOT call
  /// `router.applyStartupDefaults` — callers (tests, `feedbax-dev/main.swift`) do that
  /// explicitly once construction succeeds, the same way `EngineTests` does, so a caller that
  /// wants a bare-zero router (a unit test isolating one piece of behavior) isn't forced
  /// through the startup vector first.
  ///
  /// `audioSampleRate` is the rate `AudioBands`' biquads are tuned for — it must match
  /// whatever rate samples actually arrive at, or the fixed-Hz bandpass filters (46.7/60.0/
  /// 144.3 Hz, spec §03 §3) select the wrong band entirely. Spec §03 §2 targets 48 kHz mono,
  /// the default here; a caller with a real input device (`feedbax-dev/main.swift`) should
  /// query that device's actual native rate BEFORE constructing `Engine` and pass it in —
  /// there is no reconciliation path AFTER construction (an earlier version of this comment
  /// claimed `AudioAnalysis` reconstructs `AudioBands` internally at the hardware rate; it
  /// does not — `AudioAnalysis.init(bands:)` takes an already-built `AudioBands` and never
  /// replaces it).
  ///
  /// `accumulatorFormat` — shared by `FeedbackCore`, the compositor's `QuadRenderer`, and
  /// `WaveformRenderer` (Task 18's ruling: a render pipeline's color-attachment format is
  /// fixed at build time, so every draw target sharing one render pass must agree, or Metal
  /// validation fails at draw time, not at pipeline-creation time) — defaults to `.rgba8Unorm`,
  /// the original's effective depth (design §4's "RGBA8 accumulator by default"). Exposed as an
  /// init parameter, not hardcoded, so the RGBA16F quality-toggle headroom design §4 calls out
  /// ("RGBA16F as a quality toggle where bandwidth allows") is actually reachable — currently
  /// by `feedbax-dev --soak --accumulator-format rgba16f` (Task 24); no live UI toggle yet.
  /// `stickerFolder` — nil (every existing call site) reproduces the ORIGINAL CWD-relative
  /// default exactly, so every test that relies on `swift test`'s ambient working directory (or
  /// on `changeCurrentDirectoryPath` to a fixture) keeps passing unchanged. A caller that knows
  /// the CWD-relative default won't resolve to anything real — `AppBootstrap.start()`, finding 1
  /// of the final review: a Finder-launched `Feedbax.app` bundle's CWD is `/`, which
  /// `input/transparent-background` can never exist under — passes an explicit URL instead.
  public init(context: MetalContext, audioSampleRate: Float = 48000,
              accumulatorFormat: MTLPixelFormat = .rgba8Unorm,
              stickerFolder: URL? = nil) throws {
    self.context = context
    let format = accumulatorFormat
    let size = Engine.defaultResolution
    self.resolution = size

    self.core = try FeedbackCore(context: context, size: size, format: format)
    self.compositor = Compositor(quad: try QuadRenderer(context: context, pixelFormat: format))
    self.bands = AudioBands(sampleRate: audioSampleRate)
    self.waveforms = try WaveformRenderer(context: context, pixelFormat: format)

    // Sticker folder: default is `input/transparent-background/` resolved against the CURRENT
    // WORKING DIRECTORY (controller ruling, not the app bundle or source root) —
    // `URL(fileURLWithPath:)` resolves a relative string against
    // `FileManager.default.currentDirectoryPath` for us. That default only makes sense for a
    // process whose CWD is a repo checkout (`swift run`, `swift test`); a real caller resolves
    // the folder itself and passes it in via `stickerFolder` (see that parameter's doc comment
    // above). A missing folder is tolerated either way: `StickerSource.init` scans and comes up
    // with `itemCount == 0` rather than throwing (see its own doc comment), which is exactly the
    // "nothing to show yet" state a fresh checkout/install with no populated folder should
    // render as.
    let resolvedStickerFolder = stickerFolder
      ?? URL(fileURLWithPath: "input/transparent-background", isDirectory: true)
    self.sticker = StickerSource(context: context, folder: resolvedStickerFolder)
    self.movie = MovieSource(context: context)

    // Both registered for the compositor's shared z-order/projection machinery (`drawSeeds`'s
    // `byId` lookup); `step` only ever ticks and draws whichever one `layerMode` selects, so
    // this registration costs nothing for the inactive source.
    compositor.layers = [sticker, movie]

    // Set last: `toggleHandler` closes over `self`, so every other stored property must
    // already hold a value (Swift's two-phase init) before this line runs.
    router.toggleHandler = { [weak self] event in self?.handle(event) }
  }

  /// One tick: router → audio `frameValues` → sources tick → `core.renderFrame`. Pure with
  /// respect to the injected clock — golden tests (and `EngineTests`) drive this directly,
  /// never through `FrameClock`.
  ///
  /// The frame recipe (design §4, spec §01 §1 — ordering is load-bearing; see also
  /// `FeedbackCore.renderFrame`'s own 5-step doc comment for what happens once this hands off
  /// to it):
  public func step(at time: TimeInterval, commandBuffer: MTLCommandBuffer) -> MTLTexture {
    // 1. Sample audio once per frame — the ctrlbang/audiobang cadence (spec §03 §7): every
    // downstream consumer this frame (the world bump, the two waveforms, the kitty offset)
    // reads from this SAME snapshot, not three independently-timed samples.
    var audio = bands.frameValues()

    // 2. Router → smoothed, mapped `RenderParams`, then the world-bump gate. All three bump
    // gates default off (spec §03 §7/§10); a disabled gate contributes exactly 0, not a
    // damped-toward-zero value — there's no partial bump.
    var params = router.tick(at: time)
    params.warpFilter = warpFilter
    params.worldBump = bumpsEnabled.world ? audio.worldBump : 0
    // waveBump gates the same way, mirrored onto the audio snapshot itself (rather than a
    // local passed separately) because `waveforms.draw` below reads `audio.waveBumpRaw`
    // directly for wave 2's alpha pulse (spec §03 §6) — zeroing it here, once, is what keeps
    // that draw call from needing its own gate check.
    audio.waveBumpRaw = bumpsEnabled.wave ? audio.waveBumpRaw : 0

    // 3. Kitty offset: an ADDITIVE, non-persistent modulator contribution on top of the
    // sticker layer's manual transform (design §5's Modulator rule; spec §04 §1.3) — it
    // never becomes the new manual value, so it must not accumulate frame over frame. The
    // transform is mutated only for the duration of this frame's draw and restored below,
    // rather than threading a separate "effective transform" through the compositor (which
    // reads `SeedSource.transform` directly and has no such parameter).
    let baseStickerTransform = sticker.transform
    if bumpsEnabled.kitty {
      let offset = kittyReceiver.process(audio.kittyBumpRaw)
      sticker.transform.scale.x += offset
      sticker.transform.scale.y += offset
      sticker.transform.position.y += offset
    }

    let frame = FrameContext(index: frameIndex, time: time, delta: 1.0 / Double(frameRate),
                             canvasSize: resolution, commandBuffer: commandBuffer, pool: context.pool)
    frameIndex += 1

    // 4. Active layer = the one `layerMode` selects (the either-or, ONE switch — design §5).
    // Ticking (and its filter chain) is skipped entirely when that layer is disabled, mirroring
    // `Compositor.collectTextures`'s own "disabled sources don't pay decode cost" rule — most
    // relevant for the movie layer, whose tick can touch AVFoundation.
    let activeSource: SeedSource = layerMode == .sticker ? sticker : movie
    let activeFilters = layerMode == .sticker ? stickerFilters : movieFilters
    var textures: [String: MTLTexture] = [:]
    if activeSource.layer.enabled, let raw = activeSource.tick(frame) {
      textures[activeSource.id] = activeFilters.apply(raw, frame)   // P1 default chains: empty
    }

    // 5. `core.renderFrame` runs the erase/warp/composite recipe; `drawSeeds` draws the active
    // layer (if any) under the warped past, and the waveform overlay draws in the same pass,
    // sharing the one projection every world-space draw this frame uses.
    let canvasAspect = Float(resolution.x) / Float(resolution.y)
    let projection = Compositor.projection(canvasAspect: canvasAspect)
    let result = core.renderFrame(frame, params: params) { enc in
      compositor.drawSeeds(enc, frame: frame, textures: textures)
      waveforms.draw(enc, frame: frame, audio: audio, projection: projection)
    }

    sticker.transform = baseStickerTransform   // undo step 3's temporary, additive-only offset
    return result
  }

  /// Live re-size to any of `resolutionPresets` or a custom size (the Constants table's 15th,
  /// unlisted "custom" entry — accepted here the same as a preset, no validation). Reallocates
  /// and clears both accumulators (`FeedbackCore.resize`).
  ///
  /// **Hazard, carried forward from Task 8's review:** call this only BETWEEN frames — i.e.
  /// never from inside the closure passed to `core.renderFrame`, and never while a command
  /// buffer from a prior `step` may still have GPU work in flight on the accumulator this
  /// replaces. `EngineTests`/the operator UI (Task 20) both only ever call it before the next
  /// `step`, which is the only currently-supported call pattern.
  public func setResolution(_ size: SIMD2<Int>) {
    core.resize(size, eraseColor: .zero)
    resolution = size
  }

  /// Starts looped playback of `url` on the movie layer and records its path — the only way
  /// `capturePreset` can report a real `.moviePath` selection instead of Task 12's
  /// `PresetStore.capture` placeholder (an empty string; see that method's own doc comment).
  public func loadMovie(url: URL) {
    movie.load(url: url)
    currentMoviePath = url.path
  }

  // MARK: - Toggle routing (spec §01 §4's toggle table, minus `.sInvert` — `ControlRouter`
  // consumes that one itself and never forwards it here)

  private func handle(_ event: ToggleEvent) {
    switch event {
    case .worldBumpEnabled(let on): bumpsEnabled.world = on
    case .waveBumpEnabled(let on): bumpsEnabled.wave = on
    case .kittyBumpEnabled(let on): bumpsEnabled.kitty = on
    case .wave1Enabled(let on): waveforms.wave1Enabled = on
    case .wave2Enabled(let on): waveforms.wave2Enabled = on
    case .layerEnabled(let on):
      // The original's "pic enable" toggle (spec §04 §1.4: default off, nothing draws until
      // turned on) — both sources share one flag rather than each tracking its own, because
      // only the ACTIVE one (`layerMode`) is ever ticked/drawn; the inactive one's flag is
      // inert. Keeping them in lockstep means a mode switch doesn't silently also flip the
      // enable state the performer just set.
      sticker.layer.enabled = on
      movie.layer.enabled = on
    case .fullscreen:
      break   // one-shot UI action — `PreviewView` (fullscreen)
    case .stillCapture:
      // Task 21: write the last completed frame to ~/Pictures/Feedbax/ as a dated PNG.
      // Synchronous by design: readPixels → waitUntilCompleted → CGImage write. The hitch this
      // causes scales with canvas size, not a flat "~one frame" — `readPixels` materializes the
      // WHOLE accumulator into host memory and the PNG encode runs on the same thread before
      // this call returns, so at 1080p it's roughly a frame's worth of stall, but at 8K
      // (7680×4320, `resolutionPresets`' largest entry) `readPixels` alone moves on the order of
      // a gigabyte and the encode is proportionally heavier — a visible, multi-second pause, not
      // a one-frame hitch (final review's recalibration — the original estimate was off by
      // orders of magnitude at the top of the resolution range). Still deliberately synchronous:
      // async would race the ping-pong accumulator reuse (FeedbackCore's double-buffer flips
      // next frame, so an in-flight async blit could read overwritten data) — that rationale
      // stands regardless of how long the stall actually is. Failures logged, never crash.
      do {
        _ = try StillCapture.write(core.accumulator, context: context, directory: nil,
                                   date: Date())
      } catch {
        print("Still capture failed: \(error)")
      }
    case .sInvert:
      break   // unreachable: `ControlRouter.mergeAndProcess` never forwards this one
    }
  }

  // MARK: - Presets (closes the Task 12 gap: `PresetStore.capture`'s toggles/sourceSelection/
  // filters were caller-override placeholders — see that method's doc comment — because
  // nothing yet exposed bump enables, layer mode, source selection, or a filter chain. `Engine`
  // is that caller.)

  /// Captures a complete, restorable snapshot of the currently performing state (design §5
  /// Presets). Starts from `PresetStore.capture`'s best-effort `Preset` (which gets the 9-slot
  /// vector, erase, and SInvert right already) and overwrites every field that method could
  /// only stub with the real, live value only `Engine` has visibility into.
  public func capturePreset(name: String) -> Preset {
    var preset = PresetStore.capture(name: name, router: router, layers: [sticker, movie])
    preset.toggles.worldBump = bumpsEnabled.world
    preset.toggles.waveBump = bumpsEnabled.wave
    preset.toggles.kittyBump = bumpsEnabled.kitty
    preset.toggles.wave1 = waveforms.wave1Enabled
    preset.toggles.wave2 = waveforms.wave2Enabled
    // Sticker/movie `.enabled` are kept in lockstep by `handle(.layerEnabled:)` above, so
    // either one reads the same single logical flag.
    preset.toggles.layerEnabled = sticker.layer.enabled
    preset.layerMode = layerMode.presetIdentifier
    preset.layers = preset.layers.map { layer in
      var layer = layer
      if layer.id == sticker.id {
        layer.sourceSelection = .stickerIndex(sticker.selectedIndex)
        layer.filters = stickerFilters.filters.compactMap(PresetFilterParams.capture(from:))
      } else if layer.id == movie.id {
        layer.sourceSelection = .moviePath(currentMoviePath ?? "")
        layer.filters = movieFilters.filters.compactMap(PresetFilterParams.capture(from:))
      }
      return layer
    }
    return preset
  }

  /// Recalls a preset. `PresetStore.apply` restores the 9-slot vector (ramped), erase, and
  /// per-layer transform/settings (snapped) already; this restores the fields that method
  /// can't reach — the same gap `capturePreset` closes on the way out.
  public func applyPreset(_ preset: Preset, at time: TimeInterval) {
    PresetStore.apply(preset, router: router, layers: [sticker, movie], at: time)
    layerMode = LayerMode.fromPresetIdentifier(preset.layerMode)
    bumpsEnabled = (world: preset.toggles.worldBump, wave: preset.toggles.waveBump,
                    kitty: preset.toggles.kittyBump)
    waveforms.wave1Enabled = preset.toggles.wave1
    waveforms.wave2Enabled = preset.toggles.wave2
    sticker.layer.enabled = preset.toggles.layerEnabled
    movie.layer.enabled = preset.toggles.layerEnabled
    for layer in preset.layers {
      switch (layer.id, layer.sourceSelection) {
      case (sticker.id, .stickerIndex(let index)):
        sticker.selectedIndex = index
      case (movie.id, .moviePath(let path)) where !path.isEmpty:
        loadMovie(url: URL(fileURLWithPath: path))
      default:
        break
      }
      // Filter params restore positionally onto whatever's already in the chain (the preset
      // doesn't reconstruct filter OBJECTS, only parameters for existing ones — same contract
      // `PresetFilterParams.apply(to:)` documents). P1's empty default chains make this a
      // no-op both ways; golden scenarios that attach filters explicitly get them restored.
      if layer.id == sticker.id {
        for (filter, params) in zip(stickerFilters.filters, layer.filters) { params.apply(to: filter) }
      } else if layer.id == movie.id {
        for (filter, params) in zip(movieFilters.filters, layer.filters) { params.apply(to: filter) }
      }
    }
  }
}
