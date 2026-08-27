import Foundation

/// Arbitration between the two-finger gestures AppKit delivers SIMULTANEOUSLY during one
/// physical movement (design §6.3): a twist leaks small `magnify` deltas and vice versa, and
/// at sensitivity 1 fifty leaked ±0.01 pinch events is half the zoom range. A sequence
/// starts idle; each gesture's travel accumulates; the first to cross its threshold claims the
/// sequence and the others are discarded until the winner's `.ended`/`.cancelled` arrives.
/// Movement before the threshold is not applied — ordinary hysteresis.
///
/// A `struct` with `mutating` methods, not a class: it's a value the surface owns outright,
/// with no identity of its own to share.
struct GestureLock: Equatable {
  enum State: Equatable {
    case idle
    case claimed(TrackpadGesture)
  }

  private(set) var state: State = .idle
  /// Cumulative |delta| per gesture while idle.
  private var travel: [TrackpadGesture: Float] = [:]

  /// Normalised units (design §6.3): scroll is in output-heights, pinch is `magnification`,
  /// rotate is degrees/180 — so 5° is 0.028. First guesses, flagged for tuning (design §12).
  static let thresholds: [TrackpadGesture: Float] = [
    .scroll: 0.02,
    .pinch: 0.05,
    .rotate: 5.0 / 180.0,
  ]

  /// Whether `event`'s delta should be applied.
  mutating func admit(_ event: GestureEvent) -> Bool {
    // Drag is one finger with the button held — it can't co-occur with the two-finger set,
    // so it is never contested and never touches the lock.
    guard let threshold = Self.thresholds[event.gesture] else { return true }
    switch event.phase {
    case .ended, .cancelled:
      if state == .claimed(event.gesture) {
        state = .idle
        travel = [:]
      } else {
        travel[event.gesture] = nil
      }
      return false
    case .began, .changed:
      if case .claimed(let winner) = state { return winner == event.gesture }
      let total = (travel[event.gesture] ?? 0) + abs(event.delta.x) + abs(event.delta.y)
      travel[event.gesture] = total
      guard total >= threshold else { return false }
      state = .claimed(event.gesture)
      travel = [:]
      return true
    }
  }
}
