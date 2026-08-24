import XCTest
import simd
@testable import FeedbaxKit

final class WaveformTests: XCTestCase {
  func testWave1IsClosedLoopAtRadiusOneWhenSilent() {
    let pts = WaveformRenderer.wave1Polyline([Float](repeating: 0, count: 512), style: .wave1)
    XCTAssertEqual(pts.count, 513, "closed: first point repeated")
    XCTAssertEqual(pts.first!, pts.last!)
    // radius 1 scaled by (1.5, 1) around (0, −0.85): rightmost point at x = 1.5, y = −0.85
    XCTAssertEqual(pts[0].x, 1.5, accuracy: 1e-4)
    XCTAssertEqual(pts[0].y, -0.85, accuracy: 1e-4)
  }
  func testWave1AmplitudeModulatesRadius() {
    var samples = [Float](repeating: 0, count: 512); samples[0] = 0.5
    let pts = WaveformRenderer.wave1Polyline(samples, style: .wave1)
    XCTAssertEqual(pts[0].x, 2.25, accuracy: 1e-4, "(1 + 0.5)·1.5")
  }
  func testWave2PointsSpanWidth() {
    let pts = WaveformRenderer.wave2Points([0.2, -0.2], style: .wave2)
    XCTAssertEqual(pts.count, 2)
    XCTAssertEqual(pts[0].x, -1, accuracy: 1e-4); XCTAssertEqual(pts[1].x, 1, accuracy: 1e-4)
    XCTAssertEqual(pts[0].y, 0.2, accuracy: 1e-4)
  }
  func testParityStyleConstants() {
    XCTAssertEqual(WaveformStyle.wave1.color, SIMD4(0.392375, 0.23808, 0, 0.8))
    let c2 = WaveformStyle.wave2.color
    XCTAssertEqual(SIMD3(c2.x, c2.y, c2.z), SIMD3(0, 0.786722, 0.821229))
    XCTAssertEqual(WaveformStyle.wave1.lineWidthPx, 12)
  }
  /// Pins the pixel→NDC half-size arithmetic directly (caught a prior authoring slip that
  /// divided by an extra factor of 2, shrinking wave 2's sprites to ~4px instead of the
  /// documented 8px — the GPU smoke test below didn't catch it because it only checks that
  /// *a* pixel lands on the expected color, not the sprite's actual extent).
  func testPointSpriteHalfSizeNDCConversion() {
    let halfSize = WaveformRenderer.pointSpriteHalfSizeNDC(pointSizePx: 8, canvasHeight: 1080)
    XCTAssertEqual(halfSize, 8.0 / 1080.0, accuracy: 1e-6)
  }

  /// GPU smoke test — not in the brief's pinned set, added because the ribbon/point-sprite
  /// shaders (Composite.metal's `fbx_ribbon_v`/`fbx_point_v`/`fbx_point_f`) have no other
  /// coverage: the pinned tests above only exercise the pure CPU geometry. Draws both
  /// waveforms into a small render target and checks *something* landed (nonzero alpha
  /// somewhere) — a loose bound since exact pixel coverage depends on the perspective
  /// projection, but enough to catch a pipeline/shader-compile regression or a completely
  /// off-screen/degenerate draw.
  func testDrawProducesVisiblePixels() throws {
    let ctx = try MetalContext()
    // Pipelines must match their render target's format (WaveformRenderer.init's doc
    // comment) — pass the same format the test's own target texture uses below, not a
    // hardcoded guess, exactly as a real caller (Compositor, drawing into FeedbackCore's
    // accumulator) must.
    let targetFormat: MTLPixelFormat = .rgba16Float
    let renderer = try WaveformRenderer(context: ctx, pixelFormat: targetFormat)
    renderer.wave1Enabled = true
    renderer.wave2Enabled = true
    renderer.wave2BaseAlpha = 0.5

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

    var wave1Points = [Float](repeating: 0, count: 512)
    wave1Points[0] = 0.2
    let audio = FrameAudio(worldBump: 0, waveBumpRaw: 0.1, kittyBumpRaw: 0,
                           wave1Points: wave1Points, wave2Points: [0.2, -0.2])
    let proj = Compositor.projection(canvasAspect: 1)
    renderer.draw(enc, frame: frame, audio: audio, projection: proj)
    enc.endEncoding()
    cb.commit(); cb.waitUntilCompleted()

    let pixels = ctx.readPixels(target)
    XCTAssertTrue(pixels.contains { $0.w > 0 }, "expected at least one drawn (non-transparent) pixel")

    // Color check, not just "something is opaque": guards against a Swift/Metal struct
    // layout mismatch between RibbonVertex/PointVertex/WaveUniforms and their
    // Composite.metal twins, which could still satisfy the loose alpha check above with
    // garbled (but nonzero) colors. Composited onto transparent black, alphaOver's dst
    // factor is (1−srcA) and srcAlphaDstAlpha's is dstA — both zero on first write — so
    // each waveform's first-touched pixel is exactly `color.rgb * srcAlpha`.
    func hasPixel(near expected: SIMD3<Float>, tol: Float) -> Bool {
      pixels.contains { simd_length($0.xyz - expected) < tol }
    }
    let wave1Expected = SIMD3<Float>(0.392375, 0.23808, 0) * Float(0.8)  // srcAlpha 0.8 (style.color.w)
    let wave2Expected = SIMD3<Float>(0, 0.786722, 0.821229) * Float(0.6)  // 0.5 base + 0.1 waveBumpRaw
    XCTAssertTrue(hasPixel(near: wave1Expected, tol: 0.02), "expected wave 1's burnt-orange ribbon color")
    XCTAssertTrue(hasPixel(near: wave2Expected, tol: 0.02), "expected wave 2's cyan sprite color")
  }
}

private extension SIMD4 where Scalar == Float {
  var xyz: SIMD3<Float> { SIMD3(x, y, z) }
}
