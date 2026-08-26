import XCTest
@testable import FeedbaxKit

final class RotaFoldTests: XCTestCase {
  /// The patch's erase mapping, `scale 0 1. 0.8 1. 3.` (`Feedbax.maxpat` obj-84). These
  /// expectations were MEASURED from a live Max 9.1.5 object, not derived: `scale` defaults to
  /// `classic 1`, whose curve is `outLow + span·pow(exp, x − inHigh)` on the RAW input, not the
  /// `0.8 + 0.2·t³` power curve this test used to assert (that is `@classic 0`, the mode this
  /// patch does not use — see `maxScale`'s doc comment). The practical difference is large and
  /// in the opposite direction from what spec §01 §2 claims: the real curve is biased HIGH,
  /// already at 0.9155 by half travel rather than sitting near 0.8 for most of it.
  func testMaxScaleEraseCurve() {
    XCTAssertEqual(maxScale(0.5, 0, 1, 0.8, 1.0, exp: 3), 0.915470053838, accuracy: 1e-6)
    XCTAssertEqual(maxScale(0.9, 0, 1, 0.8, 1.0, exp: 3), 0.979191691968, accuracy: 1e-6)
    XCTAssertEqual(maxScale(1.0, 0, 1, 0.8, 1.0, exp: 3), 1.0, accuracy: 1e-6)
  }
  func testMaxScaleLinearAndReversed() {
    // theta map: scale(-1,1 → +π,−π) — reversed hi/lo (spec §01 §4)
    XCTAssertEqual(maxScale(1, -1, 1, .pi, -.pi), -.pi, accuracy: 1e-6)
    XCTAssertEqual(maxScale(-1, -1, 1, .pi, -.pi), .pi, accuracy: 1e-6)
    XCTAssertEqual(maxScale(0, -1, 1, 0.4, 1.2), 0.8, accuracy: 1e-6)  // zoom center
  }
  func testMaxScaleDoesNotClip() {
    // Max's scale extrapolates beyond lo/hi (spec §01 §4 note) — out-of-domain input must not clamp.
    XCTAssertEqual(maxScale(2, -1, 1, -2000, 2000), 4000, accuracy: 1e-3)
  }

  // fold: period-2·size reflection (spec §01 §4, boundmode 4). Hand-computed, size = 100:
  func testFoldReflectsAtEdges() {
    XCTAssertEqual(fold(SIMD2(105, 50), size: SIMD2(100, 100)).x, 95, accuracy: 1e-4) // overshoot reflects
    XCTAssertEqual(fold(SIMD2(-5, 50), size: SIMD2(100, 100)).x, 5, accuracy: 1e-4)   // undershoot reflects
    XCTAssertEqual(fold(SIMD2(205, 50), size: SIMD2(100, 100)).x, 5, accuracy: 1e-4)  // period 2·size
    XCTAssertEqual(fold(SIMD2(42, 50), size: SIMD2(100, 100)).x, 42, accuracy: 1e-4)  // in-bounds untouched
  }

  // rota: inverse warp in pixel coords about anchor (spec §01 §4 GLSL, quoted verbatim in the spec)
  func testRotaIdentity() {
    let p = rotaSource(point: SIMD2(30, 40), size: SIMD2(100, 100), zoom: 1, theta: 0,
                       offset: .zero, anchor: SIMD2(0.5, 0.5))
    XCTAssertEqual(p.x, 30, accuracy: 1e-4); XCTAssertEqual(p.y, 40, accuracy: 1e-4)
  }
  func testRotaZoomInSamplesSmallerNeighborhood() {
    // zoom 2 at the point 10px right of center: sample 5px right of center (scale by 1/zoom)
    let p = rotaSource(point: SIMD2(60, 50), size: SIMD2(100, 100), zoom: 2, theta: 0,
                       offset: .zero, anchor: SIMD2(0.5, 0.5))
    XCTAssertEqual(p.x, 55, accuracy: 1e-4); XCTAssertEqual(p.y, 50, accuracy: 1e-4)
  }
  func testRotaQuarterTurn() {
    // GLSL row-vector convention: no = (point−a)·mat2(c,s,−s,c)·(1/zoom) + a + offset.
    // θ=π/2, point 10px right of center → rotated = (0, −10) → sample 10px above center.
    let p = rotaSource(point: SIMD2(60, 50), size: SIMD2(100, 100), zoom: 1, theta: .pi / 2,
                       offset: .zero, anchor: SIMD2(0.5, 0.5))
    XCTAssertEqual(p.x, 50, accuracy: 1e-3); XCTAssertEqual(p.y, 40, accuracy: 1e-3)
  }
  func testNegativeZoomPointMirrors() {
    // SInvert=−1 makes zoom negative → both axes mirror about the anchor (spec §01 §4)
    let p = rotaSource(point: SIMD2(60, 70), size: SIMD2(100, 100), zoom: -1, theta: 0,
                       offset: .zero, anchor: SIMD2(0.5, 0.5))
    XCTAssertEqual(p.x, 40, accuracy: 1e-4); XCTAssertEqual(p.y, 30, accuracy: 1e-4)
  }
  func testOffsetPansInRawPixels() {
    let p = rotaSource(point: SIMD2(10, 10), size: SIMD2(100, 100), zoom: 1, theta: 0,
                       offset: SIMD2(7, -3), anchor: SIMD2(0.5, 0.5))
    XCTAssertEqual(p.x, 17, accuracy: 1e-4); XCTAssertEqual(p.y, 7, accuracy: 1e-4)
  }
}
