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

  /// GPU smoke test — not in the brief's pinned set, added because the ribbon/point-sprite
  /// shaders (Composite.metal's `fbx_ribbon_v`/`fbx_point_v`/`fbx_point_f`) have no other
  /// coverage: the pinned tests above only exercise the pure CPU geometry. Draws both
  /// waveforms into a small render target and checks *something* landed (nonzero alpha
  /// somewhere) — a loose bound since exact pixel coverage depends on the perspective
  /// projection, but enough to catch a pipeline/shader-compile regression or a completely
  /// off-screen/degenerate draw.
  func testDrawProducesVisiblePixels() throws {
    let ctx = try MetalContext()
    let renderer = try WaveformRenderer(context: ctx)
    renderer.wave1Enabled = true
    renderer.wave2Enabled = true
    renderer.wave2BaseAlpha = 0.5

    let size = 64
    let target = ctx.device.makeTexture(descriptor: {
      let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba16Float, width: size, height: size, mipmapped: false)
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
  }
}
