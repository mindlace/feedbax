import XCTest
@testable import FeedbaxKit

final class MetalContextTests: XCTestCase {
  func testLibraryLoadsAndNoopKernelExists() throws {
    let ctx = try MetalContext()
    XCTAssertNoThrow(try ctx.computePipeline("fbx_noop"))
  }
  func testUploadReadbackRoundTrip() throws {
    let ctx = try MetalContext()
    let px: [SIMD4<Float>] = (0..<16).map { SIMD4(Float($0) / 16, 0.5, 1.38, 1) }  // includes >1 value
    let tex = ctx.makeTexture(width: 4, height: 4, format: .rgba16Float, pixels: px)
    let back = ctx.readPixels(tex)
    for i in 0..<16 {
      XCTAssertEqual(back[i].x, px[i].x, accuracy: 2e-3)   // half precision
      XCTAssertEqual(back[i].z, 1.38, accuracy: 2e-3, "rgba16Float must preserve >1 (design §5)")
    }
  }
}
