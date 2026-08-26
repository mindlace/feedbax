import Metal
import simd

/// Draws every enabled `SeedSource` layer's texture, z-ordered, into the accumulator —
/// the "seeds under" step of `FeedbackCore.renderFrame` (Task 19 wires
/// `collectTextures`/`drawSeeds` around that call). Owns the layer list; the individual
/// sources (Tasks 15/16) own their own imagery.
///
/// **Why a 3D projection at all** (not a flat NDC placement): every placement constant in
/// the spec is already in Jitter world units under Jitter's default camera — camera at
/// `(0,0,2)`, `lens_angle`/fovY 45° (spec §01 §3's videoplane creation attrs;
/// §03's wave-1/wave-2 `position`/`pak` tables). Reproducing that camera means the spec's
/// numbers (layer x roughly −1.7...1.7 per spec §02 §4, wave-1 at `(0,−0.85,0)`, wave-2 at
/// `z=−2`) transfer verbatim instead of each needing a hand-derived NDC equivalent.
public final class Compositor {
  /// nil in unit tests that only exercise `drawPlan`'s ordering logic (no pipelines, no
  /// device needed); the GPU path (`drawSeeds`) preconditions on non-nil.
  private let quad: QuadRenderer?
  public var layers: [SeedSource] = []
  /// Appended after the layer draws — waveforms (Task 18) draw their own polyline geometry
  /// in world space here rather than as a textured quad.
  public var overlays: [(MTLRenderCommandEncoder, FrameContext) -> Void] = []

  public init(quad: QuadRenderer?) {
    self.quad = quad
  }

  /// Ticks every enabled source once (design §"SeedSource": "sources decode on selection,
  /// never per render frame" — `tick` just fetches whatever's current); a nil result skips
  /// that source for this frame without changing `layer.enabled`. Ticking is skipped
  /// entirely for disabled layers — `drawPlan` would discard the texture anyway, and a
  /// disabled camera/movie source shouldn't pay decode/capture cost for a frame nothing
  /// draws.
  public func collectTextures(_ frame: FrameContext) -> [String: MTLTexture] {
    var textures: [String: MTLTexture] = [:]
    for source in layers where source.layer.enabled {
      if let texture = source.tick(frame) { textures[source.id] = texture }
    }
    return textures
  }

  /// Enabled layers with a texture available this frame, ascending `zOrder` — the one
  /// place draw order is decided, shared by `drawSeeds` so the GPU path and this
  /// pipeline-free path can never disagree about ordering.
  public func drawPlan(available: Set<String>) -> [String] {
    layers
      .filter { $0.layer.enabled && available.contains($0.id) }
      .sorted { $0.layer.zOrder < $1.layer.zOrder }
      .map { $0.id }
  }

  /// Draws all enabled layers in `zOrder` into `enc` (standard alpha-over), then the
  /// registered overlay draws.
  public func drawSeeds(_ enc: MTLRenderCommandEncoder, frame: FrameContext,
                        textures: [String: MTLTexture]) {
    precondition(quad != nil, "Compositor.drawSeeds requires a QuadRenderer; " +
                 "init(quad: nil) is for drawPlan-only order-logic tests")
    let quad = quad!
    let byId = Dictionary(uniqueKeysWithValues: layers.map { ($0.id, $0) })
    let canvasAspect = Float(frame.canvasSize.x) / Float(frame.canvasSize.y)
    let proj = Compositor.projection(canvasAspect: canvasAspect)
    for id in drawPlan(available: Set(textures.keys)) {
      guard let source = byId[id], let texture = textures[id] else { continue }
      // PARITY-REVIEW: quad spans (±textureAspect·scale.x, ±scale.y) — texture-aspect ×
      // uniform imageMove zoom is our reading of `jit.gl.layer`'s quad convention, which
      // the spec does not pin (spec §02 §5's `[?]` on undocumented attrui defaults). Flag
      // for review against captured footage.
      let textureAspect = Float(texture.width) / Float(texture.height)
      let model = Compositor.modelTransform(source.transform, textureAspect: textureAspect, atZ: 0)
      quad.drawTextured(enc, texture: texture, transform: proj * model,
                        tint: SIMD4(1, 1, 1, 1), blend: .alphaOver)
    }
    for overlay in overlays { overlay(enc, frame) }
  }

  /// Right-handed perspective matching Jitter's default camera (spec §01 §3): fovY 45°,
  /// near 0.1, far 100, camera at `(0,0,2)` looking down −z. The camera position is folded
  /// in here as a view translation (`translate(0,0,−2)`) rather than exposed separately —
  /// nothing in the spec ever moves the camera itself, only what's placed in front of it.
  ///
  /// Pinned by `CompositorTests`: a unit quad at `z=−0.414` must land at clip `y/w = 1.0`
  /// (`2.414·tan(22.5°) = 1.0`, the videoplane-fills-frame fact), and at `z=0` (distance 2)
  /// at `y/w = 1/0.8284` (`2·tan(22.5°)`).
  public static func projection(canvasAspect: Float) -> float4x4 {
    let fovYRadians: Float = 45 * .pi / 180
    let ys = 1 / tan(fovYRadians * 0.5)
    let xs = ys / canvasAspect
    let near: Float = 0.1, far: Float = 100
    let zs = far / (near - far)
    let perspective = float4x4(
      SIMD4(xs, 0, 0, 0),
      SIMD4(0, ys, 0, 0),
      SIMD4(0, 0, zs, -1),
      SIMD4(0, 0, near * zs, 0))
    return perspective * float4x4(translation: SIMD3(0, 0, -2))
  }

  /// `translate(position, z) · rotateZ(degrees) · scale(textureAspect·scale.x, scale.y, 1)`
  /// — the `imageMove` shape (spec §02 §4) applied to a unit quad (half-extent 1, the
  /// `Composite.metal` `fbx_quad_v` convention shared with `QuadRenderer`).
  public static func modelTransform(_ t: LayerTransform, textureAspect: Float, atZ z: Float) -> float4x4 {
    let translate = float4x4(translation: SIMD3(t.position.x, t.position.y, z))
    let rotate = float4x4(rotationZDegrees: t.rotationZDegrees)
    let scale = float4x4(scaling: SIMD3(textureAspect * t.scale.x, t.scale.y, 1))
    return translate * rotate * scale
  }
}

public extension float4x4 {
  /// Column-major translation matrix: `M·(x,y,z,1) = (x+t.x, y+t.y, z+t.z, 1)`.
  init(translation t: SIMD3<Float>) {
    self = float4x4(
      SIMD4(1, 0, 0, 0),
      SIMD4(0, 1, 0, 0),
      SIMD4(0, 0, 1, 0),
      SIMD4(t.x, t.y, t.z, 1))
  }

  /// Column-major rotation about +Z, counterclockwise when viewed from +z looking toward
  /// the origin (the standard right-handed convention `Compositor`'s camera also uses).
  init(rotationZDegrees degrees: Float) {
    let radians = degrees * .pi / 180
    let c = cos(radians), s = sin(radians)
    self = float4x4(
      SIMD4(c, s, 0, 0),
      SIMD4(-s, c, 0, 0),
      SIMD4(0, 0, 1, 0),
      SIMD4(0, 0, 0, 1))
  }
}
