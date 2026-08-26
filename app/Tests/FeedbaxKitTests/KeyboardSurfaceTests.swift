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
  /// Final review, finding 4: this surface no longer keeps its own per-key flip memory — it
  /// computes the next flip from `ControlStateSnapshot`'s live truth at `poll` time. This test
  /// has no live `Engine`/`ControlRouter` to read from, so `sInvertTruth` stands in for one: the
  /// manual flip after the first poll simulates the router having actually APPLIED that write
  /// (`ControlRouter.mergeAndProcess`), which is what a real session's next tick would do
  /// between these two `poll` calls.
  func testKeyEmitsToggleOncePerPress() throws {
    var sInvertTruth = false
    let snapshot = ControlStateSnapshot(
      sInvert: { sInvertTruth }, worldBumpEnabled: { false }, waveBumpEnabled: { false },
      kittyBumpEnabled: { false }, wave1Enabled: { false }, wave2Enabled: { false },
      layerEnabled: { false })
    let s = KeyboardTrackpadSurface(bindings: try BindingsLoader.load(from: nil), stateSnapshot: snapshot)
    s.keyDown("i")
    XCTAssertEqual(s.poll(0)?.toggles, [.sInvert(true)])
    sInvertTruth = true   // stand-in for the router having applied the write above
    XCTAssertNil(s.poll(0)?.toggles.first, "consumed — poll drains the event queue")
    s.keyDown("i")
    XCTAssertEqual(s.poll(0)?.toggles, [.sInvert(false)], "second press flips back, computed from truth")
  }
  func testPollAssertsOnlyTouchedSlots() throws {
    let s = KeyboardTrackpadSurface(bindings: try BindingsLoader.load(from: nil))
    s.magnify(0.1)
    let w = s.poll(0)!
    XCTAssertNotNil(w.slots[.zoom]); XCTAssertNil(w.slots[.panX], "partial write (design §5)")
  }

  /// Final review, finding 2a: `poll` must assert a held accumulator's value the frame it
  /// changes, then go silent — NOT keep reasserting it every frame, which is what let a stale
  /// keyboard gesture permanently override whatever the gamepad/operator panel wrote to the
  /// same slot afterward.
  func testHeldGestureAssertsOnceThenSilentUntilItChangesAgain() throws {
    let s = KeyboardTrackpadSurface(bindings: try BindingsLoader.load(from: nil))
    s.scroll(dx: 0.6, dy: 0)
    XCTAssertNotNil(s.poll(0)?.slots[.panX], "first poll after a gesture asserts the held value")
    XCTAssertNil(s.poll(0.016), "a second poll with no new input must not reassert (finding 2 — message-on-change)")
    s.scroll(dx: 0.1, dy: 0)
    XCTAssertNotNil(s.poll(0.032)?.slots[.panX], "a further gesture (the accumulator actually changed) asserts again")
  }
}
