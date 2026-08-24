import simd

/// GLSL mod(): x − y·floor(x/y). Result is always in [0, y) — Swift's
/// truncatingRemainder is NOT this for negative x.
public func glslMod(_ x: SIMD2<Float>, _ y: SIMD2<Float>) -> SIMD2<Float> {
  x - y * floor(x / y)
}

/// boundmode 4 — mirror-repeat with period 2·size (td.rota.jxs, spec §01 §4).
/// "The single most important visual mechanism in the feedback loop."
public func fold(_ p: SIMD2<Float>, size: SIMD2<Float>) -> SIMD2<Float> {
  let wrapped = glslMod(p, size)
  let phase = floor(glslMod(p, size * 2) / size)  // 0 = forward half-period, 1 = reflected
  return simd_mix(wrapped, size - wrapped, phase)
}

/// td.rota.jxs inverse warp (spec §01 §4, GLSL quoted verbatim there):
///   no = ((point − anchor·size) · rot) · sca + anchor·size + offset,  then fold.
/// Row-vector × column-major mat2(c, s, −s, c), scale = 1/zoom. Negative zoom
/// mirrors both axes (the SInvert kaleidoscope). Pixel-rect coords, not UV.
public func rotaSource(point: SIMD2<Float>, size: SIMD2<Float>,
                       zoom: Float, theta: Float,
                       offset: SIMD2<Float>, anchor: SIMD2<Float>) -> SIMD2<Float> {
  let c = cos(theta), s = sin(theta)
  let centered = point - anchor * size
  let rotated = SIMD2(centered.x * c + centered.y * s,
                      -centered.x * s + centered.y * c)
  let scaled = rotated / zoom
  return fold(scaled + anchor * size + offset, size: size)
}
