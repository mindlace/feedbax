# Dynamism Gap Fixes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the Swift/Metal port's feedback loop behave like the running Max patch — long memory, fine detail, saturation-driven vividness, the real waveform seeds, and a visible microphone status — by fixing the two loop-body terms and the waveform geometry the diagnosis identified.

**Architecture:** The loop is `x' = clip(HSL(R(x)) + D)` per pixel. Two terms differ from Jitter: the resample `R` must read the nearest texel (not bilinear) so thin lines survive ~250 generations, and `HSL` must not clamp S/L before `hsl2rgb` (Jitter's `cc.hsl2rgb.jxs` doesn't; the char texture clips RGB afterwards). The seeds `D` are wrong way round: waveform 1 is a 12-px straight line at the bottom edge (bass-gated), waveform 2 is the always-on cyan ring of radius 0.7. Each change is one small, independently testable unit.

**Tech Stack:** Swift 5 / SwiftPM package at `app/`, Metal shading language, XCTest. Build/test needs Xcode's toolchain.

**Spec:** `docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md` (read it first — every task below cites its sections).

## Global Constraints

- Work in this worktree only: `/Users/mindlace/Projects/feedbax/.claude/worktrees/reimplementation-proposal` (branch `worktree-reimplementation-proposal`). Run every command from that directory. Never compound `cd ... && cmd`.
- Every `swift build` / `swift test` MUST be prefixed `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer` (the CommandLineTools toolchain has no XCTest/Metal).
- Test invocation pattern: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter <TestClass>`.
- `GoldenFrameTests` FAILS BY DESIGN on this branch (`Tests/FeedbaxKitTests/GoldenReferences/` is deliberately empty — see that file's header). Run the full suite as `... swift test --package-path app --skip GoldenFrameTests` and never touch the golden references in this plan.
- Commits: Conventional Commits, `git commit -m "<subject>" -m "<body>"` (never heredocs), and end the body with the two trailer lines `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>` and `Claude-Session: https://claude.ai/code/session_017i8dhZYNK8i8tpri3zRBS4` (each as its own `-m`).
- Parity values are the diagnosis's measured/refpage values: nearest sampling default ON; no S/L clamp; wave 1 = linear, 12 px, `scale (1.5,1,0)`, `position (0,−0.85,0)`, colour `(0.392375, 0.23808, 0, 0.8)`, alpha-over; wave 2 = radial, radius 0.7, 4 px, 1024 points, colour `(0, 0.786722, 0.821229)`, base alpha 0.8, blend (SRC_ALPHA, DST_ALPHA), z = −2, enabled at load; wave-2 input gain −0.5 with 512-sample group averaging; worldBump multiplier stays 0.05.
- Do not "fix" a test by weakening an assertion. If a test fails for a reason a task did not predict, stop and report the exact failure.

---

### Task 0: Commit the diagnosis document and this plan

**Files:**
- Add: `docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md` (already written, untracked)
- Add: `docs/superpowers/plans/2026-08-24-dynamism-gap-fixes.md` (this file)

- [ ] **Step 1: Verify the worktree is otherwise clean**

Run: `git status --porcelain`
Expected: only the two `docs/superpowers/...` paths listed as `??`.

- [ ] **Step 2: Commit**

```bash
git add docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md docs/superpowers/plans/2026-08-24-dynamism-gap-fixes.md
git commit -m "docs: dynamism-gap root-cause map and fix plan" -m "Loop-map diagnosis of why the port is dark/static where Max is full/vivid: bilinear resampling and an S/L clamp the Jitter chain does not have, plus swapped waveform geometry. Plan covers the fixes." -m "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>" -m "Claude-Session: https://claude.ai/code/session_017i8dhZYNK8i8tpri3zRBS4"
```

---

### Task 1: Nearest-texel feedback sampling (default), with a linear option

**Files:**
- Modify: `app/Sources/FeedbaxKit/Shaders/WarpHSL.metal` (struct `WarpParams` lines 9-12; kernel `fbx_warp_hsl` lines 60-82)
- Modify: `app/Sources/FeedbaxKit/Engine/WarpPass.swift` (struct `WarpParams` lines 9-19)
- Modify: `app/Sources/FeedbaxKit/Engine/FeedbackCore.swift` (`RenderParams` lines 6-31)
- Modify: `app/Sources/FeedbaxKit/Engine/Engine.swift` (property block near line 74; `step` near line 199)
- Modify: `app/Sources/FeedbaxKit/UI/EngineViewModel.swift` (frame-rate block lines ~249-260)
- Modify: `app/Sources/FeedbaxKit/UI/OperatorPanel.swift` (Venue section, after the Frame Rate picker)
- Test: `app/Tests/FeedbaxKitTests/WarpParityTests.swift`, `app/Tests/FeedbaxKitTests/FeedbackCoreTests.swift`, `app/Tests/FeedbaxKitTests/EngineViewModelTests.swift`

**Interfaces:**
- Produces: `public enum WarpFilter: String, Codable, CaseIterable { case nearest, linear }` (in `WarpPass.swift`); `WarpParams.nearest: UInt32` and `WarpParams.init(... lightDelta:, nearest: Bool = true)`; `RenderParams.warpFilter: WarpFilter` (default `.nearest`); `Engine.warpFilter: WarpFilter` (default `.nearest`); `EngineViewModel.warpFilter` + `setWarpFilter(_:)`.
- Consumes: nothing new.

- [ ] **Step 1: Write the failing parity test (CPU nearest reference vs GPU)**

In `app/Tests/FeedbaxKitTests/WarpParityTests.swift`, add after `bilinearSample`:

```swift
/// CPU nearest-texel read matching the kernel's `prev.read(uint2(floor(src)))` path
/// (WarpHSL.metal): texel (floor x, floor y), clamped to the texture.
func nearestSample(_ px: [SIMD4<Float>], size: SIMD2<Int>, at coord: SIMD2<Float>) -> SIMD4<Float> {
  let x = min(max(Int(floor(coord.x)), 0), size.x - 1)
  let y = min(max(Int(floor(coord.y)), 0), size.y - 1)
  return px[y * size.x + x]
}
```

Replace the `cases` array and the `sampled` line inside `testWarpHSLMatchesCPUReference` with:

```swift
    let geometry: [(zoom: Float, theta: Float, offset: SIMD2<Float>, hue: Float, sat: Float, light: Float)] = [
      (1, 0, .zero, 0, 0, 0),
      (0.8, 0.3, SIMD2(3, -2), 0.02, 0.01, -0.01),
      (-1.1, -2.5, SIMD2(-40, 25), 0.4, 0.3, 0.2),
    ]
    var cases: [WarpParams] = []
    for g in geometry {
      for nearest in [false, true] {
        cases.append(.init(zoom: g.zoom, theta: g.theta, offset: g.offset, hueShift: g.hue,
                           satDelta: g.sat, lightDelta: g.light, nearest: nearest))
      }
    }
```

and

```swift
        let sampled = params.nearest != 0
          ? nearestSample(pixels, size: size, at: src)
          : bilinearSample(pixels, size: size, at: src)
```

Update the two assertion messages to include the filter: `"px \(x),\(y) nearest=\(params.nearest)"`.

- [ ] **Step 2: Run it to verify it fails**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter WarpParityTests`
Expected: compile error — `extra argument 'nearest' in call` / `WarpParams has no member 'nearest'`.

- [ ] **Step 3: Add the field to the Swift and Metal structs**

`app/Sources/FeedbaxKit/Engine/WarpPass.swift` — replace the `WarpParams` struct with:

```swift
/// Which texel read the warp uses for the previous frame (diagnosis doc, term 1).
/// `.nearest` is the parity default: a shrunk 1-px line keeps its full value generation
/// after generation instead of being averaged into its black neighbours, which is what
/// gives the original its ~250-frame memory and pixel-scale mesh. `.linear` is kept for A/B
/// comparison only.
public enum WarpFilter: String, Codable, CaseIterable {
  case nearest, linear
}

/// GPU-side twin of ShaderMath's rotaSource/fold + hslAdd parameters. Field order
/// matches Shaders/WarpHSL.metal's `WarpParams` exactly — zoom, theta, offset, anchor,
/// hueShift, satDelta, lightDelta, nearest — so `MemoryLayout<WarpParams>.stride` (40
/// bytes) lines up with the Metal struct's byte layout (float2 needs 8-byte alignment;
/// this order avoids any padding mismatch between the two compilers' layout rules).
public struct WarpParams {
  public var zoom, theta: Float
  public var offset: SIMD2<Float>
  public var anchor = SIMD2<Float>(0.5, 0.5)   // static in this build (spec §01 §4)
  public var hueShift, satDelta, lightDelta: Float
  /// 1 = nearest-texel read, 0 = bilinear sample. A `UInt32` rather than `Bool` so the
  /// byte layout matches the Metal `uint`.
  public var nearest: UInt32
  public init(zoom: Float, theta: Float, offset: SIMD2<Float>,
              hueShift: Float, satDelta: Float, lightDelta: Float, nearest: Bool = true) {
    self.zoom = zoom; self.theta = theta; self.offset = offset
    self.hueShift = hueShift; self.satDelta = satDelta; self.lightDelta = lightDelta
    self.nearest = nearest ? 1 : 0
  }
}
```

`app/Sources/FeedbaxKit/Shaders/WarpHSL.metal` — replace the `WarpParams` struct with:

```metal
struct WarpParams {
  float zoom; float theta; float2 offset; float2 anchor;
  float hueShift; float satDelta; float lightDelta;
  uint nearest;   // 1 = nearest-texel read (parity: Sean's `fst @filter none`), 0 = bilinear
};
```

and replace the two lines

```metal
  // fst is @filter linear (spec §01 §1) — sample linearly at the folded coordinate.
  constexpr sampler smp(address::clamp_to_edge, filter::linear, coord::normalized);
  float4 color = prev.sample(smp, src / size);
```

with

```metal
  float4 color;
  if (p.nearest != 0) {
    // Nearest texel as an exact read, not a sampler: a shrunk 1-px line keeps its full
    // value instead of being averaged with its neighbours (diagnosis doc, term 1). fold2
    // already keeps `src` inside [0, size); the clamp is belt-and-braces.
    uint2 texel = uint2(clamp(floor(src), float2(0.0), size - 1.0));
    color = prev.read(texel);
  } else {
    constexpr sampler smp(address::clamp_to_edge, filter::linear, coord::normalized);
    color = prev.sample(smp, src / size);
  }
```

- [ ] **Step 4: Run the parity test to verify it passes**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter WarpParityTests`
Expected: PASS, 6 cases (3 geometries × 2 filters).

- [ ] **Step 5: Write the failing RenderParams test**

In `app/Tests/FeedbaxKitTests/FeedbackCoreTests.swift`, add inside the class:

```swift
  func testRenderParamsDefaultToNearestAndForwardTheFilter() {
    var params = RenderParams(zoom: 1, theta: 0, offsetPx: .zero, hueShift: 0, satDelta: 0,
                              lightDelta: 0, eraseAlpha: 1)
    XCTAssertEqual(params.warpFilter, .nearest, "parity default (diagnosis doc, term 1)")
    XCTAssertEqual(params.warpParams.nearest, 1)
    params.warpFilter = .linear
    XCTAssertEqual(params.warpParams.nearest, 0)
  }
```

- [ ] **Step 6: Run it to verify it fails**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter FeedbackCoreTests/testRenderParamsDefaultToNearestAndForwardTheFilter`
Expected: compile error — `RenderParams` has no member `warpFilter`.

- [ ] **Step 7: Thread the filter through RenderParams and Engine**

`app/Sources/FeedbaxKit/Engine/FeedbackCore.swift` — inside `RenderParams`, after `public var worldBump: Float = 0` add:

```swift
  /// Texel read for the previous frame — `.nearest` by default (parity; diagnosis doc,
  /// term 1). Not a slot and not smoothed; set from `Engine.warpFilter` every frame.
  public var warpFilter: WarpFilter = .nearest
```

and change `warpParams` to:

```swift
  public var warpParams: WarpParams {
    WarpParams(zoom: zoom, theta: theta, offset: offsetPx,
              hueShift: hueShift, satDelta: satDelta, lightDelta: lightDelta,
              nearest: warpFilter == .nearest)
  }
```

`app/Sources/FeedbaxKit/Engine/Engine.swift` — directly after `public var frameRate: Int = 60` add:

```swift
  /// Feedback resample filter (diagnosis doc, term 1). `.nearest` is parity; `.linear` exists
  /// only so the two can be A/B'd live from the operator panel.
  public var warpFilter: WarpFilter = .nearest
```

and in `step`, directly after `var params = router.tick(at: time)` add:

```swift
    params.warpFilter = warpFilter
```

- [ ] **Step 8: Run the RenderParams test to verify it passes**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter FeedbackCoreTests`
Expected: PASS.

- [ ] **Step 9: Write the failing view-model test**

In `app/Tests/FeedbaxKitTests/EngineViewModelTests.swift`, add inside the class:

```swift
  func testWarpFilterMirrorsSetter() {
    let vm = EngineViewModel()
    XCTAssertEqual(vm.warpFilter, .nearest)
    vm.setWarpFilter(.linear)
    XCTAssertEqual(vm.warpFilter, .linear)
  }
```

- [ ] **Step 10: Run it to verify it fails**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter EngineViewModelTests/testWarpFilterMirrorsSetter`
Expected: compile error — no member `warpFilter`.

- [ ] **Step 11: Expose the filter on the view model and panel**

`app/Sources/FeedbaxKit/UI/EngineViewModel.swift` — directly after the `setFrameRate` function add:

```swift
  /// Feedback resample filter (diagnosis doc, term 1) — a venue/debug property like
  /// `frameRate`, not a performed slot. Mirrors `Engine.warpFilter`.
  @Published public private(set) var warpFilter: WarpFilter = .nearest

  public func setWarpFilter(_ filter: WarpFilter) {
    warpFilter = filter
    engine?.warpFilter = filter
  }
```

`app/Sources/FeedbaxKit/UI/OperatorPanel.swift` — inside `Section("Venue")`, directly after the `Picker("Frame Rate", ...) { ... }` block, add:

```swift
          Picker("Feedback sampling", selection: Binding(get: { vm.warpFilter }, set: { vm.setWarpFilter($0) })) {
            Text("Nearest (parity)").tag(WarpFilter.nearest)
            Text("Linear").tag(WarpFilter.linear)
          }
```

- [ ] **Step 12: Run the view-model tests and the full suite**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --skip GoldenFrameTests`
Expected: all PASS. `LoopStabilityTests` in particular must still pass (nearest sampling adds no gain; the lightness term still decays every seeded run).

- [ ] **Step 13: Commit**

```bash
git add app/Sources/FeedbaxKit/Shaders/WarpHSL.metal app/Sources/FeedbaxKit/Engine/WarpPass.swift app/Sources/FeedbaxKit/Engine/FeedbackCore.swift app/Sources/FeedbaxKit/Engine/Engine.swift app/Sources/FeedbaxKit/UI/EngineViewModel.swift app/Sources/FeedbaxKit/UI/OperatorPanel.swift app/Tests/FeedbaxKitTests/WarpParityTests.swift app/Tests/FeedbaxKitTests/FeedbackCoreTests.swift app/Tests/FeedbaxKitTests/EngineViewModelTests.swift
git commit -m "fix(engine): nearest-texel feedback resample by default, linear as an A/B option" -m "Bilinear resampling halves a sub-2-px line every generation, so the loop forgot its seeds in ~15 frames and sat at a dark fixed point. Reading the nearest texel keeps a shrunk line at full value until the lightness term fades it (~250 generations), which is the original's memory and pixel-scale mesh (docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md, term 1). Exposed as Engine.warpFilter / a Venue picker so the two can be compared live." -m "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>" -m "Claude-Session: https://claude.ai/code/session_017i8dhZYNK8i8tpri3zRBS4"
```

---

### Task 2: Unclamped HSL (Jitter semantics): S/L pass through, RGB clips per channel

**Files:**
- Modify: `app/Sources/FeedbaxKit/ShaderMath/HSL.swift` (header comment lines 3-6; `hslAdd` lines 50-56)
- Modify: `app/Sources/FeedbaxKit/Shaders/WarpHSL.metal` (last four lines of `fbx_warp_hsl`)
- Test: `app/Tests/FeedbaxKitTests/HSLTests.swift`

**Interfaces:**
- Produces: `hslAdd(_:hueShift:satDelta:lightDelta:)` unchanged signature, new semantics: hue wraps mod 1, S and L are NOT clamped, the RGB result is clamped to [0,1] per channel.
- Consumes: nothing new. `WarpParityTests` (Task 1) compares CPU `hslAdd` against the kernel and must keep passing.

- [ ] **Step 1: Write the failing tests**

In `app/Tests/FeedbaxKitTests/HSLTests.swift`, replace `testHueWrapsSatLightClip` with these three tests:

```swift
  func testHueWrapsAndLightnessClipsThroughRGB() {
    // Additive shift: hue wraps mod 1 (spec §01 §5). Red shifted by hue +1/3 → green.
    let g = hslAdd(SIMD3(1, 0, 0), hueShift: 1.0 / 3.0, satDelta: 0, lightDelta: 0)
    XCTAssertEqual(g.y, 1, accuracy: 1e-4); XCTAssertEqual(g.x, 0, accuracy: 1e-4)
    // hue 0.9 + 0.2 wraps to 0.1, not clamps to 1.0
    let wrapped = hslAdd(hsl2rgb(SIMD3(0.9, 1, 0.5)), hueShift: 0.2, satDelta: 0, lightDelta: 0)
    XCTAssertEqual(rgb2hsl(wrapped).x, 0.1, accuracy: 1e-3)
    // A huge lightness delta still ends at white — but via the per-channel RGB clip that the
    // original's char texture applies, not an HSL-space clamp.
    let white = hslAdd(SIMD3(0.5, 0.5, 0.5), hueShift: 0, satDelta: 0, lightDelta: 5)
    XCTAssertEqual(white, SIMD3(1, 1, 1))
  }
  /// Jitter's `cc.hsl2rgb.jxs` has no S/L clamp: with S = 1 + δ, `q = L·(1 + S)` grows the
  /// max channel by (1 + δ/2) while the min channel goes negative and clips to 0. This is the
  /// SATURATION fader's per-pixel gain — the term the port was missing (diagnosis doc, term 2).
  func testSaturationAboveOneIsAGainOnAlreadySaturatedPixels() {
    let out = hslAdd(SIMD3(0.4, 0.2, 0), hueShift: 0, satDelta: 0.035, lightDelta: 0)
    XCTAssertEqual(out.x, 0.4 * 1.0175, accuracy: 1e-3, "max channel × (1 + δ/2)")
    XCTAssertEqual(out.y, 0.2, accuracy: 1e-3, "mid channel unchanged for this hue")
    XCTAssertEqual(out.z, 0, accuracy: 1e-6, "min channel clips at 0, never below")
  }
  func testNegativeLightnessClipsToBlack() {
    let out = hslAdd(SIMD3(0.002, 0.001, 0), hueShift: 0, satDelta: 0, lightDelta: -0.004)
    XCTAssertEqual(out, SIMD3(0, 0, 0))
  }
```

- [ ] **Step 2: Run them to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter HSLTests`
Expected: `testSaturationAboveOneIsAGainOnAlreadySaturatedPixels` FAILS (`out.x` is 0.4, not 0.407 — the clamp makes the delta a no-op). The other two pass.

- [ ] **Step 3: Remove the clamp on the CPU reference**

`app/Sources/FeedbaxKit/ShaderMath/HSL.swift` — replace the header comment (lines 3-6) with:

```swift
/// Standard HSL/HSV conversions, hue in [0,1). These mirror the Jitter gen operators
/// rgb2hsl/hsl2rgb used by the shaderfx HSL pix (spec §01 §4-5): the shift is ADDITIVE
/// in HSL space and hue wraps mod 1. S and L are deliberately NOT clamped — Jitter's own
/// `cc.hsl2rgb.jxs` converts the raw values and the char texture then clips each RGB
/// channel, and above S = 1 that pair is the saturation fader's per-pixel gain
/// (docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md, term 2).
```

and replace `hslAdd` with:

```swift
public func hslAdd(_ rgb: SIMD3<Float>, hueShift: Float, satDelta: Float, lightDelta: Float) -> SIMD3<Float> {
  var hsl = rgb2hsl(rgb) + SIMD3(hueShift, satDelta, lightDelta)
  hsl.x = hsl.x - floor(hsl.x)                      // hue wraps; S and L pass through
  return simd_clamp(hsl2rgb(hsl), SIMD3(repeating: 0), SIMD3(repeating: 1))   // char-texture clip
}
```

- [ ] **Step 4: Remove the clamp in the kernel**

`app/Sources/FeedbaxKit/Shaders/WarpHSL.metal` — replace the last three statements of `fbx_warp_hsl`

```metal
  float3 hsl = rgb2hsl(color.rgb) + float3(p.hueShift, p.satDelta, p.lightDelta);
  hsl.x = fract(hsl.x);
  hsl.yz = clamp(hsl.yz, 0.0, 1.0);
  outTex.write(float4(hsl2rgb(hsl), color.a), gid);
```

with

```metal
  float3 hsl = rgb2hsl(color.rgb) + float3(p.hueShift, p.satDelta, p.lightDelta);
  hsl.x = fract(hsl.x);
  // No S/L clamp — Jitter's cc.hsl2rgb.jxs converts the raw values and the char texture
  // clips each RGB channel afterwards; above S = 1 that is the saturation fader's per-pixel
  // gain (diagnosis doc, term 2). Mirrors ShaderMath/HSL.swift's hslAdd.
  outTex.write(float4(clamp(hsl2rgb(hsl), 0.0, 1.0), color.a), gid);
```

- [ ] **Step 5: Run HSL, parity, and stability tests**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter "HSLTests|WarpParityTests|LoopStabilityTests|FeedbackCoreTests"`
Expected: all PASS. (`LoopStabilityTests` keeps saturation at the startup vector — delta 0 — so no gain is introduced there.)

- [ ] **Step 6: Commit**

```bash
git add app/Sources/FeedbaxKit/ShaderMath/HSL.swift app/Sources/FeedbaxKit/Shaders/WarpHSL.metal app/Tests/FeedbaxKitTests/HSLTests.swift
git commit -m "fix(engine): HSL shift no longer clamps S/L; RGB clips per channel like the char texture" -m "The port clamped S and L to [0,1] before hsl2rgb on a spec assumption. Jitter's cc.hsl2rgb.jxs has no such clamp: with S = 1 + δ the max channel grows by (1 + δ/2) per frame while the min channel clips to 0, which is what makes the SATURATION fader a per-pixel gain bounded by clipping — the full, vivid Max regime. Every seed already has S = 1, so the clamp had made the fader inert above centre (diagnosis doc, term 2)." -m "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>" -m "Claude-Session: https://claude.ai/code/session_017i8dhZYNK8i8tpri3zRBS4"
```

---

### Task 3: Waveform geometry — wave 1 is the bottom line, wave 2 is the ring (on at load)

**Files:**
- Rewrite: `app/Sources/FeedbaxKit/Engine/WaveformRenderer.swift`
- Modify: `app/Sources/FeedbaxKit/Shaders/Composite.metal` (waveform section, lines 34-89)
- Modify: `app/Sources/FeedbaxKit/Control/Presets.swift` (`PresetToggles.wave2` default, lines 74 and 78)
- Modify: `app/Sources/FeedbaxKit/UI/EngineViewModel.swift` (`wave2On` default, line 96)
- Rewrite: `app/Tests/FeedbaxKitTests/WaveformTests.swift`

**Interfaces:**
- Produces: `WaveformStyle` gains `radialRadius: Float` and loses `pointSizePx`; `WaveformRenderer.wave1LinePoints(_:style:) -> [SIMD2<Float>]`; `WaveformRenderer.wave2RingPolyline(_:style:canvasAspect:) -> [SIMD2<Float>]`; `WaveformRenderer.ribbonVertices(_:closed:halfWidthNDC:) -> [RibbonVertex]`; `wave2Enabled` defaults `true`; `wave2BaseAlpha` defaults `0.8`. `wave1Polyline`, `wave2Points`, `pointSpriteHalfSizeNDC` are removed.
- Consumes: `FrameAudio.wave1Points` (512 samples) and `FrameAudio.wave2Points` (any count ≥ 3; Task 4 makes it 1024) from `AudioAnalysis.swift`; `Compositor.projection`.

- [ ] **Step 1: Write the failing tests (whole file)**

Replace `app/Tests/FeedbaxKitTests/WaveformTests.swift` with:

```swift
import XCTest
import simd
@testable import FeedbaxKit

final class WaveformTests: XCTestCase {
  // MARK: wave 1 — `jit.gl.graph` obj-12, linear, `scale 1.5 1 0`, `position 0 −0.85 0`

  func testWave1IsAStraightLineAtTheBottomWhenSilent() {
    let pts = WaveformRenderer.wave1LinePoints([Float](repeating: 0, count: 512), style: .wave1)
    XCTAssertEqual(pts.count, 512)
    XCTAssertEqual(pts.first!.x, -1.5, accuracy: 1e-4, "spans −scale.x…+scale.x")
    XCTAssertEqual(pts.last!.x, 1.5, accuracy: 1e-4)
    for p in pts { XCTAssertEqual(p.y, -0.85, accuracy: 1e-5, "silent line sits at position.y") }
  }
  func testWave1SampleDeflectsYOneToOne() {
    var samples = [Float](repeating: 0, count: 512); samples[10] = 0.05
    let pts = WaveformRenderer.wave1LinePoints(samples, style: .wave1)
    XCTAssertEqual(pts[10].y, -0.80, accuracy: 1e-5, "y = position.y + sample·scale.y")
    XCTAssertEqual(pts[11].y, -0.85, accuracy: 1e-5)
  }

  // MARK: wave 2 — obj-213, `radial 1`, `radialradius 0.7`, `position 0 0 −2`

  func testWave2IsAClosedRingOfRadius0Point7StretchedByAspect() {
    let aspect: Float = 16.0 / 9.0
    let pts = WaveformRenderer.wave2RingPolyline([Float](repeating: 0, count: 1024), style: .wave2,
                                                 canvasAspect: aspect)
    XCTAssertEqual(pts.count, 1025, "closed: first point repeated")
    XCTAssertEqual(pts.first!, pts.last!)
    XCTAssertEqual(pts[0].x, 0.7 * aspect, accuracy: 1e-4, "x radius × canvas aspect (screenshot ellipse)")
    XCTAssertEqual(pts[0].y, 0, accuracy: 1e-4)
    XCTAssertEqual(pts[256].x, 0, accuracy: 1e-3)
    XCTAssertEqual(pts[256].y, 0.7, accuracy: 1e-4, "y radius is radialradius itself")
  }
  func testWave2SampleModulatesRadius() {
    var samples = [Float](repeating: 0, count: 1024); samples[0] = 0.1
    let pts = WaveformRenderer.wave2RingPolyline(samples, style: .wave2, canvasAspect: 1)
    XCTAssertEqual(pts[0].x, 0.8, accuracy: 1e-4, "r = radialradius + sample")
  }

  // MARK: ribbon expansion shared by both

  func testRibbonVertexCountsAndOffsets() {
    let open: [SIMD2<Float>] = [SIMD2(0, 0), SIMD2(1, 0), SIMD2(2, 0)]
    let openVerts = WaveformRenderer.ribbonVertices(open, closed: false, halfWidthNDC: 0.01)
    XCTAssertEqual(openVerts.count, 6, "two vertices per point")
    XCTAssertEqual(openVerts[0].halfWidthNDC, 0.01); XCTAssertEqual(openVerts[1].halfWidthNDC, -0.01)
    XCTAssertEqual(openVerts[0].normal.y, 1, accuracy: 1e-5, "normal of a +x line is +y")
    let ring = WaveformRenderer.wave2RingPolyline([Float](repeating: 0, count: 8), style: .wave2, canvasAspect: 1)
    let ringVerts = WaveformRenderer.ribbonVertices(ring, closed: true, halfWidthNDC: 0.01)
    XCTAssertEqual(ringVerts.count, ring.count * 2)
    XCTAssertEqual(ringVerts[0].normal, ringVerts[ringVerts.count - 2].normal, "seam tangents agree")
  }

  func testParityStyleConstants() {
    XCTAssertEqual(WaveformStyle.wave1.color, SIMD4(0.392375, 0.23808, 0, 0.8))
    XCTAssertEqual(WaveformStyle.wave1.lineWidthPx, 12)
    XCTAssertEqual(WaveformStyle.wave1.radialRadius, 0, "wave 1 is linear")
    XCTAssertEqual(WaveformStyle.wave1.position, SIMD3(0, -0.85, 0))
    let c2 = WaveformStyle.wave2.color
    XCTAssertEqual(SIMD3(c2.x, c2.y, c2.z), SIMD3(0, 0.786722, 0.821229))
    XCTAssertEqual(WaveformStyle.wave2.lineWidthPx, 4)
    XCTAssertEqual(WaveformStyle.wave2.radialRadius, 0.7)
    XCTAssertEqual(WaveformStyle.wave2.position, SIMD3(0, 0, -2))
  }

  func testDefaultsMatchTheLoadedPatch() throws {
    let ctx = try MetalContext()
    let renderer = try WaveformRenderer(context: ctx, pixelFormat: .rgba8Unorm)
    XCTAssertTrue(renderer.wave1Enabled, "Bass toggle: loadmess 1")
    XCTAssertTrue(renderer.wave2Enabled, "Circle toggle never sends enable 0; jit.gl.graph enables by default")
    XCTAssertEqual(renderer.wave2BaseAlpha, 0.8, "loadmess 0.8 → slider[338] → alpha")
  }

  /// GPU smoke test — the ribbon shader has no other coverage. Wave 1's silent line sits
  /// just below the visible edge at z = 0 (0.85 > 0.828), so it is fed a +0.2 deflection to
  /// bring it into frame; wave 2's ring (radius 0.7 at z = −2) is visible on its own.
  func testDrawProducesVisiblePixels() throws {
    let ctx = try MetalContext()
    let targetFormat: MTLPixelFormat = .rgba16Float
    let renderer = try WaveformRenderer(context: ctx, pixelFormat: targetFormat)
    renderer.wave1Enabled = true
    renderer.wave2Enabled = true
    renderer.wave2BaseAlpha = 0.8

    let size = 64
    let target = ctx.device.makeTexture(descriptor: {
      let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: targetFormat, width: size, height: size, mipmapped: false)
      d.usage = [.renderTarget, .shaderRead]
      d.storageMode = .shared
      return d
    }())!

    let cb = ctx.queue.makeCommandBuffer()!
    let frame = FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: SIMD2(size, size),
                             commandBuffer: cb, pool: ctx.pool)
    let rp = MTLRenderPassDescriptor()
    rp.colorAttachments[0].texture = target
    rp.colorAttachments[0].loadAction = .clear
    rp.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
    rp.colorAttachments[0].storeAction = .store
    let enc = cb.makeRenderCommandEncoder(descriptor: rp)!

    let audio = FrameAudio(worldBump: 0, waveBumpRaw: 0.1, kittyBumpRaw: 0,
                           wave1Points: [Float](repeating: 0.2, count: 512),
                           wave2Points: [Float](repeating: 0, count: 1024))
    let proj = Compositor.projection(canvasAspect: 1)
    renderer.draw(enc, frame: frame, audio: audio, projection: proj)
    enc.endEncoding()
    cb.commit(); cb.waitUntilCompleted()

    let pixels = ctx.readPixels(target)
    XCTAssertTrue(pixels.contains { $0.w > 0 }, "expected at least one drawn (non-transparent) pixel")
    // First-touched pixels over transparent black are exactly color.rgb · srcAlpha for both
    // blend modes (alphaOver's dst factor is 1−srcA, srcAlphaDstAlpha's is dstA = 0).
    func hasPixel(near expected: SIMD3<Float>, tol: Float) -> Bool {
      pixels.contains { simd_length(SIMD3($0.x, $0.y, $0.z) - expected) < tol }
    }
    let wave1Expected = SIMD3<Float>(0.392375, 0.23808, 0) * Float(0.8)
    let wave2Expected = SIMD3<Float>(0, 0.786722, 0.821229) * Float(0.9)   // 0.8 base + 0.1 waveBumpRaw
    XCTAssertTrue(hasPixel(near: wave1Expected, tol: 0.02), "expected wave 1's burnt-orange line")
    XCTAssertTrue(hasPixel(near: wave2Expected, tol: 0.02), "expected wave 2's cyan ring")
  }
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter WaveformTests`
Expected: compile errors — `wave1LinePoints`, `wave2RingPolyline`, `ribbonVertices`, `radialRadius` do not exist.

- [ ] **Step 3: Rewrite WaveformRenderer.swift**

Replace the whole of `app/Sources/FeedbaxKit/Engine/WaveformRenderer.swift` with:

```swift
import Metal
import simd

/// Fixed visual parameters for one of the two `jit.gl.graph` parity waveforms
/// (`patches/feedbax.sound2.maxpat` obj-12 and obj-213; docs/superpowers/specs/
/// 2026-08-24-dynamism-gap-diagnosis.md, "Audio couplings"). Only the sample data (both)
/// and wave 2's alpha (the bump pulse) vary per frame. Two static styles; a third is never
/// needed.
public struct WaveformStyle {
  /// World-space placement — `pak position`/`pak scale` in the original. `position.z` is what
  /// parks wave 2 deep (z = −2): the shared `Compositor.projection` makes it project smaller
  /// there, which is why the patch doesn't scale it down directly.
  public var position: SIMD3<Float>
  public var scale: SIMD3<Float>
  /// `@line_width` — the ribbon's FULL width in canvas pixels (12 for wave 1, 4 for wave 2).
  public var lineWidthPx: Float
  /// `@radial 1` + `radialradius`: > 0 draws the graph as a closed ring of this base radius
  /// (world units, y axis) instead of a left-to-right line. 0 = linear graph.
  public var radialRadius: Float
  /// Base RGBA — wave 2's alpha here is a fallback only; `WaveformRenderer.draw` overwrites
  /// it per frame with `wave2BaseAlpha + audio.waveBumpRaw`.
  public var color: SIMD4<Float>
  public var blend: QuadRenderer.BlendMode

  /// Wave 1 ("Bass", obj-12): a LINEAR graph, `line_width 12`, `scale 1.5 1 0`, `position
  /// 0 −0.85 0`, colour from `swatch[236]` with alpha 0.8, `blend_mode 6 7`. At z = 0 the
  /// visible half-height is 2·tan(22.5°) = 0.828, so the silent line's centre sits 0.022
  /// below the frame edge and only bass deflections push it into view — the audio-gated
  /// seed that the original's bands and "bass background" come from.
  public static let wave1 = WaveformStyle(
    position: SIMD3(0, -0.85, 0), scale: SIMD3(1.5, 1, 0),
    lineWidthPx: 12, radialRadius: 0,
    color: SIMD4(0.392375, 0.23808, 0, 0.8),
    blend: .alphaOver)

  /// Wave 2 ("Circle", obj-213): the RING — `loadmess 1 → prepend radial`, `radialradius 0.7`
  /// (`loadmess 0.7 → slider → pak radialradius`), `line_width 4`, `position 0 0 −2`,
  /// `scale 1 1 1`, colour from `swatch[238]`, `blend_mode 6 8` (src_alpha, dst_alpha). Drawn
  /// as an ellipse with the canvas aspect — measured off the render window, where the ring's
  /// radius is the same fraction of the half-width and of the half-height.
  public static let wave2 = WaveformStyle(
    position: SIMD3(0, 0, -2), scale: SIMD3(1, 1, 1),
    lineWidthPx: 4, radialRadius: 0.7,
    color: SIMD4(0, 0.786722, 0.821229, 1),
    blend: .srcAlphaDstAlpha)
}

/// One ribbon vertex — mirrors `Composite.metal`'s `RibbonVertex` field-for-field (identical
/// byte layout is what lets `setVertexBuffer` hand the GPU exactly what Swift wrote).
struct RibbonVertex: Equatable {
  var point: SIMD2<Float>
  var normal: SIMD2<Float>
  var halfWidthNDC: Float
}

/// Draws the two parity waveforms as a `Compositor.overlays` entry — world-space polylines
/// expanded into screen-space ribbons (`fbx_ribbon_v`), one pipeline per blend mode. The
/// geometry math (`wave1LinePoints`/`wave2RingPolyline`/`ribbonVertices`) is pure and
/// unit-tested (`WaveformTests`); `draw` is the Metal glue.
public final class WaveformRenderer {
  /// Mirrors `Composite.metal`'s `WaveUniforms`.
  private struct WaveUniforms { var projection: float4x4; var z: Float; var color: SIMD4<Float> }

  /// `soundwave_enable` (the webUI "Bass" box): `loadmess 1` → `enable 1` → obj-12.
  public var wave1Enabled = true
  /// `soundwave_enable1` (the "Circle" box) has no loadmess, and `jit.gl.graph` enables by
  /// default — so obj-213 DRAWS at load with the box unchecked (diagnosis doc, "Audio
  /// couplings"). Off only once someone sends `enable 0`.
  public var wave2Enabled = true
  /// `loadmess 0.8 → slider[338] → + wavebumpsig → prepend alpha` — wave 2's base alpha.
  public var wave2BaseAlpha: Float = 0.8

  private let wave1Pipeline: MTLRenderPipelineState
  private let wave2Pipeline: MTLRenderPipelineState
  private let device: MTLDevice

  /// `pixelFormat` must be the accumulator's actual format (the render pass this draws into):
  /// a pipeline's colour-attachment format is fixed at build time and a mismatch fails at
  /// draw time, not creation time. No default on purpose — the caller always knows.
  public init(context: MetalContext, pixelFormat: MTLPixelFormat) throws {
    func function(_ name: String) throws -> MTLFunction {
      guard let fn = context.libraries.compactMap({ $0.makeFunction(name: name) }).first else {
        throw FeedbaxError.missingShader(name)
      }
      return fn
    }
    device = context.device
    func ribbonPipeline(blend: QuadRenderer.BlendMode) throws -> MTLRenderPipelineState {
      let desc = MTLRenderPipelineDescriptor()
      desc.vertexFunction = try function("fbx_ribbon_v")
      desc.fragmentFunction = try function("fbx_point_f")
      WaveformRenderer.configureBlend(desc.colorAttachments[0]!, format: pixelFormat, blend: blend)
      return try context.device.makeRenderPipelineState(descriptor: desc)
    }
    wave1Pipeline = try ribbonPipeline(blend: WaveformStyle.wave1.blend)
    wave2Pipeline = try ribbonPipeline(blend: WaveformStyle.wave2.blend)
  }

  /// Mirrors `QuadRenderer.BlendMode`'s factor mapping — duplicated rather than shared, since
  /// an `MTLRenderPipelineDescriptor` is tied to one vertex/fragment pair.
  private static func configureBlend(_ attachment: MTLRenderPipelineColorAttachmentDescriptor,
                                     format: MTLPixelFormat, blend: QuadRenderer.BlendMode) {
    attachment.pixelFormat = format
    switch blend {
    case .none:
      attachment.isBlendingEnabled = false
    case .alphaOver:
      attachment.isBlendingEnabled = true
      attachment.rgbBlendOperation = .add
      attachment.alphaBlendOperation = .add
      attachment.sourceRGBBlendFactor = .sourceAlpha
      attachment.destinationRGBBlendFactor = .oneMinusSourceAlpha
      attachment.sourceAlphaBlendFactor = .sourceAlpha
      attachment.destinationAlphaBlendFactor = .oneMinusSourceAlpha
    case .srcAlphaDstAlpha:
      attachment.isBlendingEnabled = true
      attachment.rgbBlendOperation = .add
      attachment.alphaBlendOperation = .add
      attachment.sourceRGBBlendFactor = .sourceAlpha
      attachment.destinationRGBBlendFactor = .destinationAlpha
      attachment.sourceAlphaBlendFactor = .sourceAlpha
      attachment.destinationAlphaBlendFactor = .destinationAlpha
    }
  }

  // MARK: - Pure geometry (unit-tested by WaveformTests)

  /// Wave 1's world-space polyline — `jit.gl.graph` in linear mode: sample i of N sits at
  /// `x = (2i/(N−1) − 1)·scale.x`, `y = position.y + sampleᵢ·scale.y`. The value→y mapping is
  /// taken as 1 world unit per unit value (PARITY-REVIEW: to be measured on the running patch).
  public static func wave1LinePoints(_ samples: [Float], style: WaveformStyle) -> [SIMD2<Float>] {
    let n = samples.count
    guard n > 0 else { return [] }
    let center = SIMD2(style.position.x, style.position.y)
    if n == 1 { return [center + SIMD2(-style.scale.x, samples[0] * style.scale.y)] }
    return (0..<n).map { i in
      let t = Float(i) / Float(n - 1) * 2 - 1     // −1…1 across the sample count
      return center + SIMD2(t * style.scale.x, samples[i] * style.scale.y)
    }
  }

  /// Wave 2's world-space closed ring — `radial 1`: point i of N at `θᵢ = 2π·i/N`,
  /// `r = radialRadius + sampleᵢ`, `x = position.x + r·cosθ·scale.x·canvasAspect`,
  /// `y = position.y + r·sinθ·scale.y`. Closed: point 0 is repeated as point N.
  public static func wave2RingPolyline(_ samples: [Float], style: WaveformStyle,
                                       canvasAspect: Float) -> [SIMD2<Float>] {
    let n = samples.count
    guard n > 0 else { return [] }
    let center = SIMD2(style.position.x, style.position.y)
    var points = [SIMD2<Float>](repeating: .zero, count: n + 1)
    for i in 0..<n {
      let theta = 2 * Float.pi * Float(i) / Float(n)
      let r = style.radialRadius + samples[i]
      points[i] = center + SIMD2(r * cos(theta) * style.scale.x * canvasAspect,
                                 r * sin(theta) * style.scale.y)
    }
    points[n] = points[0]
    return points
  }

  /// Expands a polyline into triangle-strip ribbon vertices: two per point, offset ±half
  /// width along the local normal (central differences; one-sided at the ends of an open
  /// line; for a closed loop the duplicated closing point is skipped so both ends of the strip
  /// share point 0's tangent).
  static func ribbonVertices(_ points: [SIMD2<Float>], closed: Bool, halfWidthNDC: Float) -> [RibbonVertex] {
    let count = points.count
    guard count > 1 else { return [] }
    var verts = [RibbonVertex](); verts.reserveCapacity(count * 2)
    for i in 0..<count {
      let prevIdx: Int, nextIdx: Int
      if closed {
        prevIdx = i == 0 ? count - 2 : i - 1
        nextIdx = i == count - 1 ? 1 : i + 1
      } else {
        prevIdx = max(i - 1, 0)
        nextIdx = min(i + 1, count - 1)
      }
      let tangent = points[nextIdx] - points[prevIdx]
      let len = simd_length(tangent)
      let dir = len > 1e-6 ? tangent / len : SIMD2<Float>(1, 0)
      let normal = SIMD2<Float>(-dir.y, dir.x)
      verts.append(RibbonVertex(point: points[i], normal: normal, halfWidthNDC: halfWidthNDC))
      verts.append(RibbonVertex(point: points[i], normal: normal, halfWidthNDC: -halfWidthNDC))
    }
    return verts
  }

  // MARK: - GPU draw (covered only by WaveformTests' smoke test)

  /// Hooked into `Compositor.overlays` — draws under the feedback plane, using the same
  /// `projection` every other world-space draw this frame uses.
  public func draw(_ enc: MTLRenderCommandEncoder, frame: FrameContext, audio: FrameAudio,
                   projection: float4x4) {
    let canvasHeight = max(Float(frame.canvasSize.y), 1)
    let canvasAspect = max(Float(frame.canvasSize.x), 1) / canvasHeight
    if wave1Enabled {
      let style = WaveformStyle.wave1
      drawRibbon(enc, pipeline: wave1Pipeline,
                 points: WaveformRenderer.wave1LinePoints(audio.wave1Points, style: style),
                 closed: false, style: style, color: style.color,
                 canvasHeight: canvasHeight, projection: projection)
    }
    if wave2Enabled {
      let style = WaveformStyle.wave2
      // Alpha pulse: base + wavebumpsig, UNCLAMPED on the CPU side — the original relies on
      // GL's raster-time clamp for an out-of-range value.
      var color = style.color
      color.w = wave2BaseAlpha + audio.waveBumpRaw
      drawRibbon(enc, pipeline: wave2Pipeline,
                 points: WaveformRenderer.wave2RingPolyline(audio.wave2Points, style: style,
                                                            canvasAspect: canvasAspect),
                 closed: true, style: style, color: color,
                 canvasHeight: canvasHeight, projection: projection)
    }
  }

  private func drawRibbon(_ enc: MTLRenderCommandEncoder, pipeline: MTLRenderPipelineState,
                          points: [SIMD2<Float>], closed: Bool, style: WaveformStyle,
                          color: SIMD4<Float>, canvasHeight: Float, projection: float4x4) {
    // Pixel→NDC uses canvas height only (Composite.metal's header on `fbx_ribbon_v`):
    // NDC spans 2 units over canvasHeight px, so a half width of lineWidthPx/canvasHeight NDC
    // is a FULL width of lineWidthPx pixels. Exact vertically, mildly stretched horizontally.
    let halfWidthNDC = style.lineWidthPx / canvasHeight
    let verts = WaveformRenderer.ribbonVertices(points, closed: closed, halfWidthNDC: halfWidthNDC)
    guard !verts.isEmpty else { return }
    var uniforms = WaveUniforms(projection: projection, z: style.position.z, color: color)
    let vbuf = device.makeBuffer(bytes: verts, length: MemoryLayout<RibbonVertex>.stride * verts.count,
                                 options: .storageModeShared)!
    enc.setRenderPipelineState(pipeline)
    enc.setVertexBuffer(vbuf, offset: 0, index: 0)
    enc.setVertexBytes(&uniforms, length: MemoryLayout<WaveUniforms>.stride, index: 1)
    enc.setFragmentBytes(&uniforms, length: MemoryLayout<WaveUniforms>.stride, index: 1)
    enc.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: verts.count)
  }
}
```

- [ ] **Step 4: Remove the point-sprite path from Composite.metal**

In `app/Sources/FeedbaxKit/Shaders/Composite.metal`:

Replace the paragraph comment beginning `// Waveform overlay draws (Engine/WaveformRenderer.swift, Task 18) — wave 1's radial ribbon` through `// vertex's depth — the standard "screen-space line width" trick.` with:

```metal
// Waveform overlay draws (Engine/WaveformRenderer.swift): wave 1's bottom line and wave 2's
// ring, both as screen-space ribbons sharing one vertex function, one uniforms struct, and
// one flat-colour fragment function (neither samples a texture). Ribbon expansion happens in
// clip space: each vertex carries `normal·halfWidthNDC`, computed by WaveformRenderer from
// `lineWidthPx / canvasHeight` (aspect-agnostic — exact vertically, mildly stretched
// horizontally on a non-square canvas). Multiplying the offset by `clip.w` before adding it
// to `clip.xy` keeps it at its intended NDC size after the perspective divide regardless of
// the vertex's depth — the standard "screen-space line width" trick.
```

Delete the line `struct PointVertex { float2 point; float2 corner; };` and its two preceding comment lines (`// One (point, corner) pair per triangle-list vertex — ...` / `// wave-2 sample (two triangles), ...`).

Replace the `fbx_ribbon_v` doc comment (`// Wave 1 (spec §03 §5 `radial 1`): a closed-loop polyline ...` through `// style's fixed depth (0 for wave 1, spec §03 §5's `position` row).`) with:

```metal
// Both waveforms: a polyline drawn as a screen-space ribbon. `v.point` is the sample already
// in the waveform's local xy-plane (see WaveformRenderer.wave1LinePoints / wave2RingPolyline);
// `u.z` places the whole ribbon at the style's fixed depth (0 for wave 1, −2 for wave 2).
```

Delete the whole `fbx_point_v` vertex function and its two-line doc comment (`// Wave 2 (spec §03 §5 `poly_mode (0,0)` + `circpoints 5`): ...`). Keep `fbx_point_f` (both ribbon pipelines use it) and change its comment to `// Shared by both waveform pipelines — flat parity colour, no texture.`

- [ ] **Step 5: Flip the wave-2 defaults everywhere they are declared**

`app/Sources/FeedbaxKit/Control/Presets.swift`: change `public var wave2 = false` to `public var wave2 = true`, and in the `init` signature change `wave2: Bool = false` to `wave2: Bool = true`. Update the doc comment above the struct (line 67) from `everything off except `wave1`, which is on at load.` to `everything off except `wave1` and `wave2`, which both draw at load (wave 2's box is unchecked but never sends enable 0 — diagnosis doc).`

`app/Sources/FeedbaxKit/UI/EngineViewModel.swift` line 96: change `@Published public private(set) var wave2On = false` to `@Published public private(set) var wave2On = true`.

- [ ] **Step 6: Run the waveform tests, then the full suite**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter WaveformTests`
Expected: PASS.

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --skip GoldenFrameTests`
Expected: PASS. `EngineWiringTests.testBothWaveformsDrawInOneFrame` feeds a 0.6-amplitude 46.7 Hz component, whose first `jit.slide` step (0.6/8 = 0.075 > the 0.022 needed) already lifts wave 1's line into frame, so "wave 1 must draw" holds. If anything else fails, report it — do not adjust assertions.

- [ ] **Step 7: Commit**

```bash
git add app/Sources/FeedbaxKit/Engine/WaveformRenderer.swift app/Sources/FeedbaxKit/Shaders/Composite.metal app/Sources/FeedbaxKit/Control/Presets.swift app/Sources/FeedbaxKit/UI/EngineViewModel.swift app/Tests/FeedbaxKitTests/WaveformTests.swift
git commit -m "fix(engine): wave 1 is the bottom line, wave 2 is the ring and draws at load" -m "The port had the jit.gl.graph geometry swapped: the loadmess 1 → prepend radial chain feeds obj-213 (wave 2, cyan, radialradius 0.7, line_width 4, z −2), not obj-12. Wave 1 (Bass) is a 12-px linear graph at y −0.85 whose silent line sits just below the visible edge, so only bass peaks push it into frame — the audio-gated seed behind the original's bands. Wave 2's Circle box never sends enable 0, so the ring draws at load; base alpha is 0.8. Point sprites are gone; both waves are ribbons." -m "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>" -m "Claude-Session: https://claude.ai/code/session_017i8dhZYNK8i8tpri3zRBS4"
```

---

### Task 4: Wave-2 audio input: gain −0.5 and `jit.catch~` group-averaging decimation

**Files:**
- Modify: `app/Sources/FeedbaxKit/Audio/WaveBuffer.swift` (add `AveragingWaveBuffer`; expose `snapshot()`)
- Modify: `app/Sources/FeedbaxKit/Audio/AudioAnalysis.swift` (`FrameAudio.wave2Points` doc lines 25-31; `AudioBands` lines 38-48, 82-86, 128-130, 154)
- Test: `app/Tests/FeedbaxKitTests/AudioAnalysisTests.swift`

**Interfaces:**
- Produces: `struct AveragingWaveBuffer { init(capacity: Int, group: Int); mutating func push(_ x: Float); func points() -> [Float] }`; `WaveBuffer.snapshot() -> [Float]`; `AudioBands.wave2InputGain` default `-0.5`; `FrameAudio.wave2Points.count == 1024`.
- Consumes: `WaveformRenderer.wave2RingPolyline` (Task 3) accepts any count.

- [ ] **Step 1: Write the failing tests**

In `app/Tests/FeedbaxKitTests/AudioAnalysisTests.swift`, replace `testWaveBuffersShapeAndSmoothing` with:

```swift
  func testWaveBuffersShapeAndSmoothing() {
    let bands = AudioBands(sampleRate: 48000)
    bands.ingest(sine(46.7, seconds: 0.1, sampleRate: 48000, amplitude: 0.5))
    let f = bands.frameValues()
    XCTAssertEqual(f.wave1Points.count, 512, "framesize 1024 / downsample 2")
    XCTAssertEqual(f.wave2Points.count, 1024, "framesize 1024 cells of 512-sample group means (jit.catch~ refpage: downsample n averages each group of n)")
  }
  /// Wave 2's multiplier is `*~ -0.5` whose cold inlet is fed by a `gswitch` — a MESSAGE
  /// object (its refpage inlets are bang/int), so the −0.5 argument stays in force; the spec's
  /// "signal-patched cold inlet → silent" reading was wrong (diagnosis doc, "Audio couplings").
  func testWave2IsFedAtMinusHalfGain() {
    XCTAssertEqual(AudioBands(sampleRate: 48000).wave2InputGain, -0.5)
    let bands = AudioBands(sampleRate: 48000)
    bands.ingest(sine(60, seconds: 1.0, sampleRate: 48000, amplitude: 0.8))
    let points = bands.frameValues().wave2Points
    XCTAssertGreaterThan(points.map { abs($0) }.max()!, 0.001, "the ring is not structurally silent")
    let silent = AudioBands(sampleRate: 48000)
    silent.ingest([Float](repeating: 0, count: 48000))
    XCTAssertTrue(silent.frameValues().wave2Points.allSatisfy { $0 == 0 })
  }
  func testAveragingWaveBufferEmitsOneMeanPerGroup() {
    var buf = AveragingWaveBuffer(capacity: 4, group: 3)
    for _ in 0..<3 { buf.push(1) }
    XCTAssertEqual(buf.points(), [0, 0, 0, 1], "one full group → one cell, zero-padded before it")
    buf.push(2); buf.push(4)
    XCTAssertEqual(buf.points(), [0, 0, 0, 1], "a partial group emits nothing yet")
    buf.push(6)
    XCTAssertEqual(buf.points(), [0, 0, 1, 4], "mean of (2, 4, 6)")
  }
```

- [ ] **Step 2: Run to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter AudioAnalysisTests`
Expected: compile error — `AveragingWaveBuffer` undefined.

- [ ] **Step 3: Add the averaging buffer**

In `app/Sources/FeedbaxKit/Audio/WaveBuffer.swift`, rename the private `chronological()` to an internal `snapshot()` (update its one call site in `strideDecimated`), and append:

```swift
/// `jit.catch~ @downsample n` as its refpage defines it — "each group of n successive samples
/// are averaged" — followed by a `capacity`-cell frame of those means, oldest→newest. This is
/// wave 2's path (`loadmess 512 → downsample 512 → s wave2cmd`, `framesize 1024`): a 1024-cell
/// ring of 512-sample means, which is why the ring stays near-circular under a 60 Hz band
/// (diagnosis doc, "Audio couplings"; the exact history depth is flagged [measure] there).
struct AveragingWaveBuffer {
  private var ring: WaveBuffer
  private let group: Int
  private var sum: Float = 0
  private var count = 0

  init(capacity: Int, group: Int) {
    precondition(group > 0)
    ring = WaveBuffer(capacity: capacity)
    self.group = group
  }

  mutating func push(_ x: Float) {
    sum += x
    count += 1
    if count == group {
      ring.push(sum / Float(group))
      sum = 0
      count = 0
    }
  }

  /// Oldest→newest cells, zero-padded at the front until `capacity` groups have completed.
  func points() -> [Float] { ring.snapshot() }
}
```

- [ ] **Step 4: Switch wave 2 over in AudioBands**

In `app/Sources/FeedbaxKit/Audio/AudioAnalysis.swift`:

Replace the `FrameAudio.wave2Points` doc comment (the block starting `/// Wave-2 ring (1024 samples) downsampled ×512 → 2 points, unsmoothed` through `/// audio-reactive line.`) with:

```swift
  /// Wave-2 ring: 1024 cells, each the mean of 512 consecutive samples of the 60 Hz band
  /// (`jit.catch~ @framesize 1024`, `downsample 512` = group averaging per its refpage),
  /// unsmoothed. Averaging over ~0.6 of a 60 Hz cycle leaves little, which is why the
  /// original's ring is near-static (diagnosis doc, "Audio couplings").
```

Replace the `wave2InputGain` doc comment and declaration (the block starting `/// Checklist #15 (spec §03 §3, §12 q.8): wave 2's input in the original is near-silent` through `public var wave2InputGain: Float = 0.0`) with:

```swift
  /// `*~ -0.5` [sound2 obj-128] on wave 2's input. Its cold inlet is wired from a `gswitch`,
  /// which is a MESSAGE object (refpage inlets `bang/int`), so the typed −0.5 stays in force —
  /// the earlier "signal-patched cold inlet → silent" reading was wrong, and the live test
  /// that seemed to confirm it fed a glass transient through a 60 Hz band-pass with no
  /// positive control (diagnosis doc, "Audio couplings"). Operator-tunable.
  public var wave2InputGain: Float = -0.5
```

Change `private var wave2Ring: WaveBuffer` to `private var wave2Ring: AveragingWaveBuffer`; change `private static let wave2Downsample = 512 // ...` to `private static let wave2Group = 512   // jit.catch~[214] downsample 512 (loadmess 512 → s wave2cmd)`; change `wave2Ring = WaveBuffer(capacity: Self.framesize)` to `wave2Ring = AveragingWaveBuffer(capacity: Self.framesize, group: Self.wave2Group)`; and in `frameValues()` change `let wave2Points = wave2Ring.strideDecimated(by: Self.wave2Downsample)` to `let wave2Points = wave2Ring.points()`.

- [ ] **Step 5: Run the audio tests, then the full suite**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter AudioAnalysisTests`
Expected: PASS.

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --skip GoldenFrameTests`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add app/Sources/FeedbaxKit/Audio/WaveBuffer.swift app/Sources/FeedbaxKit/Audio/AudioAnalysis.swift app/Tests/FeedbaxKitTests/AudioAnalysisTests.swift
git commit -m "fix(audio): wave 2 fed at -0.5 gain through 512-sample group averaging" -m "gswitch is a message object, so the *~ -0.5 argument on wave 2's input is live, not silenced by a signal-patched cold inlet. jit.catch~'s downsample 512 averages each group of 512 samples into one of 1024 cells (refpage), which is what keeps the ring near-circular under a 60 Hz band; the port's stride decimation to 2 points is replaced by that averaging." -m "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>" -m "Claude-Session: https://claude.ai/code/session_017i8dhZYNK8i8tpri3zRBS4"
```

---

### Task 5: Microphone status and input level in the HUD

**Files:**
- Modify: `app/Sources/FeedbaxKit/Audio/AudioAnalysis.swift` (`AudioBands` — add `inputRMS`, `decibels`; `AudioAnalysis` — guard + `statusText`)
- Modify: `app/Sources/FeedbaxKit/Engine/Engine.swift` (add `audioStatus`)
- Modify: `app/Sources/FeedbaxKit/UI/AppBootstrap.swift` (lines 88-89)
- Modify: `app/Sources/FeedbaxKit/Engine/OutputStage.swift` (`draw` signature; `updateHUDIfDue`; add `hudText`)
- Modify: `app/Sources/FeedbaxKit/UI/PreviewView.swift` (`renderFrame`, the `outputStage.draw(...)` call)
- Test: `app/Tests/FeedbaxKitTests/AudioAnalysisTests.swift`, Create: `app/Tests/FeedbaxKitTests/HUDTextTests.swift`

**Interfaces:**
- Produces: `AudioBands.inputRMS: Float` (last ingested batch, thread-safe read); `static AudioBands.decibels(_ rms: Float) -> Float`; `AudioAnalysis.statusText: String`; `enum AudioAnalysisError: Error { case noInputDevice }`; `Engine.audioStatus: String`; `static OutputStage.hudText(p50: Double, p99: Double, status: String?) -> String`; `OutputStage.draw(accumulator:into:commandBuffer:drawableSize:statusLine:)` with `statusLine: String? = nil`.

- [ ] **Step 1: Write the failing tests**

Create `app/Tests/FeedbaxKitTests/HUDTextTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

final class HUDTextTests: XCTestCase {
  func testHUDTextAppendsStatusLine() {
    XCTAssertEqual(OutputStage.hudText(p50: 0.001, p99: 0.0021, status: nil), "p50 1.0 ms   p99 2.1 ms")
    XCTAssertEqual(OutputStage.hudText(p50: 0.001, p99: 0.0021, status: "mic 44100 Hz   in -40 dB"),
                   "p50 1.0 ms   p99 2.1 ms   mic 44100 Hz   in -40 dB")
  }
}
```

In `app/Tests/FeedbaxKitTests/AudioAnalysisTests.swift`, add inside the class:

```swift
  func testInputRMSTracksTheLastIngestedBatch() {
    let bands = AudioBands(sampleRate: 48000)
    XCTAssertEqual(bands.inputRMS, 0)
    bands.ingest(sine(440, seconds: 0.5, sampleRate: 48000, amplitude: 0.5))
    XCTAssertEqual(bands.inputRMS, 0.5 / sqrt(2), accuracy: 0.005, "RMS of a 0.5-amplitude sine")
    bands.ingest([Float](repeating: 0, count: 1024))
    XCTAssertEqual(bands.inputRMS, 0)
  }
  func testDecibelsFloorAtMinus90() {
    XCTAssertEqual(AudioBands.decibels(0.01), -40, accuracy: 0.01)
    XCTAssertEqual(AudioBands.decibels(1), 0, accuracy: 0.01)
    XCTAssertEqual(AudioBands.decibels(0), -90)
    XCTAssertEqual(AudioBands.decibels(1e-9), -90)
  }
```

- [ ] **Step 2: Run to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter "HUDTextTests|AudioAnalysisTests"`
Expected: compile errors — `hudText`, `inputRMS`, `decibels` undefined.

- [ ] **Step 3: Add the level and status plumbing**

`app/Sources/FeedbaxKit/Audio/AudioAnalysis.swift`, inside `AudioBands`:

After `private var kittyBumpCount: Int = 0` add:

```swift
  /// RMS of the most recent `ingest` batch (~23 ms at a 1024-sample tap) — the HUD's input
  /// meter. The app has no other way to tell "no audio arrives" from "the ring is static".
  private var lastInputRMS: Float = 0
  public var inputRMS: Float {
    lock.lock(); defer { lock.unlock() }
    return lastInputRMS
  }

  /// dBFS of an RMS level, floored at −90 dB (silence).
  public static func decibels(_ rms: Float) -> Float {
    guard rms > 0 else { return -90 }
    return max(-90, 20 * log10(rms))
  }
```

At the top of `ingest`, directly after `defer { lock.unlock() }`, add:

```swift
    if !samples.isEmpty {
      var sumSq: Float = 0
      for s in samples { sumSq += s * s }
      lastInputRMS = sqrt(sumSq / Float(samples.count))
    }
```

Inside `AudioAnalysis` (the class after `KittyBumpReceiver`): add before `public var inputGain`:

```swift
  /// What the HUD shows for the capture: the tap's format once started, or why it isn't.
  public private(set) var statusText = "mic: not started"
```

and replace the body of `start()` with:

```swift
    guard !isRunning else { return }
    let input = engine.inputNode
    let format = input.inputFormat(forBus: tapBus)
    // A 0-channel/0 Hz format means no input device; `installTap` with it raises an ObjC
    // exception (a crash, not a thrown error), so refuse up front.
    guard format.channelCount > 0, format.sampleRate > 0 else {
      statusText = "mic: no input device"
      throw AudioAnalysisError.noInputDevice
    }
    input.installTap(onBus: tapBus, bufferSize: 1024, format: format) { [weak self] buffer, _ in
      self?.handle(buffer)
    }
    try engine.start()
    isRunning = true
    statusText = "mic \(Int(format.sampleRate)) Hz ×\(format.channelCount)"
```

After the `AudioAnalysis` class add:

```swift
public enum AudioAnalysisError: Error {
  case noInputDevice
}
```

`app/Sources/FeedbaxKit/Engine/Engine.swift` — directly after the `warpFilter` property (Task 1) add:

```swift
  /// One-line capture status for the HUD, set by whoever starts `AudioAnalysis`
  /// (`AppBootstrap`). Not engine state — the engine never touches the microphone.
  public var audioStatus = "mic: not started"
```

`app/Sources/FeedbaxKit/UI/AppBootstrap.swift` — replace

```swift
    let audioAnalysis = try? AudioAnalysis(bands: engine.bands)
    try? audioAnalysis?.start()
```

with

```swift
    let audioAnalysis = try? AudioAnalysis(bands: engine.bands)
    do {
      try audioAnalysis?.start()
      engine.audioStatus = audioAnalysis?.statusText ?? "mic: unavailable"
    } catch {
      // A missing device or a denied permission must be VISIBLE (HUD), not a silent instrument.
      engine.audioStatus = "mic FAILED: \(error.localizedDescription)"
    }
```

`app/Sources/FeedbaxKit/Engine/OutputStage.swift`:

Change the `draw` signature to

```swift
  public func draw(accumulator: MTLTexture, into drawable: CAMetalDrawable,
                   commandBuffer: MTLCommandBuffer, drawableSize: SIMD2<Int>,
                   statusLine: String? = nil) {
```

change `updateHUDIfDue()` (the call inside `draw`) to `updateHUDIfDue(statusLine: statusLine)`, change its declaration to `private func updateHUDIfDue(statusLine: String?)`, and replace `let text = String(format: "p50 %.1f ms   p99 %.1f ms", p50 * 1000, p99 * 1000)` with `let text = OutputStage.hudText(p50: p50, p99: p99, status: statusLine)`. Add, next to `percentiles`:

```swift
  /// The HUD line: frame-time percentiles plus an optional status (mic capture, input level).
  /// Pure so it needs no GPU to test.
  static func hudText(p50: Double, p99: Double, status: String?) -> String {
    let timing = String(format: "p50 %.1f ms   p99 %.1f ms", p50 * 1000, p99 * 1000)
    guard let status, !status.isEmpty else { return timing }
    return timing + "   " + status
  }
```

`app/Sources/FeedbaxKit/UI/PreviewView.swift` — in `renderFrame`, replace

```swift
    outputStage.draw(accumulator: accumulator, into: update.drawable, commandBuffer: commandBuffer,
                     drawableSize: drawableSize)
```

with

```swift
    let inputDB = Int(AudioBands.decibels(engine.bands.inputRMS).rounded())
    outputStage.draw(accumulator: accumulator, into: update.drawable, commandBuffer: commandBuffer,
                     drawableSize: drawableSize,
                     statusLine: "\(engine.audioStatus)   in \(inputDB) dB")
```

- [ ] **Step 4: Run the tests and the full suite**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --skip GoldenFrameTests`
Expected: PASS.

- [ ] **Step 5: Build the dev executable to be sure the UI target compiles**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift build --package-path app --product feedbax-dev`
Expected: `Build complete!`

- [ ] **Step 6: Commit**

```bash
git add app/Sources/FeedbaxKit/Audio/AudioAnalysis.swift app/Sources/FeedbaxKit/Engine/Engine.swift app/Sources/FeedbaxKit/UI/AppBootstrap.swift app/Sources/FeedbaxKit/Engine/OutputStage.swift app/Sources/FeedbaxKit/UI/PreviewView.swift app/Tests/FeedbaxKitTests/AudioAnalysisTests.swift app/Tests/FeedbaxKitTests/HUDTextTests.swift
git commit -m "feat(app): show microphone status and input level in the HUD" -m "AudioAnalysis.start() was swallowed by try?, and nothing displayed a level, so a silent instrument was indistinguishable from an unresponsive one. The HUD now shows the tap's format (or the failure) and the last batch's dBFS; a 0-channel input is refused instead of crashing in installTap." -m "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>" -m "Claude-Session: https://claude.ai/code/session_017i8dhZYNK8i8tpri3zRBS4"
```

---

### Task 6: Fader readouts in the Max panel's convention

**Files:**
- Modify: `app/Sources/FeedbaxKit/UI/EngineViewModel.swift` (add `maxPanelValue(for:raw:)` next to `range(for:)`)
- Modify: `app/Sources/FeedbaxKit/UI/OperatorPanel.swift` (`slider(_:slot:)` at the bottom of the file; the TRANSPARANCY row)
- Test: `app/Tests/FeedbaxKitTests/EngineViewModelTests.swift`

**Interfaces:**
- Produces: `static EngineViewModel.maxPanelValue(for slot: ControlSlot, raw: Double) -> Double`.

- [ ] **Step 1: Write the failing test**

In `app/Tests/FeedbaxKitTests/EngineViewModelTests.swift`, add inside the class:

```swift
  /// The webUI faders are `slider` widgets with `size 2, min −1` (BRIGHTNESS, HUE-SHIFT, ZOOM,
  /// rotate) or `size 1` (SATURATION); their number boxes show the INTERNAL value, so Max's
  /// "BRIGHTNESS 1." is raw 0.0 and "HUE 1.1" is raw 0.1. rotate is negated on its way into
  /// slot 6 (`* -1.`). (diagnosis doc, "The control vector actually in the screenshots")
  func testMaxPanelValueConvention() {
    XCTAssertEqual(EngineViewModel.maxPanelValue(for: .bias, raw: 0), 1.0, accuracy: 1e-9)
    XCTAssertEqual(EngineViewModel.maxPanelValue(for: .hue, raw: 0.1), 1.1, accuracy: 1e-9)
    XCTAssertEqual(EngineViewModel.maxPanelValue(for: .zoom, raw: -0.25), 0.75, accuracy: 1e-9)
    XCTAssertEqual(EngineViewModel.maxPanelValue(for: .theta, raw: 0.26092), 0.73908, accuracy: 1e-6)
    XCTAssertEqual(EngineViewModel.maxPanelValue(for: .saturation, raw: 0.5), 0.5, accuracy: 1e-9)
  }
```

- [ ] **Step 2: Run to verify it fails**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter EngineViewModelTests/testMaxPanelValueConvention`
Expected: compile error — no member `maxPanelValue`.

- [ ] **Step 3: Implement and show it**

`app/Sources/FeedbaxKit/UI/EngineViewModel.swift` — directly after `range(for:)` add:

```swift
  /// The number the original's panel shows for a slot. Its faders are `slider` widgets with
  /// `size 2, min −1` (raw = internal − 1) except SATURATION (`size 1`, raw = internal); the
  /// rotate fader is negated into slot 6 by `* -1.`, so its reading is `1 − raw`. Shown next
  /// to each slider so "the same settings as Max" can be dialled in by number
  /// (docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md).
  public static func maxPanelValue(for slot: ControlSlot, raw: Double) -> Double {
    switch slot {
    case .saturation: return raw
    case .theta: return 1 - raw
    default: return raw + 1
    }
  }
```

`app/Sources/FeedbaxKit/UI/OperatorPanel.swift` — replace the `slider(_:slot:)` function with:

```swift
  private func slider(_ label: String, slot: ControlSlot) -> some View {
    let raw = vm.sliderValues[slot] ?? 0
    return LabeledContent(label) {
      HStack(spacing: 8) {
        Slider(
          value: Binding(get: { vm.sliderValues[slot] ?? 0 }, set: { vm.slider(slot, changedTo: $0) }),
          in: EngineViewModel.range(for: slot)
        )
        // The original panel's reading for this fader (its number boxes show the slider's
        // internal value, not the sent one) — see EngineViewModel.maxPanelValue.
        Text(String(format: "%.2f", EngineViewModel.maxPanelValue(for: slot, raw: raw)))
          .monospacedDigit()
          .foregroundStyle(.secondary)
          .frame(width: 44, alignment: .trailing)
      }
    }
  }
```

and in the TRANSPARANCY row, wrap its `Slider` the same way (its Max reading is the raw value):

```swift
          LabeledContent("TRANSPARANCY") {
            HStack(spacing: 8) {
              Slider(value: Binding(get: { vm.eraseValue }, set: { vm.setErase($0) }), in: 0...1)
              Text(String(format: "%.2f", vm.eraseValue))
                .monospacedDigit()
                .foregroundStyle(.secondary)
                .frame(width: 44, alignment: .trailing)
            }
          }
```

- [ ] **Step 4: Run the tests and build the executable**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter EngineViewModelTests`
Expected: PASS.

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift build --package-path app --product feedbax-dev`
Expected: `Build complete!`

- [ ] **Step 5: Commit**

```bash
git add app/Sources/FeedbaxKit/UI/EngineViewModel.swift app/Sources/FeedbaxKit/UI/OperatorPanel.swift app/Tests/FeedbaxKitTests/EngineViewModelTests.swift
git commit -m "feat(ui): show each fader's reading in the original panel's convention" -m "Max's webUI number boxes show the slider's internal 0..2 value (BRIGHTNESS 1. = raw 0, HUE 1.1 = raw 0.1, rotate negated), which made 'the same settings' hard to reproduce by hand. Each slider now shows that reading beside it." -m "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>" -m "Claude-Session: https://claude.ai/code/session_017i8dhZYNK8i8tpri3zRBS4"
```

---

### Task 7: Spec corrections and diagnosis status

**Files:**
- Modify: `docs/spec/03-audio-analysis-and-waveforms.md` (insert after the title line)
- Modify: `docs/spec/01-render-loop-and-shader-chain.md` (insert after the title line)
- Modify: `docs/spec/04-control-surfaces-and-utilities.md` (insert after the title line)
- Modify: `docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md` (the `**Status:**` line)

- [ ] **Step 1: Insert the corrections blocks**

Directly below the first line (the `# ...` title) of `docs/spec/03-audio-analysis-and-waveforms.md` insert:

```markdown

> **Corrections (2026-08-24, evening; evidence in
> `docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md`):**
> * §5 line "radial … toggle[241] → prepend radial[239] (forced)" and the §8/§10 rows that
>   repeat it: that chord goes to **obj-213 (waveform 2)**, not obj-12. Waveform 1 is a
>   **linear** graph (`line_width 12`, `scale 1.5 1 0`, `position 0 −0.85 0`); waveform 2 is
>   the **ring** (`radial 1`, `radialradius 0.7` from `loadmess 0.7 → slider[329]`,
>   `line_width 4`, `position 0 0 −2`).
> * Waveform 2 **draws at load**: `soundwave_enable1` (the "Circle" box) has no loadmess and
>   `jit.gl.graph` enables by default. Its base alpha is 0.8 (`loadmess 0.8 → slider[338]`).
> * §3: `gswitch`[126] is a **message** object (refpage inlets `bang/int`), so `*~ -0.5`[128]'s
>   cold inlet is not signal-rate and the −0.5 argument is in force; wave 2 is not structurally
>   silent. `downsample 512` (`loadmess 512 → s wave2cmd`) **averages** each group of 512
>   samples (jit.catch~ refpage), so the 60 Hz band is nearly flattened — the ring is
>   near-static for that reason.
> * §7a: `worldBump`'s multiplier is `* 0.8` with its right inlet set by `loadmess 0.05` →
>   effective **0.05**; gated by toggle[15] `wordBumpEn` (no saved state → off).
```

Directly below the title line of `docs/spec/01-render-loop-and-shader-chain.md` insert:

```markdown

> **Corrections (2026-08-24, evening; evidence in
> `docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md`):**
> * §5 "saturation and lightness … would clip/desaturate at the extremes": **not so.**
>   Jitter's reference `cc.hsl2rgb.jxs` converts the raw S/L (`v2 = L·(1+S)`); the char
>   texture clips each RGB channel afterwards. Above S = 1 that pair is a multiplicative gain
>   of (1 + δ/2) per frame on the max channel — the SATURATION fader's real effect.
> * §1/§4: the loop's resample filter is a first-order term of the look. Sean's `fst` was
>   `@filter none` (nearest); a bilinear loop forgets a 12-px seed in ~15 generations, a
>   nearest loop keeps it ~250. The retrofit node's capture-texture filter is still to be
>   read off the running patch.
```

Directly below the title line of `docs/spec/04-control-surfaces-and-utilities.md` insert:

```markdown

> **Correction (2026-08-24, evening):** the webUI faders `slider[2]` BRIGHTNESS, `slider[5]`
> HUE-SHIFT, `slider[8]` ZOOM and `slider[7]` rotate are `size 2, min −1` widgets: the value
> SENT is `internal − 1`, and the number boxes / `parameter_initial` values (1., 1.1, 0.75,
> 0.739) are internal. So the reset burst sets BRIGHTNESS → raw 0.0 and HUE-SHIFT → raw 0.1
> (not out-of-range), and ZOOM 0.75 / rotate 0.739 are raw −0.25 / +0.261 (before rotate's
> `* -1.`), matching the measured startup vector. SATURATION and TRANSPARANCY are `size 1`.
```

- [ ] **Step 2: Update the diagnosis status line**

In `docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md` replace the `**Status:**` line with:

```markdown
**Status:** fixes applied per `docs/superpowers/plans/2026-08-24-dynamism-gap-fixes.md`
(nearest resample, unclamped HSL, waveform geometry, wave-2 input, HUD mic status, fader
readouts). Still owed: the three Max-side measurements below, and a like-for-like visual
check of the dev build against the two screenshots at the measured vector.
```

- [ ] **Step 3: Commit**

```bash
git add docs/spec/03-audio-analysis-and-waveforms.md docs/spec/01-render-loop-and-shader-chain.md docs/spec/04-control-surfaces-and-utilities.md docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md
git commit -m "docs(spec): correct waveform geometry, HSL clamp, gswitch, and fader-value conventions" -m "Records the misreads the dynamism-gap diagnosis found: the radial chain belongs to waveform 2 (which draws at load), gswitch is a message object, downsample averages, worldBump's multiplier is 0.05, HSL is unclamped, the resample filter is a first-order term, and the webUI faders send internal-1." -m "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>" -m "Claude-Session: https://claude.ai/code/session_017i8dhZYNK8i8tpri3zRBS4"
```
