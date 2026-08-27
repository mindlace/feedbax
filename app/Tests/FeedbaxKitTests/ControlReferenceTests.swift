import XCTest
@testable import FeedbaxKit

/// Spec §8.1: the reference is generated from the bindings table plus a fixed list of the keys
/// handled outside it, so it cannot drift from what the keys actually do.
final class ControlReferenceTests: XCTestCase {
  private func section(_ title: String, in reference: ControlReference) -> ControlReference.Section {
    reference.sections.first { $0.title == title }!
  }

  func testSectionsInOrder() throws {
    let r = ControlReference.build(from: try BindingsLoader.load(from: nil))
    XCTAssertEqual(r.sections.map(\.title), ["Keyboard", "Trackpad", "Pads", "Gamepad"])
  }

  func testEveryBoundKeyAppearsExactlyOnceAfterTheFixedKeys() throws {
    let bindings = try BindingsLoader.load(from: nil)
    let keyboard = section("Keyboard", in: ControlReference.build(from: bindings))
    let fixed = Array(keyboard.rows.prefix(ControlReference.fixedKeyRows.count))
    XCTAssertEqual(fixed, ControlReference.fixedKeyRows)
    XCTAssertEqual(fixed.map(\.input), ["Esc", "[", "]", "?"])
    let bound = keyboard.rows.dropFirst(fixed.count)
    XCTAssertEqual(bound.map(\.input), bindings.keys.keys.sorted(), "sorted by key, one row each")
    let iRow = bound.first { $0.input == "i" }!
    XCTAssertEqual(iRow.action, "SInvert"); XCTAssertEqual(iRow.kind, "toggle")
    let fRow = bound.first { $0.input == "f" }!
    XCTAssertEqual(fRow.kind, "one-shot")
  }

  func testTrackpadRowsFollowTheTableInOrderWithModifierSymbols() throws {
    let bindings = try BindingsLoader.load(from: nil)
    let rows = section("Trackpad", in: ControlReference.build(from: bindings)).rows
    XCTAssertEqual(rows.count, bindings.trackpad.count)
    XCTAssertEqual(rows[0], ControlReference.Row(input: "Drag (one finger)", modifiers: "", action: "Pan X / Pan Y", kind: "axes"))
    XCTAssertEqual(rows[1].modifiers, "⌥"); XCTAssertEqual(rows[1].action, "Image X / Image Y")
    XCTAssertEqual(rows[2].modifiers, "⇧"); XCTAssertEqual(rows[2].action, "Hue shift / Brightness")
    let twist = rows.first { $0.input == "Twist" && $0.modifiers.isEmpty }!
    XCTAssertEqual(twist.action, "Rotate"); XCTAssertEqual(twist.kind, "axis")
  }

  func testPadRowsReflectTheLiveAssignment() throws {
    var bindings = try BindingsLoader.load(from: nil)
    XCTAssertEqual(section("Pads", in: ControlReference.build(from: bindings)).rows.map(\.action),
                   ["Image X / Image Y", "Pan X / Pan Y"])
    bindings.pads[0] = PadAssignment(x: .slot(.hue), y: .slot(.zoom))
    XCTAssertEqual(section("Pads", in: ControlReference.build(from: bindings)).rows[0].action, "Hue shift / Zoom")
    XCTAssertEqual(section("Pads", in: ControlReference.build(from: bindings)).rows[0].input, "Pad 1")
  }

  func testGamepadRowsPassThroughAndCoverEveryInputPollReads() throws {
    let rows = section("Gamepad", in: ControlReference.build(from: try BindingsLoader.load(from: nil))).rows
    XCTAssertEqual(rows, GamepadSurface.reference)
    let inputs = rows.map(\.input).joined(separator: " ")
    for name in ["Left stick", "Right stick", "Right trigger", "Left trigger", "D-pad", "A", "B", "X", "Y", "Menu"] {
      XCTAssertTrue(inputs.contains(name), "\(name) is read by GamepadSurface.poll but has no reference row")
    }
    XCTAssertEqual(rows.first { $0.input == "Left trigger" }?.action, "Rotate", "uses ControlAxis.displayName")
  }
}
