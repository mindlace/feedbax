> Part of the Feedbax technical description — see [`README.md`](README.md) for the overview,
> conventions (object-id citations like `[obj-36]`, `[?]` = unverified), and how the listings
> these sections cite were produced (`tools/maxpat2txt.py`). Each section ends with the audit
> notes from its verification pass.

# Audio input, analysis, waveform drawing and audio-reactive modulation (sound2)

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

Source: `feedbax.sound2.maxpat` (top patcher: 348 boxes / 341 lines), instantiated once in the main patch as `[obj-150] feedbax.sound2` (io=1/2). Object ids below (`obj-N`) refer to `feedbax.sound2` unless a file name prefixes them (e.g. `Feedbax.obj-146`).

## 0. One-clause glossary for objects used only in this file

- **adc~** — audio-in object; each outlet is one hardware input channel (signal).
- **gswitch** — a graphical multi-position switch UI widget with N signal inlets and 1 signal outlet; the leftmost inlet selects (by index) which of the other inlets' signal is passed to the output, like a manual patch-bay selector.
- **filtergraph~** — a GUI EQ-curve editor that doesn't touch audio itself; it outputs biquad coefficients (freq/Q/gain, one set per `set $1` outlet) that get sent into a `biquad~` to actually filter.
- **biquad~** — applies a single 2nd-order IIR filter (coefficients supplied by `filtergraph~` or typed in) to a signal.
- **abs~** — full-wave rectifier (per-sample absolute value) of a signal.
- **slide~** — an asymmetric one-pole signal envelope smoother: separate "slide up" (attack) and "slide down" (release) time constants, in samples-to-converge (not ms).
- **average~** — continuously computes a running average of its signal input; the mode message (`rms`/`bipolar`/`absolute`/`mean`) selects how samples are combined before averaging.
- **avg~** — computes the mean of its signal input *since the last bang*, and outputs that mean as a float when banged (i.e. a "sample-and-average" object, like `snapshot~` but averaging instead of instant-sampling).
- **snapshot~** — outputs the instantaneous current value of its signal input as a float whenever banged.
- **jit.catch~** — buffers an audio signal and, on bang, emits the buffered samples as a 1-row Jitter matrix (so a waveform can be drawn/processed as image/geometry data). Key attributes: `@framesize` (samples captured per matrix), `@mode` (capture-trigger mode — the listing does not resolve the exact enum, see Open Questions), `@trigthresh`/`@trigdir` (oscilloscope-style trigger level/direction used by some modes), `@downsample` (stride/decimation factor applied when filling the matrix).
- **jit.gl.graph** — draws a 1-D (or radial) Jitter matrix as a line/point graph in the GL context; `@automatic 0` means it only draws on receiving a bang.
- **jit.slide** — the Jitter (matrix) analogue of `slide~`: per-cell asymmetric temporal smoothing of a matrix stream (`@slide_up`/`@slide_down` in "adapt" units, `@adapt 1` = relative/proportional smoothing).
- **accum** — running accumulator: adds its left-inlet input to a running total (or resets on a `1`/`0` control) and outputs the sum; used here inside `xypinch` for pinch/rotate gesture integration, not audio.
- **mira.multitouch / mira.mt.pinch / mira.mt.rotate / mira.mt.centroid** — Mira (iPad remote-control surface) multitouch primitives: raw touch events, and derived pinch, rotation, and centroid (average touch position) gestures.
- **pak** — like `pack`, but (unlike `pack`) re-outputs the full list on *any* inlet's update, not just the left one.
- **swatch** — a color-picker UI object; outputs r g b a (0..1) on click, and accepts `alpha $1` etc. to update one channel of its stored color without a click.

## 1. Signal-flow diagram

```
                          ┌────────────────────────────────────────────────────────┐
                          │  MAIN PATCH (Feedbax.maxpat)                            │
   ┌───────────┐  gain    │  r uiGain ──► live.slider[332] ──┐                      │
   │  webUI /   │◄─────── │                                   │                      │
   │  Mira      │  uiGain │            ┌──────────────────────┘                      │
   └───────────┘          │            ▼                                             │
                          │      feedbax.sound2 (inlet 0 = gain float)               │
                          └────────────────────────────────────────────────────────┘
                                       │
   ┌───────────────────────────────── ▼ ────────────────────────────────────────────┐
   │ feedbax.sound2                                                                  │
   │                                                                                  │
   │  adc~[186] ──► gswitch[56] (0=mic default, 2=440Hz test-tone pair) ──►          │
   │        *~1.[51] ◄── inlet0 (uiGain float, right/cold inlet = multiplier)         │
   │        │                                                                        │
   │        ├──► outlet0/outlet1 ──► main patch live.slider feedback / meter~[203]   │
   │        ├──► meter~[310]  (Mira "SoundWaves" tab VU meter)                       │
   │        │                                                                        │
   │        ├──► biquad~[17] (EQ≈46.7 Hz via filtergraph~[8]) ─┬─► jit.catch~[3] ──► jit.slide[208] ──► jit.gl.graph[12]  "WAVEFORM 1" (radial, bottom of frame)
   │        │                                                   ├─► *~2.2[360] ──► avg~[365] ──► +0.[367] ──► s wavebumpsig ─┐
   │        │                                                   └─► *~1.[55] ──► avg~[11] ──► s kittybumpsignal (→ webUI meter only)
   │        │                                                                                                              │
   │        ├──► *~-0.5[128] [!see §3: cold inlet actually driven by dead gswitch[126]/flonum[98], likely ≈0 not -0.5] ──► biquad~[206] (EQ≈60 Hz via filtergraph~[205]) ──► jit.catch~[214] ──► jit.gl.graph[213] "WAVEFORM 2"
   │        │                                                                                                              │
   │        └──► +~[286](no-op) ──► *~1.[282](no-op) ──► biquad~[280] (EQ≈144 Hz via filtergraph~[279]) ──► abs~[259] ──►   │
   │                                                       slide~[260] (asym. env.) ──► average~[256] ──► snapshot~[255] ──►│
   │                                                       *0.05(eff.)[248] ──► s worldBump ───────────────────────────────┼─► Feedbax.maxpat:
   │                                                                                                                        │     r worldBump ──► t b f ──► +0.[93] (left inlet = flonum[67], default -0.414, not 0) ──► pak position[72] inlet3 (Z) ──► main jit.gl.videoplane[44] @position
   │                                                                                                                        │
   │  r wavebumpsig ──► t b f ──► +0.[368] (+ base from slider[338]) ──► prepend alpha ──► swatch[189] ──► s hue2 ──► graph[213] color alpha  ◄┘
   │                                                                                                                        │
   │  gate[263] opens on wordBumpEn/toggle287, passes r ctrlbang (per-frame) → triggers snapshot~[255] above               │
   │  gate[362] opens on wavebump/toggle357, passes r audiobang (per-frame) → triggers avg~[365] above                    │
   │  gate[41]  opens on kittybump(webUI)/toggle344, passes r ctrlbang → triggers avg~[11] above                          │
   │                                                                                                                        │
   │  r audiobang ──► bangs jit.catch~[3]/[214] to emit matrix, AND bangs jit.gl.graph[12]/[213] to redraw (both @automatic 0)│
   └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## 2. Audio input and gain

- `adc~` [obj-186], no arguments → captures the system's default input channel(s) (io shows 2 outlets, i.e. 2 channels captured; only outlet 0 is used).
- `[obj-13] toggle` (default **on**, `loadmess 1` [obj-49]) feeds `adc~`'s inlet — gates whether the object receives/opens audio at all.
- `[obj-56] gswitch` (io 3/1): inlet1 = live mic (`adc~` outlet 0), inlet2 = a self-test 440 Hz+440 Hz tone pair (`cycle~ 440.`[77]/[85] summed via `+~`[86], scaled `*~0.2`[88], each oscillator's frequency settable via a `flonum`→`"$1 20"`→`line~` 20 ms ramp — a manual calibration/debug tone, not audio-reactive). Selector fed by `loadmess 0`[54] → inlet0. **[corrected]** Whether selector-value 0 indexes "inlet1" or is itself literally routed to inlet index 0 is not resolvable from `gswitch`'s documented behavior alone; the parameter table's "0/1/2" range for this control is likewise unconfirmed — read as "0 (typed default) selects the mic path" [?]. A second, apparently-unused duplicate selector/tone-generator pair exists (`gswitch`[126] + `cycle~`[113]/[125]) — **[corrected, see §3 and §7 Dead/vestigial]** this second `gswitch`'s output is not merely a dead dangling duplicate: it is wired live into the **cold (right) inlet of `*~ -0.5`[128]**, i.e. into the wave‑2 EQ input stage described below, so its "default silence" behavior actually matters for wave 2's signal path.
- Gain: the subpatcher's single inlet [obj-50] carries the current gain value (a float, not a signal) into `*~ 1.`[51]'s **right** (cold) inlet, multiplying the selected mic/tone signal. That gain float originates from `live.slider`[Feedbax.obj-332] in the main patch, which is itself driven either by direct manipulation or by `r uiGain` [Feedbax.obj-58] ← `s uiGain` [obj-312] ← the "Audio Gain" `slider`[obj-311] on the Mira "SoundWaves" remote tab (`mira.frame`[obj-177]). **No smoothing is applied to gain** — it is a raw multiply, not one of the `mIniCtlSmooth`-ramped controls.
- Post-gain signal `*~1.`[51] output fans out to 6 destinations (see diagram): main-patch metering (`outlet`[19]/[53] → `live.slider`/`meter~`[203]), the Mira tab's own `meter~`[310], and the three parallel EQ/analysis chains described below.

## 3. The three parallel EQ/analysis chains

All three use a `filtergraph~` (GUI EQ curve editor, `@nfilters=1`, one band) driving a `biquad~`. None of the three `"gainmode 1"` messages ([obj-60],[obj-198],[obj-272]) are wired to any trigger (no loadbang/loadmess feeds them) — they are dead, manual-click-only messages; the actual runtime `gainmode` is whatever is baked into each `filtergraph~`'s saved state (not visible in this listing).

| Chain | filtergraph~ | biquad~ | Default filter (from `setfilter` attr) | Feeds |
|---|---|---|---|---|
| Waveform 1 | [obj-8] | [obj-17] | freq ≈ 46.7 Hz, Q ≈ 0.92, gain ≈ 1.02 | `jit.catch~`[3] (waveform 1 matrix), `*~2.2`[360]→`avg~`[365] (wavebumpsig), `*~1.`[55]→`avg~`[11] (kittybumpsignal, webUI-only) |
| Waveform 2 | [obj-205] | [obj-206] | freq ≈ 60.0 Hz, Q ≈ 2.05, gain ≈ 0.90 | `jit.catch~`[214] (waveform 2 matrix) — input signal is `*~ -0.5`[128], **[corrected]** but "-0.5" is only `[128]`'s *typed* argument, not its runtime multiplier; see below |
| worldBump | [obj-279] | [obj-280] | freq ≈ 144.3 Hz, Q ≈ 1.77, gain ≈ 0.71 | `abs~`[259]→`slide~`[260]→`average~`[256]→`snapshot~`[255] (worldBump) |

All three bands sit in the bass/sub-bass region (46–144 Hz) — this is a **kick/bass-thump detector bank**, not a general spectral analyzer. Exact `filtergraph~` filter-*type* code (the `1` in each `setfilter` array) is not resolved by the listing; treat as "a low-shelf/peaking/bandpass-ish resonant filter near the stated center frequency" [?].

**[correction/addition] `*~ -0.5`[128]'s cold inlet is not a fixed constant.** `[obj-51 *~1.]:0 → [obj-128 *~-0.5]:0` carries the gained mic/tone signal into the object's hot (signal) inlet, as stated above. But its **cold (right) inlet 1 has two separate wires into it**: `[obj-98 flonum]:0 → [128]:1` (a manual, unconnected-upstream number box, no forced default found in this listing) **and** `[obj-126 gswitch]:0 → [128]:1` (the "dead" second `gswitch`+test-tone pair flagged in §7). Per standard Max/MSP behaviour, once a signal-rate patch cord is connected to a `*~` cold inlet, that inlet is compiled as a full signal input, and the object's typed literal argument (`-0.5`) — and any float sent to the same inlet, including from `flonum`[98] — has no further audible effect; the *actual* running multiplier at DSP time is whatever `gswitch`[126] is outputting. `gswitch`[126]'s selector defaults to 0 (`loadmess 0`[104]), and the signal candidate it selects at that position (inlet1) is **itself unconnected** (see §7), so by default `gswitch`[126] outputs silence (0). **Net effect [?], not independently verified by running the patch: waveform 2's entire EQ/analysis input is most likely near‑silent by default**, not "the gained signal times -0.5" as a naïve reading of the object's typed argument would suggest — and even if an operator flips `gswitch`[126]'s selector to inlet2, that only reaches the dead `cycle~`[113]/[125] test tone, never live mic audio. This materially changes what a port should expect waveform 2 to display out of the box; verify against a running instance of the patch before assuming any specific gain/polarity for wave 2's default input.

Between `*~1.`[51] and the worldBump `biquad~`[280] sits `+~`[286]→`*~1.`[282] — both are literally no-ops (their second inlets are unconnected, so `+0` / `×1`), apparently vestigial scaffolding for a second input that was never wired (comment `// in` [obj-288] sits at this spot). A dead-end sibling `+~`[285] (also fed from [282], output goes nowhere) confirms this was a mixing point that was abandoned.

## 4. Turning signal into a drawable matrix: `jit.catch~`

Both waveform chains use one `jit.catch~` each. Both are typed `@mode 3 @framesize 1024 @trigthresh 0.02 @downsample 0`, but runtime attribute messages change some of that at load:

| | jit.catch~[3] (wave 1) | jit.catch~[214] (wave 2) |
|---|---|---|
| framesize | 1024 (typed default; `attrui`[121] is a live manual knob, no forced default found) **[corrected: `attrui`[172] belongs to the wave-2 column, not this one — `[obj-172 attrui framesize]:0 → [obj-214 jit.catch~]`, not `[obj-3]`]** | 1024 (typed default; `attrui`[172] manual) |
| mode | **3** (typed; no override wired — but `attrui`[120] is also a live manual mode knob wired to this object, **[addition]** not previously noted) | **2** (forced at load: `loadmess 2`[133]→`number`[134]→`prepend mode`[142]→jit.catch~; `attrui`[173] is also a live manual mode knob wired here, **[addition]** not previously noted) |
| downsample | **2** (forced at load: `loadmess 2`[92]→`number`[100]→`prepend downsample`[95]) | **512** (forced at load via the generic `wave2cmd` bus: `loadmess 512`[97]→`number`[99]→`prepend downsample`[101]→`s wave2cmd`→`r wave2cmd`[317]) — this is a much larger stride than wave 1's; flagged [?], see Open Questions |
| trigthresh / trigdir | 0.02 typed; `attrui`[187]/[71] manual, no forced default | 0.02 typed; `attrui`[176]/[223] manual, no forced default |

`jit.catch~`'s own inlet is also where the **trigger to actually emit the buffered matrix** arrives: `r audiobang` feeds both [obj-44]→jit.catch~[3] and [obj-164]→jit.catch~[214]. `audiobang` is the global per-frame bus fired once per 60 Hz tick in the main patch's frame loop (see the overview) — so **each frame, once**, both catch objects dump their currently-buffered window of samples as a fresh 1×N matrix.

Waveform-2's `jit.catch~`[214] also listens on the generic remote-control bus `r wave2cmd`[317] (any `prepend`-style attribute message the Mira "SoundWaves" tab sends, e.g. the downsample slider above) — this is a live-adjustable control surface, not something audio-driven.

Wave 1's matrix is additionally smoothed through `jit.slide`[208] `@adapt 1 @slide_up 8 @slide_down 3` (asymmetric per-sample temporal smoothing, attack faster than release) before reaching the graph object; wave 2's matrix goes to its graph **unsmoothed**. **[addition]** `jit.slide`[208]'s live attribute knobs are duplicated: both `attrui`[123]/[124] and `attrui`[15]/[5] independently drive `slide_up`/`slide_down` on the same object (a redundant-GUI pattern seen elsewhere in this file, e.g. Wave 1's line_width/circpoints knobs). A second, identically-configured `jit.slide`[175] exists but is never fed any matrix and its output goes nowhere — dead (see §7).

## 5. Drawing: `jit.gl.graph`

Two independent `jit.gl.graph` instances, both in GL context `"foo"` (the same context as the main videoplane) and both `@automatic 0` (draw only on bang, banged every frame by `r audiobang`).

### Waveform 1 — `[obj-12] jit.gl.graph`

Typed defaults: `@antialias 0 @auto_material 0 @color 1 1 1 1 @lighting_enable 0 @shininess 50 @smooth_shading 0 @circpoints 5 @automatic 0 @shadow_caster 0`.

| Attribute | Source | Default effective value | Notes |
|---|---|---|---|
| data (the line itself) | `jit.slide`[208] ← `jit.catch~`[3] | live waveform matrix | |
| `enable` | `toggle`[20] **or** `r soundwave_enable`[14] → `msg "enable $1"`[18] | **1** (`toggle`[20] set on load via `loadmess 1`[185]) | on by default |
| `radial` | `toggle`[241] → `prepend radial`[239] (forced), **and** `attrui radial`[22] (manual, redundant) | **1** (forced by `loadmess 1`[170]→toggle241) | Waveform 1 renders **radially** (circular/polar oscilloscope), not linear left-to-right — comment `// audio loop viz` [obj-243] confirms this is deliberately a closed loop shape |
| `position` | `pak position 0. -0.85 0.`[84] ← `flonum`[81]/[82]/[83] (manual), fired once at load via `loadbang`[179] | (0, −0.85, 0) | placed near the **bottom** of the frame in NDC-ish space |
| `scale` | `pak scale 1.5 1. 0.`[39] ← `flonum`[38]/[36]/[37] (manual), fired once at load via `loadbang`[31] | (1.5, 1, 0) | wide, flat |
| `rotatexyz` | `pak rotatexyz 0. 0. 0.`[157] ← `flonum`[154]/[155]/[156] (manual), fired by a `button`[42] click (not on load) | (0,0,0) until user clicks | |
| `color` | `r hue1` → `prepend color`[210] | see §6 | static color picker(s), not audio-driven |
| `lighting_enable` | `attrui`[33] (manual) **or** `r soundwave_lighting_enable`[28] → `msg "lighting_enable $1"`[25] (webUI) **or** `toggle`[45] → same `msg`[25] | **[corrected] 1**, not 0 — `toggle`[45] is *also* set on load by the same `loadmess 1`[185] that sets `toggle`[20] (see `enable` row above; that shared `loadmess` was previously misattributed to this row's off-typed-default claim). `[obj-45 toggle]:0 → [obj-25 msg "lighting_enable $1"]:0 → [obj-12 jit.gl.graph]:0` forces `lighting_enable 1` at patch load, overriding the object's own typed `@lighting_enable 0`. | |
| `blend_mode` | `pak blend_mode 6 7`[112] ← `number`[110]/[111] (manual), fired once via `loadbang`[29] | (6,7) = src_alpha / one_minus_src_alpha (standard alpha blend) | |
| `blend_enable` | `pak blend_enable 1`[114] ← `toggle`[116] (forced `1` via `loadmess 1`[94]) | **1** | |
| `line_width` / `circpoints` | `toggle`[43] (default **1**, `loadmess 1`[188]) **or** `r waveLineFilll`[46] **[corrected: this bus is live, sent by `feedbax.webui` — not dead]** → `sel 0 1`[30] → messages `"line_width 12"`[27] / `"circpoints 1"`[23] | forced at load to **line_width=12, circpoints=1** (solid thick line, not dotted) because toggle43 defaults on and `sel`'s test-value happens to match, and can additionally be remote-driven from `feedbax.webui` at runtime; **manual `attrui`[65]/[58]/[34] also drive the same attributes redundantly** | |
| `smooth_shading`, `two_sided`, `poly_mode`, `antialias`, `shadow_caster`, `shininess`, `circpoints`(dup) | plain `attrui`[32]/[61]/[62]/[9]/[35]/[40]/[58] | typed defaults, GUI-only, not audio-reactive | |

### Waveform 2 — `[obj-213] jit.gl.graph`

Typed defaults: `@antialias 1 @auto_material 0 @color 1 1 1 1 @lighting_enable 0 @shininess 0. @smooth_shading 0 @circpoints 5 @automatic 0 @shadow_caster 0 @line_width 2 @blend_enable 0`.

| Attribute | Source | Default effective value | Notes |
|---|---|---|---|
| data | `jit.catch~`[214] directly (no jit.slide smoothing) | live waveform matrix | |
| `enable` | `toggle`[159] **or** `r soundwave_enable1`[160] → `msg "enable $1"`[161] | **1** (`loadmess 1`[169] sets toggle159 **and** the disconnected toggle148 both to 1) | |
| `radial` | only `attrui radial`[217] (manual) — **no forced-on toggle equivalent to wave 1's** | unknown from listing [?] | |
| `position` | `pak position 0. 0. -2.`[299] ← `flonum`[296]/[297]/[298] (manual X/Y) **and** `p mIniCtlSmooth`[91] (Z, smoothed) ← gesture pinch depth, see §7 | (0,0,−2) baseline, Z is gesture-modulated | not audio-driven |
| `scale` | `pak scale 1. 1. 1.`[303] ← `flonum`[300]/[301]/[302] (manual), fired via `loadbang`[131] | (1,1,1) | |
| `rotatexyz` | `pak rotatexyz 0. 0. 0.`[291] ← `p mIniCtlSmooth`[261]/[266] (smoothed gesture rotation, from `xypinch`[233] via `mira.mt.centroid`[251]) | gesture-driven, not audio | |
| `radialradius` | `pak radialradius 1.`[305] ← `slider`[329] (manual "Radius") **and** `flonum`[87] ← `p mIniCtlSmooth`[69] ← `xypinch`[68] pinch gesture | gesture-driven | |
| `color` | `r hue2` → `prepend color`[178] | see §6 — **alpha channel is audio-modulated by wavebumpsig** | |
| `lighting_enable` | `attrui`[211] **or** `r soundwave_lighting_enable1`[167] → `msg`[168] | 0 | |
| `blend_mode` | `pak blend_mode 6 8`[197] ← `number`[195]/[196] (manual), fired via `loadbang`[180] | (6,8) = src_alpha / dst_alpha (unusual — not the standard 6/7 pair used for wave 1) | |
| `blend_enable` | `pak blend_enable 1`[194] ← `toggle`[193] (manual) | **1** — **[corrected]** `loadbang`[180] does *not* set `toggle`[193]; it bangs `pak`[194]'s inlet 0 directly (`[obj-180 loadbang]:0 → [obj-194 pak blend_enable 1]:0`), which re-outputs the pak's own typed literal argument (`1`) since inlet 1 (fed by the un-forced `toggle`[193]) has not been set to anything at that point. The numeric default (1) is still correct, but it comes from `pak`'s typed argument, not from `toggle`[193]. | overrides the object's own typed `@blend_enable 0` |
| `line_width` | `attrui`[144] (manual) **and** generic `wave2cmd`... no — `prepend line_width`[323] ← `number`[324] (Mira "Thickness" control) → `s wave2cmdG`[327] → `r wave2cmdG`[328] | manual only, not audio | |
| `poly_mode` | `msg "poly_mode 0 0"`[165] fired by `loadbang`[166] (forced) | **(0,0)** = point-style rendering (matches `circpoints`-driven dotted look) | a second message `"poly_mode 2 2"`[234] exists but is never triggered — dead |
| `circpoints` | `toggle`[137] (default **0**, `loadmess 0`[162]) → `sel 0 1`[138] ← `r waveLineFilll1`[136] (dead bus, no sender) → `"circpoints 5"`[140] (selected because toggle137=0) | forced to **circpoints=5** at load — waveform 2 renders as a **dotted/circle-point line**, unlike waveform 1's solid line | `"line_width 4"`[139]/`"circpoints 1"`[141] exist for the other toggle state but are unreachable while toggle137 stays 0 |
| `smooth_shading`, `two_sided`, `antialias`, `shadow_caster`, `shininess`, `circpoints`(dup) | plain `attrui`[209]/[220]/[221]/[16]/[218]/[219]/[212]/[147] | typed defaults, manual | |
| `gl_color` | `attrui gl_color`[333] | manual, separate from the `color` message path | |

## 6. Color buses `hue1` / `hue2`

- `hue1`: two independent `swatch` pickers both send on this bus — [obj-236] (base RGB, default `0.392375 0.23808 0. 1.` = burnt orange, set at load via `loadbang`[184]→msg[183]) and [obj-232] (a duplicate on the Mira panel, alpha only forced via `slider`[215] default **0.8**, `loadmess 0.8`[229] → `prepend alpha`[64]). Neither is audio-driven.
- `hue2`: same pattern — [obj-238] (base RGB, default `0. 0.786722 0.821229 1.` = cyan, `loadbang`[184]→msg[182]) and **[obj-189]**, whose alpha is the one continuously driven by the bump envelope (below). **[addition]** A third message box, `msg "0. 0.786722 0.821229 1."`[obj-72], is a byte-for-byte duplicate of [182] sitting nearby in the patcher — but it has **no incoming or outgoing connections at all**; it is fully orphaned (not even reachable by a click), unlike the other dead objects in §11 which are at least wired on one side.

### The audio-reactive alpha pulse (waveform 2 only)

```
r wavebumpsig ──► t b f[369] ──┬─(outlet1,f)─► +0.[368] right/cold inlet (addend = wavebumpsig value)
                                └─(outlet0,b)─► +0.[368] left/hot inlet  (bang → output = leftStored + wavebumpsig)
slider[338] (manual base, default unknown from listing [?]) ──► +0.[368] left/hot inlet directly
+0.[368] output ──► prepend alpha[337] ──► "alpha <v>" ──► swatch[189] ──► s hue2 ──► graph[213] color alpha
```

So waveform 2's **color alpha = baseAlphaSlider[338] + wavebumpsig**, resent every time `wavebumpsig` updates (i.e. once per frame while enabled — see §8). This is the only place in this file where audio analysis modulates a *visual* parameter of a graph directly (as opposed to camera/plane position). Because [obj-189] and [obj-238] both write `hue2` independently, whichever fired most recently wins — while the bump loop is enabled it will keep re-asserting cyan-with-pulsing-alpha over any RGB the user picked on [obj-238]'s swatch (only alpha is meant to be overridden, but since both swatches carry their own stored RGB, the user's manually-picked color on [238] is not what ends up visible once [189]'s alpha message fires) [?].

## 7. The "bump" systems

There are effectively **three independently-gated audio envelope followers** sharing the same bass-biquad~ outputs, each gated by its own enable flag and each triggered once per frame by a global bang bus. None of them share code — each is its own gate→averager→sender chain.

### 7a. `worldBump` — drives the main videoplane's Z position

- **Enable gate**: `gate`[263], control inlet fed by `r wordBumpEn`[264] **[corrected]** — per the send/receive cross-reference, `wordBumpEn`'s only sender is `s wordBumpEn`[obj-331] inside **this same file** (`feedbax.sound2`), fed by `toggle`[339] (comment `// worldbump`, on the Mira "SoundWaves" panel that lives inside this patcher). It is *not* a cross-file webUI bus like `kittybump`/`soundwave_enable` are — sender and receiver are both in `feedbax.sound2`. **or** local `toggle`[287] (comment `// Wordlbump`); pass-inlet fed by `r ctrlbang`[265] (global per-frame control-update bang). No loadmess sets either toggle/bus on — **default OFF**. **[addition]** The same `r wordBumpEn`[264] also feeds `sel 0`[246], whose outlet 0 (fires when wordBumpEn = 0, i.e. by default) sends message `"0,"`[102] to `s kittybumpsignal1`[262] — an additional write to that already-dead bus (see §11), presumably meant to zero it when worldBump is disabled; since nothing receives `kittybumpsignal1` anywhere in the project this path is inert too.
- **Envelope**: worldBump-band `biquad~`[280] (≈144 Hz) → `abs~`[259] (rectify) → `slide~`[260] (asymmetric smoothing, up/down times both from `number`[258]/[257], each defaulting to **2500** samples via `loadmess 2500`[245]/[244] — i.e. symmetric attack/release despite the UI allowing asymmetry) → `average~`[256] (mode = `"absolute"`, set once at load via `loadbang`[250]→msg[254]; `"rms"`[252]/`"bipolar"`[253] messages exist but are never triggered — dead) → `snapshot~`[255], sampled once per open-gate bang.
- **Scale**: `snapshot~` output → `* 0.8`[248], but the right inlet is overridden by `flonum`[247] which defaults to **0.05** via `loadmess 0.05`[103] — so the *effective* multiplier is 0.05, not the literal 0.8 in the object box.
- **Output**: sent on `s worldBump`[318] (and duplicated, uselessly, on `s kittybumpsignal1`[262] — dead, no receiver anywhere). **[addition]** There is also a second `r worldBump`[obj-330] inside **this same file** with **zero outgoing connections** — a dead stub receiver, which is why the cross-reference table lists `feedbax.sound2` itself as a "receiver" of `worldBump` alongside `Feedbax`; it is not a second functioning consumer.
- **Consumer** (in `Feedbax.maxpat`): `r worldBump`[Feedbax.obj-146] → `t b f`[Feedbax.obj-98] → `+ 0.`[Feedbax.obj-93] → **inlet 3 (Z) of `pak position 0. 0. 0.`[Feedbax.obj-72]**, which feeds `@position` of the main `jit.gl.videoplane`[Feedbax.obj-44] (typed default position `0. 0. -0.4`). **[corrected]** The left/hot operand of `+ 0.`[93] is *not* "always 0": `[Feedbax.obj-67 flonum]:0 → [93]:0` feeds it directly, and that `flonum` is forced at load to **`-0.414`** via `[Feedbax.obj-81 loadmess -0.414]`. `t b f`[98]'s outlet 1 (float, fires first, right-to-left) sets `+0.`[93]'s cold/right inlet to the incoming worldBump value; outlet 0 (bang, fires second) triggers the add using the current left value. So the actual formula is **Z = flonum67 (default −0.414, live-editable) + worldBump**, not `0 + worldBump`. Because `pak` re-outputs on any inlet change, every worldBump update immediately re-sends the full `position x y (−0.414+worldBump)`-ish vector (X/Y come from separate manual, unforced `flonum`s[Feedbax.obj-69]/[71], not shown in this file). **Net effect: the whole mirrored feedback plane is pushed/pulled in Z (toward/away from camera) in time with detected bass energy, around a baseline of roughly the videoplane's own typed default Z (−0.4)** — a "world bump"/camera-thump effect. No other *functioning* consumer of `worldBump` was found in the cross-reference (see the dead in-file stub receiver noted above).

### 7b. `wavebump` / `wavebumpsig` — drives waveform 2's alpha pulse

- **Enable**: `wavebump` bus is *only* a boolean sent by `toggle`[372] (near comment `// wave ab`) → `s wavebump`[370]. **Default OFF** (no loadmess). It, or local `toggle`[357], opens `gate`[362] (pass-inlet fed by `r audiobang`[364] — note: this one uses the per-frame **audio** bang, not `ctrlbang`, unlike 7a/7c).
- **Envelope**: reuses waveform-1's EQ output — `biquad~`[17] (≈46.7 Hz) → `*~2.2`[360] (gain overridable by `flonum`[359], no default override found → stays **2.2**) → `avg~`[365] (mean since last bang; the bang is the gated `audiobang`) → `+0.`[367] (no-op pass-through) → `s wavebumpsig`[361].
- **Consumer**: as detailed in §6 — drives `graph[213]`'s (waveform 2) color alpha, added to a manual base from `slider`[338].
- No numeric scaling/clamping is applied to `wavebumpsig` before it becomes an alpha value — if the averaged rectified-ish signal exceeds ~1.0 the alpha message will just clip however `jit.gl.graph`/GL clamps out-of-range alpha (undefined here) [?].

### 7c. `kittybump` / `kittybumpsignal` — webUI meter feedback only (no visual effect in this file)

- **Enable**: `r kittybump`[26] (sent **from** `feedbax.webui`, per cross-file bus table) or local `toggle`[344] opens `gate`[41] (pass-inlet fed by `r ctrlbang`[21]).
- **Envelope**: same waveform-1 EQ output, `*~1.`[55] (unity gain, cold inlet manually overridable via `flonum`[96] — **[addition]** no forced default found, so it stays at the typed 1.0 unless an operator edits it) → `avg~`[11] (mean since last gated bang).
- **Output**: `s kittybumpsignal`[47] → received **only** in `feedbax.webui` (per cross-reference table) — i.e. this feeds a meter/indicator widget on the web control UI, not any render parameter inside `sound2` or the main patch. **It does not modulate anything visual in this file.** Its sibling `s kittybumpsignal1`[262] (from §7a) has no receiver anywhere and is fully dead.

### Summary of bump triggers/shapes

| Bump | Trigger cadence | Rectify? | Smoothing | Enable default | Output range | Consumes |
|---|---|---|---|---|---|---|
| worldBump | `ctrlbang` (per-frame, gated) | yes (`abs~`) | `slide~` (2500/2500 samples) + `average~` | OFF | float, ×0.05 scale | videoplane Z position (main patch) |
| wavebumpsig | `audiobang` (per-frame, gated) | no explicit rectifier (raw biquad~ output ×2.2, then averaged) | `avg~` averaging window only | OFF | float, unscaled | waveform-2 color alpha (this file) |
| kittybumpsignal | `ctrlbang` (per-frame, gated) | no | `avg~` averaging window only | depends on `feedbax.webui`'s `kittybump` toggle | float, unscaled | webUI meter (outside this file) — **no visual effect here** |

Despite the "Kitty"/"world"/"wave" naming, all three are **envelope followers on the same bass-filtered mic signal, sampled once per frame**, each independently gated and routed to a different destination (camera Z, waveform alpha, remote meter). None does peak/onset detection (no comparator against a rising-edge threshold) — they are continuous smoothed levels, not discrete "hit" triggers, despite the term "bump" suggesting a transient.

## 8. The `xypinch` subpatchers — role in this file

Two identical `p xypinch` instances ([obj-233], [obj-68]) each wrap a `mira.mt.pinch` + `mira.mt.rotate` pair, translating raw two-finger touch gestures on the Mira iPad UI into: outlet0 = a smoothed pinch/zoom delta (`scale -10. 10. -0.2 0.2`, clipped, accumulated with `accum 0.33`, clipped to ±1, rescaled `0..100 → 0..1 (×1.02 exp curve)`), outlet1 = a smoothed rotation angle (`accum` of rotate deltas, rescaled `-360..360 → 360..-360`, i.e. inverted). **[verified/caveat]** The endpoints of this description (input `scale`, final `clip`, and final rescale objects/arguments) check out exactly against the subpatcher listing. However, between "clipped" and "accumulated" the real subpatcher routes the pinch delta through roughly ten comparator/`gate` objects (`< 1.`, `!= 1`, `> 0.`, `< 0.`, `== 1` ×2, `&&`, `<= 1.`, `< 1.01`, six `gate`s, a second `accum 0.33`) implementing what looks like a magnitude/direction rate-limiter or step-gate before the pinch value is allowed to accumulate — this write-up compresses that into "accumulated with accum 0.33, clipped to ±1" without resolving the gating logic in detail. Treat the exact intermediate behavior as unresolved [?]; it does not change the two `outlet`-facing endpoints for a first-pass port, but may matter for exactly reproducing gesture feel. Both outlets feed straight into `p mIniCtlSmooth` instances before reaching `pak position`/`pak rotatexyz`/`pak radialradius` on **waveform 2**'s graph[213] only (rotation, Z-position/depth via `mira.mt.centroid`, and radial radius). **These are manual touch-gesture controls for a human operator to reposition/spin/zoom waveform 2 on the remote iPad UI — they carry no audio-derived data and are unrelated to the bump systems.** `mIniCtlSmooth` (per the pre-established global description) ramps every value it receives to its target over `controlSmoothMs` ms (broadcast from `feedbax.misc`, value not visible in this file) at `lineSmoothGrain` ms steps (also from `feedbax.misc`).

## 9. Per-frame pseudocode (for a port)

```text
// Called once per global 60 Hz tick, after the audiobang/ctrlbang phases fire (per known the overview)

// --- audio input (continuous, not per-frame) ---
raw = selectedInput()               // mic by default, or a 440Hz+440Hz test tone if operator switches gswitch
gained = raw * uiGain               // uiGain: float from webUI/Mira "Audio Gain" slider or main-patch live.slider, UNsmoothed

// --- three bass-band envelope followers, each independently gated ---
if (wordBumpEnabled) {                                  // default false
    band1 = biquad(gained, f=144.3Hz, Q=1.77)            // worldBump band
    rect  = abs(band1)
    env   = asymSlide(rect, up=2500samp, down=2500samp)  // slide~
    avg   = runningAverage(env, mode="absolute")         // average~
    worldBump = snapshot(avg) * 0.05                     // sampled once this frame
    mainVideoplane.position.z = zBaseline + worldBump    // [corrected] zBaseline is a live flonum (Feedbax.obj-67),
                                                           // defaulting to -0.414 via loadmess, NOT a fixed 0 — see §7a.
                                                           // pak position x y z -> jit.gl.videoplane @position (main patch)
}

if (waveBumpEnabled) {                                   // default false
    band2 = biquad(gained, f=46.7Hz, Q=0.92)              // same band as waveform-1's EQ
    wavebumpsig = meanSinceLastBang(band2 * 2.2)          // avg~, triggered by audiobang
    waveform2.colorAlpha = baseAlphaSlider + wavebumpsig  // hue2 swatch "alpha" message
}

if (kittybumpEnabled) {                                   // default = feedbax.webui's toggle state
    band1b = biquad(gained, f=46.7Hz, Q=0.92)             // same band1 chain as waveform-1
    kittybumpsignal = meanSinceLastBang(band1b * 1.0)      // avg~, triggered by ctrlbang
    sendToWebUIMeter(kittybumpsignal)                      // NOT used inside this file's render
}

// --- waveform matrices, captured continuously, emitted once per frame on bang ---
wave1Matrix = jitCatchEmit(catch1, downsample=2,  framesize=1024, mode=3)   // input: biquad(gained,46.7Hz,Q0.92)
wave1Matrix = temporalSmooth(wave1Matrix, up=8, down=3, adaptive=true)      // jit.slide

wave2Input  = biquad(gained * wave2Mult, f=60.0Hz, Q=2.05)                 // [corrected] wave2Mult is NOT a fixed -0.5:
                                                                             // *~-0.5[128]'s cold inlet has a live signal
                                                                             // patched in from a broken duplicate gswitch
                                                                             // (default = silence). Effective default is
                                                                             // most likely wave2Mult≈0 (near-silent), not -0.5.
                                                                             // Verify against the running patch. See §3.
wave2Matrix = jitCatchEmit(catch2, downsample=512, framesize=1024, mode=2)  // NOTE unusually large downsample, verify

// --- draw, only if each graph's own enable flag is on (both default ON) ---
if (waveform1Enabled) {
    drawGraph(wave1Matrix, radial=true, position=(0,-0.85,0), scale=(1.5,1,0),
              color=hue1, lineWidth=12, circpoints=1, blend=(srcAlpha,1-srcAlpha))
}
if (waveform2Enabled) {
    drawGraph(wave2Matrix, radial=<UI, no forced default>, position=(0,0,-2)+gestureZ,
              scale=(1,1,1), rotate=gestureRotate, radialRadius=gestureOrManualRadius,
              color=hue2 (alpha = above), lineWidth=<manual>, circpoints=5, polyMode=points,
              blend=(srcAlpha,dstAlpha), blendEnable=true)
}
```

## 10. Parameter table

| Name | Source | Raw range | Default | Mapping | Smoothed? | Effect |
|---|---|---|---|---|---|---|
| Gain (`uiGain`) | Mira "Audio Gain" slider[311] / main `live.slider`[Feedbax.332] | slider native 0..1 (size=2.0) | not visible in listing [?] | `gained = raw * uiGain` via `*~ 1.`[51] right inlet | no | scales mic/test-tone before all analysis and drawing |
| Input select | `gswitch`[56] | 0/1 [?] (`gswitch`'s exact index convention is not established by this listing — see §2) | 0 (mic), from `loadmess 0`[54] | selects `adc~` vs 440 Hz test tone | n/a | picks live mic vs. calibration tone |
| Wave-2 input multiplier | `*~ -0.5`[128] cold inlet ← `gswitch`[126] (signal) **and** `flonum`[98] (manual, no effect once a signal is patched) | n/a | **[corrected] most likely ≈0 (silence)**, not -0.5 — see §3 for the full wiring chain | `gained * wave2Mult` before Wave-2's `biquad~`[206] | no | if the -0.5 reading were taken at face value: negates and halves the signal; **actual default is likely near-silent** [?] |
| Wave-1 EQ freq/Q/gain | `filtergraph~`[8]→`biquad~`[17] | continuous | 46.7 Hz / 0.92 / 1.02 | biquad coefficients | n/a | bass-emphasis EQ feeding wave1 matrix + wavebumpsig + kittybumpsignal |
| Wave-2 EQ freq/Q/gain | `filtergraph~`[205]→`biquad~`[206] | continuous | 60.0 Hz / 2.05 / 0.90 | biquad coefficients, input pre-scaled by the (likely ≈0, see row above) Wave-2 input multiplier | n/a | bass-emphasis EQ feeding wave2 matrix only |
| worldBump EQ freq/Q/gain | `filtergraph~`[279]→`biquad~`[280] | continuous | 144.3 Hz / 1.77 / 0.71 | biquad coefficients | n/a | isolates the band used for worldBump only |
| worldBump slide up/down | `number`[258]/[257] | samples | 2500 / 2500 | `slide~` attack/release | n/a (this *is* the smoother) | shapes worldBump envelope attack=release |
| worldBump scale | `flonum`[247] | free float | **0.05** (overrides typed 0.8) | `snapshot * scale` | no | final worldBump magnitude sent to Z position |
| worldBump Z baseline | `flonum`[Feedbax.obj-67] | free float | **[addition] −0.414**, forced via `loadmess -0.414`[Feedbax.obj-81] | `zBaseline + worldBump` → `pak position`[Feedbax.obj-72] inlet 3 (Z) | no | offsets the videoplane's worldBump-driven Z around roughly its own typed default (−0.4) rather than around 0 |
| wordBumpEn | `r wordBumpEn`[264] / `toggle`[287] | 0/1 | **0 (off)** | gates `ctrlbang` into `snapshot~` | n/a | enables/disables worldBump entirely |
| wavebump enable | `r wavebump`[363] / `toggle`[357] | 0/1 | **0 (off)** | gates `audiobang` into `avg~`[365] | n/a | enables/disables wavebumpsig entirely |
| wavebumpsig gain | `flonum`[359] | free float | **2.2** (typed, no override found) | `*~2.2` before averaging | n/a | scales waveform-2 alpha-pulse envelope |
| wavebumpsig base alpha | `slider`[338] | Mira slider native | not visible [?] | `+0.` left inlet (added to wavebumpsig) | no | floor/offset for waveform-2 alpha |
| kittybump enable | `r kittybump`[26] (webUI) / `toggle`[344] | 0/1 | webUI-controlled [?] | gates `ctrlbang` into `avg~`[11] | n/a | enables/disables kittybumpsignal (webUI meter only) |
| Wave-1 downsample | `loadmess 2`[92]→[100] | int | **2** | `jit.catch~`[3] `@downsample` | n/a | halves effective point density of waveform 1 |
| Wave-2 downsample | `loadmess 512`[97]→[99] | int | **512** [?] | `jit.catch~`[214] `@downsample` via `wave2cmd` bus | n/a | drastically reduces waveform-2 point density if taken at face value |
| Wave-1 mode | typed | 0-3? | 3 | `jit.catch~`[3] `@mode` | n/a | capture-trigger mode, exact semantics unresolved [?] |
| Wave-2 mode | `loadmess 2`[133]→[134]→[142] | 0-3? | **2** (overrides typed 3) | `jit.catch~`[214] `@mode` | n/a | different capture mode than wave 1 |
| Wave-1 radial | `toggle`[241] (forced) | 0/1 | **1** | `"radial 1"` → `jit.gl.graph`[12] | no | circular/polar waveform rendering |
| Wave-1 position | `pak`[84] | free floats | (0, −0.85, 0) | `@position` | no | bottom-of-frame placement |
| Wave-1 scale | `pak`[39] | free floats | (1.5, 1, 0) | `@scale` | no | wide flat line |
| Wave-1 blend_mode | `pak`[112] | Jitter enum | (6,7) | `@blend_mode` | no | standard src-alpha blend |
| Wave-1 line_width/circpoints | forced via toggle43+sel30, **[addition]** also remote-settable via the live `r waveLineFilll`[46] bus (sent by `feedbax.webui`) | int | 12 / 1 | `@line_width`/`@circpoints` | no | solid thick line style |
| **[addition]** Wave-1 lighting_enable | `toggle`[45], forced via `loadmess 1`[185] | 0/1 | **1** (overrides typed `@lighting_enable 0`) | `"lighting_enable 1"` → `jit.gl.graph`[12] | no | lighting is ON by default for waveform 1, not off as a literal reading of the object's typed attribute would suggest |
| Wave-2 blend_mode | `pak`[197] | Jitter enum | (6,8) | `@blend_mode` | no | src-alpha / dst-alpha (non-standard) |
| Wave-2 blend_enable | `pak`[194] (forced) | 0/1 | 1 | `@blend_enable` | no | overrides typed `@blend_enable 0` |
| Wave-2 poly_mode | `loadbang`[166]→msg[165] (forced) | Jitter enum pair | (0,0) | `@poly_mode` | no | point-style rendering |
| Wave-2 circpoints | forced via toggle137+sel138 | int | 5 | `@circpoints` | no | dotted/circle-point line style |
| hue1 alpha (Mira swatch) | `slider`[215] | 0..1 | 0.8 | `"alpha 0.8"` → swatch[232] | no | waveform-1 color alpha (static, not audio) |
| Control smoothing time | `r controlSmoothMs` (from `feedbax.misc`) | ms | not in this file [?] | `mIniCtlSmooth` ramp target time | — | smooths all `p mIniCtlSmooth` gesture outputs (rotation, radius, Z for waveform-2) |

## 11. Dead / vestigial parts

- `kittybumpsignal1`[262] — sent, **no receiver anywhere in the whole project** (confirmed via cross-file bus table). Dead output, duplicate of `worldBump`'s value.
- `soundwave_lighting_enable1`[167] and `waveLineFilll1`[136] — **received in this file with no sender anywhere in the project.** **[corrected]** `waveLineFilll`[46] (no trailing "1") is **not** in this category — the cross-reference confirms `feedbax.webui` *does* send on this bus, so `[obj-46 r waveLineFilll]` is a live, cross-file-driven input, not dead. Only the style-toggle logic downstream of **`waveLineFilll1`** (`sel 0 1`[138], Wave 2's line-style selector) is truly starved of an external sender and can only ever be driven by its local manual toggle[137]; Wave 1's equivalent (`sel 0 1`[30], fed by `waveLineFilll`[46]) can genuinely be remote-controlled from `feedbax.webui`, in addition to its local `toggle`[43].
- `jit.slide`[175] and its attrui knobs `outputmode`[222]/`slide_down`[224]/`slide_up`[225] — fully wired for configuration but **never fed any matrix and its output goes nowhere.** A dead duplicate of the real smoother [208].
- `+~`[286]/`*~1.`[282]/`+~`[285] ahead of the worldBump `biquad~`[280] — both second inlets unconnected, so these are no-op identity stages; `+~`[285]'s output goes nowhere at all. Vestigial mixing point (comment `// in`[288]) apparently meant for a second input that was never patched in.
- `gswitch`[126] + its accompanying `cycle~`[113]/[125]/`line~`[108]/[118] test-tone pair — output feeds `*~ -0.5`[128]'s cold inlet, but `gswitch`[126]'s own "mic" inlet1 is never connected to any signal, so at its default selector position it delivers nothing. **[elevated — this is not merely a self-contained dead duplicate]** because that output lands live on Wave 2's EQ input multiplier (§3), this "delivers nothing" behavior likely propagates into Wave 2's entire signal path being near-silent by default. Flagged [?], see Open Questions.
- `slide 8. 12`[325] (non-tilde, control-rate) fed by `flonum`[319]/[320]/`scale`[322]/[321] — output goes nowhere. Dead control-rate smoother, unclear intended purpose.
- `"gainmode 1"` messages [obj-60]/[198]/[272] — present but never triggered by anything (no loadbang/loadmess); manual-click-only, effectively dead at runtime.
- `msg "poly_mode 2 2"`[234] and `msg "rms"`[252]/`msg "bipolar"`[253] — present as alternates but never triggered; only the sibling messages that *are* wired to a `loadbang` (`poly_mode 0 0`[165], `absolute`[254]) actually fire.
- `toggle`[148] — set to 1 at load (`loadmess 1`[169]) but has **no outgoing connection at all**; purely decorative/dead UI element.
- `number`[249] feeding `average~`[256]'s inlet directly — no predecessor found (pure manual entry field); its effect on `average~` (which normally takes mode symbols or signal, not arbitrary floats) is unclear [?].
- Outlet-0/outlet-1 of `feedbax.sound2` feeding back into the main patch's `live.slider`[332] input (a *signal* wired into a UI object's control inlet) — `live.slider` does not accept a running signal in a meaningful way; likely a non-functional or accidental connection [?].

## 12. Open questions / things the listing cannot tell us

1. **`jit.catch~`'s `@mode` enum semantics** (0-3) are not established by the provided facts or this listing — wave 1 uses mode 3 (typed), wave 2 is forced to mode 2 at load. Without Jitter docs in hand, the exact difference (e.g. "trigger" vs "threshold" vs "continuous overwrite") and how it interacts with `@trigthresh`/`@trigdir` cannot be pinned down precisely; a port should treat both catches as "capture the last `framesize` samples, decimated by `downsample`, and treat trigthresh/trigdir as an oscilloscope-style trigger level/edge" and verify empirically.
2. **Wave-2's `downsample=512` default** looks anomalously large next to wave-1's `downsample=2` (framesize is 1024 for both, so 512 could mean "keep only 2 points" or could mean something entirely different depending on how `jit.catch~` interprets the attribute at values above framesize). Verify against a running Max patch or the Jitter reference before porting; this materially changes what waveform-2 looks like (near-flat/very coarse vs. a normal dense line).
3. **`filtergraph~`'s `setfilter` type code** (`1` in each array, e.g. `[0, 1, 1, 0, 0, freq, Q, gain, ...]`) is not resolved — treated here as "a resonant band" near the stated center frequency; could be lowpass/highpass/bandpass/peaking. Affects the exact spectral shape of all three bump-detector inputs.
4. **Default values for several Mira-side sliders** (`uiGain`'s actual starting position, `slider`[338]'s wavebumpsig base-alpha, waveform-2's `radial` attrui) are not printed in the box attribute dump (attrui/slider saved values weren't captured by the tool) — would need direct inspection of the `.maxpat` JSON's `saved_attribute_attributes`/`parameter_initial` blocks per object to recover exact numbers.
5. **`controlSmoothMs` / `lineSmoothGrain` actual values** are broadcast from `feedbax.misc` (per the cross-reference), not present in this file — needed to know how fast the `mIniCtlSmooth`-wrapped gesture controls (waveform-2 rotation, Z, radius) actually ramp.
6. **Whether `kittybump`/`kittybumpsignal` genuinely has zero effect on rendering** was checked only within this file and the provided cross-reference (`kittybumpsignal` is received solely in `feedbax.webui`); if `feedbax.webui` itself feeds that value back into `shadeCtl` or another render-affecting bus, it would become audio-reactive indirectly — out of scope for this file, worth checking the webui section of this project.
7. **Whether the `hue1`/`hue2` "last writer wins" race** (two swatches per bus) is intentional design (e.g. the second swatch is meant to only ever change alpha, and in practice the user is expected to leave its RGB untouched at the loaded default so the net effect merely tints alpha) or an authoring accident could not be determined from wiring alone.
8. **[added] Whether `*~ -0.5`[128]'s cold inlet actually goes silent at patch load** hinges on exact Max/MSP DSP-compile precedence between a connected signal-rate patch cord (from `gswitch`[126], itself outputting silence by default) and the object's typed literal argument / any control-rate float sent to the same inlet (from `flonum`[98]). This write-up applies the standard documented rule ("a connected signal always wins over a float/typed-arg on the same inlet") to conclude Wave 2's input is likely near-silent by default, but this has **not** been confirmed by opening/running the actual patch — Max's behavior for this specific inlet-sharing pattern should be verified empirically before relying on it for a port. If wrong, Wave 2 instead runs at the literal `-0.5` (negated, half-amplitude) as the original write-up assumed.
9. **[added] `gswitch`'s exact selector-index-to-inlet convention** (does selector value 0 mean "route inlet1" or something else?) is asserted by inference from typical Max UI-switch conventions, not confirmed against Jitter/Max UI object docs or the raw `.maxpat` JSON's `parameter_` blocks for this box. Affects the precise reading of both `gswitch[56]`'s and `gswitch[126]`'s default-selected paths.
10. **[added] The exact intermediate gating/comparator cascade inside `p xypinch`** (roughly ten comparator/`gate` objects between the initial `clip`+`scale` and the final `accum`+rescale, on both the pinch and — to a lesser extent — rotate paths) was not fully traced; see §8. Low priority for a port since these are gesture UI controls unrelated to audio, but flagged for completeness.

### Audit notes (verification pass)

Corrections made against the same source listings the original author used (`feedbax.sound2.maxpat`'s box/connection dump, the `Feedbax.maxpat` dump for the worldBump consumer, and the bus cross-reference (`docs/spec/06-bus-reference.md`) for cross-file bus provenance):

1. **Wave 1 `lighting_enable` default was stated as 0 (typed); it is actually forced to 1 at load** by `toggle`[45] via the same `loadmess 1`[185] that sets `toggle`[20] (`enable`) — the original text conflated the two toggles under the `enable` row without separately correcting the `lighting_enable` row's default.
2. **`*~ -0.5`[128] (Wave 2's input scaler) was described as if "-0.5" were its runtime multiplier.** Its cold inlet is actually signal-driven by the (default-silent) duplicate `gswitch`[126], with a non-functional manual `flonum`[98] float also wired to the same inlet. The typed "-0.5" is very likely never the actual runtime value; Wave 2's default input is most likely near-silent. Flagged [?] pending empirical verification, but corrected throughout §1–§3, §9, §10.
3. **The worldBump→videoplane-Z consumer chain in `Feedbax.maxpat` was stated as "left operand always 0".** It is actually a live, load-forced `flonum`[Feedbax.obj-67] defaulting to **-0.414** (via `loadmess -0.414`[Feedbax.obj-81]), not a literal 0 — corrected in §7a, §9, and §10.
4. **Wave 2's `blend_enable` default was attributed to `toggle`[193] "forced by the same `loadbang`[180]".** In fact `loadbang`[180] bangs `pak blend_enable 1`[194]'s inlet 0 directly (re-emitting the pak's own typed argument); `toggle`[193] has no wired predecessor at all. The resulting default value (1) was correct; the mechanism was not.
5. **`waveLineFilll`[46] was listed as a dead bus "received in this file with no sender anywhere in the project."** Per the bus cross-reference (`docs/spec/06-bus-reference.md`), `feedbax.webui` does send on this bus — only its sibling `waveLineFilll1`[136] (Wave 2's equivalent) is genuinely dead. Corrected in §5 and §11 (Wave 1's line-style toggle is remote-controllable; Wave 2's is not).
6. **`wordBumpEn` was called a "webUI/Mira bus"**, implying cross-file origin like `kittybump`/`soundwave_enable`. Per the bus cross-reference (`docs/spec/06-bus-reference.md`) its only sender (`s wordBumpEn`[obj-331]) is inside `feedbax.sound2` itself, fed by a local Mira-panel toggle — corrected in §7a.
7. **Missed dead stub**: a second `r worldBump`[obj-330] exists inside `feedbax.sound2` with zero outgoing connections — explains why the cross-reference lists `feedbax.sound2` as a "receiver" of `worldBump`, which the original text read as "no other consumer found" without noting this stub. Added to §7a and §11.
8. **Missed side-effect**: `r wordBumpEn`[264] also drives `sel 0`[246] → `msg "0,"`[102] → `s kittybumpsignal1`[262], an additional (also inert) write path to the already-dead `kittybumpsignal1` bus. Added to §7a.
9. **Missed dead object**: `msg "0. 0.786722 0.821229 1."`[obj-72], a fully orphaned duplicate of the `hue2` base-color message[182] with no connections at all. Added to §6.
10. **§4's framesize table row cited `attrui`[172] for both Wave 1 and Wave 2**; it is wired only to Wave 2's `jit.catch~`[214]. Corrected; also added the previously-unmentioned manual mode-`attrui` knobs ([120] Wave 1, [173] Wave 2).
11. **Minor additions, no prior error**: duplicate `slide_up`/`slide_down` `attrui` knobs on `jit.slide`[208] (§4); a live manual gain override `flonum`[96] on the kittybumpsignal chain's `*~1.`[55] (§7c); a `gswitch`[56] selector-range caveat (§10); an unresolved comparator cascade inside `p xypinch` beyond its stated endpoints (§8).

**Residual uncertainties** (see Open Questions §12 items 1–10 for full detail): `jit.catch~`'s `@mode` enum semantics; whether `downsample=512` truly means "coarser than downsample=2" at these values; `filtergraph~`'s exact filter-type code; several Mira-slider startup values not captured by the listing tool; `controlSmoothMs`/`lineSmoothGrain` actual values; whether `kittybumpsignal` has zero *indirect* effect via `feedbax.webui`; the `hue1`/`hue2` dual-swatch race's intentionality; **whether `gswitch`[126]'s silence genuinely propagates through `*~ -0.5`[128] at runtime (the single highest-impact unresolved item in this file for a port)**; `gswitch`'s exact selector convention; and `p xypinch`'s internal gating cascade.
