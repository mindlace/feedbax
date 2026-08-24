import Metal
import simd

/// GPU twin of ShaderMath/Keyers.swift's `lumaCascade` — a deliberate two-stage cascade
/// that keeps only midrange luminance (spec §02 §7.3): pass 1 keys out near-white
/// (`highParams`), pass 2 keys out near-black (`lowParams`). `fbx_lumakey`
/// (Shaders/Filters.metal) implements ONE luma pass; `apply` dispatches it twice through
/// an intermediate pool lease, mirroring the CPU `lumaCascade`'s nested `lumaKey` calls.
public final class LumaKeyFilter: TextureFilter {
  public let id = "lumaKey"
  public var enabled = false
  public var highParams = LumaKeyParams(luma: 1.0, tol: 0.2, fade: 0.1)
  public var lowParams = LumaKeyParams(luma: 0.0, tol: 0.15, fade: 0.1)
  public var backdrop = SIMD4<Float>(0, 0, 0, 1)

  private let pipeline: MTLComputePipelineState

  public init(context: MetalContext) throws {
    pipeline = try context.computePipeline("fbx_lumakey")
  }

  public func apply(_ input: MTLTexture, _ frame: FrameContext) -> MTLTexture {
    let mid = dispatch(input, frame, params: highParams)
    return dispatch(mid, frame, params: lowParams)
  }

  private func dispatch(_ input: MTLTexture, _ frame: FrameContext, params: LumaKeyParams) -> MTLTexture {
    let out = frame.pool.lease(width: input.width, height: input.height,
                               format: .rgba16Float, usage: [.shaderRead, .shaderWrite])
    var bd = backdrop
    var p = params
    let enc = frame.commandBuffer.makeComputeCommandEncoder()!
    enc.setComputePipelineState(pipeline)
    enc.setTexture(input, index: 0)
    enc.setTexture(out, index: 1)
    enc.setBytes(&bd, length: MemoryLayout<SIMD4<Float>>.stride, index: 0)
    // LumaKeyParams' field order (luma, tol, fade, invert, binary, mode, lumcoeff) matches
    // Filters.metal's LumaKeyGPUParams exactly — the CPU ref's own struct is the GPU buffer.
    enc.setBytes(&p, length: MemoryLayout<LumaKeyParams>.stride, index: 1)
    let tg = MTLSize(width: 16, height: 16, depth: 1)
    enc.dispatchThreadgroups(MTLSize(width: (out.width + 15) / 16, height: (out.height + 15) / 16, depth: 1),
                             threadsPerThreadgroup: tg)
    enc.endEncoding()
    return out
  }
}
