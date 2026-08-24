import SwiftUI
import AppKit
import AVFoundation
import Foundation
import FeedbaxKit

// `--soak` is parsed here so it doesn't leak through to AppKit/SwiftUI's own argv handling as
// an unrecognized argument, but the sustained-run soak-testing mode itself doesn't exist until
// Task 24 (design §10's later phase) — for now this just runs the normal windowed app.
let soakRequested = CommandLine.arguments.contains("--soak")
if soakRequested {
  print("feedbax-dev: --soak is parsed but not yet implemented (arrives in Task 24); " +
        "running the normal windowed app instead.")
}

// Query the real input hardware's native sample rate BEFORE building `Engine` —
// `AudioBands`' biquads are tuned in Hz and only select the right band (spec §03 §3) if
// analysis runs at the rate samples actually arrive at. An earlier version of this file
// hardcoded 48 kHz with a comment claiming a post-construction reconciliation path that
// didn't actually exist; `Engine.init(context:audioSampleRate:)` now takes the rate up
// front instead. A throwaway `AVAudioEngine` is the standard way to ask CoreAudio "what's
// the default input's native format" without opening a persistent tap; `inputFormat`
// reports 0 when no input device is available (e.g. a CI/headless machine), so that falls
// back to the spec's 48 kHz target rather than building `AudioBands` at a nonsense rate.
let probeSampleRate = AVAudioEngine().inputNode.inputFormat(forBus: 0).sampleRate
let audioSampleRate: Float = probeSampleRate > 0 ? Float(probeSampleRate) : 48000

// Engine assembly (Task 19): everything the instrument needs to render is built here, once,
// before the window opens. `applyStartupDefaults` reproduces the original's webUI loadbang
// (spec §04 §1.1) — the exact vector every fresh session actually starts from.
var engine: Engine!
var keyboardSurface: KeyboardTrackpadSurface!
do {
  let context = try MetalContext()
  let assembled = try Engine(context: context, audioSampleRate: audioSampleRate)
  assembled.router.applyStartupDefaults(at: 0)

  let bindings = try BindingsLoader.load(from: nil)
  let keyboard = KeyboardTrackpadSurface(bindings: bindings)
  let gamepad = GamepadSurface()
  // Order matters: later surfaces win ties (`ControlRouter`'s last-writer-wins arbitration,
  // spec §04 §1.2) — keyboard first, gamepad second, so a connected pad can override a key
  // that's merely being held, matching the "tracked source primary" precedent design §5 sets
  // for the Leap-style arbitration this baseline doesn't implement yet.
  assembled.router.surfaces = [keyboard, gamepad]

  engine = assembled
  keyboardSurface = keyboard
} catch {
  FileHandle.standardError.write(Data("feedbax-dev: failed to start the engine: \(error)\n".utf8))
  exit(1)
}

// Live microphone input is deliberately NOT part of `Engine` (design/Task 19: `Engine.step`
// must stay pure and injectable for the determinism test/golden harness). `AudioAnalysis` is
// the one place this codebase touches `AVAudioEngine`, and it only ever starts here, when the
// real app runs — never in a test. Best-effort: a machine with no input device, or a user who
// denies mic permission, should still get a working (silent) instrument, not a crash.
let audioAnalysis = try? AudioAnalysis(bands: engine.bands)
try? audioAnalysis?.start()

/// `swift run`'s unbundled executable has no Info.plist/nib, so — unlike a proper `.app`
/// bundle (Task 23) — nothing makes this process the frontmost, regular, focusable app on its
/// own; without this, the window can open behind other apps or never accept keystrokes at all
/// (review item: "keyboard likely never reaches MetalHostView" — this is the other half of
/// that fix, `MetalHostView.viewDidMoveToWindow`'s `makeFirstResponder` call is the first).
/// `NSApplicationDelegateAdaptor` is SwiftUI's hook for exactly this kind of one-time AppKit
/// setup that has to run from `applicationDidFinishLaunching`, not from a `Scene`'s `body`.
final class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    NSApp.setActivationPolicy(.regular)
    NSApp.activate()
  }
}

/// SwiftUI's `App` protocol requires a bare `init()` (the system constructs the app struct
/// itself), so `engine`/`keyboardSurface` can't be passed in as constructor arguments — they're
/// the file-scope globals built above instead, referenced directly from `body`. The operator
/// panel (sliders/toggles/pickers, Task 20) replaces this bare preview-only scene; for now the
/// whole window IS `PreviewView`.
struct FeedbaxApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup("Feedbax") {
      PreviewView(engine: engine, surface: keyboardSurface)
        .frame(minWidth: 640, minHeight: 360)
    }
  }
}

FeedbaxApp.main()
