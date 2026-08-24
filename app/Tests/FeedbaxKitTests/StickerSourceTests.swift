import XCTest
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
import simd
@testable import FeedbaxKit

/// Test-only failure for the PNG-writing helper below — distinct from `FeedbaxError` (that
/// enum is `FeedbaxKit`'s engine-init/shader-lookup errors, not a fit for "CGImage failed").
private enum TestFixtureError: Error { case step(String) }

final class StickerSourceTests: XCTestCase {
  var folder: URL!

  override func setUpWithError() throws {
    folder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
    // Write three 2×2 PNGs (red, green, blue; blue has alpha 0.5) via CGImage — helper below.
    try writePNG(folder.appendingPathComponent("a-red.png"), rgba: [1, 0, 0, 1])
    try writePNG(folder.appendingPathComponent("b-green.png"), rgba: [0, 1, 0, 1])
    try writePNG(folder.appendingPathComponent("c-blue.png"), rgba: [0, 0, 1, 0.5])
    try "not an image".write(to: folder.appendingPathComponent("notes.txt"), atomically: true, encoding: .utf8)
  }

  func testScanFiltersAndSortsAndCounts() throws {
    let src = StickerSource(context: try MetalContext(), folder: folder)
    XCTAssertEqual(src.itemCount, 3, "txt file excluded")
    XCTAssertEqual(src.items.map(\.lastPathComponent), ["a-red.png", "b-green.png", "c-blue.png"])
  }

  func testSelectionDecodesOnceAndTickReturnsCache() throws {
    let ctx = try MetalContext()
    let src = StickerSource(context: ctx, folder: folder)
    src.selectedIndex = 1
    let cb = ctx.queue.makeCommandBuffer()!
    let frame = FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: SIMD2(8, 8),
                             commandBuffer: cb, pool: ctx.pool)
    let tex = try XCTUnwrap(src.tick(frame))
    XCTAssertTrue(src.tick(frame) === tex, "tick must return the cached texture, not re-decode")
    let px = ctx.readPixels(tex)
    XCTAssertEqual(px[0].y, 1, accuracy: 2.0 / 255, "green sticker decoded")
  }

  func testStraightAlphaSurvivesDecode() throws {
    let ctx = try MetalContext()
    let src = StickerSource(context: ctx, folder: folder)
    src.selectedIndex = 2                               // blue, alpha 0.5
    let px = ctx.readPixels(try XCTUnwrap(src.tick(makeFrame(ctx))))
    XCTAssertEqual(px[0].z, 1.0, accuracy: 4.0 / 255, "un-premultiplied: rgb NOT scaled by alpha")
    XCTAssertEqual(px[0].w, 0.5, accuracy: 2.0 / 255)
  }

  func testNormalizedSelectionAndRescanReset() throws {
    let src = StickerSource(context: try MetalContext(), folder: folder)
    src.select(normalized: 0.99); XCTAssertEqual(src.selectedIndex, 2)
    src.select(normalized: 0.0);  XCTAssertEqual(src.selectedIndex, 0)
    src.selectedIndex = 2
    try FileManager.default.removeItem(at: folder.appendingPathComponent("c-blue.png"))
    src.rescan()
    XCTAssertEqual(src.itemCount, 2)
    XCTAssertEqual(src.selectedIndex, 0, "rescan resets index to 0 (spec §02 §2)")
  }

  func testDefaultsMatchOriginalPicsvidLayer() throws {
    // spec §02 §5 (zOrder), §04 §1.4 (enable-off at load), Constants (pic-size slider default).
    let src = StickerSource(context: try MetalContext(), folder: folder)
    XCTAssertEqual(src.layer.zOrder, 2)
    XCTAssertFalse(src.layer.enabled)
    XCTAssertEqual(src.transform.scale, SIMD2<Float>(0.747, 0.747))
    XCTAssertEqual(src.transform.position, SIMD2<Float>.zero)
    XCTAssertEqual(src.transform.rotationZDegrees, 0)
  }

  func testMissingFolderIsTolerated() throws {
    let ghost = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let src = StickerSource(context: try MetalContext(), folder: ghost)
    XCTAssertEqual(src.itemCount, 0)
    XCTAssertNil(src.tick(makeFrame(try MetalContext())))
  }

  func testOnCountChangedFiresOnRescan() throws {
    let src = StickerSource(context: try MetalContext(), folder: folder)
    var seen: Int?
    src.onCountChanged = { seen = $0 }
    try FileManager.default.removeItem(at: folder.appendingPathComponent("c-blue.png"))
    src.rescan()
    XCTAssertEqual(seen, 2)
  }

  // MARK: - Helpers

  /// Writes a solid-color `width`×`height` PNG with STRAIGHT (non-premultiplied) alpha —
  /// the PNG spec's own convention, and the thing `StickerSource`'s decode is meant to
  /// recover after CoreGraphics premultiplies on the way through `CGContext`.
  func writePNG(_ url: URL, rgba: [Float], width: Int = 2, height: Int = 2) throws {
    let r = UInt8((rgba[0] * 255).rounded()), g = UInt8((rgba[1] * 255).rounded())
    let b = UInt8((rgba[2] * 255).rounded()), a = UInt8((rgba[3] * 255).rounded())
    var pixels = [UInt8]()
    pixels.reserveCapacity(width * height * 4)
    for _ in 0..<(width * height) { pixels.append(contentsOf: [r, g, b, a]) }
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue)   // straight alpha
    guard let provider = CGDataProvider(data: Data(pixels) as CFData) else {
      throw TestFixtureError.step("CGDataProvider")
    }
    guard let cgImage = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32,
                                bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmapInfo,
                                provider: provider, decode: nil, shouldInterpolate: false,
                                intent: .defaultIntent) else {
      throw TestFixtureError.step("CGImage")
    }
    guard let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else {
      throw TestFixtureError.step("CGImageDestination")
    }
    CGImageDestinationAddImage(dest, cgImage, nil)
    guard CGImageDestinationFinalize(dest) else { throw TestFixtureError.step("finalize") }
  }

  func makeFrame(_ ctx: MetalContext) -> FrameContext {
    let cb = ctx.queue.makeCommandBuffer()!
    return FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: SIMD2(8, 8),
                        commandBuffer: cb, pool: ctx.pool)
  }
}
