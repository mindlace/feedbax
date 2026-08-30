# Image Layer Without a Switch, and a Panel That Fits — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Delete the image layer's on/off setting in favour of an `Off` entry in the picker, rename kitty bump to image bump, and re-lay-out the Controls panel so the XY pads stop clipping.

**Architecture:** `LayerSettings.enabled` stays as the internal gate the compositor and presets already use, but nothing outside the layer's own selection writes it: selecting an image shows it, selecting `Off` hides it, and an empty folder shows nothing. Renames are Swift-and-UI only — every persisted string (bindings markers, `PresetToggles` field names) is left exactly as it is, so no migration is owed. The panel moves the two XY pads to a full-width band and splits the rest into two balanced columns with every toggle sitting next to what it modifies.

**Tech Stack:** Swift 5.9 / SwiftUI / Metal, XCTest via `swift test`, macOS 14.

**Spec:** `docs/superpowers/specs/2026-08-29-image-layer-and-panel-layout-design.md`

## Global Constraints

- **Run tests with `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app`** from the worktree root. Without `DEVELOPER_DIR` the CommandLineTools toolchain is picked and every test file fails with `no such module 'XCTest'`.
- **`GoldenFrameTests.testAllScenariosMatchReferences` fails on `main`** ("NO REFERENCE COMMITTED" for `rota-spiral`, `sinvert-kaleidoscope`, `hsl-drift`). It is not yours. A run is green when that is the *only* failure. Never regenerate golden references to make it pass.
- **Never change a persisted string.** The bindings markers `"layerEnabled"` and `"kittyBumpEnabled"`, the keys in `app/Sources/FeedbaxKit/Control/DefaultBindings.json`, and the field names on `PresetToggles` (`kittyBump`, `layerEnabled`) keep their current spelling. An unknown marker is a hard startup throw (`Bindings.toggleEvents(fromMarkers:)`), and `PresetToggles` uses synthesized `Codable` with no `decodeIfPresent`, so a renamed field throws on every saved preset.
- **Do not touch `patches/` or `docs/spec/` prose** except the one added line in Task 6. Those describe the Max instrument, whose buses really are named `kittybump`/`kittybumpsignal`.
- **Keep sticker and movie `layer.enabled` in lockstep.** Every write goes through `Engine.handle(.imageEnabled(_:))`, never directly to one source. `EngineTests` pins this.
- **`Off` is never an entry in `StickerSource.items`.** It does not shift indices, `itemCount` does not count it, and the stepper and normalized slider never reach it.
- **"TRANSPARANCY"** keeps its deliberate misspelling wherever it appears in the UI.
- Commit after each task with a Conventional Commits subject.

---

### Task 1: Rename kitty bump → image bump (Swift and UI only)

A pure rename, so there is no red phase: the compiler is the test that the rename is complete, and the new guard test proves the *persisted* names did not move with it. Do the guard test first anyway so it is in place before the rename churns the files.

**Files:**
- Modify: `app/Sources/FeedbaxKit/Control/ControlVector.swift` (enum case, snapshot property, `current(for:)`, `constant`, `displayName`)
- Modify: `app/Sources/FeedbaxKit/Control/Bindings.swift:15,30,50` (case names only — the marker *strings* stay)
- Modify: `app/Sources/FeedbaxKit/Engine/Engine.swift` (`kittyReceiver`, `bumpsEnabled.kitty`, `handle`, preset capture/apply, stage 3)
- Modify: `app/Sources/FeedbaxKit/Audio/AudioAnalysis.swift` (`KittyBumpReceiver`, `kittyBumpRaw`, `kittyBumpSum`, `kittyBumpCount`)
- Modify: `app/Sources/FeedbaxKit/Audio/EnvelopeFollowers.swift:7` (doc comment)
- Modify: `app/Sources/FeedbaxKit/UI/EngineViewModel.swift` (`kittyBumpOn`, `setKittyBumpEnabled`, mirror sync, `applyOptimistically`)
- Modify: `app/Sources/FeedbaxKit/UI/AppBootstrap.swift:79` (snapshot wiring)
- Modify: `app/Sources/FeedbaxKit/UI/OperatorPanel.swift:93-96` (label)
- Modify: `app/Sources/FeedbaxKit/Control/Presets.swift:97` (`toggleEvents()` case name only — the *field* stays `kittyBump`)
- Test: `app/Tests/FeedbaxKitTests/BindingsTests.swift` (new guard test), plus mechanical updates in `EngineTests`, `EngineWiringTests`, `AudioAnalysisTests`, `WaveformTests`, `PresetTests`, `GoldenFrameTests`, `LoopStabilityTests`, `EngineViewModelTests`, `KeyboardSurfaceTests`

**Interfaces:**
- Consumes: nothing.
- Produces: `ToggleEvent.imageBumpEnabled(Bool)`; `ControlStateSnapshot.imageBumpEnabled: () -> Bool` (and the init label of the same name); `Engine.bumpsEnabled` becomes `(world: Bool, wave: Bool, image: Bool)`; `ImageBumpReceiver`; `FrameAudio.imageBumpRaw: Float`; `EngineViewModel.imageBumpOn` / `setImageBumpEnabled(_:)`.

- [ ] **Step 1: Write the guard test that persisted names never move**

Add to `app/Tests/FeedbaxKitTests/BindingsTests.swift`:

```swift
  /// The wire names are frozen even though the Swift names moved to "image bump"
  /// (2026-08-29 design doc §4). `Bindings.toggleEvents(fromMarkers:)` THROWS on an unknown
  /// marker and `BindingsStore.init` rethrows by design, so renaming a marker is not a
  /// cosmetic change — it is a startup failure for anyone with a saved bindings file.
  func testPersistedToggleMarkersAreFrozen() throws {
    XCTAssertEqual(ToggleEvent.imageBumpEnabled(true).marker, "kittyBumpEnabled")
    XCTAssertEqual(ToggleEvent.imageEnabledMarkerProbe, "layerEnabled")
    XCTAssertEqual(ToggleEvent.fromMarker("kittyBumpEnabled", flip: true), .imageBumpEnabled(true))
    XCTAssertEqual(ToggleEvent.fromMarker("layerEnabled", flip: true), .layerEnabled(true))
  }
```

Note: `imageEnabledMarkerProbe` does not exist yet and the `.layerEnabled` half is asserted as-is here — Task 3 renames that case and updates these two lines. For THIS task, write only the two `kittyBumpEnabled` assertions plus `XCTAssertEqual(ToggleEvent.layerEnabled(true).marker, "layerEnabled")`, i.e.:

```swift
  func testPersistedToggleMarkersAreFrozen() throws {
    XCTAssertEqual(ToggleEvent.imageBumpEnabled(true).marker, "kittyBumpEnabled")
    XCTAssertEqual(ToggleEvent.layerEnabled(true).marker, "layerEnabled")
    XCTAssertEqual(ToggleEvent.fromMarker("kittyBumpEnabled", flip: true), .imageBumpEnabled(true))
    XCTAssertEqual(ToggleEvent.fromMarker("layerEnabled", flip: true), .layerEnabled(true))
  }
```

- [ ] **Step 2: Run it and watch it fail to compile**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter BindingsTests`
Expected: compile error, `type 'ToggleEvent' has no member 'imageBumpEnabled'`.

- [ ] **Step 3: Do the rename**

Apply exactly these identifier substitutions across `app/Sources` and `app/Tests`:

| From | To |
|---|---|
| `kittyBumpEnabled` (Swift identifier — enum case, snapshot property, init label) | `imageBumpEnabled` |
| `KittyBumpReceiver` | `ImageBumpReceiver` |
| `kittyReceiver` | `imageBumpReceiver` |
| `kittyBumpRaw` | `imageBumpRaw` |
| `kittyBumpSum` | `imageBumpSum` |
| `kittyBumpCount` | `imageBumpCount` |
| `kittyBumpOn` | `imageBumpOn` |
| `setKittyBumpEnabled` | `setImageBumpEnabled` |
| `bumpsEnabled.kitty` and the tuple label `kitty:` | `bumpsEnabled.image`, `image:` |
| `displayName` string `"Kitty bump"` | `"Image bump"` |
| `OperatorPanel` label `"Kitty Bump"` | `"Image Bump"` |

**Do NOT substitute** (verify each is still spelled the old way when you are done):
- the string literals `"kittyBumpEnabled"` in `Bindings.fromMarker` and `Bindings.marker`
- `"kittyBumpEnabled"` in `DefaultBindings.json`
- `PresetToggles.kittyBump`, its init label, and `preset.toggles.kittyBump` at the two `Engine` call sites
- anything under `patches/` or `docs/`

In `Bindings.swift`, leave a comment above the `case .imageBumpEnabled: return "kittyBumpEnabled"` line:

```swift
    // Wire name deliberately NOT renamed with the Swift case (2026-08-29 design doc §4): an
    // unknown marker is a hard startup throw, and this change ships no migration.
    case .imageBumpEnabled: return "kittyBumpEnabled"
```

Add the equivalent comment above `PresetToggles.kittyBump`:

```swift
  /// Wire name frozen — see the `Bindings.marker` comment and 2026-08-29 design doc §4. The
  /// Swift-side concept is "image bump"; this field name is what saved presets contain.
  public var kittyBump = false
```

And in `Engine`'s stage 3, update the comment to say image bump while keeping the citation:

```swift
    // 3. Image bump ("kittieBump™" in the original — spec §04 §1.3, bus `kittybump`): an
    // ADDITIVE, non-persistent modulator contribution on top of the sticker layer's manual
    // transform (design §5's Modulator rule). It never becomes the new manual value, so it
    // must not accumulate frame over frame.
```

- [ ] **Step 4: Build and run the full suite**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app`
Expected: PASS except the known `GoldenFrameTests` failure.

- [ ] **Step 5: Verify no persisted string moved**

Run: `grep -rn "kittyBumpEnabled\|kittyBump" app/Sources/FeedbaxKit/Control/DefaultBindings.json app/Sources/FeedbaxKit/Control/Bindings.swift app/Sources/FeedbaxKit/Control/Presets.swift`
Expected: the JSON key, the two marker strings, and the `PresetToggles.kittyBump` field — and nothing else.

- [ ] **Step 6: Commit**

```bash
git add app/Sources app/Tests
git commit -m "refactor(controls): rename kitty bump to image bump in Swift and UI" \
           -m "Wire names (bindings markers, preset field) deliberately unchanged; it only ever offsets the sticker transform, so the name now says so."
```

---

### Task 2: Cold-start defaults — show an image and arm the bump

**Files:**
- Modify: `app/Sources/FeedbaxKit/Engine/Engine.swift` (rename `enableImageLayerIfStocked`, add the bump)
- Modify: `app/Sources/FeedbaxKit/UI/AppBootstrap.swift` (call site)
- Test: `app/Tests/FeedbaxKitTests/EngineTests.swift`

**Interfaces:**
- Consumes: `Engine.bumpsEnabled.image` from Task 1.
- Produces: `Engine.applyColdStartImageDefaults()` — replaces `enableImageLayerIfStocked()`, which no longer exists.

- [ ] **Step 1: Write the failing test**

In `app/Tests/FeedbaxKitTests/EngineTests.swift`, rename the three `testColdStart…` tests' calls and add the bump assertions:

```swift
  func testColdStartShowsAnImageAndArmsTheBumpWhenTheFolderHasImages() throws {
    let folder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
    try Data([0]).write(to: folder.appendingPathComponent("a.png"))

    let e = try Engine(context: try MetalContext(), stickerFolder: folder)
    XCTAssertFalse(e.sticker.layer.enabled)
    XCTAssertFalse(e.bumpsEnabled.image)

    e.applyColdStartImageDefaults()

    XCTAssertTrue(e.sticker.layer.enabled, "a stocked folder means there is something to show")
    XCTAssertTrue(e.movie.layer.enabled, "sticker/movie stay in lockstep")
    XCTAssertTrue(e.bumpsEnabled.image, "the bump is armed with the image (design doc §4)")
  }

  func testColdStartDoesNothingWhenTheFolderIsEmpty() throws {
    let folder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

    let e = try Engine(context: try MetalContext(), stickerFolder: folder)
    e.applyColdStartImageDefaults()

    XCTAssertFalse(e.sticker.layer.enabled)
    XCTAssertFalse(e.movie.layer.enabled)
    XCTAssertFalse(e.bumpsEnabled.image, "nothing to bump")
  }

  func testColdStartNeverTurnsThingsOff() throws {
    let folder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

    let e = try Engine(context: try MetalContext(), stickerFolder: folder)
    e.sticker.layer.enabled = true
    e.bumpsEnabled.image = true
    e.applyColdStartImageDefaults()   // empty folder, but both are already on

    XCTAssertTrue(e.sticker.layer.enabled, "an empty folder must not switch an enabled layer off")
    XCTAssertTrue(e.bumpsEnabled.image)
  }
```

- [ ] **Step 2: Run and watch it fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter EngineTests`
Expected: compile error, `value of type 'Engine' has no member 'applyColdStartImageDefaults'`.

- [ ] **Step 3: Implement**

Replace `Engine.enableImageLayerIfStocked()` with:

```swift
  /// Cold-start policy for the image layer, called once by `AppBootstrap.start()` right after
  /// `ControlRouter.applyStartupDefaults` (which carries slots, axes and erase, but no
  /// toggles). If the sticker folder actually has images in it, show one and arm the image
  /// bump.
  ///
  /// This is the port catching up with the instrument, not diverging from it: `pic enable` was
  /// `loadmess 0` in Sean's build, but the patch itself became `loadmess 1` — on at load — on
  /// 2026-08-29, "so a loaded sticker is visible without an iPad" (spec §04 §1.3 slot 0). The
  /// one difference is the stocked check, and it only bites where the patch's rule has nothing
  /// to act on anyway: with no images there is no texture to draw.
  ///
  /// Asserts ON only, and only when stocked, so it can never revert a decision a preset or a
  /// performer already made.
  public func applyColdStartImageDefaults() {
    guard sticker.itemCount > 0 else { return }
    handle(.imageEnabled(true))   // not a direct write — keeps sticker/movie in lockstep
    bumpsEnabled.image = true
  }
```

Note: `.imageEnabled` is Task 3's rename. Until Task 3 lands, write `handle(.layerEnabled(true))` here and change it in Task 3 — the plan's Task 3 step list includes that edit.

In `AppBootstrap.start()`, update the call and its comment:

```swift
    // `applyStartupDefaults` carries slots, layer axes and erase, but no toggles — so without
    // this the image layer stays off through every GUI launch and the picker looks broken.
    engine.applyColdStartImageDefaults()
```

- [ ] **Step 4: Run the tests**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter EngineTests`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app/Sources app/Tests
git commit -m "feat(engine): arm the image bump with the image at cold start"
```

---

### Task 3: Selection is the on/off state

The heart of the change. After this task, nothing but selection (and the `p`/gamepad gesture) writes the layer's enabled flag.

**Note on the spec's "remembered index":** none is needed. Hiding the image does not change `selectedIndex`, so showing it again brings back the same image for free. Do not add a memory field.

**Files:**
- Modify: `app/Sources/FeedbaxKit/Control/ControlVector.swift` (case rename + `displayName`)
- Modify: `app/Sources/FeedbaxKit/Control/Bindings.swift` (case names; marker strings unchanged)
- Modify: `app/Sources/FeedbaxKit/Control/Presets.swift` (`toggleEvents()` case name; field name unchanged)
- Modify: `app/Sources/FeedbaxKit/Engine/Engine.swift` (`handle`, `showImage`/`hideImage`, Task 2's call site)
- Modify: `app/Sources/FeedbaxKit/UI/EngineViewModel.swift` (mirror rename, selection paths assert showing)
- Modify: `app/Sources/FeedbaxKit/UI/AppBootstrap.swift` (snapshot wiring label)
- Modify: `app/Sources/FeedbaxKit/Control/GamepadSurface.swift:95,236`
- Test: `app/Tests/FeedbaxKitTests/EngineTests.swift`, `app/Tests/FeedbaxKitTests/EngineViewModelTests.swift`, `app/Tests/FeedbaxKitTests/BindingsTests.swift`

**Interfaces:**
- Consumes: `Engine.applyColdStartImageDefaults()` (Task 2).
- Produces: `ToggleEvent.imageEnabled(Bool)` (marker still `"layerEnabled"`, `displayName` `"Image on/off"`); `Engine.showImage()`, `Engine.hideImage()`, `Engine.isImageShown: Bool`; `EngineViewModel.imageShown: Bool`, `EngineViewModel.hideImage()`, `EngineViewModel.showSelectedImage()`.

- [ ] **Step 1: Write the failing tests**

In `EngineTests.swift`:

```swift
  func testShowAndHideImageKeepTheSelectionAndTheLockstep() throws {
    let folder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
    try Data([0]).write(to: folder.appendingPathComponent("a.png"))
    try Data([0]).write(to: folder.appendingPathComponent("b.png"))

    let e = try Engine(context: try MetalContext(), stickerFolder: folder)
    e.sticker.selectedIndex = 1
    e.showImage()
    XCTAssertTrue(e.isImageShown)

    e.hideImage()

    XCTAssertFalse(e.isImageShown)
    XCTAssertFalse(e.movie.layer.enabled, "lockstep holds through hide")
    XCTAssertEqual(e.sticker.selectedIndex, 1,
                   "hiding must not disturb the selection — showing again brings back the same image")

    e.showImage()
    XCTAssertTrue(e.isImageShown)
    XCTAssertEqual(e.sticker.selectedIndex, 1)
  }
```

In `EngineViewModelTests.swift` (these use `EngineViewModel(engine:)` with a real `Engine` — follow the existing pattern at `EngineViewModelTests.swift:87`):

```swift
  func testPickingAnImageShowsIt() throws {
    let folder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
    try Data([0]).write(to: folder.appendingPathComponent("a.png"))
    let engine = try Engine(context: try MetalContext(), stickerFolder: folder)
    engine.hideImage()
    let vm = EngineViewModel(engine: engine)

    vm.setStickerIndex(0)

    XCTAssertTrue(engine.isImageShown, "choosing an image is how you turn the layer on now")
    XCTAssertTrue(vm.imageShown)
  }

  func testHideImageLeavesTheSelectionAlone() throws {
    let folder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
    try Data([0]).write(to: folder.appendingPathComponent("a.png"))
    let engine = try Engine(context: try MetalContext(), stickerFolder: folder)
    let vm = EngineViewModel(engine: engine)
    vm.setStickerIndex(0)

    vm.hideImage()

    XCTAssertFalse(vm.imageShown)
    XCTAssertEqual(vm.stickerIndex, 0)
  }

  func testImportingIntoAnEmptyFolderEndsWithTheImageShowing() throws {
    let empty = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: empty, withIntermediateDirectories: true)
    let inbox = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: inbox, withIntermediateDirectories: true)
    try Data([0]).write(to: inbox.appendingPathComponent("dropped.png"))

    let engine = try Engine(context: try MetalContext(), stickerFolder: empty)
    engine.applyColdStartImageDefaults()          // empty at launch, so nothing is shown
    XCTAssertFalse(engine.isImageShown)
    let vm = EngineViewModel(engine: engine)

    vm.importStickers([inbox.appendingPathComponent("dropped.png")])

    XCTAssertTrue(engine.isImageShown,
                  "dropping images into an empty folder must not leave the picker inert")
  }
```

Update the two `.layerEnabled` lines in `BindingsTests.testPersistedToggleMarkersAreFrozen` to `.imageEnabled`, keeping both `"layerEnabled"` strings.

- [ ] **Step 2: Run and watch them fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter "EngineTests|EngineViewModelTests"`
Expected: compile errors on `showImage`, `hideImage`, `isImageShown`, `imageShown`.

- [ ] **Step 3: Rename the toggle case**

`ToggleEvent.layerEnabled` → `ToggleEvent.imageEnabled` everywhere in `app/Sources` and `app/Tests`, including `ControlStateSnapshot.layerEnabled` → `imageEnabled` (property, init label, `current(for:)`, `constant`), `Bindings.fromMarker`/`marker`/`resolvingFlip` case names, `Presets.toggleEvents()`, `GamepadSurface.swift:95,236`, and `AppBootstrap.swift`'s snapshot wiring. The marker strings `"layerEnabled"` and `PresetToggles.layerEnabled` do **not** change; add the same frozen-wire-name comment used in Task 1.

`displayName` becomes:

```swift
    case .imageEnabled: return "Image on/off"
```

- [ ] **Step 4: Add the Engine methods**

```swift
  /// Whether an image is currently drawing. There is no separate switch for this any more —
  /// it is what the picker's selection says (2026-08-29 design doc §3): choosing an image
  /// shows it, choosing `Off` hides it, and an empty folder shows nothing.
  public var isImageShown: Bool { sticker.layer.enabled }

  /// Show the currently selected image. Hiding never disturbs `selectedIndex`, so this brings
  /// back exactly the image that was showing before `hideImage()`.
  public func showImage() { handle(.imageEnabled(true)) }

  public func hideImage() { handle(.imageEnabled(false)) }
```

Change Task 2's `handle(.layerEnabled(true))` inside `applyColdStartImageDefaults()` to `showImage()`.

- [ ] **Step 5: Make selection assert showing, in the view model**

Rename `layerOn` → `imageShown` and `setLayerEnabled` → (deleted; replaced by the two methods below). In `refreshMirrorsFromTruth` and `applyOptimistically`, rename the mirror accordingly.

```swift
  /// Selecting an image is how the layer gets turned on (2026-08-29 design doc §3) — there is
  /// no separate enable control for a performer to have left off.
  public func setStickerIndex(_ index: Int) {
    guard let sticker = engine?.sticker else { stickerIndex = index; return }
    sticker.selectedIndex = index
    stickerIndex = sticker.selectedIndex   // read back — `StickerSource` clamps
    showSelectedImage()
  }

  /// The picker's `Off` tile, and the restore half of the `p` / gamepad-B gesture.
  public func hideImage() {
    imageShown = false
    pendingToggles.append(.imageEnabled(false))
  }

  public func showSelectedImage() {
    guard engine?.sticker.itemCount ?? 0 > 0 else { return }   // nothing to show
    imageShown = true
    pendingToggles.append(.imageEnabled(true))
  }
```

Add `showSelectedImage()` to the end of `importStickers(_:)` (after `refreshStickerLibrary()`), and to `selectSticker(named:)` by virtue of it already routing through `setStickerIndex`.

Note the `@Published private(set) var imageShown` needs its setter reachable from these methods — it already is, they are members of the same type.

- [ ] **Step 6: Run the tests**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app`
Expected: PASS except the known `GoldenFrameTests` failure.

- [ ] **Step 7: Commit**

```bash
git add app/Sources app/Tests
git commit -m "feat(engine): make image selection the on/off state" \
           -m "Choosing an image shows it, choosing Off hides it, an empty folder shows nothing. Hiding leaves the selection alone, so p/gamepad B restore the same image."
```

---

### Task 4: The `Off` tile, and deleting the Layer Enable checkbox

**Files:**
- Modify: `app/Sources/FeedbaxKit/UI/StickerPicker.swift`
- Modify: `app/Sources/FeedbaxKit/UI/OperatorPanel.swift:88` (delete the toggle)

**Interfaces:**
- Consumes: `EngineViewModel.imageShown`, `hideImage()`, `showSelectedImage()`, `selectSticker(named:)` (Task 3).
- Produces: no new API — UI only.

- [ ] **Step 1: Delete the Layer Enable toggle**

Remove this line from `OperatorPanel.swift`'s Toggles section:

```swift
          Toggle("Layer Enable", isOn: Binding(get: { vm.layerOn }, set: { vm.setLayerEnabled($0) }))
```

- [ ] **Step 2: Add the `Off` tile to the grid**

In `StickerPicker.swift`, inside `gridBody`'s `LazyVGrid`, before the `ForEach`:

```swift
          offTile
          ForEach(vm.stickerNames, id: \.self) { name in
            tile(name)
          }
```

And add, next to `tile(_:)`:

```swift
  /// The replacement for the old "Layer Enable" checkbox. It is a UI affordance, NOT an entry
  /// in `StickerSource.items` — it shifts no index, `itemCount` does not count it, and the
  /// stepper and normalized slider never reach it (2026-08-29 design doc §3.1). Those three
  /// are the index space the keyboard and gamepad drive; a sentinel in them would offset every
  /// selection a performer has memorised.
  private var offTile: some View {
    let isSelected = !vm.imageShown
    return Button {
      vm.hideImage()
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: 4)
          .fill(Color.secondary.opacity(0.08))
        Image(systemName: "nosign")
          .foregroundStyle(.secondary)
      }
      .frame(width: Self.tileSize, height: Self.tileSize)
      .overlay(
        RoundedRectangle(cornerRadius: 4)
          .strokeBorder(isSelected ? Color.accentColor : Color.secondary.opacity(0.35),
                        style: StrokeStyle(lineWidth: isSelected ? 2 : 1, dash: isSelected ? [] : [3, 2]))
      )
    }
    .buttonStyle(.plain)
    .help("Show no image")
  }
```

- [ ] **Step 3: Make the image tile's selected ring respect "not showing"**

In `tile(_:)`, change the first line so a hidden layer shows no image as selected:

```swift
    let isSelected = vm.imageShown && name == vm.selectedStickerName
```

- [ ] **Step 4: Update the selected-name line under the grid**

In `body`'s `DisclosureGroup`, replace the `if let selected = vm.selectedStickerName` block's `Text(selected)` with a line that reads correctly when nothing is showing:

```swift
        Text(vm.imageShown ? (vm.selectedStickerName ?? "—") : "No image")
          .font(.caption)
          .foregroundStyle(.secondary)
          .lineLimit(1)
          .truncationMode(.middle)
          .frame(maxWidth: .infinity, alignment: .leading)
```

- [ ] **Step 5: Build**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift build --package-path app`
Expected: `Build complete!` — there is no SwiftUI test rig in this package, so the compiler plus Task 6's on-screen check are the verification.

- [ ] **Step 6: Commit**

```bash
git add app/Sources
git commit -m "feat(ui): replace the Layer Enable checkbox with an Off tile in the picker"
```

---

### Task 5: Panel layout — pads on top, two balanced columns

**Files:**
- Modify: `app/Sources/FeedbaxKit/UI/OperatorPanel.swift` (`body`, lines 66-195)
- Modify: `app/Sources/FeedbaxKit/UI/StickerPicker.swift:32-39` (re-tune tile size and cap, rewrite the comments that justify them)

**Interfaces:**
- Consumes: everything from Tasks 1-4.
- Produces: no new API.

- [ ] **Step 1: Restructure `body`**

Replace the outer `HStack` with a `VStack` whose first child is the pads band. The section contents move as follows — this is the whole re-layout:

```swift
  public var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      // The XY pads are the only control in this panel with a hard width floor: two 160pt
      // squares plus 16pt of spacing needs 336pt, against ~254pt of content width per column
      // at a 600pt window, which is why they used to clip. A full-width band is what fixes
      // that, and it puts the most-performed control biggest and nearest to hand.
      // (2026-08-29 design doc §5.2 — this deliberately supersedes the 2026-08-26 design
      // doc's "Surfaces at the top of the right column".)
      Form {
        Section("Surfaces") {
          HStack(alignment: .top, spacing: 16) {
            ForEach(Array(vm.bindings.pads.indices), id: \.self) { index in
              padColumn(index)   // order stays left-to-right: ControlReference emits
            }                    // "Pad 1 / Pad 2" from this same array order
            Spacer(minLength: 0)
          }
        }
      }
      .padding(.horizontal)

      HStack(alignment: .top, spacing: 12) {
        Form {
          Section("Feedback") {
            ForEach(Self.sliderLabels, id: \.0) { slot, label in
              slider(label, slot: slot)
            }
            // TRANSPARANCY keeps the original's misspelling, and stays a direct
            // `eraseControl` write rather than one of the 9 slots.
            LabeledContent("TRANSPARANCY") {
              HStack(spacing: 8) {
                Slider(value: Binding(get: { vm.eraseValue }, set: { vm.setErase($0) }), in: 0...1)
                Text(String(format: "%.2f", vm.eraseValue))
                  .monospacedDigit()
                  .foregroundStyle(.secondary)
                  .frame(width: 44, alignment: .trailing)
              }
            }
            Toggle("SInvert", isOn: Binding(get: { vm.sInvertOn }, set: { vm.setSInvert($0) }))
            Toggle("World Bump", isOn: Binding(get: { vm.worldBumpOn }, set: { vm.setWorldBumpEnabled($0) }))
          }

          Section("Waveforms") {
            Toggle("Wave 1", isOn: Binding(get: { vm.wave1On }, set: { vm.setWave1Enabled($0) }))
            Toggle("Wave 2", isOn: Binding(get: { vm.wave2On }, set: { vm.setWave2Enabled($0) }))
            // Wave Bump feeds wave 2's alpha, so it does nothing visible unless Wave 2 is on —
            // which is the argument for it living here rather than with the other bumps.
            Toggle("Wave Bump", isOn: Binding(get: { vm.waveBumpOn }, set: { vm.setWaveBumpEnabled($0) }))
          }
        }
        .padding()
        .frame(minWidth: 260, idealWidth: 320)

        Form {
          Section("Image") {
            Picker("Mode", selection: Binding(get: { vm.layerMode }, set: { vm.setLayerMode($0) })) {
              Text("Sticker").tag(LayerMode.sticker)
              Text("Movie").tag(LayerMode.movie)
            }
            .pickerStyle(.segmented)

            ForEach(Self.layerSliderLabels, id: \.0) { axis, label in
              slider(label, axis: .layer(axis))
            }
            // The bump only ever offsets THIS layer's scale and Y, so it belongs here.
            Toggle("Image Bump", isOn: Binding(get: { vm.imageBumpOn }, set: { vm.setImageBumpEnabled($0) }))

            if vm.layerMode == .sticker {
              StickerPicker(vm: vm)
              Stepper(
                "Sticker \(vm.stickerIndex + 1) / \(max(vm.stickerItemCount, 1))",
                value: Binding(get: { vm.stickerIndex }, set: { vm.setStickerIndex($0) }),
                in: 0...max(vm.stickerItemCount - 1, 0)
              )
              Slider(
                value: Binding(
                  get: { vm.stickerItemCount > 0 ? Double(vm.stickerIndex) / Double(vm.stickerItemCount) : 0 },
                  set: { vm.setStickerNormalized($0) }),
                in: 0...1
              )
            } else {
              Button(vm.movieFileName ?? "Choose Movie…") { vm.pickMovieFile() }
              if let name = vm.movieFileName {
                Text(name).foregroundStyle(.secondary)
              }
            }
          }

          Section("Venue & Presets") {
            Picker("Resolution", selection: Binding(get: { vm.resolution }, set: { vm.setResolution($0) })) {
              ForEach(Engine.resolutionPresets, id: \.self) { size in
                Text("\(size.x)×\(size.y)").tag(size)
              }
            }
            Picker("Frame Rate", selection: Binding(get: { vm.frameRate }, set: { vm.setFrameRate($0) })) {
              ForEach(Engine.frameRatePresets, id: \.self) { rate in
                Text("\(rate) fps").tag(rate)
              }
            }
            Picker("Feedback sampling", selection: Binding(get: { vm.warpFilter }, set: { vm.setWarpFilter($0) })) {
              Text("Nearest (parity)").tag(WarpFilter.nearest)
              Text("Linear").tag(WarpFilter.linear)
            }
            // Not a ToggleEvent at all — it writes EngineHost directly — so it sits with the
            // other venue properties rather than with the performed toggles.
            Toggle("Show HUD", isOn: $vm.hudEnabled)

            TextField("Preset name", text: $vm.presetName)
              .focused($presetNameFieldFocused)
              // Both keys just relinquish first responder. Without them, a performer who names
              // a preset leaves every keyboard binding dead for the rest of the session.
              .onSubmit { presetNameFieldFocused = false }
              .onExitCommand { presetNameFieldFocused = false }
            Button("Save") { vm.saveCurrentPreset() }
              .disabled(vm.presetName.isEmpty)
            if vm.presetNames.isEmpty {
              Text("No saved presets").foregroundStyle(.secondary)
            } else {
              ForEach(vm.presetNames, id: \.self) { name in
                Button(name) { vm.recallPreset(named: name) }
              }
            }
            Button("Refresh List") { vm.refreshPresetList() }
          }
        }
        .padding()
        .frame(minWidth: 260, idealWidth: 320)
      }
    }
  }
```

Delete the now-unused `Section("Toggles")` and `Section("Display")` blocks, and the old `Section("Shader Control")`, `Section("Layer Source")`, `Section("Venue")`, `Section("Presets")` — every control they held is placed above. Keep `slider(_:slot:)`, `slider(_:axis:)`, `axisBinding`, `padColumn`, `axisPicker`, `sliderLabels`, `layerSliderLabels` and the `presetNameFieldFocused` property exactly as they are.

- [ ] **Step 2: Re-tune the sticker tiles for the wider column**

In `StickerPicker.swift`, replace the `tileSize`/`gridMaxHeight` block and its comments:

```swift
  /// The image column is ~320pt wide now that the pads have their own band (2026-08-29 design
  /// doc §5), so a `Form` row's control column fits roughly four 56pt tiles per row instead of
  /// the two the old 44pt tiles managed at a 600pt window.
  private static let tileSize: CGFloat = 56
  /// ~3 rows. The cap is no longer about protecting Venue and Presets from being pushed off
  /// the bottom of a 950pt column — it is about the grid not crowding the stepper and slider
  /// directly beneath it.
  private static let gridMaxHeight: CGFloat = 200
```

- [ ] **Step 3: Build**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift build --package-path app`
Expected: `Build complete!`

- [ ] **Step 4: Commit**

```bash
git add app/Sources
git commit -m "refactor(ui): pads on a full-width band, toggles grouped with what they change"
```

---

### Task 6: Docs, then verify on screen

**Files:**
- Modify: `README.md:55` (key list)
- Modify: `docs/spec/06-bus-reference.md` (one line)
- Modify: `docs/superpowers/specs/2026-08-26-controls-gestures-and-help-design.md` (supersede pointer)

- [ ] **Step 1: Update the hand-maintained key list**

In `README.md:55`, change the `k` entry from "kitty bump" to "image bump" and the `p` entry from "layer enable" to "image on/off". The Controls Reference *window* needs no edit — it derives its rows from `displayName`.

- [ ] **Step 2: Note the rename in the bus reference**

Add to `docs/spec/06-bus-reference.md`, in the `kittybump` row or immediately below it:

> The Swift port surfaces this bus as **image bump** (`ToggleEvent.imageBumpEnabled`, panel label "Image Bump") — the bus name and the Max patch are unchanged. See `docs/superpowers/specs/2026-08-29-image-layer-and-panel-layout-design.md` §4.

- [ ] **Step 3: Mark the superseded layout line**

At the top of `docs/superpowers/specs/2026-08-26-controls-gestures-and-help-design.md`, add:

> **Partly superseded (2026-08-29):** the "Surfaces at the top of the panel's right column" placement is replaced by a full-width pads band — see `2026-08-29-image-layer-and-panel-layout-design.md` §5.

- [ ] **Step 4: Run the full suite**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app`
Expected: PASS except the known `GoldenFrameTests` failure. Report the exact counts.

- [ ] **Step 5: Verify on screen**

Put several images in the worktree's `input/transparent-background/` (any PNGs — the folder is gitignored), then:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift run --package-path app feedbax-dev
```

Check, with a screenshot of each window:
1. An image is showing on the Output window at launch, without touching anything.
2. The Controls window has no "Layer Enable" checkbox anywhere.
3. The two XY pads sit side by side across the top and are not clipped — resize the window down to ~600pt wide and confirm they still fit.
4. Clicking the `Off` tile blanks the image on the Output window; clicking a thumbnail brings one back.
5. Pressing `p` with the Output window focused toggles the image off and back on, returning the *same* image.
6. The toggles read: SInvert and World Bump under Feedback; Wave 1, Wave 2, Wave Bump under Waveforms; Image Bump under Image; Show HUD under Venue & Presets.

Drive the app by accessibility, not screen coordinates — `System Events` `click at {x,y}` lands on whatever window is topmost at that point. Use e.g.
`osascript -e 'tell application "System Events" to tell process "feedbax-dev" to tell (first window whose name is "Controls") to get {position, value} of every checkbox of group 1'`
and click AX elements by index.

- [ ] **Step 6: Commit**

```bash
git add README.md docs
git commit -m "docs: record the image bump rename and the superseded pads placement"
```

---

## Self-Review

**Spec coverage:** §3.1 rule → Tasks 2, 3, 4. §3.1 `Off` outside the index space → Task 4 Step 2 (comment + no `items` change). §3.2 keep `enabled` → Task 3 (no `nil` selection introduced). §3.3 surface changes → Tasks 2, 3. §3.4 presets unchanged → Global Constraints + Tasks 1, 3. §4 rename → Tasks 1, 6. §5 layout → Task 5. §6 testing → Tasks 1-3 and 6 Step 5.

**Two spec deviations, both deliberate and noted at their tasks:** the "remembered index" in §3.1 is unnecessary (hiding never touches `selectedIndex`), and §3.2's movie-side "Clear" affordance is **not** implemented — movie mode keeps "Choose Movie…" as-is. Flag the second one to the user at review; it is the one piece of the spec this plan does not build.

**Type consistency:** `imageBumpEnabled` / `imageEnabled` / `bumpsEnabled.image` / `imageShown` / `imageBumpOn` used consistently from their defining task onward. `applyColdStartImageDefaults()` is named identically in Tasks 2, 3 and its test. Task 2 writes `handle(.layerEnabled(true))` and Task 3 changes it to `showImage()` — called out in both.
