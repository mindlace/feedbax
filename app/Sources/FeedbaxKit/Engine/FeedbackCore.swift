import Metal
import simd

/// Already-smoothed, already-mapped per-frame render inputs — the router (Task 11) produces
/// this from the raw control vector; `FeedbackCore` never sees a control bus, only floats.
public struct RenderParams {
  public var zoom, theta: Float
  public var offsetPx: SIMD2<Float>
  public var hueShift, satDelta, lightDelta: Float
  /// 0.8...1.0, **never** smoothed — the erase channel is the one deliberately-abrupt
  /// control in the whole chain (spec §01 §2: "α is the one unsmoothed parameter").
  public var eraseAlpha: Float
  public var eraseColor: SIMD3<Float> = .zero
  /// Z offset on the feedback plane — LeapGemini hand-depth in the original (spec §01 §3).
  public var worldBump: Float = 0

  public init(zoom: Float, theta: Float, offsetPx: SIMD2<Float>, hueShift: Float,
              satDelta: Float, lightDelta: Float, eraseAlpha: Float,
              eraseColor: SIMD3<Float> = .zero, worldBump: Float = 0) {
    self.zoom = zoom; self.theta = theta; self.offsetPx = offsetPx
    self.hueShift = hueShift; self.satDelta = satDelta; self.lightDelta = lightDelta
    self.eraseAlpha = eraseAlpha; self.eraseColor = eraseColor; self.worldBump = worldBump
  }

  /// Bridge to `WarpPass`'s params (Task 7) — the fields it needs are a strict subset of
  /// `RenderParams`, in raw pixel units already (no rescale at the seam).
  public var warpParams: WarpParams {
    WarpParams(zoom: zoom, theta: theta, offset: offsetPx,
              hueShift: hueShift, satDelta: satDelta, lightDelta: lightDelta)
  }
}

/// Textured/solid fullscreen-quad renderer, built once per accumulator pixel format and
/// shared by the feedback-plane composite here, the accumulator→drawable blit (Task 20),
/// and layer/waveform draws (Tasks 9/18) — one small vertex shader (`fbx_quad_v`,
/// Shaders/Composite.metal), transform + tint uniforms, no per-caller vertex-buffer setup.
public final class QuadRenderer {
  /// Fixed-function blend state for the quad's color attachment.
  public enum BlendMode: Hashable {
    /// Blending disabled — fragment output overwrites the destination outright. Used by
    /// the `drawSolid` test/instrumentation hook so its arithmetic is exact, not blended.
    case none
    /// (SRC_ALPHA, 1−SRC_ALPHA) for rgb and alpha — standard "over" compositing.
    case alphaOver
    /// (SRC_ALPHA, DST_ALPHA) for rgb **and** alpha — Jitter's `blend_mode 6 8`
    /// (spec §01 §3), not standard alpha-over: neither factor is a complement of the
    /// other, so high-alpha-on-both-sides composites can brighten rather than interpolate.
    case srcAlphaDstAlpha
  }

  /// Mirrors `Composite.metal`'s `QuadUniforms` field-for-field (float4x4 then float4) so
  /// `setVertexBytes`/`setFragmentBytes` hand the GPU an identical byte layout.
  private struct QuadUniforms { var transform: float4x4; var tint: SIMD4<Float> }
  private struct PipelineKey: Hashable { let textured: Bool; let blend: BlendMode }

  private let pipelines: [PipelineKey: MTLRenderPipelineState]

  /// Builds a pipeline for every (textured/solid) × (blend mode) combination up front —
  /// six small pipeline states, all against `pixelFormat` (the accumulator's format).
  /// Cheap at init time; avoids a lazy-build/race path for what's later a shared,
  /// multi-caller (Compositor, waveforms, output stage) renderer.
  public init(context: MetalContext, pixelFormat: MTLPixelFormat) throws {
    func function(_ name: String) throws -> MTLFunction {
      // Render pipelines need `library.makeFunction`, not `computePipeline` — search
      // `context.libraries` (plural: each .metal file is its own MTLLibrary, see
      // MetalContext's doc comment on why they aren't concatenated).
      guard let fn = context.libraries.compactMap({ $0.makeFunction(name: name) }).first else {
        throw FeedbaxError.missingShader(name)
      }
      return fn
    }
    let vertexFn = try function("fbx_quad_v")
    let texturedFn = try function("fbx_quad_f")
    let solidFn = try function("fbx_solid_f")

    var built: [PipelineKey: MTLRenderPipelineState] = [:]
    for textured in [true, false] {
      for blend in [BlendMode.none, .alphaOver, .srcAlphaDstAlpha] {
        let desc = MTLRenderPipelineDescriptor()
        desc.vertexFunction = vertexFn
        desc.fragmentFunction = textured ? texturedFn : solidFn
        let attachment = desc.colorAttachments[0]!
        attachment.pixelFormat = pixelFormat
        switch blend {
        case .none:
          attachment.isBlendingEnabled = false
        case .alphaOver:
          attachment.isBlendingEnabled = true
          attachment.rgbBlendOperation = .add
          attachment.alphaBlendOperation = .add
          attachment.sourceRGBBlendFactor = .sourceAlpha
          attachment.destinationRGBBlendFactor = .oneMinusSourceAlpha
          attachment.sourceAlphaBlendFactor = .sourceAlpha
          attachment.destinationAlphaBlendFactor = .oneMinusSourceAlpha
        case .srcAlphaDstAlpha:
          attachment.isBlendingEnabled = true
          attachment.rgbBlendOperation = .add
          attachment.alphaBlendOperation = .add
          attachment.sourceRGBBlendFactor = .sourceAlpha
          attachment.destinationRGBBlendFactor = .destinationAlpha
          attachment.sourceAlphaBlendFactor = .sourceAlpha
          attachment.destinationAlphaBlendFactor = .destinationAlpha
        }
        built[PipelineKey(textured: textured, blend: blend)] = try context.device.makeRenderPipelineState(descriptor: desc)
      }
    }
    self.pipelines = built
  }

  public func drawTextured(_ enc: MTLRenderCommandEncoder, texture: MTLTexture,
                           transform: float4x4, tint: SIMD4<Float>, blend: BlendMode) {
    draw(enc, textured: true, texture: texture, transform: transform, tint: tint, blend: blend)
  }

  /// The `drawSolid` test/instrumentation hook's underlying implementation — always
  /// `.none` blend (see `BlendMode.none`'s doc), so its output is exactly `color`.
  public func drawSolid(_ enc: MTLRenderCommandEncoder, transform: float4x4, color: SIMD4<Float>) {
    draw(enc, textured: false, texture: nil, transform: transform, tint: color, blend: .none)
  }

  private func draw(_ enc: MTLRenderCommandEncoder, textured: Bool, texture: MTLTexture?,
                    transform: float4x4, tint: SIMD4<Float>, blend: BlendMode) {
    var uniforms = QuadUniforms(transform: transform, tint: tint)
    enc.setRenderPipelineState(pipelines[PipelineKey(textured: textured, blend: blend)]!)
    enc.setVertexBytes(&uniforms, length: MemoryLayout<QuadUniforms>.stride, index: 0)
    enc.setFragmentBytes(&uniforms, length: MemoryLayout<QuadUniforms>.stride, index: 0)
    if let texture { enc.setFragmentTexture(texture, index: 0) }
    enc.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
  }
}

/// Uniform/non-uniform scale matrix: diag(s.x, s.y, s.z, 1). Used here for the feedback
/// plane's apparent-scale transform (spec §01 §3); reusable by later transform math
/// (Compositor, Task 9) since it operates on the same NDC-space quad convention.
public extension float4x4 {
  init(scaling s: SIMD3<Float>) {
    self = float4x4(diagonal: SIMD4(s.x, s.y, s.z, 1))
  }
}

/// The feedback core: the frame recipe that makes the instrument look like itself
/// (spec §01 §1 trigger order + design README's frame algorithm — ordering is
/// load-bearing). Owns the two ping-pong accumulator textures; everything else in the
/// engine only ever sees `accumulator`, the last completed frame.
public final class FeedbackCore {
  private let context: MetalContext
  private let format: MTLPixelFormat
  /// Last completed frame — what the rest of the engine (output stage, next frame's warp
  /// input) reads. Swapped, never copied, at the end of `renderFrame` (design §4: the
  /// screen-capture step Max needed for this is free on a GPU-native port).
  public private(set) var accumulator: MTLTexture
  /// This frame's write target. Becomes `accumulator` after the pointer swap.
  private var back: MTLTexture
  private let warp: WarpPass
  private let erasePipeline: MTLComputePipelineState
  private let quad: QuadRenderer
  /// Test/instrumentation hook: skips step 4 (the past-over composite) so erase-only and
  /// seed-only arithmetic can be verified in isolation. Golden runs always leave this true.
  public var feedbackPlaneEnabled = true

  public init(context: MetalContext, size: SIMD2<Int>, format: MTLPixelFormat = .rgba8Unorm) throws {
    self.context = context
    self.format = format
    self.warp = try WarpPass(context: context)
    self.erasePipeline = try context.computePipeline("fbx_erase")
    self.quad = try QuadRenderer(context: context, pixelFormat: format)
    self.accumulator = FeedbackCore.makeAccumulatorTexture(context: context, format: format,
                                                            width: size.x, height: size.y)
    self.back = FeedbackCore.makeAccumulatorTexture(context: context, format: format,
                                                     width: size.x, height: size.y)
    // Frame 0 must be deterministic — both accumulators start opaque black, not garbage
    // GPU memory (private-storage textures are uninitialized until written).
    FeedbackCore.clear(context: context, texture: accumulator, to: SIMD4(0, 0, 0, 1))
    FeedbackCore.clear(context: context, texture: back, to: SIMD4(0, 0, 0, 1))
  }

  /// The frame recipe (spec §01 §1 + design README; ordering is load-bearing):
  /// 1. erase `accumulator` toward `params.eraseColor` into `back`
  /// 2. warp `accumulator` (last completed frame) → a freshly leased texture
  /// 3. seeds under: caller draws into `back` (loaded, not cleared) with normal blending
  /// 4. past over: draw the warped texture as the feedback plane, (srcα, dstα) blend
  /// 5. swap — `back` becomes the new `accumulator`, no copy
  public func renderFrame(_ frame: FrameContext, params: RenderParams,
                          drawSeeds: (MTLRenderCommandEncoder) -> Void) -> MTLTexture {
    encodeErase(frame, from: accumulator, to: back, params: params)                    // 1
    let warped = warp.encode(frame, previous: accumulator, params: params.warpParams)  // 2

    let rp = MTLRenderPassDescriptor()
    rp.colorAttachments[0].texture = back
    rp.colorAttachments[0].loadAction = .load     // keep the erase kernel's output as the base
    rp.colorAttachments[0].storeAction = .store
    let enc = frame.commandBuffer.makeRenderCommandEncoder(descriptor: rp)!
    drawSeeds(enc)                                                                     // 3

    if feedbackPlaneEnabled {
      // Apparent scale of the videoplane as worldBump pushes it toward the camera:
      // 2.414·tan(22.5°) = 1.0 makes z = −0.414 exactly fullscreen (Constants table,
      // spec §01 §3). Camera at (0,0,2), so distance-to-plane = 2 − (−0.414 + worldBump)
      // = 2.414 − worldBump; apparent size scales inversely with distance.
      let scale = 2.414 / (2.414 - params.worldBump)
      quad.drawTextured(enc, texture: warped,
                        transform: float4x4(scaling: SIMD3(scale, scale, 1)),
                        tint: SIMD4(1, 1, 1, 1),
                        blend: .srcAlphaDstAlpha)                                       // 4
    }
    enc.endEncoding()

    swap(&accumulator, &back)                                                          // 5
    return accumulator
  }

  /// Live re-size (design §4): both accumulators are reallocated at the new size and
  /// cleared to `eraseColor` — the spec confirms live resize but not what the original
  /// did with the old contents, so clear is the defined, testable choice.
  public func resize(_ size: SIMD2<Int>, eraseColor: SIMD3<Float>) {
    let newAccumulator = FeedbackCore.makeAccumulatorTexture(context: context, format: format,
                                                              width: size.x, height: size.y)
    let newBack = FeedbackCore.makeAccumulatorTexture(context: context, format: format,
                                                       width: size.x, height: size.y)
    let color = SIMD4(eraseColor.x, eraseColor.y, eraseColor.z, 1)
    FeedbackCore.clear(context: context, texture: newAccumulator, to: color)
    FeedbackCore.clear(context: context, texture: newBack, to: color)
    accumulator = newAccumulator
    back = newBack
  }

  /// Draws a fullscreen solid-color quad with blending disabled — public as a test/
  /// instrumentation hook so tests can seed the accumulator with an exact, blend-free
  /// color; the spec-math tests' tolerances (3/255) depend on this being unblended.
  public func drawSolid(_ enc: MTLRenderCommandEncoder, color: SIMD4<Float>) {
    quad.drawSolid(enc, transform: matrix_identity_float4x4, color: color)
  }

  /// Step 1 of the frame recipe: `fbx_erase` (Shaders/Composite.metal) reads `prev`,
  /// writes `current` — no blending state needed, and it doubles as the ping-pong copy
  /// (`current` starts this frame holding the erased base that seeds/plane draw over).
  private func encodeErase(_ frame: FrameContext, from prev: MTLTexture, to current: MTLTexture,
                           params: RenderParams) {
    var erase = SIMD4(params.eraseColor.x, params.eraseColor.y, params.eraseColor.z, params.eraseAlpha)
    let enc = frame.commandBuffer.makeComputeCommandEncoder()!
    enc.setComputePipelineState(erasePipeline)
    enc.setTexture(prev, index: 0)
    enc.setTexture(current, index: 1)
    enc.setBytes(&erase, length: MemoryLayout<SIMD4<Float>>.stride, index: 0)
    let tg = MTLSize(width: 16, height: 16, depth: 1)
    enc.dispatchThreadgroups(MTLSize(width: (current.width + 15) / 16, height: (current.height + 15) / 16, depth: 1),
                             threadsPerThreadgroup: tg)
    enc.endEncoding()
  }

  /// Persistent (not pool-leased) ping-pong texture. Deliberately bypasses
  /// `MetalContext.makeTexture` — that helper is `.shared`-storage and documented "never
  /// the hot loop"; the accumulator IS the hot loop, so this uses `.private` storage like
  /// `TexturePool`'s own textures, sized directly off the caller's `width`/`height`.
  private static func makeAccumulatorTexture(context: MetalContext, format: MTLPixelFormat,
                                             width: Int, height: Int) -> MTLTexture {
    let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: format, width: width,
                                                     height: height, mipmapped: false)
    d.usage = [.shaderRead, .shaderWrite, .renderTarget]
    d.storageMode = .private
    return context.device.makeTexture(descriptor: d)!
  }

  /// GPU clear-to-color via a load-action-only render pass (no draw calls) — works on
  /// `.private` storage, unlike a CPU upload. Only used at init/resize, off the per-frame
  /// hot path, so committing and waiting synchronously here is fine.
  private static func clear(context: MetalContext, texture: MTLTexture, to color: SIMD4<Float>) {
    let rp = MTLRenderPassDescriptor()
    rp.colorAttachments[0].texture = texture
    rp.colorAttachments[0].loadAction = .clear
    rp.colorAttachments[0].clearColor = MTLClearColor(red: Double(color.x), green: Double(color.y),
                                                       blue: Double(color.z), alpha: Double(color.w))
    rp.colorAttachments[0].storeAction = .store
    let cb = context.queue.makeCommandBuffer()!
    let enc = cb.makeRenderCommandEncoder(descriptor: rp)!
    enc.endEncoding()
    cb.commit()
    cb.waitUntilCompleted()
  }
}
