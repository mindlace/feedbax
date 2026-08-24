import Foundation

/// The 9-slot control vector's slot identities (spec §04 §1.1's confirmed webui layout:
/// `pack 0. ×9` sends exactly these 9 floats, in this order — indices 0–8). Two slots are
/// dead: `.scalebright` and `.nc` are never wired to anything downstream in the original
/// (spec §01 §4), but `ControlRouter` still stores them so a preset (Task 12) round-trips
/// all 9 values, not just the 7 that are actually mapped.
public enum ControlSlot: Int, CaseIterable, Codable {
  case hue = 0, bias, scalebright, panX, panY, zoom, theta, nc, saturation
}

/// A discrete performer action that bypasses the ramp entirely (spec §01 §4). Unlike a slot
/// write, a toggle is a one-shot event, dispatched to `ControlRouter.toggleHandler` (or, for
/// `.sInvert`, consumed by the router itself) the instant it arrives — the original's hard
/// cuts, not smoothed values.
public enum ToggleEvent: Equatable, Codable {
  case sInvert(Bool)
  case worldBumpEnabled(Bool)
  case waveBumpEnabled(Bool)
  case kittyBumpEnabled(Bool)
  case wave1Enabled(Bool)
  case wave2Enabled(Bool)
  case layerEnabled(Bool)
  case fullscreen
  case stillCapture
}

/// A partial assertion from one control surface (or a preset recall): only the slots and
/// toggles it currently drives — design doc §5's `ControlWrite`. `eraseStep` is a controller
/// ruling pulled forward from Task 14's note: a relative nudge (e.g. a d-pad tap) applied
/// immediately to `ControlRouter.eraseControl` and clamped to 0...1. It is deliberately NOT
/// a slot — the erase channel lives outside the 9-slot vector and is never ramped (spec §01
/// §2) — so it gets its own field rather than overloading `slots`.
public struct ControlWrite {
  public var slots: [ControlSlot: Float]
  public var toggles: [ToggleEvent]
  public var eraseStep: Float?

  public init(slots: [ControlSlot: Float] = [:], toggles: [ToggleEvent] = [], eraseStep: Float? = nil) {
    self.slots = slots
    self.toggles = toggles
    self.eraseStep = eraseStep
  }
}

/// A performer input device — Task 13 (keyboard/trackpad) and Task 14 (gamepad) implement
/// this. `poll` takes a bare `TimeInterval` rather than the design doc's full `FrameContext`
/// (design §5): surfaces need only a clock to time their own gestures/ramps, not textures or
/// a command buffer, and `TimeInterval` keeps them constructible and testable without Metal.
/// This narrowing is recorded in the design doc §5.
public protocol ControlSurface: AnyObject {
  var id: String { get }
  /// Called once per `ControlRouter.tick`. Return nil to assert nothing this frame — lets
  /// the router's last-writer-wins arbitration (spec §04 §1.2) fall through to whatever an
  /// earlier surface (or the previous frame's raw slots) already holds.
  func poll(_ time: TimeInterval) -> ControlWrite?
}
