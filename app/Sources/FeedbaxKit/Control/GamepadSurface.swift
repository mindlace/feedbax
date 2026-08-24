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
/// Sticks get a 0.08 deadzone (Task 14: "GC framework applies none" on its own) — analog noise
/// near rest must not leak into `panX`/`panY`/`hue`/`bias`. Buttons and the d-pad are
/// edge-detected against the previous poll's snapshot: a held button/direction must not
/// re-fire every frame, unlike the continuous stick/trigger axes, which assert every frame
/// they're outside the deadzone/nonzero (there's no "gesture" to accumulate here — the pad's
/// own physical position already IS the state, same principle as `KeyboardTrackpadSurface`'s
/// held accumulators, just read directly instead of nudged).
public final class GamepadSurface: ControlSurface {
  public let id = "gamepad"

  /// Test seam (Task 14): nil → live `GCController.controllers().first?.extendedGamepad`.
  public var stateProvider: (() -> GamepadState?)?

  private static let stickDeadzone: Float = 0.08
  private static let eraseStepMagnitude: Float = 0.05
  private static let saturationStepMagnitude: Float = 0.1
  /// GC d-pad axes report as effectively digital (−1/0/1 floats); this just needs to sit
  /// strictly between "released" (0) and "pressed" (±1).
  private static let dpadPressThreshold: Float = 0.5

  /// Saturation's own held accumulator, 0...1. Seeded at 0.5 to match `ControlRouter
  /// .coldStartTarget`'s `.saturation` case — the HSL pix's own baked default — so a
  /// performer's first d-pad tap steps from the same place the engine is already rendering,
  /// not from an arbitrary unrelated rest value.
  private var saturation: Float = 0.5

  /// Previous poll's edge-detection snapshot — buttons and d-pad must not re-fire while held.
  private var previousButtons: Set<String> = []
  private var previousDpad = SIMD2<Float>.zero

  /// Per-button flip memory for the 4 buttons carrying a `ToggleEvent` with an associated
  /// Bool — same idiom as `KeyboardTrackpadSurface.toggleState`.
  private var buttonFlipState: [String: Bool] = [:]

  private var connectObserver: NSObjectProtocol?

  /// Subscribes to `GCController` connect notifications so a pad plugged in mid-session is
  /// picked up by `liveState()` on the next poll (`GCController.controllers()` reflects
  /// currently-connected pads; the notification is just for logging visibility here).
  public init() {
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
    if pad.rightTrigger != 0 { slots[.zoom] = pad.rightTrigger * 2 - 1 }
    if pad.leftTrigger != 0 { slots[.theta] = pad.leftTrigger * 2 - 1 }

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
      case "a": toggles.append(flip(.sInvert(true), for: "a"))
      case "b": toggles.append(flip(.layerEnabled(true), for: "b"))
      case "x": toggles.append(flip(.wave1Enabled(true), for: "x"))
      case "y": toggles.append(flip(.wave2Enabled(true), for: "y"))
      case "menu": toggles.append(.fullscreen)   // one-shot — no flip state, like keyboard "f"
      default: break   // unrecognized button name: ignore
      }
    }
    return toggles
  }

  private func flip(_ template: ToggleEvent, for button: String) -> ToggleEvent {
    let isOn = !(buttonFlipState[button] ?? false)
    buttonFlipState[button] = isOn
    return template.resolvingFlip(isOn)
  }

  /// Radial (magnitude-based) deadzone: below 0.08, the stick asserts neither axis at all —
  /// avoids the directional bias a per-axis deadzone would introduce near the diagonals. Above
  /// the threshold, the raw axis values pass straight through unscaled — sticks already report
  /// in the −1...1 range `ControlRouter.mappedTarget` expects for `panX`/`panY`/`hue`/`bias`.
  private func assertStick(_ v: SIMD2<Float>, x: ControlSlot, y: ControlSlot,
                            into slots: inout [ControlSlot: Float]) {
    guard simd_length(v) >= Self.stickDeadzone else { return }
    slots[x] = v.x
    slots[y] = v.y
  }

  private static func liveState() -> GamepadState? {
    guard let pad = GCController.controllers().first?.extendedGamepad else { return nil }
    return LiveGamepadState(pad: pad)
  }
}
