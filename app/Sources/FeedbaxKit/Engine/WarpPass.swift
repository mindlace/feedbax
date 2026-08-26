import Metal
import simd

/// Which texel read the warp uses for the previous frame (diagnosis doc, term 1).
/// `.nearest` is the parity default: a shrunk 1-px line keeps its full value generation
/// after generation instead of being averaged into its black neighbours, which is what
/// gives the original its ~250-frame memory and pixel-scale mesh. `.linear` is kept for A/B
/// comparison only.
public enum WarpFilter: String, Codable, CaseIterable {
  case nearest, linear
}

/// GPU-side twin of ShaderMath's rotaSource/fold + hslAdd parameters. Field order
/// matches Shaders/WarpHSL.metal's `WarpParams` exactly — zoom, theta, offset, anchor,
/// hueShift, satDelta, lightDelta, nearest — so `MemoryLayout<WarpParams>.stride` (40
/// bytes) lines up with the Metal struct's byte layout (float2 needs 8-byte alignment;
/// this order avoids any padding mismatch between the two compilers' layout rules).
public struct WarpParams {
  public var zoom, theta: Float
  public var offset: SIMD2<Float>
  public var anchor = SIMD2<Float>(0.5, 0.5)   // static in this build (spec §01 §4)
  public var hueShift, satDelta, lightDelta: Float
  /// 1 = nearest-texel read, 0 = bilinear sample. A `UInt32` rather than `Bool` so the
  /// byte layout matches the Metal `uint`.
  public var nearest: UInt32
  public init(zoom: Float, theta: Float, offset: SIMD2<Float>,
              hueShift: Float, satDelta: Float, lightDelta: Float, nearest: Bool = true) {
    self.zoom = zoom; self.theta = theta; self.offset = offset
    self.hueShift = hueShift; self.satDelta = satDelta; self.lightDelta = lightDelta
    self.nearest = nearest ? 1 : 0
  }
}

/// Fused rota-fold warp + additive HSL shift (spec §01 §4-5), one dispatch. Reads
/// `previous` (last frame's composited output), writes a freshly leased texture — never
/// mutates `previous` in place, since the pool may still have other readers of it this
/// frame (see design §5 on lease lifetimes).
public final class WarpPass {
  private let pipeline: MTLComputePipelineState
  public init(context: MetalContext) throws { pipeline = try context.computePipeline("fbx_warp_hsl") }

  public func encode(_ frame: FrameContext, previous: MTLTexture, params: WarpParams) -> MTLTexture {
    let out = frame.pool.lease(width: previous.width, height: previous.height,
                               format: .rgba16Float, usage: [.shaderRead, .shaderWrite])
    var p = params
    let enc = frame.commandBuffer.makeComputeCommandEncoder()!
    enc.setComputePipelineState(pipeline)
    enc.setTexture(previous, index: 0)
    enc.setTexture(out, index: 1)
    enc.setBytes(&p, length: MemoryLayout<WarpParams>.stride, index: 0)
    let tg = MTLSize(width: 16, height: 16, depth: 1)
    enc.dispatchThreadgroups(MTLSize(width: (out.width + 15) / 16, height: (out.height + 15) / 16, depth: 1),
                             threadsPerThreadgroup: tg)
    enc.endEncoding()
    return out
  }
}
