import XCTest
import simd
@testable import FeedbaxKit

final class WaveformTests: XCTestCase {
  // MARK: wave 1 — `jit.gl.graph` obj-12, linear, `scale 1.5 1 0`, `position 0 −0.85 0`

  func testWave1IsAStraightLineAtTheBottomWhenSilent() {
    let pts = WaveformRenderer.wave1LinePoints([Float](repeating: 0, count: 512), style: .wave1)
    XCTAssertEqual(pts.count, 512)
    XCTAssertEqual(pts.first!.x, -1.5, accuracy: 1e-4, "spans −scale.x…+scale.x")
    XCTAssertEqual(pts.last!.x, 1.5, accuracy: 1e-4)
    for p in pts { XCTAssertEqual(p.y, -0.85, accuracy: 1e-5, "silent line sits at position.y") }
  }
  func testWave1SampleDeflectsYOneToOne() {
    var samples = [Float](repeating: 0, count: 512); samples[10] = 0.05
    let pts = WaveformRenderer.wave1LinePoints(samples, style: .wave1)
    XCTAssertEqual(pts[10].y, -0.80, accuracy: 1e-5, "y = position.y + sample·scale.y")
    XCTAssertEqual(pts[11].y, -0.85, accuracy: 1e-5)
  }

  // MARK: wave 2 — obj-213, `radial 1`, `radialradius 0.7`, `position 0 0 −2`

  func testWave2IsAClosedRingOfRadius0Point7StretchedByAspect() {
    let aspect: Float = 16.0 / 9.0
    let pts = WaveformRenderer.wave2RingPolyline([Float](repeating: 0, count: 1024), style: .wave2,
                                                 canvasAspect: aspect)
    XCTAssertEqual(pts.count, 1025, "closed: first point repeated")
    XCTAssertEqual(pts.first!, pts.last!)
    XCTAssertEqual(pts[0].x, 0.7 * aspect, accuracy: 1e-4, "x radius × canvas aspect (screenshot ellipse)")
    XCTAssertEqual(pts[0].y, 0, accuracy: 1e-4)
    XCTAssertEqual(pts[256].x, 0, accuracy: 1e-3)
    XCTAssertEqual(pts[256].y, 0.7, accuracy: 1e-4, "y radius is radialradius itself")
  }
  func testWave2SampleModulatesRadius() {
    var samples = [Float](repeating: 0, count: 1024); samples[0] = 0.1
    let pts = WaveformRenderer.wave2RingPolyline(samples, style: .wave2, canvasAspect: 1)
    XCTAssertEqual(pts[0].x, 0.8, accuracy: 1e-4, "r = radialradius + sample")
  }

  // MARK: ribbon expansion shared by both

  func testRibbonVertexCountsAndOffsets() {
    let open: [SIMD2<Float>] = [SIMD2(0, 0), SIMD2(1, 0), SIMD2(2, 0)]
    let openVerts = WaveformRenderer.ribbonVertices(open, closed: false, halfWidthNDC: 0.01)
    XCTAssertEqual(openVerts.count, 6, "two vertices per point")
    XCTAssertEqual(openVerts[0].halfWidthNDC, 0.01); XCTAssertEqual(openVerts[1].halfWidthNDC, -0.01)
    XCTAssertEqual(openVerts[0].normal.y, 1, accuracy: 1e-5, "normal of a +x line is +y")
    let ring = WaveformRenderer.wave2RingPolyline([Float](repeating: 0, count: 8), style: .wave2, canvasAspect: 1)
    let ringVerts = WaveformRenderer.ribbonVertices(ring, closed: true, halfWidthNDC: 0.01)
    XCTAssertEqual(ringVerts.count, ring.count * 2)
    XCTAssertEqual(ringVerts[0].normal, ringVerts[ringVerts.count - 2].normal, "seam tangents agree")
  }

  func testParityStyleConstants() {
    XCTAssertEqual(WaveformStyle.wave1.color, SIMD4(0.392375, 0.23808, 0, 0.8))
    XCTAssertEqual(WaveformStyle.wave1.lineWidthPx, 12)
    XCTAssertEqual(WaveformStyle.wave1.radialRadius, 0, "wave 1 is linear")
    XCTAssertEqual(WaveformStyle.wave1.position, SIMD3(0, -0.85, 0))
    let c2 = WaveformStyle.wave2.color
    XCTAssertEqual(SIMD3(c2.x, c2.y, c2.z), SIMD3(0, 0.786722, 0.821229))
    XCTAssertEqual(WaveformStyle.wave2.lineWidthPx, 4)
    XCTAssertEqual(WaveformStyle.wave2.radialRadius, 0.7)
    XCTAssertEqual(WaveformStyle.wave2.position, SIMD3(0, 0, -2))
  }

  func testDefaultsMatchTheLoadedPatch() throws {
    let ctx = try MetalContext()
    let renderer = try WaveformRenderer(context: ctx, pixelFormat: .rgba8Unorm)
    XCTAssertTrue(renderer.wave1Enabled, "Bass toggle: loadmess 1")
    XCTAssertTrue(renderer.wave2Enabled, "Circle toggle never sends enable 0; jit.gl.graph enables by default")
    XCTAssertEqual(renderer.wave2BaseAlpha, 0.8, "loadmess 0.8 → slider[338] → alpha")
  }

  /// GPU smoke test — the ribbon shader has no other coverage. Wave 1's silent line sits
  /// just below the visible edge at z = 0 (0.85 > 0.828), so it is fed a +0.2 deflection to
  /// bring it into frame; wave 2's ring (radius 0.7 at z = −2) is visible on its own.
  func testDrawProducesVisiblePixels() throws {
    let ctx = try MetalContext()
    let targetFormat: MTLPixelFormat = .rgba16Float
    let renderer = try WaveformRenderer(context: ctx, pixelFormat: targetFormat)
    renderer.wave1Enabled = true
    renderer.wave2Enabled = true
    renderer.wave2BaseAlpha = 0.8

    let size = 64
    let target = ctx.device.makeTexture(descriptor: {
      let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: targetFormat, width: size, height: size, mipmapped: false)
      d.usage = [.renderTarget, .shaderRead]
      d.storageMode = .shared
      return d
    }())!

    let cb = ctx.queue.makeCommandBuffer()!
    let frame = FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: SIMD2(size, size),
                             commandBuffer: cb, pool: ctx.pool)
    let rp = MTLRenderPassDescriptor()
    rp.colorAttachments[0].texture = target
    rp.colorAttachments[0].loadAction = .clear
    rp.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
    rp.colorAttachments[0].storeAction = .store
    let enc = cb.makeRenderCommandEncoder(descriptor: rp)!

    let audio = FrameAudio(worldBump: 0, waveBumpRaw: 0.1, imageBumpRaw: 0,
                           wave1Points: [Float](repeating: 0.2, count: 512),
                           wave2Points: [Float](repeating: 0, count: 1024))
    let proj = Compositor.projection(canvasAspect: 1)
    renderer.draw(enc, frame: frame, audio: audio, projection: proj)
    enc.endEncoding()
    cb.commit(); cb.waitUntilCompleted()

    let pixels = ctx.readPixels(target)
    XCTAssertTrue(pixels.contains { $0.w > 0 }, "expected at least one drawn (non-transparent) pixel")
    // First-touched pixels over transparent black are exactly color.rgb · srcAlpha for both
    // blend modes (alphaOver's dst factor is 1−srcA, srcAlphaDstAlpha's is dstA = 0).
    func hasPixel(near expected: SIMD3<Float>, tol: Float) -> Bool {
      pixels.contains { simd_length(SIMD3($0.x, $0.y, $0.z) - expected) < tol }
    }
    let wave1Expected = SIMD3<Float>(0.392375, 0.23808, 0) * Float(0.8)
    let wave2Expected = SIMD3<Float>(0, 0.786722, 0.821229) * Float(0.9)   // 0.8 base + 0.1 waveBumpRaw
    XCTAssertTrue(hasPixel(near: wave1Expected, tol: 0.02), "expected wave 1's burnt-orange line")
    XCTAssertTrue(hasPixel(near: wave2Expected, tol: 0.02), "expected wave 2's cyan ring")
  }

  /// Pins the data→geometry wiring `draw` performs (which array feeds which shape): a wave-1
  /// deflection must light the bottom of the canvas and nothing near the centre; wave 2 alone
  /// must light a ring around the centre and nothing at the bottom edge.
  func testDrawRoutesWave1ToTheBottomEdgeAndWave2ToTheRing() throws {
    let ctx = try MetalContext()
    let size = 64
    func render(wave1: [Float]?, wave2: [Float]?) throws -> [SIMD4<Float>] {
      let renderer = try WaveformRenderer(context: ctx, pixelFormat: .rgba16Float)
      renderer.wave1Enabled = wave1 != nil
      renderer.wave2Enabled = wave2 != nil
      let target = ctx.device.makeTexture(descriptor: {
        let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba16Float, width: size, height: size, mipmapped: false)
        d.usage = [.renderTarget, .shaderRead]; d.storageMode = .shared; return d
      }())!
      let cb = ctx.queue.makeCommandBuffer()!
      let frame = FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: SIMD2(size, size),
                               commandBuffer: cb, pool: ctx.pool)
      let rp = MTLRenderPassDescriptor()
      rp.colorAttachments[0].texture = target
      rp.colorAttachments[0].loadAction = .clear
      rp.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
      rp.colorAttachments[0].storeAction = .store
      let enc = cb.makeRenderCommandEncoder(descriptor: rp)!
      let audio = FrameAudio(worldBump: 0, waveBumpRaw: 0, imageBumpRaw: 0,
                             wave1Points: wave1 ?? [Float](repeating: 0, count: 512),
                             wave2Points: wave2 ?? [Float](repeating: 0, count: 1024))
      renderer.draw(enc, frame: frame, audio: audio, projection: Compositor.projection(canvasAspect: 1))
      enc.endEncoding(); cb.commit(); cb.waitUntilCompleted()
      return ctx.readPixels(target)
    }
    func lit(_ px: [SIMD4<Float>], rows: Range<Int>, cols: Range<Int>) -> Bool {
      rows.contains { y in cols.contains { x in px[y * size + x].w > 0 } }
    }
    // Wave 1 deflected +0.2 sits at y = −0.65 → the lower part of the frame (row 0 is the top).
    let one = try render(wave1: [Float](repeating: 0.2, count: 512), wave2: nil)
    XCTAssertTrue(lit(one, rows: 40..<64, cols: 0..<64), "wave 1 must light the lower frame")
    XCTAssertFalse(lit(one, rows: 28..<36, cols: 28..<36), "wave 1 must not touch the centre")
    // Wave 2's ring (radius 0.7 at z = −2 → ~0.42 of the half-height) surrounds the centre.
    let two = try render(wave1: nil, wave2: [Float](repeating: 0, count: 1024))
    XCTAssertTrue(lit(two, rows: 0..<32, cols: 0..<64), "wave 2's ring must reach the upper half")
    XCTAssertFalse(lit(two, rows: 30..<34, cols: 30..<34), "wave 2 must not fill the centre")
    XCTAssertFalse(lit(two, rows: 62..<64, cols: 0..<64), "wave 2 must not touch the bottom edge")
  }
}
