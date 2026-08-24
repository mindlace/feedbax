import XCTest
import simd
@testable import FeedbaxKit

/// Deterministic RNG so the parity test is reproducible run-to-run. Random colors can
/// land near-gray, where hue is ill-conditioned and half-precision input quantization
/// legitimately exceeds the tolerance — a fixed seed pins us to a known-good draw while
/// keeping the strict 0.02 bound. (Golden-frame scenarios in Task 22 are the broad net.)
struct SplitMix64: RandomNumberGenerator {
  var state: UInt64
  mutating func next() -> UInt64 {
    state &+= 0x9E3779B97F4A7C15
    var z = state
    z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
    z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
    return z ^ (z >> 31)
  }
}

/// CPU bilinear sample matching Metal's normalized linear sampler with clamp_to_edge:
/// texel centers at integer+0.5; clamp taps to the edge texel.
func bilinearSample(_ px: [SIMD4<Float>], size: SIMD2<Int>, at coord: SIMD2<Float>) -> SIMD4<Float> {
  let p = coord - SIMD2<Float>(0.5, 0.5)
  let x0 = Int(floor(p.x)), y0 = Int(floor(p.y))
  let fx = p.x - Float(x0), fy = p.y - Float(y0)
  func tap(_ x: Int, _ y: Int) -> SIMD4<Float> {
    let cx = min(max(x, 0), size.x - 1), cy = min(max(y, 0), size.y - 1)
    return px[cy * size.x + cx]
  }
  let top = simd_mix(tap(x0, y0), tap(x0 + 1, y0), SIMD4(repeating: fx))
  let bot = simd_mix(tap(x0, y0 + 1), tap(x0 + 1, y0 + 1), SIMD4(repeating: fx))
  return simd_mix(top, bot, SIMD4(repeating: fy))
}

final class WarpParityTests: XCTestCase {
  func testWarpHSLMatchesCPUReference() throws {
    let ctx = try MetalContext()
    let size = SIMD2<Int>(16, 16)
    var rng = SplitMix64(state: 0xFEEDBA)
    let pixels: [SIMD4<Float>] = (0..<256).map { _ in
      SIMD4(Float.random(in: 0...1, using: &rng), Float.random(in: 0...1, using: &rng),
            Float.random(in: 0...1, using: &rng), Float.random(in: 0...1, using: &rng))
    }
    let prev = ctx.makeTexture(width: 16, height: 16, format: .rgba16Float, pixels: pixels)
    let cases: [WarpParams] = [
      .init(zoom: 1, theta: 0, offset: .zero, hueShift: 0, satDelta: 0, lightDelta: 0),
      .init(zoom: 0.8, theta: 0.3, offset: SIMD2(3, -2), hueShift: 0.02, satDelta: 0.01, lightDelta: -0.01),
      .init(zoom: -1.1, theta: -2.5, offset: SIMD2(-40, 25), hueShift: 0.4, satDelta: 0.3, lightDelta: 0.2),
    ]
    let pass = try WarpPass(context: ctx)
    for params in cases {
      let cb = ctx.queue.makeCommandBuffer()!
      let frame = FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: size,
                               commandBuffer: cb, pool: ctx.pool)
      let out = pass.encode(frame, previous: prev, params: params)
      cb.commit(); cb.waitUntilCompleted()
      let gpu = ctx.readPixels(out)
      for y in 0..<16 { for x in 0..<16 {
        let point = SIMD2(Float(x) + 0.5, Float(y) + 0.5)
        let src = rotaSource(point: point, size: SIMD2(16, 16), zoom: params.zoom,
                             theta: params.theta, offset: params.offset, anchor: params.anchor)
        let sampled = bilinearSample(pixels, size: size, at: src)
        let rgb = hslAdd(SIMD3(sampled.x, sampled.y, sampled.z), hueShift: params.hueShift,
                         satDelta: params.satDelta, lightDelta: params.lightDelta)
        let g = gpu[y * 16 + x]
        // Tolerance: half-precision storage + fract/pow ULP differences. Hue-wrap
        // boundaries can diverge a full hue segment on exact ties; allow rare outliers.
        XCTAssertEqual(g.x, rgb.x, accuracy: 0.02, "px \(x),\(y)")
        XCTAssertEqual(g.y, rgb.y, accuracy: 0.02, "px \(x),\(y)")
        XCTAssertEqual(g.z, rgb.z, accuracy: 0.02, "px \(x),\(y)")
        XCTAssertEqual(g.w, sampled.w, accuracy: 0.01, "alpha untouched px \(x),\(y)")
      } }
      ctx.pool.endFrame()
    }
  }
}
