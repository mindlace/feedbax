import SwiftUI

/// Window ids, in one place because two unrelated mechanisms depend on them: SwiftUI restores
/// each `Window` scene's frame and screen across launches keyed by id. (`PerformerInputMonitor`
/// finds the output window through `EngineHost.attachedWindow`, not by matching these ids — see
/// that type's own doc comment.)
public enum FeedbaxWindow {
  public static let outputID = "output"
  public static let controlsID = "controls"
}

/// The instrument's whole window layout, shared verbatim by both entry points so `swift run`
/// and `Feedbax.app` cannot drift (design §8). Two `Window` scenes rather than `WindowGroup`s:
/// `Window` is single-instance and gets a Window-menu entry for free, so a closed window can
/// always be brought back (spec goal 3).
///
/// Closing either window tears down only that window's views. `EngineHost` is untouched and
/// keeps stepping — closing the output window swaps it back to the timer driver rather than
/// stopping the feedback loop (spec goal 2).
public struct FeedbaxScenes: Scene {
  private let bootstrap: AppBootstrap

  public init(bootstrap: AppBootstrap) { self.bootstrap = bootstrap }

  public var body: some Scene {
    Window("Output", id: FeedbaxWindow.outputID) {
      DisplayView(host: bootstrap.host)
        .frame(minWidth: 320, minHeight: 240)
        // The output is the projector image: no padding, no chrome inside the window, and a
        // black ground so letterboxing around an aspect-fit frame reads as intentional.
        .background(Color.black)
        .ignoresSafeArea()
    }
    .defaultSize(width: 1280, height: 720)

    Window("Controls", id: FeedbaxWindow.controlsID) {
      OperatorPanel(vm: bootstrap.viewModel)
        .frame(minWidth: 300, minHeight: 400)
    }
    .defaultSize(width: 720, height: 800)
  }
}
