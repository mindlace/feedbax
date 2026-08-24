import XCTest
import Metal
@testable import FeedbaxKit

final class TexturePoolTests: XCTestCase {
  func testLeaseReusesReturnedTexturesAcrossFrames() throws {
    let device = try XCTUnwrap(MTLCreateSystemDefaultDevice())
    let pool = TexturePool(device: device)
    let a = pool.lease(width: 64, height: 64, format: .rgba16Float, usage: [.shaderRead, .renderTarget])
    let b = pool.lease(width: 64, height: 64, format: .rgba16Float, usage: [.shaderRead, .renderTarget])
    XCTAssertFalse(a === b, "two live leases in one frame must be distinct textures")
    pool.endFrame()
    let c = pool.lease(width: 64, height: 64, format: .rgba16Float, usage: [.shaderRead, .renderTarget])
    XCTAssertTrue(c === a || c === b, "after endFrame the pool must recycle, not allocate")
    let d = pool.lease(width: 32, height: 32, format: .rgba16Float, usage: [.shaderRead, .renderTarget])
    XCTAssertEqual(d.width, 32, "mismatched size must produce a fresh correctly-sized texture")
  }
}
