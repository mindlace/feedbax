import Foundation
import AppKit
import ImageIO
import QuartzCore
import UniformTypeIdentifiers
import simd

/// The operator's SwiftUI-facing model (Task 20; design §5's `ControlSurface` section). The
/// load-bearing design choice: **this is a `ControlSurface` like `KeyboardTrackpadSurface` or
/// `GamepadSurface`, not a privileged back door into `Engine`.** A slider move calls `axis
/// (_:changedTo:)`, which queues an axis write exactly the way a key press queues one in
/// `KeyboardTrackpadSurface` — `ControlRouter.tick` polls this object in `surfaces` order and
/// arbitrates last-write-wins with every other surface, same as any of them (spec §04 §1.2).
/// `OperatorPanel` (the SwiftUI view) never touches `Engine`/`ControlRouter` directly; it only
/// ever calls methods on this object.
///
/// Two kinds of state cross this boundary, matching the two kinds of thing the panel does:
/// - **Axis writes and toggles** go through `poll`, queued and drained exactly once — see that
///   method's own comment for why this differs from `KeyboardTrackpadSurface`, which resolves
///   pending deltas against live truth every frame. "Axis", not "slot": since the layer channel
///   landed (design §3–§4) a `ControlWrite` addresses `ControlAxis`, whose 11 live cases
///   (`ControlAxis.live`) are the 7 driven shader slots plus the image layer's 4.
/// - **Everything else the panel controls is not a `ControlAxis` at all** — erase
///   (a direct `ControlRouter.eraseControl` write, spec §01 §2's "never ramped, never a slot"),
///   layer mode, sticker selection, movie loading, resolution/rate, and presets. Those go
///   straight to `Engine`/`PresetStore` because there is no `ToggleEvent`/`ControlAxis` for them
///   to ride — `ControlWrite` only carries what a *performer gesture* can assert mid-show; a
///   file picker or a resolution change is a setup action, not an axis.
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

  /// The number the original's panel shows for a slot. Its faders are `slider` widgets with
  /// `size 2, min −1` (raw = internal − 1) except SATURATION (`size 1`, raw = internal); the
  /// rotate fader is negated into slot 6 by `* -1.`, so its reading is `1 − raw`. Shown next
  /// to each slider so "the same settings as Max" can be dialled in by number
  /// (docs/superpowers/specs/2026-08-24-dynamism-gap-diagnosis.md). PAN X/PAN Y were
  /// touch-only in the original — no fader, no number box — so there is no panel convention
  /// to match; they pass `raw` through unchanged.
  public static func maxPanelValue(for slot: ControlSlot, raw: Double) -> Double {
    switch slot {
    case .saturation, .panX, .panY: return raw
    case .theta: return 1 - raw
    case .hue, .bias, .zoom, .scalebright, .nc: return raw + 1
    }
  }

  // MARK: - Toggles (spec §04 §1's toggle table; queued exactly like a slot write)

  @Published public private(set) var sInvertOn = false
  @Published public private(set) var layerOn = false
  @Published public private(set) var wave1On = true    // PresetToggles' own default (Presets.swift)
  @Published public private(set) var wave2On = true
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

  /// Drains the queue built up since the last call. `KeyboardTrackpadSurface` no longer keeps
  /// accumulators of its own (design §5): it holds *pending deltas* and resolves them against
  /// the router's truth at poll time. This surface is one step simpler still, because it has
  /// an absolute value to assert rather than a relative nudge —
  /// a slider's write is a one-shot assertion: the performer moved it to X, the router should
  /// glide there, and nothing needs re-asserting next frame just because a fader sits still
  /// (the brief's own test name: "asserted once then drained"). Returning `nil` once nothing is
  /// queued lets `ControlRouter`'s last-write-wins arbitration fall through to whatever the
  /// previous frame's raw slots already hold, same contract every other surface honors.
  public func poll(_ time: TimeInterval) -> ControlWrite? {
    // Final review, finding 4: refresh every toggle/erase mirror from the engine/router's own
    // truth right before assembling this frame's write — the same "surfaces don't keep
    // independent memory, they read truth" discipline `KeyboardTrackpadSurface`/`GamepadSurface`
    // now follow via `ControlStateSnapshot` (that type's own doc comment). Without this, a flip
    // applied by a DIFFERENT surface (a keyboard `i` press, a gamepad button, a preset recall)
    // never reached these `@Published` mirrors, so the operator panel kept showing the OLD
    // state and its next click asserted a flip computed from that stale value on top of an
    // already-flipped truth. `poll` runs once per frame on main regardless — this is cheap
    // enough to just always do, and unconditionally (not only when this surface itself has a
    // pending write), since truth can move for reasons that have nothing to do with this
    // object's own queue.
    refreshMirrorsFromTruth()
    let axes = pendingAxes
    let toggles = pendingToggles
    pendingAxes = [:]
    pendingToggles = []
    // `refreshMirrorsFromTruth` just read the router/engine as of BEFORE this write reaches
    // them (the caller — `ControlRouter.tick` — applies `toggles` only after this method
    // returns), so it can't yet see a flip THIS object itself just queued a moment ago via
    // `setSInvert`/etc. Left alone, that would revert this frame's mirror back to the
    // pre-click value for the one tick before truth catches up — an actual regression from
    // `setSInvert`'s existing "mirror updates immediately, no round-trip lag" contract (this
    // type's own doc comment). Reapplying `toggles` on top of the truth read keeps that
    // contract intact while still picking up flips from OTHER surfaces.
    applyOptimistically(toggles)
    // Same reasoning as the toggles: the truth read above predates THIS write, so put our own
    // just-queued values back on top or a slider mid-drag flickers to the old value for a tick.
    for (axis, value) in axes { axisValues[axis] = Double(value) }
    if axes.isEmpty && toggles.isEmpty { return nil }
    return ControlWrite(axes: axes, toggles: toggles)
  }

  /// The read side of finding 4's single-owner fix — see `poll`'s call site for why this runs
  /// every frame. `engine == nil` (the bare `EngineViewModel()` unit tests construct) makes
  /// this a harmless no-op, same as every other engine-touching method in this class.
  ///
  /// Every assignment here is guarded by a compare, because `poll` runs at the frame rate: a
  /// bare assignment to a `@Published` property fires `objectWillChange` even when the value
  /// is identical, which re-evaluated `OperatorPanel.body` 60 times a second for nothing. With
  /// the panel in its own window (the control/display split) that waste is a whole window's
  /// draw cycle, not a corner of one.
  private func refreshMirrorsFromTruth() {
    guard let engine else { return }
    let newSInvert = engine.router.sInvert < 0   // `sInvert` is ±1 — ControlRouter's own doc
    if sInvertOn != newSInvert { sInvertOn = newSInvert }
    let newLayerOn = engine.sticker.layer.enabled  // sticker/movie lockstep — Engine.handle
    if layerOn != newLayerOn { layerOn = newLayerOn }
    let newWave1On = engine.waveforms.wave1Enabled
    if wave1On != newWave1On { wave1On = newWave1On }
    let newWave2On = engine.waveforms.wave2Enabled
    if wave2On != newWave2On { wave2On = newWave2On }
    let newWorldBumpOn = engine.bumpsEnabled.world
    if worldBumpOn != newWorldBumpOn { worldBumpOn = newWorldBumpOn }
    let newWaveBumpOn = engine.bumpsEnabled.wave
    if waveBumpOn != newWaveBumpOn { waveBumpOn = newWaveBumpOn }
    let newKittyBumpOn = engine.bumpsEnabled.kitty
    if kittyBumpOn != newKittyBumpOn { kittyBumpOn = newKittyBumpOn }
    for axis in ControlAxis.live {
      let value = Double(engine.router.rawValue(for: axis))
      if axisValues[axis] != value { axisValues[axis] = value }
    }
    let newEraseValue = Double(engine.router.eraseControl)
    if eraseValue != newEraseValue { eraseValue = newEraseValue }
  }

  /// Reapplies this object's OWN just-queued toggles on top of whatever `refreshMirrorsFromTruth`
  /// just set — see `poll`'s call site comment for why. `.fullscreen`/`.stillCapture` carry no
  /// mirror to update (one-shot UI actions, `ControlStateSnapshot.current`'s own doc comment).
  private func applyOptimistically(_ toggles: [ToggleEvent]) {
    for toggle in toggles {
      switch toggle {
      case .sInvert(let on): sInvertOn = on
      case .worldBumpEnabled(let on): worldBumpOn = on
      case .waveBumpEnabled(let on): waveBumpOn = on
      case .kittyBumpEnabled(let on): kittyBumpOn = on
      case .wave1Enabled(let on): wave1On = on
      case .wave2Enabled(let on): wave2On = on
      case .layerEnabled(let on): layerOn = on
      case .fullscreen, .stillCapture: break
      }
    }
  }

  // MARK: - Erase (spec §01 §2: not a `ControlAxis` at all, never ramped, never a `ControlWrite`
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

  // MARK: - Sticker library (the panel's thumbnail grid, drop zone, and "Add Images…")

  /// File names of everything in the sticker folder, index-aligned with `stickerIndex` — the
  /// grid's model. Kept in step with the source by `onCountChanged` (see `init`), the same bus
  /// the count mirror above rides.
  @Published public private(set) var stickerNames: [String] = []

  /// Small `NSImage` previews keyed by file name, decoded at grid size (never full res, and
  /// never on the render path — this is `CGImageSourceCreateThumbnailAtIndex`, entirely
  /// separate from `StickerSource`'s Metal decode of the *selected* image).
  @Published public private(set) var stickerThumbnails: [String: NSImage] = [:]

  /// Result of the last import, for the line under the drop zone ("Added 3 images", "Skipped
  /// notes.txt"). A status line, deliberately not an alert: nothing here should throw a modal
  /// in front of a performance.
  @Published public private(set) var stickerImportMessage: String?

  public var stickerFolder: URL? { engine?.sticker.folder }

  public var selectedStickerName: String? {
    guard stickerIndex >= 0, stickerIndex < stickerNames.count else { return nil }
    return stickerNames[stickerIndex]
  }

  /// Grid click → the same `selectedIndex` write the stepper and the normalized slider make;
  /// clicking a thumbnail is not a privileged path (design §5).
  public func selectSticker(named name: String) {
    guard let index = stickerNames.firstIndex(of: name) else { return }
    setStickerIndex(index)
  }

  /// Drop-zone and file-picker entry point. Copies into the sticker folder and leaves the
  /// first newly added image selected — see `StickerSource.importImages(from:)` for why copy
  /// rather than reference.
  public func importStickers(_ urls: [URL]) {
    guard let sticker = engine?.sticker else { return }
    let result = sticker.importImages(from: urls)
    stickerIndex = sticker.selectedIndex
    stickerItemCount = sticker.itemCount
    refreshStickerLibrary()
    stickerImportMessage = Self.importMessage(for: result)
  }

  /// The "Add Images…" button — `pickMovieFile`'s sibling, differing only in allowing several
  /// files and in accepting a directory (dropping or choosing a whole folder of stickers is
  /// the common case when setting up).
  public func pickStickerFiles() {
    let panel = NSOpenPanel()
    panel.allowsMultipleSelection = true
    panel.canChooseDirectories = true
    panel.canChooseFiles = true
    panel.allowedContentTypes = [.image]
    guard panel.runModal() == .OK, !panel.urls.isEmpty else { return }
    importStickers(panel.urls)
  }

  /// Re-reads the name list from the source and fills in any thumbnail it doesn't have yet,
  /// dropping the ones whose files are gone. Cheap on the common path: an existing thumbnail
  /// is never re-decoded, so a rescan of a folder that only gained one file costs one decode.
  public func refreshStickerLibrary() {
    guard let sticker = engine?.sticker else { return }
    let names = sticker.itemNames
    stickerNames = names
    let folder = sticker.folder
    var thumbnails = stickerThumbnails.filter { names.contains($0.key) }
    for name in names where thumbnails[name] == nil {
      thumbnails[name] = Self.thumbnail(at: folder.appendingPathComponent(name))
    }
    stickerThumbnails = thumbnails
  }

  /// Grid-sized preview, or nil if the file isn't decodable (the tile then shows a placeholder
  /// rather than vanishing — a file that's really there but unreadable is worth seeing).
  private static func thumbnail(at url: URL, maxPixelSize: Int = 160) -> NSImage? {
    guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
    let options: [CFString: Any] = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
    ]
    guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
      return nil
    }
    return NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
  }

  private static func importMessage(for result: StickerSource.ImportResult) -> String? {
    if result.isEmpty { return nil }
    var parts: [String] = []
    if !result.imported.isEmpty {
      parts.append(result.imported.count == 1
        ? "Added \(result.imported[0])"
        : "Added \(result.imported.count) images")
    }
    if !result.skipped.isEmpty {
      parts.append(result.skipped.count == 1
        ? "skipped \(result.skipped[0])"
        : "skipped \(result.skipped.count) files")
    }
    return parts.joined(separator: " · ")
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

  /// Feedback resample filter (diagnosis doc, term 1) — a venue/debug property like
  /// `frameRate`, not a performed slot. Mirrors `Engine.warpFilter`.
  @Published public private(set) var warpFilter: WarpFilter = .nearest

  public func setWarpFilter(_ filter: WarpFilter) {
    warpFilter = filter
    engine?.warpFilter = filter
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
  /// same clock domain `EngineHost.renderFrame` feeds `Engine.step`/`ControlRouter.tick`, so
  /// the ramp this kicks off lines up with whatever frame renders next, not some other clock.
  public func recallPreset(named name: String) {
    guard let engine, let presetStore, let preset = try? presetStore.load(name: name) else { return }
    engine.applyPreset(preset, at: CACurrentMediaTime())
    presetName = preset.name
    axisValues = Self.axisMirror(from: engine.router)
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

  /// Purely a display concern owned by `OutputStage` — NOT part of `ControlWrite`/`ToggleEvent`'s
  /// vocabulary, because hiding the frame-time overlay is not something a performer's gesture
  /// asserts into the control vector, it's a "what does the operator see" setting. The `didSet`
  /// below forwards this mirror straight to `host.hudEnabled` (`EngineHost` in turn forwards to
  /// `OutputStage`) — the only path there is now that the output stage is owned by `EngineHost`
  /// rather than reachable through any particular view.
  @Published public var hudEnabled: Bool = true {
    didSet { host?.hudEnabled = hudEnabled }
  }

  /// Set by `AppBootstrap.start()`. The HUD toggle used to reach `OutputStage` by way of
  /// `PreviewView.updateNSView`; with the output stage owned by `EngineHost` there is no view
  /// in that path any more, so the toggle talks to the host directly.
  public weak var host: EngineHost?

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

  // MARK: - Init

  /// `engine`/`presetStore` default to `nil` so `EngineViewModel()` — the bare form the unit
  /// tests construct — builds a complete, pollable `ControlSurface` with no live `Engine`
  /// dependency at all (see the type doc above). `feedbax-dev/main.swift` is the only caller
  /// that passes real values.
  public init(engine: Engine? = nil, presetStore: PresetStore? = nil, bindingsStore: BindingsStore? = nil) {
    self.engine = engine
    self.presetStore = presetStore
    self.bindingsStore = bindingsStore
    self.bindings = bindingsStore?.bindings ?? Bindings.fallback
    if let engine {
      // Seed every mirror from the live engine's actual starting state, rather than this
      // class's own arbitrary defaults — `applyStartupDefaults` (called by `main.swift` before
      // this init) already put `router`/`sticker`/`waveforms` in their real cold-start state,
      // and the panel should show that, not zeroes or this class's own guessed rest values.
      // (Review finding: this seeding was previously missing `axisValues` and the toggle
      // mirrors entirely, so every axis widget rendered at zero while the engine was already
      // running the non-zero startup vector, and the toggle switches only "worked" by
      // coincidentally matching `ToggleEvent`'s own defaults — which drifts the moment either
      // side's default changes.)
      axisValues = Self.axisMirror(from: engine.router)
      layerMode = engine.layerMode
      eraseValue = Double(engine.router.eraseControl)
      resolution = engine.resolution
      frameRate = engine.frameRate
      stickerIndex = engine.sticker.selectedIndex
      stickerItemCount = engine.sticker.itemCount
      engine.sticker.onCountChanged = { [weak self] count in
        self?.stickerItemCount = count
        self?.refreshStickerLibrary()   // names + thumbnails follow the count, one bus
      }
      refreshStickerLibrary()

      sInvertOn = engine.router.sInvert < 0   // `sInvert` is ±1 (ControlRouter's own doc comment)
      layerOn = engine.sticker.layer.enabled  // sticker/movie kept in lockstep (Engine.handle)
      wave1On = engine.waveforms.wave1Enabled
      wave2On = engine.waveforms.wave2Enabled
      worldBumpOn = engine.bumpsEnabled.world
      waveBumpOn = engine.bumpsEnabled.wave
      kittyBumpOn = engine.bumpsEnabled.kitty
    }
    if presetStore != nil { refreshPresetList() }
  }
}
