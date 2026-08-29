# Why the repo didn't run — diagnosis, fixes, and what's left (2026-08-23)

Reports being investigated:

1. nobody has been able to get Feedbax to work the way Sean did;
2. Sean "never got it working right with Max 9";
3. "earlier versions might work better than the latest one";
4. "I haven't gotten the actual feedback loop to run yet … `td.rota.jxs` in the shader patch
   shows up as broken."

Everything below was established by reading the patch JSON with `tools/maxpat2txt.py` /
`tools/maxdiff.py`, by diffing the repo against Sean's archive (`/Volumes/Space/Max2Newmini2024`),
and by opening the patches in **Max 8.6.5 on this machine** (Apple Silicon, native, unlicensed
"runtime" mode, default `gl3` engine) with probe patches that print to the Max Console. Max 9 was
not available to test.

> **Update 2026-08-23 (later the same day): Max 9.1.5 is now installed, and the capture retrofit
> (finding G) has been built and validated — the feedback loop runs on Max 9's `glcore` engine.**
> See the new section [Max 9 retrofit — built and validated](#max-9-retrofit--built-and-validated)
> at the end of this document. The summary row for G, "What was changed", and "What's left" below
> have been updated accordingly.

## Summary

| # | finding | status |
|---|---|---|
| A | The repo is a faithful split of Sean's `v123DeployabilityCleanup` (Max 9, Oct 2025). The only differences are the intended path edits. The split did not break anything. | verified (structural diff) |
| B | `td.rota.jxs`, `cc.scalebias.jxs`, `co.*.jxs`, `brcosa.genjit` and all Vizzie modules ship with Max 8 and 9 on the default search path. Nothing is missing. `td.rota` loads without error here. | verified |
| C | **`feedbax.pathsetup` never worked**: `thispatcher` answers `path` on its *right* outlet as a bare symbol, the patch listened on the left outlet through `route path`; and `sprintf symout folder %s…` baked the selector into one symbol so `route folder` in `p pic` could never match. Result: `feedbax_root` unset, sticker menu never populated. | **fixed**, verified |
| D | `loadbang → "folder input/transparent-background/"` (relative path) in picsVid → `umenu` error "not a folder". | **fixed** (buttons now re-trigger pathsetup) |
| E | `importmovie NormalFullAlpha1080p1.png` fails unless `assets/` is on Max's search path (README told users to add it by hand). | **fixed**: pathsetup now appends `<root>/assets` to the search path at load |
| F | On a fresh load the feedback path is **closed**: `[switch 2]` that gates the captured texture into `shaderfx` starts closed, and `usetexture fst/dst` is only sent when the FS toggle changes. Sean's ritual included toggling fullscreen. | **fixed** (`loadmess 0` → FS toggle), effect verified |
| G | **Root cause of "the feedback loop doesn't run"**: the capture uses the legacy `usetexture`/`to_texture` messages, which are silent no-ops under the `gl3`/"glcore" engine (Max 8.6 default, Max 9 only option). Max prints `copy_texture is obsolete when using the glcore engine` for the attribute form; the message form prints nothing. **Sean's Max 8 preferences use the legacy `gl2` engine.** | verified; **retrofit to `jit.gl.node @capture 1` built and validated on Max 9.1.5 — feedback loop runs.** See [Max 9 retrofit](#max-9-retrofit--built-and-validated) |
| H | Sean kept performing from Max 8.6.5 builds (`v116jamianXUIipadupgrade`, `v120…`, `v122debuggingisg`, Aug–Sep 2025, with a Finder alias pointing at v116). The Max 9 "DeployabilityCleanup" line (v121–v123, Jun–Oct 2025) was a parallel cleanup that dropped brightness/contrast/saturation from the chain and replaced the manual Leap/iPad switch with an automatic 2-s timer. | verified (archive diffs, `docs/spec/05`) |
| I | Optional externals absent here: `shell` (StillSave screenshots), `ultraleap` (Leap), `jit.ndi.receive~` (NDI camera). Harmless. | verified |

"`td.rota.jxs` shows up as broken" was almost certainly a reading of symptom **G** (the slab
object looks fine; its *output* never appears because its input texture is never filled).

## Evidence

### A. Repo vs. v123, and v123 vs. Sean's last Max 8 builds

`tools/maxdiff.py "<archive>/2025 Feedbax gl + image v123DeployabilityCleanup.maxpat::shaderfx" patches/feedbax.shaderfx.maxpat`
is identical; the same holds for sound2, webUI, LeapGemini, misc. picsVid and StillSave differ only in
the replaced `/Users/sean/...` paths. Main patch: identical apart from `p X` → `feedbax.x`.

`v122debuggingisg` (Max 8, 2025-09-20) → `v123` (Max 9): in `shaderfx` the two cords
`jit.gl.pix → jit.gl.pix @gen brcosa → outlet` were removed and `jit.gl.pix → outlet` added; the
manual `r leapOverrideUI` selector became the `leap2HandsActive`/`timer`/`< 2000` watchdog; webUI
lost its "Use Leap Motion" toggle. Nothing else of substance. Full chain of diffs: `docs/spec/05`.

### C/D/E. Path resolution (Max Console, probe patch printing the buses)

Before the fix a probe receiving `feedbax_sticker_folder`, `movsFound` and `v feedbax_root`
printed nothing; a minimal `loadbang → path → thispatcher → print` printed only on the **right**
outlet: `"Macintosh HD:/…/scratchpad/"` (no `path` prefix). `regexp (.+[\\/]).+[\\/]$ @substitute %1`
emits the parent folder as one symbol on outlet **1** (outlet 0 splits it at the space in
"Macintosh HD").

After the fix (with one PNG in `input/transparent-background/`):

```
PROBE_ROOT          • "Macintosh HD:/Users/mindlace/Projects/feedbax/.claude/worktrees/spec-and-diagnosis/"
PROBE_STICKERFOLDER • folder "Macintosh HD:/…/input/transparent-background/"
PROBE_MOVSFOUND     • 1
```

and the `can't find file NormalFullAlpha1080p1.png` error is gone (the `[filepath search]`
`append <root>/assets 1` runs from pathsetup's `loadbang`, which fires before picsVid's).

### F. Feedback path closed at load

Main patch: `[obj-39] toggle "FS"` → `[obj-38] + 1` → `[obj-37] switch 2` (selector; `switch` starts
at 0 = closed) and `[obj-34] sel 0 1` → `usetexture dst|fst` → `jit.gl.render`. Neither fires until
the toggle is touched. Sending `; fs 0` from a probe opened the path (the main videoplane started
drawing — under `gl2` it showed Jitter's placeholder checkerboard, i.e. an *empty* texture, rotated
by the injected `theta`).

Fix applied: `[loadmess 0]` (`obj-fs-init`) → `[obj-39]` in `Feedbax.maxpat`, which sends
`usetexture dst`, opens `switch 2` on input 1 (dst) and sends `fullscreen 0` at load. (On a `gl3`
install this only matters once the capture is retrofitted — see below.)

### G. The capture mechanism

Minimal test patch (`jit.window`/`jit.gl.render`/`jit.gl.texture @name captex`/seed circle/
feedback `jit.gl.videoplane @texture captex @rotatexyz 0 0 5`; per frame `erase`, draw, `bang`,
then capture):

| capture variant | gl3 (default here) | gl2 |
|---|---|---|
| `usetexture captex` once, `to_texture` per frame (Sean's) | no feedback, black | placeholder checkerboard (texture never written) |
| `to_texture captex` per frame | — | placeholder checkerboard |
| `copy_texture captex` attribute | console: **`jit.gl.render • copy_texture is obsolete when using the glcore engine`**, no feedback | — |

`usetexture`/`to_texture` appear only in Max's *obsolete* example folder; `jit.gl.render`'s Max 8
reference lists neither. Sean's preferences (`/Volumes/Space/Library/Application Support/Cycling
'74/Max 8/Settings/maxpreferences.maxpref`) contain `"glengine" : "gl2"`; his search path included
`~/Pictures/StickersWithAlphaCh` (where the alpha-mask PNGs also lived). Every patch he saved
records `"architecture": "x64"`, which *may* mean Max ran under Rosetta on his M4 mini (Intel
OpenGL path); Rosetta is not installed here so that could not be tested, and the field is not
conclusive (Cycling's own bundled help files carry the same value).

Why gl2 capture also failed on this machine is not established — candidates are the
Apple-Silicon-native GL driver vs. Rosetta/Intel, and `@doublebuffer` (the `jit.window` creation
string sets it to 0 then a `loadmess doublebuffer 1` turns it back on; `to_texture` reads the
back buffer after the swap). If you want to reproduce Sean's exact environment before retrofitting:
Max 8.6.5, Preferences → GL Engine = `gl2`, **Open using Rosetta** ticked on Max.app (requires
`softwareupdate --install-rosetta`), then toggle FS once after load.

## What was changed in this branch

* `patches/feedbax.pathsetup.maxpat` — rewritten (15 boxes): `loadbang`/`r feedbax_rescan` →
  `path` → `thispatcher` **right outlet** → `regexp … @substitute %1` **outlet 1** → `value feedbax_root`;
  `sprintf symout %sinput/transparent-background/` → `prepend folder` → `send feedbax_sticker_folder`;
  `sprintf symout %sassets` → `prepend append` → `append 1` → `filepath search`. The never-working
  `feedbax_as_sticker_folder` and the dead `feedbax_sticker_prefix` sends were removed.
* `patches/feedbax.picsvid.maxpat` — the seven `folder input/transparent-background/` /
  `folder AS …` message boxes are now `; feedbax_rescan bang` buttons (the loadbang'd one re-runs
  pathsetup at load, the others are manual "rescan folder" buttons); their dangling outlet cords and
  the `receive feedbax_as_sticker_folder` box were removed; the `[folder input/…]` object behind
  "drop a folder here!" lost its bogus argument. No change to any signal-path object.
* `patches/Feedbax.maxpat` — the `loadmess 0` → FS toggle (finding F), **plus the finding-G
  capture retrofit** (see the [Max 9 retrofit](#max-9-retrofit--built-and-validated) section for
  the exact object/cord edits): a `jit.gl.node foo @name fb @capture 1` and a display
  `jit.gl.videoplane foo` were added, the main feedback plane was reparented into the node, the
  shader chain's input was moved from the dead `switch 2` to the node's captured-texture outlet,
  the obsolete `to_texture`/per-frame plane-bang cords were cut, and the `erasetransparency` and
  `resolution` buses were re-pointed at the node.
* `patches/feedbax.picsvid.maxpat` — the image/sticker/camera `jit.gl.layer` reparented into the
  `fb` capture node (context `foo` → `fb`, `@automatic 1`) so its output is part of the feedback.
* `patches/feedbax.sound2.maxpat` — the two waveform `jit.gl.graph` objects reparented into `fb`
  the same way (`@automatic 1`, `@layer 3`).
* `tools/maxedit.py` — new: surgical, diff-friendly `.maxpat` JSON editor (Max can't save in
  runtime mode, so fixes are applied to the JSON directly).
* `docs/spec/*`, this file.

The GL/render path change is exactly the finding-G retrofit above; the legacy `fst`/`dst`
textures, `switch 2`, `gswitch2` and `usetexture` message boxes were left in place but
disconnected (vestigial) to keep the diff legible and the lineage against Sean's archive visible.

## What's left to make it run on a stock Max 8.6 / Max 9 install

1. ~~**Replace the capture** (finding G) with `jit.gl.node`.~~ **Done and validated on Max 9.1.5**
   — see [Max 9 retrofit — built and validated](#max-9-retrofit--built-and-validated) below.
2. **Trail-fade parity (fidelity follow-up).** On gl2, `erasetransparency` drove a *blended*
   framebuffer erase (`framebuffer = mix(old, black, α)`, α∈[0.8,1.0]) that fades the trails. The
   `jit.gl.node` erase is a *full clear* of its FBO; persistence now comes from the feedback plane
   redrawing the previous frame (as in the probe). `erasetransparency` is currently routed to the
   node's `erase_color` alpha, which is the closest analog but does not reproduce the old
   partial-fade. If the trail length control needs to feel like Sean's, translate it to a
   brightness multiply `< 1` in the shader chain (e.g. a `cc.brightness`/`cc.scalebias` slab after
   the HSL stage — the shipped `render/camera.node/camera.direct.feedback.maxpat` uses exactly this
   with `cc.brightness.ip.jxs @param alpha 1.007`).
3. **Verify a performer-driven spiral.** The loop is confirmed closed (a temp seed persists and
   recirculates through the real `shaderfx`), and the identical `td.rota.jxs` loop is confirmed to
   spiral in isolation (the probe). A full spiral in the real patch needs live control input
   (`shadeCtl` theta/zoom from webUI/Mira/Leap); this was not force-tested headlessly.
4. **Optional cleanup.** The now-vestigial `fst`/`dst`/`switch 2`/`gswitch2`/`usetexture`
   objects were left in place (disconnected). Remove them once the retrofit has been exercised
   live and confirmed.
5. Optionally re-connect `jit.gl.pix @gen brcosa` (finding H) to match what Sean performed with.

## Max 9 retrofit — built and validated

Done on **Max 9.1.5** (`glcore` engine; the Console reports `OpenGL Version 4.1 Metal - 90.5,
GLSL Version 4.10`), Apple-Silicon-native, unlicensed runtime mode. All patch edits were made with
the new `tools/maxedit.py` (Max can't save in runtime mode).

### The mechanism (proven in isolation first)

A standalone 13-object probe reproduced the loop: `jit.gl.node @name fb @capture 1 @automatic 1`
captures its children (a seed shape + a feedback plane) into texture `fb`; the node's left outlet
emits `jit_gl_texture fb`; that feeds `jit.gl.slab foo @file td.rota.jxs` (theta 0.03, zoom 1.008,
boundmode 4); the slab's output becomes the feedback plane's texture for the next frame; a separate
`jit.gl.videoplane foo` draws `fb` to the window. **It spiralled** — confirming `jit.gl.node`
capture is the correct replacement for `usetexture`/`to_texture` under `glcore`, with no console
errors. Two non-obvious points the written design didn't capture:

* **Draw order is by `@layer`, not by bang order.** With children `@automatic 1`, the node draws
  them in ascending `@layer`. ~~New material must sit *below* the feedback plane (lower `@layer`) so
  the plane composites over it, exactly as Sean's manual bang order did.~~ **Corrected 2026-08-29
  (finding J):** that was true only for the waveform graphs. Sean's bang order put the *sticker*
  layer **above** the plane (it is `@automatic`, drawn on the render bang, after the manual plane
  bang), and under the plane's additive `(SRC_ALPHA, DST_ALPHA)` composite a sticker below it is
  re-added every frame and saturates to white. Correct layering: sticker 20 > plane 10 > graphs 3.
* A textureless feedback plane at a *high* layer paints an opaque quad over everything and the
  node captures black forever — the first probe was black for this reason. Fixed by layering.

### The edits applied to the real patches

`patches/Feedbax.maxpat` (object ids are the real ones, cross-checked against the file):

* **Added** `obj-fbnode` = `jit.gl.node foo @name fb @capture 1 @automatic 1 @adapt 0 @dim 1920
  1080 @erase_color 0. 0. 0. 1.` and `obj-fbdisp` = `jit.gl.videoplane foo @automatic 1
  @transform_reset 2 @depth_enable 0 @layer 0` (the on-window display of `fb`).
* **Reparented** the main feedback plane `obj-44`: context `foo` → `fb`, `@automatic 0` → `1`,
  added `@layer 10` (top). Its `@blend_mode 6 8` (from the load-time `pak`, `obj-90`) and
  scale/position math (`obj-77`/`obj-72`, incl. `xyratio` and `worldBump`) are unchanged.
* **Rewired the feedback source**: removed `switch 2` (`obj-37`) → `feedbax.shaderfx` (`obj-148`);
  added `obj-fbnode`:0 → `obj-148`:0. `shaderfx`'s output → `obj-44`'s texture inlet is unchanged.
* **Display**: `obj-fbnode`:0 → `obj-fbdisp`:0.
* **Cut the obsolete/`glcore`-dead cords**: trigger `obj-50` outlet 0 (`to_texture`) → render, and
  outlet 2 (per-frame bang) → `obj-44` (the plane is now drawn by the node; keeping this would
  double-draw it).
* **Re-pointed the buses**: `erasetransparency` pak (`obj-56`) from render (`obj-49`) to
  `obj-fbnode`; `r resolution` (`obj-186`) from `fst` (`obj-36`) to `obj-fbnode` (`@adapt 0`, so
  a resolution preset now sets the capture-texture dims).

`patches/feedbax.picsvid.maxpat`: `jit.gl.layer` (`obj-2`) reparented `foo` → `fb`, `@automatic 1`
(kept `@layer 2`, `@enable 0` — **`@layer 2` was wrong; raised to `@layer 20` on 2026-08-29, see
finding J**). `patches/feedbax.sound2.maxpat`: both `jit.gl.graph` (`obj-12`,
`obj-213`) reparented `foo` → `fb`, `@automatic 0` → `1`, `@layer 3`.

### What was verified in Max 9

* The real `Feedbax.maxpat` opens and runs at ~60 fps with **no errors from the retrofit** — the
  Console shows only the pre-existing harmless lines (`shell`/`ultraleap`/`jit.ndi.receive~ No such
  object`, the vestigial `folder ./Cycling '74/max-help` watcher, `live.slider … "signal"`, `Mira
  Initialized`, the OpenGL banner).
* With a temporary seed child of `fb`, the loop is **closed**: the seed persists and recirculates
  through Sean's real `shaderfx` (`td.rota` + HSL). The seed was removed after testing.
* With the picsvid layer and sound2 graphs reparented, the **audio waveform graphs draw into the
  feedback** (visible in the render window), confirming reparented material feeds the loop.

Remaining fidelity items are listed under "What's left" above (trail-fade translation; a
performer-driven spiral; optional removal of the vestigial `fst`/`dst`/`switch 2` objects).

## Environment notes for whoever tests next

* Max 8 here runs unlicensed: it will not save patches ("you must authorize Max to save a patcher");
  edit the JSON instead.
* Max restores previously open patchers from `~/Library/Application Support/Cycling '74/Max 8/Crash
  Recovery/maxworkspace-*.txt` after a non-clean quit; a stale entry for `~/Projects/feedbax/patches/
  Feedbax.maxpat` produced `name fst already in use` / `jit.window foo already exists` errors during
  testing (two instances of the patch). Delete that file before a clean test.
* Max console messages after a clean load of this branch (gl3): `shell: No such object`,
  `ultraleap: No such object`, `jit.ndi.receive~: No such object` (optional externals);
  `folder ./Cycling '74/max-help: not a folder` (a vestigial folder-watcher in picsVid with a
  hard-coded bogus path — also in Sean's file); `live.slider doesn't understand "signal"` (sound2's
  outlet 0 is a signal; cosmetic); `Gen working in runtime mode`.

## Addendum 2026-08-29 — sticker (picsVid) path on Max 9

Symptom: with a PNG in `input/transparent-background/` the menu populated and `jit.movie` reported
`read <file> 1`, but nothing ever appeared. Two independent causes, both proven live on Max 9.1.5
with a `js` probe inside `feedbax.picsvid` (attribute dumps + outlet taps + screenshots):

* **H. `jit.gl.layer fb` is never enabled.** It is instantiated `@enable 0`; its only enable
  sources are webUI's `imageMove` slot 0 (the "pic enable" toggle, `loadmess 0`) and the camera
  toggle. `imageMove` is rebroadcast every `ctrlbang` (60 Hz), so a manual `enable 1` sent to the
  layer is overwritten within a frame — measured: `enable` read back `0` one second after sending
  `1`; it only stuck after the `imageMove` gate was closed. Fix: `feedbax.webui` `[obj-82]`
  `loadmess 0` → `loadmess 1`. With nothing loaded the enabled layer draws nothing (verified with
  the folder empty), so the default is safe.
* **I. `jit.movie @output_texture 1` emits an empty texture.** After the fix for H the layer had
  the movie's texture bound (`texture u…`) yet drew nothing; a `jit.gl.videoplane foo` bound to
  the same texture drew solid black, for Pluto and for a trivial 8-bit RGBA test PNG alike
  (`framecount 0`, `duration 0` under `engine avf`). Isolated with fresh objects: `read` + bang in
  the same tick (what `t b s` does) → the object emits nothing on that or any later bang until
  the next `read`; a fresh object with `read` then a bang 2 s later → texture filled; obj-49
  itself (load-time read) → black even after re-read + delayed bang. Matrix output works in every
  one of those conditions, including on obj-49: `output_texture 0`, `read`, bang → correct
  `jit_matrix`, and `jit.gl.layer` accepts it directly. Fix: `[obj-49]` →
  `jit.movie @output_texture 0` (the `@drawto foo` from the earlier fix is moot in matrix mode).
  `jit.grab @drawto foo` [obj-113] (camera) was left alone — same class of risk, not tested.

Verified: fresh load with `Pluto-transparent.png` present → the disc lands in the `fb` node and
recirculates (it blows out to white within a second — ~~that is open item 2, trail-fade parity,
not the sticker path~~ **wrong attribution; it was the sticker path's draw order, finding J
below**); fresh load with the folder empty → no rectangle (Console not inspected in these runs).

## Addendum 2026-08-29 (later) — the sticker white-out is draw order, not trail fade

Symptom: with H and I fixed, Pluto appears and within a second becomes a saturated white disc that
stays white. Sean's builds never did this.

* **J. The retrofit put the sticker layer *under* the additive feedback plane.** In Sean's file
  (`v122debuggingisg` and `v123`, identical here) the per-frame trigger `t to_texture b b b b b b
  erase` [obj-50] fires: erase → dst/fst bang → `imgbang` → `audiobang` → `ctrlbang` → **bang the
  plane** [obj-44, `@automatic 0`] → **bang the render** → `to_texture`. The picsVid layer
  `jit.gl.layer foo @layer 2 @enable 0 …` has no `@automatic` key, i.e. it is automatic and is drawn
  by the *render* bang — **after** the plane — with `jit.gl.layer`'s default alpha blend and depth
  test off. (`imgbang` reaches the layer only through `gate` [pv:obj-307] behind an unfed toggle
  [pv:obj-316], so it never drew earlier.) That makes the sticker a convex stamp on top of the
  loop: `FB' = S_a·S + (1−S_a)·warp(FB)`, bounded by the sticker's own brightness. The waveform
  graphs, by contrast, are `@automatic 0` and are banged by `audiobang` — *before* the plane — so
  they are under the plane's `(SRC_ALPHA, DST_ALPHA)` composite and are *added* into the loop each
  frame; the retrofit's `@layer 3` preserves that.

  The retrofit made the plane `@automatic 1 @layer 10` and left the sticker at `@layer 2`, i.e.
  under the plane. Inside the `fb` FBO (cleared to alpha 1) `DST_ALPHA = 1`, so the plane
  composite is `FB' = clip(S + warp(FB))`: the sticker is injected additively every frame with
  loop gain 1 and no loss term, and its footprint clips to white in a handful of frames. Sean's
  `@layer 2` never meant "below the plane" — the plane was `@automatic 0`, outside the layer
  system entirely.

  Evidence: (a) a per-pixel loop map (single channel, bilinear warp, hard clear, both orders,
  six (theta, zoom) vectors) — sticker-under-plane reaches max = 1.00 by frame 5 for every vector
  and the saturated area grows with outward zoom (4 % → 62 % of the frame by frame 90); sticker-
  on-top never exceeds the sticker's own value (0.55) for any vector. (b) Live on Max 9.1.5: HEAD
  (`@layer 2`) captured 5–20 s after launch is a white disc with 1.9 % near-white pixels; with only
  `@layer 2 → @layer 20` changed, Pluto renders with full surface detail and holds for 30 s at
  0.2 % near-white. Nothing else was touched.

  Fix: `patches/feedbax.picsvid.maxpat` [obj-2] `jit.gl.layer fb @layer 2 …` → `@layer 20`.
  The camera path (`jit.grab` → the same layer) gets the same correction for free. Open item 2
  above ("trail-fade parity") is unrelated to this symptom and remains as written.

  Still visible after the fix, and *not* a regression: with no audio input the two `jit.gl.graph`
  waveforms (flat silence lines) are added under the plane every frame and saturate into bands —
  that is Sean's own order (`audiobang` before the plane bang), so it was left alone.
