import Metal
import simd

/// Fixed visual parameters for one of the two `jit.gl.graph` parity waveforms (spec §03
/// §5-6). There are exactly two waveforms in the original patch, both with static
/// (non-audio-reactive) placement/color/blend — only the *sample data* (both) and wave 2's
/// alpha (the bump pulse, §03 §6) vary per frame. Declared as static lets on this type
/// rather than injected, since a third style is never needed.
public struct WaveformStyle {
  /// World-space placement — `pak position`/`pak scale` in the original (spec §03 §5's
  /// per-attribute tables). `position.z` is what pushes wave 2 behind wave 1/the feedback
  /// plane (z=−2 vs. z=0): the same `Compositor.projection` that draws everything else
  /// makes it project smaller there, which is why the patch parks it deep rather than
  /// scaling it down directly.
  public var position: SIMD3<Float>
  public var scale: SIMD3<Float>
  /// Ribbon half-width source, wave 1 only (`@line_width 12`, spec §03 §5) — 0 on wave 2's
  /// style, which draws point sprites instead of a ribbon.
  public var lineWidthPx: Float
  /// Point sprite edge length, wave 2 only — the port's documented approximation of
  /// `@circpoints 5`'s per-sample polygon dot (spec §03 §5's `poly_mode (0,0)` reading);
  /// 0 on wave 1's style, which draws a ribbon instead of sprites.
  public var pointSizePx: Float
  /// Base RGBA — wave 2's alpha channel here is a fallback only; `WaveformRenderer.draw`
  /// overwrites it per-frame with `wave2BaseAlpha + audio.waveBumpRaw` (spec §03 §6).
  public var color: SIMD4<Float>
  public var blend: QuadRenderer.BlendMode

  /// Wave 1 — burnt-orange radial ribbon (spec §03 §5-6 parity tables): position
  /// (0,−0.85,0) near the bottom of frame, scale (1.5,1,0) wide-and-flat, `line_width 12`,
  /// color (0.392375,0.23808,0,0.8) (swatch[236]'s RGB + slider[215]'s forced 0.8 alpha),
  /// standard alpha-over blend (`blend_mode 6 7`).
  public static let wave1 = WaveformStyle(
    position: SIMD3(0, -0.85, 0), scale: SIMD3(1.5, 1, 0),
    lineWidthPx: 12, pointSizePx: 0,
    color: SIMD4(0.392375, 0.23808, 0, 0.8),
    blend: .alphaOver)

  /// Wave 2 — cyan dotted linear spread (spec §03 §5-6): position (0,0,−2), scale
  /// (1,1,1), color (0,0.786722,0.821229,·) (swatch[238]'s RGB; alpha is the bump-pulse
  /// placeholder here, overwritten per-frame — see `color`'s doc), `blend_mode 6 8`
  /// (src_alpha/dst_alpha — unusual, not the standard pair wave 1 uses).
  public static let wave2 = WaveformStyle(
    position: SIMD3(0, 0, -2), scale: SIMD3(1, 1, 1),
    lineWidthPx: 0, pointSizePx: 8,
    color: SIMD4(0, 0.786722, 0.821229, 1),
    blend: .srcAlphaDstAlpha)
}

/// Draws the two parity waveforms as a `Compositor.overlays` entry (Task 9) — world-space
/// geometry, not a textured quad, so it owns its own tiny render pipelines rather than
/// going through `QuadRenderer`. The geometry math (`wave1Polyline`/`wave2Points`) is pure
/// and unit-tested (`WaveformTests`); `draw` is the untested GPU glue that turns that
/// geometry into per-frame vertex buffers and issues the draw calls.
public final class WaveformRenderer {
  /// Mirrors `Composite.metal`'s `RibbonVertex` field-for-field (see `QuadRenderer`'s
  /// `QuadUniforms` doc comment for why this matters — identical byte layout end to end).
  private struct RibbonVertex { var point: SIMD2<Float>; var normal: SIMD2<Float>; var halfWidthNDC: Float }
  /// Mirrors `Composite.metal`'s `PointVertex`.
  private struct PointVertex { var point: SIMD2<Float>; var corner: SIMD2<Float> }
  /// Mirrors `Composite.metal`'s `WaveUniforms`.
  private struct WaveUniforms { var projection: float4x4; var z: Float; var color: SIMD4<Float> }

  /// `soundwave_enable`'s effective default (spec §04 §1.4): `toggle[6]` is set on load via
  /// `loadmess 1` — mislabeled "unsaved" in the original UI listing but confirmed on at
  /// load. Wave 1 draws unless explicitly disabled.
  public var wave1Enabled = true
  /// `soundwave_enable1`'s effective default: `toggle[13]` has no `loadmess` — genuinely
  /// unsaved/off (spec §04 §1.4). Wave 2 stays hidden until enabled.
  public var wave2Enabled = false
  /// The manual base-alpha slider feeding wave 2's alpha-pulse formula (spec §03 §6:
  /// `slider[338]`, "default unknown from listing `[?]`"). 0.5 is this port's chosen
  /// placeholder, not a recovered value — flagged for verification against the running
  /// patch (spec §03 §12 q.2-adjacent).
  public var wave2BaseAlpha: Float = 0.5

  private let ribbonPipeline: MTLRenderPipelineState
  private let pointPipeline: MTLRenderPipelineState
  private let device: MTLDevice

  /// A `MTLRenderPipelineState`'s color-attachment pixel format is fixed at build time and
  /// must match whatever render pass it's later encoded into — mismatched formats fail
  /// Metal API validation at draw time, not at pipeline-creation time, so this can't be
  /// papered over with a convenient guess. `draw()` runs as a `Compositor.overlays` entry
  /// *inside* `FeedbackCore`'s own seeds render pass, drawing straight into the ping-pong
  /// accumulator — so `pixelFormat` here must be the accumulator's actual format: `FeedbackCore`'s
  /// own default is `.rgba8Unorm`, with `.rgba16Float` available under the quality-toggle
  /// variant (design §4's "RGBA16F-accumulator" headroom option). No default value is
  /// offered on this parameter (unlike `QuadRenderer`'s own `pixelFormat` parameter, which
  /// carries the same precedent) — the caller always knows its target format, and guessing
  /// wrong here is a silent landmine, not a loud one.
  public init(context: MetalContext, pixelFormat: MTLPixelFormat) throws {
    func function(_ name: String) throws -> MTLFunction {
      guard let fn = context.libraries.compactMap({ $0.makeFunction(name: name) }).first else {
        throw FeedbaxError.missingShader(name)
      }
      return fn
    }
    device = context.device
    let format = pixelFormat

    let ribbonDesc = MTLRenderPipelineDescriptor()
    ribbonDesc.vertexFunction = try function("fbx_ribbon_v")
    ribbonDesc.fragmentFunction = try function("fbx_point_f")
    WaveformRenderer.configureBlend(ribbonDesc.colorAttachments[0]!, format: format, blend: WaveformStyle.wave1.blend)
    ribbonPipeline = try context.device.makeRenderPipelineState(descriptor: ribbonDesc)

    let pointDesc = MTLRenderPipelineDescriptor()
    pointDesc.vertexFunction = try function("fbx_point_v")
    pointDesc.fragmentFunction = try function("fbx_point_f")
    WaveformRenderer.configureBlend(pointDesc.colorAttachments[0]!, format: format, blend: WaveformStyle.wave2.blend)
    pointPipeline = try context.device.makeRenderPipelineState(descriptor: pointDesc)
  }

  /// Mirrors `QuadRenderer.BlendMode`'s factor mapping (Task 8) — duplicated rather than
  /// shared, since an `MTLRenderPipelineDescriptor` is tied to one vertex/fragment function
  /// pair each, so `QuadRenderer`'s own build loop (built around `fbx_quad_v`/`_f`) can't
  /// be reused directly for these functions.
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

  /// Wave 1's world-space closed polyline (spec §03 §5 `radial 1` reading — documented
  /// approximation, PARITY-REVIEW: `jit.gl.graph`'s exact internal radial-to-vertex mapping
  /// isn't in the object listing; this is a standard polar-plot reading, parity-reviewed
  /// against archived stills, not derived from source). Point i of N sits at
  /// `θᵢ = 2π·i/N`, `r = radialRadius(1.0) + sampleᵢ` (1.0 = `pak radialradius 1.`[305]'s
  /// baseline before any gesture/manual offset — wave 1 has no radius control wired to it
  /// in the listing, so it stays at that baseline), position =
  /// `style.position.xy + style.scale.xy · (r·cosθᵢ, r·sinθᵢ)`. Closed: point 0 is
  /// repeated as point N, so `WaveformRenderer.draw` (and any other caller) can treat the
  /// result as a sealed loop of N+1 vertices without special-casing the seam.
  public static func wave1Polyline(_ samples: [Float], style: WaveformStyle) -> [SIMD2<Float>] {
    let n = samples.count
    guard n > 0 else { return [] }
    let radialRadius: Float = 1.0
    let center = SIMD2(style.position.x, style.position.y)
    let scaleXY = SIMD2(style.scale.x, style.scale.y)
    var points = [SIMD2<Float>](repeating: .zero, count: n + 1)
    for i in 0..<n {
      let theta = 2 * Float.pi * Float(i) / Float(n)
      let r = radialRadius + samples[i]
      points[i] = center + scaleXY * SIMD2(r * cos(theta), r * sin(theta))
    }
    points[n] = points[0]
    return points
  }

  /// Wave 2's world-space point spread (spec §03 §5 linear reading): x spans
  /// `±style.scale.x` evenly across the N samples (sample 0 at −scale.x, sample N−1 at
  /// +scale.x — a single sample places at −scale.x, the left edge, rather than dividing by
  /// zero), y = `sampleᵢ·style.scale.y`, both offset by `style.position.xy`.
  public static func wave2Points(_ samples: [Float], style: WaveformStyle) -> [SIMD2<Float>] {
    let n = samples.count
    guard n > 0 else { return [] }
    let center = SIMD2(style.position.x, style.position.y)
    if n == 1 {
      return [center + SIMD2(-style.scale.x, samples[0] * style.scale.y)]
    }
    return (0..<n).map { i in
      let t = Float(i) / Float(n - 1) * 2 - 1     // −1...1 across the sample count
      return center + SIMD2(t * style.scale.x, samples[i] * style.scale.y)
    }
  }

  // MARK: - GPU draw (untested by unit tests — Metal-dependent)

  /// Hooked into `Compositor.overlays` (Task 9) — draws under the feedback plane, using
  /// the same `projection` every other world-space draw this frame uses.
  public func draw(_ enc: MTLRenderCommandEncoder, frame: FrameContext, audio: FrameAudio,
                   projection: float4x4) {
    let canvasHeight = max(Float(frame.canvasSize.y), 1)
    if wave1Enabled {
      drawWave1(enc, samples: audio.wave1Points, canvasHeight: canvasHeight, projection: projection)
    }
    if wave2Enabled {
      drawWave2(enc, samples: audio.wave2Points, waveBumpRaw: audio.waveBumpRaw,
               canvasHeight: canvasHeight, projection: projection)
    }
  }

  private func drawWave1(_ enc: MTLRenderCommandEncoder, samples: [Float], canvasHeight: Float,
                         projection: float4x4) {
    let style = WaveformStyle.wave1
    let points = WaveformRenderer.wave1Polyline(samples, style: style)
    guard points.count > 1 else { return }
    // PARITY-REVIEW: pixel→NDC conversion uses canvas height only (see Composite.metal's
    // header comment on this file's ribbon/point vertex functions) — aspect-agnostic,
    // exact vertically, mildly stretched horizontally on a non-square canvas.
    let halfWidthNDC = style.lineWidthPx / canvasHeight

    let count = points.count   // N+1, closed (points[0] == points[count-1])
    var verts = [RibbonVertex](); verts.reserveCapacity(count * 2)
    for i in 0..<count {
      // Central-difference tangent around the ring; skip the duplicate closing sample so
      // the seam's tangent matches point 0's exactly (both ends of the strip agree).
      let prevIdx = i == 0 ? count - 2 : i - 1
      let nextIdx = i == count - 1 ? 1 : i + 1
      let tangent = points[nextIdx] - points[prevIdx]
      let len = simd_length(tangent)
      let dir = len > 1e-6 ? tangent / len : SIMD2<Float>(1, 0)
      let normal = SIMD2<Float>(-dir.y, dir.x)
      verts.append(RibbonVertex(point: points[i], normal: normal, halfWidthNDC: halfWidthNDC))
      verts.append(RibbonVertex(point: points[i], normal: normal, halfWidthNDC: -halfWidthNDC))
    }

    var uniforms = WaveUniforms(projection: projection, z: style.position.z, color: style.color)
    let vbuf = device.makeBuffer(bytes: verts, length: MemoryLayout<RibbonVertex>.stride * verts.count,
                                 options: .storageModeShared)!
    enc.setRenderPipelineState(ribbonPipeline)
    enc.setVertexBuffer(vbuf, offset: 0, index: 0)
    enc.setVertexBytes(&uniforms, length: MemoryLayout<WaveUniforms>.stride, index: 1)
    enc.setFragmentBytes(&uniforms, length: MemoryLayout<WaveUniforms>.stride, index: 1)
    enc.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: verts.count)
  }

  private func drawWave2(_ enc: MTLRenderCommandEncoder, samples: [Float], waveBumpRaw: Float,
                         canvasHeight: Float, projection: float4x4) {
    let style = WaveformStyle.wave2
    let points = WaveformRenderer.wave2Points(samples, style: style)
    guard !points.isEmpty else { return }
    // Same PARITY-REVIEW pixel→NDC convention as the ribbon, applied to the sprite edge.
    let halfSizeNDC = style.pointSizePx / canvasHeight / 2
    let corners: [SIMD2<Float>] = [
      SIMD2(-halfSizeNDC, -halfSizeNDC), SIMD2(halfSizeNDC, -halfSizeNDC), SIMD2(-halfSizeNDC, halfSizeNDC),
      SIMD2(halfSizeNDC, -halfSizeNDC), SIMD2(halfSizeNDC, halfSizeNDC), SIMD2(-halfSizeNDC, halfSizeNDC),
    ]
    var verts = [PointVertex](); verts.reserveCapacity(points.count * 6)
    for p in points {
      for c in corners { verts.append(PointVertex(point: p, corner: c)) }
    }

    // Alpha pulse (spec §03 §6): base + wavebumpsig, UNCLAMPED on the CPU side — the
    // original relies on GL's own raster-time clamp for an out-of-range value (checklist
    // #10); clamping here would silently diverge from that behavior.
    var color = style.color
    color.w = wave2BaseAlpha + waveBumpRaw
    var uniforms = WaveUniforms(projection: projection, z: style.position.z, color: color)
    let vbuf = device.makeBuffer(bytes: verts, length: MemoryLayout<PointVertex>.stride * verts.count,
                                 options: .storageModeShared)!
    enc.setRenderPipelineState(pointPipeline)
    enc.setVertexBuffer(vbuf, offset: 0, index: 0)
    enc.setVertexBytes(&uniforms, length: MemoryLayout<WaveUniforms>.stride, index: 1)
    enc.setFragmentBytes(&uniforms, length: MemoryLayout<WaveUniforms>.stride, index: 1)
    enc.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: verts.count)
  }
}
