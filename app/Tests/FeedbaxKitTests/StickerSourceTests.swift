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
    // spec §02 §5 (zOrder — Sean's `@layer 2`; orders seed layers among themselves only, the
    // plane is not in this order), §04 §1.4 (enable-off at load), Constants (pic-size slider
    // default).
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

  func testReselectingSameIndexSkipsRedecode() throws {
    // spec §02 §2's `zl change`: "re-selecting the same file is a no-op". `select(normalized:)`
    // is fed by a continuous touch/slider stream in practice, so this matters for real: hovering
    // on one item must not re-decode from disk on every callback.
    let ctx = try MetalContext()
    let src = StickerSource(context: ctx, folder: folder)
    src.select(normalized: 0.34)                          // Int(0.34·3) = 1 → green
    XCTAssertEqual(src.selectedIndex, 1)
    let tex = try XCTUnwrap(src.tick(makeFrame(ctx)))
    src.select(normalized: 0.5)                           // Int(0.5·3) = 1 → same index, different input
    XCTAssertEqual(src.selectedIndex, 1)
    XCTAssertTrue(src.tick(makeFrame(ctx)) === tex,
                  "re-selecting the same index must not produce a freshly-decoded texture")
  }

  func testRescanBypassesDedupeEvenAtSameIndex() throws {
    // rescan() always resets to index 0, which can numerically equal the index already
    // selected — but the FILE at that index may have changed, so the dedupe above must not
    // suppress this re-decode just because "index 0" was already current.
    let ctx = try MetalContext()
    let src = StickerSource(context: ctx, folder: folder)   // selectedIndex 0 (red) from init
    XCTAssertEqual(src.selectedIndex, 0)
    let firstTex = try XCTUnwrap(src.tick(makeFrame(ctx)))
    src.rescan()                                            // resets to 0 again — same index number
    XCTAssertEqual(src.selectedIndex, 0)
    let secondTex = try XCTUnwrap(src.tick(makeFrame(ctx)))
    XCTAssertFalse(secondTex === firstTex, "rescan must force a fresh decode, not trust the dedupe cache")
  }

  // MARK: - Import (the drop zone / "Add Images…" path — how the folder gets fed)

  func testImportCopiesIntoFolderAndSelectsTheNewImage() throws {
    let src = StickerSource(context: try MetalContext(), folder: folder)
    let inbox = try makeInbox()
    try writePNG(inbox.appendingPathComponent("d-white.png"), rgba: [1, 1, 1, 1])

    let result = src.importImages(from: [inbox.appendingPathComponent("d-white.png")])

    XCTAssertEqual(result.imported, ["d-white.png"])
    XCTAssertTrue(result.skipped.isEmpty)
    XCTAssertTrue(FileManager.default.fileExists(atPath: folder.appendingPathComponent("d-white.png").path),
                  "import COPIES into the sticker folder; it does not reference in place")
    XCTAssertEqual(src.itemCount, 4)
    XCTAssertEqual(src.items[src.selectedIndex].lastPathComponent, "d-white.png",
                   "a freshly imported image is selected, so a drop is immediately visible on the output")
  }

  func testImportSkipsNonImages() throws {
    let src = StickerSource(context: try MetalContext(), folder: folder)
    let inbox = try makeInbox()
    let doc = inbox.appendingPathComponent("readme.txt")
    try "nope".write(to: doc, atomically: true, encoding: .utf8)

    let result = src.importImages(from: [doc])

    XCTAssertEqual(result.imported, [])
    XCTAssertEqual(result.skipped, ["readme.txt"])
    XCTAssertEqual(src.itemCount, 3, "count unchanged")
  }

  func testImportDoesNotOverwriteAnExistingName() throws {
    let ctx = try MetalContext()
    let src = StickerSource(context: ctx, folder: folder)
    let inbox = try makeInbox()
    // Same NAME as a resident sticker, different pixels: the resident red must survive intact.
    try writePNG(inbox.appendingPathComponent("a-red.png"), rgba: [0, 1, 0, 1])

    let result = src.importImages(from: [inbox.appendingPathComponent("a-red.png")])

    XCTAssertEqual(result.imported, ["a-red-2.png"], "colliding names are suffixed, not clobbered")
    XCTAssertEqual(src.itemCount, 4)
    src.selectedIndex = try XCTUnwrap(src.itemNames.firstIndex(of: "a-red.png"))
    XCTAssertEqual(ctx.readPixels(try XCTUnwrap(src.tick(makeFrame(ctx))))[0].x, 1,
                   accuracy: 2.0 / 255, "the original a-red.png is still red")
  }

  func testImportOfADirectoryTakesTheImagesInside() throws {
    let src = StickerSource(context: try MetalContext(), folder: folder)
    let inbox = try makeInbox()
    try writePNG(inbox.appendingPathComponent("e-one.png"), rgba: [1, 1, 0, 1])
    try writePNG(inbox.appendingPathComponent("f-two.png"), rgba: [0, 1, 1, 1])
    try "nope".write(to: inbox.appendingPathComponent("notes.txt"), atomically: true, encoding: .utf8)

    let result = src.importImages(from: [inbox])

    XCTAssertEqual(result.imported, ["e-one.png", "f-two.png"],
                   "dropping a folder imports the images in it (spec §02 §9's never-wired dropfile, wired)")
    XCTAssertEqual(src.itemCount, 5)
  }

  func testImportOfAFileAlreadyInTheFolderSelectsItWithoutCopying() throws {
    let src = StickerSource(context: try MetalContext(), folder: folder)

    let result = src.importImages(from: [folder.appendingPathComponent("c-blue.png")])

    XCTAssertEqual(result.imported, ["c-blue.png"])
    XCTAssertEqual(src.itemCount, 3, "re-dropping a resident file must not spawn c-blue-2.png")
    XCTAssertEqual(src.items[src.selectedIndex].lastPathComponent, "c-blue.png")
  }

  func testImportFiresOnCountChanged() throws {
    let src = StickerSource(context: try MetalContext(), folder: folder)
    var seen: Int?
    src.onCountChanged = { seen = $0 }
    let inbox = try makeInbox()
    try writePNG(inbox.appendingPathComponent("d-white.png"), rgba: [1, 1, 1, 1])

    src.importImages(from: [inbox.appendingPathComponent("d-white.png")])

    XCTAssertEqual(seen, 4, "the panel's count mirror refreshes on import, over the same bus as rescan")
  }

  func testImportIntoAMissingFolderCreatesIt() throws {
    let ghost = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let src = StickerSource(context: try MetalContext(), folder: ghost)
    XCTAssertEqual(src.itemCount, 0)
    let inbox = try makeInbox()
    try writePNG(inbox.appendingPathComponent("d-white.png"), rgba: [1, 1, 1, 1])

    let result = src.importImages(from: [inbox.appendingPathComponent("d-white.png")])

    XCTAssertEqual(result.imported, ["d-white.png"])
    XCTAssertEqual(src.itemCount, 1, "the fallback sticker folder may not exist until the first drop")
  }

  func testImportOfNothingUsableLeavesSelectionAlone() throws {
    let src = StickerSource(context: try MetalContext(), folder: folder)
    src.selectedIndex = 2
    let inbox = try makeInbox()
    let doc = inbox.appendingPathComponent("readme.txt")
    try "nope".write(to: doc, atomically: true, encoding: .utf8)

    src.importImages(from: [doc])

    XCTAssertEqual(src.selectedIndex, 2, "a rejected drop must not yank the performer back to index 0")
  }

  func testItemNamesMirrorItems() throws {
    let src = StickerSource(context: try MetalContext(), folder: folder)
    XCTAssertEqual(src.itemNames, ["a-red.png", "b-green.png", "c-blue.png"])
  }

  // MARK: - Helpers

  /// A separate directory standing in for wherever a dropped file comes FROM (the Finder,
  /// another project folder) — deliberately never the sticker folder itself.
  func makeInbox() throws -> URL {
    let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    return url
  }

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
