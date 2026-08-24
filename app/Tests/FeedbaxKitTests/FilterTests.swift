import XCTest
import simd
@testable import FeedbaxKit

final class FilterTests: XCTestCase {
  var ctx: MetalContext!
  var pixels: [SIMD4<Float>]!
  var input: MTLTexture!

  override func setUpWithError() throws {
    ctx = try MetalContext()
    // Deterministic seed (see WarpParityTests.swift's SplitMix64) — random colors can land
    // near-gray/near-hue-boundary where the parity math is ill-conditioned; a fixed seed
    // pins us to a known-good draw while keeping the strict 0.02 tolerance.
    var rng = SplitMix64(state: 0xF11735)
    pixels = (0..<16).map { i in
      SIMD4(Float.random(in: 0...1.4, using: &rng), Float.random(in: 0...1, using: &rng),
            Float.random(in: 0...1, using: &rng), Float.random(in: 0...1, using: &rng))
    }                                       // includes >1 values — brcosa must not clamp
    input = ctx.makeTexture(width: 4, height: 4, format: .rgba16Float, pixels: pixels)
  }

  /// Apply one filter through a one-frame chain and read the result back.
  func applyAndRead(_ filter: TextureFilter) -> [SIMD4<Float>] {
    let cb = ctx.queue.makeCommandBuffer()!
    let frame = FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: SIMD2(4, 4),
                             commandBuffer: cb, pool: ctx.pool)
    let out = FilterChain([filter]).apply(input, frame)
    cb.commit(); cb.waitUntilCompleted()
    defer { ctx.pool.endFrame() }
    return ctx.readPixels(out)
  }

  func testBrcosaParity() throws {
    let f = try BrcosaFilter(context: ctx)
    f.enabled = true; f.brightness = 1.55; f.contrast = 1.55; f.saturation = 1.5
    let gpu = applyAndRead(f)
    for i in 0..<16 {
      let cpu = brcosa(pixels[i], brightness: 1.55, contrast: 1.55, saturation: 1.5)
      for c in 0..<4 { XCTAssertEqual(gpu[i][c], cpu[c], accuracy: 0.02, "px \(i) ch \(c)") }
    }
  }
  func testLumaCascadeParity() throws {
    let f = try LumaKeyFilter(context: ctx)   // parity defaults high (1,0.2,0.1) low (0,0.15,0.1)
    f.enabled = true
    let gpu = applyAndRead(f)
    for i in 0..<16 {
      let cpu = lumaCascade(pixels[i], backdrop: f.backdrop,
                            high: f.highParams, low: f.lowParams)
      for c in 0..<4 { XCTAssertEqual(gpu[i][c], cpu[c], accuracy: 0.02, "px \(i) ch \(c)") }
    }
  }
  func testChromaKeyParity() throws {
    let f = try ChromaKeyFilter(context: ctx) // defaults color (0.328129, 0.144197, 0), tol 0.2, fade 0.2
    f.enabled = true
    let gpu = applyAndRead(f)
    for i in 0..<16 {
      let cpu = chromaKey(pixels[i], backdrop: f.backdrop, color: f.keyColor, tol: f.tol, fade: f.fade)
      for c in 0..<4 { XCTAssertEqual(gpu[i][c], cpu[c], accuracy: 0.02, "px \(i) ch \(c)") }
    }
  }
  func testChainSkipsDisabledFilters() throws {
    let f = try BrcosaFilter(context: ctx)    // enabled defaults FALSE (spec §02 §7.2)
    let out = applyAndRead(f)
    for i in 0..<16 {
      XCTAssertEqual(out[i].x, pixels[i].x, accuracy: 0.01, "disabled filter must pass through")
    }
  }
  func testUnclampedIntermediateSurvivesChain() throws {
    // brcosa(contrast 2) on white → 1.38, which must reach the NEXT filter intact —
    // proves rgba16Float chain intermediates (design §5).
    let white = ctx.makeTexture(width: 4, height: 4, format: .rgba16Float,
                                pixels: [SIMD4<Float>](repeating: SIMD4(1, 1, 1, 1), count: 16))
    let b = try BrcosaFilter(context: ctx)
    b.enabled = true; b.brightness = 1; b.contrast = 2; b.saturation = 1
    let cb = ctx.queue.makeCommandBuffer()!
    let frame = FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: SIMD2(4, 4),
                             commandBuffer: cb, pool: ctx.pool)
    let out = FilterChain([b]).apply(white, frame)
    cb.commit(); cb.waitUntilCompleted(); defer { ctx.pool.endFrame() }
    XCTAssertEqual(ctx.readPixels(out)[0].x, 1.38, accuracy: 0.02)
  }
}
