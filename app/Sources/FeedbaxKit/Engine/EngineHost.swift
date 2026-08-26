import Foundation
import Metal
import QuartzCore
import AppKit
import simd

/// Whatever the host can present a finished frame into — in the app, exactly one thing: the
/// output window's `RenderView`. Deliberately narrow (a layer, its pixel size, and the window
/// it lives in) so `EngineHost` never reaches into AppKit view state.
public protocol RenderTarget: AnyObject {
  var metalLayer: CAMetalLayer { get }
  var drawableSizePixels: SIMD2<Int> { get }
  /// The window this target is presenting into, if any. Routed through here (rather than
  /// matched by `NSWindow.identifier` against a SwiftUI scene id at the call site) so a later
  /// consumer that needs to find the output window — for Escape/`f` fullscreen, or for deciding
  /// whether a pointer gesture happened over the output — gets an exact answer instead of a
  /// silent nil from an uncontracted SwiftUI behavior.
  var hostingWindow: NSWindow? { get }
}

/// Builds drivers. Exists so `EngineHostTests` can run headless: the real factory hands back a
/// `DisplayLinkDriver` that needs a live display, the test factory hands back a hand-fired
/// fake, and `EngineHost`'s own attach/detach logic is identical either way.
public protocol FrameDriverFactory {
  func makeWindowless(rate: Int, tick: @escaping (FrameTick) -> Void) -> FrameDriver
  func makeDisplayLinked(target: RenderTarget, rate: Int,
                         tick: @escaping (FrameTick) -> Void) -> FrameDriver
}

public struct SystemFrameDriverFactory: FrameDriverFactory {
  public init() {}
  public func makeWindowless(rate: Int, tick: @escaping (FrameTick) -> Void) -> FrameDriver {
    TimerDriver(rate: rate, tick: tick)
  }
  public func makeDisplayLinked(target: RenderTarget, rate: Int,
                                tick: @escaping (FrameTick) -> Void) -> FrameDriver {
    DisplayLinkDriver(layer: target.metalLayer, rate: rate, tick: tick)
  }
}

/// Owns the engine and the clock that drives it, for the entire lifetime of the process.
///
/// This is the inversion the control/display split is really made of. Before it, the render
/// view owned the `FrameClock` and was the only caller of `engine.step`, which meant no window
/// = no rendering — and for a feedback instrument, no rendering means the accumulator stops
/// evolving. The image is the state. Here, the host steps forever and merely *presents* into a
/// target when one happens to be attached.
public final class EngineHost {
  public let engine: Engine
  /// Internal (not private) so `EngineHostTests` can assert the HUD forwarding; nothing
  /// outside the module sees it.
  let outputStage: OutputStage
  private let factory: FrameDriverFactory
  private var driver: FrameDriver?
  private weak var target: RenderTarget?
  private var lastFrameTimestamp: CFTimeInterval?

  /// Bumped on every driver swap and captured by the tick closure handed to each driver. A
  /// driver that was invalidated mid-flight can still deliver one last tick (a display link
  /// already inside its callback, a timer handler already dispatched); without this stamp
  /// that stale tick would step the engine a second time for a frame the new driver is about
  /// to step too. Compare-and-drop is cheaper and more obvious than trying to make teardown
  /// synchronous.
  private var generation: Int = 0

  public private(set) var frameCount: Int = 0
  public var isAttached: Bool { target != nil }

  /// The window currently presenting the engine's output, if any. Routed through the attached
  /// `RenderTarget` rather than discovered by matching a SwiftUI scene id, so a later caller
  /// (Escape/`f` fullscreen, pointer-over-output checks) gets an exact answer instead of a
  /// silent nil from an uncontracted SwiftUI behavior.
  public var attachedWindow: NSWindow? { target?.hostingWindow }

  public var hudEnabled: Bool = true {
    didSet { outputStage.hudEnabled = hudEnabled }
  }

  /// Throws whatever `OutputStage.init` throws. The old code built it with `try?` inside
  /// `MetalHostView.viewDidMoveToWindow` and silently rendered nothing forever if it failed
  /// (spec, "Fix carried along"); a shader/pipeline failure is a launch-time fatal, and the
  /// callers of this initializer already print-and-exit the same way they do for `Engine`.
  public init(engine: Engine, factory: FrameDriverFactory = SystemFrameDriverFactory(),
              pixelFormat: MTLPixelFormat = .bgra8Unorm) throws {
    self.engine = engine
    self.factory = factory
    self.outputStage = try OutputStage(context: engine.context, pixelFormat: pixelFormat)
    self.outputStage.hudEnabled = hudEnabled
  }

  /// Starts the windowless clock. Called once at bootstrap, BEFORE any window exists — that
  /// ordering is the point (spec goal 2).
  public func start() {
    guard driver == nil else { return }
    installDriver { [weak self] gen, tick in
      guard let self else { return nil }
      return self.factory.makeWindowless(rate: self.engine.frameRate, tick: tick)
    }
  }

  /// The output window opened (or moved to a new screen and rebuilt its layer). Swaps to a
  /// vsync-locked driver bound to that window's display.
  public func attach(_ target: RenderTarget) {
    self.target = target
    installDriver { [weak self] gen, tick in
      guard let self else { return nil }
      return self.factory.makeDisplayLinked(target: target, rate: self.engine.frameRate, tick: tick)
    }
  }

  /// The output window closed. Swaps back to the timer so the loop keeps evolving. A detach
  /// from a target that is no longer the live one is ignored: AppKit tears the old view down
  /// AFTER the new one has been set up, so an unguarded detach would kill a freshly attached
  /// window's driver.
  public func detach(_ target: RenderTarget) {
    guard self.target === target else { return }
    self.target = nil
    installDriver { [weak self] gen, tick in
      guard let self else { return nil }
      return self.factory.makeWindowless(rate: self.engine.frameRate, tick: tick)
    }
  }

  private func installDriver(_ build: (Int, @escaping (FrameTick) -> Void) -> FrameDriver?) {
    driver?.invalidate()
    generation &+= 1
    let gen = generation
    driver = build(gen) { [weak self] tick in
      guard let self, gen == self.generation else { return }
      self.renderFrame(tick)
    }
  }

  /// One frame: step the engine, present into the drawable if there is one, commit, release
  /// the frame's pooled leases. Structurally the same body `MetalHostView.renderFrame` had —
  /// the difference is that `tick.drawable` is now allowed to be nil.
  private func renderFrame(_ tick: FrameTick) {
    // The frame-rate preset picker only mutates `engine.frameRate`; polling it here (once per
    // tick, a no-op unless it actually changed — `FrameClock.shouldRetune`) is what makes a
    // live switch retune the running driver instead of waiting for a relaunch.
    driver?.updateRate(engine.frameRate)

    let commandBuffer = engine.context.queue.makeCommandBuffer()!
    let now = CACurrentMediaTime()
    let accumulator = engine.step(at: now, commandBuffer: commandBuffer)

    if let drawable = tick.drawable, let target {
      let db = AudioBands.decibels(engine.bands.inputRMS)
      let inputDB = db.isFinite ? Int(max(-90, min(20, db)).rounded()) : -90
      outputStage.draw(accumulator: accumulator, into: drawable, commandBuffer: commandBuffer,
                       drawableSize: target.drawableSizePixels,
                       statusLine: "\(engine.audioStatus)   in \(inputDB) dB")
    }

    commandBuffer.commit()
    // Frame-scoped pooled leases are only valid for the frame that leased them
    // (`TexturePool.endFrame`'s own doc comment) — this is that once-per-frame call site.
    engine.context.pool.endFrame()

    if let lastFrameTimestamp {
      outputStage.recordFrameTime(now - lastFrameTimestamp)
    }
    lastFrameTimestamp = now
    frameCount &+= 1
  }

  deinit { driver?.invalidate() }
}
