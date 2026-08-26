import SwiftUI
import AppKit
import Metal
import QuartzCore
import simd

/// SwiftUI's bridge to `RenderView` — the output window's entire content.
public struct DisplayView: NSViewRepresentable {
  public let host: EngineHost

  public init(host: EngineHost) { self.host = host }

  public func makeNSView(context: Context) -> RenderView { RenderView(host: host) }
  public func updateNSView(_ nsView: RenderView, context: Context) {}
}

/// A `CAMetalLayer` that knows how big it is and tells `EngineHost` when it comes and goes.
/// That is the whole job. It used to own the `FrameClock`, the `OutputStage`, the call to
/// `engine.step`, and every input event; all four moved out (`EngineHost`, Task 2, and
/// `PerformerInputMonitor`, Task 4) so that closing this window no longer stops the
/// instrument.
public final class RenderView: NSView, RenderTarget {
  private let host: EngineHost
  private let layerForMetal = CAMetalLayer()

  public var metalLayer: CAMetalLayer { layerForMetal }
  public var drawableSizePixels: SIMD2<Int> {
    SIMD2(Int(layerForMetal.drawableSize.width), Int(layerForMetal.drawableSize.height))
  }
  public var hostingWindow: NSWindow? { window }

  public init(host: EngineHost) {
    self.host = host
    super.init(frame: .zero)
    wantsLayer = true
    layerForMetal.device = host.engine.context.device
    layerForMetal.pixelFormat = .bgra8Unorm
    // The engine's own passes never touch this layer (they draw into the private-storage
    // accumulator `OutputStage` reads FROM) — framebuffer-only is safe and is the cheaper
    // drawable-allocation mode.
    layerForMetal.framebufferOnly = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("RenderView is built programmatically by DisplayView, never from a nib/storyboard")
  }

  public override func makeBackingLayer() -> CALayer { layerForMetal }

  public override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()
    syncDrawableSize()
    guard window != nil else {
      // Window closed. `EngineHost.detach` swaps back to the timer driver — the engine keeps
      // stepping, the accumulator keeps evolving, and reopening the window picks the image up
      // where it actually is rather than where it was when the window closed.
      host.detach(self)
      return
    }
    host.attach(self)
  }

  deinit { host.detach(self) }

  public override func setFrameSize(_ newSize: NSSize) {
    super.setFrameSize(newSize)
    syncDrawableSize()
  }

  /// Also covers moving the window to a projector with a different backing scale — AppKit
  /// sends `viewDidChangeBackingProperties` for that, and the drawable has to follow or the
  /// output is drawn at the old screen's pixel density.
  public override func viewDidChangeBackingProperties() {
    super.viewDidChangeBackingProperties()
    syncDrawableSize()
  }

  private func syncDrawableSize() {
    let scale = window?.backingScaleFactor ?? 1
    layerForMetal.contentsScale = scale
    layerForMetal.drawableSize = CGSize(width: bounds.width * scale, height: bounds.height * scale)
  }
}
