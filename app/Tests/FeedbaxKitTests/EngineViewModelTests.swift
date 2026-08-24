import XCTest
@testable import FeedbaxKit

final class EngineViewModelTests: XCTestCase {
  func testSliderWritesAreAssertedOnceThenDrained() {
    let vm = EngineViewModel()
    vm.slider(.hue, changedTo: 0.5)
    let w = vm.poll(0)!
    XCTAssertEqual(w.slots[.hue]!, 0.5, accuracy: 1e-6)
    XCTAssertNil(vm.poll(0)?.slots[.hue], "drained after poll — sliders assert on change only")
  }
  func testSliderRanges() {
    XCTAssertEqual(EngineViewModel.range(for: .hue), -1.0...1.0)
    XCTAssertEqual(EngineViewModel.range(for: .saturation), 0.0...1.0,
                   "sat is the one unipolar slot (spec §04 §1.2)")
  }
  func testToggleEmitsEvent() {
    let vm = EngineViewModel()
    vm.setSInvert(true)
    XCTAssertEqual(vm.poll(0)?.toggles, [.sInvert(true)])
  }
}
