# Image layer without a switch, and a panel that fits — design

Date: 2026-08-29
Status: proposed
Supersedes: `2026-08-26-controls-gestures-and-help-design.md` §"a new Surfaces section at the top of the panel's right column" (see §5.4)

## 1. What went wrong

A sticker picker landed in the operator panel — drop zone, thumbnail grid, click to
select. Clicking the thumbnails did nothing visible, and the reason was three moves
away from the picker: `LayerSettings.enabled` defaults to `false`, and nothing in a
GUI launch ever turned it on. Not `AppBootstrap.start()`, which only reads the flag
into a `ControlStateSnapshot`; not `ControlRouter.applyStartupDefaults`, which
carries the nine slots, the four layer axes and erase, but no toggles. Only the
panel's "Layer Enable" checkbox, a recalled preset, or `feedbax-dev --soak` wrote it.

So the instrument shipped in a state where a folder full of images, a picker that
selected them, and an engine that decoded them produced a black canvas, and the
recovery was one unlabelled-in-context checkbox in a column of seven unrelated ones.

The diagnosis is not "the default was wrong". The default was *a setting that should
not exist*. Whether an image is showing is not an independent axis of state; it is
what the selection already says. Two further problems surfaced alongside it:

- **The panel columns are lopsided.** The left column is ~460pt of uniform sliders
  and checkboxes; the right is ~900–950pt — the entire default window height in one
  column — and the two XY pads inside it need 336pt of width but get ~254pt at a
  600pt window. That is not an aesthetic complaint; it is a constraint violation.
- **The toggles are stacked by type, not by meaning.** Seven checkboxes in one
  "Toggles" section that share nothing except being booleans. `SInvert` never even
  reaches the `Engine`; `Show HUD` is not a `ToggleEvent` at all.
- **"Kitty Bump" is misnamed.** It only ever offsets the sticker layer
  (`Engine.swift:234-239` — audio drives `scale.x`, `scale.y` and `position.y`), so
  it belongs to the image, both in name and in where it sits on screen.

## 2. Decisions taken

| Question | Decision |
|---|---|
| Image on/off as a panel setting | Removed. An **Off** entry at the head of the image picker replaces it. |
| `p` key and gamepad B | Kept, as a performance gesture: Off ↔ last image. |
| Image bump default | On at startup when the folder has images; manual thereafter. |
| Rename scope for kitty → image bump | UI label and Swift identifiers; persisted marker and preset field keep their current strings. |
| Panel layout | XY pads in a full-width band on top, two balanced columns below. |

## 3. The image layer

### 3.1 Rule

There is one rule, and every behaviour below is a consequence of it:

> **An image is showing when one is selected. Selecting `Off` — or having nothing to
> select — is how it stops.**

| Situation | Result |
|---|---|
| Folder is empty | Nothing draws. `itemCount == 0`, `tick` already returns nil. |
| Cold start, folder has images | Index 0 is selected, so it is showing. |
| Operator clicks a tile | That image is showing. |
| Operator clicks the `Off` tile | Nothing draws; the previously selected index is remembered. |
| Operator imports images | The first imported image is selected, so it is showing. |
| `p` / gamepad B, while showing | Off, remembering the index. |
| `p` / gamepad B, while off | The remembered image returns (index 0 if there is none). |

`Off` is a UI affordance, **not** an entry in `StickerSource.items`. It does not shift
any image's index, it is not reachable by the index stepper or the normalized slider,
and `itemCount` does not count it — those three are the index space the keyboard and
gamepad bindings drive, and putting a sentinel in them would offset every selection a
performer has memorised. The grid renders `Off` as a leading tile; the model records
it as "not showing", nothing more. With an empty folder there is nothing to turn off,
so the grid shows its empty-state line and no `Off` tile.

The last row of the previous table is what closes a gap the cold-start fix left open:
launch with an empty folder, drop images in, and the picker used to stay inert
because nothing re-ran the startup rule. Under this design importing selects, and
selecting shows — no separate rule needed.

### 3.2 How it is represented

`LayerSettings.enabled` **stays** as the internal gate. What changes is that nothing
outside the layer's own selection writes it: the panel checkbox is deleted, and the
flag becomes a derived consequence of selection rather than an independent switch.

The tempting alternative — delete `enabled` outright and represent Off as
`selectedIndex == nil` — is rejected. `enabled` is what `Engine.step:252` and
`Compositor.drawPlan:49` gate on, what `PresetToggles.layerEnabled` persists, and
what keeps `sticker` and `movie` in lockstep (`Engine.swift:330-337`, pinned by
`EngineTests:143`). Removing it would push a `nil`-selection concept through the
compositor, the preset schema and both sources to buy no behaviour the rule above
does not already give. The flag is a fine mechanism; it was the *exposed switch* that
was wrong.

Movie mode keeps the same shape: the layer shows when a movie is loaded, and
"Choose Movie…" gains a **Clear** affordance that is the movie-side `Off`. Sticker
and movie `enabled` stay in lockstep exactly as today.

### 3.3 Surface changes

- `EngineViewModel` loses `setLayerEnabled` from the panel's reach and gains
  `selectImageOff()` / `restoreImage()`, plus a `lastShownStickerIndex` memory.
- `ToggleEvent.layerEnabled` is renamed `ToggleEvent.imageEnabled` **in Swift only**.
  Its persisted marker stays the string `"layerEnabled"` in `Bindings.fromMarker` /
  `marker` and in `DefaultBindings.json`, with a comment saying why: an unknown
  marker is a hard startup throw (`Bindings.swift:~160`, rethrown by
  `BindingsStore.init`), and there is no version-bump migration in this change.
- Its `displayName` becomes **"Image on/off"**, which is what the Controls Reference
  window shows for `p` (that window derives rows from `displayName`, so it follows
  for free). `README.md`'s hand-maintained key list is updated to match.
- `Engine.enableImageLayerIfStocked()` — added earlier today as the cold-start fix —
  is renamed `applyColdStartImageDefaults()` and additionally turns the image bump
  on, per §4.

### 3.4 Presets

No schema change. `PresetToggles.layerEnabled` keeps its name and meaning ("was an
image showing"), and `PresetLayer.sourceSelection.stickerIndex` keeps recording which
one. `PresetToggles` uses synthesized `Codable` with no `decodeIfPresent`, so any
field rename would throw on every previously saved preset; the field name is left
alone precisely to avoid that. (There are zero preset files on disk today —
`~/Library/Application Support/Feedbax` is empty — so this costs nothing to honour
and avoids a migration we would otherwise owe.)

Recall still asserts both the flag and the selection, so a preset saved with the
image off comes back off.

## 4. Image bump

`kittyBump` → `imageBump` through the Swift code and the UI: `ToggleEvent`,
`ControlStateSnapshot`, `Engine.bumpsEnabled.kitty`, `KittyBumpReceiver`,
`FrameAudio.kittyBumpRaw`, `EngineViewModel.kittyBumpOn`, and the panel label, which
becomes **"Image Bump"**.

Not renamed: the marker string `"kittyBumpEnabled"` in `Bindings` and
`DefaultBindings.json` (key `k`), and `PresetToggles.kittyBump` — same reasoning as
§3.3 and §3.4. Each gets a comment pointing at this document.

Also not renamed: anything under `patches/` or `docs/spec/`. Those describe the Max
instrument, whose buses really are called `kittybump` and `kittybumpsignal`, and
whose panel really does say "kittieBump™". The port's job is to map them, not to
rewrite their history; `docs/spec/06-bus-reference.md` gains one line noting that the
Swift port surfaces this bus as "image bump".

Default: on at cold start when the sticker folder has images, off otherwise, and
manual from then on — `applyColdStartImageDefaults()` sets it in the same breath as
the selection. A recalled preset overrides it like any other toggle.

## 5. Panel layout

### 5.1 Shape

```
┌────────────────────────────────────────────────┐
│ Surfaces        [ XY pad 1 ]   [ XY pad 2 ]    │   full width
├───────────────────────┬────────────────────────┤
│ Feedback              │ Image                  │
│   8 sliders           │   Sticker / Movie      │
│   SInvert             │   4 image sliders      │
│   World Bump          │   Image Bump           │
│                       │   drop zone            │
│ Waveforms             │   grid (Off + tiles)   │
│   Wave 1              │   stepper + slider     │
│   Wave 2              │                        │
│   Wave Bump           │ Venue & Presets        │
│                       │   3 pickers, Show HUD  │
│                       │   name, Save, recall   │
└───────────────────────┴────────────────────────┘
```

### 5.2 Why the pads go on top

They are the only control with a hard width requirement — two 160pt squares plus
16pt of spacing is a 336pt floor, against ~254pt of content width per column at a
600pt window. Every other control in the panel is happy in a narrow column. Giving
them the full width removes the one real constraint conflict, and it puts the
most-performed control biggest and nearest to hand. The two columns below come out
at roughly 480 vs 520pt, against 460 vs 950 today.

### 5.3 Toggles move next to what they change

| Toggle | Goes to | Because |
|---|---|---|
| SInvert | Feedback | Router-internal; flips the pan/zoom sign and never reaches the Engine. |
| World Bump | Feedback | Gates `params.worldBump`. |
| Wave 1, Wave 2 | Waveforms | `WaveformRenderer` flags. |
| Wave Bump | Waveforms | Feeds wave 2's alpha — it has no visible effect unless Wave 2 is on, which is an argument for adjacency. |
| Image Bump | Image | Offsets the sticker transform and nothing else. |
| Show HUD | Venue | Not a `ToggleEvent`; writes `EngineHost` directly. |
| ~~Layer Enable~~ | — | Deleted; §3. |

### 5.4 Consequences to handle

- The "Surfaces at the top of the right column" line in the 2026-08-26 design doc is
  deliberately superseded. That doc gets a pointer to this one rather than an edit in
  place.
- Pad order stays left-to-right, because `ControlReference` emits "Pad 1 / Pad 2"
  from the same array order and the help window would otherwise lie.
- The sticker grid's 44pt tiles were calibrated against a ~140pt `Form` control
  column. In a wider column they can grow; the tile size and the 180pt height cap are
  re-tuned by eye against the real panel, and `StickerPicker`'s comments explaining
  both numbers are rewritten rather than left stale.
- The preset `TextField`'s `@FocusState` + `.onSubmit` + `.onExitCommand` trio moves
  with it intact — without those, every keyboard binding goes dead for the session
  once the field takes focus.
- "TRANSPARANCY" keeps its deliberate misspelling; it matches the Max original.

## 6. Testing

Model-level, in the existing XCTest suite:

- Selecting `Off` stops the layer showing and remembers the index; selecting a tile
  shows it again.
- `p` / gamepad B round-trips: showing → off → the same image returns; off with no
  memory → index 0.
- Cold start with a stocked folder shows index 0 and turns the image bump on; with an
  empty folder does neither.
- Importing into an empty folder ends with the imported image showing — the gap the
  earlier cold-start fix left.
- Sticker and movie `enabled` stay in lockstep across all of the above.
- A preset saved with the image off recalls off; one saved showing recalls showing.
- Renames do not change any persisted string: assert `Bindings` still round-trips the
  markers `"layerEnabled"` and `"kittyBumpEnabled"`, and that a preset JSON written
  before this change still decodes (fixture file).

The panel itself has no test rig in this package, as before: it is verified by
`swift build`, then by running the app and reading the result on screen — pads
unclipped at a 600pt window, columns near even, every toggle in its new home.

## 7. Out of scope

The jukebox queue and anything under P2; a bindings version bump or preset migration
(explicitly avoided, §3.4); rewriting `docs/spec/` prose about the Max original;
blessing the three unblessed `GoldenFrameTests` scenarios, which fail on `main`
independently of this work.
