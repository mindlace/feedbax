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
}
