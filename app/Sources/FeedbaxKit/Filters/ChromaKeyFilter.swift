import Metal
import simd

/// GPU twin of ShaderMath/Keyers.swift's `chromaKey` — weighted HSV-distance keyer, hue
/// counts 4× (spec §02 §7.4/§8), one dispatch of `fbx_chromakey` (Shaders/Filters.metal).
///
/// Keyer backdrop: the original mattes against a static operator-set fill (`keyCh2init`);
/// its exact per-plane values are unrecoverable from the patch (spec §02 §7.3 `[?]`).
/// Black is our documented default — operator-settable in P3's keying UI.
public final class ChromaKeyFilter: TextureFilter {
  public let id = "chromaKey"
  public var enabled = false
  public var keyColor = SIMD3<Float>(0.328129, 0.144197, 0.0)
  public var tol: Float = 0.2
  public var fade: Float = 0.2
  public var backdrop = SIMD4<Float>(0, 0, 0, 1)

  private let pipeline: MTLComputePipelineState

  public init(context: MetalContext) throws {
    pipeline = try context.computePipeline("fbx_chromakey")
  }

  public func apply(_ input: MTLTexture, _ frame: FrameContext) -> MTLTexture {
    let out = frame.pool.lease(width: input.width, height: input.height,
                               format: .rgba16Float, usage: [.shaderRead, .shaderWrite])
    var bd = backdrop
    var p = ChromaKeyGPUParams(color: keyColor, tol: tol, fade: fade)
    let enc = frame.commandBuffer.makeComputeCommandEncoder()!
    enc.setComputePipelineState(pipeline)
    enc.setTexture(input, index: 0)
    enc.setTexture(out, index: 1)
    enc.setBytes(&bd, length: MemoryLayout<SIMD4<Float>>.stride, index: 0)
    enc.setBytes(&p, length: MemoryLayout<ChromaKeyGPUParams>.stride, index: 1)
    let tg = MTLSize(width: 16, height: 16, depth: 1)
    enc.dispatchThreadgroups(MTLSize(width: (out.width + 15) / 16, height: (out.height + 15) / 16, depth: 1),
                             threadsPerThreadgroup: tg)
    enc.endEncoding()
    return out
  }
}

/// GPU-side twin of Filters.metal's `ChromaKeyGPUParams` — field order (color, tol,
/// fade) matches exactly.
private struct ChromaKeyGPUParams {
  var color: SIMD3<Float>
  var tol, fade: Float
}
