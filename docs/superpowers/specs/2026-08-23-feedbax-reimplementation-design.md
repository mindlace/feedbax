# Feedbax reimplementation — substrate proposal and design

**Status:** proposal for review · **Date:** 2026-08-23
**Source of truth for behavior:** [`docs/spec/`](../../spec/README.md) (the extracted description of what
Sean's patch does). This document decides *where* and *how* to rebuild it, not *what* it does —
where the two disagree, `docs/spec/` wins.

---

## 1. Goals

Ranked. The first two are the drivers named for this proposal; the rest come from the project's
history and the party scenario.

1. **Accessibility.** A non-technical person double-clicks an app and Feedbax runs. No Max
   license, no patch files, no engine preferences, no "why is the window black" (the failure mode
   that motivated the diagnosis doc).
2. **Extensibility.** Adding a new way to get imagery/video into the instrument, a new
   transformation of it on the way in, or a new way to control it means implementing one small
   interface, not rewiring a patch.
3. **The party scenario.** A mac mini + projector + microphone is a complete rig. Guests hit
   `feedbax.local` on their phones, upload images that get stickerified, and a curated jukebox
   queue feeds them into the visuals. People near the rig affect the rendering in ways they can
   understand. Cameras and depth/hand sensors are additive, not required.
4. **Fidelity.** Sean was proud of 8K. Mac-mini-class Apple silicon is the minimum bar; the port
   should exploit unified memory and Metal, and reproduce the documented look *exactly* — the
   fold math, the non-standard blend, the HSL drift (§6 checklist).
5. **Multi-display.** Something Sean never got out of Max. The architecture should treat outputs
   as N viewports over one canvas from day one, even if the first pass ships with one.

### Non-goals (first pass)

* Cross-platform. We buy the Mac APIs deliberately (see §3 trade-offs).
* A third-party plugin SDK. Extensibility means clean *internal* protocols; scripting/embedding
  can come later without redesign.
* NDI, PTZ camera control, Mira/iPad parity. The control-surface *shape* survives (§5); the
  specific hardware bindings don't.
* Preset/scene recall beyond load-time defaults — the original never had it (spec §04). A minimal
  "save current settings" is cheap and worth doing, but performance-grade preset morphing is not
  first-pass.

---

## 2. What we're porting, in one breath

A 60 Hz feedback loop: partially erase the accumulator, warp the previous frame
(rotate/zoom/pan with mirror-fold edges, additive HSL shift), draw fresh seed material *under* it
(stickers, movie frames, keyed camera, two audio waveforms), blend the warped past over the
present with `(SRC_ALPHA, DST_ALPHA)`, capture, repeat. Seven live control slots plus erase
amount and a kaleidoscope sign-flip, everything ramped over ~100 ms. That's the whole instrument;
the character lives in about five exact constants and two shaders (spec README, "What makes the
look").

This is *small*. The Max patch is large because Max makes plumbing visible and Sean kept eight
years of scaffolding. The extraction pass confirms the portable core is ~3 fragment shaders, one
compositor, one audio analysis chain, and a control-vector router.

---

## 3. Substrate decision

### Options considered

**A. Native Swift + Metal app, with the guest-facing web app in SvelteKit (recommended).**
SwiftUI shell; Metal render core; AVFoundation for cameras (USB, and any iPhone via Continuity
Camera — zero drivers); AVAudioEngine + vDSP for mic analysis; Vision's subject-lifting
(`VNGenerateForegroundInstanceMaskRequest`, macOS 14+) for stickerification; an embedded HTTP/
WebSocket server (Hummingbird or FlyingFox) serving a static SvelteKit build; Bonjour for
`feedbax.local`; GRDB/SQLite for the queue; Developer ID + notarization for "download and
double-click".

* *For:* Every hard requirement lands on a first-class API. Camera frames reach the GPU zero-copy
  (`CVMetalTextureCache` — the unified-memory win, material at 4K camera input). Multi-display is
  native (`NSScreen` + one `CAMetalLayer` per output). Stickerification is a free, excellent
  on-device model. Permissions (mic/camera) behave like an app, because it is one.
* *Against:* Mac-only, and Swift isn't Ethan's daily language. Mitigation: everything guest- and
  curator-facing is SvelteKit (the daily stack); the Swift core is small and changes rarely once
  parity is reached — the extension points (§5) are deliberately the boring part.

**B. Rust + wgpu.** Portable, Metal underneath, excellent GPU abstraction.
* *Against:* the non-GPU half fights the platform — camera capture on macOS via third-party
  AVFoundation bindings, no Vision (stickerify needs a bundled ONNX model), windowing/fullscreen/
  multi-display rougher, signing/packaging DIY. We'd spend the portability dividend before ever
  leaving the Mac, and the "use the Mac APIs" driver says we don't want to leave.

**C. Web-first (Tauri/Electron + WebGPU).** Entirely in the daily stack.
* *Against:* 8K60 ping-pong is at the edge of what a webview will sustain on a mini; fullscreen
  across multiple displays from a browser context is genuinely bad; camera/format control and
  future depth sensors are constrained by browser APIs. The web layer is the right tool for the
  *phone-facing* surface — which every option includes — but the wrong place for the render loop.

**Rejected without deep analysis:** TouchDesigner (recreates the Max problem: license, runtime,
not an app), openFrameworks/Cinder (C++ maintenance for fewer platform wins than Swift),
Unity/Godot (an engine's worth of ceremony for three shaders, plus export/licensing friction).

### Recommendation

**Option A: native where the GPU and the devices are, web where the people are.** One process,
one .app: the Metal engine and the embedded server live together, so the queue, the renderer, and
the operator UI share state without IPC.

The Swift core is also a stated learning vehicle — the maintainer intends to pick up Swift
through this codebase — so the engine is written to teach: small modules, doc comments that
explain *why*, no cleverness. That is the same property that keeps the extension points
approachable.

---

## 4. Architecture

```mermaid
flowchart LR
  subgraph app["Feedbax.app (one process)"]
    subgraph engine["Engine (Swift + Metal)"]
      clock["FrameClock\n30–120 Hz"] --> core
      core["FeedbackCore\naccumulator ping-pong\nrota-fold → HSL\nerase · (srcα,dstα) blend"]
      comp["Compositor\nseed layers · waveforms\ndraw order"] --> core
      core --> out["OutputStage\nN viewports / displays\nmirror · span · crop"]
    end
    subgraph sources["Seed layers"]
      stick["StickerSource\n(folder + jukebox queue)"] --> filt
      movie["MovieSource"] --> filt
      cam["CameraSource\n(USB / Continuity)"] --> filt
      filt["Per-layer filter chains\nauto-matte · luma/chroma key\nbrcosa · sticker border"] --> comp
    end
    subgraph control["Control & modulation"]
      cv["ControlVector router\n9 slots · arbitration\n~100 ms smoothing"] --> core
      audio["AudioAnalysis\n3 EQ bands → bumps\nwaveform buffers"] --> comp
      audio --> cv
      opui["Operator UI (SwiftUI)\nsliders · preview · queue"] --> cv
      local["Local input\nkeyboard · trackpad · gamepad"] --> cv
    end
    subgraph party["Party server (embedded)"]
      http["HTTP/WS + Bonjour\nfeedbax.local"] --> stickify["Stickerifier\n(auto-matte + border\nfilter chain)"]
      stickify --> queue["Jukebox queue\nSQLite · moderation"]
      queue --> stick
    end
  end
  phones["Guests' phones\nSvelteKit web app"] --> http
  curator["Host/designee phones\ncuration view"] --> http
  micln["Microphone"] --> audio
  cams["Cameras"] --> cam
  out --> proj["Projector(s) / displays"]
```

### The frame loop (unchanged from spec, restated for the port)

Per tick, in this exact order (spec README; ordering is load-bearing):

1. Partially erase the accumulator toward black: `α = 0.8 + 0.2·t³`, `t` = erase control ∈ [0,1].
   A blend toward the erase color, never a clear; **α is the one unsmoothed parameter**.
2. Warp the previous frame's texture: rota (inverse warp, pixel coordinates, anchor 0.5/0.5,
   mirror-fold bounds) → additive HSL. (v122 appended a brcosa output grade here; v1 omits it —
   see §6 decision 13.)
3. Draw seed layers and waveforms *first*.
4. Draw the warped previous frame *over* them as a full-screen quad with blend
   `(SRC_ALPHA, DST_ALPHA)` — not alpha-over.
5. Present; the accumulator becomes next frame's "previous" by ping-pong swap.

Where Max needed a fragile screen-capture step (the very thing that broke the repo on Max 9), a
Metal port renders to texture natively — step 5 is a pointer swap, not a copy. Same math, zero
legacy risk.

**Resolution/rate:** presets 720p → 8K (7680×4320) and 30–120 Hz, plus custom. Live re-size of
the accumulator, as the original did. RGBA8 accumulator by default (parity — the original was
8-bit); RGBA16F as a quality toggle where bandwidth allows.

**8K feasibility, honestly:** an 8K RGBA8 surface is ~127 MB. With the warp+HSL fused into one
pass and composite-in-place (no copy, ping-pong swap), a frame touches roughly 3 full surfaces
≈ 380 MB → ~23 GB/s at 60 Hz — comfortable even on a base M-series mini (M4 ≥ 120 GB/s).
RGBA16F at 8K60 (~46 GB/s) also fits. Sean hit 8K in Max over OpenGL 2; Metal on Apple silicon
clears that bar with headroom for the camera and multi-display work Max couldn't do.

**Multi-display:** the engine renders one canvas; each attached display gets a window +
`CAMetalLayer` viewport with modes *mirror*, *span* (canvas partitioned across displays), or
*crop* (each display frames a region). Per-display vsync via `CAMetalDisplayLink`. First pass
ships mirror + span; the viewport abstraction is what matters now.

---

## 5. The extension interfaces (driver #2)

Four small protocols, extracted from how the original actually routes data. Everything the party
scenario adds later — depth sensors, more cameras, generative layers, new looks on the way in —
is an implementation of one of these, not a change to the engine.

### `SeedSource` — "a thing that produces imagery"

```swift
protocol SeedSource: AnyObject {
  var id: SourceID { get }
  /// Called on the frame clock. Return the current texture, or nil to skip this frame.
  func tick(_ frame: FrameContext) -> MTLTexture?
  var transform: LayerTransform { get set }   // position, scale, rotationZ (imageMove shape)
  var layer: LayerSettings { get set }        // z-order, blend mode, enabled
  var capabilities: SourceCapabilities { get } // .keying, .deviceSelection, .list, .ptz…
}
```

Rules the extraction surfaced, honored at the protocol level:

* Sources decode on *selection*, never per render frame; movies advance on their own clock
  (AVPlayer), and `tick` merely fetches the current frame.
* Sources produce **raw** imagery. Everything done to it on the way in — keying, color, matting —
  lives in the layer's *filter chain* (next section), not inside the source. Writing a new look
  never means writing a new camera.
* List-backed sources (sticker folder, jukebox queue) publish their item count so index-based and
  normalized-[0,1] selectors rebind live on rescan.
* The original's camera-vs-picture either/or becomes the parity configuration of *one* layer —
  a single explicit mode switch, fixing the documented three-toggles-that-must-agree and
  last-writer-wins enable races. The compositor itself is N-layer (z-order and blend per layer),
  so the party and room phases run several seed layers at once; the original simply never had
  more than one. This — plus the filter chains — is the "mixer" the original lacked.

Built-in implementations, in build order: `StickerSource` (folder scan → later fed by the queue),
`MovieSource`, `CameraSource` (USB + Continuity), and later `NDISource`, `DepthSource`.
Waveforms are not textures — they stay a built-in compositor layer (polyline geometry), matching
the original's radial/linear line drawing with per-attribute bindings.

### `TextureFilter` — "a thing that transforms imagery on its way in"

```swift
protocol TextureFilter: AnyObject {
  var id: FilterID { get }
  var enabled: Bool { get set }
  /// Texture in, texture out, on the frame clock.
  func apply(_ input: MTLTexture, _ frame: FrameContext) -> MTLTexture
}
```

Every seed layer owns an ordered filter chain between its source and the compositor — the
channel strip the original never had (its keying was hardwired into the camera path). Any filter
attaches to any source. Built-ins:

* **`AutoMatteFilter`** — the headline addition relative to the original: automatic background
  removal on *any* source. Live video and movies use Vision person segmentation per frame — it
  runs on the Neural Engine, so it doesn't compete with the 8K loop for GPU bandwidth, and its
  masks arrive low-res and upsampled, which suits this instrument fine. Stills use subject
  lifting (any subject, higher quality), run once at decode and cached. Arbitrary-subject matting
  on *live* video is heavier; it ships as a reduced-cadence mode (refresh the mask every N
  frames) to experiment with.
* **`LumaKeyFilter` / `ChromaKeyFilter`** — the parity keyers (two-pass midtone cascade;
  HSV-weighted chroma), their strict either/or preserved as a UI rule on the camera chain, not
  as a chain limitation.
* **`BrcosaFilter`** — the unclamped camera color stage (gated off by default, hot dial
  defaults 1.55/1.55/1.5, per spec §02 §7.2). The same filter *could* later be appended to the
  output chain to recover Sean's v122 output grade, but v1 ships without that (decision 13).
* **`MatteOverlayFilter`** — the vignette matte, reading alpha (the fixed version, §6).
* **`StickerBorderFilter`** — dilated white outline. `AutoMatte → StickerBorder` *is*
  "stickerify": the party upload path (§7) runs exactly this chain at ingest, so upload-time and
  live-time background removal are one implementation.

Parity defaults per layer: camera = brcosa → keyer; sticker and movie = empty chain (file alpha
passes straight through, as the original).

### `ControlSurface` — "a thing a performer steers with"

Produces (partial) writes into the 9-slot control vector (hue, lightness bias, [dead], panX,
panY, zoom, theta, [dead], saturation) with the documented per-slot range mappings. The router
owns: recompute-every-frame + diff-before-broadcast, the hard-cut arbitration between surfaces
with a presence watchdog (Leap-style: tracked source primary, manual fallback after 2 s), global
smoothing (100 ms ramp / 4 ms grain, both global knobs), and SInvert.

The performer's baseline is local hardware, present from P1 — the original gave the performer
~7 continuous axes plus booleans, and that must not wait for exotic surfaces:

* **Operator-UI sliders** — every axis and toggle, always available.
* **Keyboard + trackpad** — the trackpad is the pan surface (the original's shader-pan touch
  role), pinch/scroll drives zoom, modifier-held drags take hue/theta, and keys carry the
  booleans (SInvert, live/picture mode, bump enables, fullscreen).
* **Game controller** (GameController framework — stock PS/Xbox pads pair natively): two sticks
  and two triggers are six analog axes — sticks → pan + hue/lightness, triggers → zoom/theta,
  d-pad steps erase and saturation, buttons carry the booleans. A ~$40 gamepad covers nearly the
  whole control vector with zero custom hardware.

Later surfaces: touch (the two-role split the original used), hand tracking (the spec §04 Leap
mapping ports directly), MIDI/OSC. Mappings live in a bindings table, not code — remapping an
axis is data.

### `Modulator` — "a signal that animates a parameter"

A named scalar updated per frame, bindable to any modulatable parameter (quad-Z bump, waveform
alpha, erase…). Built-ins: the three bass-band envelope followers (46.7 / 60 / 144.3 Hz biquads →
rectify → asymmetric smooth → per-frame sample; *levels, not onset detectors*; default off, as
the original). Later: camera presence/motion, depth proximity. The original had no LFOs and no
idle drift — we keep that discipline; a party rig that "does something on its own" is a
different instrument.

---

## 6. Fidelity checklist

The port is judged against `docs/spec/`. The items a naive port gets wrong, promoted here so they
end up in tests (§9):

| # | Invariant | Source |
|---|---|---|
| 1 | Fold bounds = period-2·size *reflection* (`mix(wrap, size−wrap, …)`), not wrap/clamp | spec §01 |
| 2 | Rota is an inverse warp in pixel coordinates; verify rotation handedness empirically | §01 |
| 3 | Feedback quad blend = `(SRC_ALPHA, DST_ALPHA)`; render clear stays standard | §01 |
| 4 | Erase `α = 0.8 + 0.2·t³`, clamped [0.8, 1.0], **never smoothed** | §01 |
| 5 | HSL shift is additive in HSL space; hue wraps, sat/light clip | §01 |
| 6 | All 7 live slots ramp ~100 ms (global), per-slot range maps per spec table | §01/§04 |
| 7 | SInvert negates zoom + offsets → point-mirror kaleidoscope; first-class toggle | §01 |
| 8 | Draw order: seeds/waveforms under, warped past blended over | §01 |
| 9 | Cold-start defaults: hue 0.02, lightness 0.5, sat 0.5 (nonzero, visually significant) | §01 |
| 10 | Bumps are smoothed levels, default off; wave-2 alpha = base + envelope, unclamped | §03 |
| 11 | Waveform 1: radial, bottom, thick burnt-orange; waveform 2: dotted cyan, `(srcα,dstα)` | §03 |
| 12 | Parity default keeps keyers on the camera chain only; luma = two-pass midtone cascade; chroma HSV weights (4,1,2) | §02 |
| 13 | Output brcosa: omitted in v1 (v123 parity — the stage is dead-wired in v123). `BrcosaFilter` ships anyway for the camera chain, so re-adding the v122 output grade later is appending that filter to the output chain. Low-risk: the v122 dials init to 1.0/1.0/1.0, an exact identity, so v122 topology at defaults renders pixel-identical to v123 | §01/§05 |
| 14 | No LFOs, no idle animation, no auto-drift | §04 |

Known original bugs we fix rather than port: the layer-enable last-writer race (becomes an OR),
the RGB-luminance vignette that made the circular matte a no-op (read alpha), the duplicated
uncoordinated chroma-key control sources (one source of truth), waveform-2's audio alpha
clobbering the user's RGB (compose alpha only). Each is flagged in the extraction and spec audits
as accidental.

---

## 7. The party subsystem

### Guest flow

```mermaid
sequenceDiagram
  participant G as Guest's phone
  participant S as Feedbax.app (server)
  participant C as Curator (host/designee)
  participant R as Renderer
  G->>S: scan QR / open feedbax.local
  G->>S: upload photo or PNG
  S->>S: stickerify (Vision subject lift + white border)<br/>skip if already transparent PNG
  S-->>G: preview "your sticker"
  S->>C: appears in moderation view
  C->>S: approve / reject / pin
  S->>R: approved → jukebox queue → StickerSource
  R-->>G: your sticker enters the feedback field
```

* **Reachability.** The app binds :80 (unprivileged on macOS) and advertises via Bonjour. Honest
  nuance: `feedbax.local` resolves when the mini's Local Hostname is set to `feedbax` — a
  one-time setting the app's setup screen offers to apply. iPhones resolve `.local` natively;
  Android browsers often don't, so **the projected QR code always carries the numeric-IP URL**
  and `feedbax.local` is the memorable alias, not the mechanism. Networkless parties: the mini
  hosts its own Wi-Fi via Internet Sharing, or a pocket travel router; both documented in setup.
* **Stickerification.** The upload path runs the same `AutoMatte → StickerBorder` filter chain
  the renderer uses (§5): Vision subject lifting produces the cutout, a dilated white border
  gives the sticker look. Uploads that are already transparent PNGs pass through untouched.
  On-device, no cloud, fast on Apple silicon.
* **Curation.** Guests are anonymous per-device IDs with a per-guest rate limit. The host and
  PIN-invited designees get the moderation view (approve/reject/pin/eject, auto-approve toggle —
  default *hold until approved*). The operator UI mirrors the same queue.
* **Jukebox.** Approved stickers rotate through `StickerSource` on a fair queue (round-robin per
  guest, pins jump the line), each entering with the imageMove-style placement transform so the
  performer — or a presence modulator — can steer where new material lands.
* **State.** SQLite via GRDB; media under Application Support per party session. A party is a
  named session you can reopen ("last Saturday's stickers").

### Guests affecting the rendering, comprehensibly

Phase R1 needs no new hardware: the keyed camera already puts *your silhouette* into the feedback
field (spec §02 — the most comprehensible mapping there is), and a motion-centroid modulator can
stir pan/hue so movement visibly perturbs the attractor. Depth sensors and hand tracking slot in
later as `Modulator`/`ControlSurface` implementations — the spec's Leap mapping is the template —
with hardware options (OAK-D-class depth, Ultraleap) evaluated when we get there, behind
interfaces that don't care.

---

## 8. Repo and code layout

```
feedbax/
  app/            Xcode project — Feedbax.app
    Engine/       FeedbackCore, shaders (.metal), Compositor, OutputStage
    Sources/      SeedSource protocol + StickerSource, MovieSource, CameraSource
    Control/      ControlVector router, surfaces, modulators, AudioAnalysis
    Party/        embedded server, stickerifier, queue, sessions
    UI/           SwiftUI operator interface
  web/            SvelteKit (static adapter) — guest upload + curation views
  docs/spec/      unchanged — the behavioral source of truth
  patches/        unchanged — the Max original, kept as reference artifact
```

The web build is embedded in the app bundle as static assets; `web/` develops standalone against
a mock API, in the daily SvelteKit toolchain.

---

## 9. Testing

* **Shader math as pure functions.** Fold, rota, HSL-add, brcosa, both keyers implemented once in
  Metal and mirrored in a tiny CPU reference; unit tests pin them to hand-computed values,
  including fold reflection at the ±edges and hue wrap. This is where checklist §6 lives.
* **Golden-frame tests.** Deterministic scenario scripts (fixed seed images, scripted control
  vectors, fixed clock) → hash/compare rendered frames across commits. Catches "the look drifted"
  without eyeballs.
* **Parity review.** Side-by-side v123 patch vs. port on the same inputs — human-judged, since
  Max-vs-Metal bit-equality isn't achievable or needed. Sean's archived stills are references.
* **Party subsystem.** Vitest for the SvelteKit app; Swift tests for queue/moderation state
  machine; one scripted end-to-end (upload → stickerify → approve → appears in a frame hash).

---

## 10. Phasing

| Phase | Deliverable | Proves |
|---|---|---|
| **P1 — Parity instrument** | Feedbax.app: engine + per-layer filter chains (brcosa, keyers) + sticker folder + movie playback + mic waveforms/bumps + operator UI + keyboard/trackpad and gamepad surfaces + fullscreen + res/rate presets + still capture | The look survives the port (checklist §6, golden frames); performable with stock hardware |
| **P2 — Party** | Embedded server, upload → stickerify → moderation → jukebox, QR overlay, sessions; `AutoMatteFilter` lands here (stills + movies) | The mini-at-a-party story end to end |
| **P3 — Room** | CameraSource + live auto-matte + keying UI, presence/motion modulators, multi-display span | Guests affect rendering; Sean's unfinished multi-monitor wish |
| **P4 — Reach** | Depth/hand tracking surfaces, MIDI/OSC, NDI/Syphon interop | The extension interfaces earn their keep |

P1 is deliberately the whole *instrument*, not a tech demo — it replaces the Max patch for the
solo performer before anything party-shaped exists.

---

## 11. Open questions

1. **Mac-only lock-in** — the recommendation buys fidelity and app-ness with portability. Any
   future scenario (a Linux gallery box?) that should veto Option A?
2. **Name** — does the reimplementation stay "Feedbax"?
3. **Minimal presets** — the original had none; a "save current settings" is nearly free in P1.
   Include?

### Resolved

* **Swift core** (2026-08-23): approved — and doubles as a Swift learning vehicle for the
  maintainer, which §3 folds into how the engine code is written.
* **Filter/mixer layer** (2026-08-23): the reviewer's instinct that a filter/mixer was missing
  was right — added as the per-layer `TextureFilter` chains plus the N-layer compositor (§5),
  with auto-stickerification (`AutoMatteFilter`) as the flagship filter.
* **Baseline local input** (2026-08-23): keyboard/trackpad and game-controller surfaces are P1
  deliverables covering the ~7 axes + booleans; exotic surfaces are additive.
* **Output brcosa** (2026-08-24): omitted in v1 rather than shipped as a toggle. Verified in the
  patch JSON that the v122 output-side dials initialize to 1.0/1.0/1.0 — an exact identity
  through the brcosa math — so the v122/v123 looks only diverge once a performer moves a dial.
  `BrcosaFilter` exists regardless (camera chain), so the v122 output grade is recoverable later
  by appending it to the output chain. Decision 13 updated to match.
