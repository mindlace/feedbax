import SwiftUI
import AppKit
import Metal
import QuartzCore
import simd

/// SwiftUI's bridge to `MetalHostView` (below) — this file is the whole window for now (the
/// operator panel with sliders/toggles/pickers is Task 20; this is just the live preview +
/// the performer's baseline keyboard/trackpad input, design §5's "baseline-local-input").
public struct PreviewView: NSViewRepresentable {
  public let engine: Engine
  public let surface: KeyboardTrackpadSurface

  public init(engine: Engine, surface: KeyboardTrackpadSurface) {
    self.engine = engine
    self.surface = surface
  }

  public func makeNSView(context: Context) -> MetalHostView {
    MetalHostView(engine: engine, surface: surface)
  }

  public func updateNSView(_ nsView: MetalHostView, context: Context) {}
}

/// The actual `CAMetalLayer`-backed `NSView`. Owns the render loop end to end once it has a
/// real window to attach a `FrameClock` to: each display-link tick calls `Engine.step`,
/// `OutputStage.draw`s the result into the drawable, and presents. Also the performer's
/// keyboard/trackpad input surface — key presses, two-finger scroll, pinch/magnify, and
/// option-held drag all forward into `KeyboardTrackpadSurface` (design §5's baseline-
/// local-input), which the caller is expected to have already registered on
/// `engine.router.surfaces`.
public final class MetalHostView: NSView {
  public let engine: Engine
  private let surface: KeyboardTrackpadSurface
  private let metalLayer = CAMetalLayer()
  private var clock: FrameClock?
  private var outputStage: OutputStage?
  private var lastFrameTimestamp: CFTimeInterval?

  public init(engine: Engine, surface: KeyboardTrackpadSurface) {
    self.engine = engine
    self.surface = surface
    super.init(frame: .zero)
    wantsLayer = true
    metalLayer.device = engine.context.device
    metalLayer.pixelFormat = .bgra8Unorm
    // The engine's own render pass never touches this layer directly (it draws into the
    // ping-pong accumulator, a private-storage texture `OutputStage` reads FROM) — framebuffer-
    // only is safe and is the cheaper drawable-allocation mode.
    metalLayer.framebufferOnly = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("MetalHostView is built programmatically by PreviewView, never from a nib/storyboard")
  }

  public override func makeBackingLayer() -> CALayer { metalLayer }

  public override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()
    syncDrawableSize()
    guard window != nil, clock == nil else { return }
    // `FrameClock`/`OutputStage` both need a real window/screen (the display link attaches to
    // the layer's eventual display) — deferred until the view is actually in a window, not
    // built in `init`.
    outputStage = try? OutputStage(context: engine.context, pixelFormat: metalLayer.pixelFormat)
    clock = FrameClock(layer: metalLayer, rate: engine.frameRate) { [weak self] update in
      self?.renderFrame(update)
    }
  }

  public override func setFrameSize(_ newSize: NSSize) {
    super.setFrameSize(newSize)
    syncDrawableSize()
  }

  private func syncDrawableSize() {
    let scale = window?.backingScaleFactor ?? 1
    metalLayer.contentsScale = scale
    metalLayer.drawableSize = CGSize(width: bounds.width * scale, height: bounds.height * scale)
  }

  private func renderFrame(_ update: CAMetalDisplayLink.Update) {
    guard let outputStage else { return }
    let commandBuffer = engine.context.queue.makeCommandBuffer()!
    let now = CACurrentMediaTime()
    let accumulator = engine.step(at: now, commandBuffer: commandBuffer)
    let drawableSize = SIMD2(Int(metalLayer.drawableSize.width), Int(metalLayer.drawableSize.height))
    outputStage.draw(accumulator: accumulator, into: update.drawable, commandBuffer: commandBuffer,
                     drawableSize: drawableSize)
    commandBuffer.commit()
    // Frame-scoped pooled leases (the warp pass's output, filter-chain intermediates) are only
    // ever valid for the frame that leased them — `TexturePool.endFrame`'s own doc comment;
    // this is the "once per frame after the command buffer commits" call site it asks for.
    engine.context.pool.endFrame()
    if let lastFrameTimestamp {
      outputStage.recordFrameTime(now - lastFrameTimestamp)
    }
    lastFrameTimestamp = now
  }

  // MARK: - Input forwarding (design §5 baseline-local-input)

  public override var acceptsFirstResponder: Bool { true }

  /// Escape and `f` both toggle fullscreen (spec §01 §1: "the original's Esc"; `f` is also
  /// the bindings-table fullscreen key, `DefaultBindings.json`). Escape isn't part of the
  /// bindings vocabulary at all (no `ToggleEvent` reaches `Engine` for it), so it's handled
  /// directly here; `f` is ALSO forwarded to `surface` below so its `.fullscreen` toggle event
  /// still flows through the normal control path — harmless, since nothing downstream acts on
  /// it a second time (`Engine.handle(_:)`'s `.fullscreen` case is a deliberate no-op).
  public override func keyDown(with event: NSEvent) {
    if event.keyCode == 53 {   // Escape
      window?.toggleFullScreen(nil)
      return
    }
    guard let chars = event.charactersIgnoringModifiers, !chars.isEmpty else { return }
    if chars == "f" {
      window?.toggleFullScreen(nil)
    }
    surface.keyDown(chars)
  }

  /// Two-finger trackpad scroll — the original's shader-pan touch role (design §5).
  public override func scrollWheel(with event: NSEvent) {
    surface.scroll(dx: Float(event.scrollingDeltaX), dy: Float(event.scrollingDeltaY))
  }

  /// Pinch/magnify gesture.
  public override func magnify(with event: NSEvent) {
    surface.magnify(Float(event.magnification))
  }

  /// Option-held drag: x → hue, y → theta (`KeyboardTrackpadSurface.modifiedDrag`'s mapping).
  /// Plain (non-option) drags are intentionally NOT forwarded — this view has no click-drag
  /// role of its own in P1.
  public override func mouseDragged(with event: NSEvent) {
    guard event.modifierFlags.contains(.option) else { return }
    surface.modifiedDrag(dx: Float(event.deltaX), dy: Float(event.deltaY))
  }
}
