import Foundation
import AppKit
import QuartzCore
import simd

/// The operator's SwiftUI-facing model (Task 20; design §5's `ControlSurface` section). The
/// load-bearing design choice: **this is a `ControlSurface` like `KeyboardTrackpadSurface` or
/// `GamepadSurface`, not a privileged back door into `Engine`.** A slider move calls `slider
/// (_:changedTo:)`, which queues a slot write exactly the way a key press queues one in
/// `KeyboardTrackpadSurface` — `ControlRouter.tick` polls this object in `surfaces` order and
/// arbitrates last-write-wins with every other surface, same as any of them (spec §04 §1.2).
/// `OperatorPanel` (the SwiftUI view) never touches `Engine`/`ControlRouter` directly; it only
/// ever calls methods on this object.
///
/// Two kinds of state cross this boundary, matching the two kinds of thing the panel does:
/// - **Slot writes and toggles** go through `poll`, queued and drained exactly once — see that
///   method's own comment for why this differs from `KeyboardTrackpadSurface`'s "keep asserting
///   while held" accumulators.
/// - **Everything else the panel controls is not part of the 9-slot vector at all** — erase
///   (a direct `ControlRouter.eraseControl` write, spec §01 §2's "never ramped, never a slot"),
///   layer mode, sticker selection, movie loading, resolution/rate, and presets. Those go
///   straight to `Engine`/`PresetStore` because there is no `ToggleEvent`/`ControlSlot` for them
///   to ride — `ControlWrite` only carries what a *performer gesture* can assert mid-show; a
///   file picker or a resolution change is a setup action, not a slot.
///
/// `engine`/`presetStore` are optional, defaulted to `nil`, specifically so `EngineViewModel()`
/// — the bare initializer the unit tests use — builds a fully testable `ControlSurface` with no
/// live `Engine` at all (constructing a real `Engine` needs a Metal device, which a headless
/// test run may not have). Every method that needs live engine state degrades to a harmless
/// no-op when `engine`/`presetStore` is nil; only `feedbax-dev/main.swift`'s real wiring ever
/// passes them in.
public final class EngineViewModel: ObservableObject, ControlSurface {
  public let id = "operator-ui"

  // `weak`, not a strong reference: `Engine.router.surfaces` holds THIS object strongly (once
  // `feedbax-dev/main.swift` registers it, same as keyboard/gamepad), so a strong `engine` here
  // would close a retain cycle (Engine → router → surfaces → EngineViewModel → engine → Engine)
  // that only the process exiting would ever break. `main.swift`'s own top-level `engine`
  // global is what actually keeps `Engine` alive for the app's lifetime; this property only
  // ever needs to reach it, never own it.
  public weak var engine: Engine?
  public var presetStore: PresetStore?

  // MARK: - Slot writes (the 7 live sliders; `.scalebright`/`.nc` are dead — ControlVector.swift)

  private var pendingSlots: [ControlSlot: Float] = [:]
  private var pendingToggles: [ToggleEvent] = []

  /// Mirrors `pendingSlots` for SwiftUI binding — `slider(_:changedTo:)` is the single entry
  /// point both a real drag gesture AND a `Binding`'s `set` closure call, so the displayed
  /// value and the queued write can never disagree (the brief's "`@Published` mirrors ... call
  /// the same entry points").
  @Published public private(set) var sliderValues: [ControlSlot: Double] = [
    .hue: 0, .bias: 0, .panX: 0, .panY: 0, .zoom: 0, .theta: 0, .saturation: 0,
  ]

  /// Called by a slider drag (or a test). Queues the write for the next `poll` and updates the
  /// mirror immediately — the mirror must not wait for a router round trip, or the slider
  /// would visibly lag the hand dragging it.
  public func slider(_ slot: ControlSlot, changedTo value: Double) {
    sliderValues[slot] = value
    pendingSlots[slot] = Float(value)
  }

  /// Centralizes every slider's range (the brief's step 3) so `OperatorPanel` never hardcodes
  /// one: `.saturation` is the one unipolar slot (spec §04 §1.2's row 8 — "pass-through 0..1,
  /// unipolar slider"); everything else the original wires as a bipolar `slider[...]` widget is
  /// −1...1 (spec §04 §1.2 rows 0/1/5/6, plus panX/panY's touch-driven −1..1 range, row 3/4).
  /// Dead slots (`.scalebright`/`.nc`) get a range too, for an exhaustive switch, even though
  /// `OperatorPanel` never surfaces a control for them.
  public static func range(for slot: ControlSlot) -> ClosedRange<Double> {
    switch slot {
    case .saturation: return 0.0...1.0
    default: return -1.0...1.0
    }
  }

  // MARK: - Toggles (spec §04 §1's toggle table; queued exactly like a slot write)

  @Published public private(set) var sInvertOn = false
  @Published public private(set) var layerOn = false
  @Published public private(set) var wave1On = true    // PresetToggles' own default (Presets.swift)
  @Published public private(set) var wave2On = false
  @Published public private(set) var worldBumpOn = false
  @Published public private(set) var waveBumpOn = false
  @Published public private(set) var kittyBumpOn = false

  public func setSInvert(_ on: Bool) { sInvertOn = on; pendingToggles.append(.sInvert(on)) }
  public func setLayerEnabled(_ on: Bool) { layerOn = on; pendingToggles.append(.layerEnabled(on)) }
  public func setWave1Enabled(_ on: Bool) { wave1On = on; pendingToggles.append(.wave1Enabled(on)) }
  public func setWave2Enabled(_ on: Bool) { wave2On = on; pendingToggles.append(.wave2Enabled(on)) }
  public func setWorldBumpEnabled(_ on: Bool) {
    worldBumpOn = on; pendingToggles.append(.worldBumpEnabled(on))
  }
  public func setWaveBumpEnabled(_ on: Bool) {
    waveBumpOn = on; pendingToggles.append(.waveBumpEnabled(on))
  }
  public func setKittyBumpEnabled(_ on: Bool) {
    kittyBumpOn = on; pendingToggles.append(.kittyBumpEnabled(on))
  }

  // MARK: - ControlSurface

  /// Drains the queue built up since the last call — unlike `KeyboardTrackpadSurface`'s held
  /// accumulators (which keep reasserting a slot's position every frame while it's nonzero),
  /// a slider's write is a one-shot assertion: the performer moved it to X, the router should
  /// glide there, and nothing needs re-asserting next frame just because a fader sits still
  /// (the brief's own test name: "asserted once then drained"). Returning `nil` once nothing is
  /// queued lets `ControlRouter`'s last-write-wins arbitration fall through to whatever the
  /// previous frame's raw slots already hold, same contract every other surface honors.
  public func poll(_ time: TimeInterval) -> ControlWrite? {
    let slots = pendingSlots
    let toggles = pendingToggles
    pendingSlots = [:]
    pendingToggles = []
    if slots.isEmpty && toggles.isEmpty { return nil }
    return ControlWrite(slots: slots, toggles: toggles)
  }

  // MARK: - Erase (spec §01 §2: outside the 9-slot vector, never ramped, never a `ControlWrite`
  // field for this surface — a slider position is an absolute "here is where TRANSPARANCY sits
  // now," not `KeyboardTrackpadSurface`'s relative `[`/`]` nudge, so it writes `eraseControl`
  // directly rather than round-tripping through `ControlWrite.eraseStep`)

  @Published public private(set) var eraseValue: Double = 1.0   // startup default, spec §04 §1.4

  public func setErase(_ value: Double) {
    let clamped = min(1, max(0, value))
    eraseValue = clamped
    engine?.router.eraseControl = Float(clamped)
  }

  // MARK: - Layer mode (the either-or picture/movie switch, design §5's `LayerMode`)

  @Published public private(set) var layerMode: LayerMode = .sticker

  public func setLayerMode(_ mode: LayerMode) {
    layerMode = mode
    engine?.layerMode = mode
  }

  // MARK: - Sticker selection (index stepper + normalized slider, bounded by `itemCount`)

  @Published public private(set) var stickerIndex: Int = 0
  @Published public private(set) var stickerItemCount: Int = 0

  public func setStickerIndex(_ index: Int) {
    guard let sticker = engine?.sticker else { stickerIndex = index; return }
    sticker.selectedIndex = index
    stickerIndex = sticker.selectedIndex   // read back — `StickerSource` clamps
  }

  /// `0...1` → index, via `StickerSource.select(normalized:)`'s own mapping (spec §02 §2 item
  /// 4) — the panel's continuous slider, as distinct from `setStickerIndex`'s discrete stepper.
  public func setStickerNormalized(_ value: Double) {
    guard let sticker = engine?.sticker else { return }
    sticker.select(normalized: Float(value))
    stickerIndex = sticker.selectedIndex
  }

  // MARK: - Movie (NSOpenPanel file picker)

  @Published public private(set) var movieFileName: String?

  /// Runs a modal `NSOpenPanel` and, on a chosen file, starts it looping on the movie layer
  /// (`Engine.loadMovie`). Modal is deliberate: choosing a movie is a performer setup action
  /// between cues, not something that needs to happen without blocking the render loop's own
  /// thread — `NSOpenPanel.runModal` is the standard synchronous AppKit idiom for exactly that,
  /// and this method is only ever called from a SwiftUI `Button` action, never from `Engine.step`.
  public func pickMovieFile() {
    let panel = NSOpenPanel()
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = false
    panel.canChooseFiles = true
    guard panel.runModal() == .OK, let url = panel.url else { return }
    engine?.loadMovie(url: url)
    movieFileName = url.lastPathComponent
  }

  // MARK: - Resolution / frame rate (venue properties, not performed — `Preset` doc comment)

  @Published public private(set) var resolution: SIMD2<Int> = Engine.resolutionPresets[4]  // 1080p
  @Published public private(set) var frameRate: Int = 60

  public func setResolution(_ size: SIMD2<Int>) {
    resolution = size
    engine?.setResolution(size)
  }

  public func setFrameRate(_ rate: Int) {
    frameRate = rate
    engine?.frameRate = rate
  }

  // MARK: - Presets (design §5 Presets — save/recall THROUGH `Engine.capturePreset`/
  // `applyPreset`, the real entry points; NOT `PresetStore.capture` directly, whose toggles/
  // sourceSelection fields are caller-override placeholders per that method's own doc comment)

  @Published public var presetName: String = ""
  @Published public private(set) var presetNames: [String] = []

  public func refreshPresetList() {
    presetNames = presetStore?.list() ?? []
  }

  public func saveCurrentPreset() {
    guard let engine, let presetStore, !presetName.isEmpty else { return }
    let preset = engine.capturePreset(name: presetName)
    try? presetStore.save(preset)
    refreshPresetList()
  }

  /// Recalls glide, per `PresetStore.apply`'s own doc comment — `CACurrentMediaTime()` is the
  /// same clock domain `MetalHostView.renderFrame` feeds `Engine.step`/`ControlRouter.tick`, so
  /// the ramp this kicks off lines up with whatever frame renders next, not some other clock.
  public func recallPreset(named name: String) {
    guard let engine, let presetStore, let preset = try? presetStore.load(name: name) else { return }
    engine.applyPreset(preset, at: CACurrentMediaTime())
    presetName = preset.name
    layerMode = engine.layerMode
    eraseValue = Double(engine.router.eraseControl)
    stickerIndex = engine.sticker.selectedIndex
    stickerItemCount = engine.sticker.itemCount
    sInvertOn = preset.toggles.sInvert
    layerOn = preset.toggles.layerEnabled
    wave1On = preset.toggles.wave1
    wave2On = preset.toggles.wave2
    worldBumpOn = preset.toggles.worldBump
    waveBumpOn = preset.toggles.waveBump
    kittyBumpOn = preset.toggles.kittyBump
  }

  // MARK: - HUD

  /// Purely a display concern owned by `OutputStage` (inside `MetalHostView`, behind
  /// `PreviewView`) — NOT part of `ControlWrite`/`ToggleEvent`'s vocabulary, because hiding the
  /// frame-time overlay is not something a performer's gesture asserts into the control vector,
  /// it's a "what does the operator see" setting. `PreviewView`/`MetalHostView` read this
  /// mirror directly (see that file's `hudEnabled` forwarding property) rather than this class
  /// reaching into AppKit view internals it has no business touching.
  @Published public var hudEnabled: Bool = true

  // MARK: - Init

  /// `engine`/`presetStore` default to `nil` so `EngineViewModel()` — the bare form the unit
  /// tests construct — builds a complete, pollable `ControlSurface` with no live `Engine`
  /// dependency at all (see the type doc above). `feedbax-dev/main.swift` is the only caller
  /// that passes real values.
  public init(engine: Engine? = nil, presetStore: PresetStore? = nil) {
    self.engine = engine
    self.presetStore = presetStore
    if let engine {
      // Seed every mirror from the live engine's actual starting state, rather than this
      // class's own arbitrary defaults — `applyStartupDefaults` (called by `main.swift` before
      // this init) already put `router`/`sticker` in their real cold-start state, and the panel
      // should show that, not zeroes.
      layerMode = engine.layerMode
      eraseValue = Double(engine.router.eraseControl)
      resolution = engine.resolution
      frameRate = engine.frameRate
      stickerIndex = engine.sticker.selectedIndex
      stickerItemCount = engine.sticker.itemCount
      engine.sticker.onCountChanged = { [weak self] count in self?.stickerItemCount = count }
    }
    if presetStore != nil { refreshPresetList() }
  }
}
