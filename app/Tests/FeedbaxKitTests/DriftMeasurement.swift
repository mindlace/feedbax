import XCTest
import Foundation
import Metal
import simd
@testable import FeedbaxKit

/// TEMPORARY MEASUREMENT (not a regression test — it asserts nothing about the numbers).
///
/// Runs the engine exactly the way `AppBootstrap.start()` assembles it — `MetalContext()`,
/// `Engine(context:)`, `router.applyStartupDefaults(at: 0)` — at a fixed 1/60 s timestep for
/// 1200 frames (20 s of wall-clock-equivalent), reading the accumulator back every 30 frames
/// and printing mean luminance, max luminance, and the fraction of fully-saturated-white
/// pixels. Canvas is the golden tests' 192×108 so readback is cheap.
///
/// Exists to answer one question with data instead of arithmetic: do the (post-scale-fix)
/// positive per-frame HSL deltas still integrate the image to white, or does the startup
/// pan/zoom warp carry content off-screen fast enough to stabilise it?
final class DriftMeasurement: XCTestCase {
  private static let size = SIMD2<Int>(192, 108)
  private static let frames = 1200
  private static let sampleEvery = 30

  func testStartupDriftOver20Seconds() throws {
    try measureRun(label: "startup defaults (sticker layer OFF, as AppBootstrap leaves it)",
                   enableSticker: false)
  }

  func testStartupDriftOver20SecondsWithStickerLayer() throws {
    try measureRun(label: "startup defaults + sticker layer ON (as feedbax-dev --soak does)",
                   enableSticker: true)
  }

  /// Same run, sampled EVERY frame for the first 90, to see the shape of the climb (the
  /// 30-frame table above is already saturated by its first sample).
  func testStartupDriftFirst90FramesPerFrame() throws {
    try measureRun(label: "first 90 frames, per frame (startup defaults, sticker OFF)",
                   enableSticker: false, frames: 90, sampleEvery: 1)
  }

  /// Control: identical, except the startup vector is applied a full second BEFORE frame 0's
  /// clock, so `ControlRouter`'s 7 ramps have fully settled to their (small) mapped targets
  /// before the first frame samples them — `GoldenRunner.render`'s `at: -1` convention. The
  /// difference between this and the run above isolates "the ramp's cold-start overshoot" from
  /// "the settled per-frame HSL delta."
  func testSettledVectorDriftFirst90FramesPerFrame() throws {
    try measureRun(label: "first 90 frames, per frame (startup defaults applied at -1, settled)",
                   enableSticker: false, frames: 90, sampleEvery: 1, applyAt: -1)
  }

  /// The settled-vector run out to the full 20 s, sampled every 30 frames.
  func testSettledVectorDriftOver20Seconds() throws {
    try measureRun(label: "20 s, startup defaults applied at -1 (settled), sticker OFF",
                   enableSticker: false, applyAt: -1)
  }

  private func measureRun(label: String, enableSticker: Bool,
                          frames: Int = DriftMeasurement.frames,
                          sampleEvery: Int = DriftMeasurement.sampleEvery,
                          applyAt: TimeInterval = 0) throws {
    let context = try MetalContext()
    let engine = try Engine(context: context)
    engine.router.applyStartupDefaults(at: applyAt)
    engine.setResolution(Self.size)
    engine.sticker.layer.enabled = enableSticker

    print("=== DRIFT MEASUREMENT: \(label) ===")
    print("frame\tmeanLum\t\tmaxLum\t\twhiteFrac")

    var last: MTLTexture!
    for i in 0..<frames {
      let time = Double(i) / 60
      let commandBuffer = context.queue.makeCommandBuffer()!
      last = engine.step(at: time, commandBuffer: commandBuffer)
      commandBuffer.commit()
      commandBuffer.waitUntilCompleted()
      context.pool.endFrame()

      if (i + 1) % sampleEvery == 0 {
        let pixels = context.readPixels(last)
        var sum = 0.0, maxLum = 0.0, white = 0
        for p in pixels {
          let lum = Double(0.2126 * p.x + 0.7152 * p.y + 0.0722 * p.z)
          sum += lum
          maxLum = max(maxLum, lum)
          if p.x >= 0.99 && p.y >= 0.99 && p.z >= 0.99 { white += 1 }
        }
        let mean = sum / Double(pixels.count)
        let whiteFrac = Double(white) / Double(pixels.count)
        print(String(format: "%d\t%.6f\t%.6f\t%.6f", i + 1, mean, maxLum, whiteFrac))
      }
    }
  }
}
