import XCTest
import AppKit
@testable import FeedbaxKit

/// The monitor's *decisions* are pure and tested here. Installing a real
/// `NSEvent.addLocalMonitorForEvents` monitor needs a window server the test process does not
/// have, so the install/uninstall plumbing is verified by hand (Task 5's manual pass), exactly
/// as `FrameClock` always has been. But `NSEvent.keyEvent(with:...)` is a plain factory —
/// unlike anything needing a real window or display link, it constructs fine headless — so
/// `handle(_:)` itself (widened from `private` to `internal` for `@testable import`) is driven
/// with real synthesized events below, covering the Escape/`f` fullscreen block, the
/// `.deviceIndependentFlagsMask` chord extraction, and the `event.window ?? NSApp.keyWindow`
/// responder lookup that the pure `decideKey`/`isTextEditor` seams skip. This also retires
/// `handleKey`, which used to be a second, parallel implementation of this same branch (minus
/// the fullscreen block) that could silently drift from `handle(_:)` — several review-driven
/// fixes had landed only in `handle(_:)`, leaving `handleKey` behind.
///
/// Virtual key codes below are the standard ANSI ones: Escape 53, `f` 3, `i` 34, `e` 14 — `i`
/// and `f` are bound in `DefaultBindings.json` (`sInvert`, `fullscreen`); `e` is not.
///
/// Every event below carries a real window's `windowNumber`, never `0`: `handle(_:)` falls
/// back to `NSApp.keyWindow` when `event.window` is nil, and `NSApp` is the implicitly-
/// unwrapped `NSApplication.shared` — nil (crashing on force-unwrap) in this headless xctest
/// process, which never runs `NSApplication.shared`/`.main()`. A real backing window makes
/// `event.window` resolve without ever touching `NSApp`.
final class PerformerInputMonitorTests: XCTestCase {
  private func keyEvent(window: NSWindow, characters: String, keyCode: UInt16,
                         modifierFlags: NSEvent.ModifierFlags = []) -> NSEvent {
    NSEvent.keyEvent(with: .keyDown, location: .zero, modifierFlags: modifierFlags,
                     timestamp: 0, windowNumber: window.windowNumber, context: nil,
                     characters: characters, charactersIgnoringModifiers: characters,
                     isARepeat: false, keyCode: keyCode)!
  }

  /// Records whether AppKit's real `toggleFullScreen(_:)` was invoked, so the fullscreen tests
  /// below can assert on the actual side effect rather than just the returned `Decision`.
  private final class RecordingWindow: NSWindow {
    var toggledFullScreen = false
    override func toggleFullScreen(_ sender: Any?) { toggledFullScreen = true }
  }

  private func makeMonitor(window: NSWindow) -> (PerformerInputMonitor, KeyboardTrackpadSurface) {
    let bindings = try! BindingsLoader.load(from: nil)
    let surface = KeyboardTrackpadSurface(bindings: bindings)
    let monitor = PerformerInputMonitor(surface: surface, outputWindow: { window })
    return (monitor, surface)
  }

  private func makeRecordingWindow() -> RecordingWindow {
    RecordingWindow(contentRect: .zero, styleMask: [], backing: .buffered, defer: false)
  }

  func testEscapeIsForwardedConsumedAndTogglesFullscreen() {
    let window = makeRecordingWindow()
    let (monitor, _) = makeMonitor(window: window)
    let event = keyEvent(window: window, characters: "\u{1b}", keyCode: 53)
    XCTAssertEqual(monitor.handle(event), .forward, "Escape is consumed, not passed through")
    XCTAssertTrue(window.toggledFullScreen, "Escape toggles fullscreen")
  }

  func testCommandEscapePassesThroughWithoutTogglingFullscreen() {
    let window = makeRecordingWindow()
    let (monitor, _) = makeMonitor(window: window)
    let event = keyEvent(window: window, characters: "\u{1b}", keyCode: 53, modifierFlags: .command)
    XCTAssertEqual(monitor.handle(event), .passThrough,
                   "Cmd-Escape is a window/app shortcut, not the performer's fullscreen toggle")
    XCTAssertFalse(window.toggledFullScreen)
  }

  func testCommandFPassesThroughWithoutTogglingFullscreen() {
    let window = makeRecordingWindow()
    let (monitor, surface) = makeMonitor(window: window)
    let event = keyEvent(window: window, characters: "f", keyCode: 3, modifierFlags: .command)
    XCTAssertEqual(monitor.handle(event), .passThrough)
    XCTAssertFalse(window.toggledFullScreen)
    XCTAssertNil(surface.poll(0), "Cmd-F must not reach the surface either")
  }

  func testOptionFDoesNotToggleFullscreenButStillReachesTheSurface() {
    // Fix 3: Option-`f` still reports plain "f" from `charactersIgnoringModifiers`, so before
    // the guard was widened from `!hasCommandOrControl` to "no chord modifiers at all" this
    // toggled fullscreen too. It's still a bound key with no Command/Control chord, so it's
    // still forwarded to the surface's normal control path.
    let window = makeRecordingWindow()
    let (monitor, surface) = makeMonitor(window: window)
    let event = keyEvent(window: window, characters: "f", keyCode: 3, modifierFlags: .option)
    XCTAssertEqual(monitor.handle(event), .forward)
    XCTAssertFalse(window.toggledFullScreen, "Option-F must not toggle fullscreen")
    XCTAssertNotNil(surface.poll(0), "Option-F is still forwarded to the surface")
  }

  func testPlainFIsForwardedConsumedAndTogglesFullscreen() {
    let window = makeRecordingWindow()
    let (monitor, surface) = makeMonitor(window: window)
    let event = keyEvent(window: window, characters: "f", keyCode: 3)
    XCTAssertEqual(monitor.handle(event), .forward)
    XCTAssertTrue(window.toggledFullScreen)
    XCTAssertNotNil(surface.poll(0), "`f` is also forwarded to the surface's fullscreen toggle")
  }

  func testUnboundKeyPassesThroughAndDoesNotReachTheSurface() {
    let window = makeRecordingWindow()
    let (monitor, surface) = makeMonitor(window: window)
    let event = keyEvent(window: window, characters: "e", keyCode: 14)
    XCTAssertEqual(monitor.handle(event), .passThrough, "\"e\" is unbound in DefaultBindings.json")
    XCTAssertNil(surface.poll(0))
  }

  func testBoundUnmodifiedKeyForwardsAndReachesTheSurface() {
    let window = makeRecordingWindow()
    let (monitor, surface) = makeMonitor(window: window)
    let event = keyEvent(window: window, characters: "i", keyCode: 34)
    XCTAssertEqual(monitor.handle(event), .forward)
    XCTAssertNotNil(surface.poll(0), "a forwarded, bound key produces a control write")
  }

  func testCommandHeldBoundKeyPassesThroughAndDoesNotReachTheSurface() {
    let window = makeRecordingWindow()
    let (monitor, surface) = makeMonitor(window: window)
    let event = keyEvent(window: window, characters: "i", keyCode: 34, modifierFlags: .command)
    XCTAssertEqual(monitor.handle(event), .passThrough)
    XCTAssertNil(surface.poll(0), "a Cmd-chorded key is a shortcut, not a performer gesture")
  }

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

}
