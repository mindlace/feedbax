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

  // MARK: - Layer channel (design §4)

  func testLayerChannelColdStartIsTheStickerDefault() {
    let r = ControlRouter()
    let t = r.layerTransform
    XCTAssertEqual(t.scale.x, 0.747, accuracy: 1e-4, "StickerSource's default scale, spec §02 §4")
    XCTAssertEqual(t.scale.y, 0.747, accuracy: 1e-4, "uniform")
    XCTAssertEqual(t.position, .zero)
    XCTAssertEqual(t.rotationZDegrees, 0)
    XCTAssertEqual(r.rawLayer, ControlRouter.startupLayerVector)
    r.applyStartupDefaults(at: 0)
    XCTAssertEqual(r.rawLayer, ControlRouter.startupLayerVector, "startup defaults reassert the same vector")
  }

  func testLayerAxesMapToWorldUnits() {
    let r = ControlRouter()
    r.apply(ControlWrite(layer: [.x: 1, .y: -1, .scale: 1, .rotate: -1]), at: 0)
    _ = r.tick(at: 1.0)   // 1 s ≫ 100 ms — settled
    let t = r.layerTransform
    XCTAssertEqual(t.position.x, 1.7, accuracy: 1e-4, "webUI centroid scale, spec §02 §4")
    XCTAssertEqual(t.position.y, -1, accuracy: 1e-4)
    XCTAssertEqual(t.scale.x, 2, accuracy: 1e-4)
    XCTAssertEqual(t.rotationZDegrees, -180, accuracy: 1e-3)
  }

  func testLayerScaleIsFlooredAboveZero() {
    let r = ControlRouter()
    r.apply(ControlWrite(layer: [.scale: -1]), at: 0)
    _ = r.tick(at: 1.0)
    XCTAssertEqual(r.layerTransform.scale.x, 0.01, accuracy: 1e-5, "a zero-size quad is degenerate")
  }

  func testLayerAxesRampLikeSlots() {
    let r = ControlRouter()
    _ = r.tick(at: 0)
    r.apply(ControlWrite(layer: [.x: 1]), at: 0)      // 0 → 1.7 over 100 ms
    _ = r.tick(at: 0.05)
    XCTAssertEqual(r.layerTransform.position.x, 0.85, accuracy: 0.05, "linear ramp: halfway at 50 ms")
    _ = r.tick(at: 0.2)
    XCTAssertEqual(r.layerTransform.position.x, 1.7, accuracy: 1e-3)
  }

  func testLastSurfaceWinsPerLayerAxis() {
    final class FixedLayer: ControlSurface {
      let id: String; let write: ControlWrite
      init(_ id: String, _ w: ControlWrite) { self.id = id; write = w }
      func poll(_ time: TimeInterval) -> ControlWrite? { write }
    }
    let r = ControlRouter()
    r.surfaces = [FixedLayer("a", .init(layer: [.x: -1, .rotate: 0.5])),
                  FixedLayer("b", .init(layer: [.x: 1]))]
    _ = r.tick(at: 1)
    XCTAssertEqual(r.rawLayer[LayerAxis.x.rawValue], 1, "later surface overwrites x")
    XCTAssertEqual(r.rawLayer[LayerAxis.rotate.rawValue], 0.5, "unasserted axis keeps earlier write")
  }

  func testRawLayerInvertsTheLayerMap() {
    // −1 is excluded for scale on purpose: the 0.01 floor makes the map non-invertible there.
    for raw: Float in [-0.9, -0.253, 0, 0.6, 1] {
      var mapped: [LayerAxis: Float] = [:]
      for axis in LayerAxis.allCases {
        mapped[axis] = ControlRouter.mappedLayerTarget(for: axis, raw: raw)
      }
      let back = ControlRouter.rawLayer(from: ControlRouter.layerTransform(from: mapped))
      for axis in LayerAxis.allCases {
        XCTAssertEqual(back[axis]!, raw, accuracy: 1e-5, "\(axis) at raw \(raw)")
      }
    }
  }

  func testRawValueReadsBothVectors() {
    let r = ControlRouter()
    r.apply(ControlWrite(slots: [.hue: 0.3], layer: [.y: -0.4]), at: 0)
    XCTAssertEqual(r.rawValue(for: .slot(.hue)), 0.3)
    XCTAssertEqual(r.rawValue(for: .layer(.y)), -0.4)
    XCTAssertEqual(r.rawValue(for: .slot(.zoom)), 0, "untouched slot")
  }
}
