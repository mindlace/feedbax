> Part of the Feedbax technical description — see [`README.md`](README.md) for the overview,
> conventions (object-id citations like `[obj-36]`, `[?]` = unverified), and how the listings
> these sections cite were produced (`tools/maxpat2txt.py`). Each section ends with the audit
> notes from its verification pass.

# Image, sticker, video and camera input (`feedbax.picsvid`)

Source patcher: `feedbax.picsvid.maxpat` (main `/`, plus subpatchers `p pic` [obj-14], `p brcosaslab` [obj-317], `p chro` [obj-147], `p vdev/format` [obj-107]), plus three Vizzie-package bpatchers instantiated inside it: `vz.alphablendr.maxpat` [obj-252 "alphablendr"], `vz.lumakeyr.maxpat` [obj-48 "lumakeyr", obj-153 "lumakeyr[1]"], `vz.chromakeyr.maxpat` [obj-26 "chromakeyr"], and two instances of `vz.matrix2texture.maxpat` [obj-133, obj-179].

This module fires on the `imgbang` bus (banged once per render frame from the main patch's 60Hz metro, per the frame-clock description in the overview). It draws into one GL layer — Sean's box: `jit.gl.layer foo @layer 2 @enable 0 @shadow_caster 0 @two_sided 0 @auto_material 0` [obj-2]; current repo: `jit.gl.layer fb @layer 20 @enable 0 @shadow_caster 0 @two_sided 0 @auto_material 0 @automatic 1` — which is composited into the shared GL context by `jit.gl.render`/`jit.gl.window` outside this file.

**Draw order (matters for loop stability).** The layer is *not* drawn by `imgbang`: `r imgbang` [obj-279] reaches it only through `gate` [obj-307], whose control toggle [obj-316] has no inbound cord and is closed by default. Sean's box has no `@automatic` key, so the ob3d default (automatic) applies and the layer is drawn by the main patch's render bang — which fires *after* the manual bang of the feedback plane (§01 trigger table, 6th vs 7th). The sticker is therefore alpha-blended **on top of** the plane's `(SRC_ALPHA, DST_ALPHA)` composite: a convex stamp whose pixels can never exceed the sticker's own brightness, however the loop is driven. Sean's `@layer 2` never ordered the layer relative to the plane (the plane was `@automatic 0`, outside the layer system). In the `jit.gl.node fb` retrofit the plane is `@automatic 1 @layer 10`, so the layer must sit **above** it — hence `@layer 20`. At the retrofit's original `@layer 2` the sticker was drawn *under* the plane and re-added to the loop every frame; measured 2026-08-29 on Max 9.1.5, Pluto saturated to a white disc within a second of load, and at `@layer 20` it renders at its own brightness indefinitely (`docs/diagnosis-2026-08-23.md`, finding J).

**Two largely independent texture sources feed `jit.gl.layer foo`:**

1. **Sticker/movie path** — `jit.movie` [obj-49] plays a single selected file (still image or movie) from a scanned folder and writes its texture straight into the layer. This is the path used for "load an image/movie and position it," and is what was used almost exclusively in the last year of live use (per the user's account).
2. **Camera path** — USB (`jit.grab` [obj-113]) or NDI (`jit.ndi.receive~` [obj-1]) captures a live frame, optionally BRCOSA-adjusted [obj-317 `p brcosaslab`], luma- or chroma-keyed against a static backdrop color through Vizzie modules, and the result also feeds the *same* layer's texture inlet. Camera is **disabled by default** (see §7) — matches the user's report that camera was rarely used recently. **Correction:** the master camera-enable toggle is not an independently-clicked switch; it is driven live by webUI's `livevid` bus, which also drives the USB toggle — see §7.1/§7.3.

Both paths write to the same `jit.gl.layer foo` texture inlet, so whichever last sends a texture (or whichever gate is open) is what's drawn; there's no explicit "layer for stickers" vs "layer for camera" split in this file.

---

## 1. Sticker folder scanning

Two global buses set the sticker folder, both built once at patch load by `feedbax.pathsetup.maxpat` from the containing project directory (`thispatcher`'s own file path, regexed down to its parent folder = `feedbax_root`):

| Bus | Built as | Sent by |
|---|---|---|
| `feedbax_sticker_folder` | `folder <feedbax_root>input/transparent-background/` | pathsetup `sprintf` [pathsetup obj-7] → `send feedbax_sticker_folder` [pathsetup obj-8] |
| `feedbax_as_sticker_folder` | `folder AS <feedbax_root>input/transparent-background/` | pathsetup `sprintf` [pathsetup obj-9] → `send feedbax_as_sticker_folder` [pathsetup obj-10] |
| `feedbax_sticker_prefix` | `prefix <feedbax_root>input/transparent-background/` | pathsetup obj-12 — **dead: no receiver anywhere in the codebase** |

Both `folder ...` messages are received by `p pic` [obj-14] via `receive feedbax_sticker_folder` [obj-recv-sticker-folder] and `receive feedbax_as_sticker_folder` [obj-recv-as-folder], which feed directly into `p pic`'s single inlet, alongside several **hardcoded** duplicate messages already sitting in the main patch that fire the identical literal path at load or on click: `"folder input/transparent-background/"` [obj-7, obj-10 via loadbang obj-78, obj-19, obj-44, obj-77] and `"folder AS input/transparent-background/"` [obj-72, obj-46] — i.e. the sticker folder is always the project-relative `input/transparent-background/` directory; there is no dynamic per-show folder picker wired into the live path (see also the dead drag-and-drop loader in §9).

Inside `p pic` [obj-14]: `route int folder` [pic obj-4] tests the incoming message.
- Messages beginning with the symbol `folder` (i.e. all of the above) → outlet 1 → `prepend prefix` [pic obj-1] → sends `prefix <path>` to the folder-scanning `umenu` [pic obj-5]. The umenu has `autopopulate=1` and a `types` filter of `["MooV","MPEG","mpg4","VfW","WMV","PICT","PNG","GIFf","TIFF","BMP"]` (movies + common still-image codecs, set via message `types MooV MPEG mpg4 "VfW " "WMV " PICT "PNG " GIFf TIFF "BMP "` [pic obj-31], fired at load via `loadbang`[pic obj-33]→`t 0 1 b`[pic obj-50]). Setting `prefix` re-scans that folder and repopulates the umenu's item list with every matching file.
- Non-`folder` messages (route's reject outlet) → `data-handler` [pic obj-75] → drives the umenu's on-screen visibility toggle (`live.toggle` "pictctrl[3]" [pic obj-41]) — not part of the sticker-selection signal path itself.

**"AS" variant is suspect / likely broken** [?]: the `feedbax_as_sticker_folder` and the hardcoded `"folder AS input/transparent-background/"` messages resolve to the *same directory* as the plain variant, just with the extra token `AS` before the path. Since `route int folder` matches only on the leading symbol `folder` and passes everything after it through unchanged, this produces the message `prefix AS input/transparent-background/` sent to the umenu — a two-atom message where a single folder-path symbol is expected. Whether Max's umenu tolerates the leading `AS` atom (silently drops it) or the prefix attribute actually becomes the literal symbol `AS` (breaking the scan) could not be determined from the static listing. Flagged for verification; see Open Questions.

**Scan-result count**: when the umenu repopulates, it emits an internal `populate <count>` notification (umenu outlet 2) → `route populate` [pic obj-22] → `t i b` [pic obj-46] → the int count exits `p pic`'s outlet 2 → main patch `s movsFound` [obj-71] → broadcast on bus **`movsFound`**. This is received both by picsvid's own display `number` [obj-57] and by `feedbax.webui`'s `number[9]` (used to bound the manual index selector, see §2).

## 2. Selecting a sticker

**Three** independent ways to pick an item, all converging on the same `umenu` [pic obj-5] — the author's original pass found only two; a third, purely local mechanism was missed:

1. **Direct click / drag** on the umenu in the UI (or a file drag-dropped onto it — `route drag` [pic obj-8] specifically distinguishes a genuine OS drag-drop from a plain click, but both eventually reach the same read logic below via its reject outlet).
2. **Numeric index from `webUI`** — bus **`movSel`**, an integer, manipulated by `+`/`-` buttons through an `incdec` (webUI's own internals are outside this audit's source set and are reported here only as the original author summarized them, unverified). `r movSel` [pic obj-72] feeds straight into the umenu's inlet 0: sending an int to a Max umenu selects that item **by list index** and fires it exactly as a click would.
3. **`[correction — new]` A second, local `movSel` sender lives inside `feedbax.picsvid` itself**, not just webUI: `incdec` [obj-65] drives `number[1]` [obj-61] (`maximum=53`) which feeds **both** `s movSel` [obj-69] directly *and* an `incdec` readback. Unlike the doc's original blanket claim that the 0–53 ceiling is "not dynamically tied to `movsFound`" — that may be true of webUI's own copy (unverifiable from the given sources), but it is **false** for this local copy: `r movsFound` [obj-70] drives a plain display `number` [obj-57] → `prepend max` [obj-66] → `number[1]`'s own inlet 0, which for a Max UI number box accepts attribute messages directly (no separate cold inlet needed) — this sends `max <count>` and **dynamically resizes `number[1]`'s ceiling to the live scan count** every time the sticker folder is rescanned. The same `r movsFound` bang also fires `t 0` [obj-79] → resets `number[1]` to `0`, and `sel 0` [obj-51] (on the `livevid`→0 transition, see §7.3/open question below) does the same — i.e. the local index resets to the first item on every rescan and every switch back from camera to picture mode.
4. **`[correction — new]` A continuous/analog selector, entirely missed by the original pass**: `p pic`'s sole inlet [pic obj-76] feeds `route int folder` [pic obj-4]'s data inlet; on its **reject** outlet (anything that is neither a bare int nor a `folder`-headed message) the data goes to `data-handler` [pic obj-75], whose outlet 0 feeds `scale 0. 1. 0 1 1` [pic obj-108] inlet 0. That `scale` object's **`hi2` bound (its inlet 4) is itself dynamically driven** by `t i b` [pic obj-46] (fed from the umenu's own `populate <count>` notification, the same signal that produces `movsFound`) — so a normalized 0–1 input is continuously rescaled to `[0, current item count]` and fed straight into the umenu's inlet 0, selecting an item by *position in range* rather than by fixed index. This strongly suggests a touch/slider control (plausibly a `mira` iPad "VidIn" control reaching `p pic`'s inlet from outside picsvid) can drag through the sticker list proportionally; nothing in the given listings shows what actually feeds `p pic`'s inlet with this kind of non-`folder`, non-int message in normal operation, so the ultimate source is **`[?]`** — flagged in Open Questions. `data-handler`'s outlet 1 (unchanged from the original doc) drives the umenu-visibility toggle [pic obj-41].

Either route lands on umenu outlet 1 (the "item selected" notice, carrying the bare filename symbol) → `route drag` [pic obj-8] reject outlet → `zl change` [pic obj-6] (dedupe — re-selecting the same file is a no-op) → `prepend read` [pic obj-13] → `read <filename>` message → gated by `live.toggle` "pictctrl[2]" [pic obj-30] (default **on**, `parameter_initial=1`) via `gate 1 1` [pic obj-71] → exits `p pic` outlet 1.

## 3. Loading and displaying the file

`p pic`'s outlet 1 (`read <filename>`) reaches the main patch's `t b s` [obj-54], which forwards the read-message and a bang into `jit.movie @output_texture 0` [obj-49]'s **same inlet 0** (both `t` outlets target inlet 0). Trigger objects fire right-to-left, so the `s` (symbol/list) outlet fires **first** — forwarding the `read <filename>` message, which starts the load — and only then does the `b` (bang) outlet fire, asking `jit.movie` to output its (now newly-loading/loaded) current frame. `jit.movie` (a Max object that decodes still images and QuickTime/AVFoundation movies alike) loads the file and outputs its (first) frame as a `jit_matrix`, which the layer uploads to its own texture.

**Max 9 note (2026-08-29, verified live on 9.1.5/glcore):** Sean's box was `jit.movie @output_texture 1` (GPU texture out). On Max 9 that path is state-dependent and broken in exactly this wiring: a bang in the same scheduler tick as `read` (which is what `t b s` does) makes the object emit *nothing* on that and every later bang until the next `read`; the load-time read leaves obj-49 emitting a texture whose contents stay black (alpha 0) even after re-reads and delayed bangs — so the layer drew an invisible sticker. A *fresh* `jit.movie` given `read` and a bang ≥1 frame later does fill its texture, but obj-49 never recovered in texture mode. With `@output_texture 0` the same object emits a correct `jit_matrix` on a same-tick bang, on repeated bangs, and after the load-time read, and `jit.gl.layer` accepts `jit_matrix` on its inlet 0 — so the box is now `jit.movie @output_texture 0`. (The `@drawto foo` that an earlier fix added to make the texture outlet emit at all is no longer needed and was dropped.)

- `jit.movie`'s frame (a `jit_matrix` since the Max 9 fix above; a `jit_gl_texture` in Sean's build) feeds `jit.gl.layer foo`'s inlet 0 **directly** [obj-49 → obj-2, inlet 0] — no keying, no matting is applied to stickers; whatever alpha channel the source PNG carries passes straight through to the compositor.
- `attrui output_texture` [obj-8] sets `jit.movie`'s `@output_texture` attribute live.
- A manual "movieBang" button [obj-53, comment "// movieBang" obj-187] re-triggers the next frame — the only other thing that bangs `jit.movie` besides a new file being read is `r livevid` [obj-120] hitting `sel 0` [obj-51]: whenever the webUI `livevid` toggle is set to **0** (i.e. "not live/camera", meaning picture mode), it fires this bang. That same `sel 0` match also fires `t 0` [obj-79] → resets the local sticker-index `number[1]` [obj-61] to 0 (see §2 item 3), so switching from camera back to picture mode both re-bangs the current sticker *and* snaps the local index selector back to item 0. `sel 0`'s non-match outlet (`livevid`=1) instead passes through to `getsourcelistmenu`-refresh plumbing shared with the NDI source list — confirmed via [obj-93 sel 0], a second, independent `sel 0` gated by the NDI toggle (see §7.1). **`jit.movie` is *not* driven by the per-frame `imgbang` clock** [?] — there is no `r imgbang → jit.movie` connection anywhere in this file. For a still PNG that's irrelevant (one frame is enough), but it means an actual **movie** file loaded through this path will not auto-advance frames on its own without one of these two triggers firing repeatedly; playback of movies (vs. stills) may rely on `jit.movie`'s own internal rate/auto-play behavior once opened, which this static listing cannot confirm.
- The umenu's built-in file list is itself stale scan data baked into the .maxpat (105 filenames, e.g. `cleo2.png`, `dblcat.png`, `IMG_3658.PNG`…) from whatever folder was last scanned at save time — cosmetic only, since `autopopulate` rescans live at load.

## 4. Positioning, scaling, rotating (`imageMove`)

`feedbax.webui` packs a 10-float list and sends it on bus **`imageMove`**, gated at the source so it only fires on `ctrlbang` (the same "control update" bus that fires once per frame the overview) or when the "pic enable" toggle changes [webui obj-1 → obj-8 pack inlet 0]:

```
pack: [enable, x, y, 0, zx, zy, 0, 0, 0, r]
       ^bang/1  ^--position (3)--^  ^--scale (3)--^  ^--rotatexyz (3)--^
```
Comment in picsvid confirms the same shape: `// enable x y 0 zx zy 0 0 0 r` [obj-47]. Position x/y come from webUI's multitouch centroid (`mira.mt.centroid` → `scale 0.1 0.9 -1.7 1.7` for x, `scale 0. 1. 1 -1.` for y, each through an `mIniCtlSmooth` ramp — see the smoothing note below); scale/rotate slots are largely `0.` placeholders in the observed wiring (only `r`, the z-rotation, is live, from a slider chain) — the exact webUI touch mapping is out of scope for this section but is summarized here because it fully determines the sticker's on-screen placement.

In picsvid, `r imageMove` [obj-39] is gated by `toggle[12]` [obj-207] (default **on**, `loadmess 1` [obj-208]) through `gate 1 1` [obj-201], then decoded by a `zl slice` chain that exactly matches the comment's grouping:

```
zl slice 1  [obj-35]  → 1 value  = enable  → prepend enable  [obj-33] → jit.gl.layer foo
   remainder(9) →
zl slice 3  [obj-36]  → 3 values = x,y,0   → prepend position [obj-32] → jit.gl.layer foo
   remainder(6) →
zl slice 3  [obj-37]  → 3 values = zx,zy,0 → prepend scale    [obj-31] → jit.gl.layer foo
   remainder(3) →
zl slice 3  [obj-38]  → 3 values = 0,0,r   → prepend rotatexyz [obj-29] → jit.gl.layer foo
```

**Enable has two independent paths into the same attribute** — worth flagging for a port because the ordering is message-driven, not logical:
- `obj-35`'s enable slice feeds `prepend enable` [obj-33] directly, **and** also feeds `||`'s [obj-138] **left/hot inlet 0**.
- The **"Enable camera" toggle** [obj-87] (see §7) feeds `t b i` [obj-139], whose two outlets **both** land on `||` [obj-138]: outlet 1 (`i`, the raw toggle value) → `||` inlet **1** (right/cold — just updates the stored operand), and outlet 0 (`b`, bang) → `||` inlet **0** (left/hot, same inlet `obj-35` feeds — triggers `||` to recompute and output using whatever operand values are currently stored on both inlets). Trigger fires right-to-left, so the cold-inlet update (outlet 1) always lands *before* the hot-inlet bang (outlet 0) that reads it back out — i.e. turning the camera-enable toggle on or off correctly ORs its new value against whatever `obj-35` last sent, then immediately outputs `enable 1`/`enable 0` via `prepend enable` [obj-156] into the same layer.

Both `prepend enable` messages target `jit.gl.layer foo`'s inlet 0. Since `jit.gl.layer` attributes are simply overwritten by whichever message arrives last, the effective enabled-state is not a clean logical OR at all — it is "whichever of these two independent triggers fired most recently." A straight port should probably just OR the two booleans explicitly (`layer.enabled = imageMove.enable || cameraEnableToggle`) rather than reproduce the race.

Base object instantiation is `@enable 0` (disabled until one of the above sets it).

## 5. `jit.gl.layer foo` compositing attributes (attrui-driven, not per-frame)

These are set by `attrui` boxes wired straight into `jit.gl.layer foo`'s inlet 0 — they are one-shot/manual controls (or set once via loadmess/UI), **not** part of the per-frame `imgbang`/`ctrlbang` signal path:

| Attribute | attrui obj | Notes |
|---|---|---|
| `layer` | [obj-3] | z-order within the shared GL context; instantiated at `2` |
| `blend_mode` | [obj-4] | Jitter blend-mode enum pair (see the overview) |
| `blend` | [obj-6] | on/off |
| `blend_enable` | [obj-318] | on/off |
| `interp` | [obj-169] | texture interpolation |
| `automatic` | [obj-199] | whether the layer auto-draws each render pass vs. needs explicit `draw`/`drawimmediate`/`drawraw` |
| `capture` | [obj-262] | Jitter layer-capture flag |

No `parameter_initial`/stored `value` is present for any of these attrui boxes in the file, and the object's own instantiation text carries none of these attributes explicitly — so their effective defaults are whatever Jitter's built-in `jit.gl.layer` defaults are, which this static listing cannot report with certainty **[?]**. **Correction:** the `draw $1` / `drawimmediate $1` / `drawraw $1` messages [obj-209, obj-222, obj-242] are **not** "wired to buttons/UI" as originally stated — they have **zero inbound connections of any kind** (no button, no toggle, nothing feeds their `$1`). They are fully dangling: even a manual click would just emit the literal unsubstituted text (e.g. `draw $1`), which `jit.gl.layer` would not interpret as a valid draw call. These three are dead/vestigial controls, not one-off debug triggers with an operator behind them — moved to §9. Normal drawing presumably happens automatically as part of `jit.gl.render`'s pass, the overview, since `@automatic` is never explicitly set to 0 anywhere in this file.

## 6. Alpha-mask overlay matrix (vignette, *not* per-sticker alpha)

Separately from the selected sticker, a second RGBA matrix `jit.matrix 4 char 1920 1080` [obj-155] holds a full-frame vignette/matte texture, loaded via `jit.matrix`'s `importmovie` method (imports one still frame from a file straight into an existing matrix):

| Trigger | Message | Effect |
|---|---|---|
| `loadbang` [obj-293] (patch load) | `importmovie NormalFullAlpha1080p1.png 1, bang` [obj-9] | loads the "Full Alpha" plate at startup |
| Button "Full Alpha" [obj-67] | same message [obj-9] | manual reload |
| Button "Circle Alpha" [obj-11] | `importmovie circleGradiant1080p6.png 1, bang` [obj-287] | swaps to the circular vignette |

Both assets were inspected directly (`assets/`):
- **`NormalFullAlpha1080p1.png`** — 1920×1080, RGB flat white `(255,255,255)` everywhere, **alpha constant 255** (fully opaque, no shape at all — an identity/no-op matte).
- **`circleGradiant1080p6.png`** — 1920×1080, RGB flat white everywhere, **alpha ranges 0–255** in a soft radial gradient: opaque at center, fading to fully transparent by roughly image-half-width from center (see rendered alpha preview). RGB itself is uniform white in both files — only the alpha channel differs.

This matrix feeds `vz.alphablendr.maxpat`'s "Video mask" inlet [obj-155 → obj-252 bpatcher inlet 2].

**Likely non-functional as a shape mask** [?]: alphablendr's internal `jit.gl.pix` graph (`//jit.gl.pix#obj-18` inside `vz.alphablendr.maxpat`) computes its blend weight from the mask input's **RGB luminance only** (`swiz rgb` → `mix(luma-pivot, rgb, contrast)` → `dot(vec(.299,.587,.114))`) — it never reads the matrix's alpha plane. Since both bundled masks are flat white RGB regardless of alpha, this luminance is spatially **uniform** across the frame for either mask — i.e. swapping "Full Alpha" for "Circle Alpha" should have **no visible effect** on alphablendr's output shape, only the (also uniform) `alphacontrast` parameter matters. If a circular vignette was actually observed live, either this reading is wrong, or the effect is coming from somewhere this listing doesn't show (e.g. a different consumer of the alpha channel not captured, or the vignette was never actually working as intended). Flagged for verification against real footage.

## 7. Camera input

### 7.1 Device selection & capture

Two mutually-exclusive camera "types," each a master toggle that also auto-drives the underlying capture object's init sequence:

- **USB** — toggle "USB" [obj-160] (`toggle[1]`) → `s usbcam`. **Correction: this toggle is not purely user-clicked** — `r livevid` [obj-120] feeds it directly (line: `[obj-120 r livevid] → [obj-160 toggle]:0`), so webUI's `livevid` bus sets the USB toggle to the same value it carries, in addition to gating `jit.movie`'s re-bang (§3) and the "Enable camera" toggle (§7.3) from the *same* bus/event — see the corrected framing there. Receivers `r usbcam` [obj-74, obj-145] auto-set two more toggles (obj-15 "grab enable" gating whether `jit.grab`'s frame reaches `s cameragrab`; obj-24, gating whether `imgbang` re-bangs `jit.grab` for a new frame each tick) and trigger `sel 1` [obj-145→146] → `getformatlist`, `getvdevlist`, and (via `pipe 100` [obj-148]) `open` sent to `jit.grab` [obj-113] — i.e. flipping "USB" on (by hand or via `livevid`) runs the whole device-enumeration/open sequence automatically.
- **NDI** — toggle "NDI" [obj-180] (`toggle[7]`, no `r livevid` link — NDI is not cascaded from `livevid` the way USB is) gates: (a) `jit.ndi.receive~`'s texture output [obj-1 outlet 1] through `vz.matrix2texture.maxpat` [obj-133] into `gate` [obj-143] → `s cameragrab`; (b) **`[correction]`** a raw `r imgbang` bang, gated by the toggle, into **`jit.ndi.receive~`'s own inlet 0** [obj-25 gate → **obj-1**, not obj-2/`jit.gl.layer foo` as originally stated] — i.e. every `imgbang` tick re-bangs the NDI receiver to output its current frame, the *exact NDI-side counterpart* of the `obj-13 gate → jit.grab` re-bang mechanism used for USB; it has nothing to do with the layer's draw call. (c) `sel 0`'s [obj-93] `getsourcelistmenu` refresh path: when the toggle carries a non-zero (NDI-on) value it passes through `sel 0`'s reject outlet to `getsourcelistmenu` [obj-18] and, via `pipe 100` [obj-80], a `0` sent back into the NDI source `umenu` [obj-59] to reset its selection; the match outlet (NDI toggled off, value 0) instead bangs the "movieBang" button [obj-53] — i.e. turning NDI off also re-triggers `jit.movie` to redisplay the current sticker, the same effect `livevid`→0 has via `sel 0` [obj-51] in §3.

Both device types converge on the same bus, **`cameragrab`** — the raw incoming camera texture, regardless of source.

**Device/format enumeration — the causal chain in the original doc was backwards; corrected here:** `jit.grab`'s outlet 1 sends both device-change notifications *and* the actual `vdevlist ...`/`formatlist ...` responses to `getvdevlist`/`getformatlist` queries. `route device_added device_removed device_format` [obj-104] only matches the two **change-notifications** on outlets 0/1 — both of which are wired together into `t b` [obj-102] → re-fires `getvdevlist` msg [obj-110], i.e. a device being added or removed just triggers a fresh list query, nothing more. `p vdev/format` [obj-107] is fed **not** from any of these three matched outlets but from route's **reject outlet 3** (line: `[obj-104]:3 -> [obj-107 p vdev/format]:0`) — i.e. it receives whatever *doesn't* match `device_added`/`device_removed`/`device_format`, which is the actual `vdevlist ...`/`formatlist ...` payload. Inside `p vdev/format`, `route vdevlist formatlist` [vdev obj-33] splits those two payload types; each is cleared (`t clear`) then rebuilt one atom at a time via `iter` + `prepend append`, and the two rebuilt lists populate `attrui vdevice` [obj-30] (via `umenu "seancomm-x2 Camera"` [obj-108], a stale-cached device-name list — items `Ultraleap`, `SIPPro9.7` per the last save) and `attrui format` [obj-40] (via `umenu[2]` [obj-41], stale-cached format list e.g. `YUY2 - 422YpCbCr8_yuvs - 1024 x 1024`). `output_texture`/`colormode` are set on `jit.grab` from `attrui` boxes [obj-105, obj-106] as well.

NDI source discovery: `getsourcelist`/`getsourcelistmenu` messages [obj-16, obj-18] → `jit.ndi.receive~` outlet 2 → `route sourcelist sourcelistmenu` [obj-58] → populates `umenu` [obj-59] (stale-cached: `LOCALHOST (Telestripe-1014)`, `IPAD 1687 (NDI HX Camera)`) → `attrui colormode` is separately wired to `jit.ndi.receive~` [obj-45]. A `toggle` "Low Bandwidth" [obj-203] sends `low_bandwidth $1` [obj-196] to the NDI receiver. **PTZ control** (for PTZ-capable NDI sources): buttons "1"–"8" [obj-213…220] each send `ptz_recall_preset N` [obj-140] over `s toNDI`; two sliders [obj-226/227, pan/tilt] pack `ptz_pantilt x y` [obj-225]; a third slider [obj-229] packs `ptz_zoom z` [obj-230] — all on the same `toNDI` bus feeding `jit.ndi.receive~` inlet 0.

### 7.2 Brightness / contrast / saturation (`p brcosaslab` [obj-317])

`r cameragrab` [obj-197] feeds `p brcosaslab`, gated on/off by toggle "BRCOSA adjust" [obj-319] (default **off** — no loadmess sets it). Internally this wraps `jit.gl.pix @gen brcosa` [brcosaslab obj-4], a per-pixel Gen shader (rendered from `brcosa.genjit`):

```
luminance = dot(rgb, vec(0.2125, 0.7154, 0.0721))
saturated = mix(vec3(luminance), rgb, saturation)          // saturation=1 → unchanged; 0 → grayscale
contrasted = mix(vec3(0.62), saturated, contrast)           // contrast=1 → unchanged; pivot gray = 0.62
result.rgb = contrasted * brightness
result.a   = input.a                                        // alpha passed through unmodified
```
i.e. exactly the standard brightness/contrast(around a fixed 0.62 gray pivot)/saturation formula, values are **not** clamped in-shader.

Three live.dials (clipped to **[-2, 2]**) drive `brightness $1` / `contrast $1` / `saturation $1` messages:

| Param | picsvid slider | Default | Comment label |
|---|---|---|---|
| Brightness | slider[6] [obj-322] | **1.55** (`loadmess 1.55` [obj-331]) | "Brt" [obj-328] |
| Contrast | slider[7] [obj-325] | **1.55** (`loadmess 1.55` [obj-333]) | "Cont" [obj-329] |
| Saturation | slider[8] [obj-326] | **1.5** (`loadmess 1.5` [obj-336]) | "Sat" [obj-330] |

All three reset to these same values via the "Reset Keys" button [obj-300] (§7.4). Output is broadcast on **`camRaw`** [obj-193 `s camRaw`].

### 7.3 Keying: alphablendr → luma/chroma → composite

`r camRaw` [obj-257] feeds `vz.alphablendr.maxpat` [obj-252] inlet 0 ("Video1"). Its other populated inlets: inlet 1 ("Video2") receives only `r keyCh2init` (see below — a static backdrop color, not a second live source); inlet 2 ("Video mask") receives the vignette matrix from §6; inlet 3 (alpha-contrast) is initialized to `1.` at load [obj-276]. **`[addition]`** inlet 4 (the module's "mode" control, selecting how the two `mix()` legs of alphablendr's internal `jit.gl.pix` combine — see §6's formula walk-through) is **never fed from picsvid at all**; it defaults to `mode=0` purely via alphablendr's own internal `loadbang`→`t 1 0.`→`live.menu` chain and its `pattr blendmode1` (`restore=[0.0]`), which is what makes the "bright mask reveals camera" reading in §6 the correct one for this patch. **`[?]`** Internally, the value that reaches inlet 3 (alpha-contrast) is itself forked two ways inside `vz.alphablendr.maxpat` — once through a `live.dial` scaled `0–2` and once as a raw, unscaled pass-through — both ultimately feeding the same `contrast $1` message; a load-time `1.` could therefore resolve to an effective contrast of either `1.0` or `2.0` depending on Vizzie's internal `data-handler` firing order, which is not visible in these listings.

Alphablendr's internal `jit.gl.pix` (analysed in §6) luma-mattes between Video1 and Video2 using the mask's luminance; with `mode=0` (default) bright mask pixels reveal Video1 (camera), dark reveal Video2 (backdrop color). Given the flat-white masks described in §6, in practice this likely just crossfades uniformly between camera and backdrop by the (also uniform) `alphacontrast` amount rather than tracing a shape — same caveat as §6.

Alphablendr's output feeds **both** keyer branches, gated exclusively by a single selector:

- **`toggle[14]` "Luma/Chroma"** [obj-150] (default **off** = luma mode): raw value → `s chromaEn`; `!= 1` [obj-265] → `s lumaEn`. So exactly one of `lumaEn`/`chromaEn` is 1 at a time, and the **default is luma keying** (`lumaEn=1`, `chromaEn=0`).
- `r lumaEn` [obj-240] mirrors into local toggle [obj-121], gating both `vz.lumakeyr.maxpat` instances plus the `gate` [obj-263] that lets alphablendr's output into the chain at all when in luma mode.
- `r chromaEn` [obj-243] mirrors into local toggle [obj-97], gating `vz.chromakeyr.maxpat` [obj-26] plus `gate` [obj-264].

**Luma path is a two-stage cascade, not a single key** — `vz.lumakeyr.maxpat` is instantiated *twice* and chained: `obj-48` ("lumakeyr") processes alphablendr's output first, and its result feeds directly into `obj-153` ("lumakeyr[1]") for a *second* pass, whose output finally reaches `s cameragrabpost`. The two passes are parameterized from opposite ends of the same 12-float `keyCtrls` bus (see §7.4), matching the on-screen labels "Lumakey high" (first pass, obj-48) and "Lumakey low" (second pass, obj-153) — i.e. **pass 1 keys out near-white pixels, pass 2 keys out near-black pixels**, leaving only midtones visible. This is a deliberate double-luma-key ("keep only midrange luminance"), not a duplicate/mistake.

**Chroma path** is a single `vz.chromakeyr.maxpat` [obj-26] instance, output → `s cameragrabpost` [via obj-247].

`co.lumakey.jxs` (used inside both `vz.lumakeyr.maxpat` instances, `@param binary 1`) and `co.chromakey.hsv.jxs` (inside `vz.chromakeyr.maxpat`) are the actual keying shaders — see quoted GLSL in §8.

**`keyCh2init`** is the shared "Video2"/backdrop for *all four* keyer module instances (alphablendr, both lumakeyr passes, chromakeyr): a solid-color `jit.matrix alp 4 char 1920 1080` [obj-159], built from four `jit.fill` plane-fills [obj-161=plane0/R, obj-189=plane1/G, obj-192=plane2/B, obj-198=plane3/A], converted to a texture via a *second* `vz.matrix2texture.maxpat` instance [obj-179], and broadcast on `s keyCh2init` [obj-248] whenever bang'd via button [obj-182] (fired once at load by `loadbang` [obj-64]). **The actual per-plane fill values could not be determined from the file** [?] — each plane has a `msg "0"`/`msg "255"` pair pointed at it (R: [obj-253]="0"/[obj-165]="255"; G: [obj-186]="0"/[obj-256]="255"; B: [obj-190]="0"/[obj-255]="255"; A: [obj-195]="0"/[obj-254]="255"), and none of these 8 message boxes has any inbound wiring — they are manually-clicked quick-set buttons (a crude per-channel 0/255 on-off UI, not a real color picker), so the fill color is whatever was last set interactively and saved with the patch. Functionally: **all keyers matte against a static flat backdrop color, not a second live video feed or true alpha transparency.**

**`[addition]` A second, fully dead RGBA literal sits nearby and is worth noting for anyone trying to guess the intended backdrop color**: `msg "0.898039 0.898039 0.898039 1."` [obj-82] (≈ light gray, `229/255` per channel) has no inbound trigger of any kind (its one connection, from `suckah` [obj-62], lands on its cold/right inlet, which does nothing since the message contains no `$1`) and no outbound connection either — fully disconnected on both sides. It cannot be the live `keyCh2init` value (it isn't wired to `jit.fill`/`jit.matrix` at all) but its presence, sitting directly below the parallel local chroma-color swatch cluster described in §7.4, hints an operator was once auto-capturing/pasting a picked color here and never finished wiring it up.

Final composite: `r cameragrabpost` [obj-85] → `gate` [obj-92], enabled by **`toggle[3]` "Enable camera"** [obj-87] (default **off**, no loadmess) → `jit.gl.layer foo` inlet 0 (texture). **Correction — this is not an independently-clicked master switch as originally described**: `r livevid` [obj-120] feeds `toggle[3]` [obj-87] directly (same source line as the USB-toggle link in §7.1), so webUI's `livevid` bus drives "Enable camera" to the *same value it carries*, in lockstep with the USB toggle and the picture-mode `jit.movie` re-bang. In normal operation the camera path is turned on/off as a side effect of whatever sets `livevid` (presumably a "live vs. picture" mode switch in webUI, outside this audit's source set), not by an operator clicking `toggle[3]` in isolation — though the toggle remains independently clickable too, and its value would then be overwritten by the next `livevid` change. Defaulting to off (`livevid` starting at 0, or the toggle's own unset default if `livevid` never fires) matches the user's report that the camera path went largely unused this past year.

### 7.4 Keying parameters (`keyCtrls` bus, 12 floats)

Comment [obj-290]: `// highLuma tol fade lowLuma tol fade ChromaTol fade r g b a`. Built by `pak` (12 inlets, "pak" = outputs on any inlet change per standard Jitter behaviour) [obj-291] → `s keyCtrls` [obj-292]:

| Slot | Meaning | picsvid control | Default | Reset via button [obj-300]? |
|---|---|---|---|---|
| 0 | Lumakey-high target luma | flonum `number[8]` [obj-270] | **1.0** (`loadmess 1.` [obj-181]) | yes |
| 1 | Lumakey-high tolerance | `number[9]` [obj-271] | **0.2** (`loadmess 0.2` [obj-200]) | yes |
| 2 | Lumakey-high fade | `number[10]` [obj-272] | **0.1** (`loadmess 0.1` [obj-210]) | yes |
| 3 | Lumakey-low target luma | `number[13]` [obj-275] | **0.0** (`loadmess 0.` [obj-221]) | yes |
| 4 | Lumakey-low tolerance | `number[12]` [obj-274] | **0.15** (`loadmess 0.15` [obj-212]) | yes |
| 5 | Lumakey-low fade | `number[11]` [obj-273] | **0.1** (`loadmess 0.1` [obj-211]) | yes |
| 6 | Chroma tolerance | `number[14]` [obj-285] | **0.2** (`loadmess 0.2` [obj-304]) | yes |
| 7 | Chroma fade | `number[15]` [obj-286] | **0.2** (`loadmess 0.2` [obj-303]) | yes |
| 8–10 | Chroma key color R,G,B | `swatch[1]` [obj-283], set by HSL `pak` from Hue/Sat/Light sliders [obj-260/267/268] *or* directly by the reset message | reset value **R=0.328129 G=0.144197 B=0.0** (dark orange/maroon) [obj-306], fired only by the Reset button; the HSL-slider-derived idle default at load is a different, unresolved value **[?]** | yes |
| 11 | Chroma key alpha | unused downstream (only R,G,B of this slot are forwarded into `vz.chromakeyr.maxpat`'s color inlets) | n/a | n/a |

Only slots 0–2 feed `vz.lumakeyr.maxpat` obj-48 ("high" pass); slots 3–5 feed obj-153 ("low" pass); slots 6–7 feed `vz.chromakeyr.maxpat`'s tol/fade; slots 8–10 feed its color (R,G,B only — see `co.chromakey.hsv.jxs`, which only reads `color.rgb`).

Button "Reset Keys" [obj-300] fans out to loadmess-equivalents for **all** of the above *and* the three BRCOSA sliders (§7.2) simultaneously — it is a single master reset for the entire camera/keying parameter set, restoring every value to the same defaults the patch loads with. Verified: its 12 outbound connections cover exactly loadmess-slots 0–7, the color-reset message [obj-306], and the 3 BRCOSA sliders — no more, no fewer.

**`[correction — major, missed entirely by the original pass]` `vz.chromakeyr.maxpat`'s five parameter inlets (2–6: R, G, B, tol, fade) are each fed from *two* independent, uncoordinated sources, not one** — the same "whichever fired last wins" hazard already flagged for the layer's `enable` attribute in §4, but here it applies to the entire chroma-key color+tolerance+fade set and the original author's audit did not find it:

1. The `keyCtrls`-bus path documented above: `unpack` [obj-297] slots 6,7,8,9,10 → chromakeyr inlets 5,4,2,3,4 respectively (as tabulated). *(Corrected inlet indices — see below.)*
2. **A second, entirely separate local control cluster sitting immediately above the `chromakeyr` bpatcher in the patcher layout**, wired directly to the *same* inlets and **never touched by the "Reset Keys" button**: five plain number boxes — `number[3]` (R) [obj-135] → inlet 2, `number[4]` (G) [obj-142] → inlet 3, `number[2]` (B) [obj-134] → inlet 4, `number[5]` (Tol) [obj-232] → inlet 5, `number[6]` (Fade) [obj-233] → inlet 6. The three color numbers are themselves driven by `unpack 0. 0. 0.` [obj-60] ← swatch `swatch` [obj-55] (an interactive color-picker UI object with no visible external driver — its value is whatever was last clicked/saved, unrecoverable from this static listing, same caveat as `swatch[1]` [obj-283]); `swatch` [obj-55] is itself fed by `prepend rgba` [obj-76] ← `suckah` [obj-62], which has **no inbound connection at all** — so that particular feed path is dead, and `swatch` [obj-55]'s value comes only from direct user interaction. `number[5]`/`number[6]` (Tol/Fade) have **no inbound wiring whatsoever** — not even a loadmess — they are pure manual-entry fields.

Net effect for a port: whichever of these two paths the operator (or a `loadbang`/Reset click) touched *most recently* is what chromakeyr actually keys against; the "Reset Keys"-driven `keyCtrls` values documented in the table above are **not** guaranteed to be what's live if this local cluster was ever touched after load. A straight port should treat chroma color/tol/fade as a single set of 5 values with one source of truth, not reproduce the duplicate wiring.

**Corrected inlet map** (verified against `vz.chromakeyr.maxpat`'s own inlet objects, ordered left-to-right by x-position): inlet 0 = Video1 (texture), inlet 1 = Video2/backdrop (texture), inlet 2 = key-color R, inlet 3 = key-color G, inlet 4 = key-color B, inlet 5 = tol, inlet 6 = fade.

## 8. Keying shaders (quoted verbatim)

### `co.lumakey.jxs` — used by both `vz.lumakeyr.maxpat` passes

Params: `luma` (target luminance, default 0.0), `tol` (default 0.3), `fade` (default 0.), `lumcoeff` (vec4, default `0.299 .587 0.114 0.`), `invert` (default 0.0), `mode` (default 0.0 — 0=blended composite, 1=mask-only output), `binary` (default 0.0 — 0=alpha-only, 1=mix with second source), `tex0`/`tex1`.

```glsl
vec4 a = texture2DRect(tex0, texcoord0);   // Video1 (the thing being keyed)
vec4 b = texture2DRect(tex1, texcoord1);   // Video2 (backdrop, here = keyCh2init)

float luminance = dot(a, lumcoeff);
float delta = abs(luminance - luma);
float scale = smoothstep(abs(tol), abs(tol) + abs(fade), delta);  // 0 near target luma, 1 far from it
float mixamount = mix(scale, 1. - scale, invert);

vec4 result = mix(b, a, vec4(mixamount));   // composite a-over-b using mixamount as alpha
a.a = mixamount;
result = mix(a, result, vec4(binary));      // binary=0 → just output a with alpha=mixamount; binary=1 → composited result
gl_FragColor = mix(result, vec4(mixamount), vec4(mode));  // mode=1 → output the mask itself, not the image
```
`vz.lumakeyr.maxpat`'s own `jit.gl.slab` instantiation is `jit.gl.slab @file co.lumakey.jxs @param binary 1 @param fade 0.05 @param tol 0.05` [lumakeyr obj-35] — so its default behavior is the **composited** result (`b` where keyed-out, `a` where kept), not a bare alpha-only pass, **and** its baked-in startup `tol`/`fade` (0.05/0.05) differ from both the shader's own XML-declared defaults (`tol` 0.3, `fade` 0.) and picsvid's `keyCtrls` loadmess values (§7.4 table) — irrelevant once the patch finishes loading and the `keyCtrls` bus fires (it overwrites these), but the true value for the few milliseconds between object instantiation and the `keyCtrls` loadbang chain firing is 0.05/0.05, not the shader's 0.3/0.

**Correction:** `vz.chromakeyr.maxpat`'s own `jit.gl.slab @file co.chromakey.hsv.jxs` instantiation [chromakeyr obj-35] carries **no** `@param` overrides — it uses the shader's own XML defaults (`tol` 0.3, `fade` 0., `color` `0 0 0 0`) until either wiring path in §7.4 fires.

### `co.chromakey.hsv.jxs` — used by `vz.chromakeyr.maxpat`

Params: `tol` (default 0.3), `fade` (default 0.), `color` (vec4 target, default `0 0 0 0`), `tex0`/`tex1`.

```glsl
vec3 rgb2hsv(vec3 rgb) { /* standard RGB→HSV, hue in [0,1) */ }

vec4 a = texture2DRect(tex0, texcoord0);
vec4 b = texture2DRect(tex1, texcoord1);
float len = length(vec3(4., 1., 2.) * (rgb2hsv(color.rgb) - rgb2hsv(a.rgb)));  // weighted HSV distance (H weighted 4x)
float scale = smoothstep(abs(tol), abs(tol) + abs(fade), len);
gl_FragColor = mix(b, a, scale);   // scale≈0 near target color → shows b (backdrop); far → shows a
```
Only `color.rgb` is read — the color's alpha component (`keyCtrls` slot 11) is irrelevant to the math, consistent with it not being wired through in §7.4.

## 9. Vestigial / disconnected elements (do **not** port)

- **`obj-116` standalone `jit.gl.slab @file co.lumakey.jxs`** in the main patcher (distinct from the two working instances inside `vz.lumakeyr.maxpat`), with its own live.dials for luma/tol/fade [obj-81/86/84], invert/mode toggles [obj-126/127], and "Binary" toggle [obj-119]: every one of these only sends `prepend param` messages into obj-116's parameter inlet. **Nothing feeds obj-116 a texture on either inlet, and its output goes nowhere.** A fully-built, fully-controllable, but entirely unwired duplicate lumakey slab — leftover from an earlier iteration, superseded by the `vz.lumakeyr.maxpat` instances actually in the signal path.
- **Drag-and-drop folder loader**: `dropfile` [obj-63], comment "// drop a folder here!" [obj-56], `folder input/transparent-background/` (a real `folder`-class object, distinct from the umenu's autopopulate) [obj-5], and message `"input/transparent-background/"` [obj-68] — `dropfile` feeds obj-5 and obj-68, but **neither has any outbound connection**. Dead UI affordance.
- **Dead receives** (per the cross-reference; no sender anywhere in the codebase): `r ---bypass` [chro obj-50, and equivalently inside each Vizzie module's own bypass gate] — always floats, meaning the `gate 1 1` boxes it feeds are permanently open (functionally a no-op bypass that can never trigger); `r 2dfft4x` [obj-23], `r scope2011` [obj-50], `r waterfall` [obj-157] — three receivers with no corresponding `send` anywhere in the patch family; these look like leftovers from an audio-visualization feature that was removed or never finished. All three are effectively inert.
- **`feedbax_sticker_prefix`** bus (pathsetup obj-12) — sent once at load, **received nowhere**.
- Stale cached umenu item lists (camera device names, NDI sources, format lists, the 105-file sticker list) are snapshot data from whatever was connected/scanned when the patch was last saved — not meaningful defaults, just leftover UI state.
- `feedbax.picsvid`'s own `p chro` subpatcher [obj-147] is a largely orphaned copy of chroma-key preview plumbing (`pattr keycolor`, swatch, a `jit.gl.slab @file co.chromakey.hsv.jxs`) with `io=0/0` at its call site — **it has no inlets or outlets wired from the parent patch at all**; whatever it does is fully self-contained and disconnected from the rest of the module. Included here for completeness but not part of the live signal path.
- **`[addition]` `draw $1` / `drawimmediate $1` / `drawraw $1` message boxes [obj-209, obj-222, obj-242]** wired into `jit.gl.layer foo`'s inlet 0: these have **zero inbound connections** (verified against every line in the connection list) — not from a button, not from a loadmess, nothing. Since each needs a `$1` argument to be a valid message and nothing ever supplies one, they cannot even be usefully hand-clicked at runtime. Fully dead, more so than the original doc's "debug/one-off trigger" framing suggested.
- **`[addition]` `route int folder` [pic obj-4]'s "int" match outlet (outlet 0)** is never connected to anything inside `p pic` — bare integers reaching this route (if any ever did) go nowhere. Sticker selection by index instead happens entirely via the separate `r movSel` receive (§2 item 2/3), which bypasses this route object altogether.

## 10. Frame-level pseudocode (for a port)

```
// Once at load / on folder-path bus:
stickerFiles = scanFolder(feedbax_root + "input/transparent-background/", 
                           types=[mov,mpg,wmv,pict,png,gif,tiff,bmp])
broadcast movsFound = stickerFiles.length

// On sticker selection (umenu click, drag-drop, or movSel index from UI):
selectedFile = stickerFiles[index]              // or the clicked/dropped file
currentStickerTexture = decodeFirstFrame(selectedFile)   // jit.movie "read"; re-decode-on-demand only —
                                                            // NOT re-decoded every render frame

// Camera (only if cameraType != none):
if cameraType == USB:  rawCamTex = usbGrab.nextFrame()      // re-grabbed once per imgbang if "continuous" toggle on
if cameraType == NDI:  rawCamTex = ndiReceive.currentFrame()
camTex = brcosaEnabled ? brcosa(rawCamTex, brightness, contrast, saturation) : rawCamTex   // brcosaEnabled default OFF

backdrop = solidColor(keyCh2initRGBA)             // static, operator-set fill color, not a second video feed
vignette = alphaMaskMatrix                        // "Full Alpha" (opaque) or "Circle Alpha" (radial), RGB always white —
                                                    // only affects alphablendr's luminance mix if the matte math is fixed
alphaBlended = lumaLerp(camTex, backdrop, luminance(vignette, contrast=alphaContrast), mode=0)

if lumaEn:                                        // default true
    stage1 = lumaKey(alphaBlended, backdrop, lumaHigh, tolHigh, fadeHigh, binary=true)   // key out near-white
    cameraComposite = lumaKey(stage1,       backdrop, lumaLow,  tolLow,  fadeLow,  binary=true)  // key out near-black
elif chromaEn:
    // NOTE (correction): chromaColorRGB/chromaTol/chromaFade each have TWO independent live sources in the
    // original patch (the keyCtrls bus AND a separate un-busbacked swatch/number cluster feeding the same
    // shader inlets) — whichever was touched most recently wins. Pick ONE source of truth for a port. See S7.4.
    cameraComposite = chromaKey(alphaBlended, backdrop, chromaColorRGB, chromaTol, chromaFade)

// Each render frame (on imgbang):
layerTexture = cameraEnabled ? cameraComposite : currentStickerTexture   // last-writer-wins in the original patch;
                                                                            // a port should make this an explicit choice
// NOTE (correction): cameraEnableToggle and the USB-capture toggle are not independent operator switches — both
// are also driven directly, in lockstep, by the webUI "livevid" bus (see S7.1/S7.3). Model livevid as the real
// live/picture mode switch and derive these two booleans from it, rather than treating them as separately clicked.
layerEnabled = imageMoveEnableBit || cameraEnableToggle   // "Enable camera" default OFF, imageMove enable default OFF
draw jit.gl.layer(layerTexture, position, scale, rotateZ, blend_mode, blend_enable, layer=2, enabled=layerEnabled)
```

## 11. Sticker-related message/bus reference table

| Bus / message | Direction | Payload | Producer | Consumer |
|---|---|---|---|---|
| `feedbax_sticker_folder` | send/receive | `folder <path>` | pathsetup [obj-7/8] | `p pic` [obj-recv-sticker-folder] |
| `feedbax_as_sticker_folder` | send/receive | `folder AS <path>` (likely broken, §1) | pathsetup [obj-9/10] | `p pic` [obj-recv-as-folder] |
| `feedbax_sticker_prefix` | send | `prefix <path>` | pathsetup [obj-12] | **none — dead** |
| `movSel` | send/receive | int, index (both declared `max=53`, but see correction) | webUI incdec [webui obj-69] (unverified, outside audit scope); **also picsvid's own local `incdec` [obj-65] → `number[1]` [obj-61] → `s movSel` [obj-69]**, whose `max` is dynamically reset to the live `movsFound` count via `prepend max` [obj-66] and whose value resets to 0 on rescan / on `livevid`→0 (§2 item 3) — this local copy is **not** a hardcoded, un-synced ceiling the way the original doc implied | `p pic` umenu [pic obj-72] |
| `movsFound` | send/receive | int (scan result count) | `p pic` autopopulate [obj-71] | picsvid display [obj-57] **and** picsvid's own `movSel` ceiling/reset chain (see above); webUI range display [webui obj-70] (unverified) |
| `livevid` | send/receive | 0/1 toggle | webUI (unverified, outside audit scope) | **`[correction]`** fans out to **three** destinations, not one: `sel 0` [obj-51] → re-bangs `jit.movie` (and resets local `movSel` index to 0) on transition to 0; `toggle[1]` "USB" [obj-160] directly (same value); `toggle[3]` "Enable camera" [obj-87] directly (same value) — see §7.1/§7.3. |
| `imageMove` | send/receive | 10 floats `[enable,x,y,0,zx,zy,0,0,0,r]` | webUI, gated on `ctrlbang`/toggle [webui obj-8/44] (unverified) | picsvid zl-slice decode [obj-35..38] → `jit.gl.layer foo` |
| `imgbang` | receive (in this file) | bang | main patch (per-frame clock) | re-bangs `jit.grab` (USB, via gate [obj-13], when toggle[2] "continuous-grab" on); **`[correction]`** re-bangs `jit.ndi.receive~` (NDI, via gate [obj-25]) — NOT a direct layer-redraw trigger as originally stated; NOT wired to `jit.movie` |
| `cameragrab` | send/receive | texture ref | USB `jit.grab` [obj-17→188] or NDI `vz.matrix2texture` [obj-133/143] | `p brcosaslab` [obj-197] |
| `camRaw` | send/receive | texture ref | `p brcosaslab` [obj-193] | `vz.alphablendr` Video1 [obj-257→252] |
| `usbcam` | send/receive | 0/1 (camera-type = USB) | toggle "USB" [obj-160] | auto-sets grab-enable toggles, triggers device open [obj-74/145] |
| `toNDI` | send | PTZ/bandwidth/source-select messages | PTZ preset/pan-tilt-zoom buttons+sliders, low_bandwidth toggle | `jit.ndi.receive~` [obj-1] |
| `keyCh2init` | send/receive | texture ref (static color fill) | `vz.matrix2texture` #2 [obj-179/248] | all 4 keyer module "Video2" inlets |
| `keyCtrls` | send/receive | 12 floats (§7.4) | `pak` [obj-291/292] | 4 keyer module instances (split by slot). **`[correction]`** for `vz.chromakeyr.maxpat`'s R/G/B/tol/fade inlets (2–6) specifically, this bus is only *half* the story — a second, un-busbacked local number/swatch cluster feeds the identical inlets directly; see §7.4. |
| `lumaEn` | send/receive | 0/1 | `toggle[14]` via `!=1` [obj-150/265/223] | both `vz.lumakeyr` instances + gate [obj-121/263] |
| `chromaEn` | send/receive | 0/1 | `toggle[14]` [obj-150/234] | `vz.chromakeyr` + gate [obj-97/264] |
| `cameragrabpost` | send/receive | texture ref (final keyed composite) | `vz.lumakeyr[1]` [obj-83] or `vz.chromakeyr` [obj-247] | final gate → `jit.gl.layer foo` [obj-85/92] |

---

## Open questions / things the listing cannot tell us

1. **`"folder AS ..."` messages** — does Max's umenu actually tolerate the extra leading `AS` token in the `prefix` message, or does this silently break the alternate-folder scan? Needs testing inside Max, or a look at whether `feedbax_as_sticker_folder` is ever used for anything different in practice (e.g. maybe it's meant to target a *different* folder that was never actually parameterized — the sprintf format string is hardcoded identically to the plain variant, which itself looks like it could be a bug/copy-paste leftover in `pathsetup`).
2. **`vz.alphablendr`'s mask input reading only RGB, never alpha** — given both bundled overlay assets vary *only* in alpha, the module as wired appears to produce a spatially-uniform result regardless of which mask is loaded. Either this reading of the Gen graph is wrong, the "shape" effect was never actually working live, or there's a piece of the puzzle (a different `jit.gl.pix` variant, or the matrix being re-planed before reaching the shader) not visible in this static analysis. Worth confirming against actual show footage/recollection if available.
3. **`keyCh2init`'s actual fill color** — the four `jit.fill` plane-set messages have no inbound wiring, so the real default backdrop color the keyers matte against is whatever was last interactively set and saved in the patch's runtime state, which the .maxpat JSON (as captured by our listing tool) doesn't expose.
4. **Chroma key color's true load-time default** — resolvable only to "whatever HSL(0,1,1) computes to, unless the swatch's own persisted UI color overrides it" versus the well-defined Reset-button value (R=0.328, G=0.144, B=0). Needs opening the patch in Max to read the swatch's live/saved color.
5. **Does `jit.movie` actually animate movies frame-by-frame in practice?** No `imgbang`-driven bang into `jit.movie` was found; only file-selection and the `livevid==0` transition re-trigger it. If real movie (not still-image) stickers were used live, there must be a frame-advance mechanism not captured here (e.g. `jit.movie`'s own internal auto-rate once opened, or a message not distinguishable from the "read" trigger in this text listing).
6. **`jit.gl.layer foo`'s attrui-controlled attributes' actual defaults** (`blend_mode`, `blend`, `blend_enable`, `interp`, `automatic`, `capture`) — none are set in the object's instantiation text nor via any loadmess in this file, so effective defaults are whatever Jitter's built-in `jit.gl.layer` defaults are; not independently verifiable from the listing.
7. **`p chro` [obj-147] subpatcher** — instantiated with zero inlets/outlets wired to its parent; unclear whether it's genuinely dead code or whether Max patchers of this kind can still receive/send via internal `r`/`s` buses not visible as inlet/outlet connections (it does contain `r ---bypass`, itself a dead receive) — treated as vestigial here but flagged in case it turns out to matter.
8. **`[new]` What actually feeds `p pic`'s inlet with a non-`folder`, non-`int` message?** The continuous/analog sticker-selector path in §2 item 4 (`data-handler`→`scale`→umenu) requires *something* upstream of `p pic` to send such a message, but nothing in `feedbax.picsvid`'s own main patcher does so — the only things wired into `p pic`'s inlet are the `folder ...` messages and the two `receive` objects. The source is presumably in `feedbax.webui` (e.g. a `mira` touch/slider control), which is outside this audit's given file set.
9. **`[new]` `vz.chromakeyr.maxpat`'s two parallel color/tol/fade sources (§7.4)** — which one is actually authoritative in practice (i.e., which was touched most recently in the saved patch state) cannot be determined from a static listing; this needs to be resolved by opening the patch in Max and checking both the `keyCtrls`-driven flonums and the local `number[2..6]`/`swatch` cluster's live values.
10. **`[new]` `vz.alphablendr`'s internal contrast double-path (§7.3)** — whether the load-time `alphacontrast=1.` ultimately resolves to shader `contrast=1.0` or `2.0` depends on `data-handler`'s (a compiled Vizzie object, internals not available to this audit) exact output-firing order, which cannot be determined from the given listings.
11. **`[new]` webUI's internals** — every claim in this document sourced from `feedbax.webui` (the `movSel`/`imageMove` producers, the `mira.mt.centroid`→`scale` touch mapping mentioned in §4, the `livevid` toggle's own UI, `movsFound`'s webUI-side display) is carried over from the original author's pass essentially unverified by this audit: `feedbax.webui`'s listing was not part of the source set given for this correction pass (only the `feedbax.picsvid.maxpat` listing, the four Vizzie bpatcher listings, the two `.jxs` shaders, and `brcosa.genjit` were). Treat any `[webui obj-N]` citation in this document as inherited, not independently re-checked here.

### Audit notes (verification pass)

Every concrete claim in this section was re-checked line-by-line against the object/connection listings in the `feedbax.picsvid.maxpat` listing (main patcher + `p pic`, `p brcosaslab`, `p chro`, `p vdev/format` subpatchers), the `vz.alphablendr.maxpat` listing, the `vz.lumakeyr.maxpat` listing, the `vz.chromakeyr.maxpat` listing, the `vz.matrix2texture.maxpat` listing, `co.lumakey.jxs`, `co.chromakey.hsv.jxs`, and `brcosa.genjit`, plus the bus cross-reference (`docs/spec/06-bus-reference.md`) for cross-file bus direction. Corrections made:

1. **[major]** `feedbax.picsvid`'s own `toggle[3]` "Enable camera" [obj-87] and `toggle[1]` "USB" [obj-160] are both driven directly by `r livevid` [obj-120], not clicked independently as the original text implied — the camera path is effectively a side effect of whatever sets webUI's `livevid` bus, not three separately-operated switches (§7.1, §7.3, §11 table).
2. **[major]** The NDI `imgbang`-gated redraw trigger [obj-25 gate] feeds `jit.ndi.receive~`'s own inlet 0 (re-banging it for a new frame, the NDI counterpart of the USB `jit.grab` re-bang), **not** `jit.gl.layer foo` as originally stated (§7.1, §11 table).
3. **[major]** The device/format enumeration causal chain was backwards: `p vdev/format` [obj-107] is fed from `route device_added device_removed device_format`'s **reject** outlet (the actual `vdevlist`/`formatlist` query responses), not from the three matched device-change-notification outlets, which instead just re-fire a `getvdevlist` refresh (§7.1).
4. **[major]** `vz.chromakeyr.maxpat`'s five color/tolerance/fade inlets (2–6) are fed by **two** independent, uncoordinated sources — the documented `keyCtrls` bus **and** a second, previously unreported local number-box/swatch cluster sitting next to the module in the patcher, which the "Reset Keys" button never touches. This was missed entirely in the original pass (§7.4, §10, §11 table, Open Question 9).
5. **[major addition]** A third sticker-selection mechanism exists: a continuous 0–1 value entering `p pic`'s inlet on `route int folder`'s reject branch is rescaled (via a `scale` object whose `hi2` bound is dynamically tied to the live item count) directly into the umenu's index inlet. The original doc only described click/drag and the `movSel` bus (§2 item 4, Open Question 8).
6. **[correction]** `feedbax.picsvid` itself sends on the `movSel` bus via a local `incdec`/`number[1]` pair whose ceiling is **dynamically** resized to `movsFound` and which resets to 0 on rescan/`livevid`→0 — contradicting the original blanket claim that the 0–53 ceiling is "not dynamically tied to `movsFound`" (that claim may still hold for webUI's own copy, which is outside this audit's source set) (§2 item 3, §11 table).
7. **[correction]** `draw $1`/`drawimmediate $1`/`drawraw $1` [obj-209/222/242] have **zero** inbound connections — not "wired to buttons/UI" as stated; they are fully dead, moved into §9.
8. **[addition]** `vz.lumakeyr.maxpat`'s `jit.gl.slab` instantiation also carries `@param fade 0.05 @param tol 0.05` (in addition to the already-noted `@param binary 1`), overriding the shader's own XML defaults until `keyCtrls` fires; `vz.chromakeyr.maxpat`'s instantiation carries no such overrides (§7.4/§8).
9. **[addition]** `t b s` [obj-54] and `t b i` [obj-139] trigger orderings were made explicit (right-to-left firing) since both feed a shared downstream inlet/object where order determines the outcome (§3, §4).
10. **[addition]** `keyCh2init`'s four `jit.fill` planes were mapped to R/G/B/A explicitly; a fully-dead, disconnected RGBA literal [obj-82] sitting near the parallel chroma-swatch cluster was flagged (§6).
11. **[addition]** `route int folder`'s unused "int" outlet inside `p pic`, and `vz.alphablendr`'s unconnected "mode" inlet (defaulting internally to `mode=0`, confirming the §6 luminance-mix reading) were noted (§7.3, §9).

**Verified accurate, no changes needed:** the `co.lumakey.jxs`, `co.chromakey.hsv.jxs`, and `brcosa.genjit` formula quotes in §7.2/§8 are byte-for-byte faithful to the source files; the alphablendr luminance-only masking claim (§6) checks out against its `jit.gl.pix` gen graph; the `zl slice` cascade decoding `imageMove` (§4); the USB device-open auto-sequence (§7.1); the alpha-mask loader trigger table (§6); and the "Reset Keys" button's 12-target fan-out (§7.4) were all confirmed exactly as described.

**Residual uncertainties (could not be resolved from the given static listings):** the true saved/interactive default values of every `swatch`/color-picker object (`swatch[1]` [obj-283], the local chroma swatch [obj-55], `keyCh2init`'s `jit.fill` plane values); which of chromakeyr's two parallel parameter sources was live in the saved patch state; Vizzie's `data-handler` internal output-firing order (affects the alphablendr contrast double-path); and everything sourced from `feedbax.webui`, whose listing was outside this pass's given source set.
