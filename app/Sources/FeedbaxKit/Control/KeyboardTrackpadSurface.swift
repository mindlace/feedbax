import Foundation

/// The performer's day-one input path (design §5 baseline-local-input): local keyboard and
/// trackpad, driven entirely by `Bindings` — no exotic hardware required for P1. Task 19/20
/// forward real `NSEvent`s into `keyDown`/`scroll`/`magnify`/`modifiedDrag`; tests call them
/// directly.
///
/// Two kinds of state, matching the two kinds of thing a performer does with this surface:
/// - **Accumulators** (`panX`/`panY`/`zoom`/`hue`/`theta`) behave like the original's sliders
///   — a gesture nudges a held position, clamped to −1...1, and `poll` asserts that position
///   the frame it CHANGES (mirrors every other surface's message-on-change contract — see
///   `lastAsserted`'s own doc comment for why "keeps asserting every frame while nonzero," this
///   type's original behavior, was a bug, not a feature).
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

  /// Held position per trackpad-bound slot, clamped −1...1 — the raw range shared by every
  /// slot these three gestures touch (`ControlRouter.mappedTarget`: hue/panX/panY/zoom/theta
  /// all map from −1...1). Sparse: a slot only appears once a gesture has touched it, which
  /// is also how `poll`'s partial write ("only touched slots," design §5) falls out for free
  /// — nothing here for an untouched slot to filter.
  private var accumulators: [ControlSlot: Float] = [:]

  /// What `poll` last ASSERTED for each slot (not the last raw gesture) — final review finding
  /// 2: `poll` previously reasserted every nonzero accumulator on EVERY call, which meant a
  /// touched slot's held value permanently overrode whatever the gamepad or operator panel
  /// wrote to that same slot afterward (surface order is `[keyboard, gamepad, viewModel]`;
  /// later surfaces are only supposed to win TIES within a frame, not lose to a stale earlier
  /// one on every subsequent frame). `ControlRouter.rawSlots` already holds a slot's value
  /// between frames on its own — this surface only needs to assert a CHANGE, exactly like
  /// `GamepadSurface`'s edge-triggered buttons/d-pad and `EngineViewModel`'s "asserted once
  /// then drained" sliders (that method's own doc comment). Diffing the ACCUMULATOR against
  /// this, not against the previous accumulator snapshot directly, is what makes a gesture that
  /// nudges a slot back to a value it already held (e.g. a scroll that overshoots and corrects)
  /// correctly assert nothing on the second poll — same "diff the target, not the input"
  /// principle `ControlRouter.lastRampTarget` uses for ramp retargeting.
  private var lastAsserted: [ControlSlot: Float] = [:]

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

  private static let eraseStepMagnitude: Float = 0.05

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

  /// Two-finger drag — the original's shader-pan touch role (design §5).
  public func scroll(dx: Float, dy: Float) {
    accumulate(dx, into: bindings.trackpad.panX)
    accumulate(dy, into: bindings.trackpad.panY)
  }

  /// Pinch/magnify.
  public func magnify(_ delta: Float) {
    accumulate(delta, into: bindings.trackpad.zoom)
  }

  /// Option-held drag: x → hue, y → theta.
  public func modifiedDrag(dx: Float, dy: Float) {
    accumulate(dx, into: bindings.trackpad.hue)
    accumulate(dy, into: bindings.trackpad.theta)
  }

  public func poll(_ time: TimeInterval) -> ControlWrite? {
    // Message-on-change (finding 2): only a slot whose accumulator differs from what was last
    // ASSERTED goes out this poll — see `lastAsserted`'s own doc comment.
    var slots: [ControlSlot: Float] = [:]
    for (slot, value) in accumulators where lastAsserted[slot] != value {
      slots[slot] = value
      lastAsserted[slot] = value
    }
    let toggles = resolveToggles()
    let eraseStep = pendingEraseStep
    pendingEraseStep = nil
    if slots.isEmpty && toggles.isEmpty && eraseStep == nil {
      return nil   // assert nothing this frame — ControlRouter falls through (spec §04 §1.2)
    }
    return ControlWrite(slots: slots, toggles: toggles, eraseStep: eraseStep)
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

  private func accumulate(_ delta: Float, into axis: TrackpadAxis) {
    let current = accumulators[axis.slot] ?? 0
    accumulators[axis.slot] = min(1, max(-1, current + delta * axis.sensitivity))
  }
}
