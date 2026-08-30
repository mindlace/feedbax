import XCTest
@testable import FeedbaxKit

/// Spec §6.5: the v2 bindings table — a list of gesture rows plus two pad assignments — and
/// the decode rules that keep a hand-edited file honest.
final class BindingsTests: XCTestCase {
  private func decode(_ json: String) throws -> Bindings {
    try JSONDecoder().decode(Bindings.self, from: Data(json.utf8))
  }

  private func document(version: Int = 2, trackpad: String = "[]",
                        pads: String = #"[{"x":"layerX","y":"layerY"},{"x":"panX","y":"panY"}]"#) -> String {
    #"{"version": \#(version), "keys": {"i": "sInvert"}, "trackpad": \#(trackpad), "pads": \#(pads)}"#
  }

  private let pinchZoom = #"{"gesture":"pinch","modifiers":[],"axis":{"axis":"zoom","sensitivity":1.0}}"#
  private let dragPan = #"{"gesture":"drag","modifiers":[],"x":{"axis":"panX","sensitivity":1.0},"y":{"axis":"panY","sensitivity":1.0}}"#

  func testBundledDefaultIsVersion2WithTheDesignTable() throws {
    let b = try BindingsLoader.load(from: nil)
    XCTAssertEqual(b.version, 2)
    XCTAssertEqual(b.trackpad.count, 10, "design §6.1: ten rows")
    XCTAssertEqual(b.trackpadBinding(for: .rotate, modifiers: [])?.target,
                   .single(TrackpadAxis(axis: .slot(.theta), sensitivity: 1)))
    XCTAssertEqual(b.trackpadBinding(for: .pinch, modifiers: [.option])?.target,
                   .single(TrackpadAxis(axis: .layer(.scale), sensitivity: 1)))
    XCTAssertEqual(b.trackpadBinding(for: .drag, modifiers: [.shift])?.target,
                   .xy(x: TrackpadAxis(axis: .slot(.hue), sensitivity: 1),
                       y: TrackpadAxis(axis: .slot(.bias), sensitivity: -1)),
                   "run pass (design §12): Shift-drag up must raise BRIGHTNESS, so bias sensitivity is -1")
    XCTAssertEqual(b.trackpadBinding(for: .scroll, modifiers: [.option])?.target,
                   .xy(x: TrackpadAxis(axis: .layer(.x), sensitivity: 1),
                       y: TrackpadAxis(axis: .layer(.y), sensitivity: 1)))
    XCTAssertNil(b.trackpadBinding(for: .rotate, modifiers: [.shift]), "unbound combination")
    XCTAssertNil(b.trackpadBinding(for: .drag, modifiers: [.option, .shift]), "exact match, not subset")
    XCTAssertEqual(b.pads, Bindings.defaultPads)
    XCTAssertEqual(b.keys["i"], .sInvert(true), "keys table unchanged from v1")
  }

  func testRoundTripThroughJSONIsLossless() throws {
    let b = try BindingsLoader.load(from: nil)
    let data = try JSONEncoder().encode(b)
    XCTAssertEqual(try JSONDecoder().decode(Bindings.self, from: data), b)
  }

  func testTheOriginalPadLayoutIsTheDefault() {
    XCTAssertEqual(Bindings.defaultPads,
                   [PadAssignment(x: .layer(.x), y: .layer(.y)), PadAssignment(x: .slot(.panX), y: .slot(.panY))],
                   "left pad = image placement, right pad = shader pan (spec §04 §1.2–1.3)")
    XCTAssertEqual(Bindings.fallback.pads, Bindings.defaultPads)
    XCTAssertEqual(Bindings.fallback.version, Bindings.currentVersion)
  }

  func testVersion1IsRejected() {
    XCTAssertThrowsError(try decode(document(version: 1)))
    XCTAssertThrowsError(try decode(document(version: 3)))
  }

  func testArityMismatchIsRejected() {
    let pinchWithXY = #"{"gesture":"pinch","modifiers":[],"x":{"axis":"panX","sensitivity":1.0},"y":{"axis":"panY","sensitivity":1.0}}"#
    XCTAssertThrowsError(try decode(document(trackpad: "[\(pinchWithXY)]")), "pinch takes one axis")
    let dragWithAxis = #"{"gesture":"drag","modifiers":[],"axis":{"axis":"zoom","sensitivity":1.0}}"#
    XCTAssertThrowsError(try decode(document(trackpad: "[\(dragWithAxis)]")), "drag takes x and y")
    XCTAssertNoThrow(try decode(document(trackpad: "[\(pinchZoom), \(dragPan)]")))
  }

  func testDuplicateGestureRowIsRejected() {
    XCTAssertThrowsError(try decode(document(trackpad: "[\(pinchZoom), \(pinchZoom)]")))
  }

  func testUnknownAxisMarkerIsRejected() {
    let bad = #"{"gesture":"pinch","modifiers":[],"axis":{"axis":"warp","sensitivity":1.0}}"#
    XCTAssertThrowsError(try decode(document(trackpad: "[\(bad)]")))
  }

  func testUnknownModifierIsRejected() {
    let bad = #"{"gesture":"pinch","modifiers":["command"],"axis":{"axis":"zoom","sensitivity":1.0}}"#
    XCTAssertThrowsError(try decode(document(trackpad: "[\(bad)]")), "Command/Control are never performer modifiers")
  }

  func testPadsMustBeExactlyTwo() {
    XCTAssertThrowsError(try decode(document(pads: #"[{"x":"panX","y":"panY"}]"#)))
    XCTAssertThrowsError(try decode(document(pads: "[]")))
  }

  func testModifiersEncodeSortedForStableFiles() throws {
    let row = TrackpadBinding(gesture: .pinch, modifiers: [.shift, .option],
                              target: .single(TrackpadAxis(axis: .slot(.zoom), sensitivity: 1)))
    let text = String(data: try JSONEncoder().encode(row), encoding: .utf8)!
    XCTAssertTrue(text.contains(#""modifiers":["option","shift"]"#), text)
  }

  /// The wire names are frozen even though the Swift names moved to "image bump"
  /// (2026-08-29 design doc §4). `Bindings.toggleEvents(fromMarkers:)` THROWS on an unknown
  /// marker and `BindingsStore.init` rethrows by design, so renaming a marker is not a
  /// cosmetic change — it is a startup failure for anyone with a saved bindings file.
  func testPersistedToggleMarkersAreFrozen() throws {
    XCTAssertEqual(ToggleEvent.imageBumpEnabled(true).marker, "kittyBumpEnabled")
    XCTAssertEqual(ToggleEvent.imageEnabled(true).marker, "layerEnabled")
    XCTAssertEqual(ToggleEvent.fromMarker("kittyBumpEnabled", flip: true), .imageBumpEnabled(true))
    XCTAssertEqual(ToggleEvent.fromMarker("layerEnabled", flip: true), .imageEnabled(true))
  }
}
