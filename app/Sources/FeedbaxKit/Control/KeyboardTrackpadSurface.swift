import Foundation

/// The performer's day-one input path (design §5 baseline-local-input): local keyboard and
/// trackpad, driven entirely by `Bindings` — no exotic hardware required for P1. Task 19/20
/// forward real `NSEvent`s into `keyDown`/`scroll`/`magnify`/`modifiedDrag`; tests call them
/// directly.
///
/// Two kinds of state, matching the two kinds of thing a performer does with this surface:
/// - **Accumulators** (`panX`/`panY`/`zoom`/`hue`/`theta`) behave like the original's sliders
///   — a gesture nudges a held position, clamped to −1...1, and `poll` keeps asserting that
///   position every frame while it's nonzero (mirrors the original's `mIniCtlSmooth` inputs,
///   which hold their last value until moved again).
/// - **Toggles and the erase step** are one-shot events: `poll` hands back whatever queued
///   since the last call and drains the queue, same as the original's hard cuts.
public final class KeyboardTrackpadSurface: ControlSurface {
  public let id = "keyboard-trackpad"

  private let bindings: Bindings

  /// Held position per trackpad-bound slot, clamped −1...1 — the raw range shared by every
  /// slot these three gestures touch (`ControlRouter.mappedTarget`: hue/panX/panY/zoom/theta
  /// all map from −1...1). Sparse: a slot only appears once a gesture has touched it, which
  /// is also how `poll`'s partial write ("only touched slots," design §5) falls out for free
  /// — nothing here for an untouched slot to filter.
  private var accumulators: [ControlSlot: Float] = [:]

  /// Per-key on/off memory for every key `bindings.keys` maps to a `ToggleEvent`. This is
  /// what actually resolves the flip `Bindings`' placeholder Bool can't (see `Bindings`' doc
  /// comment) — first press of a key flips it `true`, second flips back to `false`, and so on.
  private var toggleState: [String: Bool] = [:]

  /// Toggle events queued since the last `poll`, drained whole on read.
  private var pendingToggles: [ToggleEvent] = []

  /// Pending erase nudge, drained on read. `[`/`]` are hardcoded here rather than data-driven
  /// through `Bindings.keys` — deliberately: `ToggleEvent` has no case that carries a signed
  /// float step, and `ControlWrite.eraseStep` is a controller-level concept (Task 11's note,
  /// ControlVector.swift) outside the 9-slot vector entirely, so it doesn't fit the bindings
  /// table's "key → ToggleEvent" shape without widening that contract past what Task 13 needs.
  private var pendingEraseStep: Float?

  private static let eraseStepMagnitude: Float = 0.05

  public init(bindings: Bindings) {
    self.bindings = bindings
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
    let isOn = !(toggleState[key] ?? false)
    toggleState[key] = isOn
    pendingToggles.append(template.resolvingFlip(isOn))
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
    let slots = accumulators.filter { $0.value != 0 }   // "while nonzero" — design §5's partial write
    let toggles = pendingToggles
    let eraseStep = pendingEraseStep
    pendingToggles = []
    pendingEraseStep = nil
    if slots.isEmpty && toggles.isEmpty && eraseStep == nil {
      return nil   // assert nothing this frame — ControlRouter falls through (spec §04 §1.2)
    }
    return ControlWrite(slots: slots, toggles: toggles, eraseStep: eraseStep)
  }

  private func accumulate(_ delta: Float, into axis: TrackpadAxis) {
    let current = accumulators[axis.slot] ?? 0
    accumulators[axis.slot] = min(1, max(-1, current + delta * axis.sensitivity))
  }
}
