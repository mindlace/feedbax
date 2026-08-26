import Metal
import simd

/// "A thing that produces imagery" (design §"SeedSource"). Built-in implementations —
/// `StickerSource`, `MovieSource`, `CameraSource`, later `NDISource`/`DepthSource` — are
/// Tasks 15/16; this file only fixes the shape `Compositor` (Task 9) draws against.
///
/// Rule from the design doc, honored at the protocol level: sources decode on *selection*,
/// never per render frame — a movie advances on its own clock (`AVPlayer`); `tick` merely
/// fetches whatever the source currently has, and returns nil to skip the frame entirely
/// (distinct from "enabled but blank" — `Compositor.drawPlan` treats a nil this frame the
/// same as a disabled layer, per the task-9 brief's `d` fixture).
public protocol SeedSource: AnyObject {
  var id: String { get }
  /// Called on the frame clock. Returns the current texture, or nil to skip this frame.
  func tick(_ frame: FrameContext) -> MTLTexture?
  var transform: LayerTransform { get set }
  var layer: LayerSettings { get set }
}

/// Placement of one layer's quad in Jitter world units — the `imageMove` shape (spec §02
/// §4: `enable x y 0 zx zy 0 0 0 r`, position/scale/rotateZ once the always-zero
/// placeholder slots are dropped). Layers place in x/y only; z is fixed at the layer plane
/// (spec §02 shows `jit.gl.layer`'s `@position` is always `x y 0` — no per-layer Z control
/// in the source patches), so there is no z field here — `Compositor.modelTransform` takes
/// z as a separate parameter for callers (the feedback plane, waveforms) that do use it.
///
/// Codable + Equatable: Task 12's presets serialize this directly.
public struct LayerTransform: Codable, Equatable {
  /// World units (Jitter world-space, not pixels or NDC) — spec §02 §4's x ∈ roughly
  /// −1.7...1.7 range (webUI's touch-centroid `scale 0.1 0.9 -1.7 1.7` mapping).
  public var position = SIMD2<Float>.zero
  public var scale = SIMD2<Float>(1, 1)
  public var rotationZDegrees: Float = 0

  public init(position: SIMD2<Float> = .zero, scale: SIMD2<Float> = SIMD2(1, 1),
              rotationZDegrees: Float = 0) {
    self.position = position; self.scale = scale; self.rotationZDegrees = rotationZDegrees
  }
}

/// Per-layer compositing settings — `jit.gl.layer`'s `@layer` (z-order) and enable state
/// (spec §02 §5, §4). Default `zOrder = 2` matches the picsvid layer's own instantiation
/// (`jit.gl.layer foo @layer 2 ...`, spec §02 §1); default `enabled = false` matches both
/// its gating toggles' observed defaults (spec §02 §4/§7: "Enable camera" default off,
/// `imageMove` enable default off) — nothing draws until something turns a layer on.
///
/// Codable + Equatable: Task 12's presets serialize this directly.
public struct LayerSettings: Codable, Equatable {
  public var zOrder = 2
  public var enabled = false

  public init(zOrder: Int = 2, enabled: Bool = false) {
    self.zOrder = zOrder; self.enabled = enabled
  }
}
