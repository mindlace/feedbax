# Controls: Trackpad Gestures, XY Pads, and Controls Reference — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give the performer a generated Controls Reference window, the original's two touch pads as assignable XY pads, a modifier-based trackpad gesture vocabulary with twist-to-rotate, and a live control path for the image layer's transform.

**Architecture:** A unified `ControlAxis` (shader slot *or* layer axis) is the one identity every surface, pad, slider, and help row speaks. `ControlRouter` gains a ramped 4-axis layer channel whose output `Engine.step` writes onto both seed sources each frame. `KeyboardTrackpadSurface` becomes data-driven over a v2 bindings table (gesture × modifiers → axes), resolves relative gestures against router truth at poll time, and arbitrates simultaneous two-finger gestures with a lock. The operator panel gets two absolute XY pads and four layer sliders; a third SwiftUI `Window` renders `ControlReference`, a pure model built from the same bindings.

**Tech Stack:** Swift 5.10, SwiftPM (`app/Package.swift`), XCTest, SwiftUI + AppKit (`NSEvent` local monitor), Metal (untouched).

**Spec:** `docs/superpowers/specs/2026-08-26-controls-gestures-and-help-design.md` — read it first; every task below cites its section.

## Global Constraints

- **Run everything from the worktree root** (`/Users/mindlace/Projects/feedbax/.claude/worktrees/controls-gestures-help`). Never `cd` in a compound command; run `cd` alone first if needed.
- **Tests:** `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter <TestClass>`. Without `DEVELOPER_DIR`, `import XCTest` fails ("no such module 'XCTest'") — that is the toolchain, not your test. `swift build --package-path app` needs no prefix.
- **Minimum macOS 14** (`Package.swift`), SwiftUI operator UI, AppKit for input/render.
- **Teach-style code** (design §3): small files, `///` doc comments that explain *why* (cite the spec section), standard idioms, no dense generics. Explain a new Swift construct briefly in a comment the first time it appears.
- **TDD:** write the failing test, run it, see it fail, implement, run it, see it pass. Previously passing tests stay green; run the full suite (`swift test --package-path app`) before every commit.
- **Conventional Commits** (`feat:`, `fix:`, `test:`, `docs:`, `refactor:`). Multi-line messages via a temp file + `git commit -F`, or multiple `-m`. Never heredoc-in-`$(...)`.
- **SwiftUI views have no unit-test rig** in this repo — `XYPad`, `ControlsReferenceView`, `OperatorPanel`, `FeedbaxScenes` are verified by `swift build` plus the manual `swift run --package-path app feedbax-dev` pass in Task 12. Keep every non-view piece of logic in a testable type.
- The 9-slot `ControlSlot` and the `Preset` file format do **not** change (spec §3.1, §4).

## File Structure

New files (one responsibility each):

| File | Responsibility |
|---|---|
| `app/Sources/FeedbaxKit/Control/ControlAxis.swift` | `LayerAxis`, `ControlAxis`: ranges, JSON markers, display names, the `live` list |
| `app/Sources/FeedbaxKit/Control/TrackpadBinding.swift` | `TrackpadGesture`, `GestureModifier`, `GesturePhase`, `GestureEvent`, `TrackpadAxis`, `TrackpadBinding`, `PadAssignment` + Codable |
| `app/Sources/FeedbaxKit/Control/GestureLock.swift` | Dominant-gesture arbitration for simultaneous two-finger events (spec §6.3) |
| `app/Sources/FeedbaxKit/Control/BindingsStore.swift` | User file → bundled default resolution; save (spec §6.6) |
| `app/Sources/FeedbaxKit/Control/ControlReference.swift` | Pure help model built from `Bindings` (spec §8.1) |
| `app/Sources/FeedbaxKit/UI/XYPad.swift` | Absolute XY pad view + pure coordinate mapping (spec §7) |
| `app/Sources/FeedbaxKit/UI/ControlsReferenceView.swift` | Renders `ControlReference` (spec §8.2) |
| `app/Tests/FeedbaxKitTests/ControlAxisTests.swift`, `BindingsTests.swift`, `GestureLockTests.swift`, `BindingsStoreTests.swift`, `ControlReferenceTests.swift`, `XYPadTests.swift` | One test file per new unit |

Modified: `Control/ControlVector.swift`, `Control/ControlRouter.swift`, `Control/Bindings.swift`, `Control/DefaultBindings.json`, `Control/KeyboardTrackpadSurface.swift`, `Control/GamepadSurface.swift`, `Control/Presets.swift`, `Engine/Engine.swift`, `UI/PerformerInputMonitor.swift`, `UI/EngineViewModel.swift`, `UI/OperatorPanel.swift`, `UI/FeedbaxScenes.swift`, `UI/AppBootstrap.swift`, `README.md`, plus their existing tests.

Task order is dependency order; each task leaves the package building and the suite green.

---

### Task 1: `ControlAxis` vocabulary, `ControlWrite.layer`, snapshot `rawValue`

Spec §3. One identity for everything a gesture can drive, and the two contract widenings every later task uses.

**Files:**
- Create: `app/Sources/FeedbaxKit/Control/ControlAxis.swift`
- Modify: `app/Sources/FeedbaxKit/Control/ControlVector.swift` (`ToggleEvent`, `ControlWrite`, `ControlStateSnapshot`)
- Test: `app/Tests/FeedbaxKitTests/ControlAxisTests.swift`

**Interfaces:**
- Consumes: `ControlSlot`, `ControlSlot.marker`/`fromMarker` (internal, `Bindings.swift`).
- Produces:
  - `enum LayerAxis: Int, CaseIterable, Codable { case x = 0, y, scale, rotate }`
  - `enum ControlAxis: Hashable, Codable { case slot(ControlSlot); case layer(LayerAxis) }` with `static let live: [ControlAxis]` (11), `var rawRange: ClosedRange<Float>`, `func clamped(_ v: Float) -> Float`, `var displayName: String`, `var marker: String`, `static func fromMarker(_:) -> ControlAxis?`
  - `ControlWrite.layer: [LayerAxis: Float]` (defaulted), `ControlWrite.init(axes: [ControlAxis: Float], toggles:, eraseStep:)`
  - `ControlStateSnapshot.rawValue: (ControlAxis) -> Float` (init param defaulted to `{ _ in 0 }`), `ControlStateSnapshot.constant(_:rawValue:)`
  - `ToggleEvent.displayName: String`, `ToggleEvent.isOneShot: Bool`

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/ControlAxisTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

/// Spec §3: one axis identity for slots and layer axes, with the ranges, JSON spellings and
/// display names every surface/pad/help row derives from it.
final class ControlAxisTests: XCTestCase {
  func testLiveAxesAreTheSevenLiveSlotsPlusFourLayerAxes() {
    XCTAssertEqual(ControlAxis.live.count, 11)
    XCTAssertFalse(ControlAxis.live.contains(.slot(.scalebright)), "dead slot, spec §01 §4")
    XCTAssertFalse(ControlAxis.live.contains(.slot(.nc)), "dead slot, spec §01 §4")
    XCTAssertEqual(Array(ControlAxis.live.suffix(4)),
                   [.layer(.x), .layer(.y), .layer(.scale), .layer(.rotate)])
  }

  func testRawRangesAndClamp() {
    XCTAssertEqual(ControlAxis.slot(.saturation).rawRange, 0...1, "the one unipolar slot")
    XCTAssertEqual(ControlAxis.slot(.panX).rawRange, -1...1)
    XCTAssertEqual(ControlAxis.layer(.scale).rawRange, -1...1)
    XCTAssertEqual(ControlAxis.slot(.saturation).clamped(-0.5), 0)
    XCTAssertEqual(ControlAxis.layer(.x).clamped(3), 1)
    XCTAssertEqual(ControlAxis.layer(.x).clamped(-0.25), -0.25)
  }

  func testMarkersRoundTripForEveryLiveAxis() {
    for axis in ControlAxis.live {
      XCTAssertEqual(ControlAxis.fromMarker(axis.marker), axis, axis.marker)
    }
    XCTAssertEqual(ControlAxis.fromMarker("layerScale"), .layer(.scale))
    XCTAssertEqual(ControlAxis.fromMarker("panX"), .slot(.panX))
    XCTAssertNil(ControlAxis.fromMarker("bogus"))
  }

  func testCodableSpellsTheMarker() throws {
    let axes: [ControlAxis] = [.layer(.rotate), .slot(.hue)]
    let data = try JSONEncoder().encode(axes)
    XCTAssertEqual(String(data: data, encoding: .utf8), #"["layerRotate","hue"]"#)
    XCTAssertEqual(try JSONDecoder().decode([ControlAxis].self, from: data), axes)
    XCTAssertThrowsError(try JSONDecoder().decode(ControlAxis.self, from: Data(#""bogus""#.utf8)))
  }

  func testEveryAxisAndToggleHasADisplayName() {
    for axis in ControlAxis.live { XCTAssertFalse(axis.displayName.isEmpty, "\(axis)") }
    XCTAssertEqual(ControlAxis.slot(.theta).displayName, "Rotate")
    XCTAssertEqual(ControlAxis.layer(.rotate).displayName, "Image rotate")
    XCTAssertEqual(ToggleEvent.sInvert(true).displayName, "SInvert")
    XCTAssertEqual(ToggleEvent.stillCapture.displayName, "Still capture")
    XCTAssertTrue(ToggleEvent.fullscreen.isOneShot)
    XCTAssertFalse(ToggleEvent.wave1Enabled(true).isOneShot)
  }

  func testControlWriteSplitsAxesIntoSlotsAndLayer() {
    let w = ControlWrite(axes: [.slot(.hue): 0.2, .layer(.scale): -0.5])
    XCTAssertEqual(w.slots, [.hue: 0.2])
    XCTAssertEqual(w.layer, [.scale: -0.5])
    XCTAssertEqual(ControlWrite(slots: [.zoom: 1]).layer, [:], "existing call sites default to no layer write")
  }

  func testSnapshotRawValueDefaultsToZeroAndCanBeSupplied() {
    XCTAssertEqual(ControlStateSnapshot.constant(false).rawValue(.slot(.zoom)), 0)
    let s = ControlStateSnapshot.constant(false, rawValue: { $0 == .layer(.x) ? 0.7 : 0 })
    XCTAssertEqual(s.rawValue(.layer(.x)), 0.7)
    XCTAssertEqual(s.rawValue(.layer(.y)), 0)
  }
}
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter ControlAxisTests`
Expected: compile failure — `LayerAxis`/`ControlAxis` not found.

- [ ] **Step 3: Create `ControlAxis.swift`**

```swift
import Foundation

/// The image layer's four live axes — the original's `imageMove` roles (spec §02 §4, §04
/// §1.3: touch centroid → x/y, pinch → zoom, two-finger twist → rotate). A separate enum
/// rather than four more `ControlSlot` cases, because `ControlSlot` IS the original's 9-float
/// `shadeCtl` vector — fixed indices, preset-serialized as a 9-array — and the image layer
/// never rode that bus; it had its own (`imageMove`). Design §3.1.
public enum LayerAxis: Int, CaseIterable, Codable {
  case x = 0, y, scale, rotate
}

/// Anything a gesture, pad, or slider can drive: one of the shader slots, or a layer axis.
///
/// This is a Swift enum with *associated values* — each case carries a payload (`ControlSlot`
/// or `LayerAxis`). A `switch` over it must handle both cases and, inside each, every payload
/// value, so "every axis has a display name and a range" is checked by the compiler rather
/// than discovered as a blank row in the reference window (design §13).
public enum ControlAxis: Hashable {
  case slot(ControlSlot)
  case layer(LayerAxis)

  /// The 11 assignable axes in display order: the 7 live shader slots — never the dead
  /// `.scalebright`/`.nc` (spec §01 §4) — then the 4 layer axes. Pad pickers, the operator
  /// panel's mirrors, and the reference window all iterate this, so they can't disagree.
  public static let live: [ControlAxis] = [
    .slot(.hue), .slot(.bias), .slot(.panX), .slot(.panY), .slot(.zoom), .slot(.theta),
    .slot(.saturation),
    .layer(.x), .layer(.y), .layer(.scale), .layer(.rotate),
  ]

  /// The raw domain a surface writes in, BEFORE `ControlRouter` maps it: saturation is the
  /// one unipolar slot (spec §04 §1.2 row 8); everything else is bipolar −1...1 (design §3.1).
  /// Lived in `EngineViewModel.range(for:)` until the layer axes needed it too.
  public var rawRange: ClosedRange<Float> {
    switch self {
    case .slot(.saturation): return 0...1
    case .slot, .layer: return -1...1
    }
  }

  public func clamped(_ value: Float) -> Float {
    min(rawRange.upperBound, max(rawRange.lowerBound, value))
  }

  /// What the operator panel, the pad pickers, and the Controls Reference window show.
  /// "Rotate" is the `.theta` slot — the original's own name for the field's rotation angle
  /// (spec §01 §4); the panel already labels that slider "rotate".
  public var displayName: String {
    switch self {
    case .slot(let slot):
      switch slot {
      case .hue: return "Hue shift"
      case .bias: return "Brightness"
      case .scalebright: return "Scale/bright (unused)"
      case .panX: return "Pan X"
      case .panY: return "Pan Y"
      case .zoom: return "Zoom"
      case .theta: return "Rotate"
      case .nc: return "NC (unused)"
      case .saturation: return "Saturation"
      }
    case .layer(let axis):
      switch axis {
      case .x: return "Image X"
      case .y: return "Image Y"
      case .scale: return "Image scale"
      case .rotate: return "Image rotate"
      }
    }
  }

  // MARK: - JSON spelling (the bindings file is hand-editable, design §5's "data, not code")

  public var marker: String {
    switch self {
    case .slot(let slot): return slot.marker
    case .layer(.x): return "layerX"
    case .layer(.y): return "layerY"
    case .layer(.scale): return "layerScale"
    case .layer(.rotate): return "layerRotate"
    }
  }

  public static func fromMarker(_ name: String) -> ControlAxis? {
    switch name {
    case "layerX": return .layer(.x)
    case "layerY": return .layer(.y)
    case "layerScale": return .layer(.scale)
    case "layerRotate": return .layer(.rotate)
    default: return ControlSlot.fromMarker(name).map { .slot($0) }
    }
  }
}

/// Encodes as the bare marker string (`"layerScale"`, `"panX"`) — a single JSON value, not an
/// object — so a pad assignment in the bindings file reads `{"x": "layerX", "y": "layerY"}`.
extension ControlAxis: Codable {
  public init(from decoder: Decoder) throws {
    let name = try decoder.singleValueContainer().decode(String.self)
    guard let axis = ControlAxis.fromMarker(name) else {
      throw DecodingError.dataCorrupted(DecodingError.Context(
        codingPath: decoder.codingPath, debugDescription: "Unknown control axis marker '\(name)'"))
    }
    self = axis
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(marker)
  }
}
```

- [ ] **Step 4: Widen `ControlWrite`, `ControlStateSnapshot`, and `ToggleEvent` in `ControlVector.swift`**

Replace the `ControlWrite` struct with:

```swift
public struct ControlWrite {
  public var slots: [ControlSlot: Float]
  /// The image layer's raw axes (design §3.2) — the same partial-write contract as `slots`,
  /// kept in its own dictionary so `ControlRouter`'s slot code keeps its shape and the 9-slot
  /// vector stays exactly the original's `shadeCtl`.
  public var layer: [LayerAxis: Float]
  public var toggles: [ToggleEvent]
  public var eraseStep: Float?

  public init(slots: [ControlSlot: Float] = [:], layer: [LayerAxis: Float] = [:],
              toggles: [ToggleEvent] = [], eraseStep: Float? = nil) {
    self.slots = slots
    self.layer = layer
    self.toggles = toggles
    self.eraseStep = eraseStep
  }

  /// Surfaces think in `ControlAxis`; the router thinks in two vectors. This is the split,
  /// done once here rather than in every surface.
  public init(axes: [ControlAxis: Float], toggles: [ToggleEvent] = [], eraseStep: Float? = nil) {
    var slots: [ControlSlot: Float] = [:]
    var layer: [LayerAxis: Float] = [:]
    for (axis, value) in axes {
      switch axis {
      case .slot(let slot): slots[slot] = value
      case .layer(let layerAxis): layer[layerAxis] = value
      }
    }
    self.init(slots: slots, layer: layer, toggles: toggles, eraseStep: eraseStep)
  }
}
```

In `ControlStateSnapshot`, add a stored property after `layerEnabled` and extend `init`/`constant`:

```swift
  /// The router's current RAW value for any axis (design §5). A relative gesture nudges FROM
  /// this at poll time rather than from a private accumulator — otherwise a slider or preset
  /// that moved the axis is undone by the next trackpad nudge (spec §2, finding 1).
  public var rawValue: (ControlAxis) -> Float

  public init(sInvert: @escaping () -> Bool, worldBumpEnabled: @escaping () -> Bool,
              waveBumpEnabled: @escaping () -> Bool, kittyBumpEnabled: @escaping () -> Bool,
              wave1Enabled: @escaping () -> Bool, wave2Enabled: @escaping () -> Bool,
              layerEnabled: @escaping () -> Bool,
              rawValue: @escaping (ControlAxis) -> Float = { _ in 0 }) {
    self.sInvert = sInvert
    self.worldBumpEnabled = worldBumpEnabled
    self.waveBumpEnabled = waveBumpEnabled
    self.kittyBumpEnabled = kittyBumpEnabled
    self.wave1Enabled = wave1Enabled
    self.wave2Enabled = wave2Enabled
    self.layerEnabled = layerEnabled
    self.rawValue = rawValue
  }
```

and

```swift
  public static func constant(_ value: Bool,
                              rawValue: @escaping (ControlAxis) -> Float = { _ in 0 }) -> ControlStateSnapshot {
    ControlStateSnapshot(sInvert: { value }, worldBumpEnabled: { value }, waveBumpEnabled: { value },
                         kittyBumpEnabled: { value }, wave1Enabled: { value }, wave2Enabled: { value },
                         layerEnabled: { value }, rawValue: rawValue)
  }
```

Add to `ToggleEvent` (an extension at the bottom of `ControlVector.swift`):

```swift
extension ToggleEvent {
  /// Reference-window label (design §8.1). Exhaustive on purpose: a new toggle without a name
  /// is a compile error, not a blank row.
  public var displayName: String {
    switch self {
    case .sInvert: return "SInvert"
    case .worldBumpEnabled: return "World bump"
    case .waveBumpEnabled: return "Wave bump"
    case .kittyBumpEnabled: return "Kitty bump"
    case .wave1Enabled: return "Wave 1"
    case .wave2Enabled: return "Wave 2"
    case .layerEnabled: return "Layer enable"
    case .fullscreen: return "Fullscreen"
    case .stillCapture: return "Still capture"
    }
  }

  /// `.fullscreen`/`.stillCapture` fire the same way every press; everything else alternates.
  public var isOneShot: Bool {
    switch self {
    case .fullscreen, .stillCapture: return true
    default: return false
    }
  }
}
```

- [ ] **Step 5: Run the tests**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter ControlAxisTests`
Expected: 7 tests PASS. Then run the whole suite — nothing else should change (every existing `ControlStateSnapshot(...)`/`ControlWrite(...)` call still compiles because the new parameters are defaulted).

- [ ] **Step 6: Commit**

```bash
git add app/Sources/FeedbaxKit/Control/ControlAxis.swift app/Sources/FeedbaxKit/Control/ControlVector.swift app/Tests/FeedbaxKitTests/ControlAxisTests.swift
git commit -m "feat(control): ControlAxis vocabulary, layer channel on ControlWrite, snapshot rawValue"
```

---

### Task 2: Router layer channel

Spec §4. Four ramped layer axes beside the 9 slots; `layerTransform` as the output; the inverse map for preset recall; `rawValue(for:)` for surfaces.

**Files:**
- Modify: `app/Sources/FeedbaxKit/Control/ControlRouter.swift`
- Test: `app/Tests/FeedbaxKitTests/ControlRouterTests.swift`

**Interfaces:**
- Consumes: `LayerAxis`, `ControlAxis`, `ControlWrite.layer` (Task 1); `LayerTransform` (`Sources/SeedSource.swift`); `maxScale` (`ShaderMath/MaxScale.swift`).
- Produces:
  - `ControlRouter.rawLayer: [Float]` (4, `LayerAxis.rawValue`-indexed), `ControlRouter.layerTransform: LayerTransform` (refreshed by `tick`)
  - `static let startupLayerVector: [Float] = [0, 0, -0.253, 0]`
  - `static func mappedLayerTarget(for: LayerAxis, raw: Float) -> Float` (internal)
  - `static func layerTransform(from mapped: [LayerAxis: Float]) -> LayerTransform` (internal)
  - `public static func rawLayer(from transform: LayerTransform) -> [LayerAxis: Float]`
  - `public func rawValue(for axis: ControlAxis) -> Float`

- [ ] **Step 1: Write the failing tests**

Append to `ControlRouterTests`:

```swift
  // MARK: - Layer channel (design §4)

  func testLayerChannelColdStartIsTheStickerDefault() {
    let r = ControlRouter()
    let t = r.layerTransform
    XCTAssertEqual(t.scale.x, 0.747, accuracy: 1e-4, "StickerSource's default scale, spec §02 §4")
    XCTAssertEqual(t.scale.y, 0.747, accuracy: 1e-4, "uniform")
    XCTAssertEqual(t.position, .zero)
    XCTAssertEqual(t.rotationZDegrees, 0)
    XCTAssertEqual(r.rawLayer, ControlRouter.startupLayerVector)
    r.applyStartupDefaults(at: 0)
    XCTAssertEqual(r.rawLayer, ControlRouter.startupLayerVector, "startup defaults reassert the same vector")
  }

  func testLayerAxesMapToWorldUnits() {
    let r = ControlRouter()
    r.apply(ControlWrite(layer: [.x: 1, .y: -1, .scale: 1, .rotate: -1]), at: 0)
    _ = r.tick(at: 1.0)   // 1 s ≫ 100 ms — settled
    let t = r.layerTransform
    XCTAssertEqual(t.position.x, 1.7, accuracy: 1e-4, "webUI centroid scale, spec §02 §4")
    XCTAssertEqual(t.position.y, -1, accuracy: 1e-4)
    XCTAssertEqual(t.scale.x, 2, accuracy: 1e-4)
    XCTAssertEqual(t.rotationZDegrees, -180, accuracy: 1e-3)
  }

  func testLayerScaleIsFlooredAboveZero() {
    let r = ControlRouter()
    r.apply(ControlWrite(layer: [.scale: -1]), at: 0)
    _ = r.tick(at: 1.0)
    XCTAssertEqual(r.layerTransform.scale.x, 0.01, accuracy: 1e-5, "a zero-size quad is degenerate")
  }

  func testLayerAxesRampLikeSlots() {
    let r = ControlRouter()
    _ = r.tick(at: 0)
    r.apply(ControlWrite(layer: [.x: 1]), at: 0)      // 0 → 1.7 over 100 ms
    _ = r.tick(at: 0.05)
    XCTAssertEqual(r.layerTransform.position.x, 0.85, accuracy: 0.05, "linear ramp: halfway at 50 ms")
    _ = r.tick(at: 0.2)
    XCTAssertEqual(r.layerTransform.position.x, 1.7, accuracy: 1e-3)
  }

  func testLastSurfaceWinsPerLayerAxis() {
    final class FixedLayer: ControlSurface {
      let id: String; let write: ControlWrite
      init(_ id: String, _ w: ControlWrite) { self.id = id; write = w }
      func poll(_ time: TimeInterval) -> ControlWrite? { write }
    }
    let r = ControlRouter()
    r.surfaces = [FixedLayer("a", .init(layer: [.x: -1, .rotate: 0.5])),
                  FixedLayer("b", .init(layer: [.x: 1]))]
    _ = r.tick(at: 1)
    XCTAssertEqual(r.rawLayer[LayerAxis.x.rawValue], 1, "later surface overwrites x")
    XCTAssertEqual(r.rawLayer[LayerAxis.rotate.rawValue], 0.5, "unasserted axis keeps earlier write")
  }

  func testRawLayerInvertsTheLayerMap() {
    // −1 is excluded for scale on purpose: the 0.01 floor makes the map non-invertible there.
    for raw: Float in [-0.9, -0.253, 0, 0.6, 1] {
      var mapped: [LayerAxis: Float] = [:]
      for axis in LayerAxis.allCases {
        mapped[axis] = ControlRouter.mappedLayerTarget(for: axis, raw: raw)
      }
      let back = ControlRouter.rawLayer(from: ControlRouter.layerTransform(from: mapped))
      for axis in LayerAxis.allCases {
        XCTAssertEqual(back[axis]!, raw, accuracy: 1e-5, "\(axis) at raw \(raw)")
      }
    }
  }

  func testRawValueReadsBothVectors() {
    let r = ControlRouter()
    r.apply(ControlWrite(slots: [.hue: 0.3], layer: [.y: -0.4]), at: 0)
    XCTAssertEqual(r.rawValue(for: .slot(.hue)), 0.3)
    XCTAssertEqual(r.rawValue(for: .layer(.y)), -0.4)
    XCTAssertEqual(r.rawValue(for: .slot(.zoom)), 0, "untouched slot")
  }
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter ControlRouterTests`
Expected: compile failure — `layerTransform`, `rawLayer` not found.

- [ ] **Step 3: Implement the layer channel in `ControlRouter.swift`**

Add stored properties (after `lastRampTarget`):

```swift
  /// Raw, unmapped image-layer axes, `LayerAxis.rawValue`-indexed — the original's `imageMove`
  /// x/y/zoom/rotate (spec §02 §4). Starts at `startupLayerVector`, NOT zeros: unlike the 9
  /// slots (whose raw-0 rest is "no control message has arrived yet"), the layer has a real
  /// cold-start placement — `StickerSource`'s default 0.747 scale — and a bare `ControlRouter`
  /// should already report it.
  public private(set) var rawLayer: [Float]
  private var layerRamps: [LayerAxis: LinearRamp]
  private var lastLayerTarget: [LayerAxis: Float]

  /// The ramped, mapped placement `Engine.step` hands both seed sources every frame (design
  /// §4). Not a `RenderParams` field: `RenderParams` is `FeedbackCore`'s input, and the layer
  /// transform belongs to the compositor.
  public private(set) var layerTransform: LayerTransform

  /// Raw layer vector a fresh session starts on: centred, unrotated, scale raw −0.253 — which
  /// `mappedLayerTarget` turns into 0.747, `StickerSource`'s default (spec §02 §4). `x y scale
  /// rotate`, `LayerAxis` order.
  public static let startupLayerVector: [Float] = [0, 0, -0.253, 0]
```

In `init`, before `self.ramps = ramps`:

```swift
    self.rawLayer = ControlRouter.startupLayerVector
    var layerRamps: [LayerAxis: LinearRamp] = [:]
    var layerTargets: [LayerAxis: Float] = [:]
    for axis in LayerAxis.allCases {
      // Seeded AT the mapped startup value (like the HSL slots' `coldStartSeed`), so cold start
      // lands on the sticker's real default with no glide.
      let target = ControlRouter.mappedLayerTarget(for: axis, raw: ControlRouter.startupLayerVector[axis.rawValue])
      layerRamps[axis] = LinearRamp(initial: target, smoothMs: smoothMs, grainMs: grainMs)
      layerTargets[axis] = target
    }
    self.layerRamps = layerRamps
    self.lastLayerTarget = layerTargets
    self.layerTransform = ControlRouter.layerTransform(from: layerTargets)
```

In `applyStartupDefaults`, replace the `apply(...)` line:

```swift
    var layer: [LayerAxis: Float] = [:]
    for axis in LayerAxis.allCases {
      layer[axis] = ControlRouter.startupLayerVector[axis.rawValue]
    }
    apply(ControlWrite(slots: slots, layer: layer), at: time)
```

In `tick`, after the `for surface in surfaces` loop and before `let eraseAlpha`:

```swift
    var mappedLayer: [LayerAxis: Float] = [:]
    for axis in LayerAxis.allCases {
      mappedLayer[axis] = layerRamps[axis]!.value(at: time)
    }
    layerTransform = ControlRouter.layerTransform(from: mappedLayer)
```

In `mergeAndProcess`, after the `write.slots` loop:

```swift
    for (axis, value) in write.layer {
      rawLayer[axis.rawValue] = value
    }
```

In `updateRampTargets`, after the slot loop:

```swift
    for axis in LayerAxis.allCases {
      let target = ControlRouter.mappedLayerTarget(for: axis, raw: rawLayer[axis.rawValue])
      if lastLayerTarget[axis] != target {
        layerRamps[axis]?.setTarget(target, at: time)
        lastLayerTarget[axis] = target
      }
    }
```

Add, after `mappedTarget`:

```swift
  /// Raw −1...1 → `LayerTransform`'s world units (design §4's table). `x` is the webUI
  /// centroid scale `scale 0.1 0.9 -1.7 1.7` (spec §02 §4); `y` keeps +raw = up (the
  /// original's `1 -1` inversion was the iPad pad's top-left origin, not a world-space fact);
  /// `scale` is linear 0...2 with a 0.01 floor — flagged for parity review, the original's
  /// exponential accumulator isn't recoverable from the listing (spec §04 §1.3); `rotate` is
  /// ±180°, the same clamped contract the field's own `.theta` slot has.
  static func mappedLayerTarget(for axis: LayerAxis, raw: Float) -> Float {
    switch axis {
    case .x: return maxScale(raw, -1, 1, -1.7, 1.7)
    case .y: return raw
    case .scale: return max(0.01, maxScale(raw, -1, 1, 0, 2))
    case .rotate: return maxScale(raw, -1, 1, -180, 180)
    }
  }

  static func layerTransform(from mapped: [LayerAxis: Float]) -> LayerTransform {
    let scale = mapped[.scale] ?? 1
    return LayerTransform(position: SIMD2(mapped[.x] ?? 0, mapped[.y] ?? 0),
                          scale: SIMD2(scale, scale),
                          rotationZDegrees: mapped[.rotate] ?? 0)
  }

  /// The inverse of `mappedLayerTarget`, for preset recall (`PresetStore.apply` seeds this
  /// channel from a saved `LayerTransform`). Uniform scale is assumed — `scale.x` is read.
  public static func rawLayer(from transform: LayerTransform) -> [LayerAxis: Float] {
    [
      .x: ControlAxis.layer(.x).clamped(transform.position.x / 1.7),
      .y: ControlAxis.layer(.y).clamped(transform.position.y),
      .scale: ControlAxis.layer(.scale).clamped(transform.scale.x - 1),
      .rotate: ControlAxis.layer(.rotate).clamped(transform.rotationZDegrees / 180),
    ]
  }

  /// Truth for `ControlStateSnapshot.rawValue` (design §5): whatever was last written to the
  /// axis, unramped and unmapped.
  public func rawValue(for axis: ControlAxis) -> Float {
    switch axis {
    case .slot(let slot): return rawSlots[slot.rawValue]
    case .layer(let layerAxis): return rawLayer[layerAxis.rawValue]
    }
  }
```

Update the class doc comment's first paragraph to mention "…the 9-slot raw control vector, the 4-axis image-layer vector (design §4), SInvert, the erase channel…".

- [ ] **Step 4: Run the tests**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter ControlRouterTests`
Expected: all PASS (6 existing + 7 new). Then the full suite: green.

- [ ] **Step 5: Commit**

```bash
git add app/Sources/FeedbaxKit/Control/ControlRouter.swift app/Tests/FeedbaxKitTests/ControlRouterTests.swift
git commit -m "feat(control): ramped image-layer channel on ControlRouter with world-unit map and inverse"
```

---

### Task 3: Engine applies the layer transform; presets recall through the router

Spec §4 ("Engine", "Presets").

**Files:**
- Modify: `app/Sources/FeedbaxKit/Engine/Engine.swift` (`step`, between stages 2 and 3)
- Modify: `app/Sources/FeedbaxKit/Control/Presets.swift` (`PresetStore.apply`)
- Test: `app/Tests/FeedbaxKitTests/EngineWiringTests.swift`, `app/Tests/FeedbaxKitTests/PresetTests.swift`

**Interfaces:**
- Consumes: `ControlRouter.layerTransform`, `ControlRouter.rawLayer(from:)`, `ControlWrite.layer` (Tasks 1–2).
- Produces: `Engine.step` invariant — after any step, `sticker.transform == movie.transform == router.layerTransform`; `PresetStore.apply` no longer writes `layer.transform` directly.

- [ ] **Step 1: Write the failing tests**

Append to `EngineWiringTests` (inside the class, after the filter-chain tests):

```swift
  // MARK: - Layer placement wiring (design §4)

  /// Both seed sources take the router's ramped layer transform every frame — the original had
  /// ONE picsvid layer whose transform came from `imageMove` whether it showed a picture or a
  /// video. The kitty offset (stage 3) is additive on top and restored, so after `step` the
  /// sources read exactly the router's value.
  func testBothSeedSourcesFollowTheRouterLayerTransform() throws {
    let ctx = try MetalContext()
    var captured: Engine?
    _ = try render(frames: 1, context: ctx) { engine in
      captured = engine
      // Applied at −1 s, settled long before frame 0's step at t = 0.
      engine.router.apply(ControlWrite(layer: [.x: 0.5, .rotate: 0.25]), at: -1)
    }
    let engine = try XCTUnwrap(captured)
    XCTAssertEqual(engine.sticker.transform, engine.router.layerTransform)
    XCTAssertEqual(engine.movie.transform, engine.router.layerTransform)
    XCTAssertEqual(engine.sticker.transform.position.x, 0.85, accuracy: 1e-3, "0.5 × 1.7")
    XCTAssertEqual(engine.sticker.transform.rotationZDegrees, 45, accuracy: 1e-2, "0.25 × 180°")
  }
```

Replace `PresetTests.testApplyRestoresSlotsRampedAndTransformsDirectly` with:

```swift
  /// Recall glides EVERYTHING now: the 9 slots through the slot ramps (as before) and the layer
  /// placement through the router's layer channel (design §4) — never by poking
  /// `layer.transform`, which `Engine.step` overwrites from `router.layerTransform` on the very
  /// next frame anyway. Settings (z-order/enable) still restore directly.
  func testApplyRecallsSlotsAndLayerPlacementThroughTheRouter() throws {
    final class FakeLayer: SeedSource {
      let id = "sticker"; var transform = LayerTransform(); var layer = LayerSettings()
      func tick(_ frame: FrameContext) -> MTLTexture? { nil }
    }
    let router = ControlRouter()
    _ = router.tick(at: 0)                       // ramps at rest
    let layer = FakeLayer()
    let preset = Preset(name: "p", slots: [1, 0, 0, 0, 0, 0, 0, 0, 0], eraseControl: 0.3,
                        toggles: PresetToggles(), layers: [
                          PresetLayer(id: "sticker", sourceSelection: .stickerIndex(0),
                                      transform: LayerTransform(position: SIMD2(0.85, 0), scale: SIMD2(1, 1),
                                                                rotationZDegrees: 90),
                                      settings: LayerSettings(zOrder: 2, enabled: true), filters: [])])
    PresetStore.apply(preset, router: router, layers: [layer], at: 1.0)
    XCTAssertEqual(router.rawSlots[0], 1)
    XCTAssertEqual(router.rawLayer, [0.5, 0, 0, 0.5], "inverse-mapped into the layer channel")
    XCTAssertTrue(layer.layer.enabled, "settings restore directly")
    XCTAssertEqual(layer.transform, LayerTransform(), "transform is NOT written directly — Engine.step does that")
    // Recall RAMPS (design §5 Presets — glide, not snap): 10 ms in, both hue and x are mid-flight.
    let mid = router.tick(at: 1.010)
    let midX = router.layerTransform.position.x
    let settled = router.tick(at: 1.2)
    XCTAssertNotEqual(mid.hueShift, settled.hueShift, accuracy: 1e-5)
    XCTAssertNotEqual(midX, 0.85, accuracy: 1e-3)
    XCTAssertEqual(router.layerTransform.position.x, 0.85, accuracy: 1e-3)
    XCTAssertEqual(router.layerTransform.rotationZDegrees, 90, accuracy: 1e-2)
  }
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter "EngineWiringTests|PresetTests"`
Expected: the wiring test fails (`sticker.transform` still 0.747 default, not the router's), the preset test fails on `rawLayer`/`layer.transform`.

- [ ] **Step 3: Apply the transform in `Engine.step`**

Insert between the end of stage 2 (`audio.waveBumpRaw = ...`) and stage 3's `let baseStickerTransform`:

```swift
    // 2b. Image-layer placement: the router's ramped `imageMove` (spec §02 §4; design §4)
    // lands on BOTH sources every frame. The original had one picsvid layer whose transform
    // came from `imageMove` whether it showed a picture or a video — the same reason
    // `handle(.layerEnabled:)` keeps both `.enabled` flags in lockstep. This is the layer's
    // BASE placement; stage 3's kitty offset is additive on top and restored afterward.
    sticker.transform = router.layerTransform
    movie.transform = router.layerTransform
```

- [ ] **Step 4: Recall through the router in `PresetStore.apply`**

Replace the body of `apply` with:

```swift
  public static func apply(_ preset: Preset, router: ControlRouter, layers: [SeedSource],
                           at time: TimeInterval) {
    var slots: [ControlSlot: Float] = [:]
    for slot in ControlSlot.allCases {
      slots[slot] = preset.slots[slot.rawValue]
    }
    // Layer placement recalls THROUGH the router's layer channel — ramped, the same glide the
    // 9 slots get (design §4) — not by writing `layer.transform` directly: `Engine.step` puts
    // `router.layerTransform` on both sources every frame, so a direct write would be
    // overwritten on the next tick. Both sources move in lockstep, so the sticker layer's
    // saved transform is the one that counts; a preset whose two layers disagree recalls the
    // sticker's (or, failing that, whichever layer comes first).
    var layer: [LayerAxis: Float] = [:]
    if let placement = preset.layers.first(where: { $0.id == "sticker" }) ?? preset.layers.first {
      layer = ControlRouter.rawLayer(from: placement.transform)
    }
    router.apply(ControlWrite(slots: slots, layer: layer, toggles: preset.toggles.toggleEvents()), at: time)
    router.eraseControl = preset.eraseControl

    let layersByID = Dictionary(uniqueKeysWithValues: layers.map { ($0.id, $0) })
    for presetLayer in preset.layers {
      guard let layer = layersByID[presetLayer.id] else { continue }
      layer.layer = presetLayer.settings
      // Filters: no-op for the same reason `capture` can't snapshot them — SeedSource
      // doesn't expose a filter chain yet. Once it does, restore each with
      // `PresetFilterParams.apply(to:)` above.
    }
  }
```

Update `apply`'s doc comment: transforms now glide through the router (design §4); only `eraseControl` and layer settings are set directly.

- [ ] **Step 5: Run the tests, then the full suite**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app`
Expected: all green. If a golden-frame test moves, STOP and report — the layer's cold-start transform is meant to be identical (0.747, centred), so a golden change means the mapping is wrong, not the reference.

- [ ] **Step 6: Commit**

```bash
git add app/Sources/FeedbaxKit/Engine/Engine.swift app/Sources/FeedbaxKit/Control/Presets.swift app/Tests/FeedbaxKitTests/EngineWiringTests.swift app/Tests/FeedbaxKitTests/PresetTests.swift
git commit -m "feat(engine): seed sources follow the router layer transform; presets recall placement through it"
```

---

### Task 4: Bindings v2 and the surface's `GestureEvent` API

Spec §5, §6.1, §6.4, §6.5. The bindings table becomes a list of gesture rows keyed by (gesture, modifiers); the surface stops holding accumulators and resolves pending deltas against router truth at poll time. `PerformerInputMonitor`'s three existing call sites are adapted minimally here so the package keeps building — its full rework (rotate, plain/Shift drag, `?`) is Task 6.

**Files:**
- Create: `app/Sources/FeedbaxKit/Control/TrackpadBinding.swift`
- Modify: `app/Sources/FeedbaxKit/Control/Bindings.swift` (remove `TrackpadAxis`/`TrackpadBindings`, v2 `Bindings` + Codable)
- Modify: `app/Sources/FeedbaxKit/Control/DefaultBindings.json`
- Modify: `app/Sources/FeedbaxKit/Control/KeyboardTrackpadSurface.swift`
- Modify: `app/Sources/FeedbaxKit/UI/PerformerInputMonitor.swift` (call sites only)
- Test: `app/Tests/FeedbaxKitTests/BindingsTests.swift` (new), `app/Tests/FeedbaxKitTests/KeyboardSurfaceTests.swift`

**Interfaces:**
- Consumes: `ControlAxis`, `ControlWrite(axes:)`, `ControlStateSnapshot.rawValue` (Task 1).
- Produces:
  - `enum TrackpadGesture: String, Codable, CaseIterable { case drag, scroll, pinch, rotate }` + `var axisCount: Int` (internal) + `var displayName: String`
  - `enum GestureModifier: String, Codable, CaseIterable { case option, shift }` + `var symbol: String`
  - `enum GesturePhase: Equatable { case began, changed, ended, cancelled }`
  - `struct GestureEvent: Equatable { gesture, modifiers: Set<GestureModifier>, phase, delta: SIMD2<Float> }` with `init(gesture:modifiers:phase:delta:)` and `init(gesture:modifiers:phase:dx:dy:)`
  - `struct TrackpadAxis: Equatable, Codable { axis: ControlAxis; sensitivity: Float }`
  - `struct TrackpadBinding: Equatable, Codable { gesture; modifiers; target: Target }`, `enum Target { case xy(x: TrackpadAxis, y: TrackpadAxis); case single(TrackpadAxis) }`
  - `struct PadAssignment: Equatable, Codable { x: ControlAxis; y: ControlAxis }`
  - `Bindings { version; keys; trackpad: [TrackpadBinding]; pads: [PadAssignment] }`, `static let currentVersion = 2`, `static let defaultPads`, `static let fallback`, `func trackpadBinding(for:modifiers:) -> TrackpadBinding?`
  - `KeyboardTrackpadSurface.handles(_ gesture:, modifiers:) -> Bool`, `.gesture(_ event: GestureEvent)`; `scroll`/`magnify`/`modifiedDrag` are removed.

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/BindingsTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

/// Spec §6.5: the v2 bindings table — a list of gesture rows plus two pad assignments — and
/// the decode rules that keep a hand-edited file honest.
final class BindingsTests: XCTestCase {
  private func decode(_ json: String) throws -> Bindings {
    try JSONDecoder().decode(Bindings.self, from: Data(json.utf8))
  }

  private func document(version: Int = 2, trackpad: String = "[]",
                        pads: String = #"[{"x":"layerX","y":"layerY"},{"x":"panX","y":"panY"}]"#) -> String {
    #"{"version": \#(version), "keys": {"i": "sInvert"}, "trackpad": \#(trackpad), "pads": \#(pads)}"#
  }

  private let pinchZoom = #"{"gesture":"pinch","modifiers":[],"axis":{"axis":"zoom","sensitivity":1.0}}"#
  private let dragPan = #"{"gesture":"drag","modifiers":[],"x":{"axis":"panX","sensitivity":1.0},"y":{"axis":"panY","sensitivity":1.0}}"#

  func testBundledDefaultIsVersion2WithTheDesignTable() throws {
    let b = try BindingsLoader.load(from: nil)
    XCTAssertEqual(b.version, 2)
    XCTAssertEqual(b.trackpad.count, 10, "design §6.1: ten rows")
    XCTAssertEqual(b.trackpadBinding(for: .rotate, modifiers: [])?.target,
                   .single(TrackpadAxis(axis: .slot(.theta), sensitivity: 1)))
    XCTAssertEqual(b.trackpadBinding(for: .pinch, modifiers: [.option])?.target,
                   .single(TrackpadAxis(axis: .layer(.scale), sensitivity: 1)))
    XCTAssertEqual(b.trackpadBinding(for: .drag, modifiers: [.shift])?.target,
                   .xy(x: TrackpadAxis(axis: .slot(.hue), sensitivity: 1),
                       y: TrackpadAxis(axis: .slot(.bias), sensitivity: 1)))
    XCTAssertEqual(b.trackpadBinding(for: .scroll, modifiers: [.option])?.target,
                   .xy(x: TrackpadAxis(axis: .layer(.x), sensitivity: 1),
                       y: TrackpadAxis(axis: .layer(.y), sensitivity: 1)))
    XCTAssertNil(b.trackpadBinding(for: .rotate, modifiers: [.shift]), "unbound combination")
    XCTAssertNil(b.trackpadBinding(for: .drag, modifiers: [.option, .shift]), "exact match, not subset")
    XCTAssertEqual(b.pads, Bindings.defaultPads)
    XCTAssertEqual(b.keys["i"], .sInvert(true), "keys table unchanged from v1")
  }

  func testRoundTripThroughJSONIsLossless() throws {
    let b = try BindingsLoader.load(from: nil)
    let data = try JSONEncoder().encode(b)
    XCTAssertEqual(try JSONDecoder().decode(Bindings.self, from: data), b)
  }

  func testTheOriginalPadLayoutIsTheDefault() {
    XCTAssertEqual(Bindings.defaultPads,
                   [PadAssignment(x: .layer(.x), y: .layer(.y)), PadAssignment(x: .slot(.panX), y: .slot(.panY))],
                   "left pad = image placement, right pad = shader pan (spec §04 §1.2–1.3)")
    XCTAssertEqual(Bindings.fallback.pads, Bindings.defaultPads)
    XCTAssertEqual(Bindings.fallback.version, Bindings.currentVersion)
  }

  func testVersion1IsRejected() {
    XCTAssertThrowsError(try decode(document(version: 1)))
    XCTAssertThrowsError(try decode(document(version: 3)))
  }

  func testArityMismatchIsRejected() {
    let pinchWithXY = #"{"gesture":"pinch","modifiers":[],"x":{"axis":"panX","sensitivity":1.0},"y":{"axis":"panY","sensitivity":1.0}}"#
    XCTAssertThrowsError(try decode(document(trackpad: "[\(pinchWithXY)]")), "pinch takes one axis")
    let dragWithAxis = #"{"gesture":"drag","modifiers":[],"axis":{"axis":"zoom","sensitivity":1.0}}"#
    XCTAssertThrowsError(try decode(document(trackpad: "[\(dragWithAxis)]")), "drag takes x and y")
    XCTAssertNoThrow(try decode(document(trackpad: "[\(pinchZoom), \(dragPan)]")))
  }

  func testDuplicateGestureRowIsRejected() {
    XCTAssertThrowsError(try decode(document(trackpad: "[\(pinchZoom), \(pinchZoom)]")))
  }

  func testUnknownAxisMarkerIsRejected() {
    let bad = #"{"gesture":"pinch","modifiers":[],"axis":{"axis":"warp","sensitivity":1.0}}"#
    XCTAssertThrowsError(try decode(document(trackpad: "[\(bad)]")))
  }

  func testUnknownModifierIsRejected() {
    let bad = #"{"gesture":"pinch","modifiers":["command"],"axis":{"axis":"zoom","sensitivity":1.0}}"#
    XCTAssertThrowsError(try decode(document(trackpad: "[\(bad)]")), "Command/Control are never performer modifiers")
  }

  func testPadsMustBeExactlyTwo() {
    XCTAssertThrowsError(try decode(document(pads: #"[{"x":"panX","y":"panY"}]"#)))
    XCTAssertThrowsError(try decode(document(pads: "[]")))
  }

  func testModifiersEncodeSortedForStableFiles() throws {
    let row = TrackpadBinding(gesture: .pinch, modifiers: [.shift, .option],
                              target: .single(TrackpadAxis(axis: .slot(.zoom), sensitivity: 1)))
    let text = String(data: try JSONEncoder().encode(row), encoding: .utf8)!
    XCTAssertTrue(text.contains(#""modifiers":["option","shift"]"#), text)
  }
}
```

Update `KeyboardSurfaceTests`: change `testBundledBindingsLoad` to expect `version == 2`, and replace the three gesture tests (`testScrollAccumulatesIntoPanAndClamps`, `testPollAssertsOnlyTouchedSlots`, `testHeldGestureAssertsOnceThenSilentUntilItChangesAgain`) with:

```swift
  private func surface(rawValue: @escaping (ControlAxis) -> Float = { _ in 0 }) throws -> KeyboardTrackpadSurface {
    KeyboardTrackpadSurface(bindings: try BindingsLoader.load(from: nil),
                            stateSnapshot: .constant(false, rawValue: rawValue))
  }

  func testTwoScrollsBeforeAPollAccumulateAndClamp() throws {
    let s = try surface()
    s.gesture(GestureEvent(gesture: .scroll, dx: 0.6, dy: 0))
    s.gesture(GestureEvent(gesture: .scroll, dx: 0.6, dy: 0))
    let w = s.poll(0)!
    XCTAssertEqual(w.slots[.panX]!, 1.0, accuracy: 1e-5, "clamped to the axis range −1..1")
    XCTAssertNil(w.slots[.panY], "a zero delta on y is not a change")
  }

  func testPollAssertsOnlyTouchedAxes() throws {
    let s = try surface()
    s.gesture(GestureEvent(gesture: .pinch, dx: 0.1))
    let w = s.poll(0)!
    XCTAssertNotNil(w.slots[.zoom]); XCTAssertNil(w.slots[.panX], "partial write (design §5)")
  }

  /// Spec §5: a nudge resolves against the router's CURRENT value, not a private accumulator.
  /// After another surface (a slider, a preset) moved pan to 0.5, the next scroll continues
  /// from 0.5 — the old accumulator would have jumped it back to its own stale position.
  func testNudgesResolveAgainstTruthAtPollTime() throws {
    var truth: [ControlAxis: Float] = [:]
    let s = try surface(rawValue: { truth[$0] ?? 0 })
    s.gesture(GestureEvent(gesture: .scroll, dx: 0.1, dy: 0))
    XCTAssertEqual(s.poll(0)?.slots[.panX], 0.1)
    truth[.slot(.panX)] = 0.5   // stand-in for a slider having moved it
    s.gesture(GestureEvent(gesture: .scroll, dx: 0.1, dy: 0))
    XCTAssertEqual(s.poll(0.016)?.slots[.panX], 0.6, "0.5 + 0.1, not 0.1 + 0.1")
  }

  func testANudgeThatLandsOnTheTruthAssertsNothing() throws {
    let s = try surface(rawValue: { $0 == .slot(.panX) ? 1.0 : 0 })
    s.gesture(GestureEvent(gesture: .scroll, dx: 0.3, dy: 0))   // already clamped at 1
    XCTAssertNil(s.poll(0), "message-on-change: clamp(1 + 0.3) == 1 == truth")
  }

  func testAGestureAssertsOnceThenStaysSilent() throws {
    let s = try surface()
    s.gesture(GestureEvent(gesture: .scroll, dx: 0.6, dy: 0))
    XCTAssertNotNil(s.poll(0)?.slots[.panX])
    XCTAssertNil(s.poll(0.016), "no new input → nothing to assert")
  }

  func testModifiersSelectTheTargetAndSensitivityScales() throws {
    let s = try surface()
    s.gesture(GestureEvent(gesture: .pinch, modifiers: [.option], dx: 0.2))
    s.gesture(GestureEvent(gesture: .rotate, dx: 0.25))
    s.gesture(GestureEvent(gesture: .drag, modifiers: [.shift], dx: 0.1, dy: -0.2))
    let w = s.poll(0)!
    XCTAssertEqual(w.layer[.scale]!, 0.2, accuracy: 1e-6, "Option-pinch → image scale")
    XCTAssertEqual(w.slots[.theta]!, 0.25, accuracy: 1e-6, "twist → rotate")
    XCTAssertEqual(w.slots[.hue]!, 0.1, accuracy: 1e-6, "Shift-drag x → hue")
    XCTAssertEqual(w.slots[.bias]!, -0.2, accuracy: 1e-6, "Shift-drag y → brightness")
    XCTAssertNil(w.slots[.zoom], "plain pinch was not performed")
  }

  func testUnboundGestureCombinationIsIgnored() throws {
    let s = try surface()
    XCTAssertFalse(s.handles(.rotate, modifiers: [.shift]))
    XCTAssertTrue(s.handles(.rotate, modifiers: [.option]))
    s.gesture(GestureEvent(gesture: .rotate, modifiers: [.shift], dx: 0.5))
    XCTAssertNil(s.poll(0))
  }
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter "BindingsTests|KeyboardSurfaceTests"`
Expected: compile failure — `GestureEvent`, `TrackpadBinding` not found.

- [ ] **Step 3: Create `TrackpadBinding.swift`**

```swift
import Foundation
import simd

/// The four trackpad gestures the surface recognizes (design §6.1). Drag is one finger with
/// the button held; the other three are two-finger gestures AppKit already recognizes and
/// delivers as `scrollWheel`/`magnify`/`rotate` events.
public enum TrackpadGesture: String, Codable, CaseIterable {
  case drag, scroll, pinch, rotate

  /// Drag/scroll move in two dimensions and bind two axes; pinch/rotate are scalar.
  var axisCount: Int { self == .drag || self == .scroll ? 2 : 1 }

  public var displayName: String {
    switch self {
    case .drag: return "Drag (one finger)"
    case .scroll: return "Scroll (two fingers)"
    case .pinch: return "Pinch"
    case .rotate: return "Twist"
    }
  }
}

/// The modifiers a performer can hold to retarget a gesture (design §6.1: Option = the image
/// layer, Shift = colour). Command/Control are deliberately not here — a chord with either is
/// an app/window shortcut and passes through untouched, as chorded keys already do.
///
/// A `Set<GestureModifier>` rather than an `OptionSet`: a set of a small `Codable` enum reads
/// as a JSON array (`["option"]`) in the hand-edited bindings file and compares by value,
/// which is all the table needs (design §13).
public enum GestureModifier: String, Codable, CaseIterable {
  case option, shift

  public var symbol: String { self == .option ? "⌥" : "⇧" }
}

/// Where in a continuous gesture an event sits — `NSEvent.Phase` reduced to what
/// `GestureLock` (Task 5) needs to know.
public enum GesturePhase: Equatable {
  case began, changed, ended, cancelled
}

/// One gesture event as the surface sees it: AppKit-free, already normalised by
/// `PerformerInputMonitor` (design §6.2). Pinch and rotate use `delta.x` only.
public struct GestureEvent: Equatable {
  public var gesture: TrackpadGesture
  public var modifiers: Set<GestureModifier>
  public var phase: GesturePhase
  public var delta: SIMD2<Float>

  public init(gesture: TrackpadGesture, modifiers: Set<GestureModifier> = [],
              phase: GesturePhase = .changed, delta: SIMD2<Float>) {
    self.gesture = gesture
    self.modifiers = modifiers
    self.phase = phase
    self.delta = delta
  }

  public init(gesture: TrackpadGesture, modifiers: Set<GestureModifier> = [],
              phase: GesturePhase = .changed, dx: Float, dy: Float = 0) {
    self.init(gesture: gesture, modifiers: modifiers, phase: phase, delta: SIMD2(dx, dy))
  }
}

/// One gesture axis's target and gain: which `ControlAxis` it nudges and how much of the
/// normalised delta lands per unit. Negative sensitivity flips a direction — the way a
/// performer whose "twist left" comes out backwards fixes it without a rebuild (design §6.2).
public struct TrackpadAxis: Equatable, Codable {
  public var axis: ControlAxis
  public var sensitivity: Float

  public init(axis: ControlAxis, sensitivity: Float) {
    self.axis = axis
    self.sensitivity = sensitivity
  }
}

/// One row of the trackpad table: (gesture, exact modifier set) → one or two axes.
public struct TrackpadBinding: Equatable {
  public enum Target: Equatable {
    case xy(x: TrackpadAxis, y: TrackpadAxis)
    case single(TrackpadAxis)
  }

  public var gesture: TrackpadGesture
  public var modifiers: Set<GestureModifier>
  public var target: Target

  public init(gesture: TrackpadGesture, modifiers: Set<GestureModifier>, target: Target) {
    self.gesture = gesture
    self.modifiers = modifiers
    self.target = target
  }
}

/// JSON shape (design §6.5): `{"gesture": "drag", "modifiers": ["option"], "x": {...}, "y": {...}}`
/// for two-axis gestures, `{"gesture": "pinch", "modifiers": [], "axis": {...}}` for scalar
/// ones. Decoding rejects an arity mismatch outright rather than guessing.
extension TrackpadBinding: Codable {
  private enum CodingKeys: String, CodingKey { case gesture, modifiers, x, y, axis }

  public init(from decoder: Decoder) throws {
    let c = try decoder.container(keyedBy: CodingKeys.self)
    gesture = try c.decode(TrackpadGesture.self, forKey: .gesture)
    modifiers = Set(try c.decodeIfPresent([GestureModifier].self, forKey: .modifiers) ?? [])
    let x = try c.decodeIfPresent(TrackpadAxis.self, forKey: .x)
    let y = try c.decodeIfPresent(TrackpadAxis.self, forKey: .y)
    let single = try c.decodeIfPresent(TrackpadAxis.self, forKey: .axis)
    switch (gesture.axisCount, x, y, single) {
    case (2, let x?, let y?, nil): target = .xy(x: x, y: y)
    case (1, nil, nil, let axis?): target = .single(axis)
    default:
      throw DecodingError.dataCorruptedError(
        forKey: .gesture, in: c,
        debugDescription: "'\(gesture.rawValue)' needs \(gesture.axisCount == 2 ? "x and y" : "axis") and nothing else")
    }
  }

  public func encode(to encoder: Encoder) throws {
    var c = encoder.container(keyedBy: CodingKeys.self)
    try c.encode(gesture, forKey: .gesture)
    // Sorted so a saved file is byte-stable across runs (a `Set` has no order of its own).
    try c.encode(modifiers.sorted { $0.rawValue < $1.rawValue }, forKey: .modifiers)
    switch target {
    case .xy(let x, let y):
      try c.encode(x, forKey: .x)
      try c.encode(y, forKey: .y)
    case .single(let axis):
      try c.encode(axis, forKey: .axis)
    }
  }
}

/// Which two axes one on-screen XY pad drives (design §7). `{"x": "layerX", "y": "layerY"}`.
public struct PadAssignment: Equatable, Codable {
  public var x: ControlAxis
  public var y: ControlAxis

  public init(x: ControlAxis, y: ControlAxis) {
    self.x = x
    self.y = y
  }
}
```

- [ ] **Step 4: Rewrite `Bindings` in `Bindings.swift`**

Delete the `TrackpadAxis` and `TrackpadBindings` structs and their `Codable` extensions (`extension TrackpadAxis: Codable` and `extension TrackpadBindings: Codable {}`). Keep the `ToggleEvent`/`ControlSlot` marker extensions and `BindingsLoader`. Replace the `Bindings` struct and its `Codable` extension with:

```swift
/// The performer's bindings table (design §5, §6.5): a versioned, hand-editable JSON resource.
/// `keys` maps a key to WHICH `ToggleEvent` it fires (the Bool is a placeholder, resolved at
/// poll time against live truth — `KeyboardTrackpadSurface.resolveToggles`); `trackpad` is a
/// list of gesture rows looked up by exact (gesture, modifiers); `pads` is the two on-screen
/// XY pads' axis assignments.
public struct Bindings: Equatable {
  /// Bumped from 1 when the trackpad table became a gesture list and `pads` appeared. No
  /// migration: the only v1 file that ever existed was the bundled default this replaces.
  public static let currentVersion = 2

  public var version: Int
  public var keys: [String: ToggleEvent]
  public var trackpad: [TrackpadBinding]
  public var pads: [PadAssignment]

  public init(version: Int, keys: [String: ToggleEvent], trackpad: [TrackpadBinding],
              pads: [PadAssignment]) {
    self.version = version
    self.keys = keys
    self.trackpad = trackpad
    self.pads = pads
  }

  /// Exact-match lookup: Option+Shift matches no row of the default table and so passes
  /// through — modifiers select a row, they don't stack (design §6.1).
  public func trackpadBinding(for gesture: TrackpadGesture,
                              modifiers: Set<GestureModifier>) -> TrackpadBinding? {
    trackpad.first { $0.gesture == gesture && $0.modifiers == modifiers }
  }

  /// The pad layout the original ran (spec §04 §1.2–1.3): left pad = image placement, right
  /// pad = shader pan.
  public static let defaultPads = [
    PadAssignment(x: .layer(.x), y: .layer(.y)),
    PadAssignment(x: .slot(.panX), y: .slot(.panY)),
  ]

  /// A usable table with no keys or gestures — what `EngineViewModel()` (the bare unit-test
  /// form) runs on when no `BindingsStore` is injected. Never loaded from disk.
  public static let fallback = Bindings(version: currentVersion, keys: [:], trackpad: [], pads: defaultPads)
}

extension Bindings: Codable {
  private enum CodingKeys: String, CodingKey { case version, keys, trackpad, pads }

  public init(from decoder: Decoder) throws {
    let c = try decoder.container(keyedBy: CodingKeys.self)
    version = try c.decode(Int.self, forKey: .version)
    guard version == Bindings.currentVersion else {
      throw DecodingError.dataCorruptedError(
        forKey: .version, in: c,
        debugDescription: "Bindings version \(version) is not supported (this build reads version \(Bindings.currentVersion))")
    }
    let rawKeys = try c.decode([String: String].self, forKey: .keys)
    var resolved: [String: ToggleEvent] = [:]
    for (key, marker) in rawKeys {
      guard let event = ToggleEvent.fromMarker(marker) else {
        throw DecodingError.dataCorruptedError(
          forKey: .keys, in: c, debugDescription: "Unknown toggle marker '\(marker)' for key '\(key)'")
      }
      resolved[key] = event
    }
    keys = resolved
    trackpad = try c.decode([TrackpadBinding].self, forKey: .trackpad)
    // Two rows for the same (gesture, modifiers) would make `trackpadBinding(for:)` silently
    // pick the first — reject the file instead so the edit that caused it gets noticed.
    var seen: Set<String> = []
    for row in trackpad {
      let key = row.gesture.rawValue + ":" + row.modifiers.map(\.rawValue).sorted().joined(separator: "+")
      guard seen.insert(key).inserted else {
        throw DecodingError.dataCorruptedError(
          forKey: .trackpad, in: c, debugDescription: "Duplicate trackpad row for \(key)")
      }
    }
    pads = try c.decode([PadAssignment].self, forKey: .pads)
    guard pads.count == 2 else {
      throw DecodingError.dataCorruptedError(
        forKey: .pads, in: c, debugDescription: "Exactly two pads are expected, found \(pads.count)")
    }
  }

  public func encode(to encoder: Encoder) throws {
    var c = encoder.container(keyedBy: CodingKeys.self)
    try c.encode(version, forKey: .version)
    let rawKeys = Dictionary(uniqueKeysWithValues: keys.map { ($0.key, $0.value.marker) })
    try c.encode(rawKeys, forKey: .keys)
    try c.encode(trackpad, forKey: .trackpad)
    try c.encode(pads, forKey: .pads)
  }
}
```

- [ ] **Step 5: Replace `DefaultBindings.json` with the v2 table**

```json
{
  "version": 2,
  "keys": {
    "i": "sInvert",
    "w": "worldBumpEnabled",
    "a": "waveBumpEnabled",
    "k": "kittyBumpEnabled",
    "p": "layerEnabled",
    "f": "fullscreen",
    "s": "stillCapture",
    "1": "wave1Enabled",
    "2": "wave2Enabled"
  },
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

- [ ] **Step 6: Rewrite the gesture half of `KeyboardTrackpadSurface`**

Replace the `accumulators` and `lastAsserted` properties, the `scroll`/`magnify`/`modifiedDrag` methods, `poll`, and `accumulate` with the following (keep `bindings`, `stateSnapshot`, `pendingToggleTemplates`, `pendingEraseStep`, `eraseStepMagnitude`, `init`, `handles(_ key:)`, `keyDown`, `resolveToggles` as they are):

```swift
  /// Deltas gathered since the last `poll`, per axis. NOT a held position (design §5): the
  /// surface used to keep its own accumulator per slot and nudge THAT, so after the operator
  /// panel or a preset moved a slot, the next trackpad nudge asserted "stale accumulator +
  /// delta" and snapped the value back. `poll` now resolves each delta against
  /// `stateSnapshot.rawValue` — the router's truth at that moment — which is the same
  /// "read truth at poll time" ruling finding 4 established for toggles.
  private var pendingDeltas: [ControlAxis: Float] = [:]

  /// Whether the bindings table has a row for this exact gesture + modifier set —
  /// `PerformerInputMonitor`'s consume/pass-through decision for pointer events, mirroring
  /// `handles(_ key:)`: an unbound combination is never swallowed.
  public func handles(_ gesture: TrackpadGesture, modifiers: Set<GestureModifier>) -> Bool {
    bindings.trackpadBinding(for: gesture, modifiers: modifiers) != nil
  }

  /// One normalised gesture event (design §6.4). Unbound → no-op, same as an unbound key.
  public func gesture(_ event: GestureEvent) {
    guard let binding = bindings.trackpadBinding(for: event.gesture, modifiers: event.modifiers) else { return }
    switch binding.target {
    case .xy(let x, let y):
      nudge(event.delta.x, along: x)
      nudge(event.delta.y, along: y)
    case .single(let axis):
      nudge(event.delta.x, along: axis)
    }
  }

  private func nudge(_ delta: Float, along axis: TrackpadAxis) {
    pendingDeltas[axis.axis, default: 0] += delta * axis.sensitivity
  }

  public func poll(_ time: TimeInterval) -> ControlWrite? {
    // Each pending delta lands on the router's CURRENT raw value, clamped to the axis range,
    // and is asserted only if that actually moves it — message-on-change falls out of the
    // comparison (a nudge into a clamp, or one that overshoots and corrects back within one
    // frame, asserts nothing).
    var axes: [ControlAxis: Float] = [:]
    for (axis, delta) in pendingDeltas {
      let truth = stateSnapshot.rawValue(axis)
      let next = axis.clamped(truth + delta)
      if next != truth { axes[axis] = next }
    }
    pendingDeltas = [:]
    let toggles = resolveToggles()
    let eraseStep = pendingEraseStep
    pendingEraseStep = nil
    if axes.isEmpty && toggles.isEmpty && eraseStep == nil {
      return nil   // assert nothing this frame — ControlRouter falls through (spec §04 §1.2)
    }
    return ControlWrite(axes: axes, toggles: toggles, eraseStep: eraseStep)
  }
```

Update the type's doc comment: the "Accumulators" bullet becomes "**Gesture deltas** are gathered per axis and resolved against router truth at poll time (design §5) — a gesture nudges the axis from wherever it actually is."

- [ ] **Step 7: Adapt `PerformerInputMonitor`'s three call sites (no behaviour beyond what compiles)**

In `handle(_:)`:

```swift
    case .scrollWheel:
      guard isOutputWindowEvent(event), let height = eventViewHeight(event) else { return .passThrough }
      surface.gesture(GestureEvent(gesture: .scroll,
                                   dx: Float(event.scrollingDeltaX) / height,
                                   dy: Float(event.scrollingDeltaY) / height))
      return .forward

    case .magnify:
      guard isOutputWindowEvent(event) else { return .passThrough }
      surface.gesture(GestureEvent(gesture: .pinch, dx: Float(event.magnification)))
      return .forward

    case .leftMouseDragged:
      guard event.modifierFlags.contains(.option), isOutputWindowEvent(event),
            let height = eventViewHeight(event) else { return .passThrough }
      surface.gesture(GestureEvent(gesture: .drag, modifiers: [.option],
                                   dx: Float(event.deltaX) / height, dy: Float(event.deltaY) / height))
      return .forward
```

Keep the existing comments on normalisation. (Task 6 replaces this whole block.)

- [ ] **Step 8: Run the tests, then the full suite**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app`
Expected: green. `PerformerInputMonitorTests.testOptionFDoesNotToggleFullscreenButStillReachesTheSurface` and friends still pass — keys are untouched.

- [ ] **Step 9: Commit**

```bash
git add app/Sources/FeedbaxKit/Control/TrackpadBinding.swift app/Sources/FeedbaxKit/Control/Bindings.swift app/Sources/FeedbaxKit/Control/DefaultBindings.json app/Sources/FeedbaxKit/Control/KeyboardTrackpadSurface.swift app/Sources/FeedbaxKit/UI/PerformerInputMonitor.swift app/Tests/FeedbaxKitTests/BindingsTests.swift app/Tests/FeedbaxKitTests/KeyboardSurfaceTests.swift
git commit -m "feat(control): bindings v2 gesture table and pads; trackpad surface resolves nudges against router truth"
```

---

### Task 5: Dominant-gesture lock

Spec §6.3. AppKit delivers `magnify`, `rotate`, and two-finger `scrollWheel` simultaneously during one two-finger movement; the first to cross its threshold claims the sequence.

**Files:**
- Create: `app/Sources/FeedbaxKit/Control/GestureLock.swift`
- Modify: `app/Sources/FeedbaxKit/Control/KeyboardTrackpadSurface.swift` (`gesture(_:)`)
- Test: `app/Tests/FeedbaxKitTests/GestureLockTests.swift` (new), `app/Tests/FeedbaxKitTests/KeyboardSurfaceTests.swift` (one integration test)

**Interfaces:**
- Consumes: `GestureEvent`, `TrackpadGesture`, `GesturePhase` (Task 4).
- Produces: `struct GestureLock { enum State { idle, claimed(TrackpadGesture) }; private(set) var state; static let thresholds: [TrackpadGesture: Float]; mutating func admit(_ event: GestureEvent) -> Bool }` (internal to the module).

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/GestureLockTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

/// Spec §6.3: one two-finger movement arrives as pinch AND rotate AND scroll events at once.
/// The first past its threshold claims the sequence; the others are discarded until it ends.
final class GestureLockTests: XCTestCase {
  private func rotate(_ deg: Float, phase: GesturePhase = .changed) -> GestureEvent {
    GestureEvent(gesture: .rotate, phase: phase, dx: deg / 180)
  }
  private func pinch(_ m: Float, phase: GesturePhase = .changed) -> GestureEvent {
    GestureEvent(gesture: .pinch, phase: phase, dx: m)
  }

  func testSubThresholdMovementIsNotAdmitted() {
    var lock = GestureLock()
    XCTAssertFalse(lock.admit(rotate(2)), "2° < the 5° threshold")
    XCTAssertEqual(lock.state, .idle)
  }

  func testTravelAccumulatesAcrossEventsUntilTheThreshold() {
    var lock = GestureLock()
    XCTAssertFalse(lock.admit(rotate(2)))
    XCTAssertFalse(lock.admit(rotate(2)))
    XCTAssertTrue(lock.admit(rotate(2)), "6° cumulative — this event is admitted")
    XCTAssertEqual(lock.state, .claimed(.rotate))
  }

  func testFirstGesturePastThresholdClaimsAndTheOtherIsDiscarded() {
    var lock = GestureLock()
    XCTAssertTrue(lock.admit(rotate(10)))
    XCTAssertFalse(lock.admit(pinch(0.5)), "a large pinch is still discarded once rotate owns the sequence")
    XCTAssertTrue(lock.admit(rotate(1)), "the winner's small deltas keep flowing")
  }

  func testEndingTheWinnerReleasesTheLock() {
    var lock = GestureLock()
    XCTAssertTrue(lock.admit(pinch(0.1)))
    XCTAssertFalse(lock.admit(pinch(0, phase: .ended)), "the end event itself carries nothing to apply")
    XCTAssertEqual(lock.state, .idle)
    XCTAssertTrue(lock.admit(rotate(10)), "a fresh sequence can be claimed by the other gesture")
  }

  func testANonWinnerEndingDoesNotReleaseTheLock() {
    var lock = GestureLock()
    XCTAssertTrue(lock.admit(rotate(10)))
    _ = lock.admit(pinch(0, phase: .ended))
    XCTAssertEqual(lock.state, .claimed(.rotate))
  }

  func testCancelledReleasesLikeEnded() {
    var lock = GestureLock()
    XCTAssertTrue(lock.admit(rotate(10)))
    _ = lock.admit(rotate(0, phase: .cancelled))
    XCTAssertEqual(lock.state, .idle)
  }

  func testAnIdleEndClearsThatGesturesTravel() {
    var lock = GestureLock()
    XCTAssertFalse(lock.admit(rotate(4)))
    _ = lock.admit(rotate(0, phase: .ended))        // fingers lifted before the threshold
    XCTAssertFalse(lock.admit(rotate(2)), "travel restarted from zero")
  }

  func testDragIsNeverContested() {
    var lock = GestureLock()
    XCTAssertTrue(lock.admit(rotate(10)))
    XCTAssertTrue(lock.admit(GestureEvent(gesture: .drag, dx: 0.001, dy: 0)), "one-finger drag can't co-occur; never locked")
    XCTAssertTrue(lock.admit(GestureEvent(gesture: .drag, phase: .ended, dx: 0.001, dy: 0)), "and its end is inert")
  }
}
```

Add to `KeyboardSurfaceTests`:

```swift
  /// Spec §6.3 end to end: a twist that leaks pinch deltas moves rotate only.
  func testATwistThatLeaksPinchDeltasMovesRotateOnly() throws {
    let s = try surface()
    s.gesture(GestureEvent(gesture: .rotate, phase: .began, dx: 0))
    s.gesture(GestureEvent(gesture: .pinch, phase: .began, dx: 0))
    for _ in 0..<5 {
      s.gesture(GestureEvent(gesture: .rotate, dx: 3.0 / 180))   // 15° total, past 5°
      s.gesture(GestureEvent(gesture: .pinch, dx: 0.01))         // 0.05 total — would also pass alone
    }
    let w = s.poll(0)!
    XCTAssertNotNil(w.slots[.theta])
    XCTAssertNil(w.slots[.zoom], "pinch was discarded once rotate claimed the sequence")
  }
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter "GestureLockTests|KeyboardSurfaceTests"`
Expected: compile failure — `GestureLock` not found.

- [ ] **Step 3: Create `GestureLock.swift`**

```swift
import Foundation

/// Arbitration between the two-finger gestures AppKit delivers SIMULTANEOUSLY during one
/// physical movement (design §6.3): a twist leaks small `magnify` deltas and vice versa, and
/// at sensitivity 1 fifty leaked ±0.01 pinch events is half the zoom range. A sequence
/// starts idle; each gesture's travel accumulates; the first to cross its threshold claims the
/// sequence and the others are discarded until the winner's `.ended`/`.cancelled` arrives.
/// Movement before the threshold is not applied — ordinary hysteresis.
///
/// A `struct` with `mutating` methods, not a class: it's a value the surface owns outright,
/// with no identity of its own to share.
struct GestureLock: Equatable {
  enum State: Equatable {
    case idle
    case claimed(TrackpadGesture)
  }

  private(set) var state: State = .idle
  /// Cumulative |delta| per gesture while idle.
  private var travel: [TrackpadGesture: Float] = [:]

  /// Normalised units (design §6.3): scroll is in output-heights, pinch is `magnification`,
  /// rotate is degrees/180 — so 5° is 0.028. First guesses, flagged for tuning (design §12).
  static let thresholds: [TrackpadGesture: Float] = [
    .scroll: 0.02,
    .pinch: 0.05,
    .rotate: 5.0 / 180.0,
  ]

  /// Whether `event`'s delta should be applied.
  mutating func admit(_ event: GestureEvent) -> Bool {
    // Drag is one finger with the button held — it can't co-occur with the two-finger set,
    // so it is never contested and never touches the lock.
    guard let threshold = Self.thresholds[event.gesture] else { return true }
    switch event.phase {
    case .ended, .cancelled:
      if state == .claimed(event.gesture) {
        state = .idle
        travel = [:]
      } else {
        travel[event.gesture] = nil
      }
      return false
    case .began, .changed:
      if case .claimed(let winner) = state { return winner == event.gesture }
      let total = (travel[event.gesture] ?? 0) + abs(event.delta.x) + abs(event.delta.y)
      travel[event.gesture] = total
      guard total >= threshold else { return false }
      state = .claimed(event.gesture)
      travel = [:]
      return true
    }
  }
}
```

- [ ] **Step 4: Wire the lock into `KeyboardTrackpadSurface.gesture(_:)`**

Add `private var lock = GestureLock()` beside `pendingDeltas`, and change `gesture(_:)` to:

```swift
  public func gesture(_ event: GestureEvent) {
    guard let binding = bindings.trackpadBinding(for: event.gesture, modifiers: event.modifiers) else { return }
    // Bound gestures only reach the lock — an unbound combination the monitor let through
    // (or a test fed directly) must not claim a sequence nothing will ever end.
    guard lock.admit(event) else { return }
    switch binding.target {
    case .xy(let x, let y):
      nudge(event.delta.x, along: x)
      nudge(event.delta.y, along: y)
    case .single(let axis):
      nudge(event.delta.x, along: axis)
    }
  }
```

Note for the existing Task 4 tests: a single `scroll` of `dx: 0.6` or `pinch` of `0.1`/`0.2` and a `rotate` of `0.25` each exceed their threshold on the first event, so they still assert — the thresholds are deliberately small relative to a real gesture. If any Task 4 test's first delta is below a threshold, raise the test's delta, not the threshold.

- [ ] **Step 5: Run the tests, then the full suite**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app`
Expected: green.

- [ ] **Step 6: Commit**

```bash
git add app/Sources/FeedbaxKit/Control/GestureLock.swift app/Sources/FeedbaxKit/Control/KeyboardTrackpadSurface.swift app/Tests/FeedbaxKitTests/GestureLockTests.swift app/Tests/FeedbaxKitTests/KeyboardSurfaceTests.swift
git commit -m "feat(control): dominant-gesture lock so a twist does not leak zoom"
```

---

### Task 6: `PerformerInputMonitor` — rotate, plain/Shift drags, modifier extraction, phases, `?`

Spec §6.1–6.2, §8.3. The monitor becomes a thin normaliser: every pointer event maps to one `GestureEvent`; the surface decides via `handles(_:modifiers:)` whether it is consumed.

**Files:**
- Modify: `app/Sources/FeedbaxKit/UI/PerformerInputMonitor.swift`
- Test: `app/Tests/FeedbaxKitTests/PerformerInputMonitorTests.swift`

**Interfaces:**
- Consumes: `KeyboardTrackpadSurface.handles(_:modifiers:)`, `.gesture(_:)`, `GestureEvent`, `GesturePhase` (Tasks 4–5).
- Produces:
  - `static func gestureModifiers(_ flags: NSEvent.ModifierFlags) -> Set<GestureModifier>?` (nil = Command/Control chord → pass through)
  - `static func gesturePhase(_ phase: NSEvent.Phase) -> GesturePhase`
  - `static let rotationNormalization: Float = 180`, `static func normalizedRotation(_ degrees: Float) -> Float`
  - `static func decideHelpKey(firstResponderIsTextEditor: Bool, characters: String?, chordFlags: NSEvent.ModifierFlags) -> Bool`
  - `Notification.Name.feedbaxShowControlsReference` (public), posted on `?`

- [ ] **Step 1: Write the failing tests**

Append to `PerformerInputMonitorTests`:

```swift
  // MARK: - Pointer gestures (design §6.2) and the help key (design §8.3)

  func testGestureModifiersExtractOptionAndShiftAndRejectCommandControl() {
    XCTAssertEqual(PerformerInputMonitor.gestureModifiers([]), [])
    XCTAssertEqual(PerformerInputMonitor.gestureModifiers(.option), [.option])
    XCTAssertEqual(PerformerInputMonitor.gestureModifiers(.shift), [.shift])
    XCTAssertEqual(PerformerInputMonitor.gestureModifiers([.option, .shift]), [.option, .shift])
    XCTAssertNil(PerformerInputMonitor.gestureModifiers(.command), "Cmd-gesture is never the performer's")
    XCTAssertNil(PerformerInputMonitor.gestureModifiers([.control, .option]))
    XCTAssertEqual(PerformerInputMonitor.gestureModifiers([.option, .capsLock]), [.option],
                   "device-independent noise like Caps Lock is ignored")
  }

  func testGesturePhaseMapsNSEventPhase() {
    XCTAssertEqual(PerformerInputMonitor.gesturePhase(.began), .began)
    XCTAssertEqual(PerformerInputMonitor.gesturePhase(.changed), .changed)
    XCTAssertEqual(PerformerInputMonitor.gesturePhase([]), .changed, "momentum/stationary events count as changes")
    XCTAssertEqual(PerformerInputMonitor.gesturePhase(.ended), .ended)
    XCTAssertEqual(PerformerInputMonitor.gesturePhase(.cancelled), .cancelled)
  }

  func testRotationIsNormalisedSoHalfATurnSpansTheRange() {
    XCTAssertEqual(PerformerInputMonitor.normalizedRotation(90), 0.5, accuracy: 1e-6)
    XCTAssertEqual(PerformerInputMonitor.normalizedRotation(-180), -1, accuracy: 1e-6)
  }

  func testHelpKeyDecision() {
    XCTAssertTrue(PerformerInputMonitor.decideHelpKey(firstResponderIsTextEditor: false, characters: "?", chordFlags: .shift),
                  "Shift-/ on a US layout")
    XCTAssertTrue(PerformerInputMonitor.decideHelpKey(firstResponderIsTextEditor: false, characters: "?", chordFlags: []),
                  "layouts with an unshifted ?")
    XCTAssertFalse(PerformerInputMonitor.decideHelpKey(firstResponderIsTextEditor: true, characters: "?", chordFlags: .shift),
                   "typing ? into the preset-name field")
    XCTAssertFalse(PerformerInputMonitor.decideHelpKey(firstResponderIsTextEditor: false, characters: "?", chordFlags: .command),
                   "⌘? is the menu item's own shortcut — leave it to the menu")
    XCTAssertFalse(PerformerInputMonitor.decideHelpKey(firstResponderIsTextEditor: false, characters: "/", chordFlags: []))
  }

  func testQuestionMarkPostsTheShowReferenceNotificationAndIsConsumed() {
    let window = makeRecordingWindow()
    let (monitor, surface) = makeMonitor(window: window)
    let posted = expectation(forNotification: .feedbaxShowControlsReference, object: nil)
    let event = keyEvent(window: window, characters: "?", keyCode: 44, modifierFlags: .shift)
    XCTAssertEqual(monitor.handle(event), .forward)
    wait(for: [posted], timeout: 1)
    XCTAssertNil(surface.poll(0), "? is an app action, never a control write")
  }

  /// A drag event with a real content height (the normaliser divides by it) — `RecordingWindow`
  /// is built on a zero rect, so these tests need their own.
  private func makeDragWindow() -> NSWindow {
    NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 200), styleMask: [],
             backing: .buffered, defer: false)
  }

  private func dragEvent(window: NSWindow, modifierFlags: NSEvent.ModifierFlags = []) -> NSEvent {
    NSEvent.mouseEvent(with: .leftMouseDragged, location: NSPoint(x: 10, y: 10),
                       modifierFlags: modifierFlags, timestamp: 0, windowNumber: window.windowNumber,
                       context: nil, eventNumber: 0, clickCount: 1, pressure: 1)!
  }

  func testPlainDragInTheOutputWindowIsForwarded() {
    let window = makeDragWindow()
    let (monitor, _) = makeMonitor(window: window)
    XCTAssertEqual(monitor.handle(dragEvent(window: window)), .forward,
                   "design §6.1: plain drag is the one-finger pan gesture")
  }

  func testShiftDragIsForwardedAndOptionShiftDragPassesThrough() {
    let window = makeDragWindow()
    let (monitor, _) = makeMonitor(window: window)
    XCTAssertEqual(monitor.handle(dragEvent(window: window, modifierFlags: .shift)), .forward)
    XCTAssertEqual(monitor.handle(dragEvent(window: window, modifierFlags: [.option, .shift])), .passThrough,
                   "no row for Option+Shift — never swallowed")
    XCTAssertEqual(monitor.handle(dragEvent(window: window, modifierFlags: .command)), .passThrough)
  }

  func testDragOutsideTheOutputWindowPassesThrough() {
    let output = makeDragWindow()
    let other = makeDragWindow()
    let (monitor, _) = makeMonitor(window: output)
    XCTAssertEqual(monitor.handle(dragEvent(window: other)), .passThrough)
  }
```

Also update the class doc comment's key-code list to include "`?` 44 (Shift-/)".

- [ ] **Step 2: Run the tests to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter PerformerInputMonitorTests`
Expected: compile failure — `gestureModifiers` etc. not found.

- [ ] **Step 3: Implement**

Add the notification name at the bottom of `PerformerInputMonitor.swift`:

```swift
extension Notification.Name {
  /// Posted by `PerformerInputMonitor` on the `?` key (design §8.3). `NotificationCenter` is the
  /// conventional bridge from an AppKit object to SwiftUI views without either owning the
  /// other — `FeedbaxScenes`' window content views `.onReceive` this and open the Controls
  /// Reference window (design §13).
  public static let feedbaxShowControlsReference = Notification.Name("FeedbaxShowControlsReference")
}
```

Extend the monitor mask in `install()`:

```swift
      matching: [.keyDown, .scrollWheel, .magnify, .rotate, .leftMouseDragged]
```

Add the pure helpers next to `decideKey`/`decidePointer`:

```swift
  /// Which performer modifiers a pointer event carries, or nil when Command/Control make it an
  /// app/window chord that must pass through — the same rule `decideKey` applies to keys.
  /// Only Option and Shift are performer modifiers (`GestureModifier`); Caps Lock, Fn and the
  /// numeric-pad bit are ignored rather than disqualifying.
  public static func gestureModifiers(_ flags: NSEvent.ModifierFlags) -> Set<GestureModifier>? {
    let chord = flags.intersection(.deviceIndependentFlagsMask)
    if chord.contains(.command) || chord.contains(.control) { return nil }
    var modifiers: Set<GestureModifier> = []
    if chord.contains(.option) { modifiers.insert(.option) }
    if chord.contains(.shift) { modifiers.insert(.shift) }
    return modifiers
  }

  /// `NSEvent.Phase` → `GesturePhase`. Momentum scroll events and stationary events carry an
  /// empty phase; they are ordinary changes to the surface.
  public static func gesturePhase(_ phase: NSEvent.Phase) -> GesturePhase {
    if phase.contains(.cancelled) { return .cancelled }
    if phase.contains(.ended) { return .ended }
    if phase.contains(.began) { return .began }
    return .changed
  }

  /// `NSEvent.rotation` is degrees per event; ÷180 makes half a turn span the whole −1...1
  /// raw range at sensitivity 1 (design §6.2).
  public static let rotationNormalization: Float = 180

  public static func normalizedRotation(_ degrees: Float) -> Float {
    degrees / rotationNormalization
  }

  /// `?` opens the Controls Reference (design §8.3): no text editor focused, and no modifier
  /// beyond Shift (Shift-/ is how a US keyboard types it). ⌘? is deliberately NOT ours — that
  /// is the Help menu item's own key equivalent.
  public static func decideHelpKey(firstResponderIsTextEditor: Bool, characters: String?,
                                   chordFlags: NSEvent.ModifierFlags) -> Bool {
    guard characters == "?", !firstResponderIsTextEditor else { return false }
    return chordFlags.subtracting(.shift).isEmpty
  }
```

In `handle(_:)`'s `.keyDown` case, after the Escape/`f` block and before `let isBound`:

```swift
      if Self.decideHelpKey(firstResponderIsTextEditor: isText, characters: characters,
                            chordFlags: chordFlags) {
        NotificationCenter.default.post(name: .feedbaxShowControlsReference, object: nil)
        return .forward   // consumed: `?` is an app action, not a control write
      }
```

Replace the `.scrollWheel`, `.magnify`, `.leftMouseDragged` cases with:

```swift
    case .scrollWheel:
      // `scrollingDeltaX/Y` are raw POINTS and one fast swipe can report 5–40 of them; ÷ the
      // output view's height turns "drag the full height of the output" into "drive the axis
      // across its whole −1...1 range" and scales with the window. The surface is AppKit-free
      // and has no geometry of its own, which is why the normalisation lives here.
      guard let height = eventViewHeight(event) else { return .passThrough }
      return forward(.scroll, event: event, phase: Self.gesturePhase(event.phase),
                     delta: SIMD2(Float(event.scrollingDeltaX) / height, Float(event.scrollingDeltaY) / height))

    case .magnify:
      // `magnification` is already a small per-event ratio — no normalisation.
      return forward(.pinch, event: event, phase: Self.gesturePhase(event.phase),
                     delta: SIMD2(Float(event.magnification), 0))

    case .rotate:
      return forward(.rotate, event: event, phase: Self.gesturePhase(event.phase),
                     delta: SIMD2(Self.normalizedRotation(Float(event.rotation)), 0))

    case .leftMouseDragged:
      // Plain drag = pan, Option = image layer, Shift = colour (design §6.1) — which is which
      // is the bindings table's business; this just normalises like scroll.
      guard let height = eventViewHeight(event) else { return .passThrough }
      return forward(.drag, event: event, phase: .changed,
                     delta: SIMD2(Float(event.deltaX) / height, Float(event.deltaY) / height))
```

and add the shared helper next to `isOutputWindowEvent`:

```swift
  /// One path for every pointer gesture: output window only (`decidePointer`), no
  /// Command/Control chord, and a bindings row for this gesture + modifiers — otherwise the
  /// event passes through untouched (a two-finger scroll over the Controls form keeps
  /// scrolling the form; an Option+Shift pinch nobody bound reaches whatever wanted it).
  private func forward(_ gesture: TrackpadGesture, event: NSEvent, phase: GesturePhase,
                       delta: SIMD2<Float>) -> Decision {
    guard isOutputWindowEvent(event),
          let modifiers = Self.gestureModifiers(event.modifierFlags),
          surface.handles(gesture, modifiers: modifiers) else { return .passThrough }
    surface.gesture(GestureEvent(gesture: gesture, modifiers: modifiers, phase: phase, delta: delta))
    return .forward
  }
```

Update the class doc comment to list the five event types and the `?` role. `import simd` at the top if `SIMD2` isn't already visible via AppKit (it is via Foundation on macOS 14, but the import is harmless).

- [ ] **Step 4: Run the tests, then the full suite**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app`
Expected: green. The old `testOptionFDoesNotToggleFullscreenButStillReachesTheSurface` still holds (keys unchanged).

- [ ] **Step 5: Commit**

```bash
git add app/Sources/FeedbaxKit/UI/PerformerInputMonitor.swift app/Tests/FeedbaxKitTests/PerformerInputMonitorTests.swift
git commit -m "feat(input): twist, plain and Shift drags, modifier-selected targets, and the ? help key"
```

---

### Task 7: `BindingsStore` and bootstrap wiring

Spec §6.6. User file → bundled default; `save` round-trips the whole table. `AppBootstrap` loads through the store and gives the keyboard snapshot its `rawValue` reader.

**Files:**
- Create: `app/Sources/FeedbaxKit/Control/BindingsStore.swift`
- Modify: `app/Sources/FeedbaxKit/UI/AppBootstrap.swift`
- Test: `app/Tests/FeedbaxKitTests/BindingsStoreTests.swift`

**Interfaces:**
- Consumes: `Bindings`, `BindingsLoader`, `PadAssignment` (Task 4); `ControlRouter.rawValue(for:)` (Task 2).
- Produces: `final class BindingsStore { private(set) var bindings: Bindings; static var defaultUserFileURL: URL; init(userFileURL: URL?) throws; init(bindings: Bindings, userFileURL: URL?); func setPads(_ pads: [PadAssignment]) throws; func save() throws }`; `AppBootstrap.bindingsStore: BindingsStore`.

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/BindingsStoreTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

/// Spec §6.6: `~/Library/Application Support/Feedbax/Bindings.json` wins over the bundled
/// default; pad reassignment writes the whole table back so hand edits survive.
final class BindingsStoreTests: XCTestCase {
  private var userFile: URL!

  override func setUpWithError() throws {
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    userFile = dir.appendingPathComponent("Bindings.json")
  }

  override func tearDownWithError() throws {
    try? FileManager.default.removeItem(at: userFile.deletingLastPathComponent())
  }

  func testMissingUserFileFallsBackToTheBundledDefault() throws {
    let store = try BindingsStore(userFileURL: userFile)
    XCTAssertEqual(store.bindings, try BindingsLoader.load(from: nil))
    XCTAssertFalse(FileManager.default.fileExists(atPath: userFile.path), "reading never creates the file")
  }

  func testNilUserFileMeansBundledOnlyAndSaveIsANoOp() throws {
    let store = try BindingsStore(userFileURL: nil)
    XCTAssertNoThrow(try store.setPads(Bindings.defaultPads.reversed()))
    XCTAssertEqual(store.bindings.pads, Bindings.defaultPads.reversed(), "in-memory change still applies")
  }

  func testUserFileWinsOverTheBundledDefault() throws {
    var custom = try BindingsLoader.load(from: nil)
    custom.keys["q"] = .sInvert(true)
    try FileManager.default.createDirectory(at: userFile.deletingLastPathComponent(), withIntermediateDirectories: true)
    try JSONEncoder().encode(custom).write(to: userFile)
    let store = try BindingsStore(userFileURL: userFile)
    XCTAssertEqual(store.bindings.keys["q"], .sInvert(true))
  }

  func testABrokenUserFileIsALoudFailureNotASilentFallback() throws {
    try FileManager.default.createDirectory(at: userFile.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("{\"version\": 1}".utf8).write(to: userFile)
    XCTAssertThrowsError(try BindingsStore(userFileURL: userFile))
  }

  func testSetPadsPersistsAndPreservesHandEditedRows() throws {
    var custom = try BindingsLoader.load(from: nil)
    custom.keys["q"] = .sInvert(true)
    try FileManager.default.createDirectory(at: userFile.deletingLastPathComponent(), withIntermediateDirectories: true)
    try JSONEncoder().encode(custom).write(to: userFile)

    let store = try BindingsStore(userFileURL: userFile)
    let swapped = [PadAssignment(x: .slot(.hue), y: .slot(.bias)), Bindings.defaultPads[1]]
    try store.setPads(swapped)

    let reloaded = try BindingsStore(userFileURL: userFile)
    XCTAssertEqual(reloaded.bindings.pads, swapped)
    XCTAssertEqual(reloaded.bindings.keys["q"], .sInvert(true), "the hand-edited key survived the round trip")
    XCTAssertEqual(reloaded.bindings.trackpad, custom.trackpad, "gesture rows untouched, in order")
  }

  func testSaveCreatesTheDirectory() throws {
    let store = try BindingsStore(userFileURL: userFile)
    try store.save()
    XCTAssertTrue(FileManager.default.fileExists(atPath: userFile.path))
  }
}
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter BindingsStoreTests`
Expected: compile failure — `BindingsStore` not found.

- [ ] **Step 3: Create `BindingsStore.swift`**

```swift
import Foundation

/// Where the bindings table actually comes from (design §6.6): the performer's own file under
/// Application Support if there is one, else the bundled `DefaultBindings.json`. "The
/// bindings table is data, not code" (design §5) only means something if the data can be
/// edited without a rebuild — and pad reassignment from the operator panel has to land
/// somewhere that survives a relaunch.
///
/// `save` round-trips the WHOLE `Bindings` struct, so a hand-edited key or gesture row in the
/// user file is preserved when the panel changes a pad. Bindings are read once at bootstrap;
/// hot reload while running is out of scope (design §11).
public final class BindingsStore {
  public private(set) var bindings: Bindings
  private let userFileURL: URL?

  /// `~/Library/Application Support/Feedbax/Bindings.json` — beside `PresetStore`'s `Presets/`.
  public static var defaultUserFileURL: URL {
    let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    return support.appendingPathComponent("Feedbax", isDirectory: true)
      .appendingPathComponent("Bindings.json")
  }

  /// Loads the user file when it exists, else the bundled default. A user file that exists but
  /// fails to decode THROWS — a broken venue file must be a loud failure at startup, not a
  /// silent fallback to defaults the performer didn't ask for. `nil` means bundled only and
  /// makes `save` a no-op (tests, and any caller that wants a read-only table).
  public init(userFileURL: URL?) throws {
    self.userFileURL = userFileURL
    if let userFileURL, FileManager.default.fileExists(atPath: userFileURL.path) {
      bindings = try BindingsLoader.load(from: userFileURL)
    } else {
      bindings = try BindingsLoader.load(from: nil)
    }
  }

  /// For callers that already hold a table (tests).
  public init(bindings: Bindings, userFileURL: URL?) {
    self.bindings = bindings
    self.userFileURL = userFileURL
  }

  /// The one mutation the operator panel makes (design §7). Applies in memory first so a save
  /// failure (read-only disk) still leaves the running instrument on the new assignment.
  public func setPads(_ pads: [PadAssignment]) throws {
    bindings.pads = pads
    try save()
  }

  public func save() throws {
    guard let userFileURL else { return }
    try FileManager.default.createDirectory(at: userFileURL.deletingLastPathComponent(),
                                            withIntermediateDirectories: true)
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    try encoder.encode(bindings).write(to: userFileURL)
  }
}
```

- [ ] **Step 4: Wire `AppBootstrap`**

Add `public let bindingsStore: BindingsStore` as a stored property (and to the private `init`). In `start()` replace `let bindings = try BindingsLoader.load(from: nil)` with:

```swift
    // The performer's own table wins over the bundled default (design §6.6); the same store
    // is what the operator panel writes pad reassignments through.
    let bindingsStore = try BindingsStore(userFileURL: BindingsStore.defaultUserFileURL)
    let bindings = bindingsStore.bindings
```

and give the snapshot its truth reader:

```swift
    let stateSnapshot = ControlStateSnapshot(
      sInvert: { engine.router.sInvert < 0 },
      worldBumpEnabled: { engine.bumpsEnabled.world },
      waveBumpEnabled: { engine.bumpsEnabled.wave },
      kittyBumpEnabled: { engine.bumpsEnabled.kitty },
      wave1Enabled: { engine.waveforms.wave1Enabled },
      wave2Enabled: { engine.waveforms.wave2Enabled },
      layerEnabled: { engine.sticker.layer.enabled },
      // Relative trackpad gestures nudge from HERE (design §5), not from a private accumulator.
      rawValue: { engine.router.rawValue(for: $0) })
```

Pass `bindingsStore: bindingsStore` into the final `AppBootstrap(...)` call. (Task 8 adds `bindingsStore:` to `EngineViewModel`'s init and passes it here.)

- [ ] **Step 5: Run the tests, then the full suite and a build**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app` and `swift build --package-path app`
Expected: green; build succeeds.

- [ ] **Step 6: Commit**

```bash
git add app/Sources/FeedbaxKit/Control/BindingsStore.swift app/Sources/FeedbaxKit/UI/AppBootstrap.swift app/Tests/FeedbaxKitTests/BindingsStoreTests.swift
git commit -m "feat(control): BindingsStore resolves the performer's bindings file over the bundled default"
```

---

### Task 8: `EngineViewModel` — axes, truth mirrors, pads

Spec §7 (model half). The view model speaks `ControlAxis`, mirrors every live axis from router truth each poll (with the optimistic reapply toggles already get), and owns the pad assignments through the store. `OperatorPanel` is updated only as far as compiling requires; its new sections are Task 9.

**Files:**
- Modify: `app/Sources/FeedbaxKit/UI/EngineViewModel.swift`
- Modify: `app/Sources/FeedbaxKit/UI/OperatorPanel.swift` (`slider(_:slot:)` only)
- Modify: `app/Sources/FeedbaxKit/UI/AppBootstrap.swift` (pass `bindingsStore:`)
- Test: `app/Tests/FeedbaxKitTests/EngineViewModelTests.swift`

**Interfaces:**
- Consumes: `ControlAxis`, `ControlWrite(axes:)` (Task 1); `ControlRouter.rawValue(for:)` (Task 2); `Bindings`, `PadAssignment` (Task 4); `BindingsStore` (Task 7).
- Produces:
  - `@Published private(set) var axisValues: [ControlAxis: Double]` (replaces `sliderValues`)
  - `func axis(_ axis: ControlAxis, changedTo value: Double)` (replaces `slider(_:changedTo:)`)
  - `static func range(for axis: ControlAxis) -> ClosedRange<Double>` (replaces the `ControlSlot` overload)
  - `@Published private(set) var bindings: Bindings`; `enum PadAxis { case x, y }`; `func setPadAxis(pad index: Int, _ which: PadAxis, to axis: ControlAxis)`
  - `init(engine: Engine? = nil, presetStore: PresetStore? = nil, bindingsStore: BindingsStore? = nil)`

- [ ] **Step 1: Write the failing tests**

In `EngineViewModelTests`, rename/replace:

```swift
  func testAxisWritesAreAssertedOnceThenDrained() {
    let vm = EngineViewModel()
    vm.axis(.slot(.hue), changedTo: 0.5)
    vm.axis(.layer(.scale), changedTo: -0.25)
    let w = vm.poll(0)!
    XCTAssertEqual(w.slots[.hue]!, 0.5, accuracy: 1e-6)
    XCTAssertEqual(w.layer[.scale]!, -0.25, accuracy: 1e-6, "layer axes go out on the layer channel")
    XCTAssertNil(vm.poll(0), "drained after poll — sliders assert on change only")
  }

  func testAxisRanges() {
    XCTAssertEqual(EngineViewModel.range(for: .slot(.hue)), -1.0...1.0)
    XCTAssertEqual(EngineViewModel.range(for: .slot(.saturation)), 0.0...1.0,
                   "sat is the one unipolar slot (spec §04 §1.2)")
    XCTAssertEqual(EngineViewModel.range(for: .layer(.rotate)), -1.0...1.0)
  }
```

Update `testSliderValuesSeedFromLiveEngineStartupVector` to read `vm.axisValues[.slot(slot)]` and add, inside it, `XCTAssertEqual(vm.axisValues[.layer(.scale)]!, -0.253, accuracy: 1e-6, "layer channel seeds too")`. Update `testRecallPresetSeedsSliderValues` to read `vm.axisValues[.slot(.hue)]` / `[.slot(.saturation)]`. Then add:

```swift
  /// Spec §7: the pad dot and every slider follow the router — a trackpad gesture or a preset
  /// moves them. `poll` refreshes the axis mirrors from truth exactly like the toggle mirrors.
  func testAxisMirrorsFollowRouterTruth() throws {
    let engine = try Engine(context: try MetalContext())
    engine.router.applyStartupDefaults(at: 0)
    let vm = EngineViewModel(engine: engine)
    engine.router.apply(ControlWrite(slots: [.panX: 0.4], layer: [.x: -0.6]), at: 0)   // some other surface
    _ = vm.poll(0)
    XCTAssertEqual(vm.axisValues[.slot(.panX)]!, 0.4, accuracy: 1e-6)
    XCTAssertEqual(vm.axisValues[.layer(.x)]!, -0.6, accuracy: 1e-6)
  }

  /// The same optimistic reapply toggles get: a slider being dragged must not flicker back to
  /// the pre-drag truth for the one tick before the router applies its write.
  func testOwnPendingWriteSurvivesTheTruthRefresh() throws {
    let engine = try Engine(context: try MetalContext())
    engine.router.applyStartupDefaults(at: 0)
    let vm = EngineViewModel(engine: engine)
    vm.axis(.slot(.hue), changedTo: 0.9)
    let w = vm.poll(0)
    XCTAssertEqual(w?.slots[.hue], 0.9)
    XCTAssertEqual(vm.axisValues[.slot(.hue)]!, 0.9, accuracy: 1e-6, "mirror shows the drag, not the stale truth")
  }

  func testPadsDefaultToTheOriginalLayoutWithoutAStore() {
    XCTAssertEqual(EngineViewModel().bindings.pads, Bindings.defaultPads)
  }

  func testSetPadAxisUpdatesTheMirrorAndPersistsThroughTheStore() throws {
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let file = dir.appendingPathComponent("Bindings.json")
    let store = try BindingsStore(userFileURL: file)
    let vm = EngineViewModel(bindingsStore: store)
    vm.setPadAxis(pad: 1, .y, to: .slot(.zoom))
    XCTAssertEqual(vm.bindings.pads[1], PadAssignment(x: .slot(.panX), y: .slot(.zoom)))
    XCTAssertEqual(try BindingsStore(userFileURL: file).bindings.pads[1].y, .slot(.zoom), "written to disk")
    try? FileManager.default.removeItem(at: dir)
  }
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter EngineViewModelTests`
Expected: compile failure — `axis(_:changedTo:)`, `axisValues`, `bindings` not found.

- [ ] **Step 3: Implement in `EngineViewModel.swift`**

Replace the "Slot writes" section (`pendingSlots`, `sliderValues`, `liveSlots`, `sliderMirror`, `slider(_:changedTo:)`, `range(for:)`) with:

```swift
  // MARK: - Axis writes (the 7 live sliders, the 4 layer sliders, and both pads — design §7)

  private var pendingAxes: [ControlAxis: Float] = [:]
  private var pendingToggles: [ToggleEvent] = []

  /// Mirror of every live axis for SwiftUI binding. `axis(_:changedTo:)` is the single entry
  /// point a slider drag, a pad drag, and a test all call, so the displayed value and the
  /// queued write can never disagree; `refreshMirrorsFromTruth` keeps it following the router
  /// so a trackpad gesture or a preset recall moves the widgets too (design §7).
  @Published public private(set) var axisValues: [ControlAxis: Double] = {
    var mirror: [ControlAxis: Double] = [:]
    for axis in ControlAxis.live { mirror[axis] = 0 }
    return mirror
  }()

  private static func axisMirror(from router: ControlRouter) -> [ControlAxis: Double] {
    var mirror: [ControlAxis: Double] = [:]
    for axis in ControlAxis.live { mirror[axis] = Double(router.rawValue(for: axis)) }
    return mirror
  }

  /// Called by a slider or pad drag (or a test). Queues the write for the next `poll` and
  /// updates the mirror immediately — the mirror must not wait for a router round trip, or
  /// the widget would visibly lag the hand dragging it.
  public func axis(_ axis: ControlAxis, changedTo value: Double) {
    axisValues[axis] = value
    pendingAxes[axis] = Float(value)
  }

  /// Every widget's range in one place, from `ControlAxis.rawRange` (design §3.1), so
  /// `OperatorPanel` never hardcodes one.
  public static func range(for axis: ControlAxis) -> ClosedRange<Double> {
    Double(axis.rawRange.lowerBound)...Double(axis.rawRange.upperBound)
  }
```

Keep `maxPanelValue(for:raw:)` as is (it is about the original's slot faders only).

In `poll`, replace the slot handling:

```swift
    refreshMirrorsFromTruth()
    let axes = pendingAxes
    let toggles = pendingToggles
    pendingAxes = [:]
    pendingToggles = []
    applyOptimistically(toggles)
    // Same reasoning as the toggles: the truth read above predates THIS write, so put our own
    // just-queued values back on top or a slider mid-drag flickers to the old value for a tick.
    for (axis, value) in axes { axisValues[axis] = Double(value) }
    if axes.isEmpty && toggles.isEmpty { return nil }
    return ControlWrite(axes: axes, toggles: toggles)
```

In `refreshMirrorsFromTruth`, add before the erase line:

```swift
    for axis in ControlAxis.live {
      let value = Double(engine.router.rawValue(for: axis))
      if axisValues[axis] != value { axisValues[axis] = value }
    }
```

Add a pads section (after the HUD section):

```swift
  // MARK: - Pads (design §7): two absolute XY surfaces, each assignable to any two live axes

  /// Which pad axis a picker changes.
  public enum PadAxis { case x, y }

  /// The live bindings table — pad rows are read from here by the panel and the reference
  /// window. Falls back to `Bindings.fallback` (no keys, no gestures, the default pads) when no
  /// store is injected, i.e. the bare `EngineViewModel()` the unit tests construct.
  @Published public private(set) var bindings: Bindings
  public var bindingsStore: BindingsStore?

  /// Writes through the store so the assignment survives a relaunch (design §6.6). A save
  /// failure is not fatal to the running instrument — the in-memory table still changes.
  public func setPadAxis(pad index: Int, _ which: PadAxis, to axis: ControlAxis) {
    guard bindings.pads.indices.contains(index) else { return }
    var pads = bindings.pads
    switch which {
    case .x: pads[index].x = axis
    case .y: pads[index].y = axis
    }
    if let bindingsStore {
      do { try bindingsStore.setPads(pads) } catch { print("Bindings save failed: \(error)") }
    }
    bindings.pads = pads
  }
```

In `recallPreset`, replace `sliderValues = Self.sliderMirror(from: preset.slots)` with `axisValues = Self.axisMirror(from: engine.router)` (the router has just been seeded by `applyPreset`, layer channel included).

Change `init` to `public init(engine: Engine? = nil, presetStore: PresetStore? = nil, bindingsStore: BindingsStore? = nil)`; set `self.bindingsStore = bindingsStore` and `self.bindings = bindingsStore?.bindings ?? Bindings.fallback` before the `if let engine` block; inside it replace `sliderValues = Self.sliderMirror(from: engine.router.rawSlots)` with `axisValues = Self.axisMirror(from: engine.router)`.

In `OperatorPanel.slider(_:slot:)`, read `vm.axisValues[.slot(slot)] ?? 0`, bind `set: { vm.axis(.slot(slot), changedTo: $0) }`, and use `EngineViewModel.range(for: .slot(slot))`.

In `AppBootstrap.start()`, construct the view model as `EngineViewModel(engine: engine, presetStore: PresetStore(), bindingsStore: bindingsStore)`.

- [ ] **Step 4: Run the tests, then the full suite and a build**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app` and `swift build --package-path app`
Expected: green; build succeeds.

- [ ] **Step 5: Commit**

```bash
git add app/Sources/FeedbaxKit/UI/EngineViewModel.swift app/Sources/FeedbaxKit/UI/OperatorPanel.swift app/Sources/FeedbaxKit/UI/AppBootstrap.swift app/Tests/FeedbaxKitTests/EngineViewModelTests.swift
git commit -m "feat(ui): view model speaks ControlAxis, mirrors every axis from router truth, owns pad assignments"
```

---

### Task 9: `XYPad` view, Surfaces section, layer sliders

Spec §7 (view half). SwiftUI — verified by `swift build` and the Task 12 run pass; the coordinate mapping is pure and unit-tested.

**Files:**
- Create: `app/Sources/FeedbaxKit/UI/XYPad.swift`
- Modify: `app/Sources/FeedbaxKit/UI/OperatorPanel.swift`
- Test: `app/Tests/FeedbaxKitTests/XYPadTests.swift`

**Interfaces:**
- Consumes: `EngineViewModel.axisValues`, `.axis(_:changedTo:)`, `.bindings.pads`, `.setPadAxis`, `EngineViewModel.range(for:)` (Task 8); `ControlAxis.live`, `.displayName` (Task 1).
- Produces: `struct XYPad: View { init(x: Binding<Double>, y: Binding<Double>, xRange:, yRange:) }` with pure `static func unitPoint(_ location: CGPoint, in size: CGSize) -> (x: Double, y: Double)`, `static func value(_ unit: Double, in range: ClosedRange<Double>) -> Double`, `static func unit(_ value: Double, in range: ClosedRange<Double>) -> Double`.

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/XYPadTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

/// The pad's coordinate mapping is pure (design §7): pointer → unit square → axis range, with
/// SwiftUI's downward y flipped so "up on the pad" is +raw (design §4's `y` rule).
final class XYPadTests: XCTestCase {
  func testPointerMapsToTheUnitSquareWithYUp() {
    let size = CGSize(width: 200, height: 100)
    let centre = XYPad.unitPoint(CGPoint(x: 100, y: 50), in: size)
    XCTAssertEqual(centre.x, 0.5, accuracy: 1e-9); XCTAssertEqual(centre.y, 0.5, accuracy: 1e-9)
    let topLeft = XYPad.unitPoint(CGPoint(x: 0, y: 0), in: size)
    XCTAssertEqual(topLeft.x, 0, accuracy: 1e-9); XCTAssertEqual(topLeft.y, 1, accuracy: 1e-9, "top of the pad is y = 1")
    let outside = XYPad.unitPoint(CGPoint(x: 300, y: -20), in: size)
    XCTAssertEqual(outside.x, 1, accuracy: 1e-9); XCTAssertEqual(outside.y, 1, accuracy: 1e-9, "clamped")
  }

  func testUnitAndValueAreInverses() {
    let bipolar = -1.0...1.0, unipolar = 0.0...1.0
    XCTAssertEqual(XYPad.value(0.5, in: bipolar), 0, accuracy: 1e-9)
    XCTAssertEqual(XYPad.value(0, in: bipolar), -1, accuracy: 1e-9)
    XCTAssertEqual(XYPad.value(0.25, in: unipolar), 0.25, accuracy: 1e-9)
    for v in [-1.0, -0.3, 0, 0.7, 1] {
      XCTAssertEqual(XYPad.value(XYPad.unit(v, in: bipolar), in: bipolar), v, accuracy: 1e-9)
    }
  }
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter XYPadTests`
Expected: compile failure — `XYPad` not found.

- [ ] **Step 3: Create `XYPad.swift`**

```swift
import SwiftUI

/// A square, absolute-position XY surface — the port of the original's two Mira multitouch
/// pads (spec §04 §1.2–1.3; design §7). The dot FOLLOWS the bound values, so a trackpad
/// gesture or a preset recall moves it, and a drag SETS them from the pointer position. There
/// is no state inside the view to drift from the router's truth.
public struct XYPad: View {
  @Binding private var x: Double
  @Binding private var y: Double
  private let xRange: ClosedRange<Double>
  private let yRange: ClosedRange<Double>

  public init(x: Binding<Double>, y: Binding<Double>,
              xRange: ClosedRange<Double>, yRange: ClosedRange<Double>) {
    _x = x
    _y = y
    self.xRange = xRange
    self.yRange = yRange
  }

  public var body: some View {
    GeometryReader { geometry in
      let size = geometry.size
      ZStack {
        RoundedRectangle(cornerRadius: 6).fill(Color(nsColor: .controlBackgroundColor))
        RoundedRectangle(cornerRadius: 6).strokeBorder(Color.secondary.opacity(0.4))
        Path { path in
          path.move(to: CGPoint(x: size.width / 2, y: 0))
          path.addLine(to: CGPoint(x: size.width / 2, y: size.height))
          path.move(to: CGPoint(x: 0, y: size.height / 2))
          path.addLine(to: CGPoint(x: size.width, y: size.height / 2))
        }
        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
        Circle()
          .fill(Color.accentColor)
          .frame(width: 14, height: 14)
          .position(dotPosition(in: size))
      }
      .contentShape(Rectangle())
      // `minimumDistance: 0` so a tap-and-hold jumps the dot immediately, like touching a pad.
      .gesture(DragGesture(minimumDistance: 0).onChanged { drag in
        let unit = Self.unitPoint(drag.location, in: size)
        x = Self.value(unit.x, in: xRange)
        y = Self.value(unit.y, in: yRange)
      })
    }
    .aspectRatio(1, contentMode: .fit)
  }

  private func dotPosition(in size: CGSize) -> CGPoint {
    CGPoint(x: Self.unit(x, in: xRange) * size.width,
            y: (1 - Self.unit(y, in: yRange)) * size.height)
  }

  // MARK: - Pure mapping (unit-tested)

  /// Pointer → unit square, clamped, with SwiftUI's downward y flipped so the top of the pad
  /// is y = 1 — "up on the pad" is +raw (design §4's `y` rule).
  static func unitPoint(_ location: CGPoint, in size: CGSize) -> (x: Double, y: Double) {
    let ux = min(1, max(0, location.x / max(size.width, 1)))
    let uy = min(1, max(0, 1 - location.y / max(size.height, 1)))
    return (Double(ux), Double(uy))
  }

  static func value(_ unit: Double, in range: ClosedRange<Double>) -> Double {
    range.lowerBound + unit * (range.upperBound - range.lowerBound)
  }

  static func unit(_ value: Double, in range: ClosedRange<Double>) -> Double {
    (value - range.lowerBound) / (range.upperBound - range.lowerBound)
  }
}
```

- [ ] **Step 4: Add the Surfaces section and the four layer sliders to `OperatorPanel`**

At the top of the right-hand `Form` (before `Section("Layer Source")`):

```swift
        // The original's two Mira pads (spec §04 §1.2–1.3), each assignable to any two live
        // axes; defaults come from the bindings table (design §7).
        Section("Surfaces") {
          HStack(alignment: .top, spacing: 16) {
            ForEach(Array(vm.bindings.pads.indices), id: \.self) { index in
              padColumn(index)
            }
          }
        }
```

Inside `Section("Layer Source")`, after the `Picker("Mode", ...)`:

```swift
          ForEach(Self.layerSliderLabels, id: \.0) { axis, label in
            slider(label, axis: .layer(axis))
          }
```

Add beside `sliderLabels`:

```swift
  /// The image layer's four live axes (design §4) — reachable here even when neither pad is
  /// assigned to them. Upper-case to sit beside the original's shader labels.
  private static let layerSliderLabels: [(LayerAxis, String)] = [
    (.x, "IMAGE X"), (.y, "IMAGE Y"), (.scale, "IMAGE SCALE"), (.rotate, "IMAGE ROTATE"),
  ]
```

Generalise the slider helper. Replace `slider(_:slot:)` with:

```swift
  private func slider(_ label: String, slot: ControlSlot) -> some View {
    slider(label, axis: .slot(slot))
  }

  private func slider(_ label: String, axis: ControlAxis) -> some View {
    let raw = vm.axisValues[axis] ?? 0
    // Slot faders show the original panel's reading (EngineViewModel.maxPanelValue); layer
    // axes had no Max fader, so they show the raw value.
    let readout: Double
    if case .slot(let slot) = axis { readout = EngineViewModel.maxPanelValue(for: slot, raw: raw) } else { readout = raw }
    return LabeledContent(label) {
      HStack(spacing: 8) {
        Slider(value: axisBinding(axis), in: EngineViewModel.range(for: axis))
        Text(String(format: "%.2f", readout))
          .monospacedDigit()
          .foregroundStyle(.secondary)
          .frame(width: 44, alignment: .trailing)
      }
    }
  }

  private func axisBinding(_ axis: ControlAxis) -> Binding<Double> {
    Binding(get: { vm.axisValues[axis] ?? 0 }, set: { vm.axis(axis, changedTo: $0) })
  }

  private func padColumn(_ index: Int) -> some View {
    let pad = vm.bindings.pads[index]
    return VStack(spacing: 6) {
      XYPad(x: axisBinding(pad.x), y: axisBinding(pad.y),
            xRange: EngineViewModel.range(for: pad.x), yRange: EngineViewModel.range(for: pad.y))
        .frame(width: 160, height: 160)
      axisPicker("X", selection: pad.x) { vm.setPadAxis(pad: index, .x, to: $0) }
      axisPicker("Y", selection: pad.y) { vm.setPadAxis(pad: index, .y, to: $0) }
    }
  }

  private func axisPicker(_ label: String, selection: ControlAxis,
                          onChange: @escaping (ControlAxis) -> Void) -> some View {
    Picker(label, selection: Binding(get: { selection }, set: onChange)) {
      ForEach(ControlAxis.live, id: \.self) { axis in
        Text(axis.displayName).tag(axis)
      }
    }
    .frame(width: 160)
  }
```

Widen the Controls window's default size in `FeedbaxScenes` from `720×800` to `760×900` so two 160-pt pads plus pickers fit without scrolling.

- [ ] **Step 5: Run the tests, the full suite, and build**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app` and `swift build --package-path app`
Expected: green; build succeeds. Then a quick visual check: `swift run --package-path app feedbax-dev` — two pads appear at the top of the right column, dragging a pad moves the matching sliders, dragging a slider moves the dot. Quit with ⌘Q.

- [ ] **Step 6: Commit**

```bash
git add app/Sources/FeedbaxKit/UI/XYPad.swift app/Sources/FeedbaxKit/UI/OperatorPanel.swift app/Sources/FeedbaxKit/UI/FeedbaxScenes.swift app/Tests/FeedbaxKitTests/XYPadTests.swift
git commit -m "feat(ui): two assignable XY pads and image-layer sliders in the operator panel"
```

---

### Task 10: `ControlReference` model and the gamepad's reference table

Spec §8.1. A pure data model built from `Bindings` — the help content cannot drift from what the keys do because it *is* the keys.

**Files:**
- Create: `app/Sources/FeedbaxKit/Control/ControlReference.swift`
- Modify: `app/Sources/FeedbaxKit/Control/GamepadSurface.swift` (add `static let reference`)
- Test: `app/Tests/FeedbaxKitTests/ControlReferenceTests.swift`

**Interfaces:**
- Consumes: `Bindings`, `TrackpadBinding`, `TrackpadGesture.displayName`, `GestureModifier.symbol`, `PadAssignment` (Task 4); `ControlAxis.displayName`, `ToggleEvent.displayName`/`.isOneShot` (Task 1).
- Produces:
  - `struct ControlReference: Equatable { struct Row { input, modifiers, action, kind: String }; struct Section { title: String; rows: [Row] }; var sections: [Section]; static let fixedKeyRows: [Row]; static func build(from bindings: Bindings, gamepad: [Row] = GamepadSurface.reference) -> ControlReference }`
  - `GamepadSurface.reference: [ControlReference.Row]`

- [ ] **Step 1: Write the failing tests**

`app/Tests/FeedbaxKitTests/ControlReferenceTests.swift`:

```swift
import XCTest
@testable import FeedbaxKit

/// Spec §8.1: the reference is generated from the bindings table plus a fixed list of the keys
/// handled outside it, so it cannot drift from what the keys actually do.
final class ControlReferenceTests: XCTestCase {
  private func section(_ title: String, in reference: ControlReference) -> ControlReference.Section {
    reference.sections.first { $0.title == title }!
  }

  func testSectionsInOrder() throws {
    let r = ControlReference.build(from: try BindingsLoader.load(from: nil))
    XCTAssertEqual(r.sections.map(\.title), ["Keyboard", "Trackpad", "Pads", "Gamepad"])
  }

  func testEveryBoundKeyAppearsExactlyOnceAfterTheFixedKeys() throws {
    let bindings = try BindingsLoader.load(from: nil)
    let keyboard = section("Keyboard", in: ControlReference.build(from: bindings))
    let fixed = Array(keyboard.rows.prefix(ControlReference.fixedKeyRows.count))
    XCTAssertEqual(fixed, ControlReference.fixedKeyRows)
    XCTAssertEqual(fixed.map(\.input), ["Esc", "[", "]", "?"])
    let bound = keyboard.rows.dropFirst(fixed.count)
    XCTAssertEqual(bound.map(\.input), bindings.keys.keys.sorted(), "sorted by key, one row each")
    let iRow = bound.first { $0.input == "i" }!
    XCTAssertEqual(iRow.action, "SInvert"); XCTAssertEqual(iRow.kind, "toggle")
    let fRow = bound.first { $0.input == "f" }!
    XCTAssertEqual(fRow.kind, "one-shot")
  }

  func testTrackpadRowsFollowTheTableInOrderWithModifierSymbols() throws {
    let bindings = try BindingsLoader.load(from: nil)
    let rows = section("Trackpad", in: ControlReference.build(from: bindings)).rows
    XCTAssertEqual(rows.count, bindings.trackpad.count)
    XCTAssertEqual(rows[0], ControlReference.Row(input: "Drag (one finger)", modifiers: "", action: "Pan X / Pan Y", kind: "axes"))
    XCTAssertEqual(rows[1].modifiers, "⌥"); XCTAssertEqual(rows[1].action, "Image X / Image Y")
    XCTAssertEqual(rows[2].modifiers, "⇧"); XCTAssertEqual(rows[2].action, "Hue shift / Brightness")
    let twist = rows.first { $0.input == "Twist" && $0.modifiers.isEmpty }!
    XCTAssertEqual(twist.action, "Rotate"); XCTAssertEqual(twist.kind, "axis")
  }

  func testPadRowsReflectTheLiveAssignment() throws {
    var bindings = try BindingsLoader.load(from: nil)
    XCTAssertEqual(section("Pads", in: ControlReference.build(from: bindings)).rows.map(\.action),
                   ["Image X / Image Y", "Pan X / Pan Y"])
    bindings.pads[0] = PadAssignment(x: .slot(.hue), y: .slot(.zoom))
    XCTAssertEqual(section("Pads", in: ControlReference.build(from: bindings)).rows[0].action, "Hue shift / Zoom")
    XCTAssertEqual(section("Pads", in: ControlReference.build(from: bindings)).rows[0].input, "Pad 1")
  }

  func testGamepadRowsPassThroughAndCoverEveryInputPollReads() throws {
    let rows = section("Gamepad", in: ControlReference.build(from: try BindingsLoader.load(from: nil))).rows
    XCTAssertEqual(rows, GamepadSurface.reference)
    let inputs = rows.map(\.input).joined(separator: " ")
    for name in ["Left stick", "Right stick", "Right trigger", "Left trigger", "D-pad", "A", "B", "X", "Y", "Menu"] {
      XCTAssertTrue(inputs.contains(name), "\(name) is read by GamepadSurface.poll but has no reference row")
    }
    XCTAssertEqual(rows.first { $0.input == "Left trigger" }?.action, "Rotate", "uses ControlAxis.displayName")
  }
}
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter ControlReferenceTests`
Expected: compile failure — `ControlReference` not found.

- [ ] **Step 3: Create `ControlReference.swift`**

```swift
import Foundation

/// The Controls Reference window's content as plain data (design §8.1), built from the live
/// `Bindings` plus a fixed list of the keys handled outside the table. Generated, not
/// hand-written: the help can't drift from what the keys do because it IS the keys.
/// `ControlsReferenceView` renders it; nothing in here imports SwiftUI.
public struct ControlReference: Equatable {
  public struct Row: Equatable {
    public var input: String       // "i", "Drag (one finger)", "Left stick", "Pad 1"
    public var modifiers: String   // "", "⌥", "⇧"
    public var action: String      // "SInvert", "Pan X / Pan Y"
    public var kind: String        // "toggle", "one-shot", "step", "axis", "axes"

    public init(input: String, modifiers: String, action: String, kind: String) {
      self.input = input
      self.modifiers = modifiers
      self.action = action
      self.kind = kind
    }
  }

  public struct Section: Equatable {
    public var title: String
    public var rows: [Row]

    public init(title: String, rows: [Row]) {
      self.title = title
      self.rows = rows
    }
  }

  public var sections: [Section]

  /// Keys handled OUTSIDE the bindings table — `PerformerInputMonitor` (Escape, `?`) and
  /// `KeyboardTrackpadSurface` (`[`/`]`, hardcoded because `ToggleEvent` has no signed-step
  /// case). Listed here by hand because that is where they live; keep in step with those two
  /// files.
  public static let fixedKeyRows: [Row] = [
    Row(input: "Esc", modifiers: "", action: "Toggle fullscreen", kind: "one-shot"),
    Row(input: "[", modifiers: "", action: "Erase −0.05", kind: "step"),
    Row(input: "]", modifiers: "", action: "Erase +0.05", kind: "step"),
    Row(input: "?", modifiers: "", action: "Show this window", kind: "one-shot"),
  ]

  public static func build(from bindings: Bindings,
                           gamepad: [Row] = GamepadSurface.reference) -> ControlReference {
    let keyRows = bindings.keys.sorted { $0.key < $1.key }.map { key, event in
      Row(input: key, modifiers: "", action: event.displayName, kind: event.isOneShot ? "one-shot" : "toggle")
    }
    let trackpadRows = bindings.trackpad.map { binding -> Row in
      let modifiers = binding.modifiers.sorted { $0.rawValue < $1.rawValue }.map(\.symbol).joined()
      switch binding.target {
      case .xy(let x, let y):
        return Row(input: binding.gesture.displayName, modifiers: modifiers,
                   action: "\(x.axis.displayName) / \(y.axis.displayName)", kind: "axes")
      case .single(let axis):
        return Row(input: binding.gesture.displayName, modifiers: modifiers,
                   action: axis.axis.displayName, kind: "axis")
      }
    }
    let padRows = bindings.pads.enumerated().map { index, pad in
      Row(input: "Pad \(index + 1)", modifiers: "",
          action: "\(pad.x.displayName) / \(pad.y.displayName)", kind: "axes")
    }
    return ControlReference(sections: [
      Section(title: "Keyboard", rows: fixedKeyRows + keyRows),
      Section(title: "Trackpad", rows: trackpadRows),
      Section(title: "Pads", rows: padRows),
      Section(title: "Gamepad", rows: gamepad),
    ])
  }
}
```

- [ ] **Step 4: Add the gamepad's reference table**

In `GamepadSurface`, after `stateProvider`:

```swift
  /// The mapping in this type's doc comment, as reference rows for the Controls Reference
  /// window (design §8.1). Gamepad bindings stay code-defined (design §5 deferred moving them
  /// to JSON), so this table lives beside the code it describes; `ControlReferenceTests`
  /// checks it names every input `poll` reads. Axis names come from `ControlAxis.displayName`
  /// so a rename there flows here.
  public static let reference: [ControlReference.Row] = [
    .init(input: "Left stick", modifiers: "",
          action: "\(ControlAxis.slot(.panX).displayName) / \(ControlAxis.slot(.panY).displayName)", kind: "axes"),
    .init(input: "Right stick", modifiers: "",
          action: "\(ControlAxis.slot(.hue).displayName) / \(ControlAxis.slot(.bias).displayName)", kind: "axes"),
    .init(input: "Right trigger", modifiers: "", action: ControlAxis.slot(.zoom).displayName, kind: "axis"),
    .init(input: "Left trigger", modifiers: "", action: ControlAxis.slot(.theta).displayName, kind: "axis"),
    .init(input: "D-pad up / down", modifiers: "", action: "Erase +0.05 / −0.05", kind: "step"),
    .init(input: "D-pad right / left", modifiers: "",
          action: "\(ControlAxis.slot(.saturation).displayName) +0.1 / −0.1", kind: "step"),
    .init(input: "A", modifiers: "", action: ToggleEvent.sInvert(true).displayName, kind: "toggle"),
    .init(input: "B", modifiers: "", action: ToggleEvent.layerEnabled(true).displayName, kind: "toggle"),
    .init(input: "X", modifiers: "", action: ToggleEvent.wave1Enabled(true).displayName, kind: "toggle"),
    .init(input: "Y", modifiers: "", action: ToggleEvent.wave2Enabled(true).displayName, kind: "toggle"),
    .init(input: "Menu", modifiers: "", action: ToggleEvent.fullscreen.displayName, kind: "one-shot"),
  ]
```

- [ ] **Step 5: Run the tests, then the full suite**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app`
Expected: green.

- [ ] **Step 6: Commit**

```bash
git add app/Sources/FeedbaxKit/Control/ControlReference.swift app/Sources/FeedbaxKit/Control/GamepadSurface.swift app/Tests/FeedbaxKitTests/ControlReferenceTests.swift
git commit -m "feat(control): ControlReference model generated from the bindings table"
```

---

### Task 11: Controls Reference window, Help menu, `?` receivers

Spec §8.2–8.3. A third `Window` scene, the app's first custom menu item, and the notification receivers that turn the monitor's `?` into an open window.

**Files:**
- Create: `app/Sources/FeedbaxKit/UI/ControlsReferenceView.swift`
- Modify: `app/Sources/FeedbaxKit/UI/FeedbaxScenes.swift`
- Test: `app/Tests/FeedbaxKitTests/AppBootstrapTests.swift` (window ids)

**Interfaces:**
- Consumes: `ControlReference.build(from:)` (Task 10); `EngineViewModel.bindings` (Task 8); `Notification.Name.feedbaxShowControlsReference` (Task 6).
- Produces: `FeedbaxWindow.referenceID = "reference"`; `struct ControlsReferenceView: View { init(vm: EngineViewModel) }`.

- [ ] **Step 1: Write the failing test**

In `AppBootstrapTests.testWindowIdentifiersAreDistinctAndStable`, add:

```swift
    XCTAssertEqual(FeedbaxWindow.referenceID, "reference")
    XCTAssertEqual(Set([FeedbaxWindow.outputID, FeedbaxWindow.controlsID, FeedbaxWindow.referenceID]).count, 3)
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter AppBootstrapTests`
Expected: compile failure — `referenceID` not found.

- [ ] **Step 3: Create `ControlsReferenceView.swift`**

```swift
import SwiftUI

/// The Controls Reference window's content (design §8.2): `ControlReference`'s sections as
/// read-only tables. Observes the view model so a pad reassignment shows up immediately —
/// `vm.bindings` is `@Published`.
public struct ControlsReferenceView: View {
  @ObservedObject private var vm: EngineViewModel

  public init(vm: EngineViewModel) {
    self.vm = vm
  }

  public var body: some View {
    let reference = ControlReference.build(from: vm.bindings)
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        ForEach(reference.sections, id: \.title) { section in
          VStack(alignment: .leading, spacing: 6) {
            Text(section.title).font(.headline)
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 4) {
              ForEach(Array(section.rows.enumerated()), id: \.offset) { _, row in
                GridRow {
                  Text(row.modifiers + row.input)
                    .font(.system(.body, design: .monospaced))
                  Text(row.action)
                  Text(row.kind).foregroundStyle(.secondary)
                }
              }
            }
          }
        }
        Text("Trackpad gestures act on the Output window. Option targets the image layer; Shift targets colour.")
          .font(.footnote)
          .foregroundStyle(.secondary)
      }
      .padding(20)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}
```

- [ ] **Step 4: Add the window, the Help menu, and the `?` receivers in `FeedbaxScenes.swift`**

Add `public static let referenceID = "reference"` to `FeedbaxWindow`.

Add two private types above `FeedbaxScenes`:

```swift
/// The app's first custom menu item (design §8.3): Help › Feedbax Controls, ⌘? — the
/// platform's standard Help shortcut. `CommandGroup(replacing: .help)` swaps out SwiftUI's
/// default (and inert) "<App> Help" entry. A bare `?` key equivalent would beat text fields
/// to the keystroke, so the unmodified `?` goes through `PerformerInputMonitor` instead.
private struct ControlsReferenceCommands: Commands {
  var body: some Commands {
    CommandGroup(replacing: .help) {
      ShowControlsReferenceButton()
    }
  }
}

/// Split out because `openWindow` is an environment value, and environment values are only
/// readable from a `View` — `Commands` bodies can't read them directly.
private struct ShowControlsReferenceButton: View {
  @Environment(\.openWindow) private var openWindow

  var body: some View {
    Button("Feedbax Controls") { openWindow(id: FeedbaxWindow.referenceID) }
      .keyboardShortcut("?", modifiers: .command)
  }
}
```

In BOTH `OutputWindowContent` and `ControlsWindowContent`, add after `.onAppear { ... }`:

```swift
      // `?` from `PerformerInputMonitor` (design §8.3). Both windows listen; `openWindow` on
      // an already-open window just focuses it, so two receivers can't fight.
      .onReceive(NotificationCenter.default.publisher(for: .feedbaxShowControlsReference)) { _ in
        openWindow(id: FeedbaxWindow.referenceID)
      }
```

In `FeedbaxScenes.body`, attach the commands to the Output scene and add the third window:

```swift
    Window("Output", id: FeedbaxWindow.outputID) {
      OutputWindowContent(host: bootstrap.host)
    }
    .defaultSize(width: 1280, height: 720)
    .commands { ControlsReferenceCommands() }

    Window("Controls", id: FeedbaxWindow.controlsID) {
      ControlsWindowContent(viewModel: bootstrap.viewModel)
    }
    .defaultSize(width: 760, height: 900)

    // The reference gets a Window-menu entry and frame restoration for free, like the other
    // two (design §8.2).
    Window("Controls Reference", id: FeedbaxWindow.referenceID) {
      ControlsReferenceView(vm: bootstrap.viewModel)
        .frame(minWidth: 420, minHeight: 360)
    }
    .defaultSize(width: 560, height: 640)
```

Update the type doc comment: three `Window` scenes.

- [ ] **Step 5: Run the tests, the full suite, and build**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app` and `swift build --package-path app`
Expected: green; build succeeds. Quick check with `swift run --package-path app feedbax-dev`: Help menu shows "Feedbax Controls" (⌘?); pressing `?` with the Output window frontmost opens the reference; the Window menu lists it. Quit with ⌘Q.

- [ ] **Step 6: Commit**

```bash
git add app/Sources/FeedbaxKit/UI/ControlsReferenceView.swift app/Sources/FeedbaxKit/UI/FeedbaxScenes.swift app/Tests/FeedbaxKitTests/AppBootstrapTests.swift
git commit -m "feat(ui): Controls Reference window, Help menu item, and ? key"
```

---

### Task 12: README, spec status, and the run pass (gesture signs)

Spec §6.2 ("verified by hand in the `swift run` pass"), §12. The only part of this work that cannot be unit-tested is whether each gesture moves the picture the way the fingers moved. This task does that check, fixes any sign in the bindings JSON (never in code), and writes the user-facing docs.

**Files:**
- Modify: `README.md` — add a new `### Controls (Swift port)` subsection immediately after the existing `### Controls Overview` subsection (which describes the original Max patch; leave it untouched)
- Modify: `app/Sources/FeedbaxKit/Control/DefaultBindings.json` (sensitivity signs only, if needed)
- Modify: `docs/superpowers/specs/2026-08-26-controls-gestures-and-help-design.md` (status line + §12 outcomes)

- [ ] **Step 1: Run the instrument and check every gesture**

Announce in chat that a GUI window is about to open, then run `swift run --package-path app feedbax-dev`. Enable the layer (`p`) so the sticker is visible. With the Output window frontmost, check each row and note the observed direction:

| Gesture | Expect |
|---|---|
| Two-finger scroll right / drag right | field pans right |
| Two-finger scroll up / drag up | field pans up |
| Pinch out | field zooms in (zoom raw increases) |
| Twist counter-clockwise | field rotates counter-clockwise |
| Option-drag right / up | image moves right / up |
| Option-pinch out | image grows |
| Option-twist counter-clockwise | image rotates counter-clockwise |
| Shift-drag right | hue shifts forward (HUE-SHIFT slider rises) |
| Shift-drag up | BRIGHTNESS slider rises |
| Shift-pinch out | SATURATION slider rises |
| Twist while pinching a little | rotate moves, ZOOM slider stays put (lock) |
| `?` | Controls Reference opens; `Help › Feedbax Controls` (⌘?) does the same |
| Pad 1 drag | sticker moves; IMAGE X/Y sliders follow |
| Pad 2 picker → Hue shift / Zoom, relaunch | assignment persists (`~/Library/Application Support/Feedbax/Bindings.json` exists) |

- [ ] **Step 2: Fix any inverted direction in `DefaultBindings.json`**

Flip the `sensitivity` sign (`1.0` → `-1.0`) on the offending row's axis. Do not touch code or the monitor's normalisation. If a direction is inverted for BOTH the plain and the Option row of the same gesture, the fix is still per-row — the two rows drive different maps (design §4 vs `ControlRouter.mappedTarget`), and they may legitimately differ. Re-run `swift test` (`BindingsTests.testBundledDefaultIsVersion2WithTheDesignTable` compares whole `TrackpadAxis` values including sensitivity — update its expected sensitivity for any flipped row).

- [ ] **Step 3: Write the README controls section**

Replace or add the port's controls section with the design §6.1 table plus keys, pads, gamepad, and how to find the reference:

```markdown
### Controls (Swift port)

Press `?` (or Help › Feedbax Controls, ⌘?) inside the app for the live reference — it is generated from the bindings table, so it is always current. Summary:

**Keys:** `i` SInvert · `w` world bump · `a` wave bump · `k` kitty bump · `p` layer enable · `1`/`2` wave 1/2 · `f`/Esc fullscreen · `s` still capture · `[`/`]` erase −/+.

**Trackpad (over the Output window):** unmodified gestures drive the feedback field, **Option** drives the image layer, **Shift** drives colour.

| Gesture | — | Option | Shift |
|---|---|---|---|
| Drag (1 finger) / Scroll (2) | Pan X / Pan Y | Image X / Image Y | Hue shift / Brightness (drag only) |
| Pinch | Zoom | Image scale | Saturation |
| Twist | Rotate | Image rotate | — |

**Pads:** two XY pads in the Controls window, each assignable to any two axes (default: pad 1 = image X/Y, pad 2 = pan X/Y — the original's two Mira pads). Assignments persist in `~/Library/Application Support/Feedbax/Bindings.json`, which also holds the key and gesture tables and can be hand-edited (version 2).

**Gamepad:** left stick pan, right stick hue/brightness, triggers zoom/rotate, d-pad erase and saturation, A/B/X/Y SInvert/layer/wave 1/wave 2, Menu fullscreen.
```

- [ ] **Step 4: Close out the spec**

In the spec, change `**Status:** draft for review` to `**Status:** implemented 2026-08-26 (plan: docs/superpowers/plans/2026-08-26-controls-gestures-and-help.md)` and, under §12, record what the run pass found (which rows were flipped, if any; whether the lock thresholds felt right).

- [ ] **Step 5: Full suite one last time**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app`
Expected: green.

- [ ] **Step 6: Commit**

```bash
git add README.md app/Sources/FeedbaxKit/Control/DefaultBindings.json docs/superpowers/specs/2026-08-26-controls-gestures-and-help-design.md
git commit -m "docs: controls reference in README; record run-pass gesture signs and close the spec"
```

---

## Self-Review

**Spec coverage.** §3 → Task 1. §4 → Tasks 2–3 (router channel, engine application, preset recall, startup 0.747). §5 → Task 4 (`rawValue`, `pendingDeltas`) + Task 7 (bootstrap wires the reader). §6.1/§6.5 → Task 4 (table, JSON, exact-match lookup, arity/duplicate/version rules). §6.2 → Task 6 (normalisation, negative sensitivity honoured by Task 4's `nudge`), signs → Task 12. §6.3 → Task 5. §6.4 → Task 4. §6.6 → Task 7. §7 → Tasks 8–9 (pads, pickers, absolute drag, dot follows truth, layer sliders, persistence). §8.1 → Task 10. §8.2–8.3 → Task 11 (window, ⌘? menu, `?` via Task 6's notification). §9 → each task's tests; the view-only pieces are covered by build + Task 12's pass, as the spec allows. §10 file map → File Structure above. §11/§12 → nothing to build; §12 outcomes recorded in Task 12.

**Placeholders.** None: every code step has its code; the README text is written out; the run-pass table lists concrete expectations.

**Type consistency.** `ControlAxis.live`/`rawRange`/`clamped`/`displayName`/`marker` (Task 1) used in Tasks 4, 8, 9, 10. `ControlWrite(axes:toggles:eraseStep:)` (Task 1) used in Tasks 4, 8. `ControlStateSnapshot.rawValue` + `constant(_:rawValue:)` (Task 1) used in Tasks 4, 7. `ControlRouter.rawLayer`/`layerTransform`/`rawLayer(from:)`/`rawValue(for:)`/`mappedLayerTarget`/`layerTransform(from:)`/`startupLayerVector` (Task 2) used in Tasks 3, 7, 8. `GestureEvent(gesture:modifiers:phase:dx:dy:)` and `(…delta:)` (Task 4) used in Tasks 5, 6. `KeyboardTrackpadSurface.handles(_:modifiers:)`/`gesture(_:)` (Task 4) used in Task 6. `GestureLock.admit` (Task 5) used in Task 5's surface edit. `Bindings.trackpadBinding(for:modifiers:)`/`defaultPads`/`fallback`/`pads` (Task 4) used in Tasks 7, 8, 10. `BindingsStore(userFileURL:)`/`setPads`/`bindings` (Task 7) used in Task 8. `EngineViewModel.axisValues`/`axis(_:changedTo:)`/`range(for: ControlAxis)`/`bindings`/`setPadAxis(pad:_:to:)`/`PadAxis` (Task 8) used in Tasks 9, 11. `XYPad.unitPoint`/`value`/`unit` (Task 9) tested in Task 9. `ControlReference.build(from:gamepad:)`/`fixedKeyRows`/`Row`/`Section` (Task 10) used in Tasks 10, 11. `GamepadSurface.reference` (Task 10) used in Task 10's default argument. `FeedbaxWindow.referenceID` (Task 11) used in Task 11. `Notification.Name.feedbaxShowControlsReference` (Task 6) used in Task 11.
