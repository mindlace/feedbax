# Feedbax P1 — Parity Instrument Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build Feedbax.app P1 — a Swift+Metal macOS app that reproduces the documented look and feel of Sean Stevens' Max/Jitter feedback instrument for the solo performer in picture/movie mode, with keyboard/trackpad/gamepad control, mic-driven waveforms and bumps, presets, still capture, and a golden-frame parity harness.

**Architecture:** All logic lives in a Swift Package (`FeedbaxKit`) so `swift test` drives TDD headlessly; a thin `feedbax-dev` executable runs the windowed app during development, and a final XcodeGen-generated Xcode project wraps the same package into a signed `Feedbax.app`. Every shader is implemented twice: once as a pure-Swift CPU reference (unit-tested against hand-computed values from the spec) and once in Metal (parity-tested against the CPU reference). The engine renders one canvas into a ping-pong accumulator pair; layers and waveforms draw under, the warped previous frame blends over with `(SRC_ALPHA, DST_ALPHA)`.

**Tech Stack:** Swift 5.10+, Metal, MetalKit, simd, AVFoundation (movie playback), AVAudioEngine + vDSP (mic), GameController, SwiftUI (operator UI), Swift Package Manager, XcodeGen (app bundle), XCTest.

**Spec:** `docs/superpowers/specs/2026-08-23-feedbax-reimplementation-design.md` (the design this plan implements) and `docs/spec/` (behavioral source of truth — where this plan quotes a constant, the citation is to those files; where they disagree, `docs/spec/` wins).

## Global Constraints

- **Minimum deployment target: macOS 14 (Sonoma)** (design §3).
- **Package layout:** everything under `app/` — `app/Package.swift`, sources in `app/Sources/FeedbaxKit/{Engine,ShaderMath,Shaders,Sources,Control,Audio,UI}/`, tests in `app/Tests/FeedbaxKitTests/`. (The design §8 folder sketch maps onto SPM's `Sources/<target>/` convention.)
- **Accumulator: `rgba8Unorm` by default**; all filter-chain intermediates `rgba16Float` so unclamped stages (brcosa) carry out-of-range values (design §5).
- **Erase α = 0.8 + 0.2·t³, clamped [0.8, 1.0], NEVER smoothed** (spec §01 §2; design fidelity checklist #4).
- **Feedback plane blend = `(.sourceAlpha, .destinationAlpha)`** for RGB and alpha alike — not alpha-over (spec §01 §3).
- **All 7 live control slots ramp over `controlSmoothMs` = 100 ms at `lineSmoothGrain` = 4 ms grain** (spec §01 §0, §04 §5); toggles are discrete events that bypass the ramp.
- **No LFOs, no idle animation, no auto-drift** (design checklist #14).
- **Output brcosa stage omitted** — the v1 output chain is `rota-fold → HSL` only (design decision #13). `BrcosaFilter` exists solely as a `TextureFilter` (camera chain in P3; golden scenarios attach it to a movie layer in P1).
- **Teach-style code** (design §3): small modules, doc comments that explain *why* a constant or ordering exists (citing spec §), no cleverness. This is a review convention for every task.
- **Conventional Commits** for every commit. All work stays in the current worktree.
- **Run tests with:** `swift test --package-path app` (append `--filter <TestClassName>` for one class). Expected-fail steps mean the *new* test fails; previously-passing tests must stay green.

## Verbatim constants (single source — tasks refer here as "Constants table")

| Name | Value | Source |
|---|---|---|
| Startup control vector (9 floats, slots 0–8) | `[0.011905, 0.392857, 0.755952, -0.354023, -0.5, -0.634044, 0.281234, 0.0, 0.71131]` | spec §04 §1.1 (webui loadbang) |
| HSL pix param defaults (before first vector arrives) | hue_shift 0.02, saturation 0.5, lightness 0.5 | spec §01 §4 |
| Erase control default `t` | 1.0 (webui TRANSPARANCY slider persisted 1.0 → α = 1.0, hard clear until moved) | spec §04 §1.4 |
| Slot 0 hue map | `maxScale(in, -1, 1, -0.05, 0.05, exp: 0.1)` → smooth | spec §01 §4 |
| Slot 1 bias map | `maxScale(in, -1, 1, -0.04, 0.02, exp: 0.05)` → smooth | spec §01 §4 |
| Slot 3/4 pan map | `in × SInvert` → `maxScale(·, -1, 1, -2000, 2000)` px → smooth | spec §01 §4 |
| Slot 5 zoom map | `maxScale(in, -1, 1, 0.4, 1.2)` → smooth → `× SInvert` | spec §01 §4 |
| Slot 6 theta map | `maxScale(in, -1, 1, +π, -π)` (reversed) → smooth | spec §01 §4 |
| Slot 8 sat map | `maxScale(in, 0, 1, -0.05, 0.05, exp: 0.1)` → smooth | spec §01 §4 |
| Erase map | `maxScale(t, 0, 1, 0.8, 1.0, exp: 3)`, no smoothing | spec §01 §2 |
| SInvert | +1 when toggle off (default), −1 when on | spec §01 §4 |
| Rota anchor | (0.5, 0.5), static | spec §01 §4 |
| Fold | mirror-repeat, period 2×size (boundmode 4) | spec §01 §4 |
| Videoplane | scale (+1.78·aspectMultiplier, 1, 1) — NOT mirrored; position (0, 0, −0.414 + worldBump); color (1,1,1,1) | spec §01 §3 |
| Jitter camera equivalence | camera at (0,0,2), lens 45°: half-height at distance d = d·tan(22.5°); at plane z=−0.414, d=2.414 → half-height exactly 1.0 | derived; spec §01 §3 |
| brcosa | Rec.709 luma (0.2125, 0.7154, 0.0721); contrast pivot 0.62 gray; unclamped; alpha passthrough from ORIGINAL input | spec §01 §4 |
| Camera brcosa dial defaults (P1: used only in golden scenarios) | brightness 1.55, contrast 1.55, saturation 1.5, gate default OFF | spec §02 §7.2 |
| Luma keyer | `lumcoeff = (0.299, 0.587, 0.114, 0)`; two-pass cascade: high pass luma=1.0 tol=0.2 fade=0.1, low pass luma=0.0 tol=0.15 fade=0.1; binary=1, invert=0, mode=0 | spec §02 §7.4, §8 |
| Chroma keyer | HSV distance weights (4, 1, 2); defaults tol 0.2, fade 0.2, color (0.328129, 0.144197, 0.0) | spec §02 §7.4, §8 |
| EQ bands (freq Hz / Q / gain) | wave1+bumps: 46.7 / 0.92 / 1.02 · wave2: 60.0 / 2.05 / 0.90 · worldBump: 144.3 / 1.77 / 0.71 | spec §03 §3 |
| worldBump chain | abs → slide~ 2500/2500 (samples) → average~ "absolute" (100-sample window) → per-frame snapshot → × 0.05 → Z offset on videoplane | spec §03 §7a |
| waveBump chain | 46.7 Hz band × 2.2 → mean-since-last-frame → wave2 alpha = base + value, unclamped | spec §03 §7b, §6 |
| kittyBump chain | 46.7 Hz band → mean-since-last-frame → abs → slide 22/14 (per-update) → ADDS to sticker layer zoom (zx, zy) and Y placement | spec §03 §7c, §04 §1.3 |
| Bump enables | all three default OFF | spec §03 §7 |
| Wave 1 | radial, position (0,−0.85,0), scale (1.5,1,0), line_width 12, solid, blend (srcα, 1−srcα), color hue1 = (0.392375, 0.23808, 0, 1) burnt orange, alpha 0.8 | spec §03 §5–6 |
| Wave 2 | position (0,0,−2), scale (1,1,1), dotted (points, circpoints 5), blend (srcα, dstα), color hue2 = (0, 0.786722, 0.821229, 1) cyan, alpha = base + waveBump | spec §03 §5–6 |
| Wave buffers | framesize 1024; wave1 downsample 2 + jit.slide up 8 / down 3; wave2 downsample 512 [?] — see Task 25 | spec §03 §4 |
| Wave 2 default input | most likely near-silent (checklist #15) — default input gain 0.0 until Task 25 verifies | spec §03 §3 |
| FPS presets | 30 / 60 / 90 / 100 / 120 (five), default 60 | spec §01 §1 |
| Resolution presets | 1024×768, 1280×720, 1280×800, 1366×1024, 1920×1080 (default), 2560×1080, 2560×1440, 2560×1600, 2880×1620, 3440×1440, 3840×2160, 5120×1440, 7680×4320, 8192×8192, custom | spec §01 §1 |
| Sticker folder | `<repo>/input/transparent-background/`, types PNG/GIF/TIFF/BMP/PICT + movie containers | spec §02 §1 |
| imageMove maps | x: centroid `maxScale(·, 0.1, 0.9, -1.7, 1.7)`; y: `maxScale(·, 0, 1, 1, -1)`; pic-size slider default 0.747; pic-rotate −1..1 → +210..−210 degrees; x/y/zx/zy/r all smoothed | spec §02 §4, §04 §1.3, §7 |
| Layer enable | explicit OR of the two enable sources (bug fix, design §6) | spec §02 §4 |
| `maxScale(in, lo, hi, lo2, hi2, exp)` | `f = (in−lo)/(hi−lo)` (NOT clamped); `out = lo2 + (hi2−lo2) · sign(f)·|f|^exp` | spec §01 §2 formula; signed-pow extension for out-of-domain inputs is our documented choice (spec §01 open q. 6) — flagged for parity review |
| Golden-frame compare | max channel delta ≤ 2/255 on ≥ 99.9 % of pixels, references per pinned OS/hardware baseline | design §9 |
| Still capture | key-bound PNG of the accumulator at canvas resolution → `~/Pictures/Feedbax/` | design §10 |

## File Structure (what exists when P1 is done)

```
app/
  Package.swift
  project.yml                          # XcodeGen spec for Feedbax.app (Task 23)
  Sources/
    FeedbaxKit/
      Engine/
        FrameContext.swift             # FrameContext, TexturePool
        MetalContext.swift             # device, queue, library, readback helpers
        FeedbackCore.swift             # erase pass, warp pass, feedback composite, ping-pong
        Compositor.swift               # Jitter-default projection, layer quads, draw order
        WaveformRenderer.swift         # radial/linear polyline + point rendering
        OutputStage.swift              # CAMetalLayer viewport, fullscreen, HUD
        FrameClock.swift               # CAMetalDisplayLink wrapper + injectable test clock
        StillCapture.swift
        GoldenRunner.swift             # scenario runner (also used by tests)
      ShaderMath/                      # CPU reference — pure functions, no Metal
        MaxScale.swift
        RotaFold.swift
        HSL.swift
        Brcosa.swift
        Keyers.swift
      Shaders/                         # .metal, compiled into the package's metallib
        WarpHSL.metal
        Filters.metal                  # brcosa, luma key, chroma key
        Composite.metal                # erase quad, textured quad, waveform ribbon/points
      Sources/
        SeedSource.swift               # protocol + LayerTransform/LayerSettings
        StickerSource.swift
        MovieSource.swift
      Control/
        ControlVector.swift            # ControlSlot, ControlWrite, ToggleEvent
        ControlRouter.swift            # maps, ramps, SInvert, erase path, diff
        LinearRamp.swift
        Bindings.swift                 # bindings-table JSON load
        KeyboardTrackpadSurface.swift
        GamepadSurface.swift
        Presets.swift
        DefaultBindings.json           # resource
      Audio/
        Biquad.swift
        EnvelopeFollowers.swift        # slide~, average~, avg~, the three bumps
        AudioAnalysis.swift            # AVAudioEngine tap → bands → per-frame values
        WaveBuffer.swift               # jit.catch~/jit.slide equivalents
      Filters/
        TextureFilter.swift            # protocol + FilterChain
        BrcosaFilter.swift
        LumaKeyFilter.swift
        ChromaKeyFilter.swift
      UI/
        OperatorPanel.swift            # SwiftUI sliders/toggles/pickers
        EngineViewModel.swift
        PreviewView.swift              # NSViewRepresentable hosting the CAMetalLayer
    feedbax-dev/
      main.swift                       # NSApplication bootstrap + --soak mode (Task 24)
  Tests/
    FeedbaxKitTests/
      ... one test file per task (named in each task) ...
      GoldenReferences/                # committed reference PNGs (Task 22)
```

Design rules carried from the design doc: sources produce **raw** imagery (filters live in the chain); filters render into pool-leased `rgba16Float` textures valid for the current frame only, and the **chain** owns the leases; modulator offsets are additive, outside the ramp, never part of surface arbitration.

---
### Task 1: Package scaffold, FrameContext, TexturePool

**Files:**
- Create: `app/Package.swift`
- Create: `app/Sources/FeedbaxKit/Engine/FrameContext.swift`
- Create: `app/Sources/feedbax-dev/main.swift` (placeholder)
- Create: `app/Sources/FeedbaxKit/Shaders/Placeholder.metal` (so the resource pipeline exists from day one)
- Test: `app/Tests/FeedbaxKitTests/TexturePoolTests.swift`

**Interfaces:**
- Consumes: nothing (first task).
- Produces: `struct FrameContext { let index: Int; let time: TimeInterval; let delta: TimeInterval; let canvasSize: SIMD2<Int>; let commandBuffer: MTLCommandBuffer; let pool: TexturePool }`; `final class TexturePool { init(device: MTLDevice); func lease(width: Int, height: Int, format: MTLPixelFormat, usage: MTLTextureUsage) -> MTLTexture; func endFrame() }`. Every later task takes these as given.

- [ ] **Step 1: Create the package manifest and placeholder sources**

`app/Package.swift`:

```swift
// swift-tools-version: 5.10
import PackageDescription

let package = Package(
  name: "Feedbax",
  platforms: [.macOS(.v14)],  // subject lifting + CAMetalDisplayLink floor (design §3)
  targets: [
    .target(
      name: "FeedbaxKit",
      resources: [.process("Shaders"), .copy("Control/DefaultBindings.json")]
    ),
    .executableTarget(name: "feedbax-dev", dependencies: ["FeedbaxKit"]),
    .testTarget(
      name: "FeedbaxKitTests",
      dependencies: ["FeedbaxKit"],
      resources: [.copy("GoldenReferences")]
    ),
  ]
)
```

`app/Sources/FeedbaxKit/Shaders/Placeholder.metal`:

```metal
#include <metal_stdlib>
using namespace metal;
// Placeholder so SwiftPM builds a metallib for this package from the first commit.
kernel void fbx_noop(uint2 gid [[thread_position_in_grid]]) {}
```

`app/Sources/feedbax-dev/main.swift`:

```swift
print("feedbax-dev placeholder — windowed app arrives in Task 19")
```

Also create `app/Sources/FeedbaxKit/Control/DefaultBindings.json` containing `{"version": 1}` (fleshed out in Task 13) and `app/Tests/FeedbaxKitTests/GoldenReferences/.gitkeep`.

- [ ] **Step 2: Write the failing test**

`app/Tests/FeedbaxKitTests/TexturePoolTests.swift`:

```swift
import XCTest
import Metal
@testable import FeedbaxKit

final class TexturePoolTests: XCTestCase {
  func testLeaseReusesReturnedTexturesAcrossFrames() throws {
    let device = try XCTUnwrap(MTLCreateSystemDefaultDevice())
    let pool = TexturePool(device: device)
    let a = pool.lease(width: 64, height: 64, format: .rgba16Float, usage: [.shaderRead, .renderTarget])
    let b = pool.lease(width: 64, height: 64, format: .rgba16Float, usage: [.shaderRead, .renderTarget])
    XCTAssertFalse(a === b, "two live leases in one frame must be distinct textures")
    pool.endFrame()
    let c = pool.lease(width: 64, height: 64, format: .rgba16Float, usage: [.shaderRead, .renderTarget])
    XCTAssertTrue(c === a || c === b, "after endFrame the pool must recycle, not allocate")
    let d = pool.lease(width: 32, height: 32, format: .rgba16Float, usage: [.shaderRead, .renderTarget])
    XCTAssertEqual(d.width, 32, "mismatched size must produce a fresh correctly-sized texture")
  }
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `swift test --package-path app --filter TexturePoolTests`
Expected: FAIL — `TexturePool` not defined (compile error).

- [ ] **Step 4: Implement FrameContext + TexturePool**

`app/Sources/FeedbaxKit/Engine/FrameContext.swift`:

```swift
import Metal

/// Per-frame context handed to every SeedSource/TextureFilter/ControlSurface/Modulator
/// (design §5). `time`/`delta` are injectable so tests and golden runs use a fixed clock.
public struct FrameContext {
  public let index: Int
  public let time: TimeInterval
  public let delta: TimeInterval
  public let canvasSize: SIMD2<Int>
  public let commandBuffer: MTLCommandBuffer
  public let pool: TexturePool

  public init(index: Int, time: TimeInterval, delta: TimeInterval,
              canvasSize: SIMD2<Int>, commandBuffer: MTLCommandBuffer, pool: TexturePool) {
    self.index = index; self.time = time; self.delta = delta
    self.canvasSize = canvasSize; self.commandBuffer = commandBuffer; self.pool = pool
  }
}

/// Frame-scoped texture recycling. Leases are valid for the current frame only; the
/// filter CHAIN owns its leases (design §5) — at 8K one rgba16Float surface is ~254 MB,
/// so per-filter allocation would be ruinous.
public final class TexturePool {
  private struct Key: Hashable { let w: Int, h: Int, format: MTLPixelFormat.RawValue, usage: MTLTextureUsage.RawValue }
  private let device: MTLDevice
  private var free: [Key: [MTLTexture]] = [:]
  private var inFlight: [(Key, MTLTexture)] = []

  public init(device: MTLDevice) { self.device = device }

  public func lease(width: Int, height: Int, format: MTLPixelFormat, usage: MTLTextureUsage) -> MTLTexture {
    let key = Key(w: width, h: height, format: format.rawValue, usage: usage.rawValue)
    let tex: MTLTexture
    if let recycled = free[key]?.popLast() {
      tex = recycled
    } else {
      let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: format, width: width, height: height, mipmapped: false)
      d.usage = usage
      d.storageMode = .private
      tex = device.makeTexture(descriptor: d)!
    }
    inFlight.append((key, tex))
    return tex
  }

  /// Return every lease to the free lists. Call once per frame after the command buffer commits.
  public func endFrame() {
    for (key, tex) in inFlight { free[key, default: []].append(tex) }
    inFlight.removeAll(keepingCapacity: true)
  }
}
```

Note: the test leases with `storageMode .private`; tests that need CPU readback later use MetalContext helpers (Task 6), never pooled textures directly.

- [ ] **Step 5: Run test to verify it passes**

Run: `swift test --package-path app --filter TexturePoolTests`
Expected: PASS (also proves the package + metallib resource pipeline builds).

- [ ] **Step 6: Commit**

```bash
git add app
git commit -m "feat(engine): SPM scaffold with FrameContext and frame-scoped TexturePool"
```

---

### Task 2: CPU reference — Max scale, rota warp, mirror fold

**Files:**
- Create: `app/Sources/FeedbaxKit/ShaderMath/MaxScale.swift`
- Create: `app/Sources/FeedbaxKit/ShaderMath/RotaFold.swift`
- Test: `app/Tests/FeedbaxKitTests/RotaFoldTests.swift`

**Interfaces:**
- Consumes: nothing.
- Produces: `func maxScale(_ x: Float, _ lo: Float, _ hi: Float, _ lo2: Float, _ hi2: Float, exp: Float = 1) -> Float`; `func glslMod(_ x: SIMD2<Float>, _ y: SIMD2<Float>) -> SIMD2<Float>`; `func fold(_ p: SIMD2<Float>, size: SIMD2<Float>) -> SIMD2<Float>`; `func rotaSource(point: SIMD2<Float>, size: SIMD2<Float>, zoom: Float, theta: Float, offset: SIMD2<Float>, anchor: SIMD2<Float>) -> SIMD2<Float>` (returns the FOLDED source-pixel coordinate). Tasks 7, 10, 11 use these names exactly.

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/RotaFoldTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

final class RotaFoldTests: XCTestCase {
  // maxScale: erase example from spec §01 §2 — scale 0 1. 0.8 1. 3. → 0.8 + 0.2·t³
  func testMaxScaleEraseCurve() {
    XCTAssertEqual(maxScale(0.5, 0, 1, 0.8, 1.0, exp: 3), 0.825, accuracy: 1e-4)
    XCTAssertEqual(maxScale(0.9, 0, 1, 0.8, 1.0, exp: 3), 0.9458, accuracy: 1e-3)
    XCTAssertEqual(maxScale(1.0, 0, 1, 0.8, 1.0, exp: 3), 1.0, accuracy: 1e-6)
  }
  func testMaxScaleLinearAndReversed() {
    // theta map: scale(-1,1 → +π,−π) — reversed hi/lo (spec §01 §4)
    XCTAssertEqual(maxScale(1, -1, 1, .pi, -.pi), -.pi, accuracy: 1e-6)
    XCTAssertEqual(maxScale(-1, -1, 1, .pi, -.pi), .pi, accuracy: 1e-6)
    XCTAssertEqual(maxScale(0, -1, 1, 0.4, 1.2), 0.8, accuracy: 1e-6)  // zoom center
  }
  func testMaxScaleDoesNotClip() {
    // Max's scale extrapolates beyond lo/hi (spec §01 §4 note) — out-of-domain input must not clamp.
    XCTAssertEqual(maxScale(2, -1, 1, -2000, 2000), 4000, accuracy: 1e-3)
  }

  // fold: period-2·size reflection (spec §01 §4, boundmode 4). Hand-computed, size = 100:
  func testFoldReflectsAtEdges() {
    XCTAssertEqual(fold(SIMD2(105, 50), size: SIMD2(100, 100)).x, 95, accuracy: 1e-4) // overshoot reflects
    XCTAssertEqual(fold(SIMD2(-5, 50), size: SIMD2(100, 100)).x, 5, accuracy: 1e-4)   // undershoot reflects
    XCTAssertEqual(fold(SIMD2(205, 50), size: SIMD2(100, 100)).x, 5, accuracy: 1e-4)  // period 2·size
    XCTAssertEqual(fold(SIMD2(42, 50), size: SIMD2(100, 100)).x, 42, accuracy: 1e-4)  // in-bounds untouched
  }

  // rota: inverse warp in pixel coords about anchor (spec §01 §4 GLSL, quoted verbatim in the spec)
  func testRotaIdentity() {
    let p = rotaSource(point: SIMD2(30, 40), size: SIMD2(100, 100), zoom: 1, theta: 0,
                       offset: .zero, anchor: SIMD2(0.5, 0.5))
    XCTAssertEqual(p.x, 30, accuracy: 1e-4); XCTAssertEqual(p.y, 40, accuracy: 1e-4)
  }
  func testRotaZoomInSamplesSmallerNeighborhood() {
    // zoom 2 at the point 10px right of center: sample 5px right of center (scale by 1/zoom)
    let p = rotaSource(point: SIMD2(60, 50), size: SIMD2(100, 100), zoom: 2, theta: 0,
                       offset: .zero, anchor: SIMD2(0.5, 0.5))
    XCTAssertEqual(p.x, 55, accuracy: 1e-4); XCTAssertEqual(p.y, 50, accuracy: 1e-4)
  }
  func testRotaQuarterTurn() {
    // GLSL row-vector convention: no = (point−a)·mat2(c,s,−s,c)·(1/zoom) + a + offset.
    // θ=π/2, point 10px right of center → rotated = (0, −10) → sample 10px above center.
    let p = rotaSource(point: SIMD2(60, 50), size: SIMD2(100, 100), zoom: 1, theta: .pi / 2,
                       offset: .zero, anchor: SIMD2(0.5, 0.5))
    XCTAssertEqual(p.x, 50, accuracy: 1e-3); XCTAssertEqual(p.y, 40, accuracy: 1e-3)
  }
  func testNegativeZoomPointMirrors() {
    // SInvert=−1 makes zoom negative → both axes mirror about the anchor (spec §01 §4)
    let p = rotaSource(point: SIMD2(60, 70), size: SIMD2(100, 100), zoom: -1, theta: 0,
                       offset: .zero, anchor: SIMD2(0.5, 0.5))
    XCTAssertEqual(p.x, 40, accuracy: 1e-4); XCTAssertEqual(p.y, 30, accuracy: 1e-4)
  }
  func testOffsetPansInRawPixels() {
    let p = rotaSource(point: SIMD2(10, 10), size: SIMD2(100, 100), zoom: 1, theta: 0,
                       offset: SIMD2(7, -3), anchor: SIMD2(0.5, 0.5))
    XCTAssertEqual(p.x, 17, accuracy: 1e-4); XCTAssertEqual(p.y, 7, accuracy: 1e-4)
  }
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `swift test --package-path app --filter RotaFoldTests`
Expected: FAIL — `maxScale`/`fold`/`rotaSource` not defined.

- [ ] **Step 3: Implement**

`app/Sources/FeedbaxKit/ShaderMath/MaxScale.swift`:

```swift
import Foundation

/// Max's `scale lo hi lo2 hi2 exp` object. Derivation from spec §01 §2:
/// f = (in−lo)/(hi−lo); out = lo2 + (hi2−lo2)·f^exp. Max does NOT clip out-of-domain
/// input (spec §01 §4 note). For f < 0 with a fractional exponent, plain pow is NaN;
/// we extend as sign(f)·|f|^exp — a documented choice, flagged for parity review
/// (spec §01 open question 6 — the sat slot's 0..1 domain vs −1..1 siblings).
public func maxScale(_ x: Float, _ lo: Float, _ hi: Float,
                     _ lo2: Float, _ hi2: Float, exp e: Float = 1) -> Float {
  let f = (x - lo) / (hi - lo)
  let curved = e == 1 ? f : (f < 0 ? -pow(-f, e) : pow(f, e))
  return lo2 + (hi2 - lo2) * curved
}
```

`app/Sources/FeedbaxKit/ShaderMath/RotaFold.swift`:

```swift
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
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `swift test --package-path app --filter RotaFoldTests`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(shadermath): CPU reference for Max scale and td.rota fold warp"
```

---

### Task 3: CPU reference — HSL additive shift

**Files:**
- Create: `app/Sources/FeedbaxKit/ShaderMath/HSL.swift`
- Test: `app/Tests/FeedbaxKitTests/HSLTests.swift`

**Interfaces:**
- Consumes: nothing.
- Produces: `func rgb2hsl(_ rgb: SIMD3<Float>) -> SIMD3<Float>`, `func hsl2rgb(_ hsl: SIMD3<Float>) -> SIMD3<Float>`, `func rgb2hsv(_ rgb: SIMD3<Float>) -> SIMD3<Float>`, `func hslAdd(_ rgb: SIMD3<Float>, hueShift: Float, satDelta: Float, lightDelta: Float) -> SIMD3<Float>`. Tasks 5, 7 use these names.

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/HSLTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

final class HSLTests: XCTestCase {
  func testPrimariesRoundTrip() {
    for rgb: SIMD3<Float> in [SIMD3(1,0,0), SIMD3(0,1,0), SIMD3(0,0,1),
                              SIMD3(1,1,0), SIMD3(0.5,0.25,0.75), SIMD3(0.2,0.2,0.2)] {
      let back = hsl2rgb(rgb2hsl(rgb))
      XCTAssertEqual(back.x, rgb.x, accuracy: 1e-4)
      XCTAssertEqual(back.y, rgb.y, accuracy: 1e-4)
      XCTAssertEqual(back.z, rgb.z, accuracy: 1e-4)
    }
  }
  func testKnownValues() {
    // Red: h=0, s=1, l=0.5. Cyan: h=0.5, s=1, l=0.5.
    let red = rgb2hsl(SIMD3(1, 0, 0))
    XCTAssertEqual(red.x, 0, accuracy: 1e-5); XCTAssertEqual(red.y, 1, accuracy: 1e-5)
    XCTAssertEqual(red.z, 0.5, accuracy: 1e-5)
    let cyan = rgb2hsl(SIMD3(0, 1, 1))
    XCTAssertEqual(cyan.x, 0.5, accuracy: 1e-5)
  }
  func testHueWrapsSatLightClip() {
    // Additive shift: hue wraps mod 1; sat/light clamp (design checklist #5, spec §01 §5).
    // Red shifted by hue +1/3 → green.
    let g = hslAdd(SIMD3(1, 0, 0), hueShift: 1.0 / 3.0, satDelta: 0, lightDelta: 0)
    XCTAssertEqual(g.y, 1, accuracy: 1e-4); XCTAssertEqual(g.x, 0, accuracy: 1e-4)
    // hue 0.9 + 0.2 wraps to 0.1, not clamps to 1.0
    let wrapped = hslAdd(hsl2rgb(SIMD3(0.9, 1, 0.5)), hueShift: 0.2, satDelta: 0, lightDelta: 0)
    let h = rgb2hsl(wrapped).x
    XCTAssertEqual(h, 0.1, accuracy: 1e-3)
    // lightness clips at 1 (white), does not wrap
    let white = hslAdd(SIMD3(0.5, 0.5, 0.5), hueShift: 0, satDelta: 0, lightDelta: 5)
    XCTAssertEqual(white.x, 1, accuracy: 1e-5)
  }
  func testRgb2HsvKnownValues() {
    let v = rgb2hsv(SIMD3(1, 0, 0))  // needed by the chroma keyer (Task 5)
    XCTAssertEqual(v.x, 0, accuracy: 1e-5); XCTAssertEqual(v.y, 1, accuracy: 1e-5)
    XCTAssertEqual(v.z, 1, accuracy: 1e-5)
  }
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `swift test --package-path app --filter HSLTests`
Expected: FAIL — functions not defined.

- [ ] **Step 3: Implement**

`app/Sources/FeedbaxKit/ShaderMath/HSL.swift`:

```swift
import simd

/// Standard HSL/HSV conversions, hue in [0,1). These mirror the Jitter gen operators
/// rgb2hsl/hsl2rgb used by the shaderfx HSL pix (spec §01 §4-5): the shift is ADDITIVE
/// in HSL space, hue wraps mod 1, sat/light clamp — which is exactly what turns a
/// per-frame ±0.05 hue delta into the slow rainbow drift.
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
  hsl.x = hsl.x - floor(hsl.x)                      // hue wraps
  hsl.y = min(max(hsl.y, 0), 1)                     // sat clips
  hsl.z = min(max(hsl.z, 0), 1)                     // light clips
  return hsl2rgb(hsl)
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `swift test --package-path app --filter HSLTests`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(shadermath): CPU reference for additive HSL shift with hue wrap"
```

---

### Task 4: CPU reference — brcosa

**Files:**
- Create: `app/Sources/FeedbaxKit/ShaderMath/Brcosa.swift`
- Test: `app/Tests/FeedbaxKitTests/BrcosaTests.swift`

**Interfaces:**
- Consumes: nothing.
- Produces: `func brcosa(_ rgba: SIMD4<Float>, brightness: Float, contrast: Float, saturation: Float) -> SIMD4<Float>`. Tasks 8, 10 use this name.

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/BrcosaTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

final class BrcosaTests: XCTestCase {
  func testIdentityAtDefaults() {
    // 1/1/1 is an EXACT identity — the fact that let us drop the output-brcosa toggle
    // (design §11 Resolved, 2026-08-24).
    let c = SIMD4<Float>(0.3, 0.7, 0.2, 0.4)
    XCTAssertEqual(brcosa(c, brightness: 1, contrast: 1, saturation: 1), c)
  }
  func testSaturationZeroIsRec709Grayscale() {
    let out = brcosa(SIMD4(1, 0, 0, 1), brightness: 1, contrast: 1, saturation: 0)
    XCTAssertEqual(out.x, 0.2125, accuracy: 1e-4)   // Rec.709 red weight (spec §01 §4)
    XCTAssertEqual(out.y, 0.2125, accuracy: 1e-4)
    XCTAssertEqual(out.z, 0.2125, accuracy: 1e-4)
  }
  func testContrastZeroIsFlatPivotGray() {
    let out = brcosa(SIMD4(0.9, 0.1, 0.5, 1), brightness: 1, contrast: 0, saturation: 1)
    XCTAssertEqual(out.x, 0.62, accuracy: 1e-5)     // 0.62 pivot, not 0.5 (spec §01 §4)
    XCTAssertEqual(out.y, 0.62, accuracy: 1e-5)
  }
  func testUnclampedExtrapolation() {
    // contrast 2 on white: 0.62 + 2·(1−0.62) = 1.38 — must NOT clamp (spec §01 §4)
    let out = brcosa(SIMD4(1, 1, 1, 1), brightness: 1, contrast: 2, saturation: 1)
    XCTAssertEqual(out.x, 1.38, accuracy: 1e-4)
  }
  func testAlphaPassthroughFromOriginalInput() {
    let out = brcosa(SIMD4(0.5, 0.5, 0.5, 0.123), brightness: 3, contrast: 0, saturation: 0)
    XCTAssertEqual(out.w, 0.123, accuracy: 1e-6)    // alpha from ORIGINAL input, untouched
  }
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `swift test --package-path app --filter BrcosaTests`
Expected: FAIL — `brcosa` not defined.

- [ ] **Step 3: Implement**

`app/Sources/FeedbaxKit/ShaderMath/Brcosa.swift`:

```swift
import simd

/// brcosa.genjit, rendered exactly (spec §01 §4):
///   sat:      mix(luma, rgb, saturation), Rec.709 weights
///   contrast: mix(0.62-gray, ·, contrast) — extrapolates, never clamps
///   bright:   plain multiply
///   alpha:    passthrough from the ORIGINAL input
public func brcosa(_ rgba: SIMD4<Float>, brightness: Float, contrast: Float, saturation: Float) -> SIMD4<Float> {
  let rgb = SIMD3(rgba.x, rgba.y, rgba.z)
  let l = simd_dot(rgb, SIMD3(0.2125, 0.7154, 0.0721))
  let sat = simd_mix(SIMD3(repeating: l), rgb, SIMD3(repeating: saturation))
  let graded = simd_mix(SIMD3(repeating: 0.62), sat, SIMD3(repeating: contrast))
  let bright = graded * brightness
  return SIMD4(bright.x, bright.y, bright.z, rgba.w)
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `swift test --package-path app --filter BrcosaTests`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(shadermath): CPU reference for brcosa color grade"
```

---

### Task 5: CPU reference — luma keyer (two-pass cascade) and chroma keyer

**Files:**
- Create: `app/Sources/FeedbaxKit/ShaderMath/Keyers.swift`
- Test: `app/Tests/FeedbaxKitTests/KeyerTests.swift`

**Interfaces:**
- Consumes: `rgb2hsv` (Task 3).
- Produces:
  ```swift
  struct LumaKeyParams { var luma, tol, fade: Float; var invert: Float = 0; var binary: Float = 1; var mode: Float = 0; var lumcoeff: SIMD4<Float> = .init(0.299, 0.587, 0.114, 0) }
  func lumaKey(_ a: SIMD4<Float>, backdrop: SIMD4<Float>, _ p: LumaKeyParams) -> SIMD4<Float>
  func lumaCascade(_ a: SIMD4<Float>, backdrop: SIMD4<Float>, high: LumaKeyParams, low: LumaKeyParams) -> SIMD4<Float>
  func chromaKey(_ a: SIMD4<Float>, backdrop: SIMD4<Float>, color: SIMD3<Float>, tol: Float, fade: Float) -> SIMD4<Float>
  func smoothstepf(_ e0: Float, _ e1: Float, _ x: Float) -> Float
  ```
  Tasks 8, 10 use these names.

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/KeyerTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

final class KeyerTests: XCTestCase {
  // Parity defaults from spec §02 §7.4: high = (1.0, 0.2, 0.1), low = (0.0, 0.15, 0.1)
  let high = LumaKeyParams(luma: 1.0, tol: 0.2, fade: 0.1)
  let low = LumaKeyParams(luma: 0.0, tol: 0.15, fade: 0.1)
  let backdrop = SIMD4<Float>(0, 0, 0, 1)

  func testHighPassKeysOutNearWhite() {
    // white: luminance 1 → delta 0 → smoothstep(0.2, 0.3, 0) = 0 → mixamount 0 →
    // binary=1 composite = backdrop (spec §02 §8 GLSL)
    let out = lumaKey(SIMD4(1, 1, 1, 1), backdrop: backdrop, high)
    XCTAssertEqual(out, backdrop)
  }
  func testMidtonesSurviveHighPass() {
    // gray 0.5: delta 0.5 > tol+fade → mixamount 1 → a kept
    let g = SIMD4<Float>(0.5, 0.5, 0.5, 1)
    XCTAssertEqual(lumaKey(g, backdrop: backdrop, high), g)
  }
  func testFadeBandIsSmoothstep() {
    // delta 0.25 → t = (0.25−0.2)/0.1 = 0.5 → smoothstep = 0.5 → half mix.
    // Find a gray with luminance 0.75: dot((g,g,g,1),(.299,.587,.114,0)) = g
    let out = lumaKey(SIMD4(0.75, 0.75, 0.75, 1), backdrop: backdrop, high)
    XCTAssertEqual(out.x, 0.375, accuracy: 1e-3)   // mix(0, 0.75, 0.5)
  }
  func testCascadeKeepsOnlyMidrange() {
    // "pass 1 keys out near-white, pass 2 keys out near-black" (spec §02 §7.3)
    let white = lumaCascade(SIMD4(1, 1, 1, 1), backdrop: backdrop, high: high, low: low)
    let black = lumaCascade(SIMD4(0.02, 0.02, 0.02, 1), backdrop: backdrop, high: high, low: low)
    let mid = lumaCascade(SIMD4(0.5, 0.5, 0.5, 1), backdrop: backdrop, high: high, low: low)
    XCTAssertEqual(white, backdrop)
    XCTAssertEqual(black, backdrop)
    XCTAssertEqual(mid, SIMD4(0.5, 0.5, 0.5, 1))
  }
  func testChromaKeyTargetColorShowsBackdrop() {
    let key = SIMD3<Float>(0.328129, 0.144197, 0.0)  // reset default (spec §02 §7.4)
    let out = chromaKey(SIMD4(key.x, key.y, key.z, 1), backdrop: backdrop,
                        color: key, tol: 0.2, fade: 0.2)
    XCTAssertEqual(out, backdrop)                     // distance 0 → backdrop
    let far = SIMD4<Float>(0, 0, 1, 1)                // blue is far in weighted HSV
    XCTAssertEqual(chromaKey(far, backdrop: backdrop, color: key, tol: 0.2, fade: 0.2), far)
  }
  func testChromaHueWeighting() {
    // weights (4,1,2) — hue distance counts 4×. Two colors equidistant in RGB can differ
    // hugely in weighted HSV: same-value/sat hue-opposite color must exceed tol+fade
    // while a value-only tweak of the key color stays keyed out.
    let key = SIMD3<Float>(1, 0, 0)
    let valueTweak = SIMD4<Float>(0.9, 0, 0, 1)      // hsv distance = 2·0.1 weighted (value w=2)
    let hueOpposite = SIMD4<Float>(0, 1, 1, 1)       // hue 0.5 away, weighted 4×
    let a = chromaKey(valueTweak, backdrop: backdrop, color: key, tol: 0.25, fade: 0.1)
    let b = chromaKey(hueOpposite, backdrop: backdrop, color: key, tol: 0.25, fade: 0.1)
    XCTAssertEqual(a, backdrop, "small value shift stays keyed out")
    XCTAssertEqual(b, hueOpposite, "hue-opposite color survives")
  }
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `swift test --package-path app --filter KeyerTests`
Expected: FAIL — types not defined.

- [ ] **Step 3: Implement**

`app/Sources/FeedbaxKit/ShaderMath/Keyers.swift`:

```swift
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
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `swift test --package-path app --filter KeyerTests`
Expected: PASS. (If `testChromaHueWeighting` fails on the chosen example values, adjust the *example colors* — not the weights or formula — until both assertions demonstrate the 4/1/2 asymmetry; the formula itself is verbatim from the spec.)

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(shadermath): CPU reference for two-pass luma cascade and HSV chroma keyer"
```

---
### Task 6: Metal bootstrap — MetalContext, library load, readback helpers

**Files:**
- Create: `app/Sources/FeedbaxKit/Engine/MetalContext.swift`
- Test: `app/Tests/FeedbaxKitTests/MetalContextTests.swift`

**Interfaces:**
- Consumes: `TexturePool` (Task 1).
- Produces:
  ```swift
  final class MetalContext {
    let device: MTLDevice; let queue: MTLCommandQueue; let library: MTLLibrary; let pool: TexturePool
    init() throws                                     // library via Bundle.module metallib
    func makeTexture(width: Int, height: Int, format: MTLPixelFormat, pixels: [SIMD4<Float>]?) -> MTLTexture   // shared storage, CPU-writable
    func readPixels(_ tex: MTLTexture) -> [SIMD4<Float>]   // blit→shared, supports rgba8Unorm/rgba16Float/bgra8Unorm
    func computePipeline(_ name: String) throws -> MTLComputePipelineState
  }
  ```
  Every Metal task below uses these names.

- [ ] **Step 1: Write the failing test**

`app/Tests/FeedbaxKitTests/MetalContextTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

final class MetalContextTests: XCTestCase {
  func testLibraryLoadsAndNoopKernelExists() throws {
    let ctx = try MetalContext()
    XCTAssertNoThrow(try ctx.computePipeline("fbx_noop"))
  }
  func testUploadReadbackRoundTrip() throws {
    let ctx = try MetalContext()
    let px: [SIMD4<Float>] = (0..<16).map { SIMD4(Float($0) / 16, 0.5, 1.38, 1) }  // includes >1 value
    let tex = ctx.makeTexture(width: 4, height: 4, format: .rgba16Float, pixels: px)
    let back = ctx.readPixels(tex)
    for i in 0..<16 {
      XCTAssertEqual(back[i].x, px[i].x, accuracy: 2e-3)   // half precision
      XCTAssertEqual(back[i].z, 1.38, accuracy: 2e-3, "rgba16Float must preserve >1 (design §5)")
    }
  }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `swift test --package-path app --filter MetalContextTests`
Expected: FAIL — `MetalContext` not defined.

- [ ] **Step 3: Implement**

`app/Sources/FeedbaxKit/Engine/MetalContext.swift` — the *why* comments matter; core of the implementation:

```swift
import Metal
import Foundation

/// One Metal device/queue/library for the whole engine. The shader library is the
/// metallib SwiftPM compiles from Sources/FeedbaxKit/Shaders/*.metal into Bundle.module.
public final class MetalContext {
  public let device: MTLDevice
  public let queue: MTLCommandQueue
  public let library: MTLLibrary
  public let pool: TexturePool
  private var pipelines: [String: MTLComputePipelineState] = [:]

  public init() throws {
    guard let device = MTLCreateSystemDefaultDevice() else { throw FeedbaxError.noMetalDevice }
    self.device = device
    self.queue = device.makeCommandQueue()!
    self.library = try device.makeDefaultLibrary(bundle: Bundle.module)
    self.pool = TexturePool(device: device)
  }

  public func computePipeline(_ name: String) throws -> MTLComputePipelineState {
    if let p = pipelines[name] { return p }
    guard let fn = library.makeFunction(name: name) else { throw FeedbaxError.missingShader(name) }
    let p = try device.makeComputePipelineState(function: fn)
    pipelines[name] = p
    return p
  }

  /// Shared-storage texture the CPU can fill — for tests and still decode, never the hot loop.
  public func makeTexture(width: Int, height: Int, format: MTLPixelFormat,
                          pixels: [SIMD4<Float>]?) -> MTLTexture {
    let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: format, width: width,
                                                     height: height, mipmapped: false)
    d.usage = [.shaderRead, .shaderWrite, .renderTarget]
    d.storageMode = .shared
    let tex = device.makeTexture(descriptor: d)!
    guard let pixels else { return tex }
    let region = MTLRegionMake2D(0, 0, width, height)
    switch format {
    case .rgba16Float:
      let halves = pixels.map { SIMD4<Float16>(Float16($0.x), Float16($0.y), Float16($0.z), Float16($0.w)) }
      halves.withUnsafeBytes { tex.replace(region: region, mipmapLevel: 0,
                                           withBytes: $0.baseAddress!, bytesPerRow: width * 8) }
    case .rgba8Unorm, .bgra8Unorm:
      let swap = format == .bgra8Unorm
      var bytes = [UInt8](); bytes.reserveCapacity(pixels.count * 4)
      for p in pixels {
        let c = p.clamped(lowerBound: .zero, upperBound: .one) * 255
        let r = UInt8(c.x.rounded()), g = UInt8(c.y.rounded()), b = UInt8(c.z.rounded()), a = UInt8(c.w.rounded())
        bytes.append(contentsOf: swap ? [b, g, r, a] : [r, g, b, a])
      }
      bytes.withUnsafeBytes { tex.replace(region: region, mipmapLevel: 0,
                                          withBytes: $0.baseAddress!, bytesPerRow: width * 4) }
    default: fatalError("unsupported upload format \(format)")
    }
    return tex
  }

  /// Blit to a shared buffer and decode to floats. Handles rgba8Unorm, bgra8Unorm, rgba16Float.
  public func readPixels(_ tex: MTLTexture) -> [SIMD4<Float>] {
    let bpp = tex.pixelFormat == .rgba16Float ? 8 : 4
    let buf = device.makeBuffer(length: tex.width * tex.height * bpp, options: .storageModeShared)!
    let cb = queue.makeCommandBuffer()!
    let blit = cb.makeBlitCommandEncoder()!
    blit.copy(from: tex, sourceSlice: 0, sourceLevel: 0,
              sourceOrigin: MTLOrigin(), sourceSize: MTLSize(width: tex.width, height: tex.height, depth: 1),
              to: buf, destinationOffset: 0,
              destinationBytesPerRow: tex.width * bpp, destinationBytesPerImage: 0)
    blit.endEncoding()
    cb.commit(); cb.waitUntilCompleted()
    let count = tex.width * tex.height
    switch tex.pixelFormat {
    case .rgba16Float:
      let p = buf.contents().bindMemory(to: SIMD4<Float16>.self, capacity: count)
      return (0..<count).map { SIMD4<Float>(Float(p[$0].x), Float(p[$0].y), Float(p[$0].z), Float(p[$0].w)) }
    case .rgba8Unorm, .bgra8Unorm:
      let swap = tex.pixelFormat == .bgra8Unorm
      let p = buf.contents().bindMemory(to: UInt8.self, capacity: count * 4)
      return (0..<count).map { i in
        let o = i * 4
        let r = Float(p[o + (swap ? 2 : 0)]) / 255, g = Float(p[o + 1]) / 255
        let b = Float(p[o + (swap ? 0 : 2)]) / 255, a = Float(p[o + 3]) / 255
        return SIMD4(r, g, b, a)
      }
    default: fatalError("unsupported readback format \(tex.pixelFormat)")
    }
  }
}

public enum FeedbaxError: Error { case noMetalDevice, missingShader(String) }
```

(`clamped(lowerBound:upperBound:)` is the simd extension — add it as a two-line helper in this file if the toolchain lacks it.)

- [ ] **Step 4: Run test to verify it passes**

Run: `swift test --package-path app --filter MetalContextTests`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(engine): MetalContext with package metallib and pixel readback"
```

---

### Task 7: Metal warp pass (rota-fold + additive HSL, fused) with CPU parity

**Files:**
- Create: `app/Sources/FeedbaxKit/Shaders/WarpHSL.metal`
- Create: `app/Sources/FeedbaxKit/Engine/WarpPass.swift`
- Test: `app/Tests/FeedbaxKitTests/WarpParityTests.swift`

**Interfaces:**
- Consumes: `MetalContext`, `TexturePool`, CPU reference (Tasks 2–3).
- Produces:
  ```swift
  struct WarpParams { var zoom, theta: Float; var offset: SIMD2<Float>; var anchor = SIMD2<Float>(0.5, 0.5); var hueShift, satDelta, lightDelta: Float }
  final class WarpPass { init(context: MetalContext) throws
    /// Reads `previous`, returns a pool-leased rgba16Float texture: fold-warped then HSL-shifted.
    func encode(_ frame: FrameContext, previous: MTLTexture, params: WarpParams) -> MTLTexture }
  ```
  Task 8 composites this pass's output; Task 22 scenarios exercise it.

- [ ] **Step 1: Write the Metal shader**

`app/Sources/FeedbaxKit/Shaders/WarpHSL.metal` — the GPU twin of `rotaSource` + `hslAdd`. The gen math is duplicated here deliberately: the CPU copy is the testable spec, the Metal copy is the fast one, and the parity test (below) is what keeps them the same.

```metal
#include <metal_stdlib>
using namespace metal;

struct WarpParams {
  float zoom; float theta; float2 offset; float2 anchor;
  float hueShift; float satDelta; float lightDelta;
};

static float2 glsl_mod2(float2 x, float2 y) { return x - y * floor(x / y); }

static float2 fold2(float2 p, float2 size) {
  float2 wrapped = glsl_mod2(p, size);
  float2 phase = floor(glsl_mod2(p, size * 2.0) / size);
  return mix(wrapped, size - wrapped, phase);
}

static float3 rgb2hsl(float3 c) { /* same algorithm as HSL.swift, transcribed */ }
static float3 hsl2rgb(float3 h) { /* same algorithm as HSL.swift, transcribed */ }

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
```

Transcribe the two HSL helpers from `HSL.swift` line-for-line (same branch structure).

- [ ] **Step 2: Write the failing parity test**

`app/Tests/FeedbaxKitTests/WarpParityTests.swift`:

```swift
import XCTest
import simd
@testable import FeedbaxKit

/// CPU bilinear sample matching Metal's normalized linear sampler with clamp_to_edge:
/// texel centers at integer+0.5; clamp taps to the edge texel.
func bilinearSample(_ px: [SIMD4<Float>], size: SIMD2<Int>, at coord: SIMD2<Float>) -> SIMD4<Float> {
  let p = coord - SIMD2<Float>(0.5, 0.5)
  let x0 = Int(floor(p.x)), y0 = Int(floor(p.y))
  let fx = p.x - Float(x0), fy = p.y - Float(y0)
  func tap(_ x: Int, _ y: Int) -> SIMD4<Float> {
    let cx = min(max(x, 0), size.x - 1), cy = min(max(y, 0), size.y - 1)
    return px[cy * size.x + cx]
  }
  let top = simd_mix(tap(x0, y0), tap(x0 + 1, y0), SIMD4(repeating: fx))
  let bot = simd_mix(tap(x0, y0 + 1), tap(x0 + 1, y0 + 1), SIMD4(repeating: fx))
  return simd_mix(top, bot, SIMD4(repeating: fy))
}

final class WarpParityTests: XCTestCase {
  func testWarpHSLMatchesCPUReference() throws {
    let ctx = try MetalContext()
    let size = SIMD2<Int>(16, 16)
    var rng = SystemRandomNumberGenerator()
    let pixels: [SIMD4<Float>] = (0..<256).map { _ in
      SIMD4(Float.random(in: 0...1, using: &rng), Float.random(in: 0...1, using: &rng),
            Float.random(in: 0...1, using: &rng), Float.random(in: 0...1, using: &rng))
    }
    let prev = ctx.makeTexture(width: 16, height: 16, format: .rgba16Float, pixels: pixels)
    let cases: [WarpParams] = [
      .init(zoom: 1, theta: 0, offset: .zero, hueShift: 0, satDelta: 0, lightDelta: 0),
      .init(zoom: 0.8, theta: 0.3, offset: SIMD2(3, -2), hueShift: 0.02, satDelta: 0.01, lightDelta: -0.01),
      .init(zoom: -1.1, theta: -2.5, offset: SIMD2(-40, 25), hueShift: 0.4, satDelta: 0.3, lightDelta: 0.2),
    ]
    let pass = try WarpPass(context: ctx)
    for params in cases {
      let cb = ctx.queue.makeCommandBuffer()!
      let frame = FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: size,
                               commandBuffer: cb, pool: ctx.pool)
      let out = pass.encode(frame, previous: prev, params: params)
      cb.commit(); cb.waitUntilCompleted()
      let gpu = ctx.readPixels(out)
      for y in 0..<16 { for x in 0..<16 {
        let point = SIMD2(Float(x) + 0.5, Float(y) + 0.5)
        let src = rotaSource(point: point, size: SIMD2(16, 16), zoom: params.zoom,
                             theta: params.theta, offset: params.offset, anchor: params.anchor)
        let sampled = bilinearSample(pixels, size: size, at: src)
        let rgb = hslAdd(SIMD3(sampled.x, sampled.y, sampled.z), hueShift: params.hueShift,
                         satDelta: params.satDelta, lightDelta: params.lightDelta)
        let g = gpu[y * 16 + x]
        // Tolerance: half-precision storage + fract/pow ULP differences. Hue-wrap
        // boundaries can diverge a full hue segment on exact ties; allow rare outliers.
        XCTAssertEqual(g.x, rgb.x, accuracy: 0.02, "px \(x),\(y)")
        XCTAssertEqual(g.y, rgb.y, accuracy: 0.02, "px \(x),\(y)")
        XCTAssertEqual(g.z, rgb.z, accuracy: 0.02, "px \(x),\(y)")
        XCTAssertEqual(g.w, sampled.w, accuracy: 0.01, "alpha untouched px \(x),\(y)")
      } }
      ctx.pool.endFrame()
    }
  }
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `swift test --package-path app --filter WarpParityTests`
Expected: FAIL — `WarpPass` not defined.

- [ ] **Step 4: Implement WarpPass**

`app/Sources/FeedbaxKit/Engine/WarpPass.swift`:

```swift
import Metal
import simd

public struct WarpParams {
  public var zoom, theta: Float
  public var offset: SIMD2<Float>
  public var anchor = SIMD2<Float>(0.5, 0.5)   // static in this build (spec §01 §4)
  public var hueShift, satDelta, lightDelta: Float
  public init(zoom: Float, theta: Float, offset: SIMD2<Float>,
              hueShift: Float, satDelta: Float, lightDelta: Float) {
    self.zoom = zoom; self.theta = theta; self.offset = offset
    self.hueShift = hueShift; self.satDelta = satDelta; self.lightDelta = lightDelta
  }
}

public final class WarpPass {
  private let pipeline: MTLComputePipelineState
  public init(context: MetalContext) throws { pipeline = try context.computePipeline("fbx_warp_hsl") }

  public func encode(_ frame: FrameContext, previous: MTLTexture, params: WarpParams) -> MTLTexture {
    let out = frame.pool.lease(width: previous.width, height: previous.height,
                               format: .rgba16Float, usage: [.shaderRead, .shaderWrite])
    var p = params
    let enc = frame.commandBuffer.makeComputeCommandEncoder()!
    enc.setComputePipelineState(pipeline)
    enc.setTexture(previous, index: 0)
    enc.setTexture(out, index: 1)
    enc.setBytes(&p, length: MemoryLayout<WarpParams>.stride, index: 0)
    let tg = MTLSize(width: 16, height: 16, depth: 1)
    enc.dispatchThreadgroups(MTLSize(width: (out.width + 15) / 16, height: (out.height + 15) / 16, depth: 1),
                             threadsPerThreadgroup: tg)
    enc.endEncoding()
    return out
  }
}
```

Match the Metal struct layout to Swift's: declare fields in identical order; verify `MemoryLayout<WarpParams>.stride` against the Metal side by test failure if misaligned (float2 needs 8-byte alignment — order the struct: zoom, theta, offset, anchor, hueShift, satDelta, lightDelta as written, which aligns).

- [ ] **Step 5: Run test to verify it passes**

Run: `swift test --package-path app --filter WarpParityTests`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add app
git commit -m "feat(engine): fused rota-fold + HSL Metal pass with CPU parity test"
```

---

### Task 8: FeedbackCore — erase, seed-under/past-over composite, ping-pong

**Files:**
- Create: `app/Sources/FeedbaxKit/Shaders/Composite.metal`
- Create: `app/Sources/FeedbaxKit/Engine/FeedbackCore.swift`
- Test: `app/Tests/FeedbaxKitTests/FeedbackCoreTests.swift`

**Interfaces:**
- Consumes: `MetalContext`, `WarpPass` (Task 7).
- Produces:
  ```swift
  struct RenderParams {   // already smoothed+mapped — the router (Task 11) produces this
    var zoom, theta: Float; var offsetPx: SIMD2<Float>
    var hueShift, satDelta, lightDelta: Float
    var eraseAlpha: Float                    // 0.8...1.0, never smoothed
    var eraseColor: SIMD3<Float> = .zero
    var worldBump: Float = 0                 // Z offset on the feedback plane
  }
  final class FeedbackCore {
    init(context: MetalContext, size: SIMD2<Int>, format: MTLPixelFormat = .rgba8Unorm) throws
    var accumulator: MTLTexture { get }      // last completed frame
    func renderFrame(_ frame: FrameContext, params: RenderParams,
                     drawSeeds: (MTLRenderCommandEncoder) -> Void) -> MTLTexture
    func resize(_ size: SIMD2<Int>, eraseColor: SIMD3<Float>)
  }
  ```
  Also (in `Composite.metal` + a small `QuadRenderer` helper inside `FeedbackCore.swift`): a textured-quad vertex/fragment pair `fbx_quad_v` / `fbx_quad_f` taking a 4×4 transform + tint color — reused by the Compositor (Task 9) and waveforms (Task 18).

**Frame recipe** (spec §01 §1 trigger order + README frame algorithm — ordering is load-bearing):

1. **Erase into current**: full-screen pass writing `mix(prevFinal, eraseColor, α)` for RGB and `α·α + (1−α)·prev.a` for alpha — this is exactly what Jitter's `erase` with blending on does (spec §01 §2). Implemented as a compute kernel `fbx_erase` reading `prev`, writing `current` (no blending state needed, and it doubles as the ping-pong copy).
2. **Warp**: `WarpPass.encode` on `prevFinal` → warped texture (v1 chain ends at HSL — design decision #13).
3. **Seeds under**: render pass on `current` (load: `.load`), caller's `drawSeeds` closure draws layers/waveforms with standard alpha blend.
4. **Past over**: same render pass, draw the warped texture as the feedback plane with blend factors `(.sourceAlpha, .destinationAlpha)` — rgb AND alpha (spec §01 §3). Plane transform: fullscreen quad scaled by `2.414 / (2.414 − worldBump)` — moving the Jitter videoplane from z=−0.414 toward the default camera at (0,0,2) is an apparent-scale change; 2.414·tan(22.5°) = 1.0 is why −0.414 fills the frame exactly (Constants table).
5. **Swap**: current becomes `accumulator`. No copy — the capture step Max needed is free here (design §4).

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/FeedbackCoreTests.swift` — three focused tests:

```swift
import XCTest
import simd
@testable import FeedbaxKit

final class FeedbackCoreTests: XCTestCase {
  func makeCore(_ ctx: MetalContext, size: Int = 8) throws -> FeedbackCore {
    try FeedbackCore(context: ctx, size: SIMD2(size, size))
  }
  func runFrame(_ ctx: MetalContext, _ core: FeedbackCore, _ params: RenderParams,
                index: Int = 0, drawSeeds: @escaping (MTLRenderCommandEncoder) -> Void = { _ in }) -> [SIMD4<Float>] {
    let cb = ctx.queue.makeCommandBuffer()!
    let frame = FrameContext(index: index, time: Double(index) / 60, delta: 1 / 60,
                             canvasSize: SIMD2(8, 8), commandBuffer: cb, pool: ctx.pool)
    let out = core.renderFrame(frame, params: params, drawSeeds: drawSeeds)
    cb.commit(); cb.waitUntilCompleted(); ctx.pool.endFrame()
    return ctx.readPixels(out)
  }
  static func identityParams(erase: Float) -> RenderParams {
    RenderParams(zoom: 1, theta: 0, offsetPx: .zero, hueShift: 0, satDelta: 0,
                 lightDelta: 0, eraseAlpha: erase)
  }

  func testEraseResidualIsOneMinusAlphaPerFrame() throws {
    // Seed one white frame, disable the feedback plane (test hook), then run erase-only
    // frames at α=0.9: residual must be (1−0.9)^n (spec §01 §2).
    let ctx = try MetalContext()
    let core = try makeCore(ctx)
    var p = Self.identityParams(erase: 1.0)
    core.feedbackPlaneEnabled = false
    _ = runFrame(ctx, core, p) { enc in core.drawSolid(enc, color: SIMD4(1, 1, 1, 1)) }
    p.eraseAlpha = 0.9
    var value: Float = 1
    for i in 1...3 {
      let px = runFrame(ctx, core, p, index: i)
      value *= 0.1
      XCTAssertEqual(px[0].x, value, accuracy: 3.0 / 255, "frame \(i): residual (1−a)^n")
    }
  }

  func testFeedbackBlendIsSrcAlphaDstAlpha() throws {
    // prev = (0.4, 0.4, 0.4, 0.25) (seeded with plane off); this frame's seeds fill
    // (0.2, 0.2, 0.2, 0.5); warped prev blends over with (srcα, dstα):
    // rgb = 0.25·0.4 + 0.5·0.2 = 0.2 — NOT alpha-over (which would give 0.2·? ≠ this).
    let ctx = try MetalContext()
    let core = try makeCore(ctx)
    let p = Self.identityParams(erase: 1.0)
    core.feedbackPlaneEnabled = false
    _ = runFrame(ctx, core, p) { enc in core.drawSolid(enc, color: SIMD4(0.4, 0.4, 0.4, 0.25)) }
    core.feedbackPlaneEnabled = true
    let px = runFrame(ctx, core, p, index: 1) { enc in core.drawSolid(enc, color: SIMD4(0.2, 0.2, 0.2, 0.5)) }
    XCTAssertEqual(px[0].x, 0.2, accuracy: 3.0 / 255)
    // and alpha: srcα·srcα + dstα·dstα = 0.25·0.25 + 0.5·0.5 = 0.3125
    XCTAssertEqual(px[0].w, 0.3125, accuracy: 3.0 / 255)
  }

  func testResizeClearsToEraseColor() throws {
    let ctx = try MetalContext()
    let core = try makeCore(ctx)
    _ = runFrame(ctx, core, Self.identityParams(erase: 1.0)) { enc in
      core.drawSolid(enc, color: SIMD4(1, 1, 1, 1))
    }
    core.resize(SIMD2(16, 16), eraseColor: .zero)   // design §4: clear on resize
    XCTAssertEqual(core.accumulator.width, 16)
    let px = ctx.readPixels(core.accumulator)
    XCTAssertEqual(px[0].x, 0, accuracy: 1.0 / 255)
  }
}
```

`drawSolid(_ enc: MTLRenderCommandEncoder, color: SIMD4<Float>)` is a small helper on `FeedbackCore` drawing a fullscreen quad through `fbx_solid_f` with blending DISABLED — public, documented as a test/instrumentation hook. `init` clears both accumulators to (0, 0, 0, 1) so frame 0 is deterministic.

- [ ] **Step 2: Run tests to verify they fail**

Run: `swift test --package-path app --filter FeedbackCoreTests`
Expected: FAIL — `FeedbackCore` not defined.

- [ ] **Step 3: Implement Composite.metal + FeedbackCore**

`Composite.metal`:

```metal
#include <metal_stdlib>
using namespace metal;

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
```

`FeedbackCore.swift` — key parts (write in full):

```swift
public final class FeedbackCore {
  public private(set) var accumulator: MTLTexture   // prev (read this frame)
  private var back: MTLTexture                      // current (written this frame)
  private let warp: WarpPass
  private let erasePipeline: MTLComputePipelineState
  private let quad: QuadRenderer                    // pipelines for fbx_quad_*/fbx_solid_f
  public var feedbackPlaneEnabled = true            // test hook — golden runs keep it true

  public func renderFrame(_ frame: FrameContext, params: RenderParams,
                          drawSeeds: (MTLRenderCommandEncoder) -> Void) -> MTLTexture {
    encodeErase(frame, from: accumulator, to: back, params: params)      // 1
    let warped = warp.encode(frame, previous: accumulator, params: params.warpParams)  // 2
    let rp = MTLRenderPassDescriptor()
    rp.colorAttachments[0].texture = back
    rp.colorAttachments[0].loadAction = .load
    rp.colorAttachments[0].storeAction = .store
    let enc = frame.commandBuffer.makeRenderCommandEncoder(descriptor: rp)!
    drawSeeds(enc)                                                        // 3: seeds UNDER
    if feedbackPlaneEnabled {                                             // 4: past OVER
      // Apparent scale of the videoplane as worldBump pushes it toward the camera:
      // 2.414·tan(22.5°) = 1.0 makes z = −0.414 exactly fullscreen (Constants table).
      let scale = 2.414 / (2.414 - params.worldBump)
      quad.drawTextured(enc, texture: warped,
                        transform: float4x4(scaling: SIMD3(scale, scale, 1)),
                        tint: SIMD4(1, 1, 1, 1),
                        blend: .srcAlphaDstAlpha)     // (SRC_ALPHA, DST_ALPHA), rgb AND alpha
    }
    enc.endEncoding()
    swap(&accumulator, &back)                                             // 5
    return accumulator
  }
}
```

`QuadRenderer` builds three `MTLRenderPipelineState`s (textured/solid × blend modes `.none`, `.alphaOver` = (srcα, 1−srcα), `.srcAlphaDstAlpha` = (srcα, dstα) with matching alpha factors) against the accumulator pixel format; `drawSolid` is the test hook from Step 1. `RenderParams.warpParams` maps the shared fields into `WarpParams`.

- [ ] **Step 4: Run tests to verify they pass**

Run: `swift test --package-path app --filter FeedbackCoreTests`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(engine): FeedbackCore with erase, srcAlpha/dstAlpha composite, ping-pong"
```

---

### Task 9: Compositor — Jitter-default projection, layer quads, draw order

**Files:**
- Create: `app/Sources/FeedbaxKit/Engine/Compositor.swift`
- Create: `app/Sources/FeedbaxKit/Sources/SeedSource.swift`
- Test: `app/Tests/FeedbaxKitTests/CompositorTests.swift`

**Interfaces:**
- Consumes: `QuadRenderer` (Task 8), `FrameContext`.
- Produces:
  ```swift
  protocol SeedSource: AnyObject {
    var id: String { get }
    func tick(_ frame: FrameContext) -> MTLTexture?    // nil = skip this frame
    var transform: LayerTransform { get set }
    var layer: LayerSettings { get set }
  }
  struct LayerTransform: Codable, Equatable { var position = SIMD2<Float>.zero  // world units
    var scale = SIMD2<Float>(1, 1); var rotationZDegrees: Float = 0 }
  struct LayerSettings: Codable, Equatable { var zOrder = 2; var enabled = false }
  final class Compositor {
    init(quad: QuadRenderer)
    var layers: [SeedSource]
    /// Draws all enabled layers in zOrder into the encoder (standard alpha-over),
    /// then the registered overlay draws (waveforms — Task 18).
    func drawSeeds(_ enc: MTLRenderCommandEncoder, frame: FrameContext, textures: [String: MTLTexture])
    func collectTextures(_ frame: FrameContext) -> [String: MTLTexture]   // ticks sources
    func drawPlan(available: Set<String>) -> [String]   // ids in draw order — shared by drawSeeds
    static func projection(canvasAspect: Float) -> float4x4               // camera (0,0,2), fovY 45°
    static func modelTransform(_ t: LayerTransform, textureAspect: Float, atZ z: Float) -> float4x4
  }
  ```
  Tasks 15/16 implement `SeedSource`; Task 18 registers waveform overlay draws; Task 19 wires `collectTextures` → `drawSeeds` around `FeedbackCore.renderFrame`.

**Why a 3D projection at all:** every placement constant in the spec is in Jitter world units under Jitter's default camera — position (0,0,2), lens 45°, so visible half-height at distance d is `d·tan(22.5°)`. Keeping that projection means the spec's numbers (layer x ∈ −1.7..1.7, wave-1 at (0,−0.85,0), wave-2 at z=−2) transfer verbatim instead of each needing a hand-derived NDC equivalent.

- [ ] **Step 1: Write the failing tests**

```swift
import XCTest
import simd
@testable import FeedbaxKit

final class CompositorTests: XCTestCase {
  func testVideoplaneEquivalenceFillsFrame() {
    // A unit quad (half-extent 1) at z=−0.414 under the Jitter default camera must hit
    // clip y = ±1 exactly (2.414·tan(22.5°) = 1.0) — the videoplane fact (spec §01 §3).
    let proj = Compositor.projection(canvasAspect: 16.0 / 9.0)
    let model = Compositor.modelTransform(LayerTransform(), textureAspect: 1, atZ: -0.414)
    let corner = proj * model * SIMD4<Float>(0, 1, 0, 1)
    XCTAssertEqual(corner.y / corner.w, 1.0, accuracy: 2e-3)
  }
  func testLayerAtOriginHalfHeight() {
    // A layer at z=0 sits at distance 2: half-height 2·tan(22.5°) ≈ 0.828 world units →
    // a unit quad reaches clip y ≈ 1/0.828 ≈ 1.207.
    let proj = Compositor.projection(canvasAspect: 1)
    let model = Compositor.modelTransform(LayerTransform(), textureAspect: 1, atZ: 0)
    let corner = proj * model * SIMD4<Float>(0, 1, 0, 1)
    XCTAssertEqual(corner.y / corner.w, 1.0 / 0.8284, accuracy: 2e-3)
  }
  func testDrawOrderSortsByZOrderAndSkipsDisabledAndTextureless() throws {
    final class FakeSource: SeedSource {
      let id: String; var transform = LayerTransform(); var layer = LayerSettings()
      init(_ id: String) { self.id = id }
      func tick(_ frame: FrameContext) -> MTLTexture? { nil }
    }
    let quadless = Compositor(quad: nil)   // drawPlan needs no pipelines
    let a = FakeSource("a"); a.layer = .init(zOrder: 5, enabled: true)
    let b = FakeSource("b"); b.layer = .init(zOrder: 1, enabled: true)
    let c = FakeSource("c"); c.layer = .init(zOrder: 3, enabled: false)
    let d = FakeSource("d"); d.layer = .init(zOrder: 2, enabled: true)
    quadless.layers = [a, b, c, d]
    XCTAssertEqual(quadless.drawPlan(available: ["a", "b", "c"]), ["b", "a"],
                   "zOrder ascending; disabled c skipped; d skipped (no texture this frame)")
  }
}
```

(`Compositor.init(quad:)` takes `QuadRenderer?` so order logic is testable without pipelines; the GPU path force-unwraps with a documented precondition.)

- [ ] **Step 2: Run tests to verify they fail**

Run: `swift test --package-path app --filter CompositorTests`
Expected: FAIL — types not defined.

- [ ] **Step 3: Implement**

`Compositor.projection`: right-handed perspective, fovY 45°, near 0.1, far 100, then translate by camera position (0,0,−2 view translation). `modelTransform`: translate(position.x, position.y, z) · rotateZ(degrees) · scale(textureAspect·scale.x, scale.y, 1). Quad half-extent is 1 (Jitter plane convention). `drawSeeds` draws each enabled layer's texture (from `textures[id]`) with `.alphaOver` blend and the model-view-projection as the quad transform, in ascending `zOrder`; unknown/nil textures skip. `drawPlan` is the same iteration returning ids (shared helper so order logic exists once). Overlay draws: `var overlays: [(MTLRenderCommandEncoder, FrameContext) -> Void]` appended after layers (waveforms draw in world space themselves, Task 18).

Layer aspect choice — the quad spans `(±textureAspect·scale.x, ±scale.y)`: Jitter's `jit.gl.layer` quad convention is not pinned by the spec; texture-aspect × uniform imageMove zoom is our reading, flagged for parity review against footage (README `[?]` items).

- [ ] **Step 4: Run tests to verify they pass**

Run: `swift test --package-path app --filter CompositorTests`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(engine): compositor with Jitter-default projection and z-ordered layers"
```

---
### Task 10: TextureFilter protocol, FilterChain, Brcosa/LumaKey/ChromaKey filters

**Files:**
- Create: `app/Sources/FeedbaxKit/Filters/TextureFilter.swift`
- Create: `app/Sources/FeedbaxKit/Filters/BrcosaFilter.swift`
- Create: `app/Sources/FeedbaxKit/Filters/LumaKeyFilter.swift`
- Create: `app/Sources/FeedbaxKit/Filters/ChromaKeyFilter.swift`
- Create: `app/Sources/FeedbaxKit/Shaders/Filters.metal`
- Test: `app/Tests/FeedbaxKitTests/FilterTests.swift`

**Interfaces:**
- Consumes: `MetalContext`, `FrameContext`, CPU references (Tasks 4–5).
- Produces:
  ```swift
  protocol TextureFilter: AnyObject {
    var id: String { get }
    var enabled: Bool { get set }
    func apply(_ input: MTLTexture, _ frame: FrameContext) -> MTLTexture   // pool-leased rgba16Float out
  }
  final class FilterChain { var filters: [TextureFilter]
    func apply(_ input: MTLTexture, _ frame: FrameContext) -> MTLTexture }  // disabled filters skipped
  final class BrcosaFilter: TextureFilter   // params: brightness/contrast/saturation, defaults 1.55/1.55/1.5, enabled=false (spec §02 §7.2)
  final class LumaKeyFilter: TextureFilter  // two-pass cascade; high (1.0,0.2,0.1), low (0.0,0.15,0.1); backdrop color, default black
  final class ChromaKeyFilter: TextureFilter // color (0.328129,0.144197,0.0), tol 0.2, fade 0.2; backdrop color
  ```
  Task 22's golden scenarios attach these to a movie layer (P1's only live use — design §10); P3 puts them on the camera chain.

- [ ] **Step 1: Write the Metal kernels**

`Filters.metal` — three kernels, each the transcription of its CPU reference (`fbx_brcosa`, `fbx_lumakey`, `fbx_chromakey`). Params structs mirror the Swift ones field-for-field. `fbx_lumakey` implements ONE luma pass (the filter dispatches it twice, high then low, through an intermediate lease). The chroma kernel transcribes `rgb2hsv` from `HSL.swift`.

- [ ] **Step 2: Write the failing parity tests**

`FilterTests.swift`:

```swift
import XCTest
import simd
@testable import FeedbaxKit

final class FilterTests: XCTestCase {
  var ctx: MetalContext!
  var pixels: [SIMD4<Float>]!
  var input: MTLTexture!

  override func setUpWithError() throws {
    ctx = try MetalContext()
    var rng = SystemRandomNumberGenerator()
    pixels = (0..<16).map { i in
      SIMD4(Float.random(in: 0...1.4, using: &rng), Float.random(in: 0...1, using: &rng),
            Float.random(in: 0...1, using: &rng), Float.random(in: 0...1, using: &rng))
    }                                       // includes >1 values — brcosa must not clamp
    input = ctx.makeTexture(width: 4, height: 4, format: .rgba16Float, pixels: pixels)
  }

  /// Apply one filter through a one-frame chain and read the result back.
  func applyAndRead(_ filter: TextureFilter) -> [SIMD4<Float>] {
    let cb = ctx.queue.makeCommandBuffer()!
    let frame = FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: SIMD2(4, 4),
                             commandBuffer: cb, pool: ctx.pool)
    let out = FilterChain([filter]).apply(input, frame)
    cb.commit(); cb.waitUntilCompleted()
    defer { ctx.pool.endFrame() }
    return ctx.readPixels(out)
  }

  func testBrcosaParity() throws {
    let f = try BrcosaFilter(context: ctx)
    f.enabled = true; f.brightness = 1.55; f.contrast = 1.55; f.saturation = 1.5
    let gpu = applyAndRead(f)
    for i in 0..<16 {
      let cpu = brcosa(pixels[i], brightness: 1.55, contrast: 1.55, saturation: 1.5)
      for c in 0..<4 { XCTAssertEqual(gpu[i][c], cpu[c], accuracy: 0.02, "px \(i) ch \(c)") }
    }
  }
  func testLumaCascadeParity() throws {
    let f = try LumaKeyFilter(context: ctx)   // parity defaults high (1,0.2,0.1) low (0,0.15,0.1)
    f.enabled = true
    let gpu = applyAndRead(f)
    for i in 0..<16 {
      let cpu = lumaCascade(pixels[i], backdrop: f.backdrop,
                            high: f.highParams, low: f.lowParams)
      for c in 0..<4 { XCTAssertEqual(gpu[i][c], cpu[c], accuracy: 0.02, "px \(i) ch \(c)") }
    }
  }
  func testChromaKeyParity() throws {
    let f = try ChromaKeyFilter(context: ctx) // defaults color (0.328129, 0.144197, 0), tol 0.2, fade 0.2
    f.enabled = true
    let gpu = applyAndRead(f)
    for i in 0..<16 {
      let cpu = chromaKey(pixels[i], backdrop: f.backdrop, color: f.keyColor, tol: f.tol, fade: f.fade)
      for c in 0..<4 { XCTAssertEqual(gpu[i][c], cpu[c], accuracy: 0.02, "px \(i) ch \(c)") }
    }
  }
  func testChainSkipsDisabledFilters() throws {
    let f = try BrcosaFilter(context: ctx)    // enabled defaults FALSE (spec §02 §7.2)
    let out = applyAndRead(f)
    for i in 0..<16 {
      XCTAssertEqual(out[i].x, pixels[i].x, accuracy: 0.01, "disabled filter must pass through")
    }
  }
  func testUnclampedIntermediateSurvivesChain() throws {
    // brcosa(contrast 2) on white → 1.38, which must reach the NEXT filter intact —
    // proves rgba16Float chain intermediates (design §5).
    let white = ctx.makeTexture(width: 4, height: 4, format: .rgba16Float,
                                pixels: [SIMD4<Float>](repeating: SIMD4(1, 1, 1, 1), count: 16))
    let b = try BrcosaFilter(context: ctx)
    b.enabled = true; b.brightness = 1; b.contrast = 2; b.saturation = 1
    let cb = ctx.queue.makeCommandBuffer()!
    let frame = FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: SIMD2(4, 4),
                             commandBuffer: cb, pool: ctx.pool)
    let out = FilterChain([b]).apply(white, frame)
    cb.commit(); cb.waitUntilCompleted(); defer { ctx.pool.endFrame() }
    XCTAssertEqual(ctx.readPixels(out)[0].x, 1.38, accuracy: 0.02)
  }
}
```

- [ ] **Step 3: Run tests to verify they fail**

Run: `swift test --package-path app --filter FilterTests`
Expected: FAIL.

- [ ] **Step 4: Implement**

`TextureFilter.swift`:

```swift
public protocol TextureFilter: AnyObject {
  var id: String { get }
  var enabled: Bool { get set }
  /// Texture in → pool-leased texture out. Leases belong to the CHAIN's frame scope;
  /// outputs are valid this frame only (design §5).
  func apply(_ input: MTLTexture, _ frame: FrameContext) -> MTLTexture
}

public final class FilterChain {
  public var filters: [TextureFilter] = []
  public init(_ filters: [TextureFilter] = []) { self.filters = filters }
  public func apply(_ input: MTLTexture, _ frame: FrameContext) -> MTLTexture {
    filters.reduce(input) { tex, f in f.enabled ? f.apply(tex, frame) : tex }
  }
}
```

Each filter: one compute pipeline (`init(context: MetalContext) throws`), `apply` leases an `rgba16Float` output sized like the input, dispatches, returns the lease. Public parameter surface (names the tests use): `BrcosaFilter` — `brightness: Float = 1.55, contrast: Float = 1.55, saturation: Float = 1.5`, `enabled = false` (the camera-chain hot defaults behind the default-off gate, spec §02 §7.2; golden scenarios flip `enabled` explicitly). `LumaKeyFilter` — `highParams = LumaKeyParams(luma: 1.0, tol: 0.2, fade: 0.1)`, `lowParams = LumaKeyParams(luma: 0.0, tol: 0.15, fade: 0.1)`, `backdrop = SIMD4<Float>(0, 0, 0, 1)`; `apply` dispatches high then low through two leases. `ChromaKeyFilter` — `keyColor = SIMD3<Float>(0.328129, 0.144197, 0.0)`, `tol: Float = 0.2`, `fade: Float = 0.2`, `backdrop = SIMD4<Float>(0, 0, 0, 1)`. Keyer backdrop: the original mattes against a static operator-set fill (`keyCh2init`, exact per-plane values unrecoverable from the patch, spec §02 §7.3 `[?]`); black is our documented default, operator-settable in P3's keying UI.

- [ ] **Step 5: Run tests to verify they pass**

Run: `swift test --package-path app --filter FilterTests`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add app
git commit -m "feat(filters): TextureFilter chain with brcosa, luma cascade, chroma key"
```

---

### Task 11: ControlRouter — slot maps, ramps, SInvert, erase path, diff

**Files:**
- Create: `app/Sources/FeedbaxKit/Control/ControlVector.swift`
- Create: `app/Sources/FeedbaxKit/Control/LinearRamp.swift`
- Create: `app/Sources/FeedbaxKit/Control/ControlRouter.swift`
- Test: `app/Tests/FeedbaxKitTests/ControlRouterTests.swift`

**Interfaces:**
- Consumes: `maxScale` (Task 2), `RenderParams` (Task 8).
- Produces:
  ```swift
  enum ControlSlot: Int, CaseIterable, Codable { case hue = 0, bias, scalebright, panX, panY, zoom, theta, nc, saturation }
  enum ToggleEvent: Equatable, Codable { case sInvert(Bool), worldBumpEnabled(Bool), waveBumpEnabled(Bool),
    kittyBumpEnabled(Bool), wave1Enabled(Bool), wave2Enabled(Bool), layerEnabled(Bool), fullscreen, stillCapture }
  struct ControlWrite { var slots: [ControlSlot: Float] = [:]; var toggles: [ToggleEvent] = [] }
  protocol ControlSurface: AnyObject { var id: String { get }
    func poll(_ time: TimeInterval) -> ControlWrite? }
  final class ControlRouter {
    init(smoothMs: Double = 100, grainMs: Double = 4)
    var surfaces: [ControlSurface]
    var eraseControl: Float                      // raw t, 0..1 — set directly, NOT a slot
    private(set) var sInvert: Float              // +1 / −1
    var toggleHandler: ((ToggleEvent) -> Void)?  // engine wires bump/wave/layer/capture actions
    func apply(_ write: ControlWrite, at time: TimeInterval)      // slots + toggles, immediately
    func tick(at time: TimeInterval) -> RenderParams              // polls surfaces, advances ramps
    var rawSlots: [Float] { get }                // for presets (Task 12)
  }
  ```
  Deliberate narrowing vs the design doc's `poll(_ frame: FrameContext)`: surfaces need only
  time (no textures/command buffer), and `TimeInterval` keeps them testable without Metal.
  Record this deviation in the design doc's §5 when the task lands (one-line edit).
  Tasks 13/14 implement `ControlSurface`; Task 12 recalls presets through `router.apply`; Task 19 calls `tick` each frame.

**Mapping rules** (Constants table; order of operations is load-bearing, spec §01 §4):
- hue/bias/sat → `maxScale` (exp curves) → ramp.
- panX/panY → raw `× SInvert` **then** map **then** ramp (a flip glides in over 100 ms).
- zoom → map **then** ramp **then** `× SInvert` (a flip inverts instantly — the kaleidoscope hard cut).
- theta → reversed map → ramp.
- erase → `maxScale(t, 0, 1, 0.8, 1, exp: 3)`, **no ramp** (checklist #4).
- scalebright/nc: mapped to nothing (dead slots) but stored, so presets round-trip all 9.
- `tick` polls surfaces in order; later surfaces overwrite earlier ones' asserted slots (last-writer-wins, matching the original's competing-sources behavior, spec §04 §1.2). Toggles dispatch to `toggleHandler` in arrival order, unsmoothed.

- [ ] **Step 1: Write the failing tests**

```swift
import XCTest
@testable import FeedbaxKit

final class ControlRouterTests: XCTestCase {
  func testSlotMappingsAtKnownPoints() {
    let r = ControlRouter()
    r.apply(ControlWrite(slots: [.zoom: 0, .theta: 1, .panX: 1]), at: 0)
    let p = r.tick(at: 1.0)   // 1 s ≫ 100 ms — ramps settled
    XCTAssertEqual(p.zoom, 0.8, accuracy: 1e-4)          // scale(−1,1→0.4,1.2) at 0
    XCTAssertEqual(p.theta, -.pi, accuracy: 1e-4)        // reversed map
    XCTAssertEqual(p.offsetPx.x, 2000, accuracy: 1e-1)   // ±2000 px
  }
  func testRampIsLinearOver100ms() {
    // Ramps initialize at the mapped value of raw slot 0 → zoom rest value 0.8.
    let r = ControlRouter()
    _ = r.tick(at: 0)
    r.apply(ControlWrite(slots: [.zoom: 1.0]), at: 0)     // target 1.2
    let mid = r.tick(at: 0.05)                            // linear ramp: halfway at 50 ms
    XCTAssertEqual(mid.zoom, 1.0, accuracy: 0.02)         // 0.8 → 1.2, half = 1.0
    let done = r.tick(at: 0.12)
    XCTAssertEqual(done.zoom, 1.2, accuracy: 1e-3)
  }
  func testEraseIsMappedButNeverSmoothed() {
    let r = ControlRouter()
    r.eraseControl = 0.5
    let p = r.tick(at: 0.001)                             // immediately, no ramp
    XCTAssertEqual(p.eraseAlpha, 0.825, accuracy: 1e-4)   // 0.8 + 0.2·0.5³
  }
  func testSInvertZoomFlipsInstantlyPanRampsIn() {
    let r = ControlRouter()
    r.apply(ControlWrite(slots: [.zoom: 1.0, .panX: 1.0]), at: 0)
    _ = r.tick(at: 0.5)                                   // settle: zoom 1.2, panX 2000
    r.apply(ControlWrite(toggles: [.sInvert(true)]), at: 0.5)
    let p = r.tick(at: 0.501)                             // 1 ms later
    XCTAssertEqual(p.zoom, -1.2, accuracy: 1e-2, "zoom flip is instant (post-ramp multiply)")
    XCTAssertGreaterThan(p.offsetPx.x, 1900, "pan flip ramps (pre-map multiply)")
    let later = r.tick(at: 0.7)
    XCTAssertEqual(later.offsetPx.x, -2000, accuracy: 1, "pan settles at flipped value")
  }
  func testLastSurfaceWinsPerSlot() {
    final class Fixed: ControlSurface {
      let id: String; let write: ControlWrite
      init(_ id: String, _ w: ControlWrite) { self.id = id; write = w }
      func poll(_ time: TimeInterval) -> ControlWrite? { write }
    }
    let r = ControlRouter()
    r.surfaces = [Fixed("a", .init(slots: [.hue: -1, .zoom: 0.5])),
                  Fixed("b", .init(slots: [.hue: 1]))]
    _ = r.tick(at: 1)
    XCTAssertEqual(r.rawSlots[ControlSlot.hue.rawValue], 1, "later surface overwrites hue")
    XCTAssertEqual(r.rawSlots[ControlSlot.zoom.rawValue], 0.5, "unasserted slot keeps earlier write")
  }
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `swift test --package-path app --filter ControlRouterTests`
Expected: FAIL.

- [ ] **Step 3: Implement**

`LinearRamp.swift` — mIniCtlSmooth's `line` behavior (spec §01 §0): on `setTarget(v, at: t)` record start value/time; `value(at: t)` interpolates linearly over `smoothMs`, quantized to `grainMs` steps (`floor(elapsed / grain) * grain` — the 4 ms grain from `feedbax.misc`, spec §04 §5); retargeting mid-ramp starts from the current interpolated value.

`ControlRouter.tick`: poll surfaces → merge writes (slots overwrite; toggles append) → apply toggles (update `sInvert`, forward the rest to `toggleHandler`) → update each mapped param's ramp target if its raw slot changed (diff-before-broadcast, spec §04 §1.2 — `zl.change` equivalent) → evaluate ramps at `time` → assemble `RenderParams` with the SInvert order rules above. Raw slot storage initialized to all zeros; Task 12 loads the startup vector.

- [ ] **Step 4: Run tests to verify they pass**

Run: `swift test --package-path app --filter ControlRouterTests`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(control): 9-slot router with exact maps, 100ms/4ms ramps, SInvert order"
```

---

### Task 12: Cold-start defaults and presets

**Files:**
- Create: `app/Sources/FeedbaxKit/Control/Presets.swift`
- Modify: `app/Sources/FeedbaxKit/Control/ControlRouter.swift` (add `static let startupVector`)
- Test: `app/Tests/FeedbaxKitTests/PresetTests.swift`

**Interfaces:**
- Consumes: `ControlRouter`, `LayerTransform`, `LayerSettings`.
- Produces:
  ```swift
  struct Preset: Codable, Equatable {
    var name: String
    var slots: [Float]                 // 9 raw values
    var eraseControl: Float
    var toggles: PresetToggles
    var layers: [PresetLayer]
  }
  struct PresetToggles: Codable, Equatable {   // all default false — memberwise init with defaults
    var sInvert = false; var worldBump = false; var waveBump = false; var kittyBump = false
    var wave1 = true; var wave2 = false; var layerEnabled = false }
  enum SourceSelection: Codable, Equatable { case stickerIndex(Int), moviePath(String) }
  struct PresetLayer: Codable, Equatable {
    var id: String; var sourceSelection: SourceSelection
    var transform: LayerTransform; var settings: LayerSettings
    var filters: [PresetFilterParams] }        // enum: .brcosa(b,c,s,enabled), .lumaKey(...), .chromaKey(...)
  final class PresetStore {
    init(directory: URL)               // default: Application Support/Feedbax/Presets
    func save(_ preset: Preset) throws
    func load(name: String) throws -> Preset
    func list() -> [String]
    static func capture(name: String, router: ControlRouter, layers: [SeedSource]) -> Preset
    static func apply(_ preset: Preset, router: ControlRouter, layers: [SeedSource], at time: TimeInterval)
  }
  ```
  Task 20's UI calls save/load; Task 22's scenarios are `Preset` + timeline (design §9).
  Res/rate and display assignment are deliberately NOT in `Preset` — venue properties (design §5 Presets).

- [ ] **Step 1: Write the failing tests**

```swift
final class PresetTests: XCTestCase {
  func testStartupVectorIsTheWebuiLoadbang() {
    // spec §04 §1.1 — the 9 floats webui broadcasts ~0 ms after load
    XCTAssertEqual(ControlRouter.startupVector,
                   [0.011905, 0.392857, 0.755952, -0.354023, -0.5, -0.634044, 0.281234, 0.0, 0.71131])
    let r = ControlRouter()
    r.applyStartupDefaults(at: 0)
    XCTAssertEqual(r.rawSlots, ControlRouter.startupVector)
    XCTAssertEqual(r.eraseControl, 1.0, "TRANSPARANCY persisted 1.0 → hard clear until moved (spec §04 §1.4)")
  }
  func testPresetRoundTripsThroughJSON() throws {
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let store = PresetStore(directory: dir)
    let preset = Preset(name: "saturday", slots: ControlRouter.startupVector, eraseControl: 0.6,
                        toggles: PresetToggles(sInvert: true, worldBump: false, waveBump: true,
                                               kittyBump: false, wave1: true, wave2: false, layerEnabled: true),
                        layers: [PresetLayer(id: "sticker", sourceSelection: .stickerIndex(3),
                                             transform: LayerTransform(position: SIMD2(0.2, -0.1),
                                                                       scale: SIMD2(0.747, 0.747),
                                                                       rotationZDegrees: 15),
                                             settings: LayerSettings(zOrder: 2, enabled: true),
                                             filters: [])])
    try store.save(preset)
    XCTAssertEqual(store.list(), ["saturday"])
    XCTAssertEqual(try store.load(name: "saturday"), preset)
  }
  func testApplyRestoresSlotsRampedAndTransformsDirectly() throws {
    final class FakeLayer: SeedSource {
      let id = "sticker"; var transform = LayerTransform(); var layer = LayerSettings()
      func tick(_ frame: FrameContext) -> MTLTexture? { nil }
    }
    let router = ControlRouter()
    _ = router.tick(at: 0)                       // ramps at rest on slot value 0
    let layer = FakeLayer()
    let preset = Preset(name: "p", slots: [1, 0, 0, 0, 0, 0, 0, 0, 0], eraseControl: 0.3,
                        toggles: PresetToggles(), layers: [
                          PresetLayer(id: "sticker", sourceSelection: .stickerIndex(0),
                                      transform: LayerTransform(position: SIMD2(0.5, 0), scale: SIMD2(1, 1),
                                                                rotationZDegrees: 0),
                                      settings: LayerSettings(zOrder: 2, enabled: true), filters: [])])
    PresetStore.apply(preset, router: router, layers: [layer], at: 1.0)
    XCTAssertEqual(router.rawSlots[0], 1)
    XCTAssertEqual(layer.transform.position.x, 0.5, "transforms restore directly")
    // Recall RAMPS (design §5 Presets — glide, not snap): 10 ms in, hue is mid-flight.
    let mid = router.tick(at: 1.010)
    let settled = router.tick(at: 1.2)
    XCTAssertNotEqual(mid.hueShift, settled.hueShift, accuracy: 1e-5)
  }
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `swift test --package-path app --filter PresetTests`
Expected: FAIL.

- [ ] **Step 3: Implement**

`Preset` as plain `Codable` structs; `PresetStore` reads/writes pretty-printed JSON files `<name>.json` under its directory (create on first save). `capture` snapshots router raw slots + erase + toggle states + each layer's selection/transform/settings + filter params (via a small `PresetFilterParams` enum per filter type). `PresetStore.apply` pushes slots through `router.apply` (ramped) and sets toggles/transforms directly. `applyStartupDefaults` = `router.apply(startupVector…)` + `eraseControl = 1.0` — with one wrinkle kept faithful: before the first vector arrives the HSL params are the pix defaults (0.02, 0.5, 0.5) (spec §01 §4); the router's ramps initialize FROM those mapped values so frame 0 matches the original's cold start.

- [ ] **Step 4: Run tests to verify they pass**

Run: `swift test --package-path app --filter PresetTests`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(control): startup defaults from webui loadbang and JSON presets"
```

---

### Task 13: Bindings table + keyboard/trackpad surface

**Files:**
- Create: `app/Sources/FeedbaxKit/Control/Bindings.swift`
- Modify: `app/Sources/FeedbaxKit/Control/DefaultBindings.json`
- Create: `app/Sources/FeedbaxKit/Control/KeyboardTrackpadSurface.swift`
- Test: `app/Tests/FeedbaxKitTests/KeyboardSurfaceTests.swift`

**Interfaces:**
- Consumes: `ControlSurface`, `ControlWrite` (Task 11).
- Produces:
  ```swift
  struct Bindings: Codable {   // versioned, hot-reloadable (design §5)
    var version: Int
    var keys: [String: ToggleEvent]           // "i" → sInvert toggle, "1"…"5" rate, "space" still, etc.
    var trackpad: TrackpadBindings            // which gesture drives which slot + sensitivity
  }
  final class BindingsLoader { static func load(from url: URL?) throws -> Bindings }  // nil → bundled default
  final class KeyboardTrackpadSurface: ControlSurface {
    init(bindings: Bindings)
    // Event entry points — Task 19/20 forward NSEvents here; tests call them directly:
    func keyDown(_ key: String)
    func scroll(dx: Float, dy: Float)          // two-finger drag → pan (the shader-pan touch role)
    func magnify(_ delta: Float)               // pinch → zoom
    func modifiedDrag(dx: Float, dy: Float)    // option-drag → hue (x) / theta (y)
    func poll(_ time: TimeInterval) -> ControlWrite?
  }
  ```

**Default bindings** (design §5 baseline-local-input): trackpad two-finger drag → panX/panY (accumulating, clamped −1..1); pinch → zoom (accumulating); option-drag → hue/theta. Keys: `i` SInvert, `w` worldBump, `a` waveBump, `k` kittyBump, `p` layer enable (pic enable), `[`/`]` erase −/+ 0.05, `f` fullscreen, `s` still capture, `1`/`2` wave 1/2 enable.

- [ ] **Step 1: Write the failing tests**

```swift
final class KeyboardSurfaceTests: XCTestCase {
  func testBundledBindingsLoad() throws {
    let b = try BindingsLoader.load(from: nil)
    XCTAssertEqual(b.version, 1)
    XCTAssertEqual(b.keys["i"], .sInvert(true))   // toggle events carry the *flip* action
  }
  func testScrollAccumulatesIntoPanAndClamps() throws {
    let s = KeyboardTrackpadSurface(bindings: try BindingsLoader.load(from: nil))
    s.scroll(dx: 0.6, dy: 0)
    s.scroll(dx: 0.6, dy: 0)
    let w = s.poll(0)!
    XCTAssertEqual(w.slots[.panX]!, 1.0, accuracy: 1e-5, "clamped to slot range −1..1")
  }
  func testKeyEmitsToggleOncePerPress() throws {
    let s = KeyboardTrackpadSurface(bindings: try BindingsLoader.load(from: nil))
    s.keyDown("i")
    XCTAssertEqual(s.poll(0)?.toggles, [.sInvert(true)])
    XCTAssertNil(s.poll(0)?.toggles.first, "consumed — poll drains the event queue")
    s.keyDown("i")
    XCTAssertEqual(s.poll(0)?.toggles, [.sInvert(false)], "second press flips back")
  }
  func testPollAssertsOnlyTouchedSlots() throws {
    let s = KeyboardTrackpadSurface(bindings: try BindingsLoader.load(from: nil))
    s.magnify(0.1)
    let w = s.poll(0)!
    XCTAssertNotNil(w.slots[.zoom]); XCTAssertNil(w.slots[.panX], "partial write (design §5)")
  }
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `swift test --package-path app --filter KeyboardSurfaceTests`
Expected: FAIL.

- [ ] **Step 3: Implement**

`Bindings`/`BindingsLoader` decode the JSON (bundled default via `Bundle.module.url(forResource: "DefaultBindings", withExtension: "json")`). Fill in `DefaultBindings.json` with the table above (keys map to `{"toggle": "sInvert"}`-style entries decoded into `ToggleEvent` with flip semantics resolved by the surface's own state). The surface keeps accumulator state per bound slot, a drained toggle queue, and marks slots dirty on input so `poll` returns only touched slots since the last poll (plus held accumulators — pan/zoom keep asserting their current value while nonzero, mirroring how the original's sliders keep their last position).

- [ ] **Step 4: Run tests to verify they pass**

Run: `swift test --package-path app --filter KeyboardSurfaceTests`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(control): bindings table and keyboard/trackpad surface"
```

---

### Task 14: Game controller surface

**Files:**
- Create: `app/Sources/FeedbaxKit/Control/GamepadSurface.swift`
- Test: `app/Tests/FeedbaxKitTests/GamepadSurfaceTests.swift`

**Interfaces:**
- Consumes: `ControlSurface`, `Bindings` (Task 13 — gamepad axis map added to the same JSON, version stays 1 since it ships together).
- Produces:
  ```swift
  protocol GamepadState {          // seam over GCExtendedGamepad so tests need no hardware
    var leftStick: SIMD2<Float> { get }; var rightStick: SIMD2<Float> { get }
    var leftTrigger: Float { get }; var rightTrigger: Float { get }
    var dpad: SIMD2<Float> { get }
    var pressedButtons: [String] { get }   // "a", "b", "x", "y", "menu"
  }
  final class GamepadSurface: ControlSurface {
    init()                          // subscribes to GCController connect notifications
    var stateProvider: (() -> GamepadState?)?   // test seam; nil → live GCController
    func poll(_ time: TimeInterval) -> ControlWrite?
  }
  ```

**Mapping** (design §5): left stick → panX/panY; right stick → hue (x) / bias (y); triggers → zoom (right, 0..1 → −1..1) / theta (left); d-pad up/down steps erase ±0.05, left/right steps saturation ∓0.1; buttons: a=SInvert, b=layer enable, x=wave1, y=wave2, menu=fullscreen. Sticks get a 0.08 deadzone (GC framework does not apply one).

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/GamepadSurfaceTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

struct FakePad: GamepadState {
  var leftStick = SIMD2<Float>.zero; var rightStick = SIMD2<Float>.zero
  var leftTrigger: Float = 0; var rightTrigger: Float = 0
  var dpad = SIMD2<Float>.zero; var pressedButtons: [String] = []
}

final class GamepadSurfaceTests: XCTestCase {
  func surface(_ pad: FakePad) -> (GamepadSurface, () -> ControlWrite?) {
    var current = pad
    let s = GamepadSurface()
    s.stateProvider = { current }
    return (s, { s.poll(0) })
  }
  func testDeadzoneAssertsNothing() {
    let (_, poll) = surface(FakePad(leftStick: SIMD2(0.05, -0.05)))
    XCTAssertNil(poll()?.slots[.panX])
  }
  func testSticksAndTriggersMapToSlots() {
    var pad = FakePad(); pad.leftStick = SIMD2(1, 0.5); pad.rightTrigger = 0.75
    let (_, poll) = surface(pad)
    let w = poll()!
    XCTAssertEqual(w.slots[.panX]!, 1, accuracy: 1e-4)
    XCTAssertEqual(w.slots[.panY]!, 0.5, accuracy: 1e-4)
    XCTAssertEqual(w.slots[.zoom]!, 0.5, accuracy: 1e-4, "trigger 0..1 → −1..1")
  }
  func testButtonsAndDpadAreEdgeTriggered() {
    let s = GamepadSurface()
    var pad = FakePad(); pad.pressedButtons = ["a"]; pad.dpad = SIMD2(0, 1)
    s.stateProvider = { pad }
    let first = s.poll(0)!
    XCTAssertEqual(first.toggles, [.sInvert(true)])
    XCTAssertNotNil(first.slots[.eraseStep])   // see note below — d-pad erase is a router-side step
    let held = s.poll(0.016)
    XCTAssertNil(held, "held button/d-pad must not re-fire")
  }
}
```

Note on d-pad erase: erase is not a slot, so the surface exposes it as a dedicated field — change `ControlWrite` (Task 11) to add `var eraseStep: Float? = nil` alongside slots/toggles, applied by the router as `eraseControl += step` (clamped 0…1). Add `.eraseStep` handling to `ControlRouter.apply` and one assertion for it in `ControlRouterTests` while here (`r.apply(ControlWrite(eraseStep: -0.05), at: 0)` → `eraseControl == 0.95` from the 1.0 default). The keyboard `[`/`]` bindings (Task 13) use the same field. (`w.slots[.eraseStep]` in the test above is then written as `first.eraseStep` — mirror the final shape.)

- [ ] **Step 2: Run to verify FAIL**, filter `GamepadSurfaceTests`.

- [ ] **Step 3: Implement** — poll reads `stateProvider?() ?? liveControllerState()`; 0.08 stick deadzone; edge-detect buttons/d-pad against the previous poll's snapshot; live path maps `GCController.controllers().first?.extendedGamepad` (subscribe to `GCController.didConnectNotification` to log connects). Mapping per the table above.

- [ ] **Step 4: Run to verify PASS** (including the updated `ControlRouterTests`).

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(control): game controller surface with deadzone and edge-triggered toggles"
```

---
### Task 15: StickerSource — folder scan, decode-on-selection, index/normalized selection

**Files:**
- Create: `app/Sources/FeedbaxKit/Sources/StickerSource.swift`
- Test: `app/Tests/FeedbaxKitTests/StickerSourceTests.swift`

**Interfaces:**
- Consumes: `SeedSource` (Task 9), `MetalContext`.
- Produces:
  ```swift
  final class StickerSource: SeedSource {
    init(context: MetalContext, folder: URL)
    private(set) var items: [URL]               // sorted by filename, images + movies filtered out to images here
    var itemCount: Int { get }                  // the movsFound equivalent (spec §02 §1)
    var selectedIndex: Int { get set }          // clamped 0..<count; decode happens HERE, not in tick
    func select(normalized: Float)              // 0..1 → index (spec §02 §2 item 4)
    func rescan()                               // repopulates; resets selectedIndex to 0 (spec §02 §2)
    var onCountChanged: ((Int) -> Void)?
    func tick(_ frame: FrameContext) -> MTLTexture?   // cached texture only — never decodes
  }
  ```
  Task 19 instantiates it on `<repo>/input/transparent-background/`; Task 20 binds index UI.

**Decode rule** (spec §02 §3 + design §5): decode on *selection*, cache the `MTLTexture`, `tick` just returns it. PNG alpha arrives premultiplied from CGContext; un-premultiply at decode (CPU, once per selection) so the compositor's straight-alpha blending matches Jitter's convention.

- [ ] **Step 1: Write the failing tests**

```swift
final class StickerSourceTests: XCTestCase {
  var folder: URL!
  override func setUpWithError() throws {
    folder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
    // Write three 2×2 PNGs (red, green, blue; blue has alpha 0.5) via CGImage — helper in test file.
    try writePNG(folder.appendingPathComponent("a-red.png"), rgba: [1, 0, 0, 1])
    try writePNG(folder.appendingPathComponent("b-green.png"), rgba: [0, 1, 0, 1])
    try writePNG(folder.appendingPathComponent("c-blue.png"), rgba: [0, 0, 1, 0.5])
    try "not an image".write(to: folder.appendingPathComponent("notes.txt"), atomically: true, encoding: .utf8)
  }
  func testScanFiltersAndSortsAndCounts() throws {
    let src = StickerSource(context: try MetalContext(), folder: folder)
    XCTAssertEqual(src.itemCount, 3, "txt file excluded")
    XCTAssertEqual(src.items.map(\.lastPathComponent), ["a-red.png", "b-green.png", "c-blue.png"])
  }
  func testSelectionDecodesOnceAndTickReturnsCache() throws {
    let ctx = try MetalContext()
    let src = StickerSource(context: ctx, folder: folder)
    src.selectedIndex = 1
    let cb = ctx.queue.makeCommandBuffer()!
    let frame = FrameContext(index: 0, time: 0, delta: 1/60, canvasSize: SIMD2(8, 8),
                             commandBuffer: cb, pool: ctx.pool)
    let tex = try XCTUnwrap(src.tick(frame))
    XCTAssertTrue(src.tick(frame) === tex, "tick must return the cached texture, not re-decode")
    let px = ctx.readPixels(tex)
    XCTAssertEqual(px[0].y, 1, accuracy: 2.0 / 255, "green sticker decoded")
  }
  func testStraightAlphaSurvivesDecode() throws {
    let ctx = try MetalContext()
    let src = StickerSource(context: ctx, folder: folder)
    src.selectedIndex = 2                               // blue, alpha 0.5
    let px = ctx.readPixels(try XCTUnwrap(src.tick(makeFrame(ctx))))
    XCTAssertEqual(px[0].z, 1.0, accuracy: 4.0 / 255, "un-premultiplied: rgb NOT scaled by alpha")
    XCTAssertEqual(px[0].w, 0.5, accuracy: 2.0 / 255)
  }
  func testNormalizedSelectionAndRescanReset() throws {
    let src = StickerSource(context: try MetalContext(), folder: folder)
    src.select(normalized: 0.99); XCTAssertEqual(src.selectedIndex, 2)
    src.select(normalized: 0.0);  XCTAssertEqual(src.selectedIndex, 0)
    src.selectedIndex = 2
    try FileManager.default.removeItem(at: folder.appendingPathComponent("c-blue.png"))
    src.rescan()
    XCTAssertEqual(src.itemCount, 2)
    XCTAssertEqual(src.selectedIndex, 0, "rescan resets index to 0 (spec §02 §2)")
  }
}
```

Include the `writePNG` / `makeFrame` helpers in the test file (CGContext → CGImageDestination PNG; ~20 lines).

- [ ] **Step 2: Run to verify FAIL**, filter `StickerSourceTests`.

- [ ] **Step 3: Implement** — scan with `FileManager.contentsOfDirectory` filtered by extension set `png/gif/tif/tiff/bmp/jpg/jpeg/heic` (image half of the original's types list; movies belong to `MovieSource`), sorted by filename. Decode: `CGImageSourceCreateWithURL` → draw into `CGContext(premultipliedLast)` → un-premultiply loop (`rgb /= a` where `a > 0`) → `context.makeTexture(..., format: .rgba8Unorm, pixels:)`. `select(normalized:)` = `min(Int(v * Float(count)), count − 1)`. `layer.zOrder` defaults 2 (the original's layer number, spec §02 §5); `layer.enabled` defaults false (pic enable off at load, spec §04 §1.4); `transform` defaults from the imageMove map — position (0,0), scale from pic-size slider default 0.747, rotation 0 (Constants table).

- [ ] **Step 4: Run to verify PASS.**

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(sources): StickerSource with decode-on-selection and straight alpha"
```

---

### Task 16: MovieSource — AVPlayer playback into Metal

**Files:**
- Create: `app/Sources/FeedbaxKit/Sources/MovieSource.swift`
- Test: `app/Tests/FeedbaxKitTests/MovieSourceTests.swift`

**Interfaces:**
- Consumes: `SeedSource`, `MetalContext`.
- Produces:
  ```swift
  final class MovieSource: SeedSource {
    init(context: MetalContext)
    func load(url: URL)                          // starts looped playback (AVPlayerLooper)
    var isPlaying: Bool { get }
    func tick(_ frame: FrameContext) -> MTLTexture?   // current frame via CVMetalTextureCache, zero-copy
  }
  ```
  Movies advance on AVPlayer's own clock; `tick` merely fetches (design §5 rule).

- [ ] **Step 1: Write the failing test**

`MovieSourceTests` generates a fixture in `setUpWithError`: a 12-frame 64×64 H.264 movie whose frames sweep red→black, written with `AVAssetWriter` (append pixel buffers via `AVAssetWriterInputPixelBufferAdaptor` at 30 fps; ~50 lines, include in full in the test file). Then:

```swift
func meanRed(_ ctx: MetalContext, _ tex: MTLTexture) -> Float {
  let px = ctx.readPixels(tex)
  return px.reduce(0) { $0 + $1.x } / Float(px.count)
}

func firstFrame(_ src: MovieSource, _ ctx: MetalContext, deadline: TimeInterval = 2) -> MTLTexture? {
  let end = Date().addingTimeInterval(deadline)
  while Date() < end {
    let cb = ctx.queue.makeCommandBuffer()!
    let frame = FrameContext(index: 0, time: 0, delta: 1/60, canvasSize: SIMD2(64, 64),
                             commandBuffer: cb, pool: ctx.pool)
    if let t = src.tick(frame) { return t }
    Thread.sleep(forTimeInterval: 0.05)
  }
  return nil
}

func testTickDeliversAdvancingFrames() throws {
  let ctx = try MetalContext()
  let src = MovieSource(context: ctx)
  src.load(url: fixtureURL)
  let first = try XCTUnwrap(firstFrame(src, ctx), "player produced no frame within 2 s")
  XCTAssertEqual(first.width, 64); XCTAssertEqual(first.height, 64)
  let redA = meanRed(ctx, first)
  Thread.sleep(forTimeInterval: 0.3)                       // ≥ 9 frames of the 30 fps sweep
  let second = try XCTUnwrap(firstFrame(src, ctx))
  let redB = meanRed(ctx, second)
  XCTAssertGreaterThan(abs(redA - redB), 0.05,
                       "red sweep must advance — the movie plays on its own clock (design §5)")
}
```

Timing assertions stay loose on purpose (CI machines stutter) — the retry helper and the 0.05 mean-red delta are the contract, not exact frame indices.

- [ ] **Step 2: Run to verify FAIL**, filter `MovieSourceTests`.

- [ ] **Step 3: Implement** — `AVQueuePlayer` + `AVPlayerLooper`, `AVPlayerItemVideoOutput` with `kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA` and `kCVPixelBufferMetalCompatibilityKey: true`; `tick` = `hasNewPixelBuffer(forItemTime:)` → `copyPixelBuffer` → `CVMetalTextureCacheCreateTextureFromImage` (`.bgra8Unorm`) → cache last texture (return the cached one when no new buffer — a movie at 30 fps under a 60 Hz engine repeats frames, as the original did). Hold the `CVMetalTexture` alongside the `MTLTexture` so the backing IOSurface outlives the frame.

- [ ] **Step 4: Run to verify PASS.**

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(sources): MovieSource with looped AVPlayer and zero-copy Metal frames"
```

---

### Task 17: Audio analysis — EQ bands, envelope followers, wave buffers

**Files:**
- Create: `app/Sources/FeedbaxKit/Audio/Biquad.swift`
- Create: `app/Sources/FeedbaxKit/Audio/EnvelopeFollowers.swift`
- Create: `app/Sources/FeedbaxKit/Audio/WaveBuffer.swift`
- Create: `app/Sources/FeedbaxKit/Audio/AudioAnalysis.swift`
- Test: `app/Tests/FeedbaxKitTests/AudioAnalysisTests.swift`

**Interfaces:**
- Consumes: nothing engine-side (pure DSP + an AVAudioEngine shell).
- Produces:
  ```swift
  struct Biquad { init(bandpass f: Float, q: Float, gain: Float, sampleRate: Float)
    mutating func process(_ x: Float) -> Float
    mutating func process(buffer: [Float]) -> [Float] }
  struct SlideEnvelope {                       // slide~: y += (x−y)/slide, per sample (spec §03 glossary)
    init(up: Float, down: Float)               // in samples-to-converge
    mutating func process(_ x: Float) -> Float }
  struct RunningAverage { init(window: Int, mode: Mode)  // average~ "absolute", window 100 samples
    mutating func process(_ x: Float) -> Float }
  final class AudioBands {                     // the whole per-buffer chain, injectable input
    init(sampleRate: Float)
    var wave2InputGain: Float = 0.0            // checklist #15: near-silent default until Task 25
    func ingest(_ samples: [Float])            // mic tap or test injection
    // Sampled once per render frame (the ctrlbang/audiobang cadence, spec §03 §7):
    func frameValues() -> FrameAudio           // resets the since-last-frame means
  }
  struct FrameAudio {
    var worldBump: Float        // 144.3 Hz → abs → slide 2500/2500 → avg(100,absolute) → ×0.05
    var waveBumpRaw: Float      // 46.7 Hz ×2.2 → mean since last frame (NO rectifier)
    var kittyBumpRaw: Float     // 46.7 Hz → mean since last frame (rectify+slide happens receiver-side)
    var wave1Points: [Float]    // 1024-sample window, downsample 2 → 512 pts, jit.slide up 8 / down 3
    var wave2Points: [Float]    // 1024-sample window, downsample 512 → 2 pts [?] — Task 25 verifies
  }
  final class KittyBumpReceiver {              // webui-side abs + slide 22/14 (spec §04 §1.3)
    func process(_ raw: Float) -> Float }
  final class AudioAnalysis {                  // AVAudioEngine input tap → AudioBands (thin shell)
    init(bands: AudioBands) throws; func start() throws; func stop()
    var inputGain: Float                       // uiGain — raw multiply, unsmoothed (spec §03 §2)
  }
  ```
  Task 18 consumes `wave1Points`/`wave2Points`/`waveBumpRaw`; Task 19 wires `worldBump` → `RenderParams.worldBump` and `KittyBumpReceiver` → sticker transform offsets. Enables all default OFF (Constants table) — gating lives engine-side (Task 19), the DSP always runs.

- [ ] **Step 1: Write the failing tests**

```swift
final class AudioAnalysisTests: XCTestCase {
  func testBandpassSelectsItsBand() {
    var bq = Biquad(bandpass: 46.7, q: 0.92, gain: 1.02, sampleRate: 48000)
    let inBand = rms(processSine(&bq, freq: 46.7))
    var bq2 = Biquad(bandpass: 46.7, q: 0.92, gain: 1.02, sampleRate: 48000)
    let outOfBand = rms(processSine(&bq2, freq: 1000))
    XCTAssertGreaterThan(inBand, outOfBand * 10, "46.7 Hz passes, 1 kHz attenuates ≥20 dB")
  }
  func testSlideConvergence() {
    // slide~ semantics: step response after k samples leaves (1−1/slide)^k remaining.
    var s = SlideEnvelope(up: 100, down: 100)
    var y: Float = 0
    for _ in 0..<100 { y = s.process(1) }
    XCTAssertEqual(y, 1 - pow(1 - 1.0 / 100, 100), accuracy: 1e-3)   // ≈ 0.634
  }
  func testWorldBumpRespondsToBassBurst() {
    let bands = AudioBands(sampleRate: 48000)
    bands.ingest(sine(144.3, seconds: 0.5, sampleRate: 48000, amplitude: 0.8))
    let v = bands.frameValues().worldBump
    XCTAssertGreaterThan(v, 0.001)
    XCTAssertLessThan(v, 0.05, "×0.05 final scale keeps bumps subtle (spec §03 §7a)")
    let silent = AudioBands(sampleRate: 48000)
    silent.ingest([Float](repeating: 0, count: 24000))
    XCTAssertEqual(silent.frameValues().worldBump, 0, accuracy: 1e-4)
  }
  func testWaveBumpIsMeanSinceLastFrameTimes2Point2() {
    // DC into the 46.7 band ≈ blocked; use a 46.7 Hz sine and check the UNRECTIFIED mean
    // is near zero while worldBump (rectified) is not — the pipeline difference (spec §03 §7).
    let bands = AudioBands(sampleRate: 48000)
    bands.ingest(sine(46.7, seconds: 1.0, sampleRate: 48000, amplitude: 0.8))
    let f = bands.frameValues()
    XCTAssertEqual(abs(f.waveBumpRaw), 0.1, accuracy: 0.1, "no rectifier → mean ≈ 0-ish")
  }
  func testWaveBuffersShapeAndSmoothing() {
    let bands = AudioBands(sampleRate: 48000)
    bands.ingest(sine(46.7, seconds: 0.1, sampleRate: 48000, amplitude: 0.5))
    let f = bands.frameValues()
    XCTAssertEqual(f.wave1Points.count, 512, "framesize 1024 / downsample 2")
    XCTAssertEqual(f.wave2Points.count, 2, "downsample 512 — flagged [?], Task 25")
    XCTAssertEqual(f.wave2Points[0], 0, accuracy: 1e-5, "wave2 input silent by default (checklist #15)")
  }
  func testKittyReceiverRectifiesAndSlews() {
    let r = KittyBumpReceiver()
    _ = r.process(-0.5)                       // abs() first
    let v = r.process(-0.5)
    XCTAssertGreaterThan(v, 0, "rectified"); XCTAssertLessThan(v, 0.5, "slewed by slide 22")
  }
}
```

(`sine`/`processSine`/`rms` helpers in the test file.)

- [ ] **Step 2: Run to verify FAIL**, filter `AudioAnalysisTests`.

- [ ] **Step 3: Implement**

`Biquad`: RBJ constant-peak bandpass — `omega = 2π·f/Fs`, `alpha = sin(omega)/(2Q)`; `b0 = Q·alpha? ` — use the RBJ "BPF (constant 0 dB peak gain)" form `b0 = alpha, b1 = 0, b2 = −alpha, a0 = 1+alpha, a1 = −2cos(omega), a2 = 1−alpha`, output ×`gain`. Comment: filtergraph~'s exact filter type is unresolved (spec §03 open q. 3); resonant bandpass at the documented f/Q/gain is the port's documented choice, parity-reviewed against footage. `SlideEnvelope`: `y += (x−y)/up` when rising, `/down` when falling. `RunningAverage`: circular buffer of |x| (absolute mode), mean of last `window`. `AudioBands.ingest` runs the three band chains per buffer and accumulates: worldBump chain per-sample (abs→slide→runningAvg, snapshot = last value at `frameValues`, ×0.05); wave/kitty accumulate sum+count for mean-since-last-frame (reset on `frameValues` — the avg~-on-bang semantics); wave buffers keep a 1024-sample ring per band (wave2's input pre-scaled by `wave2InputGain`), `frameValues` emits stride-decimated copies, wave1's through a per-point `SlideEnvelope(up: 8, down: 3)` array (jit.slide). `KittyBumpReceiver`: `abs` then `SlideEnvelope(up: 22, down: 14)` stepped once per call (control-rate slide, spec §04 §1.3). `AudioAnalysis`: `AVAudioEngine.inputNode` tap at 48 kHz mono → `bands.ingest(buffer × inputGain)`.

- [ ] **Step 4: Run to verify PASS** (tune only test tolerances if DSP settle times bite, never the constants).

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(audio): EQ bands, three envelope followers, wave buffers per spec 03"
```

---

### Task 18: Waveform rendering — radial wave 1, dotted wave 2, alpha pulse

**Files:**
- Create: `app/Sources/FeedbaxKit/Engine/WaveformRenderer.swift`
- Modify: `app/Sources/FeedbaxKit/Shaders/Composite.metal` (add `fbx_ribbon_v` + `fbx_point_v`/`fbx_point_f`)
- Test: `app/Tests/FeedbaxKitTests/WaveformTests.swift`

**Interfaces:**
- Consumes: `Compositor` overlays (Task 9), `FrameAudio` (Task 17), `QuadRenderer` blend modes (Task 8).
- Produces:
  ```swift
  struct WaveformStyle {          // both parity styles are static lets on this type:
    static let wave1: WaveformStyle   // radial, pos (0,−0.85,0), scale (1.5,1,0), lineWidthPx 12,
                                      // color (0.392375, 0.23808, 0, 0.8), blend .alphaOver, closed loop
    static let wave2: WaveformStyle   // linear points, pos (0,0,−2), scale (1,1,1), pointSizePx ~8 (circpoints 5),
                                      // color (0, 0.786722, 0.821229, ·), blend .srcAlphaDstAlpha
  }
  final class WaveformRenderer {
    init(context: MetalContext) throws
    var wave1Enabled: Bool  // default true (soundwave_enable loadmess 1, spec §04 §1.4)
    var wave2Enabled: Bool  // default false (soundwave_enable1 unsaved → off)
    var wave2BaseAlpha: Float // manual base slider; default 0.5 [?] not in listing (spec §03 §6)
    /// Geometry only — pure, testable: world-space polyline points for a frame of samples.
    static func wave1Polyline(_ samples: [Float], style: WaveformStyle) -> [SIMD2<Float>]
    static func wave2Points(_ samples: [Float], style: WaveformStyle) -> [SIMD2<Float>]
    /// Overlay draw hooked into Compositor.overlays (draws under the feedback plane).
    func draw(_ enc: MTLRenderCommandEncoder, frame: FrameContext, audio: FrameAudio,
              projection: float4x4)
  }
  ```

**Geometry reading of `jit.gl.graph`** (documented approximation, parity-reviewed against archived stills): wave 1 `radial 1` → closed loop: point i of N at `θᵢ = 2π·i/N`, radius `r = radialRadius(1.0) + sampleᵢ`, position `center + scale.xy · (r·cos θᵢ, r·sin θᵢ)`; drawn as a screen-space ribbon `lineWidthPx` wide. Wave 2 → linear: x spans `±scale.x` across N points, y = `sampleᵢ·scale.y`, drawn as square point sprites via two triangles per point (`poly_mode (0,0)` + `circpoints 5`, spec §03 §5). Wave 2's color alpha = `wave2BaseAlpha + audio.waveBumpRaw·2.2… ` — no: the ×2.2 already happened in `AudioBands`; alpha = `base + waveBumpRaw`, unclamped on the CPU side (GL clamps at raster, checklist #10).

- [ ] **Step 1: Write the failing tests**

```swift
final class WaveformTests: XCTestCase {
  func testWave1IsClosedLoopAtRadiusOneWhenSilent() {
    let pts = WaveformRenderer.wave1Polyline([Float](repeating: 0, count: 512), style: .wave1)
    XCTAssertEqual(pts.count, 513, "closed: first point repeated")
    XCTAssertEqual(pts.first!, pts.last!)
    // radius 1 scaled by (1.5, 1) around (0, −0.85): rightmost point at x = 1.5, y = −0.85
    XCTAssertEqual(pts[0].x, 1.5, accuracy: 1e-4)
    XCTAssertEqual(pts[0].y, -0.85, accuracy: 1e-4)
  }
  func testWave1AmplitudeModulatesRadius() {
    var samples = [Float](repeating: 0, count: 512); samples[0] = 0.5
    let pts = WaveformRenderer.wave1Polyline(samples, style: .wave1)
    XCTAssertEqual(pts[0].x, 2.25, accuracy: 1e-4, "(1 + 0.5)·1.5")
  }
  func testWave2PointsSpanWidth() {
    let pts = WaveformRenderer.wave2Points([0.2, -0.2], style: .wave2)
    XCTAssertEqual(pts.count, 2)
    XCTAssertEqual(pts[0].x, -1, accuracy: 1e-4); XCTAssertEqual(pts[1].x, 1, accuracy: 1e-4)
    XCTAssertEqual(pts[0].y, 0.2, accuracy: 1e-4)
  }
  func testParityStyleConstants() {
    XCTAssertEqual(WaveformStyle.wave1.color, SIMD4(0.392375, 0.23808, 0, 0.8))
    let c2 = WaveformStyle.wave2.color
    XCTAssertEqual(SIMD3(c2.x, c2.y, c2.z), SIMD3(0, 0.786722, 0.821229))
    XCTAssertEqual(WaveformStyle.wave1.lineWidthPx, 12)
  }
}
```

- [ ] **Step 2: Run to verify FAIL**, filter `WaveformTests`.

- [ ] **Step 3: Implement** — geometry functions as specified; `draw` builds a vertex buffer per waveform per frame (512·2 ribbon vertices / N·6 point vertices — trivial at these counts), ribbon expansion in the vertex shader using a per-vertex `(point, normal, halfWidthNDC)` layout, both drawn with the projection at their z (wave 1 at z=0 within its position; wave 2 at z=−2 — its points project smaller, which is why the original parks it deeper). Wave 2's draw uses `.srcAlphaDstAlpha`; wave 1 `.alphaOver` (spec §03 §5 tables).

- [ ] **Step 4: Run to verify PASS.**

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(engine): radial and dotted waveform rendering with parity styles"
```

---
### Task 19: Engine assembly, FrameClock, window, fullscreen, res/rate presets

**Files:**
- Create: `app/Sources/FeedbaxKit/Engine/Engine.swift`
- Create: `app/Sources/FeedbaxKit/Engine/FrameClock.swift`
- Create: `app/Sources/FeedbaxKit/Engine/OutputStage.swift`
- Create: `app/Sources/FeedbaxKit/UI/PreviewView.swift`
- Modify: `app/Sources/feedbax-dev/main.swift` (real windowed app)
- Test: `app/Tests/FeedbaxKitTests/EngineTests.swift`

**Interfaces:**
- Consumes: everything above.
- Produces:
  ```swift
  final class Engine {                      // the one object that owns the frame recipe
    init(context: MetalContext) throws     // builds core, compositor, router, bands, renderer, sources
    let router: ControlRouter
    let sticker: StickerSource; let movie: MovieSource
    let bands: AudioBands; let waveforms: WaveformRenderer
    var layerMode: LayerMode               // .sticker / .movie — the either-or as ONE switch (design §5)
    var bumpsEnabled: (world: Bool, wave: Bool, kitty: Bool)   // all default false
    /// One tick: router → audio frameValues → sources tick → core.renderFrame. Pure with
    /// respect to the injected clock — golden tests drive this directly.
    func step(at time: TimeInterval, commandBuffer: MTLCommandBuffer) -> MTLTexture
    func setResolution(_ size: SIMD2<Int>)          // preset list in Constants table; clears (Task 8)
    var frameRate: Int                              // 30/60/90/100/120
    static let resolutionPresets: [SIMD2<Int>]
    static let frameRatePresets = [30, 60, 90, 100, 120]
  }
  final class FrameClock {                  // CAMetalDisplayLink at `frameRate`; injectable for tests
    init(layer: CAMetalLayer, rate: Int, tick: @escaping (CAMetalDisplayLink.Update) -> Void) }
  final class OutputStage {                 // blits/draws the accumulator into the drawable,
    // aspect-fit, plus the frame-time HUD (rolling p50/p99 text overlay, toggleable)
  }
  ```

**Engine.step wiring** (this is the whole instrument in one function — comment each line with its spec §):
1. `let audio = bands.frameValues()` — once per frame, the ctrlbang/audiobang cadence (spec §03 §7).
2. `var params = router.tick(at: time)`; then the bump gate: `params.worldBump = bumpsEnabled.world ? audio.worldBump : 0`.
3. Kitty offset: when enabled, `kitty.process(audio.kittyBumpRaw)` ADDS onto the sticker layer transform — scale x/y and position y — on top of the manual values (modulator rule, design §5; spec §04 §1.3); when disabled contributes 0.
4. Active layer = `layerMode == .sticker ? sticker : movie`; its `FilterChain` applies to its ticked texture (P1 default chains are EMPTY — design §5 parity defaults; golden scenarios attach filters explicitly).
5. `core.renderFrame(frame, params:) { enc in compositor.drawSeeds(...); waveforms.draw(..., audio: audio, ...) }`.

- [ ] **Step 1: Write the failing tests**

```swift
final class EngineTests: XCTestCase {
  func testDeterministicHeadlessRun() throws {
    // Two engines, same injected clock and inputs → byte-identical accumulators after 30 frames.
    // This is the property the golden harness (Task 22) stands on.
    let ctx = try MetalContext()
    func run() throws -> [SIMD4<Float>] {
      let e = try Engine(context: ctx)
      e.router.applyStartupDefaults(at: 0)
      e.setResolution(SIMD2(64, 36))
      var last: MTLTexture!
      for i in 0..<30 {
        let cb = ctx.queue.makeCommandBuffer()!
        last = e.step(at: Double(i) / 60, commandBuffer: cb)
        cb.commit(); cb.waitUntilCompleted(); ctx.pool.endFrame()
      }
      return ctx.readPixels(last)
    }
    let a = try run(), b = try run()
    for i in 0..<a.count { XCTAssertEqual(a[i], b[i], "pixel \(i) diverged") }
  }
  func testResolutionPresetListMatchesSpec() {
    XCTAssertEqual(Engine.resolutionPresets.count, 14)          // Constants table
    XCTAssertTrue(Engine.resolutionPresets.contains(SIMD2(7680, 4320)))
    XCTAssertEqual(Engine.frameRatePresets, [30, 60, 90, 100, 120], "five, not four (spec §01 §1)")
  }
  func testWorldBumpGateDefaultsOff() throws {
    let e = try Engine(context: try MetalContext())
    XCTAssertFalse(e.bumpsEnabled.world); XCTAssertFalse(e.bumpsEnabled.wave)
    XCTAssertFalse(e.bumpsEnabled.kitty)   // spec §03 §7 — all three default OFF
  }
}
```

- [ ] **Step 2: Run to verify FAIL**, filter `EngineTests`.

- [ ] **Step 3: Implement** — `Engine` as specified; `FrameClock` wraps `CAMetalDisplayLink` (macOS 14) with `preferredFrameRateRange` pinned to `frameRate`; `OutputStage` draws the accumulator aspect-fit into the drawable via `QuadRenderer` and renders the HUD (frame times into a ring buffer; text via a small `NSAttributedString` → texture cache, redrawn at 2 Hz). `PreviewView` = `NSViewRepresentable` hosting the `CAMetalLayer`, forwarding key/scroll/magnify/option-drag events to `KeyboardTrackpadSurface`, Esc + `f` toggling `window.toggleFullScreen` (the original's Esc, spec §01 §1). `feedbax-dev/main.swift`: `NSApplication` + SwiftUI window showing `PreviewView` (operator panel joins in Task 20); `--soak` flag parsed but unimplemented until Task 24.

- [ ] **Step 4: Run tests to verify they pass**, then run the app by hand:

Run: `swift run --package-path app feedbax-dev`
Expected: window opens; with a populated `input/transparent-background/` and `p` pressed, the sticker feeds back under rotate/zoom controlled by trackpad/keys; Esc toggles fullscreen. (Manual smoke — the automated determinism test is the gate.)

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(engine): assembled engine with display link, fullscreen, res/rate presets"
```

---

### Task 20: Operator UI (SwiftUI)

**Files:**
- Create: `app/Sources/FeedbaxKit/UI/EngineViewModel.swift`
- Create: `app/Sources/FeedbaxKit/UI/OperatorPanel.swift`
- Modify: `app/Sources/feedbax-dev/main.swift` (split view: preview + panel)
- Test: `app/Tests/FeedbaxKitTests/EngineViewModelTests.swift`

**Interfaces:**
- Consumes: `Engine`, `PresetStore`, `ControlSurface`.
- Produces: `final class EngineViewModel: ObservableObject, ControlSurface` — sliders publish into `poll` like any other surface (the operator UI is *a surface*, not a privileged path — design §5); `OperatorPanel: View` with: 7 slot sliders + erase slider; toggles SInvert / layer enable / wave 1 / wave 2 / 3 bumps; layer mode picker; sticker index stepper + normalized slider (`movsFound`-bounded) + movie file picker; res/rate pickers; preset name field + save/recall list; HUD toggle.

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/EngineViewModelTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

final class EngineViewModelTests: XCTestCase {
  func testSliderWritesAreAssertedOnceThenDrained() {
    let vm = EngineViewModel()
    vm.slider(.hue, changedTo: 0.5)
    let w = vm.poll(0)!
    XCTAssertEqual(w.slots[.hue]!, 0.5, accuracy: 1e-6)
    XCTAssertNil(vm.poll(0)?.slots[.hue], "drained after poll — sliders assert on change only")
  }
  func testSliderRanges() {
    XCTAssertEqual(EngineViewModel.range(for: .hue), -1.0...1.0)
    XCTAssertEqual(EngineViewModel.range(for: .saturation), 0.0...1.0,
                   "sat is the one unipolar slot (spec §04 §1.2)")
  }
  func testToggleEmitsEvent() {
    let vm = EngineViewModel()
    vm.setSInvert(true)
    XCTAssertEqual(vm.poll(0)?.toggles, [.sInvert(true)])
  }
}
```

- [ ] **Step 2: Run to verify FAIL**, filter `EngineViewModelTests`.

- [ ] **Step 3: Implement** — `EngineViewModel` exposes `slider(_ slot:changedTo:)`, `setSInvert`, etc., dirty-marking into a pending `ControlWrite` drained by `poll`; `static func range(for: ControlSlot) -> ClosedRange<Double>` centralizes slider ranges; `@Published` mirrors for SwiftUI binding call the same entry points. The panel is plain SwiftUI forms in two columns; `recall(preset:)`/`saveCurrent(name:)` call `PresetStore`. Slider labels use the original's names (HUE-SHIFT, BRIGHTNESS, ZOOM, rotate, SATURATION, TRANSPARANCY…) so a performer who knew the Max UI is at home.

- [ ] **Step 4: Run to verify PASS**; manual: `swift run --package-path app feedbax-dev` shows panel beside preview; sliders glide (100 ms), erase snaps.

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(ui): SwiftUI operator panel as a control surface with presets"
```

---

### Task 21: Still capture

**Files:**
- Create: `app/Sources/FeedbaxKit/Engine/StillCapture.swift`
- Modify: `app/Sources/FeedbaxKit/Engine/Engine.swift` (handle `.stillCapture` toggle)
- Test: `app/Tests/FeedbaxKitTests/StillCaptureTests.swift`

**Interfaces:**
- Produces: `struct StillCapture { static func write(_ texture: MTLTexture, context: MetalContext, directory: URL?, date: Date) throws -> URL }` — PNG at canvas resolution, named `feedbaxStill-YYYY-MM-dd-HHmmss.png`, default directory `~/Pictures/Feedbax/` (created on demand). Design §10; deliberately a clean render-target dump, PNG-consistent — fixing the original's screencapture/-t png/.jpg mismatch (spec §04 §6).

- [ ] **Step 1: Write the failing test**

`app/Tests/FeedbaxKitTests/StillCaptureTests.swift`:

```swift
import XCTest
import ImageIO
@testable import FeedbaxKit

final class StillCaptureTests: XCTestCase {
  func testWritesDatedPNGMatchingAccumulator() throws {
    let ctx = try MetalContext()
    let engine = try Engine(context: ctx)
    engine.router.applyStartupDefaults(at: 0)
    engine.setResolution(SIMD2(64, 36))
    let cb = ctx.queue.makeCommandBuffer()!
    let tex = engine.step(at: 0, commandBuffer: cb)
    cb.commit(); cb.waitUntilCompleted(); ctx.pool.endFrame()

    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let date = Date(timeIntervalSince1970: 1_787_500_000)
    let url = try StillCapture.write(tex, context: ctx, directory: dir, date: date)
    XCTAssertTrue(url.lastPathComponent.hasPrefix("feedbaxStill-"))
    XCTAssertEqual(url.pathExtension, "png")
    let src = try XCTUnwrap(CGImageSourceCreateWithURL(url as CFURL, nil))
    XCTAssertEqual(CGImageSourceGetType(src) as String?, "public.png")
    let img = try XCTUnwrap(CGImageSourceCreateImageAtIndex(src, 0, nil))
    XCTAssertEqual(img.width, 64); XCTAssertEqual(img.height, 36)
  }
}
```

- [ ] **Step 2: Run to verify FAIL**, filter `StillCaptureTests`.

- [ ] **Step 3: Implement** — `readPixels` → `CGImage` (rgba8) → `CGImageDestination` PNG. Engine's `toggleHandler` calls it on `.stillCapture` with the *previous completed* accumulator (never mid-encode).

- [ ] **Step 4: Run to verify PASS.**

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "feat(engine): still capture to ~/Pictures/Feedbax as dated PNG"
```

---

### Task 22: Golden-frame harness and parity scenarios

**Files:**
- Create: `app/Sources/FeedbaxKit/Engine/GoldenRunner.swift`
- Create: `app/Tests/FeedbaxKitTests/GoldenFrameTests.swift`
- Create: `app/Tests/FeedbaxKitTests/GoldenReferences/` (references, generated then committed)

**Interfaces:**
- Consumes: `Engine`, `Preset` (Task 12).
- Produces:
  ```swift
  struct Scenario {                        // design §9: preset + control timeline + fixed clock
    var name: String; var preset: Preset
    var timeline: [(frame: Int, write: ControlWrite)]
    var frames: Int; var size: SIMD2<Int>  // small canvases (192×108) keep references tiny
    var configure: ((Engine) -> Void)?     // attach filters, set layer mode, inject audio
  }
  struct GoldenVerdict { var passed: Bool; var failingPixelFraction: Double; var maxChannelDelta: Int }
  struct GoldenRunner {
    static func render(_ scenario: Scenario, context: MetalContext) throws -> [SIMD4<Float>]
    static func compare(_ result: [SIMD4<Float>], referencePNG: URL) throws -> GoldenVerdict
    // Tolerance: max channel delta ≤ 2/255 on ≥ 99.9 % of pixels (design §9).
    static func writeReference(_ result: [SIMD4<Float>], size: SIMD2<Int>, to url: URL) throws
  }
  ```

**The P1 scenario set** (each a `func` in `GoldenFrameTests`, one reference PNG each):
1. `identity-accumulation` — startup defaults, no input; proves cold start (erase 1.0 hard clear + HSL defaults).
2. `rota-spiral` — sticker layer enabled with a bundled 32×32 test glyph, zoom 0.9 / theta 0.2 / erase 0.55 raw; 120 frames; the signature fold spiral.
3. `sinvert-kaleidoscope` — same, SInvert flipped at frame 60 (checklist #7).
4. `hsl-drift` — hue slot 1.0 for 180 frames; proves wrap cycling (checklist #5).
5. `brcosa-on-movie` — movie layer + `BrcosaFilter(enabled: true)` hot defaults; pins the filter live before the camera exists (design §10 note).
6. `keyers-on-movie` — movie layer + luma cascade; ditto for checklist #12's implementations.
7. `waveforms-synthetic` — waveforms enabled, `AudioBands` fed a fixed 46.7+144.3 Hz mixture via `configure`, bumps on (checklists #10, #11).
Scenarios 5–7 use a tiny deterministic movie fixture generated once by the Task 16 helper and committed (`Tests/.../Fixtures/sweep.mov`, ~40 KB).

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/GoldenFrameTests.swift` (scenario definitions live here too — each is a `static func` returning a `Scenario` per the list above):

```swift
final class GoldenFrameTests: XCTestCase {
  static let scenarios: [Scenario] = [
    Scenarios.identityAccumulation, Scenarios.rotaSpiral, Scenarios.sinvertKaleidoscope,
    Scenarios.hslDrift, Scenarios.brcosaOnMovie, Scenarios.keyersOnMovie, Scenarios.waveformsSynthetic,
  ]
  func testAllScenariosMatchReferences() throws {
    let ctx = try MetalContext()
    let regen = ProcessInfo.processInfo.environment["FEEDBAX_REGEN_GOLDEN"] == "1"
    var failures: [String] = []
    for scenario in Self.scenarios {
      let result = try GoldenRunner.render(scenario, context: ctx)
      let ref = try XCTUnwrap(Bundle.module.url(forResource: "GoldenReferences/\(scenario.name)",
                                                withExtension: "png",
                                                fallbackToSourceTree: true))   // helper: writes go to the source tree
      if regen {
        try GoldenRunner.writeReference(result, size: scenario.size, to: ref)
      } else {
        let verdict = try GoldenRunner.compare(result, referencePNG: ref)
        if !verdict.passed {
          failures.append("\(scenario.name): \(verdict.failingPixelFraction * 100)% pixels over tolerance")
        }
      }
    }
    if regen { XCTFail("references regenerated — eyeball the PNGs, then rerun without the flag") }
    XCTAssertEqual(failures, [], "the look drifted")
  }
}
```

(`fallbackToSourceTree` is a tiny test helper that resolves the reference path inside the repo checkout when regenerating, since `Bundle.module` resources are read-only — locate the source tree via `#filePath`.) First run fails with missing references.

- [ ] **Step 2: Run to verify FAIL** (missing references), filter `GoldenFrameTests`.

- [ ] **Step 3: Implement runner + generate references**

Run: `FEEDBAX_REGEN_GOLDEN=1 swift test --package-path app --filter GoldenFrameTests`
Then: **eyeball every generated PNG** (open them — this is the one manual gate: do the spiral, the fold symmetry, the rainbow drift, the dotted cyan wave look like Feedbax? Compare against `docs/` screenshots and archived stills). Only then commit them.

- [ ] **Step 4: Run to verify PASS**

Run: `swift test --package-path app --filter GoldenFrameTests`
Expected: PASS — and stays green on every later commit on this machine. References are valid per pinned OS/hardware baseline (design §9); regeneration on OS/GPU change is `FEEDBAX_REGEN_GOLDEN=1` + re-eyeball + commit.

- [ ] **Step 5: Commit**

```bash
git add app
git commit -m "test(golden): scenario runner with seven parity scenarios and references"
```

---

### Task 23: Feedbax.app bundle via XcodeGen

**Files:**
- Create: `app/project.yml`
- Create: `app/App/FeedbaxApp.swift` (SwiftUI `@main`, same views as feedbax-dev)
- Create: `app/App/Info.plist` (NSMicrophoneUsageDescription: "Feedbax listens to the room to draw waveforms and bass bumps."), `app/App/Feedbax.entitlements` (mic)

**Interfaces:** consumes `FeedbaxKit` unchanged — the app target is a shell (design §8: engine code identical between dev run and app).

- [ ] **Step 1: Write project.yml**

```yaml
name: Feedbax
options: { bundleIdPrefix: net.mindlace, deploymentTarget: { macOS: "14.0" } }
packages: { FeedbaxKit: { path: . } }
targets:
  Feedbax:
    type: application
    platform: macOS
    sources: [App]
    dependencies: [{ package: FeedbaxKit, product: FeedbaxKit }]
    info: { path: App/Info.plist, properties: { NSMicrophoneUsageDescription: "Feedbax listens to the room to draw waveforms and bass bumps." } }
    entitlements: { path: App/Feedbax.entitlements, properties: { com.apple.security.device.audio-input: true } }
```

- [ ] **Step 2: Generate and build**

Run: `cd app && xcodegen generate && xcodebuild -project Feedbax.xcodeproj -scheme Feedbax -configuration Release build` (install XcodeGen via `brew install xcodegen` if absent).
Expected: BUILD SUCCEEDED.

- [ ] **Step 3: Verify by launching** the built `Feedbax.app` from DerivedData: window opens, mic permission prompt appears once, instrument runs. Signing/notarization for distribution is a release chore, not part of this plan.

- [ ] **Step 4: Commit** (the generated `.xcodeproj` stays untracked — add to `.gitignore`)

```bash
git add app/project.yml app/App .gitignore
git commit -m "build(app): Feedbax.app shell via XcodeGen with mic entitlement"
```

---

### Task 24: 8K/60 soak gate

**Files:**
- Modify: `app/Sources/feedbax-dev/main.swift` (implement `--soak`)
- Create: `docs/superpowers/plans/p1-soak-gate.md` (how to run + recorded results)

- [ ] **Step 1: Implement `--soak WxH@fps --seconds N`** — headless engine at the given res/rate with parity defaults + sticker layer + waveforms, driven by the display link (or a tight loop with `waitUntilCompleted` when no display), collecting per-frame GPU+CPU ms; prints p50/p95/p99 and a PASS/FAIL line against the gate: **p99 < 16.7 ms over ≥ 10 min at 7680×4320@60 on a base M4 mini** (design §10 P1 Proves).

- [ ] **Step 2: Run the short smoke locally**

Run: `swift run --package-path app -c release feedbax-dev --soak 7680x4320@60 --seconds 60`
Expected: completes and prints percentiles. (60 s smoke on the dev machine; the full 10-minute run on the actual mini is the release gate.)

- [ ] **Step 3: Record results** in `p1-soak-gate.md` (machine, OS, numbers) and note the RGBA16F-accumulator variant result too (quality toggle headroom, design §4).

- [ ] **Step 4: Commit**

```bash
git add app docs/superpowers/plans/p1-soak-gate.md
git commit -m "perf(engine): 8K soak mode with p99 frame-time gate"
```

---

### Task 25: Wave-2 default input — empirical verification (checklist #15)

The spec flags wave 2's input as most likely near-silent by default (a dead gswitch signal-patched into its input multiplier) and calls it "the single highest-impact unresolved item in this file for a port" (spec §03 §3, §12 q8). The port defaulted `wave2InputGain = 0.0` (Task 17). Verify against the running patch and finish the decision.

- [ ] **Step 1: Verify in Max** — using the memory-noted workflow (Max 9.1.5 runtime at `/Applications/Max.app`, `tools/maxedit.py`, floating-window screencapture testing): open `patches/Feedbax.maxpat`, enable audio, feed mic/test-tone signal, enable wave 2 (`soundwave_enable1` toggle), observe whether waveform 2 draws a live signal or stays flat.
- [ ] **Step 2: Act on the result** —
  - Flat (expected): keep `wave2InputGain = 0.0`; update design checklist #15 to "verified"; note that reviving wave 2 is an operator tunable, not parity.
  - Live: measure the effective polarity/gain (the literal reading would be −0.5), set `wave2InputGain` accordingly, regenerate the `waveforms-synthetic` golden, re-eyeball, commit.
  - Also settle the `downsample=512` question (spec §12 q2) from the same session: count the visible points in wave 2 and set `WaveBuffer`'s wave-2 decimation to match.
- [ ] **Step 3: Update docs + commit**

```bash
git add app docs/superpowers/specs/2026-08-23-feedbax-reimplementation-design.md
git commit -m "fix(audio): pin wave-2 default input from live-patch verification"
```

---

## Execution notes

- **Task order is the dependency order**; 2–5 are parallelizable among themselves, as are 13–14 and 15–16.
- **Parity-review items deliberately deferred to the human-eyeball pass** (design §9): jit.gl.graph radial parametrization (Task 18), layer-quad aspect convention (Task 9), filtergraph~ filter type (Task 17), `maxScale` signed-pow extension (Task 2), keyer backdrop color (Task 10). Each is commented at its implementation site with `// PARITY-REVIEW:`.
- **P2 pointers** (not in this plan): party server + stickerifier + web app (design §7); the API contract is the first P2 planning task.
