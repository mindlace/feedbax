# Controls: trackpad gestures, XY pads, and a controls reference — design

**Date:** 2026-08-26
**Status:** draft for review
**Builds on:** `2026-08-23-feedbax-reimplementation-design.md` §5 (control surfaces),
`2026-08-24-control-display-split-design.md` (windows, `PerformerInputMonitor`),
spec §04 (control surfaces — the original's two Mira pads).

## 1. Goals

1. **Discoverability.** A performer can see every key, gesture, pad, and gamepad binding
   from inside the app — a *Help › Feedbax Controls* menu item, the `?` key, and a window
   whose content is generated from the same data the bindings run on, so it cannot drift.
2. **The original's two touch surfaces come back**, as two XY pads in the Controls window,
   each assignable to any pair of live axes, defaulting to what the original did.
3. **The trackpad becomes a real performance surface**: pinch, twist, and one-finger drag
   drive the feedback field; the same gestures with **Option** held drive the image layer.
4. **The image layer is live-controllable** (position, scale, rotation) — today only a
   preset recall can set it.

## 2. What the original did, and where the port is today

The two "paired surfaces" in `feedbax.webui.maxpat` are two `mira.multitouch` pads with
*different* jobs (spec §04 §1.2–1.3):

| Pad | Input | Drives | Port equivalent |
|---|---|---|---|
| Right | single touch position (absolute) | `shadeCtl` xshift/yshift — **shader pan** | `panX`/`panY` (slots 3/4); two-finger scroll already drives it |
| Left | touch centroid (absolute) | `imageMove` x/y — **image layer position** | `LayerTransform.position` — **no live path** |
| Left | pinch | `imageMove` zoom — image layer scale | `LayerTransform.scale` — **no live path** |
| Left | two-finger twist | `imageMove` r — image layer rotation | `LayerTransform.rotationZDegrees` — **no live path** |

(In the original, pinch/rotate recognition was persisted *off* on both pads, so only the
position tracking worked out of the box — spec §04 §1.3. This design enables both.)

In the port today: `KeyboardTrackpadSurface` handles two-finger scroll → pan, pinch → zoom,
Option-drag → hue (x) / theta (y). There is no `rotate` handling, no plain-drag role, no
menus, no help key, and `LayerTransform` is written only by `PresetStore.apply`.

Two findings that shape the design:

- **Relative gestures nudge a private accumulator, not the truth.** `KeyboardTrackpadSurface`
  keeps its own held position per slot and nudges *that*. After the operator panel (or a
  preset, or the gamepad) moves a slot, the next trackpad nudge asserts *stale accumulator +
  delta* and the value jumps back. Invisible today because nobody mixes surfaces mid-gesture;
  with pads in the panel it would be the first thing a performer hits. §5 fixes it.
- **macOS owns three-finger gestures.** Mission Control (three fingers up) and space switching
  (three fingers sideways) are on by default and cancel the app's touches when they fire.
  Three-finger drags are therefore *not* in the default vocabulary; two fingers + modifiers is
  the conflict-free space. (See §11.)

## 3. Control vocabulary: one axis identity for everything a gesture can drive

### 3.1 `LayerAxis` and `ControlAxis`

The 9-slot `ControlSlot` stays exactly what it is — the original's `shadeCtl` vector, indices
0–8, preset-serialized as a 9-float array. The image layer's axes get their own small enum
rather than being crammed into it:

```swift
/// The image layer's four live axes — the original's `imageMove` roles (spec §02 §4, §04 §1.3).
public enum LayerAxis: Int, CaseIterable, Codable { case x = 0, y, scale, rotate }

/// Anything a gesture, pad, or slider can drive: one of the 7 live shader slots, or a layer axis.
public enum ControlAxis: Hashable, Codable {
  case slot(ControlSlot)
  case layer(LayerAxis)
}
```

`ControlAxis` carries the things every consumer (surfaces, pads, sliders, help) currently
duplicates or lacks:

- `rawRange: ClosedRange<Float>` — `0...1` for `.slot(.saturation)`, `-1...1` for everything
  else (moves out of `EngineViewModel.range(for:)`).
- `marker: String` / `fromMarker` — the JSON spelling: the existing slot markers plus
  `layerX`, `layerY`, `layerScale`, `layerRotate`.
- `displayName: String` — what the panel, pickers, and reference window show: `Hue shift`,
  `Brightness`, `Pan X`, `Pan Y`, `Zoom`, `Rotate`, `Saturation`, `Image X`, `Image Y`,
  `Image scale`, `Image rotate`.
- `static let live: [ControlAxis]` — the 11 assignable axes (the 7 live slots — never
  `.scalebright`/`.nc` — plus the 4 layer axes), in display order.

### 3.2 `ControlWrite` gains a layer channel

```swift
public struct ControlWrite {
  public var slots: [ControlSlot: Float]
  public var layer: [LayerAxis: Float]      // new — raw −1...1, same partial-write contract
  public var toggles: [ToggleEvent]
  public var eraseStep: Float?
}
```

Surfaces write `ControlAxis`-keyed values; a small helper splits them into `slots`/`layer`
at the write boundary so the router's existing slot code doesn't change shape.

## 4. Router: the layer channel

`ControlRouter` grows a second, parallel vector — same rules as the slots, separate storage:

- `rawLayer: [Float]` (4 entries, indexed by `LayerAxis.rawValue`), last-writer-wins per axis
  within a tick, exactly like `rawSlots`.
- One `LinearRamp` per layer axis, same 100 ms / 4 ms global smoothing. The original ran the
  pad centroid through `mIniCtlSmooth` (spec §04 §1.3); its pinch/rotate accumulators were
  unsmoothed, but the port's stated rule is *one* global smoothing knob (design §5), so all
  four ride the ramp.
- `mappedLayerTarget(for:raw:)` — raw −1...1 → world units (`LayerTransform`'s own
  coordinate space, `SeedSource.swift`):

  | Axis | Mapped | Why |
  |---|---|---|
  | `x` | −1.7 ... 1.7 | the webUI centroid scale `scale 0.1 0.9 -1.7 1.7` (spec §02 §4) |
  | `y` | −1 ... 1, +raw = up | the original's `1 -1` inversion was the pad's top-left origin, not a world-space fact |
  | `scale` | 0.01 ... 2.0 linear, uniform (x = y) | linear so pinch feels linear; floor keeps the quad non-degenerate. **Flagged for parity review** — the original's accumulator was exponential (spec §04 §1.3), and its exact curve isn't recoverable from the static listing |
  | `rotate` | −180° ... 180°, clamped | the same contract `theta` has (raw ±1 → ∓π). **Flagged** — the original's `accum` was unbounded; a wrapping raw domain would fight the ramp at the seam |

- `layerTransform: LayerTransform` — the ramped, mapped output, refreshed by `tick` alongside
  `RenderParams`. Not a `RenderParams` field: `RenderParams` is `FeedbackCore`'s input; the
  layer transform is the compositor's.
- Startup: `applyStartupDefaults` seeds `rawLayer` to `[0, 0, −0.253, 0]` — scale −0.253 maps
  to 0.747, `StickerSource`'s current default (spec §02 §4), so cold start looks identical.

**Engine.** `Engine.step` assigns `router.layerTransform` to **both** `sticker.transform` and
`movie.transform` each frame, before step 3 (the kitty bump's temporary additive offset,
which still restores afterward). Both, in lockstep, because the original had one picsvid
layer whose transform came from `imageMove` whether it showed a picture or a video — the same
reason `layerEnabled` already keeps both `.enabled` flags in lockstep.

**Presets.** The `Preset` file format does not change (per-layer `LayerTransform` stays). On
recall, `PresetStore.apply` now seeds the router's layer channel from the preset's sticker
layer transform via the inverse map (`LayerAxis.raw(fromMapped:)`) — ramped, the same glide the
9 slots get — instead of poking `layer.transform` directly, which the engine would overwrite
next frame. `capture` is unchanged (it reads the live transforms, which the router wrote).

## 5. Relative gestures resolve against the truth, not a private accumulator

`ControlStateSnapshot` — the closure bundle surfaces already use to read live toggle truth at
poll time — gains one reader:

```swift
public var rawValue: (ControlAxis) -> Float   // router.rawSlots / router.rawLayer, live
```

`KeyboardTrackpadSurface` stops holding `accumulators`/`lastAsserted`. It holds only
`pendingDeltas: [ControlAxis: Float]` between polls; `poll` resolves each as
`clamp(rawValue(axis) + delta, axis.rawRange)` and asserts it **only if it differs** from the
truth it read. Message-on-change falls out of the comparison; a nudge that lands where the
truth already is asserts nothing. This is the same "resolve at poll time against truth"
ruling finding 4 established for toggles, applied to axes.

(`GamepadSurface`'s d-pad saturation accumulator has the same latent problem. It is not in
this design's scope; the mechanism above is the fix when it's wanted.)

## 6. Trackpad gestures and the bindings table (v2)

### 6.1 Default vocabulary

| Gesture | Fingers | Modifier | X → | Y → |
|---|---|---|---|---|
| drag (button held) | 1 | — | Pan X | Pan Y |
| drag | 1 | Option | Image X | Image Y |
| drag | 1 | Shift | Hue shift | Brightness |
| scroll | 2 | — | Pan X | Pan Y |
| scroll | 2 | Option | Image X | Image Y |
| pinch | 2 | — | Zoom | |
| pinch | 2 | Option | Image scale | |
| pinch | 2 | Shift | Saturation | |
| rotate (twist) | 2 | — | Rotate (theta) | |
| rotate | 2 | Option | Image rotate | |

The mental model: *unmodified = the feedback field; Option = the image layer; Shift = colour.*
Drag and scroll deliberately share targets — they are the one- and two-finger versions of
"move". This replaces today's Option-drag → hue/theta (theta moves to twist; hue moves to
Shift-drag).

Rules that don't live in the table:

- Command/Control-chorded gestures pass through untouched, as chorded keys already do.
- Modifier matching is exact over {Option, Shift}: Option+Shift matches no row → passes through.
- Gestures forward only from the Output window (`PerformerInputMonitor.decidePointer`,
  unchanged) — the Controls window keeps scrolling its form.
- Hover (one finger, no button) does nothing. The original's pads were absolute-position
  surfaces; on a trackpad that would fire every time the cursor crossed the output. Drag is
  the deliberate arming gesture; the *pads* (§7) are where absolute positioning lives.

### 6.2 Normalisation (AppKit side, in `PerformerInputMonitor`)

`KeyboardTrackpadSurface` stays AppKit-free and unit-testable; the monitor turns `NSEvent`s
into unit-free deltas:

- drag / scroll: `deltaX|Y` or `scrollingDeltaX|Y` ÷ output content height (existing rule).
- pinch: `event.magnification` as is (existing rule).
- rotate: `event.rotation` (degrees) ÷ 180 — half a turn spans the full raw range at
  sensitivity 1.
- `sensitivity` may be negative to flip a direction. Default signs are chosen so the picture
  follows the fingers (drag right → pans right, twist counter-clockwise → rotates
  counter-clockwise) and are verified by hand in the `swift run` pass — the shader's sign
  conventions are not something to derive from the listing (memory: *measure running Max*).

### 6.3 Dominant-gesture lock

AppKit delivers `magnify`, `rotate`, and two-finger `scrollWheel` events *simultaneously*
during one two-finger movement — a twist leaks small pinch deltas and vice versa, and at
sensitivity 1 fifty leaked events of ±0.01 is half the zoom range. `KeyboardTrackpadSurface`
therefore arbitrates:

- A two-finger sequence starts idle. Each of scroll / pinch / rotate accumulates its own
  cumulative magnitude; the **first to cross its threshold claims the sequence** and the other
  two are discarded until the claimed gesture's `.ended`/`.cancelled` phase arrives.
- Thresholds (code constants, tunable): scroll 0.02 (normalised), pinch 0.05, rotate 5°
  (0.028 normalised). Movement before the threshold is not applied — standard hysteresis.
- The monitor forwards `event.phase` with each gesture event so the surface can see
  `.began`/`.ended`/`.cancelled`. Drag (mouse button) never co-occurs with two-finger events
  and is outside the lock.

### 6.4 Surface API

```swift
public struct GestureEvent {
  public var gesture: TrackpadGesture              // .drag, .scroll, .pinch, .rotate
  public var modifiers: Set<GestureModifier>       // .option, .shift
  public var phase: GesturePhase                   // .began, .changed, .ended, .cancelled
  public var delta: SIMD2<Float>                   // pinch/rotate use .x
}
public func handles(_ gesture: TrackpadGesture, modifiers: Set<GestureModifier>) -> Bool
public func gesture(_ event: GestureEvent)
```

`handles` is the consume/pass-through decision for the monitor, mirroring `handles(_ key:)`:
an unbound gesture+modifier combination is never swallowed.

### 6.5 Bindings JSON, version 2

```json
{
  "version": 2,
  "keys": { "i": "sInvert", "w": "worldBumpEnabled", "…": "…" },
  "trackpad": [
    { "gesture": "drag",   "modifiers": [],         "x": {"axis": "panX",   "sensitivity": 1.0},
                                                     "y": {"axis": "panY",   "sensitivity": 1.0} },
    { "gesture": "drag",   "modifiers": ["option"], "x": {"axis": "layerX", "sensitivity": 1.0},
                                                     "y": {"axis": "layerY", "sensitivity": 1.0} },
    { "gesture": "drag",   "modifiers": ["shift"],  "x": {"axis": "hue",    "sensitivity": 1.0},
                                                     "y": {"axis": "bias",   "sensitivity": 1.0} },
    { "gesture": "scroll", "modifiers": [],         "x": {"axis": "panX",   "sensitivity": 1.0},
                                                     "y": {"axis": "panY",   "sensitivity": 1.0} },
    { "gesture": "scroll", "modifiers": ["option"], "x": {"axis": "layerX", "sensitivity": 1.0},
                                                     "y": {"axis": "layerY", "sensitivity": 1.0} },
    { "gesture": "pinch",  "modifiers": [],         "axis": {"axis": "zoom",        "sensitivity": 1.0} },
    { "gesture": "pinch",  "modifiers": ["option"], "axis": {"axis": "layerScale",  "sensitivity": 1.0} },
    { "gesture": "pinch",  "modifiers": ["shift"],  "axis": {"axis": "saturation",  "sensitivity": 1.0} },
    { "gesture": "rotate", "modifiers": [],         "axis": {"axis": "theta",       "sensitivity": 1.0} },
    { "gesture": "rotate", "modifiers": ["option"], "axis": {"axis": "layerRotate", "sensitivity": 1.0} }
  ],
  "pads": [
    { "x": "layerX", "y": "layerY" },
    { "x": "panX",   "y": "panY" }
  ]
}
```

- `trackpad` is a list of `TrackpadBinding { gesture, modifiers, target }` where `target` is
  `.xy(TrackpadAxis, TrackpadAxis)` for drag/scroll and `.single(TrackpadAxis)` for
  pinch/rotate; decoding rejects an arity mismatch and duplicate (gesture, modifiers) rows.
- `TrackpadAxis.slot: ControlSlot` becomes `TrackpadAxis.axis: ControlAxis`.
- `pads` is exactly two `PadAssignment { x, y: ControlAxis }`.
- `BindingsLoader` rejects any `version` other than 2 with a clear error. No v1 migration:
  the only v1 file in existence is the bundled default this replaces.

### 6.6 Where the file lives: `BindingsStore`

Pad reassignment persists, and "the bindings table is data" only means something if the data
can be edited without a rebuild. `BindingsStore` resolves, in order:
`~/Library/Application Support/Feedbax/Bindings.json` → the bundled `DefaultBindings.json`.
`save(_:)` writes the user file (creating the directory), round-tripping the whole `Bindings`
struct — `Bindings` already encodes. Only pad assignments write today; a hand-edited key or
gesture table in that file is preserved by the round trip. Bindings are read once at
bootstrap; hot reload while running stays out of scope.

## 7. XY pads in the Controls window

```
┌ Surfaces ───────────────────────────────────────┐
│  ┌──────────────┐        ┌──────────────┐        │
│  │      ·       │        │       ·      │        │
│  │      ┼   ●   │        │   ●   ┼      │        │
│  │      ·       │        │       ·      │        │
│  └──────────────┘        └──────────────┘        │
│  X [Image X     ▾]       X [Pan X       ▾]       │
│  Y [Image Y     ▾]       Y [Pan Y       ▾]       │
└──────────────────────────────────────────────────┘
```

- `XYPad` (new SwiftUI view): a square with a centre crosshair and a dot. A drag sets both
  axes **absolutely** from the pointer position (the Mira pad's behaviour), mapped through
  each axis's `rawRange`; the dot also *follows* the axis truth, so a trackpad gesture or a
  preset recall moves it. Two pickers below each pad list `ControlAxis.live` by `displayName`.
- Placement: a new "Surfaces" section at the top of the panel's right column, above the
  Layer/Presets sections; pads 160 pt square, side by side.
- Model (`EngineViewModel`):
  - `slider(_:changedTo:)` generalises to `axis(_ axis: ControlAxis, changedTo:)`; the mirror
    becomes `axisValues: [ControlAxis: Double]`. Slot sliders keep working via `.slot(...)`.
  - `refreshMirrorsFromTruth` now also refreshes the 11 axis mirrors from `router.rawSlots` /
    `router.rawLayer` (compare-before-assign, as today), with the same optimistic reapply of
    this object's own pending writes that toggles already get — so a slider being dragged
    doesn't flicker back for one tick.
  - `padAssignments: [PadAssignment]` (published) and `setPadAxis(pad:, .x|.y, to:)`, which
    writes through `BindingsStore.save`.
- Four new sliders in the Layer Source section — `IMAGE X`, `IMAGE Y`, `IMAGE SCALE`, `IMAGE
  ROTATE` — so every layer axis is reachable even when neither pad is assigned to it.

## 8. The Controls Reference window, the Help menu, and `?`

### 8.1 Data first: `ControlReference`

A pure model, built from data, no SwiftUI:

```swift
public struct ControlReference {
  public struct Row { public var input: String; public var modifiers: String;
                      public var action: String; public var kind: String }
  public struct Section { public var title: String; public var rows: [Row] }
  public var sections: [Section]
  public static func build(from bindings: Bindings, gamepad: [Row]) -> ControlReference
}
```

Sections and their sources:

| Section | Source |
|---|---|
| Keyboard — fixed | the keys `PerformerInputMonitor`/the surface hardcode: `Esc` fullscreen, `[`/`]` erase −/+, `?` this window |
| Keyboard — bound | `bindings.keys`, sorted, via `ToggleEvent.displayName` |
| Trackpad | `bindings.trackpad`, in file order, via `ControlAxis.displayName` |
| Pads | `bindings.pads` — live, so a reassignment shows immediately |
| Gamepad | `GamepadSurface.reference: [ControlReference.Row]`, a static table declared beside the mapping code (gamepad bindings stay code-defined, as design §5 deferred) |

`displayName` is an exhaustive `switch` on each enum, so adding an axis or toggle without a
name is a compile error, not a blank row.

### 8.2 The window

`Window("Controls Reference", id: FeedbaxWindow.referenceID)` in `FeedbaxScenes` — a
third scene, so it gets a Window-menu entry and frame restoration for free, like the other
two. `ControlsReferenceView` renders the sections as tables: key caps in monospace, then
modifiers, then the action. Read-only; observes the store's bindings so pad rows are live.

### 8.3 Opening it

- **Menu:** `FeedbaxScenes` adds `.commands { CommandGroup(replacing: .help) { Button("Feedbax
  Controls") … .keyboardShortcut("?", modifiers: .command) } }` — the first app-defined menu
  item; ⌘? is the platform's Help shortcut.
- **`?` key:** handled in `PerformerInputMonitor` next to Escape — no text editor focused,
  modifier set ⊆ {Shift} (so `Shift-/` on US layouts and a bare `?` on layouts that have one) —
  and consumed. Why not a bare `?` key-equivalent on the menu item: unmodified menu key
  equivalents win over text fields, so typing `?` in the preset-name field would open help.
- **The AppKit→SwiftUI bridge:** the monitor posts `Notification.Name.feedbaxShowControlsReference`;
  both window content views `.onReceive` it and call `openWindow(id:)`. Two observers are
  harmless — `openWindow` on an open window just focuses it (the same reasoning
  `LaunchWindowOpener` already relies on).

## 9. Testing

`swift test` drives everything below `SwiftUI`; the views themselves are verified by
`swift build` plus a manual `swift run --package-path app feedbax-dev` pass, per the panel's
existing convention.

| Area | Tests |
|---|---|
| `ControlAxis` | marker round-trip for all 11; `rawRange`; `displayName` non-empty for every case |
| `Bindings` v2 | decode the bundled default; encode→decode round-trip equals; arity mismatch, duplicate row, unknown axis, and `version: 1` each throw |
| `BindingsStore` | user file wins over bundled; missing user file falls back; `save` round-trips including untouched keys/trackpad |
| `KeyboardTrackpadSurface` | every default row dispatches to its axis; unbound modifier combo `handles == false`; deltas resolve against a mutable truth snapshot (the §5 jump is gone); a nudge landing on the truth asserts nothing; gesture lock: rotate past threshold discards concurrent pinch until `.ended`; sub-threshold movement applies nothing |
| `PerformerInputMonitor` | new pure decision helpers: modifier-set extraction (Cmd/Ctrl → pass through, Option+Shift → pass through), rotate normalisation, `?` recognition with and without Shift, `?` ignored in a text editor |
| `ControlRouter` | layer axes ramp and map; `layerTransform` at startup equals `LayerTransform(scale: 0.747)`; last-writer-wins across `layer` writes; `raw(fromMapped:)` inverts `mappedLayerTarget` |
| `Engine` (wiring) | both layers' transforms equal `router.layerTransform` after a step; kitty bump offset still restores |
| `PresetStore` | recall seeds the router layer channel (ramped) from the sticker layer; capture unchanged |
| `EngineViewModel` | pad write asserts both axes once then drains; axis mirrors follow router truth; own pending write survives the truth refresh; `setPadAxis` persists through a store fake |
| `ControlReference` | every bound key and every trackpad row appears exactly once; the four fixed keys appear; gamepad rows pass through; changing `bindings.pads` changes the Pads section |

## 10. File map

New:
- `Control/ControlAxis.swift` — `LayerAxis`, `ControlAxis`, ranges, markers, display names.
- `Control/TrackpadBinding.swift` — `TrackpadGesture`, `GestureModifier`, `GesturePhase`,
  `GestureEvent`, `TrackpadBinding`, `PadAssignment`, their `Codable`.
- `Control/BindingsStore.swift`
- `Control/ControlReference.swift`
- `UI/XYPad.swift`
- `UI/ControlsReferenceView.swift`

Changed:
- `Control/ControlVector.swift` — `ControlWrite.layer`; `ControlStateSnapshot.rawValue`.
- `Control/Bindings.swift` — v2 shape; `TrackpadBindings` struct removed in favour of the list.
- `Control/DefaultBindings.json` — v2 content (§6.5).
- `Control/ControlRouter.swift` — layer channel (§4).
- `Control/KeyboardTrackpadSurface.swift` — §5 and §6.3–6.4.
- `Control/GamepadSurface.swift` — `static let reference` only.
- `Control/Presets.swift` — recall seeds the layer channel.
- `Engine/Engine.swift` — applies `router.layerTransform` each step.
- `UI/PerformerInputMonitor.swift` — `.rotate` mask, plain/Shift drags, modifier extraction,
  phase forwarding, `?`.
- `UI/EngineViewModel.swift` — axis generalisation, pad model, mirrors from truth.
- `UI/OperatorPanel.swift` — Surfaces section, four layer sliders.
- `UI/FeedbaxScenes.swift` — third window, `.commands`, notification receivers.
- `UI/AppBootstrap.swift` — `BindingsStore`, snapshot `rawValue`.
- `README.md` — controls section rewritten from the §6.1 table.

## 11. Out of scope (deliberate)

- **Three- and four-finger gestures** — contested by macOS system gestures by default. If
  wanted later, the path is raw `NSTouch` tracking on `RenderView` plus a documented System
  Settings change; the `GestureEvent` shape already has room for a finger count.
- **Raw `NSTouch` absolute finger tracking** (the trackpad *as* a Mira pad) — the pads in §7
  give absolute positioning where it's expected, on screen.
- Hover-to-pan; smart-magnify (two-finger double tap); force/pressure.
- Gamepad bindings moving into JSON; hot reload of bindings while running; v1 migration.
- The gamepad's own stale-accumulator fix (§5 mechanism applies when wanted).

## 12. Flagged for parity review (decisions made, not measured)

- Image scale mapping is linear 0.01–2.0; the original's was an exponential accumulator whose
  curve isn't recoverable statically.
- Image rotate is clamped ±180° like `theta`; the original's accumulator was unbounded.
- Gesture directions (sign of each default `sensitivity`) are set by hand in the run pass.
- Gesture-lock thresholds are first guesses.

## 13. Swift notes for the reader

- `enum ControlAxis { case slot(ControlSlot); case layer(LayerAxis) }` is an enum with
  *associated values* — each case carries a payload — and `switch` over it is exhaustive, which
  is what makes "every axis has a display name" a compile-time guarantee.
- `Set<GestureModifier>` over an `OptionSet`: a `Set` of a small `Codable` enum encodes as a
  readable JSON array (`["option"]`) and compares by value, which is all the table needs.
- `NotificationCenter` is the conventional bridge from an AppKit object (the event monitor)
  to SwiftUI views without either owning the other; `.onReceive` subscribes a view to it.
