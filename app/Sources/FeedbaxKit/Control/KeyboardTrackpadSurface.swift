import Foundation

/// The performer's day-one input path (design §5 baseline-local-input): local keyboard and
/// trackpad, driven entirely by `Bindings` — no exotic hardware required for P1. Task 19/20
/// forward real `NSEvent`s into `keyDown`/`gesture`; tests call them directly.
///
/// Two kinds of state, matching the two kinds of thing a performer does with this surface:
/// - **Gesture deltas** are gathered per axis and resolved against router truth at poll time
///   (design §5) — a gesture nudges the axis from wherever it actually is.
/// - **Toggles and the erase step** are one-shot events: `poll` hands back whatever queued
///   since the last call and drains the queue, same as the original's hard cuts.
public final class KeyboardTrackpadSurface: ControlSurface {
  public let id = "keyboard-trackpad"

  private let bindings: Bindings

  /// The live truth this surface's toggles compute their next flip FROM, instead of keeping
  /// their own memory (finding 4, final review — see `ControlStateSnapshot`'s own doc comment).
  /// Defaults to `.constant(false)`: a bare unit test that doesn't care about cross-surface
  /// reconciliation gets the same "nothing has been pressed yet" starting behavior this type
  /// always had.
  private let stateSnapshot: ControlStateSnapshot

  /// Deltas gathered since the last `poll`, per axis. NOT a held position (design §5): the
  /// surface used to keep its own accumulator per slot and nudge THAT, so after the operator
  /// panel or a preset moved a slot, the next trackpad nudge asserted "stale accumulator +
  /// delta" and snapped the value back. `poll` now resolves each delta against
  /// `stateSnapshot.rawValue` — the router's truth at that moment — which is the same
  /// "read truth at poll time" ruling finding 4 established for toggles.
  private var pendingDeltas: [ControlAxis: Float] = [:]

  /// Toggle TEMPLATES queued by `keyDown` since the last `poll` — deliberately NOT yet resolved
  /// to a concrete on/off Bool. Resolution happens in `poll`, via `resolveToggles`, against
  /// `stateSnapshot`'s truth AT THAT MOMENT — not decided here at keydown time — so a truth
  /// change from ANOTHER surface (the gamepad, the operator panel, a preset recall) that lands
  /// between this keypress and this surface's next poll is what the flip actually resolves
  /// against (finding 4's own test: "keyboard's next `i` press emits the CORRECT next value").
  private var pendingToggleTemplates: [ToggleEvent] = []

  /// Pending erase nudge, drained on read. `[`/`]` are hardcoded here rather than data-driven
  /// through `Bindings.keys` — deliberately: `ToggleEvent` has no case that carries a signed
  /// float step, and `ControlWrite.eraseStep` is a controller-level concept (Task 11's note,
  /// ControlVector.swift) outside the 9-slot vector entirely, so it doesn't fit the bindings
  /// table's "key → ToggleEvent" shape without widening that contract past what Task 13 needs.
  private var pendingEraseStep: Float?

  /// Internal rather than private so `ControlReference.fixedKeyRows` can spell the `[`/`]`
  /// rows from the very constant those keys apply, instead of a literal that can drift from it
  /// (design §8.1 — the reference IS the keys).
  static let eraseStepMagnitude: Float = 0.05

  /// Arbitrates between simultaneously-delivered two-finger gestures (design §6.3, Task 5) —
  /// see `GestureLock`'s own doc comment for why this needs to exist at all.
  private var lock = GestureLock()

  public init(bindings: Bindings, stateSnapshot: ControlStateSnapshot = .constant(false)) {
    self.bindings = bindings
    self.stateSnapshot = stateSnapshot
  }

  /// Whether this surface has anything bound to `key` — `[`/`]` (the hardcoded erase step) or
  /// an entry in `bindings.keys`. `PerformerInputMonitor` uses this to decide whether a keydown
  /// is actually ours to consume, rather than forwarding (and swallowing) every unbound key
  /// app-wide — Cmd-Q, Tab, arrow keys, Space, none of which this surface does anything with.
  public func handles(_ key: String) -> Bool {
    key == "[" || key == "]" || bindings.keys[key] != nil
  }

  public func keyDown(_ key: String) {
    if key == "[" {
      pendingEraseStep = (pendingEraseStep ?? 0) - Self.eraseStepMagnitude
      return
    }
    if key == "]" {
      pendingEraseStep = (pendingEraseStep ?? 0) + Self.eraseStepMagnitude
      return
    }
    guard let template = bindings.keys[key] else { return }   // unbound key: no-op
    pendingToggleTemplates.append(template)
  }

  /// Whether the bindings table has a row for this exact gesture + modifier set —
  /// `PerformerInputMonitor`'s consume/pass-through decision for pointer events, mirroring
  /// `handles(_ key:)`: an unbound combination is never swallowed.
  public func handles(_ gesture: TrackpadGesture, modifiers: Set<GestureModifier>) -> Bool {
    bindings.trackpadBinding(for: gesture, modifiers: modifiers) != nil
  }

  /// One normalised gesture event (design §6.4). Unbound → no-op, same as an unbound key.
  public func gesture(_ event: GestureEvent) {
    // A lift-off must reach the lock even when this event's modifiers are unbound (design
    // §6.3) — otherwise a modifier change at the end of a claimed gesture leaves the lock
    // claimed forever.
    if event.phase.isTerminal {
      _ = lock.admit(event)
      return   // nothing to apply: terminal events carry no delta
    }
    guard let binding = bindings.trackpadBinding(for: event.gesture, modifiers: event.modifiers) else { return }
    // Bound gestures only reach the lock — an unbound combination the monitor let through
    // (or a test fed directly) must not claim a sequence nothing will ever end.
    guard lock.admit(event) else { return }
    switch binding.target {
    case .xy(let x, let y):
      nudge(event.delta.x, along: x)
      nudge(event.delta.y, along: y)
    case .single(let axis):
      nudge(event.delta.x, along: axis)
    }
  }

  private func nudge(_ delta: Float, along axis: TrackpadAxis) {
    pendingDeltas[axis.axis, default: 0] += delta * axis.sensitivity
  }

  public func poll(_ time: TimeInterval) -> ControlWrite? {
    // Each pending delta lands on the router's CURRENT raw value, clamped to the axis range,
    // and is asserted only if that actually moves it — message-on-change falls out of the
    // comparison (a nudge into a clamp, or one that overshoots and corrects back within one
    // frame, asserts nothing).
    var axes: [ControlAxis: Float] = [:]
    for (axis, delta) in pendingDeltas {
      let truth = stateSnapshot.rawValue(axis)
      let next = axis.clamped(truth + delta)
      if next != truth { axes[axis] = next }
    }
    pendingDeltas = [:]
    let toggles = resolveToggles()
    let eraseStep = pendingEraseStep
    pendingEraseStep = nil
    if axes.isEmpty && toggles.isEmpty && eraseStep == nil {
      return nil   // assert nothing this frame — ControlRouter falls through (spec §04 §1.2)
    }
    return ControlWrite(axes: axes, toggles: toggles, eraseStep: eraseStep)
  }

  /// Resolves every queued template into a concrete on/off `ToggleEvent`, chained against
  /// `stateSnapshot`'s live truth (finding 4). The FIRST queued occurrence of a given toggle
  /// kind flips away from whatever truth currently reads; a SECOND occurrence of the SAME kind
  /// queued before this same `poll` (a very fast repeated keypress inside one frame interval)
  /// flips again from what the first one just resolved to, not from truth — truth itself won't
  /// actually move until this write reaches the router and gets applied, so a same-batch repeat
  /// has nothing fresher than its own prior resolution to read. Keyed by `ToggleEvent.marker`
  /// (`Bindings.swift`) since that, not the source key string, is what identifies "the same
  /// underlying toggle" — two different keys bound to the same `ToggleEvent` case should still
  /// chain off each other within one batch.
  private func resolveToggles() -> [ToggleEvent] {
    guard !pendingToggleTemplates.isEmpty else { return [] }
    var inFlight: [String: Bool] = [:]
    let resolved = pendingToggleTemplates.map { template -> ToggleEvent in
      let marker = template.marker
      let current = inFlight[marker] ?? stateSnapshot.current(for: template) ?? false
      let next = !current
      inFlight[marker] = next
      return template.resolvingFlip(next)
    }
    pendingToggleTemplates = []
    return resolved
  }
}
