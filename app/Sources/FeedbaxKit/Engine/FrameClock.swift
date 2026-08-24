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

  /// Starts the display link immediately, pinned to `rate` (one of `Engine.frameRatePresets`
  /// in normal use, but not validated here — same "the UI constrains the picker, this class
  /// doesn't" stance as `Engine.frameRate` itself). `minimum`/`maximum`/`preferred` are all set
  /// to the same value: this instrument has no adaptive-refresh use case (design checklist
  /// #14 — no idle drift, nothing that would benefit from a variable rate), it wants exactly
  /// `rate` ticks per second.
  public init(layer: CAMetalLayer, rate: Int, tick: @escaping (CAMetalDisplayLink.Update) -> Void) {
    self.link = CAMetalDisplayLink(metalLayer: layer)
    self.tick = tick
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

  public func metalDisplayLink(_ link: CAMetalDisplayLink, needsUpdate update: CAMetalDisplayLink.Update) {
    tick(update)
  }
}
