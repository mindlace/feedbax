import XCTest
import Foundation
import Metal
import QuartzCore
import AppKit
import simd
@testable import FeedbaxKit

/// A `FrameDriver` that never fires on its own — the test calls `fire()` when it wants a
/// frame. This is what makes "did the swap drop or double-step a frame?" a deterministic
/// assertion instead of a race against two real clocks.
final class ManualDriver: FrameDriver {
  private(set) var rate: Int
  private(set) var invalidated = false
  private let tick: (FrameTick) -> Void
  init(rate: Int, tick: @escaping (FrameTick) -> Void) { self.rate = rate; self.tick = tick }
  func fire() { tick(FrameTick(drawable: nil)) }
  func updateRate(_ newRate: Int) { rate = newRate }
  func invalidate() { invalidated = true }
}

final class FakeDriverFactory: FrameDriverFactory {
  var windowless: [ManualDriver] = []
  var displayLinked: [ManualDriver] = []
  func makeWindowless(rate: Int, tick: @escaping (FrameTick) -> Void) -> FrameDriver {
    let d = ManualDriver(rate: rate, tick: tick); windowless.append(d); return d
  }
  func makeDisplayLinked(target: RenderTarget, rate: Int,
                         tick: @escaping (FrameTick) -> Void) -> FrameDriver {
    let d = ManualDriver(rate: rate, tick: tick); displayLinked.append(d); return d
  }
}

/// A `RenderTarget` with a layer nothing ever presents into — the fake factory never builds a
/// real display link, so the layer is only ever passed around, never drawn to.
final class FakeTarget: RenderTarget {
  let metalLayer = CAMetalLayer()
  var drawableSizePixels = SIMD2(320, 240)
  var hostingWindow: NSWindow? { nil }
}

final class EngineHostTests: XCTestCase {
  private func makeHost(_ factory: FakeDriverFactory) throws -> EngineHost {
    let engine = try Engine(context: try MetalContext())
    engine.setResolution(SIMD2(64, 64))
    return try EngineHost(engine: engine, factory: factory)
  }

  func testHostStepsWithNoTargetAttached() throws {
    let factory = FakeDriverFactory()
    let host = try makeHost(factory)
    host.start()
    XCTAssertEqual(factory.windowless.count, 1, "no window → windowless driver")
    XCTAssertTrue(factory.displayLinked.isEmpty)
    XCTAssertEqual(host.frameCount, 0)

    factory.windowless[0].fire()
    factory.windowless[0].fire()
    XCTAssertEqual(host.frameCount, 2, "the engine steps with no window in existence")
  }

  func testAttachSwapsDriversWithoutDroppingOrDoubleSteppingAFrame() throws {
    let factory = FakeDriverFactory()
    let host = try makeHost(factory)
    host.start()
    factory.windowless[0].fire()
    XCTAssertEqual(host.frameCount, 1)

    let target = FakeTarget()
    host.attach(target)
    XCTAssertTrue(factory.windowless[0].invalidated, "the old driver must be stopped")
    XCTAssertEqual(factory.displayLinked.count, 1)

    // A stale tick from the invalidated driver (already in flight when the swap happened)
    // must not step the engine a second time for the same frame.
    factory.windowless[0].fire()
    XCTAssertEqual(host.frameCount, 1, "stale driver ticks are ignored after a swap")

    factory.displayLinked[0].fire()
    XCTAssertEqual(host.frameCount, 2, "the new driver drives, continuing the same count")
  }

  func testDetachReturnsToTheWindowlessDriver() throws {
    let factory = FakeDriverFactory()
    let host = try makeHost(factory)
    host.start()
    let target = FakeTarget()
    host.attach(target)
    XCTAssertTrue(host.isAttached)

    host.detach(target)
    XCTAssertFalse(host.isAttached)
    XCTAssertTrue(factory.displayLinked[0].invalidated)
    XCTAssertEqual(factory.windowless.count, 2, "a fresh windowless driver takes over")

    factory.windowless[1].fire()
    XCTAssertEqual(host.frameCount, 1, "engine keeps stepping after the window closes")
  }

  func testDetachOfAStaleTargetIsIgnored() throws {
    let factory = FakeDriverFactory()
    let host = try makeHost(factory)
    host.start()
    let first = FakeTarget()
    let second = FakeTarget()
    host.attach(first)
    host.attach(second)
    // `first`'s view is torn down AFTER `second` attached (AppKit orders teardown after
    // setup on a window swap) — it must not detach the target that is actually live.
    host.detach(first)
    XCTAssertTrue(host.isAttached, "detach from a target that no longer owns the host is a no-op")
  }

  /// The test that encodes "closing the output window doesn't lose your image."
  func testAccumulatorSurvivesDetachAndReattach() throws {
    let factory = FakeDriverFactory()
    let engine = try Engine(context: try MetalContext())
    engine.setResolution(SIMD2(64, 64))
    engine.router.applyStartupDefaults(at: 0)
    let host = try EngineHost(engine: engine, factory: factory)
    host.start()

    for _ in 0..<8 { factory.windowless[0].fire() }
    let target = FakeTarget()
    host.attach(target)
    host.detach(target)
    for _ in 0..<2 { factory.windowless[1].fire() }

    // Non-black pixels prove the accumulator still holds evolved content rather than having
    // been reallocated/cleared by the attach/detach cycle (`FeedbackCore.resize` is the only
    // thing that legitimately clears it, and nothing here resizes).
    let commandBuffer = engine.context.queue.makeCommandBuffer()!
    let accumulator = engine.step(at: 1.0, commandBuffer: commandBuffer)
    commandBuffer.commit()
    commandBuffer.waitUntilCompleted()
    engine.context.pool.endFrame()
    let pixels = engine.context.readPixels(accumulator)
    XCTAssertTrue(pixels.contains { $0.x > 0.001 || $0.y > 0.001 || $0.z > 0.001 },
                  "the feedback image survived the window closing")
  }

  func testHudEnabledIsForwardedToTheOutputStage() throws {
    let factory = FakeDriverFactory()
    let host = try makeHost(factory)
    host.hudEnabled = false
    XCTAssertFalse(host.outputStage.hudEnabled)
    host.hudEnabled = true
    XCTAssertTrue(host.outputStage.hudEnabled)
  }

  func testDriverIsRetunedWhenTheEngineFrameRateChanges() throws {
    let factory = FakeDriverFactory()
    let host = try makeHost(factory)
    host.start()
    host.engine.frameRate = 30
    factory.windowless[0].fire()
    XCTAssertEqual(factory.windowless[0].rate, 30,
                   "a live frame-rate preset switch retunes the running driver")
  }

  func testAttachedWindowReflectsTheAttachedTarget() throws {
    let factory = FakeDriverFactory()
    let host = try makeHost(factory)
    host.start()
    XCTAssertNil(host.attachedWindow, "no target attached → no window")

    let target = FakeTarget()
    host.attach(target)
    XCTAssertNil(host.attachedWindow, "FakeTarget reports no hosting window")
  }
}
