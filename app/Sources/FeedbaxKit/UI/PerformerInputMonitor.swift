import AppKit
import Foundation

/// One app-level `NSEvent` local monitor, installed once at bootstrap, replacing the
/// per-view input overrides `MetalHostView` used to carry. That is spec goal 4: a performer
/// tweaking a slider in the control window can still hit a key binding without clicking back
/// into the output window first.
public final class PerformerInputMonitor {
  private let surface: KeyboardTrackpadSurface
  private let outputWindow: () -> NSWindow?
  private var monitor: Any?

  public enum Decision { case forward, passThrough }

  /// `outputWindow` is a closure, not a stored window or an `NSWindow.identifier` lookup: the
  /// output window doesn't exist yet when the monitor is constructed at bootstrap (Task 5), and
  /// SwiftUI stamping a `Window` scene's `id` onto the AppKit window's `identifier` isn't a
  /// contract worth depending on — if it silently didn't hold, every pointer gesture would
  /// dead-end into `decidePointer(false)` with no error. Task 5 passes
  /// `{ [weak host] in host?.attachedWindow }`.
  public init(surface: KeyboardTrackpadSurface, outputWindow: @escaping () -> NSWindow?) {
    self.surface = surface
    self.outputWindow = outputWindow
  }

  /// Keys are forwarded regardless of which window is key — that is the whole point — but a
  /// local monitor also sees keystrokes destined for the control panel's own text fields
  /// (the preset-name field) and, more broadly, EVERY keydown in the app. Returning nil from a
  /// local monitor CONSUMES the event, so this must not forward anything it isn't actually
  /// going to use: an unbound key (Cmd-Q, Tab, an arrow key, Space) or anything chorded with
  /// Command/Control (a menu shortcut, a window command) has to pass through untouched, or
  /// keyboard navigation of the app — including the control panel this monitor exists
  /// alongside — breaks the moment no text field has focus (review finding, superseding the
  /// brief's original "forward every key unless a text editor has focus").
  public static func decideKey(firstResponderIsTextEditor: Bool, characters: String?,
                                isBound: Bool, hasCommandOrControl: Bool) -> Decision {
    guard let characters, !characters.isEmpty else { return .passThrough }
    if firstResponderIsTextEditor || hasCommandOrControl || !isBound { return .passThrough }
    return .forward
  }

  /// Pointer gestures are narrower than keys on purpose: they are aimed at whatever is under
  /// the cursor. The control window is a scrollable form of sliders, so a two-finger scroll
  /// there must scroll the form, not pan the shader.
  public static func decidePointer(eventIsInOutputWindow: Bool) -> Decision {
    eventIsInOutputWindow ? .forward : .passThrough
  }

  /// `NSTextView` covers SwiftUI's `TextField` too: AppKit hands an editing text field its
  /// window's shared *field editor*, which is an `NSTextView`, as first responder.
  public static func isTextEditor(_ responder: NSResponder?) -> Bool {
    guard let responder else { return false }
    if responder is NSText { return true }
    if let view = responder as? NSView, view.isKind(of: NSTextField.self) { return true }
    return false
  }

  /// Internal seam the tests drive directly — the real monitor closure below is a thin shell
  /// over this plus `decideKey`. `isBound` is derived from the surface here rather than passed
  /// in, matching `handle(_:)`'s own real path; `hasCommandOrControl` stays a parameter so
  /// tests can exercise the chord-gating rule without synthesizing a real `NSEvent`.
  func handleKey(characters: String?, firstResponderIsTextEditor: Bool,
                 hasCommandOrControl: Bool = false) {
    let isBound = characters.map(surface.handles) ?? false
    guard Self.decideKey(firstResponderIsTextEditor: firstResponderIsTextEditor,
                         characters: characters, isBound: isBound,
                         hasCommandOrControl: hasCommandOrControl) == .forward,
          let characters else { return }
    surface.keyDown(characters)
  }

  /// Installs the monitor. Returning nil from the handler CONSUMES the event, which is what
  /// keeps a forwarded key from also reaching (say) a SwiftUI button's key equivalent;
  /// returning the event passes it through untouched.
  public func install() {
    guard monitor == nil else { return }
    monitor = NSEvent.addLocalMonitorForEvents(
      matching: [.keyDown, .scrollWheel, .magnify, .leftMouseDragged]
    ) { [weak self] event in
      guard let self else { return event }
      return self.handle(event) == .forward ? nil : event
    }
  }

  public func uninstall() {
    if let monitor { NSEvent.removeMonitor(monitor) }
    monitor = nil
  }

  deinit { uninstall() }

  private func handle(_ event: NSEvent) -> Decision {
    switch event.type {
    case .keyDown:
      let responder = (event.window ?? NSApp.keyWindow)?.firstResponder
      let isText = Self.isTextEditor(responder)
      let characters = event.charactersIgnoringModifiers
      // Escape and `f` both toggle fullscreen (spec §01 §1: "the original's Esc"; `f` is also
      // the bindings-table fullscreen key, `DefaultBindings.json`). Escape carries no binding
      // at all — that's exactly why it's handled directly here rather than through
      // `decideKey`/`surface.handles` — and stays consumed; `f` is ALSO forwarded to the
      // surface below so its `.fullscreen` toggle still flows the normal control path —
      // harmless, since `Engine.handle(_:)`'s `.fullscreen` case is a deliberate no-op.
      if !isText, event.keyCode == 53 || characters == "f" {
        outputWindow()?.toggleFullScreen(nil)
        if event.keyCode == 53 { return .forward }   // Escape: consumed, nothing to forward
      }
      // A local monitor sees every keydown in the app, not just ones destined for this
      // surface — Cmd-Q, Tab, arrow keys, Space are none of `KeyboardTrackpadSurface`'s
      // business, and returning nil from the monitor CONSUMES the event, so an unbound key or
      // one chorded with Command/Control must pass through untouched (review finding:
      // forwarding unconditionally widened the blast radius from "the output view has focus"
      // to "the whole app," swallowing ordinary app/window shortcuts and even keyboard
      // navigation of the control panel this monitor sits alongside).
      let isBound = characters.map(surface.handles) ?? false
      let chordFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
      let hasCommandOrControl = chordFlags.contains(.command) || chordFlags.contains(.control)
      guard let characters,
            Self.decideKey(firstResponderIsTextEditor: isText, characters: characters,
                           isBound: isBound, hasCommandOrControl: hasCommandOrControl) == .forward
      else {
        return .passThrough
      }
      surface.keyDown(characters)
      return .forward

    case .scrollWheel:
      guard isOutputWindowEvent(event), let height = eventViewHeight(event) else { return .passThrough }
      // `scrollingDeltaX/Y` are raw POINTS and one fast swipe can report 5–40 of them; fed
      // straight into `accumulate`'s ±1 range that slams the pan accumulator to its clamp in a
      // single event. Dividing by the output view's height turns "drag the full height of the
      // output" into "drive the axis across its whole −1...1 range", and scales with the
      // window automatically. `KeyboardTrackpadSurface` is deliberately AppKit-free and has no
      // view geometry of its own, which is why this normalization lives here.
      surface.scroll(dx: Float(event.scrollingDeltaX) / height,
                     dy: Float(event.scrollingDeltaY) / height)
      return .forward

    case .magnify:
      guard isOutputWindowEvent(event) else { return .passThrough }
      // `magnification` is already a small per-event ratio, not raw points — no normalization.
      surface.magnify(Float(event.magnification))
      return .forward

    case .leftMouseDragged:
      // Option-held drag: x → hue, y → theta (`KeyboardTrackpadSurface.modifiedDrag`). Plain
      // drags are intentionally not forwarded — the output view has no click-drag role in P1.
      guard event.modifierFlags.contains(.option), isOutputWindowEvent(event),
            let height = eventViewHeight(event) else { return .passThrough }
      surface.modifiedDrag(dx: Float(event.deltaX) / height, dy: Float(event.deltaY) / height)
      return .forward

    default:
      return .passThrough
    }
  }

  private func isOutputWindowEvent(_ event: NSEvent) -> Bool {
    Self.decidePointer(
      eventIsInOutputWindow: event.window != nil && event.window === outputWindow()
    ) == .forward
  }

  /// The output window's content height in points — the normalization denominator the old
  /// per-view handlers got from `bounds.height`.
  private func eventViewHeight(_ event: NSEvent) -> Float? {
    guard let height = event.window?.contentView?.bounds.height, height > 0 else { return nil }
    return Float(height)
  }
}
