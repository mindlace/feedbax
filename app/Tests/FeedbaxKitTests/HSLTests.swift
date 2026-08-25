import XCTest
@testable import FeedbaxKit

final class HSLTests: XCTestCase {
  func testPrimariesRoundTrip() {
    for rgb: SIMD3<Float> in [SIMD3(1,0,0), SIMD3(0,1,0), SIMD3(0,0,1),
                              SIMD3(1,1,0), SIMD3(0.5,0.25,0.75), SIMD3(0.2,0.2,0.2)] {
      let back = hsl2rgb(rgb2hsl(rgb))
      XCTAssertEqual(back.x, rgb.x, accuracy: 1e-4)
      XCTAssertEqual(back.y, rgb.y, accuracy: 1e-4)
      XCTAssertEqual(back.z, rgb.z, accuracy: 1e-4)
    }
  }
  func testKnownValues() {
    // Red: h=0, s=1, l=0.5. Cyan: h=0.5, s=1, l=0.5.
    let red = rgb2hsl(SIMD3(1, 0, 0))
    XCTAssertEqual(red.x, 0, accuracy: 1e-5); XCTAssertEqual(red.y, 1, accuracy: 1e-5)
    XCTAssertEqual(red.z, 0.5, accuracy: 1e-5)
    let cyan = rgb2hsl(SIMD3(0, 1, 1))
    XCTAssertEqual(cyan.x, 0.5, accuracy: 1e-5)
  }
  func testHueWrapsAndLightnessClipsThroughRGB() {
    // Additive shift: hue wraps mod 1 (spec §01 §5). Red shifted by hue +1/3 → green.
    let g = hslAdd(SIMD3(1, 0, 0), hueShift: 1.0 / 3.0, satDelta: 0, lightDelta: 0)
    XCTAssertEqual(g.y, 1, accuracy: 1e-4); XCTAssertEqual(g.x, 0, accuracy: 1e-4)
    // hue 0.9 + 0.2 wraps to 0.1, not clamps to 1.0
    let wrapped = hslAdd(hsl2rgb(SIMD3(0.9, 1, 0.5)), hueShift: 0.2, satDelta: 0, lightDelta: 0)
    XCTAssertEqual(rgb2hsl(wrapped).x, 0.1, accuracy: 1e-3)
    // A huge lightness delta still ends at white — but via the per-channel RGB clip that the
    // original's char texture applies, not an HSL-space clamp.
    let white = hslAdd(SIMD3(0.5, 0.5, 0.5), hueShift: 0, satDelta: 0, lightDelta: 5)
    XCTAssertEqual(white, SIMD3(1, 1, 1))
  }
  /// Jitter's `cc.hsl2rgb.jxs` has no S/L clamp: with S = 1 + δ, `q = L·(1 + S)` grows the
  /// max channel by (1 + δ/2) while the min channel goes negative and clips to 0. This is the
  /// SATURATION fader's per-pixel gain — the term the port was missing (diagnosis doc, term 2).
  func testSaturationAboveOneIsAGainOnAlreadySaturatedPixels() {
    let out = hslAdd(SIMD3(0.4, 0.2, 0), hueShift: 0, satDelta: 0.035, lightDelta: 0)
    XCTAssertEqual(out.x, 0.4 * 1.0175, accuracy: 1e-3, "max channel × (1 + δ/2)")
    XCTAssertEqual(out.y, 0.2, accuracy: 1e-3, "mid channel unchanged for this hue")
    XCTAssertEqual(out.z, 0, accuracy: 1e-6, "min channel clips at 0, never below")
  }
  func testNegativeLightnessClipsToBlack() {
    let out = hslAdd(SIMD3(0.002, 0.001, 0), hueShift: 0, satDelta: 0, lightDelta: -0.004)
    XCTAssertEqual(out, SIMD3(0, 0, 0))
  }
  func testRgb2HsvKnownValues() {
    let v = rgb2hsv(SIMD3(1, 0, 0))  // needed by the chroma keyer (Task 5)
    XCTAssertEqual(v.x, 0, accuracy: 1e-5); XCTAssertEqual(v.y, 1, accuracy: 1e-5)
    XCTAssertEqual(v.z, 1, accuracy: 1e-5)
  }
}
