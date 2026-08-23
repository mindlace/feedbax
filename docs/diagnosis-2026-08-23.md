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

## Summary

| # | finding | status |
|---|---|---|
| A | The repo is a faithful split of Sean's `v123DeployabilityCleanup` (Max 9, Oct 2025). The only differences are the intended path edits. The split did not break anything. | verified (structural diff) |
| B | `td.rota.jxs`, `cc.scalebias.jxs`, `co.*.jxs`, `brcosa.genjit` and all Vizzie modules ship with Max 8 and 9 on the default search path. Nothing is missing. `td.rota` loads without error here. | verified |
| C | **`feedbax.pathsetup` never worked**: `thispatcher` answers `path` on its *right* outlet as a bare symbol, the patch listened on the left outlet through `route path`; and `sprintf symout folder %s…` baked the selector into one symbol so `route folder` in `p pic` could never match. Result: `feedbax_root` unset, sticker menu never populated. | **fixed**, verified |
| D | `loadbang → "folder input/transparent-background/"` (relative path) in picsVid → `umenu` error "not a folder". | **fixed** (buttons now re-trigger pathsetup) |
| E | `importmovie NormalFullAlpha1080p1.png` fails unless `assets/` is on Max's search path (README told users to add it by hand). | **fixed**: pathsetup now appends `<root>/assets` to the search path at load |
| F | On a fresh load the feedback path is **closed**: `[switch 2]` that gates the captured texture into `shaderfx` starts closed, and `usetexture fst/dst` is only sent when the FS toggle changes. Sean's ritual included toggling fullscreen. | **fixed** (`loadmess 0` → FS toggle), effect verified |
| G | **Root cause of "the feedback loop doesn't run"**: the capture uses the legacy `usetexture`/`to_texture` messages, which are silent no-ops under the `gl3`/"glcore" engine (Max 8.6 default, Max 9 only option). Max prints `copy_texture is obsolete when using the glcore engine` for the attribute form; the message form prints nothing. **Sean's Max 8 preferences use the legacy `gl2` engine.** | verified; retrofit to `jit.gl.node @capture 1` designed, not yet applied |
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
* `patches/Feedbax.maxpat` — one added object: `loadmess 0` → the FS toggle (finding F).
* `docs/spec/*`, this file, `tools/*.py`.

Nothing else in the GL/render path was modified.

## What's left to make it run on a stock Max 8.6 / Max 9 install

1. **Replace the capture** (finding G) with `jit.gl.node`. Design, validated in principle against
   the Max 8 reference but **not yet built/tested**:
   * add `jit.gl.node foo @name fb @capture 1 @automatic 0 @dim 1920 1080 @erase_color 0 0 0 1
     @blend_enable 1 @depth_enable 0`; route the `resolution` bus and the `erase_color` pak to it
     (the partial-erase trick must happen inside the node — confirm `erase_mode` blend behaviour on
     `jit.gl.node`);
   * make the drawers children of the node by renaming their context argument `foo` → `fb`:
     the main `jit.gl.videoplane` (Feedbax.maxpat), `jit.gl.layer foo` (picsvid), both
     `jit.gl.graph foo` (sound2); give them `@automatic 1` and `@layer` values that reproduce the
     manual bang order (image layer 2, waveforms ~3, feedback plane highest);
   * per frame: `erase` → bang node (draws children into its FBO, emits `jit_gl_texture fb`) →
     that reference goes where `switch 2`'s output went (`feedbax.shaderfx` inlet) → the plane's
     texture for the *next* frame; a new `jit.gl.videoplane foo @texture fb` draws the node's
     output into the window; then bang `jit.gl.render`;
   * delete/ignore `fst`/`dst`/`switch 2`/`gswitch2`/`usetexture`/`to_texture`.
   Because the shader slab produces a fresh texture, the plane never samples the FBO it is drawing
   into. Test first in a 12-object patch (seed circle + rotating plane should spiral), then retrofit.
2. Optionally re-connect `jit.gl.pix @gen brcosa` (finding H) to match what Sean performed with.
3. Re-test under Max 9 (not available on this machine).

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
