import XCTest
@testable import FeedbaxKit

/// Final review, finding 3: `FrameClock` needs a real `CAMetalLayer`/window to construct at all
/// (its own type doc — "no automated test of its own for exactly that reason"), so this only
/// covers the one piece of the "rebuild/retune the clock when `Engine.frameRate` changes" fix
/// that IS headless-testable: the pure decision `MetalHostView.renderFrame` acts on every tick
/// (`clock?.updateRate(engine.frameRate)`). The actual live retuning — that
/// `CAMetalDisplayLink.preferredFrameRateRange` really does change and the display link really
/// does start firing at the new cadence — has no automated coverage here and needs manual
/// verification against a real window (same gap `FrameClock` has always had).
final class FrameClockTests: XCTestCase {
  func testShouldRetuneOnlyWhenEngineRateDiffersFromBuiltRate() {
    XCTAssertFalse(FrameClock.shouldRetune(currentEngineRate: 60, builtRate: 60),
                   "no change — retuning every unchanged frame would be pure overhead")
    XCTAssertTrue(FrameClock.shouldRetune(currentEngineRate: 120, builtRate: 60),
                  "a live preset switch must be detected")
    XCTAssertTrue(FrameClock.shouldRetune(currentEngineRate: 30, builtRate: 120))
  }
}
