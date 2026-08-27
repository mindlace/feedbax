import XCTest
@testable import FeedbaxKit

/// Spec §6.3: one two-finger movement arrives as pinch AND rotate AND scroll events at once.
/// The first past its threshold claims the sequence; the others are discarded until it ends.
final class GestureLockTests: XCTestCase {
  private func rotate(_ deg: Float, phase: GesturePhase = .changed) -> GestureEvent {
    GestureEvent(gesture: .rotate, phase: phase, dx: deg / 180)
  }
  private func pinch(_ m: Float, phase: GesturePhase = .changed) -> GestureEvent {
    GestureEvent(gesture: .pinch, phase: phase, dx: m)
  }
  private func scroll(_ dy: Float, phase: GesturePhase = .changed) -> GestureEvent {
    GestureEvent(gesture: .scroll, phase: phase, dx: 0, dy: dy)
  }

  /// The exact sequence a real two-finger flick produces (final-review finding 1): the scroll
  /// proper ends, and THEN AppKit keeps delivering momentum events — which used to arrive as
  /// `.changed` forever because `PerformerInputMonitor.gesturePhase` read only `event.phase`
  /// (empty during momentum) and never `event.momentumPhase`. Those re-claimed the lock for
  /// `.scroll` with no terminal event to follow, so every pinch and twist after a flick was
  /// discarded. With the momentum phase mapped, the coast's own `.ended` releases the lock.
  func testMomentumScrollReleasesTheLockSoALaterPinchIsAdmitted() {
    var lock = GestureLock()
    XCTAssertTrue(lock.admit(scroll(0.1)), "the real scroll claims the sequence")
    _ = lock.admit(scroll(0, phase: .ended))
    XCTAssertEqual(lock.state, .idle, "fingers lifted")
    // The coast: each momentum event carries travel and re-claims `.scroll`.
    XCTAssertFalse(lock.admit(scroll(0.01)))
    XCTAssertTrue(lock.admit(scroll(0.01)), "0.02 cumulative crosses the scroll threshold")
    XCTAssertTrue(lock.admit(scroll(0.01)))
    XCTAssertEqual(lock.state, .claimed(.scroll))
    _ = lock.admit(scroll(0, phase: .ended))            // momentumPhase == .ended
    XCTAssertEqual(lock.state, .idle, "the coast's own end releases the lock")
    XCTAssertTrue(lock.admit(pinch(0.1)), "the next pinch is admitted, not swallowed")
  }

  func testSubThresholdMovementIsNotAdmitted() {
    var lock = GestureLock()
    XCTAssertFalse(lock.admit(rotate(2)), "2° < the 5° threshold")
    XCTAssertEqual(lock.state, .idle)
  }

  func testTravelAccumulatesAcrossEventsUntilTheThreshold() {
    var lock = GestureLock()
    XCTAssertFalse(lock.admit(rotate(2)))
    XCTAssertFalse(lock.admit(rotate(2)))
    XCTAssertTrue(lock.admit(rotate(2)), "6° cumulative — this event is admitted")
    XCTAssertEqual(lock.state, .claimed(.rotate))
  }

  func testFirstGesturePastThresholdClaimsAndTheOtherIsDiscarded() {
    var lock = GestureLock()
    XCTAssertTrue(lock.admit(rotate(10)))
    XCTAssertFalse(lock.admit(pinch(0.5)), "a large pinch is still discarded once rotate owns the sequence")
    XCTAssertTrue(lock.admit(rotate(1)), "the winner's small deltas keep flowing")
  }

  func testEndingTheWinnerReleasesTheLock() {
    var lock = GestureLock()
    XCTAssertTrue(lock.admit(pinch(0.1)))
    XCTAssertFalse(lock.admit(pinch(0, phase: .ended)), "the end event itself carries nothing to apply")
    XCTAssertEqual(lock.state, .idle)
    XCTAssertTrue(lock.admit(rotate(10)), "a fresh sequence can be claimed by the other gesture")
  }

  func testANonWinnerEndingDoesNotReleaseTheLock() {
    var lock = GestureLock()
    XCTAssertTrue(lock.admit(rotate(10)))
    _ = lock.admit(pinch(0, phase: .ended))
    XCTAssertEqual(lock.state, .claimed(.rotate))
  }

  func testCancelledReleasesLikeEnded() {
    var lock = GestureLock()
    XCTAssertTrue(lock.admit(rotate(10)))
    _ = lock.admit(rotate(0, phase: .cancelled))
    XCTAssertEqual(lock.state, .idle)
  }

  func testAnIdleEndClearsThatGesturesTravel() {
    var lock = GestureLock()
    XCTAssertFalse(lock.admit(rotate(4)))
    _ = lock.admit(rotate(0, phase: .ended))        // fingers lifted before the threshold
    XCTAssertFalse(lock.admit(rotate(2)), "travel restarted from zero")
  }

  func testDragIsNeverContested() {
    var lock = GestureLock()
    XCTAssertTrue(lock.admit(rotate(10)))
    XCTAssertTrue(lock.admit(GestureEvent(gesture: .drag, dx: 0.001, dy: 0)), "one-finger drag can't co-occur; never locked")
    XCTAssertTrue(lock.admit(GestureEvent(gesture: .drag, phase: .ended, dx: 0.001, dy: 0)), "and its end is inert")
  }
}
