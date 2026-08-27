import XCTest
@testable import FeedbaxKit

final class AppBootstrapTests: XCTestCase {
  /// Regression guard for the startup segfault: `AppBootstrap.start()` used to probe the input
  /// hardware with a throwaway `AVAudioEngine()` in a single expression
  /// (`AVAudioEngine().inputNode.inputFormat(forBus: 0)`). ARC has no reason to keep that engine
  /// alive past the `inputNode` getter — its last use — and `AVAudioInputNode` does not retain
  /// the engine that vends it, so `inputFormat(forBus:)` dereferenced a freed
  /// `AVAudioIONodeImpl` and killed the process before a window ever appeared. This test crashes
  /// the whole test runner (rather than merely failing) against that version, which is exactly
  /// the signal we want: the probe has to survive being called at all.
  ///
  /// Asserts the contract `start()` actually depends on rather than a specific rate — the value
  /// is whatever the machine's default input runs at (44.1 kHz here, 48 kHz elsewhere), and on
  /// a headless box with no input device it's the spec's 48 kHz fallback. All `Engine` needs is
  /// a positive, plausible rate to tune `AudioBands`' biquads against.
  func testProbeInputSampleRateSurvivesAndIsPlausible() {
    let rate = AppBootstrap.probeInputSampleRate()
    XCTAssertGreaterThanOrEqual(rate, 8000)
    XCTAssertLessThanOrEqual(rate, 192_000)
  }

  /// The probe runs once per `start()` in production, but an over-release only reliably shows up
  /// under repetition — a freed-engine read that happened to land on reclaimed-but-not-yet-reused
  /// memory once will not survive several round trips, and it must return the same rate each time.
  func testProbeInputSampleRateIsRepeatable() {
    let first = AppBootstrap.probeInputSampleRate()
    for _ in 0..<8 {
      XCTAssertEqual(AppBootstrap.probeInputSampleRate(), first)
    }
  }

  /// SwiftUI restores each `Window` scene's frame by its id — the two ids must never collide
  /// or drift.
  func testWindowIdentifiersAreDistinctAndStable() {
    XCTAssertEqual(FeedbaxWindow.outputID, "output")
    XCTAssertEqual(FeedbaxWindow.controlsID, "controls")
    XCTAssertNotEqual(FeedbaxWindow.outputID, FeedbaxWindow.controlsID)
    XCTAssertEqual(FeedbaxWindow.referenceID, "reference")
    XCTAssertEqual(Set([FeedbaxWindow.outputID, FeedbaxWindow.controlsID, FeedbaxWindow.referenceID]).count, 3)
  }
}
