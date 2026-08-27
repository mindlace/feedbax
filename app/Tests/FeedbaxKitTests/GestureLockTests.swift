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
