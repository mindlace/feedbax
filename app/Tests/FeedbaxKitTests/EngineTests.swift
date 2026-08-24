import XCTest
import simd
@testable import FeedbaxKit

/// Task 19: the assembled instrument — `Engine` wires router → audio → sources → core into
/// one per-frame `step`. The determinism test is the gate the golden-frame harness (Task 22)
/// stands on: two engines fed the same injected clock must land on byte-identical pixels,
/// which only holds if nothing in the frame recipe reaches for a live clock, a live mic, or
/// any other non-injected source of variance.
final class EngineTests: XCTestCase {
  func testDeterministicHeadlessRun() throws {
    // Two engines, same injected clock and inputs → byte-identical accumulators after 30 frames.
    // This is the property the golden harness (Task 22) stands on.
    let ctx = try MetalContext()
    func run() throws -> [SIMD4<Float>] {
      let e = try Engine(context: ctx)
      e.router.applyStartupDefaults(at: 0)
      e.setResolution(SIMD2(64, 36))
      var last: MTLTexture!
      for i in 0..<30 {
        let cb = ctx.queue.makeCommandBuffer()!
        last = e.step(at: Double(i) / 60, commandBuffer: cb)
        cb.commit(); cb.waitUntilCompleted(); ctx.pool.endFrame()
      }
      return ctx.readPixels(last)
    }
    let a = try run(), b = try run()
    for i in 0..<a.count { XCTAssertEqual(a[i], b[i], "pixel \(i) diverged") }
  }
  func testResolutionPresetListMatchesSpec() {
    XCTAssertEqual(Engine.resolutionPresets.count, 14)          // Constants table
    XCTAssertTrue(Engine.resolutionPresets.contains(SIMD2(7680, 4320)))
    XCTAssertEqual(Engine.frameRatePresets, [30, 60, 90, 100, 120], "five, not four (spec §01 §1)")
  }
  func testWorldBumpGateDefaultsOff() throws {
    let e = try Engine(context: try MetalContext())
    XCTAssertFalse(e.bumpsEnabled.world); XCTAssertFalse(e.bumpsEnabled.wave)
    XCTAssertFalse(e.bumpsEnabled.kitty)   // spec §03 §7 — all three default OFF
  }
}
