import XCTest
import AppKit
@testable import FeedbaxKit

/// The monitor's *decisions* are pure and tested here. Installing a real
/// `NSEvent.addLocalMonitorForEvents` monitor and synthesizing events through a live app needs
/// a window server the test process does not have, so the install/uninstall plumbing is
/// verified by hand (Task 5's manual pass), exactly as `FrameClock` always has been.
final class PerformerInputMonitorTests: XCTestCase {
  func testKeysForwardWhenNoTextFieldIsFocused() {
    XCTAssertEqual(
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: false, characters: "i"),
      .forward)
  }

  func testKeysPassThroughWhileTypingInATextField() {
    XCTAssertEqual(
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: true, characters: "i"),
      .passThrough,
      "typing a preset name must not fire a key binding")
  }

  func testKeysWithNoCharactersPassThrough() {
    XCTAssertEqual(
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: false, characters: nil),
      .passThrough)
    XCTAssertEqual(
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: false, characters: ""),
      .passThrough)
  }

  func testPointerGesturesOnlyForwardFromTheOutputWindow() {
    XCTAssertEqual(PerformerInputMonitor.decidePointer(eventIsInOutputWindow: true), .forward)
    XCTAssertEqual(PerformerInputMonitor.decidePointer(eventIsInOutputWindow: false),
                   .passThrough,
                   "two-finger scroll over the control panel scrolls the panel")
  }

  func testTextEditorDetectionRecognizesFieldEditorsAndTextViews() {
    XCTAssertTrue(PerformerInputMonitor.isTextEditor(NSTextView()))
    XCTAssertTrue(PerformerInputMonitor.isTextEditor(NSTextField()))
    XCTAssertFalse(PerformerInputMonitor.isTextEditor(NSView()))
    XCTAssertFalse(PerformerInputMonitor.isTextEditor(nil))
  }

  /// "i" is `DefaultBindings.json`'s `sInvert` toggle key. With the surface's default
  /// `stateSnapshot` (`.constant(false)`), a press resolves to `.sInvert(true)` and `poll`
  /// returns a non-nil `ControlWrite` — the same behavior `KeyboardSurfaceTests
  /// .testKeyEmitsToggleOncePerPress` already demonstrates. ("e" is not bound in
  /// `DefaultBindings.json` at all and produces no write — it was the brief's placeholder, not
  /// a verified one; see Ruling 2 in Task 4's context.)
  func testForwardedKeysReachTheSurface() throws {
    let bindings = try BindingsLoader.load(from: nil)
    let surface = KeyboardTrackpadSurface(bindings: bindings)
    let monitor = PerformerInputMonitor(surface: surface, outputWindow: { nil })
    monitor.handleKey(characters: "i", firstResponderIsTextEditor: false)
    XCTAssertNotNil(surface.poll(0), "a forwarded key produced a control write")
  }

  func testTypedKeysDoNotReachTheSurface() throws {
    let bindings = try BindingsLoader.load(from: nil)
    let surface = KeyboardTrackpadSurface(bindings: bindings)
    let monitor = PerformerInputMonitor(surface: surface, outputWindow: { nil })
    monitor.handleKey(characters: "i", firstResponderIsTextEditor: true)
    XCTAssertNil(surface.poll(0), "a key typed into a text field produced no control write")
  }
}
