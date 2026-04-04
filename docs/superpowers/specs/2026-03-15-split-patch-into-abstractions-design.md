# Split Feedbax.maxpat into Max Abstractions

## Problem

Feedbax.maxpat is a 34,595-line JSON file containing all subpatchers inline. This makes it:
- Difficult for AI tools (Claude) to read, navigate, and edit reliably
- Produces unreadable git diffs — a change to one subpatcher touches the entire file

## Goal

Extract each top-level subpatcher into its own `.maxpat` file (Max abstraction), so that:
- Each functional unit is a separate, manageable file
- Git diffs are scoped to the files that actually changed
- The parent patch becomes a thin orchestration layer

## Scope

- **In scope**: `patches/Feedbax.maxpat` only
- **Out of scope**: `patches/variants/Feedbax Ultrawide.maxpat` (future work)

## Architecture

### File Structure

```
patches/
├── Feedbax.maxpat                      # Parent: metro, GL context, feedback loop, abstraction refs
└── lib/
    ├── feedbax.pathsetup.maxpat        # Project-relative path resolution
    ├── feedbax.misc.maxpat             # Parameter broadcasting
    ├── feedbax.minictlsmooth.maxpat    # Parameter smoother (utility, 24 instances)
    ├── feedbax.picsvid.maxpat          # Camera/NDI/video/image input (contains chro, pic, brcosaslab, vdev)
    ├── feedbax.sound2.maxpat           # Audio analysis + waveform vis (contains nested xypinch instances)
    ├── feedbax.shaderfx.maxpat         # GPU shader chain (contains oldconrtrol)
    ├── feedbax.webui.maxpat            # Mira/on-screen controls (contains xypinch instance)
    ├── feedbax.leapgemini.maxpat       # Ultraleap hand tracking (contains fill_coll)
    └── feedbax.stillsave.maxpat        # Screenshot capture
```

### Naming Convention

`feedbax.<subpatcher>.maxpat` — dot-separated namespace, lowercase.

### Communication

Most inter-subpatcher communication uses Max's `s`/`r` (send/receive) named globals, which work across abstraction boundaries without changes.

**Exceptions — patchcord connections:**
- `sound2` has 1 inlet, 2 outlets (connected to the texture feedback loop and obj-203)
- `shaderfx` has 1 inlet, 1 outlet (receives texture from switch, outputs to jit.gl.videoplane)
- All other subpatchers (pathsetup, misc, webUI, LeapGemini, StillSave, picsVid) have 0 inlets/outlets and communicate entirely via s/r

Extraction requires **no changes to subpatcher internals** except for `pathsetup` (see below). The parent patch changes from inline definitions to abstraction references.

Key signals: `shadeCtl`, `shadeCtlLeap`, `lineSmoothGrain`, `controlSmoothMs`, `kittybumpsignal`, `SInvert`, `feedbax_root`, `feedbax_sticker_folder`, etc.

### What Changes in the Parent Patch

Each `"maxclass": "newobj", "text": "p pathsetup"` (and equivalent for other subpatchers) becomes `"text": "feedbax.pathsetup"`. Max resolves this by looking for `feedbax.pathsetup.maxpat` on the search path.

The parent's `"patcher"` key for each subpatcher (which contains the entire inline definition) is removed — it now lives in the external file.

### Search Path

The parent patch needs `patches/lib/` on its Max search path. Recommended approach: **use a Max Project (`.maxproj`)** that includes the `lib/` folder. `.maxproj` files are JSON and can be committed to git. This avoids a load-order race condition — if the search path is added dynamically via `thispatcher` inside pathsetup, other abstractions may fail to resolve before pathsetup finishes.

Fallback: add `lib/` to Max's File Preferences manually.

### pathsetup Internal Fix Required

`pathsetup` currently uses `thispatcher` to get its file path, then strips `patches/` to find the project root. After extraction to `patches/lib/feedbax.pathsetup.maxpat`, `thispatcher` will return `.../patches/lib/feedbax.pathsetup.maxpat`. The regexp must be updated to strip two directory levels (`patches/lib/`) instead of one. This is the **only** subpatcher that requires an internal change during extraction.

### Nested Subpatchers Stay Nested

These subpatchers are specific to their parent and not reused elsewhere:
- `chro`, `pic`, `brcosaslab`, `vdev/format` → stay inside `feedbax.picsvid`
- `oldconrtrol` → stays inside `feedbax.shaderfx`
- `fill_coll` → stays inside `feedbax.leapgemini`
- `xypinch` → stays inside its respective parents (webUI, sound2)

Exception: `mIniCtlSmooth` is extracted because it's instantiated 26 times across multiple subpatchers and is a generic utility.

## Extraction Order

Extract in dependency order (most independent first):

1. **feedbax.pathsetup** — no dependencies, init-only
2. **feedbax.misc** — no dependencies, broadcast-only
3. **feedbax.minictlsmooth** — utility, no s/r dependencies
4. **feedbax.stillsave** — small (14 boxes), depends on signals from others
5. **feedbax.leapgemini** — moderate (75 boxes), sends to shaderfx
6. **feedbax.shaderfx** — moderate (95 boxes), receives from LeapGemini + webUI
7. **feedbax.picsvid** — large (323 boxes), self-contained image pipeline
8. **feedbax.sound2** — largest (348 boxes), heavy internal structure
9. **feedbax.webui** — large (193 boxes), control hub

## Extraction Process (per subpatcher)

1. Locate the `"newobj"` with `"text": "p <name>"` in the parent
2. Extract the `"patcher"` object from within it — this becomes the new `.maxpat` file. The top-level structure must be `{"patcher": { ... }}` with `fileversion`, `appversion` (Max 9.0.7), `classnamespace`, `rect`, `boxes`, and `lines` keys. Do NOT include `saved_object_attributes` from the parent's box definition in the extracted file.
3. In the parent, replace the full object with a simple `"text": "feedbax.<name>"` reference (removing the inline patcher definition)
4. Preserve all patchcord connections (`"lines"`) in the parent — the abstraction's inlets/outlets must match the original subpatcher's
5. Verify inlet/outlet count and order match

## Verification

After each extraction:
1. Open the parent `Feedbax.maxpat` in Max 9
2. Verify the abstraction loads (no "object not found" errors)
3. Check that the subpatcher UI opens correctly (double-click the abstraction)
4. Run the instrument and verify the affected subsystem works
5. `git diff` should show the parent shrunk and a new file appeared

End-to-end:
- All 9 abstractions load without errors
- Camera input, audio reactivity, shader effects, controls, and screenshot capture all function
- Parent patch is reduced to ~8,000–9,000 lines (GL context, metro, feedback loop, resolution presets, 188 patchcords, window management)
