import simd

/// Standard HSL/HSV conversions, hue in [0,1). These mirror the Jitter gen operators
/// rgb2hsl/hsl2rgb used by the shaderfx HSL pix (spec §01 §4-5): the shift is ADDITIVE
/// in HSL space and hue wraps mod 1. S and L are deliberately NOT clamped — Jitter's own
/// `cc.hsl2rgb.jxs` converts the raw values and the char texture then clips each RGB
/// channel, and above S = 1 that pair is the saturation fader's per-pixel gain
/// (docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md, term 2).
public func rgb2hsl(_ c: SIMD3<Float>) -> SIMD3<Float> {
  let maxc = max(c.x, max(c.y, c.z)), minc = min(c.x, min(c.y, c.z))
  let l = (maxc + minc) / 2
  guard maxc != minc else { return SIMD3(0, 0, l) }
  let d = maxc - minc
  let s = l > 0.5 ? d / (2 - maxc - minc) : d / (maxc + minc)
  var h: Float
  if maxc == c.x      { h = (c.y - c.z) / d + (c.y < c.z ? 6 : 0) }
  else if maxc == c.y { h = (c.z - c.x) / d + 2 }
  else                { h = (c.x - c.y) / d + 4 }
  return SIMD3(h / 6, s, l)
}

public func hsl2rgb(_ hsl: SIMD3<Float>) -> SIMD3<Float> {
  let (h, s, l) = (hsl.x, hsl.y, hsl.z)
  guard s != 0 else { return SIMD3(repeating: l) }
  func hue2rgb(_ p: Float, _ q: Float, _ t0: Float) -> Float {
    var t = t0
    if t < 0 { t += 1 }; if t > 1 { t -= 1 }
    if t < 1 / 6 { return p + (q - p) * 6 * t }
    if t < 1 / 2 { return q }
    if t < 2 / 3 { return p + (q - p) * (2 / 3 - t) * 6 }
    return p
  }
  let q = l < 0.5 ? l * (1 + s) : l + s - l * s
  let p = 2 * l - q
  return SIMD3(hue2rgb(p, q, h + 1 / 3), hue2rgb(p, q, h), hue2rgb(p, q, h - 1 / 3))
}

public func rgb2hsv(_ c: SIMD3<Float>) -> SIMD3<Float> {
  let maxc = max(c.x, max(c.y, c.z)), minc = min(c.x, min(c.y, c.z))
  let d = maxc - minc
  var h: Float = 0
  if d != 0 {
    if maxc == c.x      { h = glslMod(SIMD2((c.y - c.z) / d, 0), SIMD2(6, 1)).x }
    else if maxc == c.y { h = (c.z - c.x) / d + 2 }
    else                { h = (c.x - c.y) / d + 4 }
    h /= 6
  }
  let s = maxc == 0 ? 0 : d / maxc
  return SIMD3(h, s, maxc)
}

public func hslAdd(_ rgb: SIMD3<Float>, hueShift: Float, satDelta: Float, lightDelta: Float) -> SIMD3<Float> {
  var hsl = rgb2hsl(rgb) + SIMD3(hueShift, satDelta, lightDelta)
  hsl.x = hsl.x - floor(hsl.x)                      // hue wraps; S and L pass through
  return simd_clamp(hsl2rgb(hsl), SIMD3(repeating: 0), SIMD3(repeating: 1))   // char-texture clip
}
