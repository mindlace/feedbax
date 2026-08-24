import XCTest
@testable import FeedbaxKit

final class KeyerTests: XCTestCase {
  // Parity defaults from spec §02 §7.4: high = (1.0, 0.2, 0.1), low = (0.0, 0.15, 0.1)
  let high = LumaKeyParams(luma: 1.0, tol: 0.2, fade: 0.1)
  let low = LumaKeyParams(luma: 0.0, tol: 0.15, fade: 0.1)
  let backdrop = SIMD4<Float>(0, 0, 0, 1)

  func testHighPassKeysOutNearWhite() {
    // white: luminance 1 → delta 0 → smoothstep(0.2, 0.3, 0) = 0 → mixamount 0 →
    // binary=1 composite = backdrop (spec §02 §8 GLSL)
    let out = lumaKey(SIMD4(1, 1, 1, 1), backdrop: backdrop, high)
    XCTAssertEqual(out, backdrop)
  }
  func testMidtonesSurviveHighPass() {
    // gray 0.5: delta 0.5 > tol+fade → mixamount 1 → a kept
    let g = SIMD4<Float>(0.5, 0.5, 0.5, 1)
    XCTAssertEqual(lumaKey(g, backdrop: backdrop, high), g)
  }
  func testFadeBandIsSmoothstep() {
    // delta 0.25 → t = (0.25−0.2)/0.1 = 0.5 → smoothstep = 0.5 → half mix.
    // Find a gray with luminance 0.75: dot((g,g,g,1),(.299,.587,.114,0)) = g
    let out = lumaKey(SIMD4(0.75, 0.75, 0.75, 1), backdrop: backdrop, high)
    XCTAssertEqual(out.x, 0.375, accuracy: 1e-3)   // mix(0, 0.75, 0.5)
  }
  func testCascadeKeepsOnlyMidrange() {
    // "pass 1 keys out near-white, pass 2 keys out near-black" (spec §02 §7.3)
    let white = lumaCascade(SIMD4(1, 1, 1, 1), backdrop: backdrop, high: high, low: low)
    let black = lumaCascade(SIMD4(0.02, 0.02, 0.02, 1), backdrop: backdrop, high: high, low: low)
    let mid = lumaCascade(SIMD4(0.5, 0.5, 0.5, 1), backdrop: backdrop, high: high, low: low)
    XCTAssertEqual(white, backdrop)
    XCTAssertEqual(black, backdrop)
    XCTAssertEqual(mid, SIMD4(0.5, 0.5, 0.5, 1))
  }
  func testChromaKeyTargetColorShowsBackdrop() {
    let key = SIMD3<Float>(0.328129, 0.144197, 0.0)  // reset default (spec §02 §7.4)
    let out = chromaKey(SIMD4(key.x, key.y, key.z, 1), backdrop: backdrop,
                        color: key, tol: 0.2, fade: 0.2)
    XCTAssertEqual(out, backdrop)                     // distance 0 → backdrop
    let far = SIMD4<Float>(0, 0, 1, 1)                // blue is far in weighted HSV
    XCTAssertEqual(chromaKey(far, backdrop: backdrop, color: key, tol: 0.2, fade: 0.2), far)
  }
  func testChromaHueWeighting() {
    // weights (4,1,2) — hue distance counts 4×. Two colors equidistant in RGB can differ
    // hugely in weighted HSV: same-value/sat hue-opposite color must exceed tol+fade
    // while a value-only tweak of the key color stays keyed out.
    let key = SIMD3<Float>(1, 0, 0)
    let valueTweak = SIMD4<Float>(0.9, 0, 0, 1)      // hsv distance = 2·0.1 weighted (value w=2)
    let hueOpposite = SIMD4<Float>(0, 1, 1, 1)       // hue 0.5 away, weighted 4×
    let a = chromaKey(valueTweak, backdrop: backdrop, color: key, tol: 0.25, fade: 0.1)
    let b = chromaKey(hueOpposite, backdrop: backdrop, color: key, tol: 0.25, fade: 0.1)
    XCTAssertEqual(a, backdrop, "small value shift stays keyed out")
    XCTAssertEqual(b, hueOpposite, "hue-opposite color survives")
  }
}
