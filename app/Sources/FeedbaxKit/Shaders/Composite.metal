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

// Jitter `erase` with blending on = translucent quad over the old frame (spec §01 §2):
// rgb' = a·erase.rgb + (1−a)·prev.rgb ; a' = a·a + (1−a)·prev.a
kernel void fbx_erase(texture2d<float, access::read> prev [[texture(0)]],
                      texture2d<float, access::write> current [[texture(1)]],
                      constant float4& erase [[buffer(0)]],     // rgb + α in .w
                      uint2 gid [[thread_position_in_grid]]) {
  if (gid.x >= current.get_width() || gid.y >= current.get_height()) return;
  float4 p = prev.read(gid);
  float a = erase.w;
  current.write(float4(mix(p.rgb, erase.rgb, a), a * a + (1 - a) * p.a), gid);
}
