import XCTest
@testable import FeedbaxKit

/// Task 13: the bindings table and the keyboard/trackpad `ControlSurface` it drives (design
/// §5's baseline-local-input — the performer's day-one input path, no exotic hardware
/// required).
final class KeyboardSurfaceTests: XCTestCase {
  /// `handles` backs `PerformerInputMonitor`'s decision about whether a keydown is this
  /// surface's business at all — `[`/`]` (the hardcoded erase step, not in `bindings.keys`),
  /// a bound key, and an unbound/unrecognized key must each answer correctly.
  func testHandlesReportsWhichKeysThisSurfaceActsOn() throws {
    let s = KeyboardTrackpadSurface(bindings: try BindingsLoader.load(from: nil))
    XCTAssertTrue(s.handles("i"), "bound toggle key")
    XCTAssertTrue(s.handles("["), "hardcoded erase-down key")
    XCTAssertTrue(s.handles("]"), "hardcoded erase-up key")
    XCTAssertFalse(s.handles("e"), "not in DefaultBindings.json's keys table")
  }

  func testBundledBindingsLoad() throws {
    let b = try BindingsLoader.load(from: nil)
    XCTAssertEqual(b.version, 2)
    XCTAssertEqual(b.keys["i"], .sInvert(true))   // toggle events carry the *flip* action
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
  private func surface(rawValue: @escaping (ControlAxis) -> Float = { _ in 0 }) throws -> KeyboardTrackpadSurface {
    KeyboardTrackpadSurface(bindings: try BindingsLoader.load(from: nil),
                            stateSnapshot: .constant(false, rawValue: rawValue))
  }

  func testTwoScrollsBeforeAPollAccumulateAndClamp() throws {
    let s = try surface()
    s.gesture(GestureEvent(gesture: .scroll, dx: 0.6, dy: 0))
    s.gesture(GestureEvent(gesture: .scroll, dx: 0.6, dy: 0))
    let w = s.poll(0)!
    XCTAssertEqual(w.slots[.panX]!, 1.0, accuracy: 1e-5, "clamped to the axis range −1..1")
    XCTAssertNil(w.slots[.panY], "a zero delta on y is not a change")
  }

  func testPollAssertsOnlyTouchedAxes() throws {
    let s = try surface()
    s.gesture(GestureEvent(gesture: .pinch, dx: 0.1))
    let w = s.poll(0)!
    XCTAssertNotNil(w.slots[.zoom]); XCTAssertNil(w.slots[.panX], "partial write (design §5)")
  }

  /// Spec §5: a nudge resolves against the router's CURRENT value, not a private accumulator.
  /// After another surface (a slider, a preset) moved pan to 0.5, the next scroll continues
  /// from 0.5 — the old accumulator would have jumped it back to its own stale position.
  func testNudgesResolveAgainstTruthAtPollTime() throws {
    var truth: [ControlAxis: Float] = [:]
    let s = try surface(rawValue: { truth[$0] ?? 0 })
    s.gesture(GestureEvent(gesture: .scroll, dx: 0.1, dy: 0))
    XCTAssertEqual(s.poll(0)?.slots[.panX], 0.1)
    truth[.slot(.panX)] = 0.5   // stand-in for a slider having moved it
    s.gesture(GestureEvent(gesture: .scroll, dx: 0.1, dy: 0))
    XCTAssertEqual(s.poll(0.016)?.slots[.panX], 0.6, "0.5 + 0.1, not 0.1 + 0.1")
  }

  func testANudgeThatLandsOnTheTruthAssertsNothing() throws {
    let s = try surface(rawValue: { $0 == .slot(.panX) ? 1.0 : 0 })
    s.gesture(GestureEvent(gesture: .scroll, dx: 0.3, dy: 0))   // already clamped at 1
    XCTAssertNil(s.poll(0), "message-on-change: clamp(1 + 0.3) == 1 == truth")
  }

  func testAGestureAssertsOnceThenStaysSilent() throws {
    let s = try surface()
    s.gesture(GestureEvent(gesture: .scroll, dx: 0.6, dy: 0))
    XCTAssertNotNil(s.poll(0)?.slots[.panX])
    XCTAssertNil(s.poll(0.016), "no new input → nothing to assert")
  }

  func testModifiersSelectTheTargetAndSensitivityScales() throws {
    let s = try surface()
    // Task 5: pinch and rotate are both lock-managed two-finger gestures (GestureLock), so —
    // unlike the one-finger drag below — each needs its own `.ended` before the next begins;
    // otherwise the pinch that claims the lock on its first event never releases it, and the
    // rotate below would be discarded outright regardless of its own delta.
    s.gesture(GestureEvent(gesture: .pinch, modifiers: [.option], dx: 0.2))
    s.gesture(GestureEvent(gesture: .pinch, modifiers: [.option], phase: .ended, dx: 0))
    s.gesture(GestureEvent(gesture: .rotate, dx: 0.25))
    s.gesture(GestureEvent(gesture: .rotate, phase: .ended, dx: 0))
    s.gesture(GestureEvent(gesture: .drag, modifiers: [.shift], dx: 0.1, dy: -0.2))
    let w = s.poll(0)!
    XCTAssertEqual(w.layer[.scale]!, 0.2, accuracy: 1e-6, "Option-pinch → image scale")
    XCTAssertEqual(w.slots[.theta]!, 0.25, accuracy: 1e-6, "twist → rotate")
    XCTAssertEqual(w.slots[.hue]!, 0.1, accuracy: 1e-6, "Shift-drag x → hue")
    XCTAssertEqual(w.slots[.bias]!, -0.2, accuracy: 1e-6, "Shift-drag y → brightness")
    XCTAssertNil(w.slots[.zoom], "plain pinch was not performed")
  }

  func testUnboundGestureCombinationIsIgnored() throws {
    let s = try surface()
    XCTAssertFalse(s.handles(.rotate, modifiers: [.shift]))
    XCTAssertTrue(s.handles(.rotate, modifiers: [.option]))
    s.gesture(GestureEvent(gesture: .rotate, modifiers: [.shift], dx: 0.5))
    XCTAssertNil(s.poll(0))
  }

  /// Review finding: a performer can change the held modifier between claiming a two-finger
  /// gesture and lifting off. If the terminal event's now-unbound modifier combination never
  /// reached `GestureLock`, the lock would stay `.claimed(.rotate)` forever and silently
  /// discard every later pinch/scroll of a different kind (design §6.3 requires the winner's
  /// `.ended`/`.cancelled` to release the lock, unconditionally).
  func testALiftOffWithAnUnboundModifierStillReleasesTheLock() throws {
    let s = try surface()
    s.gesture(GestureEvent(gesture: .rotate, modifiers: [.option], dx: 0.1))   // claims (> 5/180 threshold)
    XCTAssertNotNil(s.poll(0), "the claiming event itself nudges layerRotate")
    // The performer swaps to Shift before lifting off — rotate+shift has no bindings row.
    s.gesture(GestureEvent(gesture: .rotate, modifiers: [.shift], phase: .ended, dx: 0))
    XCTAssertNil(s.poll(0.016), "the unbound terminal event itself applies nothing")
    s.gesture(GestureEvent(gesture: .pinch, dx: 0.2))
    let w = s.poll(0.032)!
    XCTAssertEqual(w.slots[.zoom]!, 0.2, accuracy: 1e-6,
                   "the lock must have released — otherwise this pinch is discarded as a non-winner")
  }

  /// Spec §6.3 end to end: a twist that leaks pinch deltas moves rotate only.
  func testATwistThatLeaksPinchDeltasMovesRotateOnly() throws {
    let s = try surface()
    s.gesture(GestureEvent(gesture: .rotate, phase: .began, dx: 0))
    s.gesture(GestureEvent(gesture: .pinch, phase: .began, dx: 0))
    for _ in 0..<5 {
      s.gesture(GestureEvent(gesture: .rotate, dx: 3.0 / 180))   // 15° total, past 5°
      s.gesture(GestureEvent(gesture: .pinch, dx: 0.01))         // 0.05 total — would also pass alone
    }
    let w = s.poll(0)!
    XCTAssertNotNil(w.slots[.theta])
    XCTAssertNil(w.slots[.zoom], "pinch was discarded once rotate claimed the sequence")
  }
}
