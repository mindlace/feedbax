import Foundation

/// Max's `scale lo hi lo2 hi2 exp` object in **classic mode**, which is the object's DEFAULT.
///
/// `scale` has a `classic` attribute; instantiated bare — as every `scale` in the Feedbax
/// patch is — it comes up `classic = 1`. That was confirmed empirically in Max 9.1.5 by
/// reading the attribute off a live object (`js` + `getattr`), not inferred from the docs.
/// The behaviour below was then measured directly: 62 points across 11 configurations,
/// printed through `sprintf v%.12f`, all reproduced by this formula to 5e-12 relative.
/// The constants in `MaxScaleTests` are those measurements. They are *observations*, not
/// derivations — do not "correct" them toward a formula that looks tidier.
///
/// Classic mode has two branches, and neither is the textbook exponential interpolation:
///
///   * **exp <= 1 — the exponent is ignored entirely.** Not applied as a gentle curve;
///     dropped. The result is the plain linear map `lo2 + (hi2-lo2)·(x-lo)/(hi-lo)`. The
///     patch's `exp 0.1` / `exp 0.05` HSL mappings are therefore straight lines.
///   * **exp > 1 — `lo2 + (hi2-lo2)·pow(exp, x - hi)`.** The base is the exponent and the
///     term uses the **raw, un-normalised** input: `x - hi`, not `(x-lo)/(hi-lo)`. Over a
///     0...100 domain that is `pow(exp, x-100)`, which is a wholly different curve from the
///     normalised one. This is the single most surprising property of classic mode and the
///     one that pins the formula (see `testExponentTermUsesRawUnNormalisedInput`).
///
/// On top of the curved branch sits an exact-equality special case: when `lo <= 0` and the
/// input is *exactly* `lo`, the result is `lo2`. The curve is genuinely **discontinuous**
/// there — `scale 0 1 0.8 1 3` returns 0.8 at x=0 but 0.8667 at x=1e-6. Do not smooth it.
///
/// **Known gap:** the `lo > 0` case is not implemented. It was fitted from only two measured
/// ranges and behaves strangely there (it appears to return `hi2` at `x == lo`), and no
/// Feedbax call site has `lo > 0` — every one uses `lo` of 0 or -1. Rather than ship a
/// guess, `lo > 0` simply falls through to the curved branch. If a call site with `lo > 0`
/// ever appears, go measure it in Max before trusting the number this returns.
///
/// No clamping: Max extrapolates out-of-range input along the same curve, and so do we.
///
/// **What this is NOT:** Max also has a modern mode (`@classic 0`), whose formula is the
/// familiar `lo2 + (hi2-lo2)·((x-lo)/(hi-lo))^exp` — normalise, then raise. That is what the
/// Max documentation describes, what spec §01 §2 derived, and what this function used to
/// implement. It is wrong for a default-instantiated `scale`: on the HSL mappings it
/// produced deltas 2-73x too large, driving the instrument to white in under a second.
/// Mode selection is not exposed here because the patch never sets `@classic 0`.
///
/// Evaluated in `Double` internally so the returned `Float` carries only its own rounding
/// error — `pow` on a curved branch loses more than the tolerances above allow otherwise.
public func maxScale(_ x: Float, _ lo: Float, _ hi: Float,
                     _ lo2: Float, _ hi2: Float, exp e: Float = 1) -> Float {
  let x = Double(x), lo = Double(lo), hi = Double(hi)
  let lo2 = Double(lo2), hi2 = Double(hi2), e = Double(e)
  if e <= 1 {                       // exponent ignored — plain linear map
    return Float(lo2 + (hi2 - lo2) * (x - lo) / (hi - lo))
  }
  if lo <= 0 && x == lo {           // exact-equality special case; the curve jumps here
    return Float(lo2)
  }
  return Float(lo2 + (hi2 - lo2) * pow(e, x - hi))   // raw input, deliberately un-normalised
}
