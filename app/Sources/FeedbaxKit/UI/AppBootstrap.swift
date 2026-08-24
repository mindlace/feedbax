import AVFoundation
import Foundation

/// Everything the instrument needs to start running, factored out of `feedbax-dev/main.swift`
/// (Task 19/20's original wiring) so the `Feedbax.app` bundle (Task 23) can call the exact same
/// engine-assembly logic instead of copy-pasting it: probes the real input hardware's native
/// sample rate, builds `Engine`, applies the webUI-parity startup defaults (spec §04 §1.1),
/// wires up the keyboard/gamepad/operator-panel control surfaces in their tie-breaking order
/// (design §5, spec §04 §1.2 — later surfaces win ties, so keyboard/gamepad/operator-panel is
/// deliberate), and starts best-effort live microphone capture. Both entry points still write
/// their own `App`/`ContentView` — that part is legitimately different per bundle (see
/// `feedbax-dev/main.swift`'s `AppDelegate` comment for why the unbundled executable needs
/// extra activation-policy plumbing that a real `.app` bundle gets for free from Launch
/// Services) — but the "what does the engine actually consist of" logic now exists exactly
/// once.
public final class AppBootstrap {
  public let engine: Engine
  public let keyboardSurface: KeyboardTrackpadSurface
  public let viewModel: EngineViewModel

  /// Kept alive purely so ARC doesn't tear down the mic tap the instant `start()` returns —
  /// nothing reads this property directly; `AudioBands` (owned by `engine`) is the interface
  /// analysis results actually flow through. Optional because starting it is best-effort: a
  /// machine with no input device, or a user who denies mic permission, still gets a working
  /// (silent) instrument rather than a crash.
  private let audioAnalysis: AudioAnalysis?

  private init(
    engine: Engine, keyboardSurface: KeyboardTrackpadSurface, viewModel: EngineViewModel,
    audioAnalysis: AudioAnalysis?
  ) {
    self.engine = engine
    self.keyboardSurface = keyboardSurface
    self.viewModel = viewModel
    self.audioAnalysis = audioAnalysis
  }

  /// Throws whatever `MetalContext`/`Engine`/`BindingsLoader` throw. There's no windowed way to
  /// recover from "the GPU context couldn't be built" or "the default bindings failed to
  /// decode," so callers are expected to print and exit, the way `feedbax-dev` always has.
  public static func start() throws -> AppBootstrap {
    // Query the real input hardware's native sample rate BEFORE building `Engine` —
    // `AudioBands`' biquads are tuned in Hz and only select the right band (spec §03 §3) if
    // analysis runs at the rate samples actually arrive at. A throwaway `AVAudioEngine` is the
    // standard way to ask CoreAudio "what's the default input's native format" without opening
    // a persistent tap; `inputFormat` reports 0 when no input device is available (e.g. a
    // CI/headless machine), so that falls back to the spec's 48 kHz target rather than building
    // `AudioBands` at a nonsense rate.
    let probeSampleRate = AVAudioEngine().inputNode.inputFormat(forBus: 0).sampleRate
    let audioSampleRate: Float = probeSampleRate > 0 ? Float(probeSampleRate) : 48000

    let context = try MetalContext()
    let engine = try Engine(context: context, audioSampleRate: audioSampleRate)
    // Reproduces the original's webUI loadbang (spec §04 §1.1) — the exact vector every fresh
    // session actually starts from.
    engine.router.applyStartupDefaults(at: 0)

    let bindings = try BindingsLoader.load(from: nil)
    let keyboard = KeyboardTrackpadSurface(bindings: bindings)
    let gamepad = GamepadSurface()
    // `EngineViewModel` (Task 20) is registered exactly like keyboard/gamepad — design §5's
    // "the operator UI is a surface, not a privileged path": it queues slot writes/toggles into
    // `poll` the same way a key press or a stick tilt does, and `ControlRouter.tick` arbitrates
    // it with last-write-wins like any other surface.
    let viewModel = EngineViewModel(engine: engine, presetStore: PresetStore())
    // Order matters: later surfaces win ties (`ControlRouter`'s last-writer-wins arbitration,
    // spec §04 §1.2) — keyboard first, gamepad second, operator panel last, so an explicit
    // slider move by the person actually running the show always overrides a merely-held key or
    // stick, matching the "tracked source primary" precedent design §5 sets for the Leap-style
    // arbitration this baseline doesn't implement yet.
    engine.router.surfaces = [keyboard, gamepad, viewModel]

    // Live microphone input is deliberately NOT part of `Engine` (design/Task 19: `Engine.step`
    // must stay pure and injectable for the determinism test/golden harness). `AudioAnalysis` is
    // the one place this codebase touches `AVAudioEngine`, and it only ever starts here, when a
    // real entry point runs — never in a test.
    let audioAnalysis = try? AudioAnalysis(bands: engine.bands)
    try? audioAnalysis?.start()

    return AppBootstrap(
      engine: engine, keyboardSurface: keyboard, viewModel: viewModel, audioAnalysis: audioAnalysis
    )
  }
}
