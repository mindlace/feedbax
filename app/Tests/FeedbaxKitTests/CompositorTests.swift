import XCTest
import simd
@testable import FeedbaxKit

final class CompositorTests: XCTestCase {
  func testVideoplaneEquivalenceFillsFrame() {
    // A unit quad (half-extent 1) at z=−0.414 under the Jitter default camera must hit
    // clip y = ±1 exactly (2.414·tan(22.5°) = 1.0) — the videoplane fact (spec §01 §3).
    let proj = Compositor.projection(canvasAspect: 16.0 / 9.0)
    let model = Compositor.modelTransform(LayerTransform(), textureAspect: 1, atZ: -0.414)
    let corner = proj * model * SIMD4<Float>(0, 1, 0, 1)
    XCTAssertEqual(corner.y / corner.w, 1.0, accuracy: 2e-3)
  }
  func testLayerAtOriginHalfHeight() {
    // A layer at z=0 sits at distance 2: half-height 2·tan(22.5°) ≈ 0.828 world units →
    // a unit quad reaches clip y ≈ 1/0.828 ≈ 1.207.
    let proj = Compositor.projection(canvasAspect: 1)
    let model = Compositor.modelTransform(LayerTransform(), textureAspect: 1, atZ: 0)
    let corner = proj * model * SIMD4<Float>(0, 1, 0, 1)
    XCTAssertEqual(corner.y / corner.w, 1.0 / 0.8284, accuracy: 2e-3)
  }
  func testDrawOrderSortsByZOrderAndSkipsDisabledAndTextureless() throws {
    final class FakeSource: SeedSource {
      let id: String; var transform = LayerTransform(); var layer = LayerSettings()
      init(_ id: String) { self.id = id }
      func tick(_ frame: FrameContext) -> MTLTexture? { nil }
    }
    let quadless = Compositor(quad: nil)   // drawPlan needs no pipelines
    let a = FakeSource("a"); a.layer = .init(zOrder: 5, enabled: true)
    let b = FakeSource("b"); b.layer = .init(zOrder: 1, enabled: true)
    let c = FakeSource("c"); c.layer = .init(zOrder: 3, enabled: false)
    let d = FakeSource("d"); d.layer = .init(zOrder: 2, enabled: true)
    quadless.layers = [a, b, c, d]
    XCTAssertEqual(quadless.drawPlan(available: ["a", "b", "c"]), ["b", "a"],
                   "zOrder ascending; disabled c skipped; d skipped (no texture this frame)")
  }
}
