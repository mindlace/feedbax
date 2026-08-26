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
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: false, characters: "i",
                                       isBound: true, hasCommandOrControl: false),
      .forward)
  }

  func testKeysPassThroughWhileTypingInATextField() {
    XCTAssertEqual(
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: true, characters: "i",
                                       isBound: true, hasCommandOrControl: false),
      .passThrough,
      "typing a preset name must not fire a key binding")
  }

  func testKeysWithNoCharactersPassThrough() {
    XCTAssertEqual(
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: false, characters: nil,
                                       isBound: true, hasCommandOrControl: false),
      .passThrough)
    XCTAssertEqual(
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: false, characters: "",
                                       isBound: true, hasCommandOrControl: false),
      .passThrough)
  }

  /// Review finding: forwarding every key unconditionally (the brief's original rule) widened
  /// a local-monitor's blast radius to the whole app — an app-level monitor sees Cmd-Q, Tab,
  /// arrow keys, Space, none of which `DefaultBindings.json` binds to anything. "e" is
  /// verifiably unbound there (no entry in `keys`, and not `[`/`]`), so `isBound` is `false` for
  /// it independent of anything else about the event.
  func testUnboundKeyPassesThrough() {
    XCTAssertEqual(
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: false, characters: "e",
                                       isBound: false, hasCommandOrControl: false),
      .passThrough,
      "an unbound key must not be swallowed by the monitor")
  }

  /// Same review finding, the modifier half: a Command or Control chord (a menu shortcut, a
  /// window command) must pass through even for a key this surface DOES bind — "i" is bound
  /// (`sInvert`), so `isBound: true` alone would decide `.forward` without the chord check.
  func testCommandOrControlChordPassesThroughEvenForABoundKey() {
    XCTAssertEqual(
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: false, characters: "i",
                                       isBound: true, hasCommandOrControl: true),
      .passThrough,
      "Cmd/Ctrl-chorded keys are app/window shortcuts, not performer bindings")
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
  /// .testKeyEmitsToggleOncePerPress` already demonstrates.
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

  /// "e" is unbound (see `testUnboundKeyPassesThrough`) — the monitor must not call
  /// `surface.keyDown` for it at all, not just skip asserting a write for unrelated reasons.
  func testUnboundKeyDoesNotReachTheSurface() throws {
    let bindings = try BindingsLoader.load(from: nil)
    let surface = KeyboardTrackpadSurface(bindings: bindings)
    let monitor = PerformerInputMonitor(surface: surface, outputWindow: { nil })
    monitor.handleKey(characters: "e", firstResponderIsTextEditor: false)
    XCTAssertNil(surface.poll(0), "an unbound key produced no control write")
  }

  /// "i" is bound, but Cmd-I (or Ctrl-I) is an app/window shortcut, not a performer gesture.
  func testCommandHeldBoundKeyDoesNotReachTheSurface() throws {
    let bindings = try BindingsLoader.load(from: nil)
    let surface = KeyboardTrackpadSurface(bindings: bindings)
    let monitor = PerformerInputMonitor(surface: surface, outputWindow: { nil })
    monitor.handleKey(characters: "i", firstResponderIsTextEditor: false, hasCommandOrControl: true)
    XCTAssertNil(surface.poll(0), "a Cmd/Ctrl-chorded key produced no control write")
  }
}
