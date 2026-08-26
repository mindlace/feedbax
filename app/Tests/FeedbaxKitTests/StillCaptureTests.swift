import XCTest
import ImageIO
@testable import FeedbaxKit

final class StillCaptureTests: XCTestCase {
  func testWritesDatedPNGMatchingAccumulator() throws {
    let ctx = try MetalContext()
    let engine = try Engine(context: ctx)
    engine.router.applyStartupDefaults(at: 0)
    engine.setResolution(SIMD2(64, 36))
    let cb = ctx.queue.makeCommandBuffer()!
    let tex = engine.step(at: 0, commandBuffer: cb)
    cb.commit(); cb.waitUntilCompleted(); ctx.pool.endFrame()

    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let date = Date(timeIntervalSince1970: 1_787_500_000)
    let url = try StillCapture.write(tex, context: ctx, directory: dir, date: date)
    XCTAssertTrue(url.lastPathComponent.hasPrefix("feedbaxStill-"))
    XCTAssertEqual(url.pathExtension, "png")
    let src = try XCTUnwrap(CGImageSourceCreateWithURL(url as CFURL, nil))
    XCTAssertEqual(CGImageSourceGetType(src) as String?, "public.png")
    let img = try XCTUnwrap(CGImageSourceCreateImageAtIndex(src, 0, nil))
    XCTAssertEqual(img.width, 64); XCTAssertEqual(img.height, 36)
  }
}
