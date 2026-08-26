import SwiftUI
import Foundation
import FeedbaxKit

/// The `Feedbax.app` bundle's `@main` entry point (Task 23). This mirrors `feedbax-dev/main.swift`
/// deliberately closely — same `ContentView` layout, same `AppBootstrap.start()` call — because
/// design §8 requires the engine to behave identically whether it's driven from `swift run` or a
/// packaged bundle. It's thinner than `feedbax-dev` in exactly one way: a real `.app` bundle with
/// an `Info.plist` already launches as a regular, frontmost, focusable app via Launch Services, so
/// there's no need for `feedbax-dev`'s `NSApplicationDelegateAdaptor`/`NSApp.setActivationPolicy`
/// workaround (see that file's comment on why the unbundled executable needs it).
///
/// `AppBootstrap.start()` can throw (a GPU-less machine, or a corrupt bundled `DefaultBindings.json`)
/// — there's no windowed way to recover from that, so a failure here prints to stderr and exits
/// before any window opens, exactly like `feedbax-dev`.
///
/// This file is `@main`, not `main.swift` — only a file literally named `main.swift` gets to
/// hold free-standing top-level *statements* (that's how `feedbax-dev/main.swift`'s `do`/`catch`
/// works). A single global `let` with an initializer expression is still legal here, so the
/// `do`/`catch` is wrapped in an immediately-invoked closure rather than written bare.
let bootstrap: AppBootstrap = {
  do {
    return try AppBootstrap.start()
  } catch {
    FileHandle.standardError.write(Data("Feedbax: failed to start the engine: \(error)\n".utf8))
    exit(1)
  }
}()

// TEMPORARY (Task 3): `AppBootstrap.host` doesn't exist yet — Task 5 moves this into
// `AppBootstrap` and deletes this local build.
let host: EngineHost = {
  do { return try EngineHost(engine: bootstrap.engine) } catch {
    FileHandle.standardError.write(Data("Feedbax: failed to start the renderer: \(error)\n".utf8))
    exit(1)
  }
}()
host.start()

/// `DisplayView` + `OperatorPanel` side by side (Task 20's "panel beside PreviewView in an
/// HSplitView"), identical to `feedbax-dev/main.swift`'s `ContentView`.
struct ContentView: View {
  let engine: Engine
  let keyboardSurface: KeyboardTrackpadSurface
  @ObservedObject var viewModel: EngineViewModel

  var body: some View {
    HSplitView {
      DisplayView(host: host)
        .frame(minWidth: 480, minHeight: 360)
      OperatorPanel(vm: viewModel)
        .frame(minWidth: 300, idealWidth: 340)
    }
  }
}

@main
struct FeedbaxApp: App {
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
