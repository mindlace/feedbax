import SwiftUI
import AppKit
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

// Engine assembly (Task 19): everything the instrument needs to render is built here, once,
// before the window opens. `applyStartupDefaults` reproduces the original's webUI loadbang
// (spec §04 §1.1) — the exact vector every fresh session actually starts from.
var engine: Engine!
var keyboardSurface: KeyboardTrackpadSurface!
do {
  let context = try MetalContext()
  let assembled = try Engine(context: context)
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

/// SwiftUI's `App` protocol requires a bare `init()` (the system constructs the app struct
/// itself), so `engine`/`keyboardSurface` can't be passed in as constructor arguments — they're
/// the file-scope globals built above instead, referenced directly from `body`. The operator
/// panel (sliders/toggles/pickers, Task 20) replaces this bare preview-only scene; for now the
/// whole window IS `PreviewView`.
struct FeedbaxApp: App {
  var body: some Scene {
    WindowGroup("Feedbax") {
      PreviewView(engine: engine, surface: keyboardSurface)
        .frame(minWidth: 640, minHeight: 360)
    }
  }
}

FeedbaxApp.main()
