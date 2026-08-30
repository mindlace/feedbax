import AVFoundation
import Foundation

/// Everything the instrument needs to start running, factored out of `feedbax-dev/main.swift`
/// (Task 19/20's original wiring) so the `Feedbax.app` bundle (Task 23) can call the exact same
/// engine-assembly logic instead of copy-pasting it: probes the real input hardware's native
/// sample rate, builds `Engine`, applies the webUI-parity startup defaults (spec §04 §1.1),
/// wires up the keyboard/gamepad/operator-panel control surfaces in their tie-breaking order
/// (design §5, spec §04 §1.2 — later surfaces win ties, so keyboard/gamepad/operator-panel is
/// deliberate), starts the always-running `EngineHost` and its `PerformerInputMonitor`, and
/// starts best-effort live microphone capture. `FeedbaxScenes` (Task 5) is the one place both
/// entry points build their window layout — the only thing each bundle still writes for itself
/// is its own tiny `App` struct's `body` (`FeedbaxScenes(bootstrap:)`, verbatim) and, for the
/// unbundled `feedbax-dev` executable, the `AppDelegate` activation-policy plumbing a real `.app`
/// bundle gets for free from Launch Services (see that file's own comment on why). Everything
/// about "what does the engine actually consist of" — and now "what windows does it have" —
/// exists exactly once.
public final class AppBootstrap {
  public let engine: Engine
  public let keyboardSurface: KeyboardTrackpadSurface
  public let viewModel: EngineViewModel
  public let host: EngineHost
  public let inputMonitor: PerformerInputMonitor
  public let bindingsStore: BindingsStore

  /// Kept alive purely so ARC doesn't tear down the mic tap the instant `start()` returns —
  /// nothing reads this property directly; `AudioBands` (owned by `engine`) is the interface
  /// analysis results actually flow through. `AudioAnalysis.init` cannot fail (it just stores
  /// `bands`); starting it is what's best-effort — a machine with no input device, or a user
  /// who denies mic permission, still gets a working (silent) instrument rather than a crash.
  private let audioAnalysis: AudioAnalysis

  private init(
    engine: Engine, keyboardSurface: KeyboardTrackpadSurface, viewModel: EngineViewModel,
    host: EngineHost, inputMonitor: PerformerInputMonitor, audioAnalysis: AudioAnalysis,
    bindingsStore: BindingsStore
  ) {
    self.engine = engine
    self.keyboardSurface = keyboardSurface
    self.viewModel = viewModel
    self.host = host
    self.inputMonitor = inputMonitor
    self.audioAnalysis = audioAnalysis
    self.bindingsStore = bindingsStore
  }

  /// Throws whatever `MetalContext`/`Engine`/`BindingsLoader` throw. There's no windowed way to
  /// recover from "the GPU context couldn't be built" or "the default bindings failed to
  /// decode," so callers are expected to print and exit, the way `feedbax-dev` always has.
  public static func start() throws -> AppBootstrap {
    let audioSampleRate = probeInputSampleRate()

    let context = try MetalContext()
    let engine = try Engine(context: context, audioSampleRate: audioSampleRate,
                            stickerFolder: Self.resolveStickerFolder())
    // Reproduces the original's webUI loadbang (spec §04 §1.1) — the exact vector every fresh
    // session actually starts from.
    engine.router.applyStartupDefaults(at: 0)
    // `applyStartupDefaults` carries slots, layer axes and erase, but no toggles — so without
    // this the image layer stayed off through every GUI launch and the sticker picker looked
    // broken (see `Engine.enableImageLayerIfStocked`).
    engine.enableImageLayerIfStocked()

    // The performer's own table wins over the bundled default (design §6.6); the same store
    // is what the operator panel writes pad reassignments through.
    let bindingsStore = try BindingsStore(userFileURL: BindingsStore.defaultUserFileURL)
    let bindings = bindingsStore.bindings
    // Single source of truth for every flip-carrying toggle (final review, finding 4) — both
    // flip-memory surfaces below query this instead of keeping their own independent on/off
    // memory, which is what let keyboard/gamepad/operator-panel drift out of sync with each
    // other (a keyboard `i` press could flip the router's real SInvert state while the panel's
    // toggle kept showing the OLD value, and the panel's own next click then asserted a flip
    // computed from that stale value on top of an already-flipped truth). See
    // `ControlStateSnapshot`'s own doc comment.
    let stateSnapshot = ControlStateSnapshot(
      sInvert: { engine.router.sInvert < 0 },
      worldBumpEnabled: { engine.bumpsEnabled.world },
      waveBumpEnabled: { engine.bumpsEnabled.wave },
      imageBumpEnabled: { engine.bumpsEnabled.image },
      wave1Enabled: { engine.waveforms.wave1Enabled },
      wave2Enabled: { engine.waveforms.wave2Enabled },
      layerEnabled: { engine.sticker.layer.enabled },
      // Relative trackpad gestures nudge from HERE (design §5), not from a private accumulator.
      rawValue: { engine.router.rawValue(for: $0) })
    let keyboard = KeyboardTrackpadSurface(bindings: bindings, stateSnapshot: stateSnapshot)
    let gamepad = GamepadSurface(stateSnapshot: stateSnapshot)
    // `EngineViewModel` (Task 20) is registered exactly like keyboard/gamepad — design §5's
    // "the operator UI is a surface, not a privileged path": it queues slot writes/toggles into
    // `poll` the same way a key press or a stick tilt does, and `ControlRouter.tick` arbitrates
    // it with last-write-wins like any other surface. Its own toggle mirrors reconcile from the
    // same truth every poll (`EngineViewModel.refreshMirrorsFromTruth`) rather than through this
    // `ControlStateSnapshot` — it already holds `engine` directly, so a second indirection would
    // buy nothing.
    let viewModel = EngineViewModel(engine: engine, presetStore: PresetStore(), bindingsStore: bindingsStore)
    // Order matters: later surfaces win ties (`ControlRouter`'s last-writer-wins arbitration,
    // spec §04 §1.2) — keyboard first, gamepad second, operator panel last, so an explicit
    // slider move by the person actually running the show always overrides a merely-held key or
    // stick, matching the "tracked source primary" precedent design §5 sets for the Leap-style
    // arbitration this baseline doesn't implement yet.
    engine.router.surfaces = [keyboard, gamepad, viewModel]

    // The host owns the clock from here on, and starts stepping BEFORE any window exists —
    // that ordering is the point of the split (spec goal 2). `OutputStage` construction now
    // throws out of here instead of being swallowed by `try?` inside the render view.
    let host = try EngineHost(engine: engine)
    host.start()
    host.hudEnabled = viewModel.hudEnabled
    viewModel.host = host

    let inputMonitor = PerformerInputMonitor(
      surface: keyboard, outputWindow: { [weak host] in host?.attachedWindow })
    inputMonitor.install()

    // Live microphone input is deliberately NOT part of `Engine` (design/Task 19: `Engine.step`
    // must stay pure and injectable for the determinism test/golden harness). `AudioAnalysis` is
    // the one place this codebase touches `AVAudioEngine`, and it only ever starts here, when a
    // real entry point runs — never in a test.
    let audioAnalysis = AudioAnalysis(bands: engine.bands)
    do {
      try audioAnalysis.start()
      engine.audioStatus = audioAnalysis.statusText
    } catch {
      // A missing device or a denied permission must be VISIBLE (HUD), not a silent instrument.
      engine.audioStatus = "mic FAILED: \(error.localizedDescription)"
    }

    return AppBootstrap(
      engine: engine, keyboardSurface: keyboard, viewModel: viewModel, host: host,
      inputMonitor: inputMonitor, audioAnalysis: audioAnalysis, bindingsStore: bindingsStore
    )
  }

  /// Queries the real input hardware's native sample rate, which `start()` needs BEFORE building
  /// `Engine` — `AudioBands`' biquads are tuned in Hz and only select the right band (spec §03
  /// §3) if analysis runs at the rate samples actually arrive at. A short-lived `AVAudioEngine`
  /// is the standard way to ask CoreAudio "what's the default input's native format" without
  /// opening a persistent tap; `inputFormat` reports 0 when no input device is available (e.g. a
  /// CI/headless machine), so that falls back to the spec's 48 kHz target rather than building
  /// `AudioBands` at a nonsense rate.
  ///
  /// Internal rather than private so `AppBootstrapTests` can call it — the rest of `start()`
  /// needs a GPU and a window server, but this probe is exactly the part that was crashing, and
  /// it is testable on its own.
  /// The engine MUST be bound to a local and explicitly kept alive across the `inputFormat`
  /// call. Written as the obvious one-liner
  /// (`AVAudioEngine().inputNode.inputFormat(forBus: 0)`) this segfaults on launch, every time:
  /// ARC's last use of the engine is the `inputNode` getter, and `AVAudioInputNode` does NOT
  /// retain the engine that vends it, so the engine is released while the returned node is
  /// still in flight and `inputFormat(forBus:)` dereferences a freed `AVAudioIONodeImpl`.
  /// `AudioAnalysis` never hit this because it holds its engine in a stored property.
  static func probeInputSampleRate() -> Float {
    let probeEngine = AVAudioEngine()
    let probeSampleRate = probeEngine.inputNode.inputFormat(forBus: 0).sampleRate
    withExtendedLifetime(probeEngine) {}
    return probeSampleRate > 0 ? Float(probeSampleRate) : 48000
  }

  /// Resolves where the sticker folder actually lives for a REAL entry point (final review,
  /// finding 1). `Engine.init`'s own CWD-relative default (`input/transparent-background/`)
  /// only resolves to anything when the process's current working directory is a repo checkout
  /// — `swift run`'s case, and every existing test's (`EngineTests`, `EngineViewModelTests`
  /// changeCurrentDirectoryPath to a fixture, or just tolerate a missing folder). A
  /// Finder-launched `Feedbax.app` bundle's CWD is `/` (Task 23), so that default resolves to a
  /// folder that can never exist and the instrument silently starts with `sticker.itemCount ==
  /// 0` no matter how many PNGs the performer actually has.
  ///
  /// Prefers the CWD-relative folder when it's actually there — so a repo checkout with
  /// `input/transparent-background/` populated keeps behaving exactly as it always has, no
  /// migration needed for the `swift run` workflow. Otherwise falls back to
  /// `~/Pictures/Feedbax/stickers/` — a real, discoverable location a performer can drop PNGs
  /// into without touching the app bundle's own Resources (which Gatekeeper/notarization
  /// wouldn't allow writing to at runtime anyway), created on demand so a fresh install has
  /// *somewhere* to scan. An empty freshly-created folder degrades the same way the CWD-relative
  /// fallback always has — `itemCount == 0`, `StickerSource.init`'s own "nothing to show yet"
  /// tolerance, not a crash or a thrown error.
  private static func resolveStickerFolder() -> URL {
    let cwdFolder = URL(fileURLWithPath: "input/transparent-background", isDirectory: true)
    if FileManager.default.fileExists(atPath: cwdFolder.path) {
      return cwdFolder
    }
    let picturesFolder = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("Feedbax/stickers", isDirectory: true)
    try? FileManager.default.createDirectory(at: picturesFolder, withIntermediateDirectories: true)
    return picturesFolder
  }
}
