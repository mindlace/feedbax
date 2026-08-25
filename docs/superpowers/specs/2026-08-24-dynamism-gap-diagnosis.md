# Dynamism gap — root-cause map (2026-08-24, evening)

**Branch:** `worktree-reimplementation-proposal` at `3ae9ba2` (whiteout fixes in)
**Status:** fixes applied per `docs/superpowers/plans/2026-08-24-dynamism-gap-fixes.md`
(nearest resample, unclamped HSL, waveform geometry, wave-2 input, HUD mic status, fader
readouts). Still owed: the three Max-side measurements below, and a like-for-like visual
check of the dev build against the two screenshots at the measured vector.

## Reports

Comparing the running Max patch (Max 9.1.5, retrofit `Feedbax.maxpat`) with the dev build
(`swift run --package-path app feedbax-dev`) at nominally the same webUI settings:

1. Max is far more dynamic — a rotation change gives a radically different fine-grained
   kaleidoscopic texture filling the whole frame; the app looks comparatively static.
2. Max takes much longer to settle; the app converges almost instantly.
3. Colour varies much more in Max.
4. The ring isn't affected by audio in the app; the "bass background thing" (audio changing
   the whole image, not just the ring) isn't applied at all; no mic-in-use indicator.

## Method

Per `feedback-loop-map-not-stage-chasing`: write the whole-cycle map for both systems, put
numbers on every term, then fuzz the port at the *measured* control vector with one variable
changed at a time. Per `measure-running-max-not-the-spec`: nothing below that reaches a shader
is taken from `docs/spec` on trust; sources are the patch JSON (`tools/maxpat2txt.py`), Max's
own refpages and shader sources in `/Applications/Max.app`, the owner's two screenshots, and
the port's source. Items marked **[measure]** still need the running patch.

### The control vector actually in the screenshots

The five webUI faders are `slider` widgets with `size 2, min −1` (BRIGHTNESS, HUE-SHIFT, ZOOM,
rotate) or `size 1` (SATURATION, TRANSPARANCY) — `patches/feedbax.webui.maxpat` obj-30/17/27/56/
50/83. Their number boxes and `parameter_initial` values are *internal* (0..size); the sent
value is `2·fill − 1`. This reproduces the measured startup vector exactly (ZOOM initial 0.75
→ −0.25 → zoom 0.7; rotate 0.739 → −0.261 → `* -1` → +0.26092), so the reading is trusted.
So Max's "BRIGHTNESS 1." is the app's raw 0.0 and "HUE 1.1" is the app's 0.1 — the app's
panel shows raw values, which makes "same settings" easy to get wrong by hand.

Measured from the first screenshot's pixels (`scratchpad/sliders.py`):

| fader | fill | raw | mapped per frame |
|---|---|---|---|
| BRIGHTNESS | 0.60 | +0.20 | lightness **−0.004** (zero crossing is raw +0.333) |
| HUE-SHIFT | 0.45 → 0.27 (2nd shot) | −0.10 → −0.46 | hue −0.005 → −0.023 |
| SATURATION | 0.85 | 0.85 | saturation **+0.035** |
| TRANSPARANCY | 1.00 | 1.0 | erase alpha 1.0 — hard clear |
| ZOOM | 0.52 | +0.05 | zoom **0.82** (shrinks; > 1 needs fill ≥ 0.75) |
| rotate | 0.59 | +0.185 → slot −0.185 | theta **+0.58 rad** (33°/frame); 2nd shot −0.69 rad |

Note the HUE-SHIFT fader also moved between the two screenshots, not only rotate.

### The Max frame itself (screenshot 1, render window cropped, `scratchpad/crop.py`)

mean luminance **0.49**, mean chroma **0.54**, **0.0 %** pure black, 4.5 % clipped. The
wave-1 line shows only as a yellow sliver along the bottom edge; the cyan ring measures radius
≈ 0.68 in world units at z = −2 (`radialradius 0.7`).

## The loop map, with the two terms the port is missing

Per pixel, one cycle, both systems (erase 1.0, seeds `D`, warped previous frame `W`):

```
x' = clip( HSL( R( x ) ) + D )
```

`R` = td.rota resample (zoom 0.82, theta, mirror-fold) — same math in both (verified against
`td.rota.jxs` in the Max bundle). `HSL` = rgb2hsl → +(Δh, Δs, Δl) → hsl2rgb. Plane blend
(SRC_ALPHA, DST_ALPHA) with `A_w = A_d = 1` — same. What differs:

**Term 1 — the resample filter.** The port samples the previous frame bilinearly
(`Shaders/WarpHSL.metal:75`). A line thinner than ~2 px loses about half its peak per
resample, so under zoom 0.82 a 12-px seed is gone in ~15 frames and the loop's memory is
~15 generations. With nearest sampling the line never blurs: it shrinks to 1 px and then
persists at full brightness until the lightness term fades it (~250 frames at −0.004),
rotating 33° per generation — the dense multi-hue mesh in the screenshots. Sean's original
capture texture `fst` was explicitly `@filter none`; the retrofit node's capture-texture filter
is **[measure]** (`getattr filter` via `js`), but the look is not reachable with a bilinear loop.

**Term 2 — the HSL clamp.** The port clamps S and L to [0,1] before hsl2rgb
(`WarpHSL.metal:80`, `ShaderMath/HSL.swift:53-54`), following an *assumption* in
`docs/spec/01` line 259 ("would clip at the extremes"). Jitter's reference
`cc.hsl2rgb.jxs` (Max bundle, Jitter Tools) has no clamp: `v2 = L·(1+S)` on the raw S. Gen's
`hsl2rgb` is documented only as "Convert HSL to RGB, preserving alpha" **[measure]**.
Consequence: every seed and every clipped pixel already has S = 1, so in the port the
SATURATION fader is inert above centre (measured: sat 0.86 and sat 0.5 are bit-identical).
Unclamped, S = 1 + δ turns the max channel into a multiplicative gain of (1 + δ/2) per frame
while the min channel goes negative and clips to 0. Combined with the additive lightness loss,
the per-pixel map on a saturated pixel with max channel `m` is

```
m' = (1 + δ/2)·m − |Δl|·(1 + δ)      δ = 0.035, |Δl| = 0.004  →  m* ≈ 0.47
```

Above `m*` content grows to the clip rail and stays; below it decays. RGB clipping is the
bound. That bistable, clip-bounded regime — no black anywhere, saturated pixel-scale colour,
hue drifting through the whole wheel — is the Max frame. The spec's own audit flagged the
`0..1` domain of the saturation `scale` as unverified (§01 line 205).

### Reproduction in the port's headless engine (1920×1080, wave 1 on, silence, 300 frames)

| variant (vector = screenshot 1) | lum | chroma | black | clipped | fine detail `hf` | settle after θ step | fixed point |
|---|---|---|---|---|---|---|---|
| Max frame (screenshot) | 0.49 | 0.54 | 0 % | 4.5 % | — | "much longer" | never (live) |
| port as-is (bilinear, clamped) | 0.015 | 0.027 | 81 % | 0 | 0.0035 | 30 frames to 25 %, `d`=0 by ~60 | yes, static |
| + Max vector vs startup vector | ≈ same | ≈ same | ≈ same | 0 | lower | 30 vs 13 frames | yes |
| + extra 8-bit rounding of warp output | identical | identical | identical | 0 | identical | — | yes |
| unclamped HSL only | 0.016 | 0.033 | 78 % | 0 | 0.0040 | 32 frames | yes |
| nearest only | 0.034 | 0.074 | 66 % | 0.2 % | 0.031 (5×) | 55 frames, tail ~1e-3 at 300 | never exactly 0 |
| nearest + unclamped HSL | 0.21 ↑ | 0.44 ↑ | 33 % ↓ | 29 % | 0.24 | — | none: still filling at 300 |

Vectors alone, and 8-bit rounding, are ruled out. Nearest alone gives the fine detail and the
long settling tail but a dark frame. Only the two terms together reach the Max regime — a
full-field saturated pixel texture over the seed structure, luminance and clipped fraction
still climbing at frame 300 (the Max window had been running for minutes). PNGs:
`scratchpad/max_window1.png`, `max_shot1_base_f300.png`, `max_shot1_nearest_f300.png`,
`max_shot1_nearest_noclamp_f300.png`. The combined run's field is random confetti rather than
Max's structured mesh because the port's seeds have the wrong geometry (next section); it is
not evidence against the mechanism.

## Audio couplings — what the "ring" and the "bass background" are

Verified from `patches/feedbax.sound2.maxpat` listings and Max refpages:

| item | Max | port | verdict |
|---|---|---|---|
| "Bass" (Wave Enable) | `s soundwave_enable` → `enable $1` → graph obj-12 = **waveform 1**, `loadmess 1` | `wave1Enabled = true` | same |
| "Circle" (Wave Enable) | `s soundwave_enable1` → obj-213 = **waveform 2**; no loadmess, and `jit.gl.graph` enables by default → **wave 2 draws at load** with the box unchecked | `wave2Enabled = false` | **port wrong** |
| waveform 1 geometry | `line_width 12`, `scale 1.5 1 0`, `position 0 −0.85 0`, **linear** graph (its `attrui radial` has no loadmess); at z = 0 the visible half-height is 0.828, so the line's centre is 0.022 below the frame edge and only bass peaks push it into view — an audio-gated seed at the bottom edge | drawn as a **radial ring** of radius 1 + sample around (0, −0.85), scale (1.5, 1): huge arcs across the frame every frame | **port wrong** (spec §03 line 124 attributed `loadmess 1 → toggle → prepend radial` to obj-12; the cord goes to obj-213) |
| waveform 2 geometry | `loadmess 1 → prepend radial` → obj-213: **the ring**, `radialradius 0.7` (`loadmess 0.7 → slider → pak radialradius`), `line_width 4`, 1024 points, colour (0, 0.787, 0.821), alpha 0.8 (+ wavebump), blend 6 8, z = −2 | 2 point sprites on a straight line; alpha placeholder 0.5 | **port wrong** |
| waveform 2 input | `*~ -0.5` cold inlet fed by `gswitch`, which is a **message** object (refpage inlets `bang/int`), so the multiplier stays −0.5; then `loadmess 512 → downsample 512 → s wave2cmd` makes `jit.catch~` **average** groups of 512 samples (refpage), flattening the 60 Hz band — the ring is near-static by construction | `wave2InputGain = 0` (spec's signal-inlet reading + a live test with no positive control); stride decimation instead of averaging | ring visibly static in both; port's model is wrong for the wrong reason |
| worldBump (bass → plane z → zoom pulse) | gated by hidden toggle `wordBumpEn` in sound2 (no saved state → OFF); `loadmess 0.05 → flonum → * 0.8` right inlet ⇒ effective multiplier **0.05** | off by default, ×0.05, applied as `2.414/(2.414−b)` scale (`FeedbackCore.swift:200-210`) | same; not the "bass background" |
| "bass background" | wave 1's thick bottom line, deformed by the 46.7 Hz band (`jit.slide` 8/3), entering the frame on bass peaks and then propagated through the loop | absent, because wave 1 is a ring and the loop forgets it in 15 frames | explained by the two loop terms + geometry |
| input device / gain | Core Audio "System Device" 44.1 kHz; `*~ 1.` gain, `uiGain` slider unset | default input node, gain 1.0 | same |
| mic capture from the dev build | — | works from this terminal's TCC identity (cmux): authorized, 44.1 kHz mono, quiet room RMS 0.0014, peak 0.014 (`scratchpad/micprobe.swift`); `AppBootstrap.swift:88-89` starts it with `try?` and nothing in the HUD/panel shows a level | needs a level readout and a visible failure |

## What is NOT the cause (measured)

- The startup vector vs the screenshot vector (ramps, smoothing 100 ms/4 ms, erase mapping,
  zoom/theta/HSL mappings — all term-for-term identical to the patch after b336206).
- Accumulator resolution (both 1920×1080; the Max *window* is 320×180 pt, display only).
- One vs three 8-bit roundings per cycle (no effect at 5 decimals).
- worldBump scaling (0.05 in both).

## Fix plan (in order of effect; each one small)

1. `WarpHSL.metal`: sample the previous frame with `filter::nearest`. Expose as an engine
   option so parity vs Max can be A/B'd, default nearest.
2. `WarpHSL.metal` + `HSL.swift`: drop the S/L clamp; clip RGB per channel after `hsl2rgb`
   (what the char texture does). Update `HSLTests`/golden expectations accordingly.
3. `WaveformRenderer`: wave 1 = linear graph, 12 px, scale (1.5, 1), y = −0.85 (bottom-edge,
   audio-gated); wave 2 = radial ring r = 0.7 + sample, 4 px, 1024 points, cyan, alpha 0.8 +
   wavebump, enabled at load; ring drawn as an ellipse in frame-normalised coordinates
   (screenshot ratio matches). Verify the graph's value→y mapping and `line_width` under glcore
   **[measure]**.
4. `AudioBands`: wave-2 gain −0.5 and `downsample` as group-averaging (verify `jit.catch~`
   mode-3 output size at downsample 512 **[measure]**).
5. Operator panel: show the five faders in Max's convention (BRIGHTNESS/HUE/ZOOM/rotate as
   0..2 with "1." at centre, or label the raw −1..1 with the Max equivalent) so "same
   settings" is reproducible; add an input-level meter and surface `AudioAnalysis.start()`
   failures.
6. Golden scenarios: regenerate after 1–3 (they currently enshrine the bilinear/clamped loop).

## Max-side measurements still owed (GUI — announce before launching)

1. `filter` of the `fb` node's capture texture and of the slab/pix internal textures.
2. Gen `hsl2rgb` with S > 1: feed a known RGB through `jit.gl.pix rgb2hsl → + (0, 0.5, 0) →
   hsl2rgb`, read back; compare with the clamped and unclamped formulas.
3. `jit.gl.graph` line width and value→y scale under glcore; `jit.catch~` output dim at
   `downsample 512`.

## Corrections owed to `docs/spec`

- §03 §5 line 124 / line 293: the forced `radial 1` belongs to waveform 2 (obj-213), not 1;
  waveform 2 draws at load; `radialradius` starts at 0.7.
- §03 §3: `gswitch` is not a signal object; wave 2's multiplier is −0.5; `downsample` averages.
- §01 line 259: HSL S/L are not clamped by Jitter's conversion; RGB clips per channel.
- §01 §1: the loop's resample filter is a first-order term of the look; record the measured
  value once taken.
- §04 §1.2: state the slider widgets' `size/min` and the internal-vs-sent value convention.
