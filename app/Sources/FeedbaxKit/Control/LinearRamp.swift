import Foundation

/// The port's `mIniCtlSmooth` (spec §01 §0): a linear ramp from wherever the value is right
/// now to a new target, over `smoothMs` (the `controlSmoothMs` bus, default 100 ms), stepped
/// every `grainMs` (the `line` object's grain argument, fed from `lineSmoothGrain`, default
/// 4 ms — spec §04 §5. `grainMs` is the ramp's *step resolution*; `smoothMs` is its *total
/// duration* — the two are independent knobs in the original and stay independent here.
public struct LinearRamp {
  private let smoothMs: Double
  private let grainMs: Double
  private var startValue: Float
  private var targetValue: Float
  private var startTime: TimeInterval

  /// Seeds the ramp already-settled at `initial`, with no special-cased "first read." The
  /// original's `mIniCtlSmooth` produces no ramp output at all until a target has actually
  /// been unpacked (spec §01 §4's cold-start note) — treating construction as "arrived" gets
  /// the same effect: `value(at:)` returns `initial` for any real timestamp, and the first
  /// real `setTarget` starts a normal ramp from it.
  public init(initial: Float, smoothMs: Double = 100, grainMs: Double = 4) {
    self.smoothMs = smoothMs
    self.grainMs = grainMs
    self.startValue = initial
    self.targetValue = initial
    self.startTime = -.infinity
  }

  /// Retargets from the value the ramp is AT right now — not from its old target, and not a
  /// hard snap. This is what makes a performer wiggling a control glide continuously instead
  /// of jumping: each new target starts a fresh 100 ms ramp from the current interpolated
  /// position, matching `line`'s live-retarget behavior.
  public mutating func setTarget(_ value: Float, at time: TimeInterval) {
    startValue = self.value(at: time)
    targetValue = value
    startTime = time
  }

  /// The current interpolated value, quantized to `grainMs` steps (`line`'s ramp only
  /// actually recomputes every grain — two reads inside the same grain window return the
  /// same value, spec §04 §5).
  public func value(at time: TimeInterval) -> Float {
    guard smoothMs > 0 else { return targetValue }
    let elapsedMs = (time - startTime) * 1000
    if elapsedMs <= 0 { return startValue }
    if elapsedMs >= smoothMs { return targetValue }
    let quantizedMs = (elapsedMs / grainMs).rounded(.down) * grainMs
    let f = Float(quantizedMs / smoothMs)
    return startValue + (targetValue - startValue) * f
  }
}
