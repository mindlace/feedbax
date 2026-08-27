import XCTest
@testable import FeedbaxKit

/// Spec §3: one axis identity for slots and layer axes, with the ranges, JSON spellings and
/// display names every surface/pad/help row derives from it.
final class ControlAxisTests: XCTestCase {
  func testLiveAxesAreTheSevenLiveSlotsPlusFourLayerAxes() {
    XCTAssertEqual(ControlAxis.live.count, 11)
    XCTAssertFalse(ControlAxis.live.contains(.slot(.scalebright)), "dead slot, spec §01 §4")
    XCTAssertFalse(ControlAxis.live.contains(.slot(.nc)), "dead slot, spec §01 §4")
    XCTAssertEqual(Array(ControlAxis.live.suffix(4)),
                   [.layer(.x), .layer(.y), .layer(.scale), .layer(.rotate)])
  }

  func testRawRangesAndClamp() {
    XCTAssertEqual(ControlAxis.slot(.saturation).rawRange, 0...1, "the one unipolar slot")
    XCTAssertEqual(ControlAxis.slot(.panX).rawRange, -1...1)
    XCTAssertEqual(ControlAxis.layer(.scale).rawRange, -1...1)
    XCTAssertEqual(ControlAxis.slot(.saturation).clamped(-0.5), 0)
    XCTAssertEqual(ControlAxis.layer(.x).clamped(3), 1)
    XCTAssertEqual(ControlAxis.layer(.x).clamped(-0.25), -0.25)
  }

  func testMarkersRoundTripForEveryLiveAxis() {
    for axis in ControlAxis.live {
      XCTAssertEqual(ControlAxis.fromMarker(axis.marker), axis, axis.marker)
    }
    XCTAssertEqual(ControlAxis.fromMarker("layerScale"), .layer(.scale))
    XCTAssertEqual(ControlAxis.fromMarker("panX"), .slot(.panX))
    XCTAssertNil(ControlAxis.fromMarker("bogus"))
  }

  func testCodableSpellsTheMarker() throws {
    let axes: [ControlAxis] = [.layer(.rotate), .slot(.hue)]
    let data = try JSONEncoder().encode(axes)
    XCTAssertEqual(String(data: data, encoding: .utf8), #"["layerRotate","hue"]"#)
    XCTAssertEqual(try JSONDecoder().decode([ControlAxis].self, from: data), axes)
    XCTAssertThrowsError(try JSONDecoder().decode(ControlAxis.self, from: Data(#""bogus""#.utf8)))
  }

  func testEveryAxisAndToggleHasADisplayName() {
    for axis in ControlAxis.live { XCTAssertFalse(axis.displayName.isEmpty, "\(axis)") }
    XCTAssertEqual(ControlAxis.slot(.theta).displayName, "Rotate")
    XCTAssertEqual(ControlAxis.layer(.rotate).displayName, "Image rotate")
    XCTAssertEqual(ToggleEvent.sInvert(true).displayName, "SInvert")
    XCTAssertEqual(ToggleEvent.stillCapture.displayName, "Still capture")
    XCTAssertTrue(ToggleEvent.fullscreen.isOneShot)
    XCTAssertFalse(ToggleEvent.wave1Enabled(true).isOneShot)
  }

  func testControlWriteSplitsAxesIntoSlotsAndLayer() {
    let w = ControlWrite(axes: [.slot(.hue): 0.2, .layer(.scale): -0.5])
    XCTAssertEqual(w.slots, [.hue: 0.2])
    XCTAssertEqual(w.layer, [.scale: -0.5])
    XCTAssertEqual(ControlWrite(slots: [.zoom: 1]).layer, [:], "existing call sites default to no layer write")
  }

  func testSnapshotRawValueDefaultsToZeroAndCanBeSupplied() {
    XCTAssertEqual(ControlStateSnapshot.constant(false).rawValue(.slot(.zoom)), 0)
    let s = ControlStateSnapshot.constant(false, rawValue: { $0 == .layer(.x) ? 0.7 : 0 })
    XCTAssertEqual(s.rawValue(.layer(.x)), 0.7)
    XCTAssertEqual(s.rawValue(.layer(.y)), 0)
  }
}
