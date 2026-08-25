import QuartzCore
import Metal

/// Thin closure wrapper over `CAMetalDisplayLink` (macOS 14+ — the deployment floor
/// `Package.swift` pins specifically for this API, design §3). Everywhere else in this
/// codebase, tests drive `Engine.step` directly with an injected `time` and never touch this
/// class at all (`FrameClock` has no automated test of its own for exactly that reason — a
/// real `CAMetalLayer` needs a real window/screen, which CI doesn't have). This file is the
/// one place that boundary is crossed: turning "a new drawable is ready" into a call to
/// `Engine.step` is `PreviewView`'s job, not this class's — `FrameClock` only ever forwards
/// the display link's own `Update` to whatever closure the caller supplied.
public final class FrameClock: NSObject, CAMetalDisplayLinkDelegate {
  private let link: CAMetalDisplayLink
  private let tick: (CAMetalDisplayLink.Update) -> Void

  /// The rate this clock is CURRENTLY pinned to. `MetalHostView.renderFrame` compares
  /// `Engine.frameRate` against this every tick (final review, finding 3:
  /// `EngineViewModel.setFrameRate` only ever mutated `Engine.frameRate` itself — nothing told
  /// the already-running display link about the change, so a live preset switch silently did
  /// nothing until the next full relaunch) and calls `updateRate` the moment they diverge.
  public private(set) var rate: Int

  /// Starts the display link immediately, pinned to `rate` (one of `Engine.frameRatePresets`
  /// in normal use, but not validated here — same "the UI constrains the picker, this class
  /// doesn't" stance as `Engine.frameRate` itself). `minimum`/`maximum`/`preferred` are all set
  /// to the same value: this instrument has no adaptive-refresh use case (design checklist
  /// #14 — no idle drift, nothing that would benefit from a variable rate), it wants exactly
  /// `rate` ticks per second.
  public init(layer: CAMetalLayer, rate: Int, tick: @escaping (CAMetalDisplayLink.Update) -> Void) {
    self.link = CAMetalDisplayLink(metalLayer: layer)
    self.tick = tick
    self.rate = rate
    super.init()
    let fps = Float(rate)
    link.preferredFrameRateRange = CAFrameRateRange(minimum: fps, maximum: fps, preferred: fps)
    link.delegate = self
    link.add(to: .main, forMode: .common)
  }

  /// Stops the display link — callers must invoke this before releasing their last reference
  /// (e.g. `PreviewView` tearing down its `NSView`); `CAMetalDisplayLink` does not stop itself
  /// just because nothing external retains it, since the run loop it's attached to still holds
  /// it.
  public func invalidate() {
    link.invalidate()
  }

  /// Pure decision extracted so it's testable without a live `CAMetalDisplayLink`/window (this
  /// type's own doc comment: `FrameClock` needs a real `CAMetalLayer`, which CI doesn't have) —
  /// the one headless-testable piece of finding 3's fix. `MetalHostView.renderFrame` calls
  /// `updateRate` unconditionally every tick; this is the guard that makes that call a no-op
  /// on every frame where the rate hasn't actually changed.
  public static func shouldRetune(currentEngineRate: Int, builtRate: Int) -> Bool {
    currentEngineRate != builtRate
  }

  /// Retunes the already-running display link to `newRate` IN PLACE — no invalidate/rebuild of
  /// the underlying `CAMetalDisplayLink` needed. `preferredFrameRateRange` is a live, settable
  /// property (the same idiom `CADisplayLink` exposes) — changing it just changes how often
  /// `needsUpdate` fires from here on, which is all a live frame-rate-preset switch actually
  /// needs. Tearing down and re-adding a whole new link to the run loop would work too, but
  /// costs a real link teardown/re-attach for a change that is really just "pin this same link
  /// to a different cadence" — retune, not rebuild.
  public func updateRate(_ newRate: Int) {
    guard Self.shouldRetune(currentEngineRate: newRate, builtRate: rate) else { return }
    rate = newRate
    let fps = Float(newRate)
    link.preferredFrameRateRange = CAFrameRateRange(minimum: fps, maximum: fps, preferred: fps)
  }

  public func metalDisplayLink(_ link: CAMetalDisplayLink, needsUpdate update: CAMetalDisplayLink.Update) {
    tick(update)
  }
}
