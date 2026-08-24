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

// Engine assembly (Task 19/20) now lives in `AppBootstrap` (Task 23) so `Feedbax.app`'s
// `FeedbaxApp.swift` can share it verbatim instead of duplicating the do/catch below.
let bootstrap: AppBootstrap
do {
  bootstrap = try AppBootstrap.start()
} catch {
  FileHandle.standardError.write(Data("feedbax-dev: failed to start the engine: \(error)\n".utf8))
  exit(1)
}

/// `swift run`'s unbundled executable has no Info.plist/nib, so — unlike a proper `.app`
/// bundle (Task 23) — nothing makes this process the frontmost, regular, focusable app on its
/// own; without this, the window can open behind other apps or never accept keystrokes at all
/// (review item: "keyboard likely never reaches MetalHostView" — this is the other half of
/// that fix, `MetalHostView.viewDidMoveToWindow`'s `makeFirstResponder` call is the first).
/// `NSApplicationDelegateAdaptor` is SwiftUI's hook for exactly this kind of one-time AppKit
/// setup that has to run from `applicationDidFinishLaunching`, not from a `Scene`'s `body`.
/// `Feedbax.app`'s `FeedbaxApp.swift` doesn't need this: a real bundle with an Info.plist
/// already launches as a regular, frontmost, focusable app via Launch Services.
final class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    NSApp.setActivationPolicy(.regular)
    NSApp.activate()
  }
}

/// `PreviewView` + `OperatorPanel` side by side (Task 20's "panel beside PreviewView in an
/// HSplitView"). `@ObservedObject`, not a plain `let`, is what makes this redraw — and, in
/// particular, re-invoke `PreviewView.updateNSView` with a fresh `hudEnabled` — whenever the
/// operator panel changes `EngineViewModel.hudEnabled` or any other `@Published` mirror.
struct ContentView: View {
  let engine: Engine
  let keyboardSurface: KeyboardTrackpadSurface
  @ObservedObject var viewModel: EngineViewModel

  var body: some View {
    HSplitView {
      PreviewView(engine: engine, surface: keyboardSurface, hudEnabled: viewModel.hudEnabled)
        .frame(minWidth: 480, minHeight: 360)
      OperatorPanel(vm: viewModel)
        .frame(minWidth: 300, idealWidth: 340)
    }
  }
}

/// SwiftUI's `App` protocol requires a bare `init()` (the system constructs the app struct
/// itself), so `bootstrap` can't be passed in as a constructor argument — it's the file-scope
/// global built above instead, referenced directly from `body`.
struct FeedbaxApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup("Feedbax") {
      ContentView(
        engine: bootstrap.engine, keyboardSurface: bootstrap.keyboardSurface,
        viewModel: bootstrap.viewModel
      )
      .frame(minWidth: 800, minHeight: 400)
    }
  }
}

FeedbaxApp.main()
