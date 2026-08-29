# Feedbax — technical description for re-implementation

This folder describes, in enough detail to rebuild it outside Max, what Sean Stevens' **Feedbax**
actually does: the per-frame algorithm, every shader and its exact math, every user-facing
parameter with its range/default/mapping, the audio analysis, the control surfaces, and how all of
it evolved between 2017 and 2025. It was extracted from the patch files themselves (the current
repo, i.e. Sean's `v123DeployabilityCleanup`, plus ~28 archived versions), not from memory of
performances, so it says what the patch *does*, which is sometimes not what the README or the
on-screen labels suggest.

| file | what it covers |
|---|---|
| [01-render-loop-and-shader-chain.md](01-render-loop-and-shader-chain.md) | the frame clock, the feedback texture round-trip, erase/blend settings, the main videoplane, the `td.rota` rotate/zoom/fold shader, the HSL shift, brcosa, exact parameter mappings, minimal port pseudocode |
| [02-image-and-video-input.md](02-image-and-video-input.md) | sticker/image/movie loading, folder scanning, the `imageMove` transform, camera (USB/NDI) path, luma/chroma keying shaders, the alpha-mask matrix |
| [03-audio-analysis-and-waveforms.md](03-audio-analysis-and-waveforms.md) | `adc~` → bass EQ bank → `jit.catch~` → `jit.gl.graph` waveforms; the three "bump" envelope followers (`worldBump`, `wavebump`, `kittybump`) |
| [04-control-surfaces-and-utilities.md](04-control-surfaces-and-utilities.md) | the 9/11-slot `shadeCtl` vector, Mira/iPad touch + tilt mapping, `xypinch`, Ultraleap mapping, Leap↔iPad arbitration, pathsetup/misc/StillSave |
| [05-version-lineage.md](05-version-lineage.md) | dated table of every archived version, the six eras of the shader chain, the exact diffs between Sean's last Max 8 builds and the Max 9 branch this repo is based on |
| [06-bus-reference.md](06-bus-reference.md) | every global `send`/`receive` bus, payload, meaning, sender → receiver, and which ones are dead |

The companion document [`../diagnosis-2026-08-23.md`](../diagnosis-2026-08-23.md) records why the
repo did not run for people, what was fixed, and what still needs doing.

## Conventions

* `[obj-36]` cites the object id inside the relevant `.maxpat` so a claim can be checked.
  `sfx:` / `pic:` etc. prefix ids from a sub-patch. `[?]` marks something the static patch cannot
  settle (usually a UI object's last-saved value, or a Max object's undocumented corner behaviour).
* The sections were written from **text listings** of the patches produced by
  `tools/maxpat2txt.py` (objects + every connection, in reading order), then independently
  audited against the same listings; each section ends with the audit notes. Run
  `python3 tools/maxpat2txt.py patches/feedbax.shaderfx.maxpat` to regenerate a listing, and
  `python3 tools/maxdiff.py A.maxpat B.maxpat` to diff two versions structurally.
* Jitter blend modes use the enum `0 zero, 1 one, 2 dst colour, 3 src colour, 4 1−dst colour,
  5 1−src colour, 6 src alpha, 7 1−src alpha, 8 dst alpha, 9 1−dst alpha`. So `6 7` is ordinary
  alpha-over and `6 8` (used on the main feedback plane) is `(SRC_ALPHA, DST_ALPHA)`.

## What Feedbax is, in one paragraph

A single full-window GL context runs at 60 Hz. Each frame, the *previous* frame (captured into a
texture) is pushed through a short GPU chain — rotate/zoom/pan about an anchor with mirrored-fold
edge handling, then an additive hue/saturation/lightness shift — and redrawn as a full-screen quad
with a non-standard `(src_alpha, dst_alpha)` blend on top of a partially-erased (80–100 %)
background. Fresh material — a PNG "sticker" or movie frame positioned by iPad touch, an optionally
keyed live camera, and one or two audio waveforms drawn as lines — is composited into the same
frame. The frame is captured again and the cycle repeats. Because the transform is applied to the
whole accumulated image every frame, tiny rotations, zooms and hue offsets compound into spirals,
fractal tunnels, kaleidoscopic folds and slow rainbow drift; the performer steers the attractor
with a handful of continuous controls (rotation angle, zoom, pan, hue drift, erase amount) and by
injecting new seed material. Audio drives only secondary modulation (a bass-envelope "bump" on the
plane's depth and on a waveform's alpha).

## The frame algorithm (authoritative summary)

```
every tick of metro (60 Hz default; presets 30/60/90/100/120):
  1. fb.erase                         # erase_color = (0,0,0,a), a = 0.8 + 0.2·3^(t−1), t = erasetransparency∈[0,1]
                                      #   (classic-mode scale, measured; §01 §2). Post-retrofit the target is the
                                      #   jit.gl.node `fb`, whose erase is a HARD clear — no (1−a) residual. A port
                                      #   that keeps a residual under the additive plane composite (step 5) has gain > 1.
  2. bang feedbackTexture             # fst (full res, fullscreen) or dst (320×180, windowed) → emits its texture ref
       → shaderfx:  tex = td_rota(tex; zoom, theta, offset, anchor=(.5,.5), boundmode=4 (mirror-fold))
                    tex = hsl_shift(tex; +hue_shift, +sat_delta, +light_delta)
                    [v122 Max-8 builds only: tex = brcosa(tex; brightness, contrast, saturation)]
       → mainPlane.texture = tex
  3. s imgbang  → picsVid: if camera on, grab a new frame. (Does NOT draw the sticker layer — see step 7.)
  4. s audiobang→ sound2: dump jit.catch~ buffers → draw waveform 1 (radial, bottom) and waveform 2
  5. s ctrlbang → webUI re-evaluates shadeCtl (60 Hz, pushed on change); Leap timer; bump gates
  6. bang mainPlane                   # draws the transformed previous frame: scale (+1.78·xyratio, 1, 1),
                                      #   position (0,0,−0.414+worldBump), blend (SRC_ALPHA, DST_ALPHA), colour (1,1,1,1)
  7. bang render                      # draws every @automatic object — i.e. the picsVid jit.gl.layer (sticker /
                                      #   camera), alpha-blended ON TOP of the plane — then swaps
  8. render.to_texture                # capture the framebuffer into the feedback texture for the next tick
```

Draw order is explicit for the manually banged objects, and the two kinds of injected material
land on *opposite* sides of the feedback plane:

- **Waveforms** (`jit.gl.graph`, `@automatic 0`, banged at step 4) are drawn *before* the plane, so
  the plane's `(SRC_ALPHA, DST_ALPHA)` composite **adds** the warped previous frame on top of them —
  they inject energy into the loop every frame.
- **The sticker/camera `jit.gl.layer`** carries no `@automatic` in Sean's file (default = automatic),
  so it is drawn by the render bang at step 7, *after* the plane, with `jit.gl.layer`'s default alpha
  blend — a convex stamp that can never exceed the sticker's own brightness. (`imgbang` only reaches
  the layer through a gate that is closed by default.)

Post-retrofit (`jit.gl.node fb`, everything `@automatic 1`) this order is carried by `@layer`:
sticker **20** > plane **10** > waveform graphs **3**. Putting the sticker *under* the plane
(`@layer 2`, the retrofit's first state) re-adds it every frame and saturates it to white within a
second — measured 2026-08-29, see `docs/diagnosis-2026-08-23.md` finding J. Details, defaults and
the exact object wiring: §01.

## The control vector

webUI (iPad via Mira, or the on-screen sliders) and LeapGemini each produce a 9-float list on
`shadeCtl` / `shadeCtlLeap`; shaderfx unpacks 11 slots and uses 7:

| slot | name | raw range | becomes | mapping (then ~100 ms linear smoothing) |
|---|---|---|---|---|
| 0 | hue | −1..1 | HSL `hue_shift` per frame | `scale(−1,1 → −0.05,0.05, exp 0.1)` |
| 1 | bias | −1..1 | HSL `lightness` delta | `scale(−1,1 → −0.04,0.02, exp 0.05)` |
| 2 | scalebright | −1..1 | *(unused in v123; was scalebias)* | — |
| 3 | xshift | −1..1 | `td.rota` `offset.x` (pixels) | `×SInvert` then `scale(−1,1 → −2000,2000)` |
| 4 | yshift | −1..1 | `td.rota` `offset.y` (pixels) | same |
| 5 | scale | −1..1 | `td.rota` `zoom` (both axes) | `scale(−1,1 → 0.4,1.2)` then `×SInvert` |
| 6 | theta | −1..1 | `td.rota` `theta` (radians) | `scale(−1,1 → +π,−π)` |
| 7 | NC | −1..1 | *(unused — "NYI")* | — |
| 8 | sat | 0..1 | HSL `saturation` delta | `scale(0,1 → −0.05,0.05, exp 0.1)` |
| 9,10 | ancx, ancy | — | *(never sent)* — anchor stays (0.5, 0.5) | — |

`SInvert` is ±1 from the webUI "scaleInv" toggle; negative zoom point-mirrors the sampled region,
which is the patch's own "kaleidoscope" switch. Leap is the primary source when hands are visible
and the patch falls back to the iPad 2 s after hands disappear (v123); Sean's Max 8 builds used a
manual "Use Leap Motion" toggle instead. Full mapping tables: §01 §4, §04 §1–3.

## What makes the look (priority order)

1. **Mirror-fold edge handling** in `td.rota` (`boundmode 4`): anything pushed off the edge by
   zoom/rotation/pan is folded back in as a reflection, period 2×size. Over many frames this is
   the source of the symmetric, kaleidoscopic structure. Quote the GLSL in §01 §4 verbatim.
2. **Rotate + zoom about the centre every frame**, with all controls ramped over ~100 ms so the
   attractor glides. Zoom range is only 0.4–1.2 and rotation ±π per frame, but it compounds.
3. **Additive per-frame hue rotation** (±0.05 of the hue circle per frame) that wraps, giving the
   slow rainbow cycling.
4. **Partial erase never below 80 %** — trails are short; persistence comes from the transformed
   re-draw, not from a low erase alpha. Clamp your erase alpha to [0.8, 1.0].
5. **`(SRC_ALPHA, DST_ALPHA)` blend on the feedback plane** (a `loadbang` overrides the
   `6 7` in the object's creation string), which brightens/accumulates rather than cross-fading.
6. **Seed material with alpha**: PNG stickers with transparent backgrounds (the last year of use),
   optionally a keyed camera, and the audio waveform lines (a thick line and a dotted one, the
   dotted one pulsing with bass).

Two surprises worth repeating for a port: the main plane's creation string says `@scale −1.78`
(mirrored) but a `loadmess 1.` chain re-sends `scale +1.78 1 1` at load, so **at load the plane
is not mirrored** (§01 §3); and brightness/contrast/saturation (`brcosa`) is **present but
disconnected** in v123 — it was in the chain in every Max 8 build Sean performed with (§05).

## Minimum viable port

* One RGBA framebuffer/texture pair at the output resolution (Sean's presets run from 1280×720
  to 3840×2160; 1920×1080 default), float or 8-bit.
* Per frame: fade the accumulator by `a` (above), draw seeds (textured quads with alpha, 1-D
  waveform polylines), draw `shader(previous)` with `(SRC_ALPHA, DST_ALPHA)`, copy to `previous`.
* Fragment shader = §01 §6 pseudocode (rect-pixel coordinates, fold, HSL add). Two passes or one
  combined pass are equivalent.
* Controls: the 7 live slots above + erase amount + SInvert, each smoothed ~100 ms; a sticker
  loader with position/scale/rotation; microphone in → 46/60/144 Hz resonant band envelopes.
* Ignore: Vizzie/NDI plumbing, PTZ control, StillSave, the dead receives listed in §06, and the
  disconnected `oldconrtrol`/`chro`/`obj-116` islands called out in §01 and §02.

## A note on how the feedback capture works in Max (and why the repo didn't run)

Sean's patch captures the frame with the **legacy** Jitter messages `usetexture <name>` +
`to_texture` on `jit.gl.render`. In Max 8.6+/9 with the default `gl3` ("glcore") engine these are
silent no-ops — the feedback texture is never filled, so the loop never closes (the window shows
only the fresh seeds). Sean's own Max 8 preferences were set to the legacy `gl2` engine. The
modern equivalent is `jit.gl.node @capture 1` (render the scene into a node's FBO and use the
texture it emits). See the diagnosis document for the evidence and the status of the fix; for a
non-Max port none of this matters — just copy the framebuffer.
