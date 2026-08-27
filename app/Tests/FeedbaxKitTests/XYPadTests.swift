import XCTest
@testable import FeedbaxKit

/// The pad's coordinate mapping is pure (design §7): pointer → unit square → axis range, with
/// SwiftUI's downward y flipped so "up on the pad" is +raw (design §4's `y` rule).
final class XYPadTests: XCTestCase {
  func testPointerMapsToTheUnitSquareWithYUp() {
    let size = CGSize(width: 200, height: 100)
    let centre = XYPad.unitPoint(CGPoint(x: 100, y: 50), in: size)
    XCTAssertEqual(centre.x, 0.5, accuracy: 1e-9); XCTAssertEqual(centre.y, 0.5, accuracy: 1e-9)
    let topLeft = XYPad.unitPoint(CGPoint(x: 0, y: 0), in: size)
    XCTAssertEqual(topLeft.x, 0, accuracy: 1e-9); XCTAssertEqual(topLeft.y, 1, accuracy: 1e-9, "top of the pad is y = 1")
    let outside = XYPad.unitPoint(CGPoint(x: 300, y: -20), in: size)
    XCTAssertEqual(outside.x, 1, accuracy: 1e-9); XCTAssertEqual(outside.y, 1, accuracy: 1e-9, "clamped")
  }

  func testUnitAndValueAreInverses() {
    let bipolar = -1.0...1.0, unipolar = 0.0...1.0
    XCTAssertEqual(XYPad.value(0.5, in: bipolar), 0, accuracy: 1e-9)
    XCTAssertEqual(XYPad.value(0, in: bipolar), -1, accuracy: 1e-9)
    XCTAssertEqual(XYPad.value(0.25, in: unipolar), 0.25, accuracy: 1e-9)
    for v in [-1.0, -0.3, 0, 0.7, 1] {
      XCTAssertEqual(XYPad.value(XYPad.unit(v, in: bipolar), in: bipolar), v, accuracy: 1e-9)
    }
  }
}
