import XCTest
import simd
@testable import FeedbaxKit

final class FeedbackCoreTests: XCTestCase {
  func makeCore(_ ctx: MetalContext, size: Int = 8) throws -> FeedbackCore {
    try FeedbackCore(context: ctx, size: SIMD2(size, size))
  }
  func runFrame(_ ctx: MetalContext, _ core: FeedbackCore, _ params: RenderParams,
                index: Int = 0, drawSeeds: @escaping (MTLRenderCommandEncoder) -> Void = { _ in }) -> [SIMD4<Float>] {
    let cb = ctx.queue.makeCommandBuffer()!
    let frame = FrameContext(index: index, time: Double(index) / 60, delta: 1 / 60,
                             canvasSize: SIMD2(8, 8), commandBuffer: cb, pool: ctx.pool)
    let out = core.renderFrame(frame, params: params, drawSeeds: drawSeeds)
    cb.commit(); cb.waitUntilCompleted(); ctx.pool.endFrame()
    return ctx.readPixels(out)
  }
  static func identityParams(erase: Float) -> RenderParams {
    RenderParams(zoom: 1, theta: 0, offsetPx: .zero, hueShift: 0, satDelta: 0,
                 lightDelta: 0, eraseAlpha: erase)
  }

  func testEraseResidualIsOneMinusAlphaPerFrame() throws {
    // Seed one white frame, disable the feedback plane (test hook), then run erase-only
    // frames at α=0.9: residual must be (1−0.9)^n (spec §01 §2).
    let ctx = try MetalContext()
    let core = try makeCore(ctx)
    var p = Self.identityParams(erase: 1.0)
    core.feedbackPlaneEnabled = false
    _ = runFrame(ctx, core, p) { enc in core.drawSolid(enc, color: SIMD4(1, 1, 1, 1)) }
    p.eraseAlpha = 0.9
    var value: Float = 1
    for i in 1...3 {
      let px = runFrame(ctx, core, p, index: i)
      value *= 0.1
      XCTAssertEqual(px[0].x, value, accuracy: 3.0 / 255, "frame \(i): residual (1−a)^n")
    }
  }

  func testFeedbackBlendIsSrcAlphaDstAlpha() throws {
    // prev = (0.4, 0.4, 0.4, 0.25) (seeded with plane off); this frame's seeds fill
    // (0.2, 0.2, 0.2, 0.5); warped prev blends over with (srcα, dstα):
    // rgb = 0.25·0.4 + 0.5·0.2 = 0.2 — NOT alpha-over (which would give 0.2·? ≠ this).
    let ctx = try MetalContext()
    let core = try makeCore(ctx)
    let p = Self.identityParams(erase: 1.0)
    core.feedbackPlaneEnabled = false
    _ = runFrame(ctx, core, p) { enc in core.drawSolid(enc, color: SIMD4(0.4, 0.4, 0.4, 0.25)) }
    core.feedbackPlaneEnabled = true
    let px = runFrame(ctx, core, p, index: 1) { enc in core.drawSolid(enc, color: SIMD4(0.2, 0.2, 0.2, 0.5)) }
    XCTAssertEqual(px[0].x, 0.2, accuracy: 3.0 / 255)
    // and alpha: srcα·srcα + dstα·dstα = 0.25·0.25 + 0.5·0.5 = 0.3125
    XCTAssertEqual(px[0].w, 0.3125, accuracy: 3.0 / 255)
  }

  func testResizeClearsToEraseColor() throws {
    let ctx = try MetalContext()
    let core = try makeCore(ctx)
    _ = runFrame(ctx, core, Self.identityParams(erase: 1.0)) { enc in
      core.drawSolid(enc, color: SIMD4(1, 1, 1, 1))
    }
    core.resize(SIMD2(16, 16), eraseColor: .zero)   // design §4: clear on resize
    XCTAssertEqual(core.accumulator.width, 16)
    let px = ctx.readPixels(core.accumulator)
    XCTAssertEqual(px[0].x, 0, accuracy: 1.0 / 255)
  }
}
