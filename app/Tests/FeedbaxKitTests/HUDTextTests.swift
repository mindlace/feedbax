import XCTest
@testable import FeedbaxKit

final class HUDTextTests: XCTestCase {
  func testHUDTextAppendsStatusLine() {
    XCTAssertEqual(OutputStage.hudText(p50: 0.001, p99: 0.0021, status: nil), "p50 1.0 ms   p99 2.1 ms")
    XCTAssertEqual(OutputStage.hudText(p50: 0.001, p99: 0.0021, status: "mic 44100 Hz   in -40 dB"),
                   "p50 1.0 ms   p99 2.1 ms   mic 44100 Hz   in -40 dB")
  }
}
