import XCTest
@testable import FeedbaxKit

final class ControlRouterTests: XCTestCase {
  func testSlotMappingsAtKnownPoints() {
    let r = ControlRouter()
    r.apply(ControlWrite(slots: [.zoom: 0, .theta: 1, .panX: 1]), at: 0)
    let p = r.tick(at: 1.0)   // 1 s ≫ 100 ms — ramps settled
    XCTAssertEqual(p.zoom, 0.8, accuracy: 1e-4)          // scale(−1,1→0.4,1.2) at 0
    XCTAssertEqual(p.theta, -.pi, accuracy: 1e-4)        // reversed map
    XCTAssertEqual(p.offsetPx.x, 2000, accuracy: 1e-1)   // ±2000 px
  }
  func testRampIsLinearOver100ms() {
    // Ramps initialize at the mapped value of raw slot 0 → zoom rest value 0.8.
    let r = ControlRouter()
    _ = r.tick(at: 0)
    r.apply(ControlWrite(slots: [.zoom: 1.0]), at: 0)     // target 1.2
    let mid = r.tick(at: 0.05)                            // linear ramp: halfway at 50 ms
    XCTAssertEqual(mid.zoom, 1.0, accuracy: 0.02)         // 0.8 → 1.2, half = 1.0
    let done = r.tick(at: 0.12)
    XCTAssertEqual(done.zoom, 1.2, accuracy: 1e-3)
  }
  func testEraseIsMappedButNeverSmoothed() {
    let r = ControlRouter()
    r.eraseControl = 0.5
    let p = r.tick(at: 0.001)                             // immediately, no ramp
    // Measured from Max 9.1.5: `scale` defaults to classic mode, so this is
    // 0.8 + 0.2·pow(3, 0.5 − 1), NOT the modern-mode 0.8 + 0.2·0.5³ this once asserted.
    XCTAssertEqual(p.eraseAlpha, 0.915470053838, accuracy: 1e-6)
  }
  func testSInvertZoomFlipsInstantlyPanRampsIn() {
    let r = ControlRouter()
    r.apply(ControlWrite(slots: [.zoom: 1.0, .panX: 1.0]), at: 0)
    _ = r.tick(at: 0.5)                                   // settle: zoom 1.2, panX 2000
    r.apply(ControlWrite(toggles: [.sInvert(true)]), at: 0.5)
    let p = r.tick(at: 0.501)                             // 1 ms later
    XCTAssertEqual(p.zoom, -1.2, accuracy: 1e-2, "zoom flip is instant (post-ramp multiply)")
    XCTAssertGreaterThan(p.offsetPx.x, 1900, "pan flip ramps (pre-map multiply)")
    let later = r.tick(at: 0.7)
    XCTAssertEqual(later.offsetPx.x, -2000, accuracy: 1, "pan settles at flipped value")
  }
  func testLastSurfaceWinsPerSlot() {
    final class Fixed: ControlSurface {
      let id: String; let write: ControlWrite
      init(_ id: String, _ w: ControlWrite) { self.id = id; write = w }
      func poll(_ time: TimeInterval) -> ControlWrite? { write }
    }
    let r = ControlRouter()
    r.surfaces = [Fixed("a", .init(slots: [.hue: -1, .zoom: 0.5])),
                  Fixed("b", .init(slots: [.hue: 1]))]
    _ = r.tick(at: 1)
    XCTAssertEqual(r.rawSlots[ControlSlot.hue.rawValue], 1, "later surface overwrites hue")
    XCTAssertEqual(r.rawSlots[ControlSlot.zoom.rawValue], 0.5, "unasserted slot keeps earlier write")
  }
  func testEraseStepNudgesAndClamps() {
    // Controller ruling (Task 14's note, pulled forward): ControlWrite.eraseStep applies a
    // relative nudge to eraseControl immediately, clamped to 0...1 — not a slot, never ramped.
    let r = ControlRouter()
    r.eraseControl = 1.0
    r.apply(ControlWrite(eraseStep: -0.05), at: 0)
    XCTAssertEqual(r.eraseControl, 0.95, accuracy: 1e-5)

    // Upper bound: a step that would overshoot 1 clamps at the ceiling, not overshoot/wrap.
    let upper = ControlRouter()
    upper.eraseControl = 0.98
    upper.apply(ControlWrite(eraseStep: 0.5), at: 0)
    XCTAssertEqual(upper.eraseControl, 1.0, accuracy: 1e-5, "eraseStep clamps at the ceiling")

    // Lower bound: a step that would undershoot 0 clamps at the floor.
    let lower = ControlRouter()
    lower.eraseControl = 0.02
    lower.apply(ControlWrite(eraseStep: -0.5), at: 0)
    XCTAssertEqual(lower.eraseControl, 0.0, accuracy: 1e-5, "eraseStep clamps at the floor")
  }
}
