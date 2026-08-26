import simd

/// GLSL-form mix: a·(1−t) + b·t. At t=1 this is EXACTLY b in IEEE arithmetic
/// (a·0 + b·1 = b for non-negative color values), which is what makes brcosa at
/// defaults 1/1/1 an exact identity — the fact the design's output-brcosa
/// ruling rests on. simd_mix's a + (b−a)·t form is NOT ulp-exact at t=1.
@inline(__always)
private func glslMix(_ a: SIMD3<Float>, _ b: SIMD3<Float>, _ t: Float) -> SIMD3<Float> {
  a * (1 - t) + b * t
}

/// brcosa.genjit, rendered exactly (spec §01 §4):
///   sat:      mix(luma, rgb, saturation), Rec.709 weights
///   contrast: mix(0.62-gray, ·, contrast) — extrapolates, never clamps
///   bright:   plain multiply
///   alpha:    passthrough from the ORIGINAL input
public func brcosa(_ rgba: SIMD4<Float>, brightness: Float, contrast: Float, saturation: Float) -> SIMD4<Float> {
  let rgb = SIMD3(rgba.x, rgba.y, rgba.z)
  let l = simd_dot(rgb, SIMD3(0.2125, 0.7154, 0.0721))
  let sat = glslMix(SIMD3(repeating: l), rgb, saturation)
  let graded = glslMix(SIMD3(repeating: 0.62), sat, contrast)
  let bright = graded * brightness
  return SIMD4(bright.x, bright.y, bright.z, rgba.w)
}
