import AppKit
import Foundation
import simd

/// One app-level `NSEvent` local monitor, installed once at bootstrap, replacing the
/// per-view input overrides `MetalHostView` used to carry. That is spec goal 4: a performer
/// tweaking a slider in the control window can still hit a key binding without clicking back
/// into the output window first.
///
/// Five event types feed the switch in `handle(_:)`: `.keyDown` (bound keys, Escape/`f`
/// fullscreen, and the `?` help key below) and four pointer gestures — `.scrollWheel`,
/// `.magnify`, `.rotate`, `.leftMouseDragged` — all normalised and routed through the single
/// `forward(_:event:phase:delta:)` helper onto `KeyboardTrackpadSurface.gesture(_:)` (design
/// §6.2). `?` (Shift-/) is the odd one out: it never reaches the bindings table at all — it
/// posts `.feedbaxShowControlsReference` and is consumed, the same "app action, not a control
/// write" treatment Escape gets (design §8.3).
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

  /// `forward(...)`'s consume/pass-through decision, pulled out pure: scroll/rotate `NSEvent`s
  /// cannot be synthesized in a headless test process, so this is what gets exercised directly.
  /// Forwards when the event is in the output window, carries a performer modifier set (not a
  /// Command/Control chord, which is `nil`), and EITHER the gesture+modifiers combination is
  /// bound OR the phase is terminal (`.ended`/`.cancelled`) — a lift-off must always reach
  /// `GestureLock` even when the performer changed the held modifier since the gesture began
  /// (design §6.3, review finding): otherwise the lock stays claimed forever and silently
  /// discards every later gesture of a different kind.
  public static func decideGesture(eventIsInOutputWindow: Bool, modifiers: Set<GestureModifier>?,
                                   phase: GesturePhase, isBound: Bool) -> Decision {
    guard eventIsInOutputWindow, modifiers != nil else { return .passThrough }
    return (phase.isTerminal || isBound) ? .forward : .passThrough
  }

  /// Which performer modifiers a pointer event carries, or nil when Command/Control make it an
  /// app/window chord that must pass through — the same rule `decideKey` applies to keys.
  /// Only Option and Shift are performer modifiers (`GestureModifier`); Caps Lock, Fn and the
  /// numeric-pad bit are ignored rather than disqualifying.
  public static func gestureModifiers(_ flags: NSEvent.ModifierFlags) -> Set<GestureModifier>? {
    let chord = flags.intersection(.deviceIndependentFlagsMask)
    if chord.contains(.command) || chord.contains(.control) { return nil }
    var modifiers: Set<GestureModifier> = []
    if chord.contains(.option) { modifiers.insert(.option) }
    if chord.contains(.shift) { modifiers.insert(.shift) }
    return modifiers
  }

  /// `NSEvent.Phase` → `GesturePhase`, reading BOTH of the phase fields a scroll carries.
  ///
  /// A flick on a trackpad produces two runs of events: the fingers-down scroll (lifecycle in
  /// `event.phase`, `momentumPhase` empty) and then the coast that keeps arriving after
  /// lift-off (`phase` EMPTY, lifecycle in `event.momentumPhase`). Reading `phase` alone made
  /// every coasting event a `.changed`: each one accumulated travel and re-claimed
  /// `GestureLock` for `.scroll`, and since no `.ended` ever came, the lock stayed claimed and
  /// silently discarded every pinch and twist that followed — until the performer happened to
  /// finish another real scroll (design §6.3, final-review finding 1).
  ///
  /// Priority: `.cancelled` over `.ended` over `.began`, and a terminal bit in EITHER field
  /// wins — a release must never be lost, since it is what frees the lock. `NSEvent.Phase` is
  /// an `OptionSet`, so several bits really can be set at once. Momentum `.began` is
  /// deliberately mapped to `.changed`, not `.began`: the fingers are already up, the sequence
  /// was claimed by the real scroll (or will be re-claimed by the coast's own travel), and
  /// nothing downstream wants a second "began" mid-flick.
  public static func gesturePhase(_ phase: NSEvent.Phase,
                                  momentum: NSEvent.Phase = []) -> GesturePhase {
    if phase.contains(.cancelled) || momentum.contains(.cancelled) { return .cancelled }
    if phase.contains(.ended) || momentum.contains(.ended) { return .ended }
    if phase.contains(.began) { return .began }
    return .changed
  }

  /// `NSEvent.rotation` is degrees per event; ÷180 makes half a turn span the whole −1...1
  /// raw range at sensitivity 1 (design §6.2).
  public static let rotationNormalization: Float = 180

  public static func normalizedRotation(_ degrees: Float) -> Float {
    degrees / rotationNormalization
  }

  /// `?` opens the Controls Reference (design §8.3): no text editor focused, and no modifier
  /// beyond Shift (Shift-/ is how a US keyboard types it). ⌘? is deliberately NOT ours — that
  /// is the Help menu item's own key equivalent.
  public static func decideHelpKey(firstResponderIsTextEditor: Bool, characters: String?,
                                   chordFlags: NSEvent.ModifierFlags) -> Bool {
    guard characters == "?", !firstResponderIsTextEditor else { return false }
    return chordFlags.subtracting(.shift).isEmpty
  }

  /// `NSTextView` covers SwiftUI's `TextField` too: AppKit hands an editing text field its
  /// window's shared *field editor*, which is an `NSTextView`, as first responder.
  public static func isTextEditor(_ responder: NSResponder?) -> Bool {
    guard let responder else { return false }
    if responder is NSText { return true }
    if let view = responder as? NSView, view.isKind(of: NSTextField.self) { return true }
    return false
  }

  /// Installs the monitor. Returning nil from the handler CONSUMES the event, which is what
  /// keeps a forwarded key from also reaching (say) a SwiftUI button's key equivalent;
  /// returning the event passes it through untouched.
  public func install() {
    guard monitor == nil else { return }
    monitor = NSEvent.addLocalMonitorForEvents(
      matching: [.keyDown, .scrollWheel, .magnify, .rotate, .leftMouseDragged]
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

  func handle(_ event: NSEvent) -> Decision {
    switch event.type {
    case .keyDown:
      let responder = (event.window ?? NSApp.keyWindow)?.firstResponder
      let isText = Self.isTextEditor(responder)
      let characters = event.charactersIgnoringModifiers
      let chordFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
      let hasCommandOrControl = chordFlags.contains(.command) || chordFlags.contains(.control)
      // Escape and `f` both toggle fullscreen (spec §01 §1: "the original's Esc"; `f` is also
      // the bindings-table fullscreen key, `DefaultBindings.json`). Escape carries no binding
      // at all — that's exactly why it's handled directly here rather than through
      // `decideKey`/`surface.handles` — and stays consumed; `f` is ALSO forwarded to the
      // surface below so its `.fullscreen` toggle still flows the normal control path —
      // harmless, since `Engine.handle(_:)`'s `.fullscreen` case is a deliberate no-op. Gated on
      // `chordFlags.isEmpty` — any chord at all, not just Command/Control — because
      // Option-`f` still reports plain `"f"` from `charactersIgnoringModifiers` and would
      // otherwise toggle fullscreen too (review finding; the earlier `!hasCommandOrControl`
      // check missed Option/Shift/Function chords).
      //
      // Escape is consumed app-wide here whenever no text editor has focus. Harmless today,
      // but the first SwiftUI sheet or `.onExitCommand` added to `OperatorPanel` would be
      // silently un-dismissable, since this monitor would eat the Escape before it ever
      // reaches that responder chain.
      if !isText, chordFlags.isEmpty, event.keyCode == 53 || characters == "f" {
        outputWindow()?.toggleFullScreen(nil)
        if event.keyCode == 53 { return .forward }   // Escape: consumed, nothing to forward
      }
      if Self.decideHelpKey(firstResponderIsTextEditor: isText, characters: characters,
                            chordFlags: chordFlags) {
        NotificationCenter.default.post(name: .feedbaxShowControlsReference, object: nil)
        return .forward   // consumed: `?` is an app action, not a control write
      }
      // A local monitor sees every keydown in the app, not just ones destined for this
      // surface — Cmd-Q, Tab, arrow keys, Space are none of `KeyboardTrackpadSurface`'s
      // business, and returning nil from the monitor CONSUMES the event, so an unbound key or
      // one chorded with Command/Control must pass through untouched (review finding:
      // forwarding unconditionally widened the blast radius from "the output view has focus"
      // to "the whole app," swallowing ordinary app/window shortcuts and even keyboard
      // navigation of the control panel this monitor sits alongside).
      let isBound = characters.map(surface.handles) ?? false
      guard let characters,
            Self.decideKey(firstResponderIsTextEditor: isText, characters: characters,
                           isBound: isBound, hasCommandOrControl: hasCommandOrControl) == .forward
      else {
        return .passThrough
      }
      surface.keyDown(characters)
      return .forward

    case .scrollWheel:
      // `scrollingDeltaX/Y` are raw POINTS and one fast swipe can report 5–40 of them; ÷ the
      // output view's height turns "drag the full height of the output" into "drive the axis
      // across its whole −1...1 range" and scales with the window. The surface is AppKit-free
      // and has no geometry of its own, which is why the normalisation lives here.
      guard let height = eventViewHeight(event) else { return .passThrough }
      // `momentumPhase` as well as `phase`: scroll is the one gesture that keeps delivering
      // events after the fingers lift, and only `momentumPhase` says when that coast ends.
      return forward(.scroll, event: event,
                     phase: Self.gesturePhase(event.phase, momentum: event.momentumPhase),
                     delta: SIMD2(Float(event.scrollingDeltaX) / height, Float(event.scrollingDeltaY) / height))

    case .magnify:
      // `magnification` is already a small per-event ratio — no normalisation.
      return forward(.pinch, event: event, phase: Self.gesturePhase(event.phase),
                     delta: SIMD2(Float(event.magnification), 0))

    case .rotate:
      return forward(.rotate, event: event, phase: Self.gesturePhase(event.phase),
                     delta: SIMD2(Self.normalizedRotation(Float(event.rotation)), 0))

    case .leftMouseDragged:
      // Plain drag = pan, Option = image layer, Shift = colour (design §6.1) — which is which
      // is the bindings table's business; this just normalises like scroll.
      guard let height = eventViewHeight(event) else { return .passThrough }
      return forward(.drag, event: event, phase: .changed,
                     delta: SIMD2(Float(event.deltaX) / height, Float(event.deltaY) / height))

    default:
      return .passThrough
    }
  }

  /// One path for every pointer gesture: output window only (`decidePointer`), no
  /// Command/Control chord, and a bindings row for this gesture + modifiers — otherwise the
  /// event passes through untouched (a two-finger scroll over the Controls form keeps
  /// scrolling the form; an Option+Shift pinch nobody bound reaches whatever wanted it).
  /// Terminal phases (`.ended`/`.cancelled`) bypass the bindings-row check via `decideGesture`
  /// and are forwarded regardless — the surface's `gesture(_:)` routes them straight to
  /// `GestureLock` without touching the bindings table, so a lift-off always releases whatever
  /// it claimed even if the performer changed the held modifier before lifting (design §6.3).
  private func forward(_ gesture: TrackpadGesture, event: NSEvent, phase: GesturePhase,
                       delta: SIMD2<Float>) -> Decision {
    let modifiers = Self.gestureModifiers(event.modifierFlags)
    let isBound = modifiers.map { surface.handles(gesture, modifiers: $0) } ?? false
    guard Self.decideGesture(eventIsInOutputWindow: isOutputWindowEvent(event), modifiers: modifiers,
                             phase: phase, isBound: isBound) == .forward else { return .passThrough }
    surface.gesture(GestureEvent(gesture: gesture, modifiers: modifiers!, phase: phase, delta: delta))
    return .forward
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

extension Notification.Name {
  /// Posted by `PerformerInputMonitor` on the `?` key (design §8.3). `NotificationCenter` is the
  /// conventional bridge from an AppKit object to SwiftUI views without either owning the
  /// other — `FeedbaxScenes`' window content views `.onReceive` this and open the Controls
  /// Reference window (design §13).
  public static let feedbaxShowControlsReference = Notification.Name("FeedbaxShowControlsReference")
}
