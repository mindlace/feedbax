import XCTest
@testable import FeedbaxKit

/// Task 13: the bindings table and the keyboard/trackpad `ControlSurface` it drives (design
/// §5's baseline-local-input — the performer's day-one input path, no exotic hardware
/// required).
final class KeyboardSurfaceTests: XCTestCase {
  func testBundledBindingsLoad() throws {
    let b = try BindingsLoader.load(from: nil)
    XCTAssertEqual(b.version, 1)
    XCTAssertEqual(b.keys["i"], .sInvert(true))   // toggle events carry the *flip* action
  }
  func testScrollAccumulatesIntoPanAndClamps() throws {
    let s = KeyboardTrackpadSurface(bindings: try BindingsLoader.load(from: nil))
    s.scroll(dx: 0.6, dy: 0)
    s.scroll(dx: 0.6, dy: 0)
    let w = s.poll(0)!
    XCTAssertEqual(w.slots[.panX]!, 1.0, accuracy: 1e-5, "clamped to slot range −1..1")
  }
  func testKeyEmitsToggleOncePerPress() throws {
    let s = KeyboardTrackpadSurface(bindings: try BindingsLoader.load(from: nil))
    s.keyDown("i")
    XCTAssertEqual(s.poll(0)?.toggles, [.sInvert(true)])
    XCTAssertNil(s.poll(0)?.toggles.first, "consumed — poll drains the event queue")
    s.keyDown("i")
    XCTAssertEqual(s.poll(0)?.toggles, [.sInvert(false)], "second press flips back")
  }
  func testPollAssertsOnlyTouchedSlots() throws {
    let s = KeyboardTrackpadSurface(bindings: try BindingsLoader.load(from: nil))
    s.magnify(0.1)
    let w = s.poll(0)!
    XCTAssertNotNil(w.slots[.zoom]); XCTAssertNil(w.slots[.panX], "partial write (design §5)")
  }
}
