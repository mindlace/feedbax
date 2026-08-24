import XCTest
@testable import FeedbaxKit

final class BrcosaTests: XCTestCase {
  func testIdentityAtDefaults() {
    // 1/1/1 is an EXACT identity — the fact that let us drop the output-brcosa toggle
    // (design §11 Resolved, 2026-08-24).
    let c = SIMD4<Float>(0.3, 0.7, 0.2, 0.4)
    XCTAssertEqual(brcosa(c, brightness: 1, contrast: 1, saturation: 1), c)
  }
  func testSaturationZeroIsRec709Grayscale() {
    let out = brcosa(SIMD4(1, 0, 0, 1), brightness: 1, contrast: 1, saturation: 0)
    XCTAssertEqual(out.x, 0.2125, accuracy: 1e-4)   // Rec.709 red weight (spec §01 §4)
    XCTAssertEqual(out.y, 0.2125, accuracy: 1e-4)
    XCTAssertEqual(out.z, 0.2125, accuracy: 1e-4)
  }
  func testContrastZeroIsFlatPivotGray() {
    let out = brcosa(SIMD4(0.9, 0.1, 0.5, 1), brightness: 1, contrast: 0, saturation: 1)
    XCTAssertEqual(out.x, 0.62, accuracy: 1e-5)     // 0.62 pivot, not 0.5 (spec §01 §4)
    XCTAssertEqual(out.y, 0.62, accuracy: 1e-5)
  }
  func testUnclampedExtrapolation() {
    // contrast 2 on white: 0.62 + 2·(1−0.62) = 1.38 — must NOT clamp (spec §01 §4)
    let out = brcosa(SIMD4(1, 1, 1, 1), brightness: 1, contrast: 2, saturation: 1)
    XCTAssertEqual(out.x, 1.38, accuracy: 1e-4)
  }
  func testAlphaPassthroughFromOriginalInput() {
    let out = brcosa(SIMD4(0.5, 0.5, 0.5, 0.123), brightness: 3, contrast: 0, saturation: 0)
    XCTAssertEqual(out.w, 0.123, accuracy: 1e-6)    // alpha from ORIGINAL input, untouched
  }
}
