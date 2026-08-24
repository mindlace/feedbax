#include <metal_stdlib>
using namespace metal;

// GPU twin of ShaderMath/RotaFold.swift (rotaSource/fold/glslMod) + ShaderMath/HSL.swift
// (rgb2hsl/hsl2rgb/hslAdd), fused into one pass (spec §01 §4-5). The gen math is
// duplicated here deliberately: the CPU copy in ShaderMath is the testable spec, this
// file is the fast one, and WarpParityTests.swift is what keeps them the same.

struct WarpParams {
  float zoom; float theta; float2 offset; float2 anchor;
  float hueShift; float satDelta; float lightDelta;
};

// GLSL mod(): x − y·floor(x/y). Mirrors ShaderMath/RotaFold.swift's glslMod.
static float2 glsl_mod2(float2 x, float2 y) { return x - y * floor(x / y); }

// boundmode 4 — mirror-repeat with period 2·size. Mirrors ShaderMath/RotaFold.swift's fold.
static float2 fold2(float2 p, float2 size) {
  float2 wrapped = glsl_mod2(p, size);
  float2 phase = floor(glsl_mod2(p, size * 2.0) / size);
  return mix(wrapped, size - wrapped, phase);
}

// Transcribed line-for-line from ShaderMath/HSL.swift's rgb2hsl (same branch structure).
static float3 rgb2hsl(float3 c) {
  float maxc = max(c.x, max(c.y, c.z));
  float minc = min(c.x, min(c.y, c.z));
  float l = (maxc + minc) / 2.0;
  if (maxc == minc) return float3(0.0, 0.0, l);
  float d = maxc - minc;
  float s = l > 0.5 ? d / (2.0 - maxc - minc) : d / (maxc + minc);
  float h;
  if (maxc == c.x)      { h = (c.y - c.z) / d + (c.y < c.z ? 6.0 : 0.0); }
  else if (maxc == c.y) { h = (c.z - c.x) / d + 2.0; }
  else                  { h = (c.x - c.y) / d + 4.0; }
  return float3(h / 6.0, s, l);
}

// Transcribed line-for-line from ShaderMath/HSL.swift's hsl2rgb's nested hue2rgb
// (file-scoped static here since MSL has no nested functions; no cross-file collision
// per-file MTLLibrary compilation, see MetalContext.swift).
static float hue2rgb(float p, float q, float t0) {
  float t = t0;
  if (t < 0.0) { t += 1.0; }
  if (t > 1.0) { t -= 1.0; }
  if (t < 1.0 / 6.0) { return p + (q - p) * 6.0 * t; }
  if (t < 1.0 / 2.0) { return q; }
  if (t < 2.0 / 3.0) { return p + (q - p) * (2.0 / 3.0 - t) * 6.0; }
  return p;
}

// Transcribed line-for-line from ShaderMath/HSL.swift's hsl2rgb (same branch structure).
static float3 hsl2rgb(float3 hsl) {
  float h = hsl.x, s = hsl.y, l = hsl.z;
  if (s == 0.0) return float3(l, l, l);
  float q = l < 0.5 ? l * (1.0 + s) : l + s - l * s;
  float p = 2.0 * l - q;
  return float3(hue2rgb(p, q, h + 1.0 / 3.0), hue2rgb(p, q, h), hue2rgb(p, q, h - 1.0 / 3.0));
}

kernel void fbx_warp_hsl(texture2d<float, access::sample> prev [[texture(0)]],
                         texture2d<float, access::write> outTex [[texture(1)]],
                         constant WarpParams& p [[buffer(0)]],
                         uint2 gid [[thread_position_in_grid]]) {
  if (gid.x >= outTex.get_width() || gid.y >= outTex.get_height()) return;
  float2 size = float2(prev.get_width(), prev.get_height());
  float2 point = float2(gid) + 0.5;                    // fragment center, pixel-rect coords
  float c = cos(p.theta), s = sin(p.theta);
  float2 centered = point - p.anchor * size;
  float2 rotated = float2(centered.x * c + centered.y * s,
                          -centered.x * s + centered.y * c);
  float2 src = fold2(rotated / p.zoom + p.anchor * size + p.offset, size);

  // fst is @filter linear (spec §01 §1) — sample linearly at the folded coordinate.
  constexpr sampler smp(address::clamp_to_edge, filter::linear, coord::normalized);
  float4 color = prev.sample(smp, src / size);

  float3 hsl = rgb2hsl(color.rgb) + float3(p.hueShift, p.satDelta, p.lightDelta);
  hsl.x = fract(hsl.x);
  hsl.yz = clamp(hsl.yz, 0.0, 1.0);
  outTex.write(float4(hsl2rgb(hsl), color.a), gid);
}
