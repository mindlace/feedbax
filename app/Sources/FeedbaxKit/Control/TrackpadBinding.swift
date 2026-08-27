import Foundation
import simd

/// The four trackpad gestures the surface recognizes (design §6.1). Drag is one finger with
/// the button held; the other three are two-finger gestures AppKit already recognizes and
/// delivers as `scrollWheel`/`magnify`/`rotate` events.
public enum TrackpadGesture: String, Codable, CaseIterable {
  case drag, scroll, pinch, rotate

  /// Drag/scroll move in two dimensions and bind two axes; pinch/rotate are scalar.
  var axisCount: Int { self == .drag || self == .scroll ? 2 : 1 }

  public var displayName: String {
    switch self {
    case .drag: return "Drag (one finger)"
    case .scroll: return "Scroll (two fingers)"
    case .pinch: return "Pinch"
    case .rotate: return "Twist"
    }
  }
}

/// The modifiers a performer can hold to retarget a gesture (design §6.1: Option = the image
/// layer, Shift = colour). Command/Control are deliberately not here — a chord with either is
/// an app/window shortcut and passes through untouched, as chorded keys already do.
///
/// A `Set<GestureModifier>` rather than an `OptionSet`: a set of a small `Codable` enum reads
/// as a JSON array (`["option"]`) in the hand-edited bindings file and compares by value,
/// which is all the table needs (design §13).
public enum GestureModifier: String, Codable, CaseIterable {
  case option, shift

  public var symbol: String { self == .option ? "⌥" : "⇧" }
}

/// Where in a continuous gesture an event sits — `NSEvent.Phase` reduced to what
/// `GestureLock` (Task 5) needs to know.
public enum GesturePhase: Equatable {
  case began, changed, ended, cancelled
}

/// One gesture event as the surface sees it: AppKit-free, already normalised by
/// `PerformerInputMonitor` (design §6.2). Pinch and rotate use `delta.x` only.
public struct GestureEvent: Equatable {
  public var gesture: TrackpadGesture
  public var modifiers: Set<GestureModifier>
  public var phase: GesturePhase
  public var delta: SIMD2<Float>

  public init(gesture: TrackpadGesture, modifiers: Set<GestureModifier> = [],
              phase: GesturePhase = .changed, delta: SIMD2<Float>) {
    self.gesture = gesture
    self.modifiers = modifiers
    self.phase = phase
    self.delta = delta
  }

  public init(gesture: TrackpadGesture, modifiers: Set<GestureModifier> = [],
              phase: GesturePhase = .changed, dx: Float, dy: Float = 0) {
    self.init(gesture: gesture, modifiers: modifiers, phase: phase, delta: SIMD2(dx, dy))
  }
}

/// One gesture axis's target and gain: which `ControlAxis` it nudges and how much of the
/// normalised delta lands per unit. Negative sensitivity flips a direction — the way a
/// performer whose "twist left" comes out backwards fixes it without a rebuild (design §6.2).
public struct TrackpadAxis: Equatable, Codable {
  public var axis: ControlAxis
  public var sensitivity: Float

  public init(axis: ControlAxis, sensitivity: Float) {
    self.axis = axis
    self.sensitivity = sensitivity
  }
}

/// One row of the trackpad table: (gesture, exact modifier set) → one or two axes.
public struct TrackpadBinding: Equatable {
  public enum Target: Equatable {
    case xy(x: TrackpadAxis, y: TrackpadAxis)
    case single(TrackpadAxis)
  }

  public var gesture: TrackpadGesture
  public var modifiers: Set<GestureModifier>
  public var target: Target

  public init(gesture: TrackpadGesture, modifiers: Set<GestureModifier>, target: Target) {
    self.gesture = gesture
    self.modifiers = modifiers
    self.target = target
  }
}

/// JSON shape (design §6.5): `{"gesture": "drag", "modifiers": ["option"], "x": {...}, "y": {...}}`
/// for two-axis gestures, `{"gesture": "pinch", "modifiers": [], "axis": {...}}` for scalar
/// ones. Decoding rejects an arity mismatch outright rather than guessing.
extension TrackpadBinding: Codable {
  private enum CodingKeys: String, CodingKey { case gesture, modifiers, x, y, axis }

  public init(from decoder: Decoder) throws {
    let c = try decoder.container(keyedBy: CodingKeys.self)
    gesture = try c.decode(TrackpadGesture.self, forKey: .gesture)
    modifiers = Set(try c.decodeIfPresent([GestureModifier].self, forKey: .modifiers) ?? [])
    let x = try c.decodeIfPresent(TrackpadAxis.self, forKey: .x)
    let y = try c.decodeIfPresent(TrackpadAxis.self, forKey: .y)
    let single = try c.decodeIfPresent(TrackpadAxis.self, forKey: .axis)
    switch (gesture.axisCount, x, y, single) {
    case (2, let x?, let y?, nil): target = .xy(x: x, y: y)
    case (1, nil, nil, let axis?): target = .single(axis)
    default:
      throw DecodingError.dataCorruptedError(
        forKey: .gesture, in: c,
        debugDescription: "'\(gesture.rawValue)' needs \(gesture.axisCount == 2 ? "x and y" : "axis") and nothing else")
    }
  }

  public func encode(to encoder: Encoder) throws {
    var c = encoder.container(keyedBy: CodingKeys.self)
    try c.encode(gesture, forKey: .gesture)
    // Sorted so a saved file is byte-stable across runs (a `Set` has no order of its own).
    try c.encode(modifiers.sorted { $0.rawValue < $1.rawValue }, forKey: .modifiers)
    switch target {
    case .xy(let x, let y):
      try c.encode(x, forKey: .x)
      try c.encode(y, forKey: .y)
    case .single(let axis):
      try c.encode(axis, forKey: .axis)
    }
  }
}

/// Which two axes one on-screen XY pad drives (design §7). `{"x": "layerX", "y": "layerY"}`.
public struct PadAssignment: Equatable, Codable {
  public var x: ControlAxis
  public var y: ControlAxis

  public init(x: ControlAxis, y: ControlAxis) {
    self.x = x
    self.y = y
  }
}
