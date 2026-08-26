import XCTest
import Foundation
@testable import FeedbaxKit

/// `DisplayLinkDriver` has no test here for the same reason `FrameClock` never had one — it
/// needs a real `CAMetalLayer` on a real display, which the test process has no window server
/// for. `TimerDriver` is the windowless half and is fully testable.
final class FrameDriverTests: XCTestCase {
  func testTimerDriverTicksAtRoughlyItsRate() {
    let ticked = expectation(description: "timer ticked at least 5 times")
    var count = 0
    let driver = TimerDriver(rate: 60) { tick in
      XCTAssertNil(tick.drawable, "a windowless driver presents nothing")
      count += 1
      if count == 5 { ticked.fulfill() }
    }
    // 5 frames at 60 Hz is ~83 ms; 2 s is a generous ceiling for a loaded CI machine.
    wait(for: [ticked], timeout: 2.0)
    driver.invalidate()
  }

  func testInvalidateStopsTheTimer() {
    var count = 0
    let driver = TimerDriver(rate: 60) { _ in count += 1 }
    let firstBatch = expectation(description: "some frames arrived")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { firstBatch.fulfill() }
    wait(for: [firstBatch], timeout: 2.0)
    XCTAssertGreaterThan(count, 0, "timer should have fired before invalidate")

    driver.invalidate()
    let countAtInvalidate = count
    let afterInvalidate = expectation(description: "waited past several tick intervals")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { afterInvalidate.fulfill() }
    wait(for: [afterInvalidate], timeout: 2.0)
    XCTAssertEqual(count, countAtInvalidate, "no ticks after invalidate")
  }

  func testUpdateRateRetunesAndIsANoOpAtTheSameRate() {
    let driver = TimerDriver(rate: 60) { _ in }
    XCTAssertEqual(driver.rate, 60)
    driver.updateRate(60)
    XCTAssertEqual(driver.rate, 60, "same rate — nothing to retune")
    driver.updateRate(30)
    XCTAssertEqual(driver.rate, 30)
    driver.invalidate()
  }

  func testRateIsClampedToAtLeastOne() {
    let driver = TimerDriver(rate: 0) { _ in }
    XCTAssertEqual(driver.rate, 1, "a zero/negative rate would make the tick interval infinite")
    driver.invalidate()
  }
}
