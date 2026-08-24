import Metal
import QuartzCore
import CoreGraphics
import CoreText
import simd
#if canImport(AppKit)
import AppKit
#endif

/// Draws `Engine.step`'s accumulator into a `CAMetalLayer`'s drawable — the "preview window"
/// half of the instrument (design §4's framing: the screen-capture step Max needed for this is
/// free on a GPU-native port, because the accumulator IS already a texture the window can just
/// draw). Two responsibilities: aspect-fit the accumulator into whatever size the window
/// actually is (the accumulator's aspect and the window's aspect need not match — a resize or
/// a resolution-preset switch can leave them mismatched for a frame or two), and a toggleable
/// frame-time HUD (rolling p50/p99) so a performer can see whether the rig is keeping up with
/// its `frameRate` without reaching for Instruments.
///
/// Untested by `EngineTests` — same reasoning as `FrameClock`: this only ever runs against a
/// real drawable, which needs a real window/screen. `aspectFitTransform` and `percentiles` are
/// pulled out as pure `static` functions specifically so they COULD be unit-tested later
/// without a GPU, even though no task in this plan currently does.
public final class OutputStage {
  private let quad: QuadRenderer

  /// Toggleable per the brief — a performer/operator (Task 20) can hide the HUD without it
  /// ever leaving the accumulator itself (it draws only into the drawable, never into the
  /// feedback loop).
  public var hudEnabled = true

  /// Rolling frame-time window. ~4 s at 60 Hz is enough samples for a p99 that isn't just
  /// "the single slowest frame in the last second," without holding an unbounded history.
  private static let ringCapacity = 240
  private var frameTimes: [Double] = []

  /// HUD text is redrawn at ~2 Hz, not every frame — `NSAttributedString` → `CGContext` text
  /// layout is cheap at HUD sizes but there is no reason to pay it 60/120 times a second for
  /// text a human is going to read maybe twice a second at most.
  private static let hudUpdateInterval: CFTimeInterval = 0.5
  private var lastHUDUpdate: CFTimeInterval = 0
  private var hudTexture: MTLTexture?
  private var hudPixelSize: SIMD2<Int> = .zero

  private let context: MetalContext

  /// `pixelFormat` must be the DRAWABLE's format (typically `.bgra8Unorm` for a `CAMetalLayer`)
  /// — NOT the accumulator's own format. `QuadRenderer`'s pipelines are built once against
  /// whatever format is handed in here, and a render pipeline's color-attachment format is
  /// fixed at build time (Task 18's ruling, cited on `WaveformRenderer.init`): drawing the
  /// accumulator texture as an input is fine regardless of ITS format (it's read through a
  /// texture binding, not a color attachment), but the render PASS this draws into targets the
  /// drawable, so the pipeline must match the drawable's format, not the accumulator's.
  public init(context: MetalContext, pixelFormat: MTLPixelFormat) throws {
    self.context = context
    self.quad = try QuadRenderer(context: context, pixelFormat: pixelFormat)
  }

  /// Records one presented frame's wall-clock duration (seconds), for the HUD's p50/p99.
  public func recordFrameTime(_ seconds: Double) {
    frameTimes.append(seconds)
    if frameTimes.count > Self.ringCapacity {
      frameTimes.removeFirst(frameTimes.count - Self.ringCapacity)
    }
  }

  /// Draws `accumulator` aspect-fit into `drawable`, then the HUD overlay (if enabled), and
  /// presents. Owns the whole render pass for this call — callers just `commit()` afterward.
  public func draw(accumulator: MTLTexture, into drawable: CAMetalDrawable,
                   commandBuffer: MTLCommandBuffer, drawableSize: SIMD2<Int>) {
    let rp = MTLRenderPassDescriptor()
    rp.colorAttachments[0].texture = drawable.texture
    rp.colorAttachments[0].loadAction = .clear
    rp.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
    rp.colorAttachments[0].storeAction = .store
    guard let enc = commandBuffer.makeRenderCommandEncoder(descriptor: rp) else { return }

    let fitTransform = OutputStage.aspectFitTransform(
      contentSize: SIMD2(accumulator.width, accumulator.height), drawableSize: drawableSize)
    quad.drawTextured(enc, texture: accumulator, transform: fitTransform,
                      tint: SIMD4(1, 1, 1, 1), blend: .none)

    if hudEnabled {
      updateHUDIfDue()
      if let hudTexture, hudPixelSize.x > 0, hudPixelSize.y > 0 {
        let hudTransform = OutputStage.hudCornerTransform(hudPixelSize: hudPixelSize, drawableSize: drawableSize)
        quad.drawTextured(enc, texture: hudTexture, transform: hudTransform,
                          tint: SIMD4(1, 1, 1, 1), blend: .alphaOver)
      }
    }

    enc.endEncoding()
    commandBuffer.present(drawable)
  }

  /// Scale-to-fit (letterbox, never crop) transform mapping a `contentSize`-aspect unit quad
  /// (half-extent 1, `QuadRenderer`'s convention) into a `drawableSize`-aspect NDC square —
  /// plain 2D scale math, no 3D projection (unlike `Compositor.projection`, this draw has no
  /// camera; the drawable IS the screen).
  static func aspectFitTransform(contentSize: SIMD2<Int>, drawableSize: SIMD2<Int>) -> float4x4 {
    guard contentSize.x > 0, contentSize.y > 0, drawableSize.x > 0, drawableSize.y > 0 else {
      return matrix_identity_float4x4
    }
    let contentAspect = Float(contentSize.x) / Float(contentSize.y)
    let drawableAspect = Float(drawableSize.x) / Float(drawableSize.y)
    // Wider-than-drawable content is letterboxed top/bottom (shrink y); taller-than-drawable
    // content is pillarboxed left/right (shrink x) — exactly one axis ever shrinks below 1.
    let scale: SIMD2<Float> = contentAspect > drawableAspect
      ? SIMD2(1, drawableAspect / contentAspect)
      : SIMD2(contentAspect / drawableAspect, 1)
    return float4x4(scaling: SIMD3(scale.x, scale.y, 1))
  }

  /// Places the HUD as a small quad pinned to the top-left corner, sized to its own pixel
  /// dimensions (no stretching — text should render at native resolution). `translation`'s
  /// units are the same NDC space `aspectFitTransform` above operates in.
  private static func hudCornerTransform(hudPixelSize: SIMD2<Int>, drawableSize: SIMD2<Int>) -> float4x4 {
    let halfW = Float(hudPixelSize.x) / Float(drawableSize.x)
    let halfH = Float(hudPixelSize.y) / Float(drawableSize.y)
    let margin: Float = 0.02
    // NDC: +x right, +y up, origin center — top-left corner is (−1+halfW, 1−halfH), nudged in
    // by `margin` so the HUD doesn't touch the drawable's edge.
    let translate = float4x4(translation: SIMD3(-1 + halfW + margin, 1 - halfH - margin, 0))
    let scale = float4x4(scaling: SIMD3(halfW, halfH, 1))
    return translate * scale
  }

  private func updateHUDIfDue() {
    let now = CACurrentMediaTime()
    guard now - lastHUDUpdate >= Self.hudUpdateInterval else { return }
    guard let (p50, p99) = OutputStage.percentiles(frameTimes) else { return }
    lastHUDUpdate = now
    let text = String(format: "p50 %.1f ms   p99 %.1f ms", p50 * 1000, p99 * 1000)
    if let rendered = OutputStage.renderTextTexture(text, context: context) {
      hudTexture = rendered.texture
      hudPixelSize = rendered.size
    }
  }

  /// p50/p99 of a rolling frame-time sample, sorted-then-indexed (no interpolation — at
  /// `ringCapacity` = 240 samples the nearest-rank estimate is well within HUD-legible
  /// precision, and this is display-only, not a certified measurement). Pure and file-private
  /// static so it needs no GPU/context to exercise, if a future test wants to.
  static func percentiles(_ samples: [Double]) -> (p50: Double, p99: Double)? {
    guard !samples.isEmpty else { return nil }
    let sorted = samples.sorted()
    func rank(_ p: Double) -> Double {
      let index = min(sorted.count - 1, max(0, Int((p * Double(sorted.count)).rounded(.down))))
      return sorted[index]
    }
    return (rank(0.50), rank(0.99))
  }

  /// Rasterizes `text` into a small RGBA texture via `NSAttributedString`/`CGContext` — the
  /// same "premultiplied-from-CGContext, un-premultiply by hand" recipe `StickerSource
  /// .decodeImage` uses, reused here because it's the one CoreGraphics contract that actually
  /// holds (a `CGContext` never hands back straight alpha) and `MetalContext.makeTexture`'s
  /// upload path expects straight alpha in, matching every other texture in this engine.
  static func renderTextTexture(_ text: String, context: MetalContext) -> (texture: MTLTexture, size: SIMD2<Int>)? {
    #if canImport(AppKit)
    let font = NSFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
    let attributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .foregroundColor: NSColor.white,
    ]
    let attributed = NSAttributedString(string: text, attributes: attributes)
    let textSize = attributed.size()
    let padding: CGFloat = 6
    let width = max(1, Int((textSize.width + padding * 2).rounded(.up)))
    let height = max(1, Int((textSize.height + padding * 2).rounded(.up)))

    var raw = [UInt8](repeating: 0, count: width * height * 4)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard let ctx = CGContext(data: &raw, width: width, height: height, bitsPerComponent: 8,
                              bytesPerRow: width * 4, space: colorSpace,
                              bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
      return nil
    }
    // A translucent black backing so the HUD reads over bright content, not full opacity: the
    // performer's own imagery stays visible underneath.
    ctx.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 0.55))
    ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: false)
    // UNVERIFIED (no GUI in this environment to check visually — flagged for the manual smoke
    // test, brief step 4): `CGContext`'s row-major buffer origin is bottom-left, and
    // `flipped: false` asks AppKit's text layout to draw in that same bottom-left-origin
    // convention, so the upload below should NOT need a vertical flip the way
    // `StickerSource.decodeImage`'s image-draw path empirically confirmed for ITS case — but
    // that was verified for `CGImage` draws specifically, not `NSAttributedString` layout, so
    // treat this HUD text's orientation as unconfirmed until eyeballed in a real window.
    attributed.draw(at: CGPoint(x: padding, y: padding))
    NSGraphicsContext.restoreGraphicsState()

    var pixels = [SIMD4<Float>](repeating: .zero, count: width * height)
    for i in 0..<(width * height) {
      let o = i * 4
      let a = Float(raw[o + 3]) / 255
      if a > 0 {
        let r = Float(raw[o]) / 255, g = Float(raw[o + 1]) / 255, b = Float(raw[o + 2]) / 255
        pixels[i] = SIMD4(r / a, g / a, b / a, a)
      }
    }
    let texture = context.makeTexture(width: width, height: height, format: .rgba8Unorm, pixels: pixels)
    return (texture, SIMD2(width, height))
    #else
    return nil
    #endif
  }
}
