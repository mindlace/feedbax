import Foundation
import Dispatch
import QuartzCore
import Metal

/// One frame's worth of "go" from a driver. `drawable` is non-nil only when the driver is
/// bound to a live output window (`DisplayLinkDriver`) — the windowless `TimerDriver` still
/// steps the engine every tick, it just has nothing to present into. That nil is the whole
/// reason the feedback accumulator keeps evolving with no window open (spec goal 2).
public struct FrameTick {
  public let drawable: CAMetalDrawable?
  public init(drawable: CAMetalDrawable?) { self.drawable = drawable }
}

/// What `EngineHost` pulls frames from. Two implementations, swapped on window attach/detach:
/// `DisplayLinkDriver` (vsync-locked to the output window's display) and `TimerDriver` (a
/// plain repeating timer, used when there is no window at all). `CAMetalDisplayLink` cannot
/// exist without a `CAMetalLayer`, which is exactly why the second implementation is needed.
public protocol FrameDriver: AnyObject {
  /// The rate this driver is currently pinned to — compared against `Engine.frameRate` every
  /// tick so a live frame-rate-preset switch retunes the running driver (the existing
  /// `FrameClock.shouldRetune` contract, preserved).
  var rate: Int { get }
  func updateRate(_ newRate: Int)
  /// Callers MUST invoke this before dropping their last reference: neither a run-loop-
  /// attached `CAMetalDisplayLink` nor a resumed `DispatchSourceTimer` stops merely because
  /// nothing external retains it.
  func invalidate()
}

/// The windowless clock. Delivers on the main queue, unconditionally — no `queue` parameter to
/// pick another, because `Engine.step` and `ControlRouter.tick` are main-thread-only by
/// convention throughout this codebase and every driver must tick on main.
public final class TimerDriver: FrameDriver {
  public private(set) var rate: Int
  private let tick: (FrameTick) -> Void
  private var timer: DispatchSourceTimer?

  public init(rate: Int, tick: @escaping (FrameTick) -> Void) {
    // A zero or negative rate would make the repeat interval infinite (or negative) and the
    // engine would silently stop evolving — the exact failure this driver exists to prevent.
    self.rate = max(rate, 1)
    self.tick = tick
    schedule()
  }

  private func schedule() {
    timer?.cancel()
    let interval = 1.0 / Double(rate)
    let source = DispatchSource.makeTimerSource(queue: .main)
    // Leeway is a power hint, not slop we care about: nothing downstream reads wall-clock
    // deltas from this driver (`EngineHost` stamps its own `CACurrentMediaTime`).
    source.schedule(deadline: .now() + interval, repeating: interval, leeway: .milliseconds(1))
    source.setEventHandler { [weak self] in
      self?.tick(FrameTick(drawable: nil))
    }
    source.resume()
    timer = source
  }

  /// Same guard `FrameClock.updateRate` uses, so both drivers no-op identically on the
  /// overwhelming majority of frames where the rate has not changed.
  public func updateRate(_ newRate: Int) {
    let clamped = max(newRate, 1)
    guard FrameClock.shouldRetune(currentEngineRate: clamped, builtRate: rate) else { return }
    rate = clamped
    schedule()   // a timer source's interval is not settable in place — reschedule
  }

  public func invalidate() {
    timer?.cancel()
    timer = nil
  }

  deinit { timer?.cancel() }
}

/// The windowed clock — a thin `FrameDriver` face on the existing `FrameClock`, which already
/// wraps `CAMetalDisplayLink` and already retunes in place. All this adds is the `FrameTick`
/// shape, so `EngineHost` never has to know which kind of clock it is holding.
public final class DisplayLinkDriver: FrameDriver {
  private let clock: FrameClock
  public var rate: Int { clock.rate }

  public init(layer: CAMetalLayer, rate: Int, tick: @escaping (FrameTick) -> Void) {
    clock = FrameClock(layer: layer, rate: rate) { update in
      tick(FrameTick(drawable: update.drawable))
    }
  }

  public func updateRate(_ newRate: Int) { clock.updateRate(newRate) }
  public func invalidate() { clock.invalidate() }
}
