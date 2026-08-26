import Foundation

/// Ports `filtergraph~` → `biquad~` (spec §03 §3): a single 2nd-order IIR band filter, one
/// per EQ chain (wave 1 @ 46.7 Hz, wave 2 @ 60.0 Hz, worldBump @ 144.3 Hz). Coefficients are
/// the RBJ Audio EQ Cookbook's "BPF (constant 0 dB peak gain)" form — chosen because
/// `filtergraph~`'s `setfilter` array carries a filter-*type* code the listing tool could not
/// resolve (spec §03 §12 q.3: "could be lowpass/highpass/bandpass/peaking"); a resonant
/// bandpass centered at the documented freq/Q, scaled by the documented `gain`, is the port's
/// documented choice for all three chains, since all three sit in the bass/sub-bass region and
/// the spec's own read is "a low-shelf/peaking/bandpass-ish resonant filter" (spec §03 §3).
/// PARITY-REVIEW: filtergraph~'s exact filter type is unresolved — this choice needs
/// eyeball/ear verification against captured footage/audio from the running Max patch
/// (design §9's human-eyeball pass) before being treated as final.
public struct Biquad {
  // Normalized direct-form-I coefficients (b's/a's already divided by a0) plus the output
  // gain multiply — kept separate from b0/b1/b2 because `gain` is `filtergraph~`'s *third*
  // saved parameter (spec §03 §10 "Wave-1 EQ freq/Q/gain"), not part of the RBJ formula.
  private let b0: Float
  private let b1: Float
  private let b2: Float
  private let a1: Float
  private let a2: Float
  private let gain: Float

  private var x1: Float = 0
  private var x2: Float = 0
  private var y1: Float = 0
  private var y2: Float = 0

  /// - Parameters:
  ///   - f: center frequency, Hz.
  ///   - q: RBJ Q (bandwidth control — `filtergraph~`'s saved "Q" value, spec §03 §10).
  ///   - gain: post-filter output multiply (`filtergraph~`'s saved "gain" value — NOT the RBJ
  ///     peaking-EQ dB-gain parameter; this filter type has constant 0 dB peak gain by
  ///     construction, so `gain` here is a separate linear scale applied after filtering).
  ///   - sampleRate: Hz.
  public init(bandpass f: Float, q: Float, gain: Float, sampleRate: Float) {
    let omega = 2 * Float.pi * f / sampleRate
    let alpha = sin(omega) / (2 * q)
    let cosOmega = cos(omega)
    let a0 = 1 + alpha
    self.b0 = alpha / a0
    self.b1 = 0
    self.b2 = -alpha / a0
    self.a1 = (-2 * cosOmega) / a0
    self.a2 = (1 - alpha) / a0
    self.gain = gain
  }

  /// One sample through the filter (direct form I), then the output `gain` multiply.
  public mutating func process(_ x: Float) -> Float {
    let y = b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2
    x2 = x1
    x1 = x
    y2 = y1
    y1 = y
    return y * gain
  }

  /// Convenience for offline/test use — processes a whole buffer in order, mutating state
  /// the same as calling `process(_:)` in a loop.
  public mutating func process(buffer: [Float]) -> [Float] {
    buffer.map { process($0) }
  }
}
