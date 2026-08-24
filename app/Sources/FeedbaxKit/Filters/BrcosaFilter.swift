import Metal
import simd

/// GPU twin of ShaderMath/Brcosa.swift's `brcosa`, one dispatch of `fbx_brcosa`
/// (Shaders/Filters.metal). Hot defaults (1.55/1.55/1.5) are the camera-chain's — the
/// reset patch never turns this filter on, so `enabled` defaults false and golden
/// scenarios (Task 22) flip it explicitly (spec §02 §7.2).
public final class BrcosaFilter: TextureFilter {
  public let id = "brcosa"
  public var enabled = false
  public var brightness: Float = 1.55
  public var contrast: Float = 1.55
  public var saturation: Float = 1.5

  private let pipeline: MTLComputePipelineState

  public init(context: MetalContext) throws {
    pipeline = try context.computePipeline("fbx_brcosa")
  }

  public func apply(_ input: MTLTexture, _ frame: FrameContext) -> MTLTexture {
    let out = frame.pool.lease(width: input.width, height: input.height,
                               format: .rgba16Float, usage: [.shaderRead, .shaderWrite])
    var p = BrcosaGPUParams(brightness: brightness, contrast: contrast, saturation: saturation)
    let enc = frame.commandBuffer.makeComputeCommandEncoder()!
    enc.setComputePipelineState(pipeline)
    enc.setTexture(input, index: 0)
    enc.setTexture(out, index: 1)
    enc.setBytes(&p, length: MemoryLayout<BrcosaGPUParams>.stride, index: 0)
    let tg = MTLSize(width: 16, height: 16, depth: 1)
    enc.dispatchThreadgroups(MTLSize(width: (out.width + 15) / 16, height: (out.height + 15) / 16, depth: 1),
                             threadsPerThreadgroup: tg)
    enc.endEncoding()
    return out
  }
}

/// GPU-side twin of Filters.metal's `BrcosaParams` — field order (brightness, contrast,
/// saturation) matches exactly, so this struct's memory layout lines up with the Metal
/// buffer (same pattern as Engine/WarpPass.swift's `WarpParams`).
private struct BrcosaGPUParams {
  var brightness, contrast, saturation: Float
}
