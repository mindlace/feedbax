import Foundation

/// Max's `scale lo hi lo2 hi2 exp` object. Derivation from spec §01 §2:
/// f = (in−lo)/(hi−lo); out = lo2 + (hi2−lo2)·f^exp. Max does NOT clip out-of-domain
/// input (spec §01 §4 note). For f < 0 with a fractional exponent, plain pow is NaN;
/// we extend as sign(f)·|f|^exp — a documented choice, flagged for parity review
/// (spec §01 open question 6 — the sat slot's 0..1 domain vs −1..1 siblings).
public func maxScale(_ x: Float, _ lo: Float, _ hi: Float,
                     _ lo2: Float, _ hi2: Float, exp e: Float = 1) -> Float {
  let f = (x - lo) / (hi - lo)
  let curved = e == 1 ? f : (f < 0 ? -pow(-f, e) : pow(f, e))
  return lo2 + (hi2 - lo2) * curved
}
