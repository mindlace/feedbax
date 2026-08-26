import XCTest
@testable import FeedbaxKit

struct FakePad: GamepadState {
  var leftStick = SIMD2<Float>.zero; var rightStick = SIMD2<Float>.zero
  var leftTrigger: Float = 0; var rightTrigger: Float = 0
  var dpad = SIMD2<Float>.zero; var pressedButtons: [String] = []
}

final class GamepadSurfaceTests: XCTestCase {
  func surface(_ pad: FakePad) -> (GamepadSurface, () -> ControlWrite?) {
    var current = pad
    let s = GamepadSurface()
    s.stateProvider = { current }
    return (s, { s.poll(0) })
  }
  func testDeadzoneAssertsNothing() {
    let (_, poll) = surface(FakePad(leftStick: SIMD2(0.05, -0.05)))
    XCTAssertNil(poll()?.slots[.panX])
  }
  func testSticksAndTriggersMapToSlots() {
    var pad = FakePad(); pad.leftStick = SIMD2(1, 0.5); pad.rightTrigger = 0.75
    let (_, poll) = surface(pad)
    let w = poll()!
    XCTAssertEqual(w.slots[.panX]!, 1, accuracy: 1e-4)
    XCTAssertEqual(w.slots[.panY]!, 0.5, accuracy: 1e-4)
    XCTAssertEqual(w.slots[.zoom]!, 0.5, accuracy: 1e-4, "trigger 0..1 → −1..1")
  }
  func testButtonsAndDpadAreEdgeTriggered() {
    let s = GamepadSurface()
    var pad = FakePad(); pad.pressedButtons = ["a"]; pad.dpad = SIMD2(0, 1)
    s.stateProvider = { pad }
    let first = s.poll(0)!
    XCTAssertEqual(first.toggles, [.sInvert(true)])
    XCTAssertNotNil(first.eraseStep)   // d-pad erase is a router-side step, not a slot
                                        // (ControlSlot has no .eraseStep case — Task 11/14 note)
    let held = s.poll(0.016)
    XCTAssertNil(held, "held button/d-pad must not re-fire")
  }

  /// Final review, finding 2b: a stick that goes outside the deadzone and is then released
  /// back inside it must assert exactly 0.0 ONCE on that transition — otherwise
  /// `ControlRouter.rawSlots` stays pinned at the last outside-deadzone value forever, since
  /// nothing else ever tells it the stick is back at rest. Both axes are given nonzero values
  /// (1, 0.5) while outside the deadzone so the release genuinely changes each axis — under
  /// message-on-change, an axis whose value never actually changed is correctly NOT resent.
  func testStickReleasedIntoDeadzoneAssertsZeroOnceThenNothing() {
    var pad = FakePad(); pad.leftStick = SIMD2(1, 0.5)
    let s = GamepadSurface()
    s.stateProvider = { pad }
    let outside = s.poll(0)
    XCTAssertEqual(outside?.slots[.panX] ?? -99, 1, accuracy: 1e-4, "outside the deadzone: asserts the raw value")
    XCTAssertEqual(outside?.slots[.panY] ?? -99, 0.5, accuracy: 1e-4)

    pad.leftStick = SIMD2(0.02, 0)   // released back inside the 0.08 deadzone
    let released = s.poll(0.016)
    XCTAssertEqual(released?.slots[.panX] ?? -99, 0, accuracy: 1e-6, "outside→inside transition asserts exactly 0 once")
    XCTAssertEqual(released?.slots[.panY] ?? -99, 0, accuracy: 1e-6)

    XCTAssertNil(s.poll(0.032), "already at rest — no further reassertion")
  }

  // MARK: - Message-on-change (clobbering-bug regression)

  /// The core regression: a controller resting steady OUTSIDE the deadzone (not moving) must
  /// stop asserting after its first poll — otherwise this surface silently overwrites another
  /// surface's write (e.g. an operator panel slider) on every subsequent frame. This is the bug
  /// itself, not just the deadzone check.
  func testSteadyStickOutsideDeadzoneAssertsOnceThenNil() {
    let pad = FakePad(leftStick: SIMD2(1, 0.5))
    let s = GamepadSurface()
    s.stateProvider = { pad }
    let first = s.poll(0)
    XCTAssertEqual(first?.slots[.panX] ?? -99, 1, accuracy: 1e-4)
    XCTAssertNil(s.poll(0.016), "unmoving stick must not re-assert the same value")
    XCTAssertNil(s.poll(0.032), "still must not re-assert")
  }

  /// A still controller inside the deadzone polls to nil repeatedly — the regression test for
  /// the clobbering bug in its plainest form.
  func testStillStickInsideDeadzonePollsToNilRepeatedly() {
    let pad = FakePad(leftStick: SIMD2(0.05, -0.05))
    let s = GamepadSurface()
    s.stateProvider = { pad }
    XCTAssertNil(s.poll(0))
    XCTAssertNil(s.poll(0.016))
    XCTAssertNil(s.poll(0.032))
  }

  /// A moving stick must assert on each poll where the value actually changes.
  func testMovingStickAssertsOnEachChange() {
    var pad = FakePad(leftStick: SIMD2(0.5, 0))
    let s = GamepadSurface()
    s.stateProvider = { pad }
    XCTAssertEqual(s.poll(0)?.slots[.panX] ?? -99, 0.5, accuracy: 1e-4)

    pad.leftStick = SIMD2(0.6, 0)
    XCTAssertEqual(s.poll(0.016)?.slots[.panX] ?? -99, 0.6, accuracy: 1e-4, "changed value must re-assert")

    pad.leftStick = SIMD2(0.7, 0)
    XCTAssertEqual(s.poll(0.032)?.slots[.panX] ?? -99, 0.7, accuracy: 1e-4)
  }

  /// The `!= 0` regression: a trigger resting at a tiny non-zero value (spring slop / sensor
  /// noise, not a real press) must assert nothing at all.
  func testTriggerRestingNearZeroAssertsNothing() {
    let pad = FakePad(rightTrigger: 0.01)
    let s = GamepadSurface()
    s.stateProvider = { pad }
    XCTAssertNil(s.poll(0)?.slots[.zoom])
  }

  /// A trigger held steady above its deadzone (a genuine, unmoving press) must stop asserting
  /// after the first poll — same clobbering-bug shape as the sticks.
  func testSteadyTriggerAssertsOnceThenNil() {
    let pad = FakePad(rightTrigger: 0.75)
    let s = GamepadSurface()
    s.stateProvider = { pad }
    XCTAssertEqual(s.poll(0)?.slots[.zoom] ?? -99, 0.5, accuracy: 1e-4)
    XCTAssertNil(s.poll(0.016), "unmoving trigger must not re-assert")
  }

  /// Returning a trigger to rest must assert the remapped neutral value (`0 * 2 - 1 == -1`)
  /// exactly once, then nothing — mirrors the stick release-edge test.
  func testTriggerReleasedToRestAssertsNeutralOnceThenNil() {
    var pad = FakePad(rightTrigger: 0.75)
    let s = GamepadSurface()
    s.stateProvider = { pad }
    XCTAssertEqual(s.poll(0)?.slots[.zoom] ?? -99, 0.5, accuracy: 1e-4)

    pad.rightTrigger = 0   // released to rest
    let released = s.poll(0.016)
    XCTAssertEqual(released?.slots[.zoom] ?? -99, -1, accuracy: 1e-6, "release asserts the remapped neutral value once")

    XCTAssertNil(s.poll(0.032), "already at rest — no further reassertion")
  }
}
