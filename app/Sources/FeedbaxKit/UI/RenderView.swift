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
  /// Tracks the hosting window's `isVisible`, not its lifecycle — see `viewDidMoveToWindow`'s
  /// doc comment for why lifecycle alone (`window == nil`) isn't enough here.
  private var visibilityObservation: NSKeyValueObservation?

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

  /// `Window` scenes (as opposed to `WindowGroup`) do not deallocate their `NSWindow` when the
  /// performer clicks the close button — SwiftUI keeps it alive, merely hidden
  /// (`isVisible == false`, still `screen != nil`), so it can reopen instantly from the Window
  /// menu with its SwiftUI state intact. That means `viewDidMoveToWindow` only ever fires ONCE,
  /// at initial window creation — clicking close never moves this view to a nil window, so the
  /// `window == nil` branch below is dead in practice for a `Window` scene (kept as a backstop
  /// for a hypothetical real teardown). Relying on it alone left `EngineHost` wedged on the
  /// display-linked driver bound to the now-hidden window's layer — whose display link stops
  /// delivering ticks once the window has no on-screen presence — which silently froze not just
  /// rendering but `engine.step` itself (and therefore every queued control write) until the
  /// window was manually reopened, defeating spec goal 2 entirely. Observing `isVisible`
  /// directly tracks the thing that actually changes on close/reopen, for both directions: it
  /// goes false on close (attach → detach, matching this view's `deinit`/nil-window teardown
  /// path) and true again when reopened from the Window menu (no separate "became key/main"
  /// hook needed — re-attaching on visibility is what lets the display link resume).
  public override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()
    syncDrawableSize()
    visibilityObservation = nil
    guard let window else {
      host.detach(self)
      return
    }
    host.attach(self)
    visibilityObservation = window.observe(\.isVisible, options: [.new]) { [weak self] _, change in
      guard let self, let isVisible = change.newValue else { return }
      isVisible ? self.host.attach(self) : self.host.detach(self)
    }
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
