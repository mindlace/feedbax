import Foundation
import GameController
import simd

/// Seam over `GCExtendedGamepad` (design §5's "Game controller" input path — "two sticks and
/// two triggers are six analog axes... d-pad steps erase and saturation, buttons carry the
/// booleans") so `GamepadSurface` is testable without a physical pad or a live `GCController`
/// connection. `GamepadSurfaceTests`' `FakePad` implements this directly; the live path wraps
/// a real `GCExtendedGamepad` in `LiveGamepadState` below.
public protocol GamepadState {
  var leftStick: SIMD2<Float> { get }
  var rightStick: SIMD2<Float> { get }
  var leftTrigger: Float { get }
  var rightTrigger: Float { get }
  var dpad: SIMD2<Float> { get }
  /// Currently-held buttons this poll, as a snapshot — not edge events. `GamepadSurface` does
  /// its own edge detection against the previous poll's snapshot (Task 14: "held ≠ re-fire").
  /// Recognized names: "a", "b", "x", "y", "menu".
  var pressedButtons: [String] { get }
}

/// Adapts a live `GCExtendedGamepad` to `GamepadState` — the only place this file touches
/// GameController framework input types beyond `GCController` itself (used to locate the
/// connected pad).
private struct LiveGamepadState: GamepadState {
  let pad: GCExtendedGamepad

  var leftStick: SIMD2<Float> { SIMD2(pad.leftThumbstick.xAxis.value, pad.leftThumbstick.yAxis.value) }
  var rightStick: SIMD2<Float> { SIMD2(pad.rightThumbstick.xAxis.value, pad.rightThumbstick.yAxis.value) }
  var leftTrigger: Float { pad.leftTrigger.value }
  var rightTrigger: Float { pad.rightTrigger.value }
  var dpad: SIMD2<Float> { SIMD2(pad.dpad.xAxis.value, pad.dpad.yAxis.value) }

  var pressedButtons: [String] {
    var names: [String] = []
    if pad.buttonA.isPressed { names.append("a") }
    if pad.buttonB.isPressed { names.append("b") }
    if pad.buttonX.isPressed { names.append("x") }
    if pad.buttonY.isPressed { names.append("y") }
    if pad.buttonMenu.isPressed { names.append("menu") }
    return names
  }
}

/// The performer's game-controller input path (design §5's baseline-local-input; the "Game
/// controller" bullet). Mapping, verbatim from the Task 14 brief's table:
///
/// - left stick x/y → `.panX` / `.panY`
/// - right stick x/y → `.hue` / `.bias` (bias feeds lightness — see `RenderParams.lightDelta`
///   and design §5's "sticks → pan + hue/lightness")
/// - right trigger 0...1 → `.zoom`, remapped to −1...1 (the raw range `ControlRouter
///   .mappedTarget` expects for that slot); left trigger 0...1 → `.theta`, same remap
/// - d-pad up/down → a ±0.05 nudge to `ControlWrite.eraseStep` (Task 11's controller-level
///   erase field, deliberately outside the 9-slot vector — never a slot write)
/// - d-pad left/right → a ∓0.1 step on `saturation`, an internal accumulator (mirroring
///   `KeyboardTrackpadSurface.accumulators`' role) clamped 0...1 and asserted as `.saturation`
///   — the one unipolar slot (`ControlRouter.mappedTarget`'s `.saturation` case maps a 0...1
///   raw range, unlike every other ramped slot's −1...1)
/// - buttons: a → SInvert flip, b → layer-enable flip, x → wave1 flip, y → wave2 flip,
///   menu → fullscreen (a one-shot UI action, no flip state — same as `KeyboardTrackpadSurface`
///   treats `.fullscreen`)
///
/// Sticks and triggers get a 0.08 deadzone (Task 14: "GC framework applies none" on its own) —
/// analog noise near rest must not leak into `panX`/`panY`/`hue`/`bias`/`zoom`/`theta`. All six
/// continuous axes are message-on-change (see `lastAsserted`): a pad held rock-steady, inside or
/// outside its deadzone, asserts nothing on a given poll, so it cannot silently overwrite
/// another surface's write. Buttons and the d-pad are separately edge-detected against the
/// previous poll's snapshot: a held button/direction must not re-fire while held, same
/// discipline, different mechanism (there's no "gesture" to accumulate here — the pad's own
/// physical position already IS the state, same principle as `KeyboardTrackpadSurface`'s held
/// accumulators, just read directly instead of nudged).
public final class GamepadSurface: ControlSurface {
  public let id = "gamepad"

  /// Test seam (Task 14): nil → live `GCController.controllers().first?.extendedGamepad`.
  public var stateProvider: (() -> GamepadState?)?

  private static let stickDeadzone: Float = 0.08
  /// Triggers share the sticks' deadzone magnitude rather than getting a bespoke constant: both
  /// are the same class of analog input (spring-loaded, GC framework applies no deadzone of its
  /// own), and there's no evidence a trigger's rest noise differs enough from a stick's to
  /// justify a second tuning knob. The bug this fixes: the original code asserted `.zoom`/
  /// `.theta` on a literal `!= 0` test, so a trigger resting at any tiny nonzero value (spring
  /// slop, sensor noise) pinned those slots forever and could clobber another surface's write.
  private static let triggerDeadzone: Float = stickDeadzone
  private static let eraseStepMagnitude: Float = 0.05
  private static let saturationStepMagnitude: Float = 0.1
  /// GC d-pad axes report as effectively digital (−1/0/1 floats); this just needs to sit
  /// strictly between "released" (0) and "pressed" (±1).
  private static let dpadPressThreshold: Float = 0.5

  /// Saturation's own held accumulator, 0...1 — a RAW slot value, pre-map. Seeded at 0.5 to
  /// match `ControlRouter.startupVector`'s `.saturation` entry (the measured steady-state
  /// raw value, which happens to be the exact midpoint of the 0...1 domain and so maps to a
  /// per-frame `satDelta` of exactly 0) — so a performer's first d-pad tap steps from the
  /// same place the engine is already rendering, not from an arbitrary unrelated rest value.
  private var saturation: Float = 0.5

  /// Previous poll's edge-detection snapshot — buttons and d-pad must not re-fire while held.
  private var previousButtons: Set<String> = []
  private var previousDpad = SIMD2<Float>.zero

  /// Whether each stick was OUTSIDE its deadzone on the PREVIOUS poll, keyed by the `x` slot
  /// passed to `assertStick` (`.panX` for the left stick, `.hue` for the right) — the edge
  /// `assertStick` detects against so a stick released back into the deadzone asserts exactly
  /// 0.0 once (final review, finding 2b) instead of silently doing nothing forever and leaving
  /// `ControlRouter.rawSlots` pinned at whatever nonzero value the stick last reported before
  /// centering. `ControlRouter` never resets a slot on its own — every surface is responsible
  /// for asserting its own "back to rest" transition, the same discipline the buttons/d-pad
  /// above already follow via `previousButtons`/`previousDpad`.
  private var previousStickOutsideDeadzone: [ControlSlot: Bool] = [:]

  /// Same edge-tracking as `previousStickOutsideDeadzone`, but for the two triggers: whether
  /// `.zoom`/`.theta`'s trigger was ABOVE `triggerDeadzone` on the previous poll, so a released
  /// trigger asserts its remapped rest value (`0 * 2 - 1 == -1`) exactly once instead of never
  /// resetting.
  private var previousTriggerAboveDeadzone: [ControlSlot: Bool] = [:]

  /// Message-on-change memory (mirrors `KeyboardTrackpadSurface.lastAsserted`): the value most
  /// recently sent out for each continuous slot (`.panX`/`.panY`/`.hue`/`.bias`/`.zoom`/
  /// `.theta`). `poll` only puts a slot in this frame's `ControlWrite` when the freshly computed
  /// value differs from what's recorded here — this is THE fix for the clobbering bug: a
  /// gamepad held steady (inside or outside its deadzone) must assert nothing so it cannot
  /// silently overwrite another surface's write (e.g. an operator dragging a slider) on the next
  /// poll.
  private var lastAsserted: [ControlSlot: Float] = [:]

  /// The live truth this surface's buttons compute their next flip FROM, instead of keeping
  /// their own memory (finding 4, final review — see `ControlStateSnapshot`'s own doc comment).
  /// Defaults to `.constant(false)`: a bare unit test that doesn't care about cross-surface
  /// reconciliation gets the same "nothing has been pressed yet" starting behavior this type
  /// always had.
  private let stateSnapshot: ControlStateSnapshot

  private var connectObserver: NSObjectProtocol?

  /// Subscribes to `GCController` connect notifications so a pad plugged in mid-session is
  /// picked up by `liveState()` on the next poll (`GCController.controllers()` reflects
  /// currently-connected pads; the notification is just for logging visibility here).
  public init(stateSnapshot: ControlStateSnapshot = .constant(false)) {
    self.stateSnapshot = stateSnapshot
    connectObserver = NotificationCenter.default.addObserver(
      forName: .GCControllerDidConnect, object: nil, queue: nil
    ) { notification in
      let name = (notification.object as? GCController)?.vendorName ?? "unknown"
      print("GamepadSurface: controller connected — \(name)")
    }
  }

  deinit {
    if let connectObserver {
      NotificationCenter.default.removeObserver(connectObserver)
    }
  }

  public func poll(_ time: TimeInterval) -> ControlWrite? {
    guard let pad = stateProvider?() ?? Self.liveState() else { return nil }

    var slots: [ControlSlot: Float] = [:]
    assertStick(pad.leftStick, x: .panX, y: .panY, into: &slots)
    assertStick(pad.rightStick, x: .hue, y: .bias, into: &slots)
    assertTrigger(pad.rightTrigger, slot: .zoom, into: &slots)
    assertTrigger(pad.leftTrigger, slot: .theta, into: &slots)

    let eraseStep = eraseStepFrom(pad.dpad)
    stepSaturationFrom(pad.dpad, into: &slots)
    previousDpad = pad.dpad

    let toggles = togglesFrom(pad.pressedButtons)

    if slots.isEmpty && toggles.isEmpty && eraseStep == nil { return nil }
    return ControlWrite(slots: slots, toggles: toggles, eraseStep: eraseStep)
  }

  /// D-pad up/down, edge-triggered: ±0.05 the instant the direction transitions from released
  /// (or the opposite direction) into pressed. Holding it must not repeat the nudge every
  /// frame.
  private func eraseStepFrom(_ dpad: SIMD2<Float>) -> Float? {
    if dpad.y > Self.dpadPressThreshold, previousDpad.y <= Self.dpadPressThreshold {
      return Self.eraseStepMagnitude    // up
    }
    if dpad.y < -Self.dpadPressThreshold, previousDpad.y >= -Self.dpadPressThreshold {
      return -Self.eraseStepMagnitude   // down
    }
    return nil
  }

  /// D-pad left/right, edge-triggered: steps the internal `saturation` accumulator by ∓0.1
  /// (left decreases, right increases — the mirrored sign from up/down's ±), clamps 0...1, and
  /// asserts it as `.saturation` only on the tap frame — same one-shot-step treatment as erase,
  /// not a continuously-reasserted held position.
  private func stepSaturationFrom(_ dpad: SIMD2<Float>, into slots: inout [ControlSlot: Float]) {
    if dpad.x > Self.dpadPressThreshold, previousDpad.x <= Self.dpadPressThreshold {
      saturation = min(1, max(0, saturation + Self.saturationStepMagnitude))   // right
      slots[.saturation] = saturation
    } else if dpad.x < -Self.dpadPressThreshold, previousDpad.x >= -Self.dpadPressThreshold {
      saturation = min(1, max(0, saturation - Self.saturationStepMagnitude))   // left
      slots[.saturation] = saturation
    }
  }

  /// Buttons a/b/x/y/menu, edge-triggered against `previousButtons`: only a button that just
  /// transitioned from released to pressed fires — holding it does not re-fire.
  private func togglesFrom(_ pressedButtons: [String]) -> [ToggleEvent] {
    let pressed = Set(pressedButtons)
    defer { previousButtons = pressed }
    var toggles: [ToggleEvent] = []
    for button in pressed.subtracting(previousButtons) {
      switch button {
      case "a": toggles.append(flip(.sInvert(true)))
      case "b": toggles.append(flip(.layerEnabled(true)))
      case "x": toggles.append(flip(.wave1Enabled(true)))
      case "y": toggles.append(flip(.wave2Enabled(true)))
      case "menu": toggles.append(.fullscreen)   // one-shot — no flip state, like keyboard "f"
      default: break   // unrecognized button name: ignore
      }
    }
    return toggles
  }

  /// Computes the NEXT flip value from `stateSnapshot`'s live truth (finding 4, final review) —
  /// this surface no longer keeps its own independent on/off memory per button; see
  /// `ControlStateSnapshot`'s doc comment for why that memory could desync from what the
  /// engine/router/operator panel actually show. Unlike `KeyboardTrackpadSurface.resolveToggles`
  /// this needs no same-poll chaining: `togglesFrom`'s `pressed.subtracting(previousButtons)` is
  /// a `Set` diff, so a given button appears in `toggles` at most once per `poll` call.
  private func flip(_ template: ToggleEvent) -> ToggleEvent {
    let current = stateSnapshot.current(for: template) ?? false
    return template.resolvingFlip(!current)
  }

  /// Radial (magnitude-based) deadzone: below 0.08, the stick asserts neither axis at all —
  /// avoids the directional bias a per-axis deadzone would introduce near the diagonals. Above
  /// the threshold, the raw axis values pass straight through unscaled — sticks already report
  /// in the −1...1 range `ControlRouter.mappedTarget` expects for `panX`/`panY`/`hue`/`bias`.
  ///
  /// Finding 2b (final review): a stick that WAS outside the deadzone and just moved back
  /// inside must assert exactly 0.0 once — the outside→inside edge, tracked per-stick in
  /// `previousStickOutsideDeadzone` — or `ControlRouter.rawSlots` stays pinned at the last
  /// outside-deadzone value forever, since nothing else ever tells it to go back to rest.
  ///
  /// Message-on-change is layered on top via `assertIfChanged`: even while outside the
  /// deadzone, a stick held rock-steady at the same reading must not re-assert every poll (that
  /// was the clobbering bug) — only an actual change in the computed target (a move, or the
  /// release-to-zero edge above) reaches `slots`.
  private func assertStick(_ v: SIMD2<Float>, x: ControlSlot, y: ControlSlot,
                            into slots: inout [ControlSlot: Float]) {
    let outside = simd_length(v) >= Self.stickDeadzone
    let wasOutside = previousStickOutsideDeadzone[x] == true
    previousStickOutsideDeadzone[x] = outside
    let targetX: Float? = outside ? v.x : (wasOutside ? 0 : nil)
    let targetY: Float? = outside ? v.y : (wasOutside ? 0 : nil)
    assertIfChanged(targetX, slot: x, into: &slots)
    assertIfChanged(targetY, slot: y, into: &slots)
  }

  /// Same shape as `assertStick`, for a single trigger axis: below `triggerDeadzone` the
  /// trigger reads as "at rest" and, on the release edge, asserts the remapped rest value
  /// (`0 * 2 - 1 == -1`) exactly once via `previousTriggerAboveDeadzone`; above it, the raw
  /// value remaps 0...1 → −1...1 as before. `assertIfChanged` then collapses this to
  /// message-on-change, same as the sticks.
  private func assertTrigger(_ raw: Float, slot: ControlSlot, into slots: inout [ControlSlot: Float]) {
    let above = raw >= Self.triggerDeadzone
    let wasAbove = previousTriggerAboveDeadzone[slot] == true
    previousTriggerAboveDeadzone[slot] = above
    let target: Float? = above ? (raw * 2 - 1) : (wasAbove ? -1 : nil)
    assertIfChanged(target, slot: slot, into: &slots)
  }

  /// Message-on-change primitive shared by `assertStick`/`assertTrigger` (mirrors
  /// `KeyboardTrackpadSurface.poll`'s `lastAsserted` diff): a `nil` target means "nothing to say
  /// this poll"; a non-nil target only reaches `slots` — and updates `lastAsserted` — if it
  /// differs from what was last actually sent for that slot. A gamepad that is not moving must
  /// produce no writes at all, so it cannot clobber another surface's write on the next poll.
  private func assertIfChanged(_ target: Float?, slot: ControlSlot, into slots: inout [ControlSlot: Float]) {
    guard let target else { return }
    guard lastAsserted[slot] != target else { return }
    slots[slot] = target
    lastAsserted[slot] = target
  }

  private static func liveState() -> GamepadState? {
    guard let pad = GCController.controllers().first?.extendedGamepad else { return nil }
    return LiveGamepadState(pad: pad)
  }
}
