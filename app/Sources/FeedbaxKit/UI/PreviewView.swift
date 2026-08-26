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
  /// Mirrors `EngineViewModel.hudEnabled` (Task 20) — a plain value, not a binding, so SwiftUI
  /// re-invokes `updateNSView` whenever the operator's HUD toggle changes, the same way any
  /// other `NSViewRepresentable` prop change propagates. Defaults to `true` (`OutputStage
  /// .hudEnabled`'s own default) so a caller that predates the operator panel keeps compiling
  /// and rendering the HUD exactly as before.
  public var hudEnabled: Bool = true

  public init(engine: Engine, surface: KeyboardTrackpadSurface, hudEnabled: Bool = true) {
    self.engine = engine
    self.surface = surface
    self.hudEnabled = hudEnabled
  }

  public func makeNSView(context: Context) -> MetalHostView {
    let view = MetalHostView(engine: engine, surface: surface)
    view.hudEnabled = hudEnabled
    return view
  }

  public func updateNSView(_ nsView: MetalHostView, context: Context) {
    nsView.hudEnabled = hudEnabled
  }
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

  /// Forwards to `OutputStage.hudEnabled` (Task 20's HUD toggle, `EngineViewModel.hudEnabled`
  /// via `PreviewView`). Stored here too, not just proxied, because `outputStage` doesn't exist
  /// yet at `init` time (built lazily in `viewDidMoveToWindow`, see that method's comment) — the
  /// `didSet` keeps whatever was set before the window existed, and `viewDidMoveToWindow`
  /// applies it once `outputStage` is finally there.
  public var hudEnabled: Bool = true {
    didSet { outputStage?.hudEnabled = hudEnabled }
  }

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
    guard window != nil else {
      // The view was removed from its window (or never had one) — a live `CAMetalDisplayLink`
      // is retained by the run loop it's attached to, NOT by anything that goes away just
      // because this view does, so without an explicit `invalidate()` here it keeps firing
      // and holding this view/`Engine` alive forever (the leak the review flagged). `deinit`
      // below is a second, final backstop for the case where this view is deallocated without
      // `viewDidMoveToWindow(nil)` ever running first.
      clock?.invalidate()
      clock = nil
      outputStage = nil
      return
    }
    guard clock == nil else { return }
    // `FrameClock`/`OutputStage` both need a real window/screen (the display link attaches to
    // the layer's eventual display) — deferred until the view is actually in a window, not
    // built in `init`.
    outputStage = try? OutputStage(context: engine.context, pixelFormat: metalLayer.pixelFormat)
    outputStage?.hudEnabled = hudEnabled   // apply whatever was set before the window existed
    clock = FrameClock(layer: metalLayer, rate: engine.frameRate) { [weak self] update in
      self?.renderFrame(update)
    }
    // `swift run`'s unbundled executable (no Info.plist/nib) doesn't hand out first-responder
    // status automatically the way a bundled app's window does — without this, `keyDown`/
    // `scrollWheel`/`magnify`/`mouseDragged` above never fire at all, because nothing is ever
    // asked to become key/first-responder for the window (review item: "keyboard likely never
    // reaches MetalHostView").
    window?.makeFirstResponder(self)
  }

  deinit {
    clock?.invalidate()
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
    // Final review, finding 3: `EngineViewModel.setFrameRate` only mutates `engine.frameRate`;
    // nothing else in this class ever told the already-running `FrameClock`'s display link
    // about a live preset change (`viewDidMoveToWindow` builds `clock` exactly once, guarded by
    // `clock == nil`). Polling here — once per tick, the cheapest place to notice the mismatch
    // without wiring a Combine/KVO observation path just for one Int — is what makes a preset
    // switch actually retune the running link instead of silently doing nothing until the next
    // relaunch. `updateRate` itself no-ops when the rate hasn't changed (`FrameClock
    // .shouldRetune`), so this costs nothing on the (overwhelming majority of) frames where it
    // hasn't.
    clock?.updateRate(engine.frameRate)
    let commandBuffer = engine.context.queue.makeCommandBuffer()!
    let now = CACurrentMediaTime()
    let accumulator = engine.step(at: now, commandBuffer: commandBuffer)
    let drawableSize = SIMD2(Int(metalLayer.drawableSize.width), Int(metalLayer.drawableSize.height))
    let db = AudioBands.decibels(engine.bands.inputRMS)
    let inputDB = db.isFinite ? Int(max(-90, min(20, db)).rounded()) : -90
    outputStage.draw(accumulator: accumulator, into: update.drawable, commandBuffer: commandBuffer,
                     drawableSize: drawableSize,
                     statusLine: "\(engine.audioStatus)   in \(inputDB) dB")
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

  /// Empty on purpose. AppKit only continues sending this view `mouseDragged`/`mouseUp` for a
  /// click-drag gesture that started with a `mouseDown` THIS view was actually offered — for
  /// an `NSView` hosted through SwiftUI's `NSViewRepresentable` (as `MetalHostView` is), the
  /// hosting layer can end up treating an unhandled `mouseDown` as unclaimed and never routes
  /// the drag here at all. Overriding it (even as a no-op — there is nothing to do on press
  /// itself, only on the drag in `mouseDragged` below) is what makes this view the recognized
  /// target for the rest of the gesture (review item: "option-drag hue/theta currently dead").
  public override func mouseDown(with event: NSEvent) {}

  /// Two-finger trackpad scroll — the original's shader-pan touch role (design §5).
  ///
  /// Normalization: `NSEvent.scrollingDeltaX/Y` are raw POINTS, and a single fast-swipe event
  /// can report 5–40 pts — fed straight into `KeyboardTrackpadSurface.accumulate`'s ±1 range
  /// at the bundled default sensitivity (1.0, `DefaultBindings.json`), that slams the pan
  /// accumulator to its clamp in one event instead of gliding across a gesture. Dividing by
  /// the view's own height (documented factor, chosen over an arbitrary sensitivity constant
  /// because it scales with window size automatically) turns "drag the full height of the
  /// preview" into "drive the axis across its whole −1...1 range" — a gesture-length feel
  /// `KeyboardTrackpadSurface` itself can't provide, since it's deliberately Metal/AppKit-free
  /// and has no visibility into view geometry (`ControlSurface`'s own doc comment on that
  /// narrowing, ControlVector.swift).
  public override func scrollWheel(with event: NSEvent) {
    let norm = Float(max(bounds.height, 1))
    surface.scroll(dx: Float(event.scrollingDeltaX) / norm, dy: Float(event.scrollingDeltaY) / norm)
  }

  /// Pinch/magnify gesture. `NSEvent.magnification` is already a small per-event ratio (not
  /// raw points the way scroll/drag deltas are), so it does not need the same normalization.
  public override func magnify(with event: NSEvent) {
    surface.magnify(Float(event.magnification))
  }

  /// Option-held drag: x → hue, y → theta (`KeyboardTrackpadSurface.modifiedDrag`'s mapping).
  /// Plain (non-option) drags are intentionally NOT forwarded — this view has no click-drag
  /// role of its own in P1. Same view-height normalization as `scrollWheel` above, and for the
  /// same reason: `event.deltaX`/`deltaY` are raw points.
  public override func mouseDragged(with event: NSEvent) {
    guard event.modifierFlags.contains(.option) else { return }
    let norm = Float(max(bounds.height, 1))
    surface.modifiedDrag(dx: Float(event.deltaX) / norm, dy: Float(event.deltaY) / norm)
  }
}
