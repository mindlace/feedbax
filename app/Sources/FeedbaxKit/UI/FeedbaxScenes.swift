import SwiftUI

/// Window ids, in one place because two unrelated mechanisms depend on them: SwiftUI restores
/// each `Window` scene's frame and screen across launches keyed by id. (`PerformerInputMonitor`
/// finds the output window through `EngineHost.attachedWindow`, not by matching these ids — see
/// that type's own doc comment.)
public enum FeedbaxWindow {
  public static let outputID = "output"
  public static let controlsID = "controls"
}

/// The Output window's whole content, split out of `FeedbaxScenes.body` only so it can carry the
/// launch-time `.onAppear` that opens Controls (Ruling 11) — see that modifier's doc comment.
private struct OutputWindowContent: View {
  let host: EngineHost
  @Environment(\.openWindow) private var openWindow

  /// Spec goal 1 is that output and controls are separate windows a performer places on
  /// separate screens — "open Controls once from the Window menu after every launch" is not
  /// that experience. `static`, not `@State`: this must survive across possible view rebuilds of
  /// the SAME process (the `Window` scene's underlying `NSWindow` survives close/reopen — see
  /// `RenderView`'s doc comment — but nothing guarantees SwiftUI never reconstructs this leaf
  /// view's identity while doing so) and it must NOT reset merely because the Output window was
  /// closed and reopened. A performer who deliberately closes Controls and later reopens Output
  /// must find Controls still closed, exactly as they left it — this guard only ever fires once
  /// per process, not once per Output-window-appearance.
  private static var hasOpenedControlsOnce = false

  var body: some View {
    DisplayView(host: host)
      .frame(minWidth: 320, minHeight: 240)
      // The output is the projector image: no padding, no chrome inside the window, and a
      // black ground so letterboxing around an aspect-fit frame reads as intentional.
      .background(Color.black)
      .ignoresSafeArea()
      .onAppear {
        guard !Self.hasOpenedControlsOnce else { return }
        Self.hasOpenedControlsOnce = true
        openWindow(id: FeedbaxWindow.controlsID)
      }
  }
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
      OutputWindowContent(host: bootstrap.host)
    }
    .defaultSize(width: 1280, height: 720)

    Window("Controls", id: FeedbaxWindow.controlsID) {
      OperatorPanel(vm: bootstrap.viewModel)
        .frame(minWidth: 300, minHeight: 400)
    }
    .defaultSize(width: 720, height: 800)
  }
}
