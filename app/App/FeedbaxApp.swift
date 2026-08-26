import SwiftUI
import Foundation
import FeedbaxKit

/// The `Feedbax.app` bundle's `@main` entry point. Everything about *what* the app consists of
/// — the engine, the always-running `EngineHost`, the input monitor, both windows — lives in
/// `FeedbaxKit` (`AppBootstrap`, `FeedbaxScenes`) so this bundle and `feedbax-dev` cannot
/// drift (design §8). Unlike `feedbax-dev`, a real bundle with an Info.plist already launches
/// as a regular, frontmost, focusable app via Launch Services, so there is no
/// activation-policy workaround here.
///
/// `AppBootstrap.start()` can throw (a GPU-less machine, a corrupt bundled
/// `DefaultBindings.json`, a failed output-stage pipeline) — there is no windowed way to
/// recover, so a failure prints to stderr and exits before any window opens.
let bootstrap: AppBootstrap = {
  do {
    return try AppBootstrap.start()
  } catch {
    FileHandle.standardError.write(Data("Feedbax: failed to start the engine: \(error)\n".utf8))
    exit(1)
  }
}()

@main
struct FeedbaxApp: App {
  var body: some Scene {
    FeedbaxScenes(bootstrap: bootstrap)
  }
}
