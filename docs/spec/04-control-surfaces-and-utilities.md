> Part of the Feedbax technical description — see [`README.md`](README.md) for the overview,
> conventions (object-id citations like `[obj-36]`, `[?]` = unverified), and how the listings
> these sections cite were produced (`tools/maxpat2txt.py`). Each section ends with the audit
> notes from its verification pass.

# Control surfaces (iPad/Mira, on-screen UI, Leap Motion) and utilities

> **Correction (2026-08-24, evening):** the webUI faders `slider[2]` BRIGHTNESS, `slider[5]`
> HUE-SHIFT, `slider[8]` ZOOM and `slider[7]` rotate are `size 2, min −1` widgets: the value
> SENT is `internal − 1`, and the number boxes / `parameter_initial` values (1., 1.1, 0.75,
> 0.739) are internal. So the reset burst sets BRIGHTNESS → raw 0.0 and HUE-SHIFT → raw 0.1
> (not out-of-range), and ZOOM 0.75 / rotate 0.739 are raw −0.25 / +0.261 (before rotate's
> `* -1.`), matching the measured startup vector. SATURATION and TRANSPARANCY are `size 1`.

Five small patcher files carry the "performance layer": **feedbax.webui** (the Mira-hosted iPad UI plus a bank of debug/manual sliders), **feedbax.leapgemini** (Ultraleap hand tracking), **feedbax.pathsetup** (portable-path bootstrap), **feedbax.misc** (one global constant broadcaster), and **feedbax.stillsave** (screenshot). All five are called from `Feedbax.maxpat` as argument-less abstractions (`io=0/0`), i.e. they communicate with the rest of the patch **only** through global send/receive (`s`/`r`) buses — there is no patch-cord data path into or out of them from the main patch. Mira (`mira.frame`, `mira.multitouch`, `mira.mt.*`, `mira.motion`) is Cycling '74's iPad-mirroring add-on: it renders a subset of a patcher's UI on an iPad over the network and turns iPad touches into normal Max messages.

## 0. Bus inventory relevant to this section (from the cross-reference)

| bus | sender(s) | receiver(s) | status |
|---|---|---|---|
| `shadeCtl` | feedbax.webui | feedbax.shaderfx, feedbax.webui (dead tap) | **live** |
| `shadeCtlLeap` | feedbax.leapgemini | feedbax.shaderfx | **live** |
| `leap2HandsActive` | feedbax.leapgemini | feedbax.shaderfx | **live** |
| `ctrlbang` | Feedbax (60 Hz clock) | feedbax.leapgemini, feedbax.shaderfx, feedbax.sound2, feedbax.webui | **live** |
| `controlSmoothMs` | Feedbax (UI) | every `mIniCtlSmooth` instance (shaderfx, sound2, webui) | **live** |
| `lineSmoothGrain` | feedbax.misc | every `mIniCtlSmooth` instance | **live** |
| `erasetransparency` | feedbax.webui | Feedbax (main patch) | **live** |
| `scaleInvtoggle` | feedbax.webui | feedbax.shaderfx | **live** |
| `livevid` | feedbax.webui | feedbax.picsvid | **live** |
| `imageMove` | feedbax.webui, feedbax.picsvid | feedbax.picsvid | **live** |
| `movSel` | feedbax.webui, feedbax.picsvid | feedbax.picsvid/p pic | **live** |
| `movsFound` | feedbax.picsvid | feedbax.webui | **live** |
| `kittybump` | feedbax.webui | feedbax.sound2 | **live** |
| `kittybumpsignal` | feedbax.sound2 | feedbax.webui | **live** |
| `soundwave_enable` | feedbax.webui | feedbax.sound2 | **live** |
| `soundwave_enable1` | feedbax.webui | feedbax.sound2 | **live** |
| `soundwave_lighting_enable` | feedbax.webui | feedbax.sound2 | **live** |
| `waveLineFilll` | feedbax.webui | feedbax.sound2 | **live** |
| `hue1` | feedbax.sound2, feedbax.webui | feedbax.sound2 | **live** |
| `savePic` | feedbax.webui | feedbax.stillsave | **live** |
| `gainmain` | feedbax.webui | *none* | **dead** — slider wired to nothing else in the codebase |
| `feedbax_sticker_folder` | feedbax.pathsetup | feedbax.picsvid | **live** |
| `feedbax_as_sticker_folder` | feedbax.pathsetup | feedbax.picsvid | **live** |
| `feedbax_sticker_prefix` | feedbax.pathsetup | *none* | **dead** |
| `uiGain` | feedbax.sound2 | Feedbax (main patch, `live.slider` read-back) | **live**, direction is sound2→UI |

---

## 1. feedbax.webui — the `shadeCtl` vector

### 1.1 Three independent senders to `shadeCtl`

The bus has **three** distinct origins in this file; only one of them is the live performance path.

| sender | trigger | payload | role |
|---|---|---|---|
| `[obj-114] s shadeCtl` | `[obj-88] loadbang` → `[obj-89] msg "0.011905 0.392857 0.755952 -0.354023 -0.5 -0.634044 0.281234 0. 0.71131"` | 9 literal floats | **startup default.** Fires once, ~0 ms after patch load, before any UI widget has produced a real value. |
| `[obj-208] s shadeCtl` | `[obj-216] pack 0. ×9` fed by 9 bare **flonum** boxes `[obj-209..obj-218]` (labelled hue…sat in the patcher itself) | 9 floats, manual entry | **manual/debug panel.** Not wired to any touch surface; a tech could type numbers directly into these flonums (e.g. for testing shaderfx without the iPad). `pack` (not `pak`) only re-emits when its **inlet 0** (hue) changes, so moving bias/scale/etc. alone does not push a new list until hue is touched again. No `parameter_initial` is saved on any of `obj-209..218`, so at load they read 0.0 — this panel is silent/inert unless someone touches it. |
| `[obj-14] s shadeCtl` | `[obj-15] zl.change` ← `[obj-94] pack 0. ×9` | 9 floats, live | **THE live control path** — see 1.2. |

A fourth apparent path — `[obj-121] r shadeCtl` → `[obj-7] gswitch2]:1` → `[obj-6] msg "-0.489224 0.483331 …"` (right/cold inlet, no `$` in the message) — is **vestigial**: it reads the current `shadeCtl` value back into webui but the destination message box has no dollar-sign substitution and no outgoing connection, so the read-back is a dead end. `[obj-23] toggle (varname toggle[1])` selects `gswitch2`'s active branch but has no visible on-canvas label; treat this whole cluster as inert instrumentation. `[obj-11] mira.mt.centroid` (`part of` obj-128, see below) is unrelated to this dead branch.

**Confirmation of the 11-slot layout, webui side:** both live senders (`obj-216`, `obj-94`) pack only **9** elements (indices 0–8: hue, bias, scalebright, xshift, yshift, scale, theta, NC, sat). Slots 9–10 (ancx, ancy) are **never sent by webui** — in `shaderfx`'s `unpack` (11 outlets) those two outlets simply never fire from this source, so ancx/ancy stay at whatever `jit.gl.pix`'s uniform default is. Treat ancx/ancy as **not driven from the iPad** in a port.

### 1.2 The live pack — per-slot source (`[obj-94] pack 0. ×9` → `zl.change` → `s shadeCtl`)

This pack has **two peculiarities** worth carrying into a port:

- **Inlet 0 (hue) is clocked at 60 Hz**, not just on touch. `[obj-13] float` is banged every frame by `r ctrlbang` (60 Hz main clock) and always re-outputs slider `slider[5]`'s *current* value into `pack`'s hot inlet. Since `pack` (not `pak`) only fires the whole list on inlet-0 updates, this means **the entire 9-float vector is re-evaluated every render frame**, regardless of which other slot last moved.
- **`zl.change` dedups** that 60 Hz stream so `s shadeCtl` (and hence the network hop to Mira/shaderfx) only actually fires when the list content differs from the previous frame's — i.e. functionally "push on change," implemented as "poll at 60 Hz, suppress repeats."
- Several slots have **two competing sources** feeding the *same* pack inlet (a manual slider **and** an automatic/device-driven signal). Because `pack` just stores-and-holds per inlet, whichever source fired most recently wins — there is no summing/blending logic. Flagged per-slot below.

| slot | name | source chain | formula (raw→out) | smoothed? | notes |
|---|---|---|---|---|---|
| 0 | hue | `[obj-13] float` (ctrlbang-clocked) ← **slider `slider[5]`** `[obj-17]`, on-screen label "HUE-SHIFT" | pass-through, range −1..1 | no (webui does not smooth; shaderfx's own `mIniCtlSmooth` on `unpack` outlet 0 is out of this section's scope) | re-sent every frame (see above) |
| 1 | bias | **slider `slider[2]`** `[obj-30]`, label "BRIGHTNESS" | pass-through, −1..1 | no | |
| 2 | scalebright | **slider `slider[1]`** `[obj-18]`, label "cont" (short, next to but distinct from the "CONTRAST" slider below) | pass-through, −1..1 | no | |
| 3 | xshift | `[obj-34] unpack]:0` ← `route 1 2 3 4` ← `pack "1 0. 0."` ← **mira touch X** (right-hand mira.multitouch instance `[obj-11]`, via `route touch`→`unpack …clientname`) `[obj-32] scale 0. 1. -1. 1.` | touch-X 0..1 → −1..1 | no | the `pack "1 …"`/`route 1 2 3 4` stage always emits the literal id `1`, so `route` always selects its first branch — this looks like a vestige of a multi-touch-ID router now collapsed to a single always-selected touch |
| 4 | yshift | same chain, `[obj-34 unpack]:1` ← `[obj-33] scale 0. 1. -1. 1.` (touch Y) | touch-Y 0..1 → −1..1 | no | |
| 5 | scale | **two sources**: (a) **slider `slider[8]`** `[obj-27]`, label "ZOOM", pass-through −1..1; (b) `[obj-16] scale 0 -2. -1. 0` fed by device **orientation** (`[obj-35] unpack]:0` ← `route rawaccel orientation accel gravity rotationrate` ← `mira.motion` `[obj-10]`) | (a) ZOOM slider direct; (b) tilt-orientation mapped 0..−2→−1..0, with its own scale-args (min/max) further modulated live by two extra (invisible) flonums `[obj-105]`/`[obj-108]` wired into `scale`'s cold inlets 3/4 | no | last-write-wins between the manual ZOOM slider and iPad tilt |
| 6 | theta | **two sources**: (a) `[obj-98] * -1.` ← **slider `slider[7]`** `[obj-56]`, label "rotate"; (b) `[obj-52] scale -1. 1. 1. -1.` ← device **gravity** vector (`[obj-49] unpack]:1` ← same `route …gravity…`) | (a) rotate slider negated; (b) gravity-Y inverted-mapped −1..1 | no | last-write-wins |
| 7 | NC | **slider `slider[3]`** `[obj-140]`, label "CONTRAST" | pass-through −1..1 | no | |
| 8 | sat | **slider `slider[9]`** `[obj-50]`, label "SATURATION" | pass-through 0..1 (unipolar slider) | no | |

**Mira multitouch objects — gesture flags default OFF.** Two `mira.multitouch` instances exist (`[obj-62]` "left pad", `[obj-11]` "right pad"), each with its own `attrui`-driven gesture-enable flags (`tap_enabled`, `pinch_enabled`, `rotate_enabled`, `swipe_enabled`). **Correction:** these do have a recorded default — it's just stored as a persisted *attribute on the `mira.multitouch` object itself* (`{pinch_enabled=0, rotate_enabled=0, swipe_enabled=0, tap_enabled=0, ...}`, visible in the raw JSON on both `obj-62` and `obj-11`), not on the `attrui` widgets (which have `parameter_enable=0`, i.e. they don't participate in Max's parameter/pattr save system at all — they're just live setters). So **at patch load, tap/pinch/rotate/swipe gesture recognition is OFF on both pads**, on both instances, unless a performer flips the corresponding `attrui` checkbox during the show. This matters for a port: **the entire pinch-zoom and two-finger-rotate mechanism in `p xypinch` (§1.2.1) is inert by default** — only basic touch-position tracking (used for `xshift`/`yshift` and the centroid) works out of the box; pinch and rotate gestures must be explicitly enabled live. The **left** pad (`obj-62`) feeds:
- `[obj-128] mira.mt.centroid` (7 outlets, only 0/1 wired) → centroid X/Y → drives `imageMove` (§1.3), **not** `shadeCtl`.
- `[obj-174] p xypinch` (§1.2.1) → also drives `imageMove` (pinch-zoom, rotate), **not** `shadeCtl`.

The **right** pad (`obj-11`) feeds `[obj-24] route touch` → `unpack …clientname` → the `xshift`/`yshift` chain above (shadeCtl slots 3/4). **So the two iPad touch surfaces are functionally split: left pad = image placement, right pad = shader pan.**

#### 1.2.1 `p xypinch` (subpatcher `#obj-174`) — what it computes

**Correction: the description below replaces the original, which mis-traced this subpatcher's wiring.** Re-tracing the connection list line-by-line shows the "pinch delta → clip → scale → sign-gated accumulator" apparatus that intuitively *should* drive the zoom output is actually a **dead branch that never reaches either outlet**, and the rotate accumulator's claimed reset-on-gesture-end does not exist as wired. Takes the left `mira.multitouch`'s raw stream as its single inlet (`[obj-150]`), outputs 2 values:

- **outlet 0 (pinch → persistent zoom level) — NOT driven by the pinch delta.** `[obj-71] mira.mt.pinch` outlet 1 (the "delta", per the object's plausible but Mira-doc-unverified semantics) is clipped `[obj-129] clip -3. 3.` and fed into `[obj-108] scale -10. 10. -0.2 0.2`. **Correction:** because the input is clipped to ±3 but the `scale` object's own assumed input domain is ±10, the achievable *effective* output only spans roughly **±0.06**, not the full ±0.2 the raw scale args suggest. That scaled value is then split by sign (`[obj-112] < 0.` / `[obj-113] > 0.`) into `[obj-117]`/`[obj-119] gate`, feeding two candidate accumulators `[obj-134]→[obj-125]→[obj-123] accum 0.33` (positive side) and `[obj-133]→…` (negative side). **`[obj-133]`'s control (cold) inlet is never wired anywhere in the file — it is permanently closed, so the negative-delta branch never passes data.** Even the surviving positive-side path dead-ends: `[obj-123]`'s output only feeds `[obj-131] clip -1. 1.` and `[obj-136] <= 1.` (which merely gates `obj-134`'s own control, a self-referential loop) — **`[obj-131]`'s output has no further outgoing connection anywhere in the file.** A separate parallel cluster off `mira.mt.pinch` outlet 2 and `[obj-63] sel 0 1` (`obj-105`/`obj-107`/`obj-138`/`obj-139`/`obj-140`/`obj-143`/`obj-149`) is likewise a dead end — `[obj-149] gate`'s output has no outgoing connection either. **None of this delta/sign/dual-accumulator machinery reaches the subpatcher's outlets.**
  What actually *does* reach outlet 0: `mira.mt.pinch`'s **outlet 0** (not outlet 1) feeds `[obj-189] gate`, whose control comes from `[obj-224] &&` of two conditions — `[obj-190] != 1` (itself testing the result of `[obj-179] < 1.` on that same outlet-0 value) **and** `[obj-221] < 1.01`, which tests the chain's **own previous output** (`[obj-219]`'s scaled result, fed back in). When open, `obj-189` passes the outlet-0 value through `[obj-159] t b f` (bang+float split) into `[obj-161] accum 0.33` (seeded 0.33), then `[obj-219] scale 0. 100. 0. 1. 1.02` (exponential, curve 1.02, 0..100→0..1) to the outlet. **This is a self-referential enable condition** (the gate's own output gates its future input) whose exact runtime behavior is hard to characterize from a static listing — flagged **[?]**, recommend verifying live in Max.
- **outlet 1 (two-finger rotate → twist angle) — no verified reset.** `[obj-95] mira.mt.rotate` outlet 0 feeds `[obj-229] t b f` (bang+float split) into `[obj-227] accum 0.` (a second, independent accumulator, seeded 0), then `[obj-232] scale -360. 360. 360. -360.` (inverted) to the outlet. **Correction:** the original claim that this accumulator is "reset to 0 via `[obj-231] msg "0"` whenever `mira.mt.rotate`'s gesture-state outlet reports 'gesture ended', per `[obj-91] sel 0 1`" does not match the wiring: **`[obj-91]` (fed by `mira.mt.rotate` outlet 2) has no outgoing connection at all, and `[obj-231]` has no incoming connection at all.** The reset message is never triggered. As wired, `obj-227` accumulates monotonically from every `mira.mt.rotate` outlet-0 update for the life of the patch — there is no gesture-end reset.

Both outlets feed `mIniCtlSmooth` instances (`[obj-226]`, `[obj-76]`) before reaching `imageMove` — see §1.3. (Recall from the correction above: none of this fires at all unless a performer has enabled `pinch_enabled`/`rotate_enabled` on the left pad's `attrui` controls, since both defaults are OFF.)

### 1.3 `imageMove` (10-element list: `enable x y 0 zx zy 0 0 0 r`)

Emitted from `[obj-8] pack 0. ×10` → `[obj-44] s imageMove`, **no `zl.change`** on this branch — it is rebroadcast unconditionally every `ctrlbang` (60 Hz) tick (inlet 0 is fed by both the "pic enable" toggle *and* `r ctrlbang` itself, so a bang alone re-fires the whole stored list).

| slot | field | source | notes |
|---|---|---|---|
| 0 | enable | **toggle `toggle[2]`** `[obj-1]`, label "pic enable" | picture/video layer on/off; default explicit `loadmess 0` (`[obj-82]`) — off at load |
| 1 | x | `[obj-80] mIniCtlSmooth` ← `[obj-67] scale 0.1 0.9 -1.7 1.7` ← **left `mira.mt.centroid` outlet 0** | **Correction:** the original table cited outlet **1** here; the connection list shows `[obj-128 mira.mt.centroid]:0 -> [obj-67 ...]:0` — it's outlet **0**. Given that, the original "axis-swapped: touch Y drives the x slot" claim does not hold up either (it was derived from the wrong outlet index) — outlet 0 → the `x` slot reads as the *natural*, non-swapped mapping if `mira.mt.centroid`'s outlet 0 is X (not independently verifiable from this listing — Mira object, no public doc consulted) **[?]** |
| 2 | y | **two sources**, last-write-wins: (a) `[obj-79] mIniCtlSmooth` ← `[obj-64] scale 0. 1. 1 -1.` ← **left `mira.mt.centroid` outlet 1** (see correction above — was mis-cited as outlet 0); (b) `[obj-53] mIniCtlSmooth` ← `[obj-59] scale 0. 1024 -1. 1.` ← `abs()` of `r kittybumpsignal` → `slide` envelope — see kittybump below | no confirmed axis swap; audio kick-bump also lands here |
| 3 | (unused, literal 0) | — | — |
| 4 | zx (zoom X) | **sum**: `[obj-225] f` (← `[obj-226] mIniCtlSmooth` ← xypinch outlet 0, pinch-zoom) fires the pack inlet directly; separately `[obj-145] + 0.` **adds** the manual "pic-size" slider (`slider[12]` `[obj-75]`, via `[obj-84] mIniCtlSmooth`, held as the `+`'s hot/left operand) to the kittybump envelope (fed into `+`'s cold/right inlet) — see kittybump note below. Both `obj-225` and `obj-145` write the *same* pack inlet, so whichever fired last wins between "pinch zoom" and "manual size + kittybump." | |
| 5 | zy (zoom Y) | identical duplicate of slot 4 (`obj-225`/`obj-145` both fan out to inlets 4 **and** 5) | uniform (non-anamorphic) scale |
| 6–8 | (unused, literal 0) | — | — |
| 9 | r (rotate) | `[obj-76] mIniCtlSmooth`, fed by **two** sources: xypinch outlet 1 (two-finger twist) **and** `[obj-233] scale -1. 1. 210 -210` ← manual "pic rotate" slider (`slider[11]` `[obj-74]`) | last-write-wins between gesture-rotate and the manual slider |

**Kittybump (audio-reactive "bump").** `[obj-162] toggle (toggle[5], label "kittieBump™")` → `s kittybump` enables a beat/kick detector inside `feedbax.sound2` (out of scope for this file); its envelope comes back as `r kittybumpsignal` `[obj-169]`. webui takes `abs()` of it, runs it through `[obj-191] slide 22 14` (an **asymmetric** attack/release slew — up-rate from flonum `[obj-196]`, down-rate from flonum `[obj-192]`). **Correction/hedge:** neither flonum has a `parameter_initial` in the JSON, but both declare `minimum=1.0`. Whether a fresh Max flonum with a nonzero `minimum` and no saved value displays `0` at load (out of its own declared range) or is floored to its `minimum` (`1.0`) is not resolvable from a static JSON dump — **[?]**; the original claim of "effectively 0" is not certain. Either way the object-text defaults (`22`, `14`) apply until the flonums are touched, so `slide 22. 14` is the effective attack/release regardless. The slewed value is added on top of the manual pic-size slider (feeding `imageMove` slots 4/5 as described) and also on top of the mira-touch-driven Y placement (slot 2, via `obj-53`). **This is the only audio-reactive / "drift"-adjacent generator found in webui** — there is no `drunk`, `random`, or free-running `metro`-driven LFO anywhere in this file or in leapgemini; all continuous modulation is either user-touch-driven or this one audio-envelope path.

**Device motion (iPad accelerometer/gyro).** `[obj-146] toggle (toggle[8], label "Motion control")` gates `[obj-10] mira.motion` → `route rawaccel orientation accel gravity rotationrate` (`[obj-3]`) through a `gate` (`[obj-141]`). **Correction: this toggle defaults to ON, not off.** `[obj-148] loadmess 1` fires directly into `[obj-146]` at load (`[obj-148 loadmess 1]:0 -> [obj-146 toggle]:0`) — the original doc's "unsaved" claim for this control (§1.4/§7) was wrong. So **iPad-tilt modulation of `shadeCtl` scale/theta is active from patch load**, not something a performer must opt into. When open, `orientation` feeds shadeCtl slot 5 (scale) and `gravity` feeds slot 6 (theta), as documented in §1.2. `rawaccel`, `accel`, and `rotationrate` are routed out by `[obj-3]` but **not wired further downstream in this file** — dead outlets.

### 1.4 Every toggle/dial with bus + default

| control | varname | bus | default | effect |
|---|---|---|---|---|
| pic enable | toggle[2] `obj-1` | `imageMove` slot 0 | explicit `loadmess 0` (`[obj-82]`) — off | show/hide the picture/video layer |
| Video? | toggle[12] `obj-107` | `livevid` | unsaved (no `loadmess` found, true Max default 0/off) | picsvid: show video vs. still image |
| Fill/Line | toggle[4] `obj-93` | `waveLineFilll` | unsaved | sound2 waveform draw mode |
| kittieBump™ | toggle[5] `obj-162` | `kittybump` | unsaved | enable audio kick→zoom-bump feedback loop |
| Circle (label inferred by position) | toggle[6] `obj-153` | `soundwave_enable` | **correction: explicit `loadmess 1` (`[obj-92]`) — ON at load**, not unsaved | sound2 waveform master enable |
| — (label inferred: "Wave Enable") | toggle[13] `obj-133` | `soundwave_enable1` | unsaved (confirmed no `loadmess`) | sound2 waveform secondary enable — **[?]** exact label↔bus pairing for toggle[6]/toggle[13] is inferred from on-canvas (x,y) proximity, not a direct wire-to-comment link; verify in the live patch |
| Wave Lighting | toggle[10] `obj-55` | `soundwave_lighting_enable` | explicit `loadmess 0` (`[obj-144]`) — off | sound2 waveform lit/flat shading |
| Motion control | toggle[8] `obj-146` | (gates local accelerometer chain, not a bus) | **correction: explicit `loadmess 1` (`[obj-148]`) — ON at load**, not unsaved — see §1.3 device-motion note | enable/disable iPad-tilt modulation of scale/theta |
| scaleInv | toggle[9] `obj-166` | `scaleInvtoggle` | unsaved | read by shaderfx (`r scaleInvtoggle`) to flip a `−1/1` "SInvert" sign used in its own zoom math |
| (unlabeled, feeds dead-end gswitch2) | toggle[1] `obj-23` | none live | unsaved | vestigial |
| Capture (button, not toggle) | button[7] `obj-163` | `savePic` | — | fires stillsave's screenshot |
| Reset buttons ×5 | `obj-175/177/178/63/117` | none (drive local msg boxes into 5 manual sliders) | first 3 auto-fire 1.5 s after load via `pipe 1500` on `loadbang` | **Correction: the original slider targets/values were wrong.** Tracing each button's message box to its destination slider: `obj-175`→`msg "1."`→**`obj-30` = slider[2] BRIGHTNESS** (not "rotate"); `obj-177`→`msg "1.1"`→**`obj-17` = slider[5] HUE-SHIFT** (not "pic-size" — and 1.1 is *out of* HUE-SHIFT's own declared −1..1 range, echoing the "pic rotate" out-of-range default noted elsewhere); `obj-178`→`msg "0.5"`→**`obj-50` = slider[9] SATURATION** (not "theta-ish"); `obj-63`→`msg "1."`→`obj-83` = TRANSPARANCY (correct in the original); `obj-117`→`msg "1."`→`obj-27` = slider[8] ZOOM (correct in the original, though note this resets ZOOM to 1.0, not to its own persisted load default of 0.75). So the 5 reset targets are **BRIGHTNESS→1.0, HUE-SHIFT→1.1, SATURATION→0.5, TRANSPARANCY→1.0, ZOOM→1.0** — not "rotate/pic-size/theta-ish/zoom/transparency" as originally stated, and none of them touch sliders 74/75/56 (pic rotate / pic-size / rotate) at all. |
| swatch (color picker) | `swatch` `obj-198` | `hue1` | loaded value `0.910104 0.85734 0. 1.` via `loadbang` | sets sound2's waveform base hue/color (separate from shadeCtl slot 0 "hue") |
| Video select +/− | buttons `obj-110`/`obj-111` | `movSel` (via `incdec` clamped 0..`movsFound`) | 0 | cycles which background video/still picsvid shows. **Clarification:** the clamp ceiling (`obj-25` number box) has a hard-coded compile-time `maximum=53`; `r movsFound` (`obj-70`) → `obj-57` number → `prepend max` (`obj-12`) dynamically overwrites that ceiling live once picsvid reports how many media files it actually found, so 53 is only the pre-runtime default, not a fixed cap. |
| Audio gain slider | `live.slider[1]` `obj-332` (Feedbax main patch) | reads/writes `uiGain` (**sent from sound2**, read by main patch) | whatever sound2 persisted | sets/reflects input gain. **Clarification:** the *read-back* direction (sound2→slider) genuinely goes over the `uiGain` bus, but the *write* direction (slider→sound2, i.e. the performer actually setting the gain) is a **direct patch cord** from `obj-332` into `feedbax.sound2`'s own inlet 0 (`[obj-332 live.slider]:0 -> [obj-150 feedbax.sound2]:0`) — not a global bus at all. A port only needs a bus/callback for the read-back half. |
| erase transparency slider | `slider` (unipolar) `obj-83`, label "TRANSPARANCY" | `erasetransparency` | persisted 1.0 | see main-patch section — drives the render `erase_color` alpha (trails amount) |
| gain slider (dead) | `slider[4]` `obj-26` | `gainmain` | unsaved | **no receiver anywhere in the codebase** |

---

## 2. Buses webui emits — ranges & meaning

| bus | type | range | meaning |
|---|---|---|---|
| `shadeCtl` | 9-float list | mostly −1..1, sat 0..1 | the live shader-parameter vector consumed by shaderfx (see §1.2 table for slot meanings) |
| `erasetransparency` | float | 0..1 (slider unipolar) → remapped in main patch by `scale 0 1. 0.8 1. 3` before use | controls render-erase alpha → feedback-trail length |
| `scaleInvtoggle` | 0/1 | boolean | flips shaderfx's internal `SInvert` sign |
| `livevid` | 0/1 | boolean | picsvid: video vs. still |
| `imageMove` | 10-float list | see §1.3 | picture/video plane transform |
| `movSel` | int | 0..`movsFound` (≤53) | selects which background video/picture file plays |
| `kittybump` | 0/1 | boolean | enables sound2's kick-detector → `kittybumpsignal` loop |
| `soundwave_enable` | 0/1 | boolean | sound2 waveform draw enable |
| `soundwave_enable1` | 0/1 | boolean | sound2 waveform secondary enable (distinct bus, see [?] above) |
| `soundwave_lighting_enable` | 0/1 | boolean | sound2 waveform lighting |
| `waveLineFilll` | 0/1 | boolean | sound2 waveform fill vs. line draw |
| `savePic` | bang | — | triggers stillsave's screenshot |
| `hue1` | 4-float | RGBA-ish, default `0.910104 0.85734 0. 1.` | sound2 waveform color |
| `gainmain` | float | 0..1 | **dead** — no receiver exists anywhere in the codebase; safe to drop in a port |

---

## 3. feedbax.leapgemini — Ultraleap hand tracking → `shadeCtlLeap`

### 3.1 `ultraleap` object — outlet map

`[obj-1] ultraleap` (io=1/10; the Max external wrapping Ultraleap's tracking SDK) is enabled by `[obj-51] toggle` → `msg "active $1"` → its inlet 0 (default ON: `[obj-22] loadmess 1` fires at load). Of its 10 outlets, only 7 are wired:

| outlet | bus sent | content |
|---|---|---|
| 0 | `end_frame` | frame-end marker (dead — no receiver in the codebase) |
| 1 | `left_fingers` | left-hand per-finger data |
| 2 | `right_fingers` | right-hand per-finger data |
| 3 | `left_hand` | left palm position/orientation list |
| 4 | `right_hand` | right palm position/orientation list |
| 5 | `frame_info` | per-frame summary list, `unpack i i i f` → 4 fields |
| 6 | `start_frame` | frame-start marker |
| 7–9 | *(unwired)* | unused in this patch |

`frame_info` element **1** and element **2** (both ints) are hand-presence flags for left/right; `[obj-18] ||` ORs them into `leap2HandsActive` (broadcast **every incoming Leap frame**, not just on change — see §3.3).

### 3.2 Hand data → `shadeCtlLeap` slot mapping

The pack that becomes `shadeCtlLeap` is `[obj-94] pack 0. 0. 0. 0. 0. 0. 0. 0. 1.` (note the **hard-coded literal `1.` in slot 8**, i.e. **`sat` is never modulated by Leap — always 1.0**), gated through `[obj-11] gate` (opened either by manual `[obj-6] toggle`, default on via `loadmess 1` `obj-33`, **or** automatically by `[obj-7] ||`). **Correction:** the original text called this "right-hand presence," but `[obj-7]`'s two inputs are `frame_info` elements 1 and 2 (`[obj-34 unpack i i i f]:1 -> [obj-7 ||]:0` and `[obj-34 unpack i i i f]:2 -> [obj-7 ||]:1`, plus a redundant re-trigger bang from `[obj-9] t b` on the same element-1 source into inlet 0) — **the exact same two hand-presence flags that feed `[obj-18] ||` for `leap2HandsActive`**. So `obj-7` computes OR(left-present, right-present), i.e. *either hand*, not right-hand specifically. Then `[obj-31] zl.change` → `s shadeCtlLeap`.

| slot | name | source chain | formula | notes |
|---|---|---|---|---|
| 0 | hue | `[obj-19] float` (ctrlbang-clocked, mirrors webui's clocking trick) ← `[obj-86] scale -20 0. -1. 1.` ← **left hand X** (`[obj-88] unpack]:0` ← `[obj-85] vexpr $f1*0.1` ← `[obj-38] gate` ← `[obj-114] zl slice 3]:0` ← `[obj-113] zl slice 1]:1` ← `left_hand`) | left-palm X, ×0.1, mapped −20..0→−1..1 | re-sent every frame like webui's hue. **Correction:** the original chain skipped an intermediate step — `obj-113` ("zl slice 1") strips the first element of `left_hand`, and its outlet-1 remainder is further sliced by **`[obj-114] zl slice 3`** before the X/Y/Z triple reaches `obj-38`'s gate. (`obj-38` passes the whole 3-element list at once; `[obj-85] vexpr $f1*0.1` applies element-wise across the list — this is standard `vexpr` list-broadcast behavior, not a scalar-only op — landing X/Y/Z into `[obj-88] unpack 0. 0. 0.` for the three scale objects below.) |
| 1 | bias | `[obj-87] scale 14 50. -1. 1.` ← **left hand Y** (same unpack, outlet 1) | left-palm Y, ×0.1, mapped 14..50→−1..1 | same corrected chain as slot 0 |
| 2 | scalebright | `[obj-84] scale -15 15. -1. 1.` ← **left hand Z** (same unpack, outlet 2) | left-palm Z, ×0.1, mapped −15..15→−1..1 | same corrected chain as slot 0 |
| 3 | xshift | `[obj-76] scale -20. 35. 1. -1.` ← **right hand X** (`[obj-92] unpack]:0` ← `[obj-93] vexpr $f1*0.1` ← `[obj-44] gate` ← `[obj-119] zl slice 3]:0` ← `right_hand`) | right-palm X, ×0.1, mapped −20..35→**1..−1 (inverted)** | gate opened by right-hand "grab" (`>0.8`, `obj-13`) **or** manual `toggle` `obj-46` (default on) |
| 4 | yshift | `[obj-83] scale 20. 50. 1. -1.` ← **right hand Y** (same unpack, outlet 1) | right-palm Y, ×0.1, mapped 20..50→**1..−1 (inverted)** | |
| 5 | scale | `[obj-4] scale -20 20. -1. 1.` ← **right hand Z** (same unpack, outlet 2) | right-palm Z, ×0.1, mapped −20..20→−1..1 | |
| 6 | theta | `[obj-124] scale -1. 1. 1. -1.` → `[obj-75] unpack]:0` ← `[obj-45] gate` ← `[obj-123] unpack 0. 0. 0.]:2` ← `[obj-121] zl slice 3]:0` ← `[obj-119] zl slice 3]:1` ← `right_hand` (a *third* component sliced out further down the same `right_hand` list used for xshift/yshift/scale) | scaled −1..1 → **1..−1 (inverted)** | gated by right-hand grab strength `>0.8` (`obj-13`) — **[?]** semantic meaning of this third right_hand component (possibly wrist/orientation roll) is not recoverable from the listing |
| 7 | NC | `[obj-75] unpack]:1` — **correction: this outlet never fires** | **dead — stuck at the pack's own default arg (`0.`)** | `[obj-124]`'s `scale` object outputs a single scalar float, not a 3-element list. Feeding a scalar into a 3-outlet `unpack` is standard Max behavior: only the number of outlets matching the received list length fire (here, just outlet 0 — a 1-element "list"). Outlets 1 and 2 of `obj-75` therefore **never fire from this source**, so shadeCtlLeap slot 7 (NC) is never updated by Leap and stays at whatever the pack's literal default (`0.`) provides — the original doc's "duplicate tap of the same gated value" claim is incorrect; it should read "dead." |
| 8 | sat | *(hard literal `1.` in the pack's own argument list — never wired)* | constant 1.0 | Leap never touches saturation |

**Left/right-hand "grab" gating.** Both hands have an independent grab-strength gate (right: `obj-8 zl nth 5` → `obj-13 > 0.8`; left: `obj-37 zl nth 8` → `obj-36 > 0.8`), each also override-able by a manual toggle (`obj-41` left, `obj-46` right, both default ON via `loadmess 1`). A `loadmess -0.1` (`obj-5`) feeds a flonum (`obj-60`) into both `>0.8` thresholds' cold inlet as a "grab disable hack" (per the patch's own comment `[obj-53] "// -.1 grab disable hack"`). **Correction — this is resolvable, not fully uncertain:** setting the comparison threshold to `-0.1` means the test effectively becomes `> -0.1`; since a grab-strength value is a non-negative confidence/strength measure, essentially any live reading will satisfy it, making both grab gates **near-permanent no-ops (open almost all the time)** regardless of actual hand posture — "disable" here means "disable the gating effect by making the threshold trivial," not literally shutting the gate. A separate `[obj-52] msg "0"` also targets `obj-13`'s cold inlet but **has no incoming connection anywhere in the file** — it's a manual-click-only debug control (would reset the right-hand threshold to a stricter `0` if clicked in the live patcher) and plays no role in normal operation. Given the near-always-open grab gates, the manual toggles (`obj-41`/`obj-46`, both default ON) are largely redundant with the grab test in practice — comment `[obj-43] "// removed toggles"` suggests this was mid-refactor when the file was last saved.

**Finger data** (`left_fingers`/`right_fingers`, ultraleap outlets 1/2) are broadcast but **only consumed by `p fill_coll`** (§3.4) — not used in any `shadeCtlLeap` slot.

### 3.3 `leap2HandsActive` and the "2 s → fall back to iPad" logic

`leap2HandsActive` itself is straightforward: `[obj-18] ||` of `frame_info`'s two hand-presence ints, re-sent on **every** incoming Leap frame (i.e. at Leap's own frame rate, not gated on the value actually changing).

The *consumer* of this bus — the timer that reverts control to the iPad after 2 seconds — lives in **feedbax.shaderfx**, not in leapgemini, but is documented here since the task calls for it:

```
[shaderfx obj-57] r leap2HandsActive → [obj-68] t b  (discards the 0/1 value, bangs unconditionally on ANY Leap frame)
[shaderfx obj-68] → [obj-59] timer  (left/report inlet)
[shaderfx obj-77] r ctrlbang (60 Hz) → [obj-59] timer  (right/reset inlet)
[obj-59] timer → [obj-78] < 2000 → [obj-80] change → [obj-82] toggle → [obj-30] gswitch (selector: 0=r shadeCtl/iPad, else r shadeCtlLeap)
```
Comment on the canvas at `[shaderfx obj-84]`: *"Leap is primary control, reverts to iPad after 2 seconds of no hands."*

**[?] This wiring is hard to fully reconcile from a static read.** Max's `timer` object reports elapsed time (and restarts) on a bang to its **left** inlet, and silently resets-to-zero (no output) on a bang to its **right** inlet. Here the *Leap-frame* bang is on the **left** (report) inlet and the 60 Hz *ctrlbang* is on the **right** (reset) inlet — meaning the timer is being zeroed roughly every 16.7 ms by the render clock, so a `< 2000` test evaluated immediately after would almost always read "true" regardless of Leap's actual state. The functional intent (per the comment, and per the overall gswitch/toggle/change shape, which is exactly the idiom you'd use for a debounced watchdog) is clearly "if no Leap-frame-derived bang has arrived in >2 s, flip to iPad" — but that requires the *query* to happen on the 60 Hz clock and the *reset* to happen on the Leap-frame bang, i.e. inlets swapped from how they read here. Either (a) the connection reading above has the inlet roles backwards for this Max version, or (b) there is a scheduling/precedence subtlety in Max's message queue that a static box/line dump cannot show. **Recommend verifying this empirically in Max (or just reimplementing the obviously-intended watchdog: reset a "last-Leap-frame" timestamp on every `leap2HandsActive`/hand-presence event; each render tick, if `now - lastLeapFrame > 2000 ms`, select iPad control; otherwise select Leap)** rather than porting the literal wiring.

Downstream, `gswitch` (`obj-30`, io=3/1) is fed `r shadeCtl` at inlet 1 and `r shadeCtlLeap` at inlet 2, selector at inlet 0 from the toggle above — i.e. it is a hard cut between the two 9(-11)-slot vectors, not a crossfade.

### 3.4 `p fill_coll` — diagnostic data logger (vestigial)

Subpatcher `obj-117`, called with `io=0/0` (**no inlets/outlets at all** — a pure side-effect sink; nothing downstream can ever read its state). It receives `left_fingers`, `right_fingers`, `left_hand`, `right_hand` and stores each into its own `coll` object (`fingers_L`, `fingers_R`, `hands`), plus a fourth `coll frame` fed by a bus called `leap_frame` — **which has no sender anywhere in the codebase** (dead receive). All four `coll`s are cleared (`msg "clear"`) on every `start_frame`. Since nothing ever reads these `coll`s back out, and one of the four inputs is permanently silent, **this whole subpatcher is inert instrumentation/scaffolding — safe to omit from a port.**

---

## 4. feedbax.pathsetup — portable project root

```
[obj-1] loadbang → [obj-2] msg "path" → [obj-3] thispatcher
```
`thispatcher` (a Max object that introspects the patcher it lives in) replies to the message `"path"` with `"path <folder-containing-this-.maxpat>"`. Since `feedbax.pathsetup.maxpat` lives in the project's `patches/` folder, this resolves at load time to `<project>/patches/`.

```
→ [obj-4] route path → [obj-5] regexp (.+[\/]).+[\/]$ @substitute %1 → [obj-6] value feedbax_root
```
The regex's greedy first group `(.+[\/])` consumes everything up to and including the *penultimate* path separator, so applying it to `.../feedbax/patches/` strips exactly one trailing directory level, yielding `.../feedbax/` — the **project root**, one level above `patches/`. This value fans out in parallel, straight from `[obj-5]`'s single outlet, to **four** destinations at once: a Max `value` object named `feedbax_root` (a shared-variable mechanism — per the cross-reference, nothing else in the codebase currently reads it via its own `value feedbax_root`, so this copy is write-only/unused) **and** the three `sprintf`s below, which read the same regex output directly rather than looking it up through the `value` object. **Clarification (not present in the original text):** a port does not need to reimplement any named-variable lookup here — it's a plain fan-out of one computed string to four sinks, one of which (the `value` object) is dead.

```
[obj-5] → [obj-7] sprintf symout folder %sinput/transparent-background/ → [obj-8] send feedbax_sticker_folder
[obj-5] → [obj-9] sprintf symout folder AS %sinput/transparent-background/ → [obj-10] send feedbax_as_sticker_folder
[obj-5] → [obj-11] sprintf symout prefix %sinput/transparent-background/ → [obj-12] send feedbax_sticker_prefix
```
Each `sprintf` substitutes `feedbax_root` into `%s` to build `<root>input/transparent-background/` (root already ends in `/`), prefixed with a literal selector word (`folder`, `folder AS`, or `prefix`) that becomes the first token of the outgoing message — almost certainly a message-style command consumed by a `umenu`/file-browsing object in `feedbax.picsvid` (e.g. `"folder <path>"` to set a browse directory). `feedbax_sticker_folder` and `feedbax_as_sticker_folder` **are** received in feedbax.picsvid; `feedbax_sticker_prefix` **has no receiver anywhere** — dead send. **[?]** The purpose of the second, near-duplicate "AS" variant (bus name `feedbax_as_sticker_folder`) is not recoverable from this file alone — likely an alternate/secondary sticker asset folder, but the literal token `"AS"` in the sprintf format string is not otherwise explained.

**Portability note for a port:** only this file computes and exposes `feedbax_root`. `feedbax.stillsave` does **not** consume it (see §6) — its output path is a bare relative string, so screenshots land wherever the process's current working directory happens to be, independent of the resolved project root.

---

## 5. feedbax.misc — `lineSmoothGrain` broadcaster

```
[obj-54] loadmess 4 → [obj-63] s lineSmoothGrain     (fires at load: DEFAULT = 4 ms)
[obj-101] msg "4"  ↘
[obj-102] msg "6"  →  [obj-63] s lineSmoothGrain      (clickable message boxes, no wired trigger UI — meant to be clicked directly in the patcher)
[obj-105] msg "8"  ↗
[obj-2]   msg "12" ↗
```
`lineSmoothGrain` sets the **step granularity** (in ms) of the `line` object inside every `mIniCtlSmooth` instance across the codebase (shaderfx ×2 copies, sound2, webui — ~26 instances per the earlier established count) — i.e. how often the ramp recomputes, as distinct from `controlSmoothMs` which sets its total ramp **duration**. Default 4 ms; selectable presets 4/6/8/12 ms exist as bare clickable message boxes with no wired button — this file is effectively "click one of these numbers directly in Max" live-performance UI, not a polished control.

Separately, this file also defines a `hidecursor`/`showcursor` pair (`[obj-100] sel 0 1` → `[obj-98]`/`[obj-99]` `msg ";max hidecursor"`/`";max showcursor"`) — but **`obj-100` has no incoming connection anywhere in this file**, and the abstraction itself is called with `io=0/0` from the main patch (no inlets exposed), so this selector can never fire. **Dead code as shipped** — omit from a port, or reimplement cursor-hide against the fullscreen toggle if that was the evident intent.

---

## 6. feedbax.stillsave — screenshot mechanics

```
[obj-1] r savePic → [obj-16] button → [obj-6] msg "time, date" → [obj-5] date
     → [obj-13] join → [obj-12] tosymbol @separator -
     → [obj-14] combine output/ feedbaxStill date .jpg @triggers 2
     → [obj-8] msg "screencapture -t png -D 2 $1"
     → [obj-4] shell
```
- `date` outputs the current date/time as two lists; `join` concatenates them, `tosymbol @separator -` renders the joined tokens as a single dash-separated symbol (e.g. `6-20-2025-16-51-42`).
- `combine` (a Max string-templating object, `@triggers 2` = fire once 2 of its inlets have received input) builds the literal path `output/feedbaxStill<date-string>.jpg`, e.g. `output/feedbaxStill6-20-2025-16-51-42.jpg`. **Addition:** `combine`'s inlet 2 is fed live by `[obj-12] tosymbol`'s output (the real date string) on every capture, but its inlet 1 is fed only by `[obj-7] msg "output/1-7-2024-6-29-13.jpg"` — a stale example value with **no incoming connection of its own anywhere in the file** (dangling, manual-click-only). Whether `combine`'s `@triggers 2` threshold is satisfied by its own instantiation-time argument values (making the single live inlet-2 update sufficient to fire) is a Max-runtime detail not resolvable from this static listing — see Open Questions. Two further "frozen example" message boxes downstream (`[obj-17]`, `[obj-3]`, both showing a specific stale timestamped path/command) are dead ends with no outgoing wires — harmless leftover documentation, not part of the live chain.
- That path is substituted (`$1`) into the literal shell command **`screencapture -t png -D 2 <path>`** and handed to Max's `shell` object, which spawns it as an actual macOS process. `shell`'s two outlets go only to `print`/`print 1` — console debug logging, no further use in-patch.
- **This is macOS's own `screencapture` CLI**, not `jit.gl.render`'s internal capture-to-texture/file mechanism — the screenshot is a whole-screen (or whole-display) grab of whatever is on screen at the moment, not a clean render-target dump.
- **`-t png` vs. `.jpg` filename mismatch**: the command forces PNG encoding via `-t png` while the target path ends in `.jpg` — the resulting file will contain PNG-format data with a `.jpg` extension. Worth flagging explicitly for anyone reproducing this feature; a correct port should just pick one format consistently.
- **`-D 2`** hard-codes capturing **display index 2** (macOS's 1-indexed enumeration) — i.e. whichever physical monitor is the *second* one in the current OS display ordering, presumably the projector/big-screen output rather than the control laptop's own screen in Sean's usual rig. This is an environment-specific assumption baked into the patch, not derived from any resolution/window bus — a port needs its own explicit "which output to capture" configuration.
- **Path is not routed through `feedbax_root`.** `output/…` is a bare relative path; it resolves against the Max process's CWD at the moment `shell` runs, independent of §4's project-root resolution.
- Trigger is single-shot, only from the `savePic` bus (webui's capture button `[obj-163]`) — no interval/auto-repeat.

---

## 7. Every user-facing control (summary table)

Legend: **Perf** = continuous, played live during a show; **Setup** = a one-time/rare toggle or default Sean would "set and forget."

| label | widget | bus / shadeCtl slot | raw range | default | smoothed? | effect | kind |
|---|---|---|---|---|---|---|---|
| HUE-SHIFT | slider `slider[5]` | shadeCtl[0] hue | −1..1 | 0 (no persisted init) | no (shaderfx side may smooth) | shifts overall hue | Perf |
| BRIGHTNESS | slider `slider[2]` | shadeCtl[1] bias | −1..1 | 0 | no | brightness/bias offset | Perf |
| "cont" | slider `slider[1]` | shadeCtl[2] scalebright | −1..1 | 0 | no | scale-brightness param | Perf |
| Right-pad touch X/Y | mira.multitouch `obj-11` | shadeCtl[3]/[4] xshift/yshift | touch 0..1→−1..1 | n/a | no | pans the shader field | Perf |
| ZOOM | slider `slider[8]` | shadeCtl[5] scale (shared w/ tilt) | −1..1 | 0.75 (persisted) | no | zoom | Perf |
| iPad tilt (orientation) | `mira.motion`, gated by "Motion control" toggle | shadeCtl[5] scale (shared w/ ZOOM slider) | accel-derived | **ON by default** (`loadmess 1`, `obj-148` — corrected, see §1.3) | no | tilt-driven zoom | Perf |
| "rotate" | slider `slider[7]` | shadeCtl[6] theta (shared w/ gravity) | −1..1 | 0.739 (persisted) | no | rotation angle | Perf |
| iPad tilt (gravity) | `mira.motion`, gated by "Motion control" | shadeCtl[6] theta (shared w/ rotate slider) | accel-derived | **ON by default** (`loadmess 1`, `obj-148` — corrected, see §1.3) | no | tilt-driven rotation | Perf |
| CONTRAST | slider `slider[3]` | shadeCtl[7] NC | −1..1 | 0 | no | shader "NC" param | Perf |
| SATURATION | slider `slider[9]` | shadeCtl[8] sat | 0..1 | 0 | no | saturation | Perf |
| pic enable | toggle `toggle[2]` | imageMove[0] | 0/1 | off | — | show/hide picture layer | Setup |
| Left-pad touch centroid | mira.mt.centroid `obj-128` | imageMove[1]/[2] x/y | 0..1→−1..1/1..−1 | n/a | mIniCtlSmooth | position picture/video | Perf |
| pinch (left pad, 2-finger) | `p xypinch` outlet 0 | imageMove[4]/[5] zx/zy | accumulated, exp curve | 0.33 baseline | mIniCtlSmooth | zoom picture/video | Perf |
| pic -size | slider `slider[12]` | imageMove[4]/[5] (added to kittybump) | −1..1 | 0.747 (persisted) | mIniCtlSmooth | base picture zoom | Perf/Setup hybrid |
| kittieBump™ enable | toggle `toggle[5]` | `kittybump` → sound2, envelope back via `kittybumpsignal` → imageMove[2],[4],[5] | 0/1 | off | slide 22/14 (attack/release) | audio-reactive picture "bump" | Setup (enable) + Perf (audible effect) |
| rotate (2-finger twist, left pad) | `p xypinch` outlet 1 | imageMove[9] r | accumulated degrees, −360..360 | 0 | mIniCtlSmooth | rotate picture/video | Perf |
| pic rotate | slider `slider[11]` | imageMove[9] r (shared) | −1..1 mapped ±210 | −360 (persisted, **[?]** out-of-range value) | mIniCtlSmooth | rotate picture/video | Perf/Setup hybrid |
| TRANSPARANCY | slider `slider` (unipolar) | `erasetransparency` | 0..1 | 1.0 (persisted) | no (main patch remaps via `scale`) | feedback trail length | Perf |
| Video? | toggle `toggle[12]` | `livevid` | 0/1 | off | — | picture vs. video source | Setup |
| video select +/− | buttons | `movSel` via incdec | 0..`movsFound` | 0 | — | choose bg video/picture | Setup |
| Wave Enable/Circle (2 toggles, exact label pairing [?]) | toggles `toggle[6]`/`toggle[13]` | `soundwave_enable`/`soundwave_enable1` | 0/1 | **corrected: `toggle[6]`/`soundwave_enable` = ON by default (`loadmess 1`, `obj-92`); `toggle[13]`/`soundwave_enable1` = off (unsaved)** | — | waveform draw on/off | Setup |
| Wave Lighting | toggle `toggle[10]` | `soundwave_lighting_enable` | 0/1 | off | — | waveform lit shading | Setup |
| Fill/Line | toggle `toggle[4]` | `waveLineFilll` | 0/1 | off | — | waveform draw style | Setup |
| swatch color picker | `swatch` | `hue1` | RGBA-ish | `0.910104 0.85734 0. 1.` (loaded) | — | waveform base color | Setup |
| scaleInv | toggle `toggle[9]` | `scaleInvtoggle` | 0/1 | off | — | flips shaderfx `SInvert` sign | Setup |
| Capture | button | `savePic` | bang | — | — | take a screenshot | Setup (per-shot) |
| gain slider (dead) | slider `slider[4]` | `gainmain` | 0..1 | — | — | **no effect anywhere** | dead |
| Audio gain | `live.slider[1]` (main patch) | `uiGain` (read from sound2) | sound2-defined | sound2-persisted | — | input gain | Setup |
| Leap toggle (per-hand enable) | toggles `obj-41`/`obj-46` (leapgemini) | gates the grab-threshold path per hand | 0/1 | on (`loadmess 1`) | — | manual grab-gate override | Setup |
| Leap master active | toggle `obj-51` (leapgemini) | `active $1` → `ultraleap` | 0/1 | on (`loadmess 1`) | — | enable/disable Ultraleap tracking | Setup |
| Left hand X/Y/Z | Ultraleap palm position | shadeCtlLeap[0]/[1]/[2] hue/bias/scalebright | see §3.2 formulas | n/a | no (leapgemini side) | performs hue/brightness/scalebright | Perf |
| Right hand X/Y/Z | Ultraleap palm position | shadeCtlLeap[3]/[4]/[5] xshift/yshift/scale | see §3.2 formulas, inverted on x/y | n/a | no | performs pan/zoom | Perf |
| Right-hand grab | Ultraleap grab strength `>0.8` | shadeCtlLeap[6] theta only (**corrected: slot 7/NC is dead, never fires — see §3.2**) | n/a | n/a | no | performs rotation-ish param on theta only | Perf |
| — | — | shadeCtlLeap[8] sat | constant | **1.0 always** | — | Leap never modulates saturation | fixed |
| FPS preset (**corrected: 5 equally-wired boxes — 30/60/90/100/120, no "orphan"**) | bare message boxes (main patch) | `FPSconfig` → metro interval | 30/60/90/100/120 | **60** (`loadmess 60`, `obj-97`) | — | render tick rate | Setup |
| controlSmoothMs preset (0/10/20/25/50/75/100/200/400/800/2000/8000) | bare message boxes (main patch) | `controlSmoothMs` | as listed | **100** (`loadmess 100`) | — | ramp duration for every mIniCtlSmooth | Setup |
| lineSmoothGrain preset (4/6/8/12) | bare message boxes (feedbax.misc) | `lineSmoothGrain` | as listed | **4** (`loadmess 4`) | — | ramp step granularity for every mIniCtlSmooth | Setup |
| Resolution presets (**corrected: 15 `dim W H` boxes wired to `s resolution`, spanning 14 distinct resolutions — `5120×1440` is duplicated across two separate boxes, `obj-135`/`obj-163`**) | bare message boxes (main patch) | `resolution` → `fst` texture dims, `jit.window` size, aspect-ratio recompute | 1024×768 .. 8192×8192 | none auto-fired at load — window opens at whatever `jit.window`'s file-saved size is | — | sets render resolution, recomputes videoplane x-scale for aspect. **Addition:** a 16th, out-of-band `dim 5120 1440` message box (`obj-123`) is wired directly into the `dst` feedback texture's dimension and (via `obj-160`→`obj-137 "size 5120 1440"`) straight into `jit.window`'s size — bypassing the `resolution` bus entirely. It has no incoming trigger of its own in this file (dangling/manual-click only). | Setup |

---

## 8. Per-frame control-update pseudocode (for a port)

```
// Runs once per render tick (default 60 Hz, configurable 30/60/90/120 via FPSconfig)
on ctrlbang():
    // --- webui: live shadeCtl (9 of 11 slots; ancx/ancy never driven from iPad) ---
    shadeCtl.hue          = uiHueSlider                          // re-read every tick
    shadeCtl.bias          = uiBrightnessSlider
    shadeCtl.scalebright    = uiContSlider
    shadeCtl.xshift, .yshift = rightPadTouch.xy() * 2 - 1          // 0..1 -> -1..1, if touching
    shadeCtl.scale          = lastWrite(uiZoomSlider, tiltOrientation)   // whichever moved most recently; tilt path is ON by default (motionEnabled defaults true)
    shadeCtl.theta          = lastWrite(-uiRotateSlider, tiltGravityY)   // tilt path ON by default
    shadeCtl.NC             = uiContrastSlider
    shadeCtl.sat            = uiSaturationSlider
    if shadeCtl != prevShadeCtl:            // zl.change dedup
        send("shadeCtl", shadeCtl)
        prevShadeCtl = shadeCtl

    // --- webui: imageMove (unconditional every tick, no dedup) ---
    // NOTE: pinch-zoom (xypinchZoomAccumulator) and two-finger-rotate (xypinchRotateAccumulator)
    // below are only live if a performer has enabled pinch_enabled/rotate_enabled on the left
    // mira.multitouch pad — both default OFF (see corrected §1.2.1/§1.2). As wired in the source
    // patch, the pinch-delta-driven accumulator is additionally a dead branch that never reaches
    // this output at all (see §1.2.1) — reimplement the *intent* (persistent pinch-to-zoom,
    // continuous two-finger rotate with NO gesture-end reset) rather than the literal wiring.
    imageMove.enable = picEnableToggle   // default OFF (explicit loadmess 0)
    imageMove.x, .y  = lastWrite(leftPadCentroid.swappedXY(), kittybumpEnvelope on .y)
    zoom = lastWrite(xypinchZoomAccumulator, uiPicSizeSlider + kittybumpEnvelope)
    imageMove.zx = imageMove.zy = zoom
    imageMove.r  = lastWrite(xypinchRotateAccumulator, uiPicRotateSlider * 210)
    send("imageMove", imageMove)             // every tick, always

    // --- leapgemini: shadeCtlLeap (9 slots; sat pinned to 1.0) ---
    shadeCtlLeap.hue         = leftHand.x * 0.1 mapped[-20,0 -> -1,1]     // re-read every tick
    shadeCtlLeap.bias        = leftHand.y * 0.1 mapped[14,50 -> -1,1]
    shadeCtlLeap.scalebright = leftHand.z * 0.1 mapped[-15,15 -> -1,1]
    if leftHand.grabEnabled():
        pass  // grab-gated left-hand data already folded into hue/bias/scalebright above
    if rightHand.grabEnabled():
        shadeCtlLeap.xshift = rightHand.x * 0.1 mapped[-20,35 -> 1,-1]   // inverted
        shadeCtlLeap.yshift = rightHand.y * 0.1 mapped[20,50 -> 1,-1]    // inverted
        shadeCtlLeap.scale  = rightHand.z * 0.1 mapped[-20,20 -> -1,1]
    if rightHand.grabStrength > -0.1:   // "grab disable hack" threshold — almost always true in practice
        shadeCtlLeap.theta = gatedGrabValue mapped[-1,1 -> 1,-1]
        // shadeCtlLeap.NC is NOT set here: as wired, the unpack feeding NC only ever receives a
        // scalar (not a 3-list), so its outlet never fires. NC stays at the pack's default (0.)
        // for the entire life of the patch when Leap is active. Reimplement as "NC untouched by Leap."
    shadeCtlLeap.sat = 1.0
    handsPresent = leftHand.present OR rightHand.present
    if handsPresent or manualLeapToggle:
        if shadeCtlLeap != prevShadeCtlLeap:
            send("shadeCtlLeap", shadeCtlLeap)
            prevShadeCtlLeap = shadeCtlLeap
    send("leap2HandsActive", handsPresent)     // every incoming Leap frame

    // --- shaderfx: which vector wins (see §3.3 caveat on exact Max wiring) ---
    lastLeapFrameTime = handsPresent ? now() : lastLeapFrameTime
    useLeap = (now() - lastLeapFrameTime) < 2000
    activeVector = useLeap ? shadeCtlLeap : shadeCtl
```

---

## Open questions / things the listing cannot tell us

1. **shaderfx's 2-second Leap→iPad fallback timer wiring** (`obj-57/68/59/77/78/80/82/30`) reads, as literally connected, like it would almost always evaluate "true" because the 60 Hz `ctrlbang` resets the `timer` object far more often than any real hand-absence period could accumulate. The evident *intent* (stated in the patch's own comment) is a watchdog that reverts to iPad after 2 s without a Leap frame; whether Max's actual runtime message-priority/scheduling resolves this differently than a static box/line dump suggests is not verifiable without opening the patch and testing. **Recommend reimplementing the obviously-intended watchdog logic (§8 pseudocode) rather than porting the literal wiring.**
2. **`toggle[6]` vs `toggle[13]` (`soundwave_enable` vs `soundwave_enable1`) label assignment** ("Circle" vs "Wave Enable") is inferred from on-canvas (x,y) proximity of comment boxes to toggle boxes, not from any wire — the text listing gives no direct link between a `comment` box and its neighboring control. Worth eyeballing the actual .maxpat in Max/a patcher viewer to confirm.
3. **`feedbax_as_sticker_folder` / the literal `"AS"` token** in pathsetup's second `sprintf` is unexplained by anything in this file; its consumer in `feedbax.picsvid` may clarify but is out of this section's scope.
4. ~~**shadeCtlLeap slots 6/7 (theta, NC)**~~ **Resolved in this revision** (§3.2): `obj-75`'s unpack is fed a scalar, not a list, so by standard Max `unpack` behavior only outlet 0 fires — slot 6 (theta) is live, slot 7 (NC) is dead (stuck at 0). The specific *meaning* of the underlying `right_hand` sub-element that drives theta (obj-121/obj-123's third component) is still not recoverable from the listing — flagged **[?]** in §3.2.
5. ~~**Leap "grab disable hack"**~~ **Resolved in this revision** (§3.2): a `-0.1` comparison threshold on a non-negative grab-strength value makes the `>` test almost always true — this is a "make the gate trivially open" hack, not a literal disable. The manual per-hand toggles are therefore largely redundant with the (nearly-always-open) grab gate in normal operation, not "load-bearing" as previously guessed.
6. **`p xypinch`'s self-referential pinch-zoom enable condition** (§1.2.1, revised) — the gate that lets `mira.mt.pinch` outlet 0 reach the persistent-zoom accumulator is itself conditioned in part on that accumulator's *own* previous scaled output (`obj-221 < 1.01`). This is a legitimately unusual feedback shape for a static listing to characterize with confidence; recommend testing live in Max before porting literally, and consider whether the intended behavior is simply "accumulate while below a ceiling of ~1.0" (my best reading) or something else.
7. **`mira.mt.pinch`/`mira.mt.rotate`/`mira.mt.centroid` outlet semantics** — these are Mira-specific objects with no public Max doc consulted for this audit. Which physical outlet carries X vs. Y (for `centroid`), and what "outlet 0" vs "outlet 1" of `mira.mt.pinch` actually represent (this doc guesses "gesture progress" and "delta" respectively, based only on which one feeds a `clip -3 3`), are inferred from wiring shape, not verified against documentation. The axis-swap claim removed from §1.3's x/y table in this revision reflects that uncertainty.
8. **`toggle[6]` vs `toggle[13]` (`soundwave_enable` vs `soundwave_enable1`) label assignment** ("Circle" vs "Wave Enable") is inferred from on-canvas (x,y) proximity of comment boxes to toggle boxes, not from any wire — the text listing gives no direct link between a `comment` box and its neighboring control. Worth eyeballing the actual .maxpat in Max/a patcher viewer to confirm. (This revision did confirm, via the raw JSON, that `toggle[6]` itself defaults ON and `toggle[13]` defaults off — independent of which label belongs to which.)
9. **`feedbax_as_sticker_folder` / the literal `"AS"` token** in pathsetup's second `sprintf` is unexplained by anything in this file; its consumer in `feedbax.picsvid` may clarify but is out of this section's scope.
10. **Persisted slider defaults with out-of-range values** — e.g. `slider[11]` ("pic rotate") has `parameter_initial: -360` while its own declared range is `min=-1` (bipolar, so nominal range −1..1); this revision found a second instance — the "HUE-SHIFT" reset button (§1.4) drives `slider[5]` to `1.1`, also outside its own −1..1 range. Both are either stale saved attributes from an earlier version of the control's range, or values Max clamps silently on load/on-set; effect at load/trigger time is not fully certain from the JSON alone.
11. **No `preset`/`pattrstorage` object exists anywhere in `feedbax.webui.maxpat`** (confirmed by direct grep of the raw JSON) — there is no scene/preset-recall system for the shadeCtl vector; every "default" is either a `loadmess`/`loadbang` value or a persisted UI-widget attribute, both enumerated above.
12. **Which physical display `screencapture -D 2` targets** in Sean's actual performance rig (main screen vs. projector) is an environment fact not recoverable from the patch.
13. **`feedbax.stillsave`'s `combine` object (`obj-14`, `@triggers 2`)** — this revision found that its inlet 1 is fed only by a dangling, never-triggered example message box (`obj-7`, `"output/1-7-2024-6-29-13.jpg"`, no incoming wire of its own); only inlet 2 (the live date string) ever receives real input during a capture. Whether `combine`'s own instantiation arguments count toward its `@triggers 2` threshold (so a single live inlet is sufficient to fire) is a Max-runtime detail this static listing can't resolve — worth confirming the screenshot mechanism actually fires in the live patch rather than assuming it from the wiring alone. Two further debug/example message boxes (`obj-17`, `obj-3`) downstream of `combine`/`obj-8` are also dead ends with no outgoing connections — harmless leftover documentation artifacts, not part of the live chain.

---

### Audit notes (verification pass)

Corrections made in this pass (traced against the raw `.maxpat` JSON and the connection listings, object id by object id):

- **`p xypinch` pinch/rotate mechanism, largely mis-traced.** The originally-described "clip→scale→sign-gated dual accumulator" chain off `mira.mt.pinch` outlet 1 (the "delta") is a dead branch — `obj-133`'s control inlet is never wired (permanently closed) and `obj-131`'s/`obj-149`'s outputs have no downstream connections anywhere in the file. The value that actually reaches the persistent-zoom outlet comes from **outlet 0** of `mira.mt.pinch` through a self-referential enable condition (`obj-224 &&` gated in part by the chain's own prior output), not from the delta at all. Rewrote §1.2.1 to describe the real wiring and flagged the self-referential part `[?]`.
- **Two-finger-rotate accumulator (`obj-227`) has no reset.** The claimed "reset to 0 on gesture-end via `obj-231`/`obj-91`" does not exist as wired — `obj-91` has no outgoing connection and `obj-231` has no incoming connection. The accumulator runs open-loop for the life of the patch.
- **Mira gesture flags (`tap_enabled`/`pinch_enabled`/`rotate_enabled`/`swipe_enabled`) default OFF on both touch pads**, per the objects' own persisted JSON attributes — the original text said "no visible default." This means pinch-zoom and two-finger rotate are inert unless a performer enables them live.
- **Reset-button ×5 targets were wrong.** Re-traced each button→message→slider chain: the real targets are BRIGHTNESS→1.0 (`obj-30`), HUE-SHIFT→1.1 (`obj-17`), SATURATION→0.5 (`obj-50`), TRANSPARANCY→1.0 (`obj-83`), ZOOM→1.0 (`obj-27`) — not "rotate/pic-size/theta-ish/zoom/transparency" driving sliders 74/75/56/27/83 as originally stated. Only the TRANSPARANCY and ZOOM targets were coincidentally right.
- **"Motion control" toggle (`obj-146`) defaults ON**, via `loadmess 1` (`obj-148`) — the original text called it "unsaved"/off. Device-tilt modulation of `shadeCtl` scale/theta is active from patch load, not opt-in.
- **`soundwave_enable`/toggle[6] defaults ON**, via `loadmess 1` (`obj-92`) — also mislabeled "unsaved" in the original. `soundwave_enable1`/toggle[13] is genuinely unsaved/off, confirmed no `loadmess`.
- **`pic enable`/toggle[2] and "Wave Lighting"/toggle[10]** do have explicit `loadmess 0` wiring (both off) — cosmetically the original's "unsaved" claim reached the right value but the wrong provenance; corrected for completeness.
- **`shaderfx.obj-7 ||`** (the automatic gate-open condition for `shadeCtlLeap`) was mislabeled "right-hand presence" — it's wired to the exact same two `frame_info` hand-presence flags as `leap2HandsActive`, i.e. it's an *either-hand* OR, not right-hand-specific.
- **shadeCtlLeap hue/bias/scalebright chain was missing a step** (`obj-114 zl slice 3`) between `obj-113 zl slice 1` and the gate feeding `vexpr`; added, and clarified that `vexpr` broadcasts its expression element-wise across the incoming 3-element list rather than operating on a single scalar.
- **shadeCtlLeap slot 7 (NC) is dead, not a "duplicate tap."** `obj-124`'s `scale` emits a scalar; feeding a scalar into a 3-outlet `unpack` only fires the first outlet (standard Max behavior) — so `obj-75`'s outlet 1 (feeding NC) never fires. NC stays at the pack's literal default (0.) whenever Leap is the active source.
- **Leap "grab disable hack" resolved, not left as "[?] unresolvable."** A `-0.1` threshold on a non-negative grab-strength value makes the `>` test almost always true in practice — it's a "make the gate trivially open" hack, not a mystery. Also found and noted a dangling, unreachable `obj-52 msg "0"` debug reset on the same cold inlet.
- **§1.3 x/y (`imageMove` slots 1/2) outlet indices were swapped** relative to the connection list (`obj-67`/x is fed by `mira.mt.centroid` outlet 0, not 1; `obj-64`/y by outlet 1, not 0), and the resulting "axis-swapped" claim is now marked `[?]` rather than asserted, since it rested on the wrong outlet citation and `mira.mt.centroid`'s true X/Y-to-outlet mapping isn't independently documented here.
- **FPS preset "orphan `100`" claim was wrong** — all 5 boxes (30/60/90/100/120) are identically wired into the same number box; none is disconnected.
- **Resolution preset count corrected**: 15 `dim` boxes feed `s resolution` (not 14 as stated), spanning 14 distinct resolutions because `5120×1440` appears twice (`obj-135`, `obj-163`). Added a 16th, out-of-band `dim 5120 1440` box (`obj-123`) that bypasses the `resolution` bus entirely, wired directly into the `dst` texture and the window-size chain.
- **`feedbax_root` fan-out clarified**: the regex output feeds four destinations in parallel (the `value` object and all three `sprintf`s directly); it is not routed *through* the `value` object as a lookup, and the `value` copy is otherwise unread anywhere in the codebase.
- **`uiGain` is only half a bus.** Sound2→UI read-back goes over the named bus as documented; UI→sound2 write is a direct patch cord (`obj-332`→`feedbax.sound2` inlet 0), not a bus message. Noted for port purposes.
- **`movSel` clamp ceiling** (`obj-25`, `maximum=53`) is a compile-time default, dynamically overwritten at runtime by `movsFound` via a `prepend max` message — clarified rather than left implicit.
- **`feedbax.stillsave`'s `combine` object** has one dangling (never-triggered) input and two dead-end downstream debug message boxes; flagged as a new open question whether the screenshot trigger path actually satisfies `combine`'s `@triggers 2` requirement as wired.
- Softened one claim to `[?]` rather than a flat assertion: the `slide 22 14` up/down-rate flonums' load-time display value (0 vs. their declared `minimum=1.0`) can't be determined from a static JSON dump.

Residual uncertainties (not resolvable from the listings provided, all flagged inline with `[?]` at point of use): the exact runtime semantics of `mira.mt.pinch`/`mira.mt.rotate`/`mira.mt.centroid` outlets (Mira objects, no public doc consulted); the self-referential pinch-zoom enable condition's actual runtime behavior; the semantic meaning of the `right_hand` sub-component driving Leap's theta; the `toggle[6]`/`toggle[13]` label-to-comment pairing; the `combine`-object trigger-threshold question above; and the shaderfx 2-second Leap-fallback timer's exact inlet-priority behavior (unchanged from the original text's own hedge, independently re-verified against the `feedbax.shaderfx.maxpat` listing and found to match the wiring as described).
