import SwiftUI

/// Window ids, in one place because two unrelated mechanisms depend on them: SwiftUI restores
/// each `Window` scene's frame and screen across launches keyed by id. (`PerformerInputMonitor`
/// finds the output window through `EngineHost.attachedWindow`, not by matching these ids — see
/// that type's own doc comment.)
public enum FeedbaxWindow {
  public static let outputID = "output"
  public static let controlsID = "controls"
}

/// The launch-time "make sure both windows are open" one-shot (Ruling 11), shared by both
/// windows' content so it fires regardless of which one macOS actually opens on cold launch —
/// see the two content views below for why relying on just one of them isn't enough.
private enum LaunchWindowOpener {
  /// Spec goal 1 is that output and controls are separate windows a performer places on
  /// separate screens — "open Controls once from the Window menu after every launch" is not that
  /// experience. `static`, not `@State`: this must survive across possible view rebuilds of the
  /// SAME process (the `Window` scene's underlying `NSWindow` survives close/reopen — see
  /// `RenderView`'s doc comment — but nothing guarantees SwiftUI never reconstructs a leaf view's
  /// identity while doing so) and it must NOT reset merely because a window was closed and
  /// reopened. A performer who deliberately closes one window must find it still closed later in
  /// the same process — this guard fires at most once per process, not once per appearance.
  private static var hasOpenedCompanionOnce = false

  static func openCompanionOnce(_ open: () -> Void) {
    guard !hasOpenedCompanionOnce else { return }
    hasOpenedCompanionOnce = true
    open()
  }
}

/// The Output window's whole content. Carries the launch-time `.onAppear` that opens Controls
/// (via the shared `LaunchWindowOpener`) — see `ControlsWindowContent` for why the SAME trigger
/// also lives there.
private struct OutputWindowContent: View {
  let host: EngineHost
  @Environment(\.openWindow) private var openWindow

  var body: some View {
    DisplayView(host: host)
      .frame(minWidth: 320, minHeight: 240)
      // The output is the projector image: no padding, no chrome inside the window, and a
      // black ground so letterboxing around an aspect-fit frame reads as intentional.
      .background(Color.black)
      .ignoresSafeArea()
      .onAppear {
        LaunchWindowOpener.openCompanionOnce { openWindow(id: FeedbaxWindow.controlsID) }
      }
  }
}

/// The Controls window's whole content. Only SwiftUI decides which one `Window` scene opens
/// automatically on a cold launch (observed: Output does, today) — a session whose window-state
/// restoration instead brings back Controls first (e.g. because the performer had left Output
/// closed at last quit) would otherwise never fire `OutputWindowContent`'s `.onAppear` at all,
/// leaving that performer with only Controls. Carrying the identical one-shot here, guarded by
/// the SAME shared `LaunchWindowOpener`, makes "both windows end up open at launch" hold no
/// matter which one macOS actually constructs first — `openWindow` on an already-open window is
/// a harmless no-op (it just focuses it), so there's no risk of the two content views bouncing
/// each other back open in a loop.
private struct ControlsWindowContent: View {
  let viewModel: EngineViewModel
  @Environment(\.openWindow) private var openWindow

  var body: some View {
    OperatorPanel(vm: viewModel)
      .frame(minWidth: 300, minHeight: 400)
      .onAppear {
        LaunchWindowOpener.openCompanionOnce { openWindow(id: FeedbaxWindow.outputID) }
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
      ControlsWindowContent(viewModel: bootstrap.viewModel)
    }
    .defaultSize(width: 720, height: 800)
  }
}
