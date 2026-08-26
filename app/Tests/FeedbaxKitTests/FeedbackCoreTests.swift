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

  func testEraseIsAHardClearToEraseColorAndAlpha() throws {
    // Seed one white frame, disable the feedback plane (test hook), then run a single
    // erase-only frame at α=0.9: `jit.gl.node`'s erase is a hard FBO clear to
    // (erase_color, erase_alpha) — no residual of the previous (white) frame survives
    // (docs/diagnosis-2026-08-23.md, "Trail-fade parity").
    let ctx = try MetalContext()
    let core = try makeCore(ctx)
    var p = Self.identityParams(erase: 1.0)
    core.feedbackPlaneEnabled = false
    _ = runFrame(ctx, core, p) { enc in core.drawSolid(enc, color: SIMD4(1, 1, 1, 1)) }

    p.eraseAlpha = 0.9
    let px1 = runFrame(ctx, core, p, index: 1)
    XCTAssertEqual(px1[0].x, p.eraseColor.x, accuracy: 3.0 / 255, "hard clear: no rgb residual")
    XCTAssertEqual(px1[0].y, p.eraseColor.y, accuracy: 3.0 / 255, "hard clear: no rgb residual")
    XCTAssertEqual(px1[0].z, p.eraseColor.z, accuracy: 3.0 / 255, "hard clear: no rgb residual")
    XCTAssertEqual(px1[0].w, 0.9, accuracy: 3.0 / 255, "clear alpha == eraseAlpha")

    // A second frame at a different eraseAlpha must land exactly that alpha too — the
    // clear alpha must not accumulate/blend across frames.
    p.eraseAlpha = 0.85
    let px2 = runFrame(ctx, core, p, index: 2)
    XCTAssertEqual(px2[0].w, 0.85, accuracy: 3.0 / 255, "clear alpha does not accumulate across frames")
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

  func testRenderParamsDefaultToNearestAndForwardTheFilter() {
    var params = RenderParams(zoom: 1, theta: 0, offsetPx: .zero, hueShift: 0, satDelta: 0,
                              lightDelta: 0, eraseAlpha: 1)
    XCTAssertEqual(params.warpFilter, .nearest, "parity default (diagnosis doc, term 1)")
    XCTAssertEqual(params.warpParams.nearest, 1)
    params.warpFilter = .linear
    XCTAssertEqual(params.warpParams.nearest, 0)
  }
}
