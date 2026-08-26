import Metal
import simd

/// Fixed visual parameters for one of the two `jit.gl.graph` parity waveforms
/// (`patches/feedbax.sound2.maxpat` obj-12 and obj-213; docs/superpowers/specs/
/// 2026-08-24-dynamism-gap-diagnosis.md, "Audio couplings"). Only the sample data (both)
/// and wave 2's alpha (the bump pulse) vary per frame. Two static styles; a third is never
/// needed.
public struct WaveformStyle {
  /// World-space placement — `pak position`/`pak scale` in the original. `position.z` is what
  /// parks wave 2 deep (z = −2): the shared `Compositor.projection` makes it project smaller
  /// there, which is why the patch doesn't scale it down directly.
  public var position: SIMD3<Float>
  public var scale: SIMD3<Float>
  /// `@line_width` — the ribbon's FULL width in canvas pixels (12 for wave 1, 4 for wave 2).
  public var lineWidthPx: Float
  /// `@radial 1` + `radialradius`: > 0 draws the graph as a closed ring of this base radius
  /// (world units, y axis) instead of a left-to-right line. 0 = linear graph.
  public var radialRadius: Float
  /// Base RGBA — wave 2's alpha here is a fallback only; `WaveformRenderer.draw` overwrites
  /// it per frame with `wave2BaseAlpha + audio.waveBumpRaw`.
  public var color: SIMD4<Float>
  public var blend: QuadRenderer.BlendMode

  /// Wave 1 ("Bass", obj-12): a LINEAR graph, `line_width 12`, `scale 1.5 1 0`, `position
  /// 0 −0.85 0`, colour from `swatch[236]` with alpha 0.8, `blend_mode 6 7`. At z = 0 the
  /// visible half-height is 2·tan(22.5°) = 0.828, so the silent line's centre sits 0.022
  /// below the frame edge and only bass deflections push it into view — the audio-gated
  /// seed that the original's bands and "bass background" come from.
  public static let wave1 = WaveformStyle(
    position: SIMD3(0, -0.85, 0), scale: SIMD3(1.5, 1, 0),
    lineWidthPx: 12, radialRadius: 0,
    color: SIMD4(0.392375, 0.23808, 0, 0.8),
    blend: .alphaOver)

  /// Wave 2 ("Circle", obj-213): the RING — `loadmess 1 → prepend radial`, `radialradius 0.7`
  /// (`loadmess 0.7 → slider → pak radialradius`), `line_width 4`, `position 0 0 −2`,
  /// `scale 1 1 1`, colour from `swatch[238]`, `blend_mode 6 8` (src_alpha, dst_alpha). Drawn
  /// as an ellipse in frame-normalised coordinates per the diagnosis doc's fix-plan item 3
  /// (docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md) — measured off the render
  /// window, where the ring's radius is the same fraction of the half-width and of the
  /// half-height, matching the screenshot ratio.
  public static let wave2 = WaveformStyle(
    position: SIMD3(0, 0, -2), scale: SIMD3(1, 1, 1),
    lineWidthPx: 4, radialRadius: 0.7,
    color: SIMD4(0, 0.786722, 0.821229, 1),
    blend: .srcAlphaDstAlpha)
}

/// One ribbon vertex — mirrors `Composite.metal`'s `RibbonVertex` field-for-field (identical
/// byte layout is what lets `setVertexBuffer` hand the GPU exactly what Swift wrote).
struct RibbonVertex: Equatable {
  var point: SIMD2<Float>
  var normal: SIMD2<Float>
  var halfWidthNDC: Float
}

/// Draws the two parity waveforms as a `Compositor.overlays` entry — world-space polylines
/// expanded into screen-space ribbons (`fbx_ribbon_v`), one pipeline per blend mode. The
/// geometry math (`wave1LinePoints`/`wave2RingPolyline`/`ribbonVertices`) is pure and
/// unit-tested (`WaveformTests`); `draw` is the Metal glue.
public final class WaveformRenderer {
  /// Mirrors `Composite.metal`'s `WaveUniforms`.
  private struct WaveUniforms { var projection: float4x4; var z: Float; var color: SIMD4<Float> }

  /// `soundwave_enable` (the webUI "Bass" box): `loadmess 1` → `enable 1` → obj-12.
  public var wave1Enabled = true
  /// `soundwave_enable1` (the "Circle" box) has no loadmess, and `jit.gl.graph` enables by
  /// default — so obj-213 DRAWS at load with the box unchecked (diagnosis doc, "Audio
  /// couplings"). Off only once someone sends `enable 0`.
  public var wave2Enabled = true
  /// `loadmess 0.8 → slider[338] → + wavebumpsig → prepend alpha` — wave 2's base alpha.
  public var wave2BaseAlpha: Float = 0.8

  private let wave1Pipeline: MTLRenderPipelineState
  private let wave2Pipeline: MTLRenderPipelineState
  private let device: MTLDevice

  /// `pixelFormat` must be the accumulator's actual format (the render pass this draws into):
  /// a pipeline's colour-attachment format is fixed at build time and a mismatch fails at
  /// draw time, not creation time. No default on purpose — the caller always knows.
  public init(context: MetalContext, pixelFormat: MTLPixelFormat) throws {
    func function(_ name: String) throws -> MTLFunction {
      guard let fn = context.libraries.compactMap({ $0.makeFunction(name: name) }).first else {
        throw FeedbaxError.missingShader(name)
      }
      return fn
    }
    device = context.device
    func ribbonPipeline(blend: QuadRenderer.BlendMode) throws -> MTLRenderPipelineState {
      let desc = MTLRenderPipelineDescriptor()
      desc.vertexFunction = try function("fbx_ribbon_v")
      desc.fragmentFunction = try function("fbx_point_f")
      WaveformRenderer.configureBlend(desc.colorAttachments[0]!, format: pixelFormat, blend: blend)
      return try context.device.makeRenderPipelineState(descriptor: desc)
    }
    wave1Pipeline = try ribbonPipeline(blend: WaveformStyle.wave1.blend)
    wave2Pipeline = try ribbonPipeline(blend: WaveformStyle.wave2.blend)
  }

  /// Mirrors `QuadRenderer.BlendMode`'s factor mapping — duplicated rather than shared, since
  /// an `MTLRenderPipelineDescriptor` is tied to one vertex/fragment pair.
  private static func configureBlend(_ attachment: MTLRenderPipelineColorAttachmentDescriptor,
                                     format: MTLPixelFormat, blend: QuadRenderer.BlendMode) {
    attachment.pixelFormat = format
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
  }

  // MARK: - Pure geometry (unit-tested by WaveformTests)

  /// Wave 1's world-space polyline — `jit.gl.graph` in linear mode: sample i of N sits at
  /// `x = (2i/(N−1) − 1)·scale.x`, `y = position.y + sampleᵢ·scale.y`. The value→y mapping is
  /// taken as 1 world unit per unit value (PARITY-REVIEW: to be measured on the running patch).
  public static func wave1LinePoints(_ samples: [Float], style: WaveformStyle) -> [SIMD2<Float>] {
    let n = samples.count
    guard n > 0 else { return [] }
    let center = SIMD2(style.position.x, style.position.y)
    if n == 1 { return [center + SIMD2(-style.scale.x, samples[0] * style.scale.y)] }
    return (0..<n).map { i in
      let t = Float(i) / Float(n - 1) * 2 - 1     // −1…1 across the sample count
      return center + SIMD2(t * style.scale.x, samples[i] * style.scale.y)
    }
  }

  /// Wave 2's world-space closed ring — `radial 1`: point i of N at `θᵢ = 2π·i/N`,
  /// `r = radialRadius + sampleᵢ`, `x = position.x + r·cosθ·scale.x·canvasAspect`,
  /// `y = position.y + r·sinθ·scale.y`. Closed: point 0 is repeated as point N.
  public static func wave2RingPolyline(_ samples: [Float], style: WaveformStyle,
                                       canvasAspect: Float) -> [SIMD2<Float>] {
    let n = samples.count
    guard n > 0 else { return [] }
    let center = SIMD2(style.position.x, style.position.y)
    var points = [SIMD2<Float>](repeating: .zero, count: n + 1)
    for i in 0..<n {
      let theta = 2 * Float.pi * Float(i) / Float(n)
      let r = style.radialRadius + samples[i]
      points[i] = center + SIMD2(r * cos(theta) * style.scale.x * canvasAspect,
                                 r * sin(theta) * style.scale.y)
    }
    points[n] = points[0]
    return points
  }

  /// Expands a polyline into triangle-strip ribbon vertices: two per point, offset ±half
  /// width along the local normal (central differences; one-sided at the ends of an open
  /// line; for a closed loop the duplicated closing point is skipped so both ends of the strip
  /// share point 0's tangent).
  static func ribbonVertices(_ points: [SIMD2<Float>], closed: Bool, halfWidthNDC: Float) -> [RibbonVertex] {
    let count = points.count
    guard count > 1 else { return [] }
    var verts = [RibbonVertex](); verts.reserveCapacity(count * 2)
    for i in 0..<count {
      let prevIdx: Int, nextIdx: Int
      if closed {
        prevIdx = i == 0 ? count - 2 : i - 1
        nextIdx = i == count - 1 ? 1 : i + 1
      } else {
        prevIdx = max(i - 1, 0)
        nextIdx = min(i + 1, count - 1)
      }
      let tangent = points[nextIdx] - points[prevIdx]
      let len = simd_length(tangent)
      let dir = len > 1e-6 ? tangent / len : SIMD2<Float>(1, 0)
      let normal = SIMD2<Float>(-dir.y, dir.x)
      verts.append(RibbonVertex(point: points[i], normal: normal, halfWidthNDC: halfWidthNDC))
      verts.append(RibbonVertex(point: points[i], normal: normal, halfWidthNDC: -halfWidthNDC))
    }
    return verts
  }

  // MARK: - GPU draw (covered only by WaveformTests' smoke test)

  /// Hooked into `Compositor.overlays` — draws under the feedback plane, using the same
  /// `projection` every other world-space draw this frame uses.
  public func draw(_ enc: MTLRenderCommandEncoder, frame: FrameContext, audio: FrameAudio,
                   projection: float4x4) {
    let canvasHeight = max(Float(frame.canvasSize.y), 1)
    let canvasAspect = max(Float(frame.canvasSize.x), 1) / canvasHeight
    if wave1Enabled {
      let style = WaveformStyle.wave1
      drawRibbon(enc, pipeline: wave1Pipeline,
                 points: WaveformRenderer.wave1LinePoints(audio.wave1Points, style: style),
                 closed: false, style: style, color: style.color,
                 canvasHeight: canvasHeight, projection: projection)
    }
    if wave2Enabled {
      let style = WaveformStyle.wave2
      // Alpha pulse: base + wavebumpsig, UNCLAMPED on the CPU side — the original relies on
      // GL's raster-time clamp for an out-of-range value.
      var color = style.color
      color.w = wave2BaseAlpha + audio.waveBumpRaw
      drawRibbon(enc, pipeline: wave2Pipeline,
                 points: WaveformRenderer.wave2RingPolyline(audio.wave2Points, style: style,
                                                            canvasAspect: canvasAspect),
                 closed: true, style: style, color: color,
                 canvasHeight: canvasHeight, projection: projection)
    }
  }

  private func drawRibbon(_ enc: MTLRenderCommandEncoder, pipeline: MTLRenderPipelineState,
                          points: [SIMD2<Float>], closed: Bool, style: WaveformStyle,
                          color: SIMD4<Float>, canvasHeight: Float, projection: float4x4) {
    // Pixel→NDC uses canvas height only (Composite.metal's header on `fbx_ribbon_v`):
    // NDC spans 2 units over canvasHeight px, so a half width of lineWidthPx/canvasHeight NDC
    // is a FULL width of lineWidthPx pixels. Exact vertically, mildly stretched horizontally.
    let halfWidthNDC = style.lineWidthPx / canvasHeight
    let verts = WaveformRenderer.ribbonVertices(points, closed: closed, halfWidthNDC: halfWidthNDC)
    guard !verts.isEmpty else { return }
    var uniforms = WaveUniforms(projection: projection, z: style.position.z, color: color)
    let vbuf = device.makeBuffer(bytes: verts, length: MemoryLayout<RibbonVertex>.stride * verts.count,
                                 options: .storageModeShared)!
    enc.setRenderPipelineState(pipeline)
    enc.setVertexBuffer(vbuf, offset: 0, index: 0)
    enc.setVertexBytes(&uniforms, length: MemoryLayout<WaveUniforms>.stride, index: 1)
    enc.setFragmentBytes(&uniforms, length: MemoryLayout<WaveUniforms>.stride, index: 1)
    enc.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: verts.count)
  }
}
