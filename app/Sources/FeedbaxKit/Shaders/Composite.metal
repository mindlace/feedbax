#include <metal_stdlib>
using namespace metal;

// Shared textured/solid fullscreen-quad pair — the vertex/fragment functions QuadRenderer
// (Engine/FeedbackCore.swift) builds pipelines from. Reused by the feedback plane here,
// the accumulator→drawable blit (Task 20), and layer/waveform draws (Tasks 9/18): one
// small vertex shader, transform + tint uniforms, no attribute-buffer bookkeeping per caller.

struct QuadVertexOut { float4 pos [[position]]; float2 uv; };
struct QuadUniforms { float4x4 transform; float4 tint; };

// Unit quad from a vertex-id triangle strip: (-1,-1),(1,-1),(-1,1),(1,1)
vertex QuadVertexOut fbx_quad_v(uint vid [[vertex_id]],
                                constant QuadUniforms& u [[buffer(0)]]) {
  float2 corners[4] = { {-1,-1}, {1,-1}, {-1,1}, {1,1} };
  QuadVertexOut out;
  out.pos = u.transform * float4(corners[vid], 0, 1);
  out.uv = corners[vid] * float2(0.5, -0.5) + 0.5;   // flip V: texture row 0 is top
  return out;
}

fragment float4 fbx_quad_f(QuadVertexOut in [[stage_in]],
                           texture2d<float> tex [[texture(0)]],
                           constant QuadUniforms& u [[buffer(0)]]) {
  constexpr sampler smp(address::clamp_to_edge, filter::linear);
  return tex.sample(smp, in.uv) * u.tint;
}

fragment float4 fbx_solid_f(QuadVertexOut in [[stage_in]],
                            constant QuadUniforms& u [[buffer(0)]]) { return u.tint; }

// Waveform overlay draws (Engine/WaveformRenderer.swift): wave 1's bottom line and wave 2's
// ring, both as screen-space ribbons sharing one vertex function, one uniforms struct, and
// one flat-colour fragment function (neither samples a texture). Ribbon expansion happens in
// clip space: each vertex carries `normal·halfWidthNDC`, computed by WaveformRenderer from
// `lineWidthPx / canvasHeight` (aspect-agnostic — exact vertically, mildly stretched
// horizontally on a non-square canvas). Multiplying the offset by `clip.w` before adding it
// to `clip.xy` keeps it at its intended NDC size after the perspective divide regardless of
// the vertex's depth — the standard "screen-space line width" trick.
struct WaveVertexOut { float4 pos [[position]]; };
struct WaveUniforms { float4x4 projection; float z; float4 color; };

// Mirrors WaveformRenderer.swift's `RibbonVertex` field-for-field (see QuadUniforms above
// for why this matters: identical byte layout is what lets `setVertexBuffer` hand the GPU
// exactly what Swift wrote).
struct RibbonVertex { float2 point; float2 normal; float halfWidthNDC; };

// Both waveforms: a polyline drawn as a screen-space ribbon. `v.point` is the sample already
// in the waveform's local xy-plane (see WaveformRenderer.wave1LinePoints / wave2RingPolyline);
// `u.z` places the whole ribbon at the style's fixed depth (0 for wave 1, −2 for wave 2).
vertex WaveVertexOut fbx_ribbon_v(uint vid [[vertex_id]],
                                  constant RibbonVertex* verts [[buffer(0)]],
                                  constant WaveUniforms& u [[buffer(1)]]) {
  RibbonVertex v = verts[vid];
  float4 clip = u.projection * float4(v.point, u.z, 1.0);
  clip.xy += v.normal * v.halfWidthNDC * clip.w;
  WaveVertexOut out;
  out.pos = clip;
  return out;
}

// Shared by both waveform pipelines — flat parity colour, no texture.
fragment float4 fbx_point_f(WaveVertexOut in [[stage_in]],
                            constant WaveUniforms& u [[buffer(1)]]) {
  return u.color;
}

// Erase is a hard clear of the back-buffer's render pass to (erase_color, erase_alpha) —
// see FeedbackCore.renderFrame's step 1 — matching `jit.gl.node`'s FBO clear
// (docs/diagnosis-2026-08-23.md, "Trail-fade parity"). The erase alpha only sets the
// destination alpha of undrawn pixels; no shader kernel is needed for it, so there is no
// `fbx_erase` here (the old gl2-parity soft-mix kernel this file used to define).
