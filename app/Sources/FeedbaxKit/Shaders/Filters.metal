#include <metal_stdlib>
using namespace metal;

// GPU twins of ShaderMath/Brcosa.swift and ShaderMath/Keyers.swift (spec §02 §7.2-7.4).
// Per-file MTLLibrary compilation (see MetalContext.swift) lets this file define its own
// file-scoped `rgb2hsv` helper without colliding with WarpHSL.metal's `rgb2hsl`/`hsl2rgb`.
// FilterTests.swift's parity tests are what keep this file and the CPU refs the same.

// ---- fbx_brcosa : GPU twin of ShaderMath/Brcosa.swift's `brcosa` ----

struct BrcosaParams { float brightness; float contrast; float saturation; };

// GLSL-form mix: a·(1−t) + b·t — ulp-exact to `b` at t=1, same reason as the CPU
// reference's `glslMix` (ShaderMath/Brcosa.swift): makes brightness/contrast/saturation
// 1/1/1 an exact identity. Metal's builtin `mix` uses the a+(b-a)·t form instead, so we
// keep this hand-written version to match the CPU ref's exact arithmetic.
static float3 glsl_mix3(float3 a, float3 b, float t) { return a * (1.0 - t) + b * t; }

kernel void fbx_brcosa(texture2d<float, access::read> inTex [[texture(0)]],
                       texture2d<float, access::write> outTex [[texture(1)]],
                       constant BrcosaParams& p [[buffer(0)]],
                       uint2 gid [[thread_position_in_grid]]) {
  if (gid.x >= outTex.get_width() || gid.y >= outTex.get_height()) return;
  float4 rgba = inTex.read(gid);
  float3 rgb = rgba.rgb;
  float l = dot(rgb, float3(0.2125, 0.7154, 0.0721));         // Rec.709 luma
  float3 sat = glsl_mix3(float3(l), rgb, p.saturation);
  float3 graded = glsl_mix3(float3(0.62), sat, p.contrast);    // extrapolates, never clamps
  float3 bright = graded * p.brightness;
  outTex.write(float4(bright, rgba.a), gid);                   // alpha passthrough from input
}

// ---- fbx_lumakey : GPU twin of ShaderMath/Keyers.swift's `lumaKey` (ONE pass) ----
// LumaKeyFilter.swift dispatches this kernel twice — high then low — through an
// intermediate lease, mirroring the CPU `lumaCascade`.

// Field order (luma, tol, fade, invert, binary, mode, lumcoeff) matches
// ShaderMath/Keyers.swift's `LumaKeyParams` exactly, so the Swift struct's memory
// layout can be passed straight into this buffer (see WarpParams for the same pattern).
struct LumaKeyGPUParams {
  float luma; float tol; float fade;
  float invert; float binary; float mode;
  float4 lumcoeff;
};

kernel void fbx_lumakey(texture2d<float, access::read> inTex [[texture(0)]],
                        texture2d<float, access::write> outTex [[texture(1)]],
                        constant float4& backdrop [[buffer(0)]],
                        constant LumaKeyGPUParams& p [[buffer(1)]],
                        uint2 gid [[thread_position_in_grid]]) {
  if (gid.x >= outTex.get_width() || gid.y >= outTex.get_height()) return;
  float4 a = inTex.read(gid);
  float luminance = dot(a, p.lumcoeff);
  float delta = abs(luminance - p.luma);
  float scale = smoothstep(abs(p.tol), abs(p.tol) + abs(p.fade), delta);
  float mixamount = mix(scale, 1.0 - scale, p.invert);
  float4 result = mix(backdrop, a, mixamount);
  float4 aOut = a; aOut.a = mixamount;
  result = mix(aOut, result, p.binary);
  result = mix(result, float4(mixamount), p.mode);
  outTex.write(result, gid);
}

// ---- fbx_chromakey : GPU twin of ShaderMath/Keyers.swift's `chromaKey` ----

struct ChromaKeyGPUParams { float3 color; float tol; float fade; };

// Transcribed line-for-line from ShaderMath/HSL.swift's `rgb2hsv` (same branch
// structure, including the glsl-mod hue wrap — NOT Metal's `fmod`, which differs in
// sign convention from GLSL's always-positive `mod`).
static float3 rgb2hsv(float3 c) {
  float maxc = max(c.x, max(c.y, c.z));
  float minc = min(c.x, min(c.y, c.z));
  float d = maxc - minc;
  float h = 0.0;
  if (d != 0.0) {
    if (maxc == c.x) {
      float t = (c.y - c.z) / d;
      h = t - 6.0 * floor(t / 6.0);           // glsl mod(t, 6)
    } else if (maxc == c.y) {
      h = (c.z - c.x) / d + 2.0;
    } else {
      h = (c.x - c.y) / d + 4.0;
    }
    h /= 6.0;
  }
  float s = (maxc == 0.0) ? 0.0 : d / maxc;
  return float3(h, s, maxc);
}

kernel void fbx_chromakey(texture2d<float, access::read> inTex [[texture(0)]],
                          texture2d<float, access::write> outTex [[texture(1)]],
                          constant float4& backdrop [[buffer(0)]],
                          constant ChromaKeyGPUParams& p [[buffer(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
  if (gid.x >= outTex.get_width() || gid.y >= outTex.get_height()) return;
  float4 a = inTex.read(gid);
  float3 w = float3(4.0, 1.0, 2.0);                            // hue counts 4×
  float len = length(w * (rgb2hsv(p.color) - rgb2hsv(a.rgb)));
  float scale = smoothstep(abs(p.tol), abs(p.tol) + abs(p.fade), len);
  outTex.write(mix(backdrop, a, scale), gid);
}
