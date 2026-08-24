import simd

public func smoothstepf(_ e0: Float, _ e1: Float, _ x: Float) -> Float {
  let t = min(max((x - e0) / (e1 - e0), 0), 1)
  return t * t * (3 - 2 * t)
}

/// co.lumakey.jxs (spec §02 §8, GLSL quoted verbatim there). Parity uses
/// binary=1 (composited result), invert=0, mode=0 — the vz.lumakeyr configuration.
/// NOTE lumcoeff is a vec4 with alpha weight 0 and Rec.601 RGB weights — different
/// from brcosa's Rec.709. That inconsistency is the original's; keep it.
public struct LumaKeyParams {
  public var luma, tol, fade: Float
  public var invert: Float = 0
  public var binary: Float = 1
  public var mode: Float = 0
  public var lumcoeff = SIMD4<Float>(0.299, 0.587, 0.114, 0)
  public init(luma: Float, tol: Float, fade: Float) { self.luma = luma; self.tol = tol; self.fade = fade }
}

public func lumaKey(_ a: SIMD4<Float>, backdrop b: SIMD4<Float>, _ p: LumaKeyParams) -> SIMD4<Float> {
  let luminance = simd_dot(a, p.lumcoeff)
  let delta = abs(luminance - p.luma)
  let scale = smoothstepf(abs(p.tol), abs(p.tol) + abs(p.fade), delta)
  let mixamount = simd_mix(scale, 1 - scale, p.invert)
  var result = simd_mix(b, a, SIMD4(repeating: mixamount))
  var aOut = a
  aOut.w = mixamount
  result = simd_mix(aOut, result, SIMD4(repeating: p.binary))
  return simd_mix(result, SIMD4(repeating: mixamount), SIMD4(repeating: p.mode))
}

/// The parity luma path is a deliberate two-stage cascade — "keep only midrange
/// luminance" (spec §02 §7.3): pass 1 keys near-white, pass 2 keys near-black.
public func lumaCascade(_ a: SIMD4<Float>, backdrop b: SIMD4<Float>,
                        high: LumaKeyParams, low: LumaKeyParams) -> SIMD4<Float> {
  lumaKey(lumaKey(a, backdrop: b, high), backdrop: b, low)
}

/// co.chromakey.hsv.jxs (spec §02 §8): weighted HSV distance, hue counts 4×.
/// Only color.rgb is read — the key color's alpha is irrelevant to the math.
public func chromaKey(_ a: SIMD4<Float>, backdrop b: SIMD4<Float>,
                      color: SIMD3<Float>, tol: Float, fade: Float) -> SIMD4<Float> {
  let w = SIMD3<Float>(4, 1, 2)
  let len = simd_length(w * (rgb2hsv(color) - rgb2hsv(SIMD3(a.x, a.y, a.z))))
  let scale = smoothstepf(abs(tol), abs(tol) + abs(fade), len)
  return simd_mix(b, a, SIMD4(repeating: scale))
}
