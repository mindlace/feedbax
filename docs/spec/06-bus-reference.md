> Part of the Feedbax technical description — see [`README.md`](README.md).

# 06 — Global message-bus reference

Feedbax's subsystems are separate abstraction files that share almost no patch cords; they talk
over Max's global `send`/`receive` buses (`s NAME` / `r NAME`). This table is generated from the
current patch files with `tools/srxref.py` (which walks every `.maxpat` under `patches/` including
subpatchers) and annotated by hand. "§NN" points at the section that documents the bus in depth.

Per-frame clock buses (`ctrlbang`, `audiobang`, `imgbang`) fire once per `metro` tick in the order
given in §01 §1. `mIniCtlSmooth` is the shared smoother abstraction: every value that passes through
it ramps linearly over `controlSmoothMs` milliseconds.

## Live buses

| bus | payload | meaning | sender(s) → receiver(s) | see |
|---|---|---|---|---|
| `FPSconfig` | `interval <ms> hz` | Frame-clock rate preset (30/60/90/100/120 Hz); default 60. | Feedbax → Feedbax | §01 |
| `SInvert` | float ±1 | Sign flip derived from `scaleInvtoggle`; multiplies zoom and x/y offset in the shader chain. | feedbax.shaderfx → feedbax.shaderfx | §01 §4 |
| `audiobang` | bang, per frame | Frame-clock tick for the audio layer: dumps `jit.catch~` matrices and redraws both waveform graphs. | Feedbax → feedbax.sound2 | §03 |
| `camRaw` | texture | Camera frame after optional BRCOSA adjust, before keying. | feedbax.picsvid → feedbax.picsvid | §02 §7.2 |
| `cameragrab` | texture | Raw camera frame from USB (`jit.grab`) or NDI. | feedbax.picsvid → feedbax.picsvid | §02 §7.1 |
| `cameragrabpost` | texture | Keyed camera composite, gated into the image layer by the 'Enable camera' toggle. | feedbax.picsvid → feedbax.picsvid | §02 §7.3 |
| `chromaEn` | 0/1 | Chroma-key branch enabled (exclusive with `lumaEn`). | feedbax.picsvid → feedbax.picsvid | §02 §7.3 |
| `controlSmoothMs` | int ms | Ramp time of every `mIniCtlSmooth` smoother; default 100 ms, presets 0–8000. | Feedbax → feedbax.shaderfx/mIniCtlSmooth, feedbax.shaderfx/oldconrtrol/mIniCtlSmooth, feedbax.sound2/mIniCtlSmooth, feedbax.webui/mIniCtlSmooth | §01 §0 |
| `ctrlbang` | bang, per frame | Frame-clock tick for control updates (webUI 60 Hz re-evaluation of `shadeCtl`, Leap timer, bump gates). | Feedbax → feedbax.leapgemini, feedbax.shaderfx, feedbax.sound2, feedbax.webui | §01 §1 |
| `erasetransparency` | float 0..1 | From webUI 'TRANSPARANCY' slider; mapped `0.8 + 0.2·x³` into the render erase alpha (trail length). | feedbax.webui → Feedbax | §01 §2 |
| `feedbax_sticker_folder` | `folder <abs path>` | Absolute path of `input/transparent-background/`, consumed by `p pic` to populate the sticker menu. | feedbax.pathsetup → feedbax.picsvid | §02 §1 |
| `fswindow` | `fullscreen $1` … | Messages forwarded to `jit.window foo`. | Feedbax → Feedbax | §01 §1 |
| `hue1` | r g b a | Waveform-1 colour (swatches in sound2 and webUI). | feedbax.sound2, feedbax.webui → feedbax.sound2 | §03 §6 |
| `hue2` | r g b a | Waveform-2 colour; alpha pulsed by `wavebumpsig`. | feedbax.sound2 → feedbax.sound2 | §03 §6 |
| `imageMove` | 10 floats | `enable x y 0 zx zy 0 0 0 r` — sticker/camera layer transform from webUI (and picsVid locally). | feedbax.picsvid, feedbax.webui → feedbax.picsvid | §02 §4, §04 §1.3 |
| `imgbang` | bang, per frame | Frame-clock tick for the image layer: re-bangs `jit.grab`/`jit.ndi.receive~` when camera is on. | Feedbax → feedbax.picsvid | §02 |
| `keyCh2init` | texture | Static backdrop colour texture all keyers matte against. | feedbax.picsvid → feedbax.picsvid | §02 §7.3 |
| `keyCtrls` | 12 floats | Luma-high/low and chroma key parameters + key colour. | feedbax.picsvid → feedbax.picsvid | §02 §7.4 |
| `kittybump` | 0/1 | Enables the 'kittieBump' kick-envelope in sound2. | feedbax.webui → feedbax.sound2 | §03 §7c, §04 §1.3 |
| `kittybumpsignal` | float | Kick envelope back to webUI; adds to picture size/Y placement. | feedbax.sound2 → feedbax.webui | §04 §1.3 |
| `leap2HandsActive` | 0/1 | Leap sees a hand (either); drives the 2-s Leap→iPad fallback timer. | feedbax.leapgemini → feedbax.shaderfx | §01 §4, §04 §3.3 |
| `left_fingers` | list | Ultraleap left finger data, consumed only by `p fill_coll` (display). | feedbax.leapgemini → feedbax.leapgemini/fill_coll | §04 §3.4 |
| `left_hand` | list | Ultraleap left palm data (LeapGemini-internal bus to `p fill_coll` and the shadeCtlLeap mapping). | feedbax.leapgemini → feedbax.leapgemini/fill_coll | §04 §3 |
| `lineSmoothGrain` | int ms | `line` grain for every `mIniCtlSmooth` (broadcast once by `feedbax.misc`). | feedbax.misc → feedbax.shaderfx/mIniCtlSmooth, feedbax.shaderfx/oldconrtrol/mIniCtlSmooth, feedbax.sound2/mIniCtlSmooth, feedbax.webui/mIniCtlSmooth | §04 §4 |
| `livevid` | 0/1 | Picture (0) vs live camera (1) mode; also sets USB + 'Enable camera' toggles. | feedbax.webui → feedbax.picsvid | §02 §7, §04 §1.4 |
| `lumaEn` | 0/1 | Luma-key branch enabled (default). | feedbax.picsvid → feedbax.picsvid | §02 §7.3 |
| `movSel` | int | Sticker index into the scanned folder menu. | feedbax.picsvid, feedbax.webui → feedbax.picsvid/pic | §02 §2 |
| `movsFound` | int | Number of files found in the sticker folder. | feedbax.picsvid → feedbax.picsvid, feedbax.webui | §02 §1 |
| `resolution` | `dim W H` | Feedback-texture resolution preset; also derives `xyratio`. | Feedbax → Feedbax | §01 §1 |
| `right_fingers` | list | Ultraleap right finger data, consumed only by `p fill_coll` (display). | feedbax.leapgemini → feedbax.leapgemini/fill_coll | §04 §3.4 |
| `right_hand` | list | Ultraleap right palm data (LeapGemini-internal). | feedbax.leapgemini → feedbax.leapgemini/fill_coll | §04 §3 |
| `savePic` | bang | Take a screenshot (`feedbax.stillsave`, needs the `shell` external). | feedbax.webui → feedbax.stillsave | §04 §4 |
| `scaleInvtoggle` | 0/1 | Inverts zoom/offset sign in the shader chain (`SInvert`). | feedbax.webui → feedbax.shaderfx | §01 §4 |
| `shadeCtl` | 9 floats | Live shader control vector from webUI: hue bias scalebright xshift yshift scale theta NC sat. | feedbax.webui → feedbax.shaderfx, feedbax.webui | §04 §1, §01 §4 |
| `shadeCtlLeap` | 9 floats | Same layout from Leap hand tracking (sat fixed at 1). | feedbax.leapgemini → feedbax.shaderfx | §04 §3.2 |
| `soundwave_enable` | 0/1 | Waveform 1 draw enable. | feedbax.webui → feedbax.sound2 | §03 §5 |
| `soundwave_enable1` | 0/1 | Waveform 2 draw enable. | feedbax.webui → feedbax.sound2 | §03 §5 |
| `soundwave_lighting_enable` | 0/1 | Waveform 1 lighting. | feedbax.webui → feedbax.sound2 | §03 §5 |
| `start_frame` | bang | Ultraleap frame-start marker, consumed by `p fill_coll`. | feedbax.leapgemini → feedbax.leapgemini/fill_coll | §04 §3.4 |
| `toNDI` | messages | PTZ / bandwidth messages to `jit.ndi.receive~`. | feedbax.picsvid → feedbax.picsvid | §02 §7.1 |
| `uiGain` | float | Audio input gain read-back from the Mira tab to the main-patch slider. | feedbax.sound2 → Feedbax | §03 §2 |
| `usbcam` | 0/1 | USB camera selected; triggers device enumeration/open. | feedbax.picsvid → feedbax.picsvid | §02 §7.1 |
| `wave2cmd` | attribute msgs | Mira-tab remote attribute messages to waveform-2's `jit.catch~`. | feedbax.sound2 → feedbax.sound2 | §03 §4 |
| `wave2cmdG` | attribute msgs | Mira-tab remote attribute messages to waveform-2's `jit.gl.graph`. | feedbax.sound2 → feedbax.sound2 | §03 §5 |
| `waveLineFilll` | 0/1 | Waveform 1 line style (thick line vs dotted). | feedbax.webui → feedbax.sound2 | §03 §5 |
| `wavebump` | 0/1 | Enables the waveform-2 alpha pulse envelope. | feedbax.sound2 → feedbax.sound2 | §03 §7b |
| `wavebumpsig` | float | Bass envelope added to waveform-2 colour alpha. | feedbax.sound2 → feedbax.sound2 | §03 §6 |
| `wordBumpEn` | 0/1 | Enables `worldBump` (sound2-local toggle). | feedbax.sound2 → feedbax.sound2 | §03 §7a |
| `worldBump` | float | Bass envelope ×0.05 added to the main videoplane z position (−0.414 + bump). | feedbax.sound2 → Feedbax, feedbax.sound2 | §03 §7a, §01 §3 |
| `xyratio` | float | Width/height of the current `resolution`; scales the main videoplane x. | Feedbax → Feedbax | §01 §1 |

## Dead or one-sided buses (safe to ignore in a port)

| bus | sender(s) | receiver(s) | note |
|---|---|---|---|
| `---bypass` | — | feedbax.picsvid/chro | Vizzie bypass convention; no sender → gates stay open. |
| `2dfft4x` | — | feedbax.picsvid | leftover receive from a removed audio-visual feature |
| `end_frame` | feedbax.leapgemini | — | Ultraleap frame marker, unused |
| `feedbax_rescan` | — | feedbax.pathsetup | Re-runs `feedbax.pathsetup` (re-resolves project root, re-sends the sticker folder). Added 2026-08. |
| `frame_info` | feedbax.leapgemini | — | Ultraleap per-frame summary sent on a bus but consumed via a direct cord instead |
| `fs` | — | Feedbax | Fullscreen toggle input (no sender in the patch; reserved for external control). |
| `gainmain` | feedbax.webui | — | webUI gain slider wired to nothing |
| `kittybumpsignal1` | feedbax.sound2 | — | duplicate of `worldBump`, never received |
| `leap_frame` | — | feedbax.leapgemini/fill_coll | never sent |
| `scope2011` | — | feedbax.picsvid | leftover receive from a removed 2011-era scope feature |
| `soundwave_lighting_enable1` | — | feedbax.sound2 | waveform-2 lighting enable, never sent by the UI |
| `waterfall` | — | feedbax.picsvid | leftover receive from a removed spectral-waterfall feature |
| `waveLineFilll1` | — | feedbax.sound2 | waveform-2 line style, never sent by the UI |

## `value` objects (global variables)

```
feedbax_root: ['feedbax.pathsetup']
```

`feedbax_root` is set once at load by `feedbax.pathsetup` to the absolute project folder (Max path
syntax, e.g. `Macintosh HD:/Users/you/feedbax/`). Anything that needs a project-relative file can
`[v feedbax_root]` and `sprintf` a path from it.
