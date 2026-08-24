import Foundation
import simd

/// One complete "look" a performer can save and recall — control state, discrete toggles,
/// and per-layer placement/selection/filter parameters (design §5 Presets). Res/rate and
/// display assignment are deliberately NOT here: those are venue properties, set once for a
/// space rather than performed, and Task 22's golden scenarios need them stable across every
/// preset a scenario cycles through.
public struct Preset: Codable, Equatable {
  public var name: String
  /// The 9 raw (unmapped) control-vector values, `ControlSlot.rawValue`-indexed — same shape
  /// as `ControlRouter.rawSlots`/`ControlRouter.startupVector` (spec §04 §1.1).
  public var slots: [Float]
  public var eraseControl: Float
  public var toggles: PresetToggles
  public var layers: [PresetLayer]

  public init(name: String, slots: [Float], eraseControl: Float, toggles: PresetToggles,
              layers: [PresetLayer]) {
    self.name = name
    self.slots = slots
    self.eraseControl = eraseControl
    self.toggles = toggles
    self.layers = layers
  }
}

/// Snapshot of every discrete, persistent `ToggleEvent` state. `.fullscreen`/`.stillCapture`
/// aren't represented — those are one-shot UI actions (spec §04 §1's toggle table), not
/// states a preset could meaningfully restore. Defaults mirror `ToggleEvent`'s own observed
/// rest state (spec §01 §4): everything off except `wave1`, which is on at load.
public struct PresetToggles: Codable, Equatable {
  public var sInvert = false
  public var worldBump = false
  public var waveBump = false
  public var kittyBump = false
  public var wave1 = true
  public var wave2 = false
  public var layerEnabled = false

  public init(sInvert: Bool = false, worldBump: Bool = false, waveBump: Bool = false,
              kittyBump: Bool = false, wave1: Bool = true, wave2: Bool = false,
              layerEnabled: Bool = false) {
    self.sInvert = sInvert
    self.worldBump = worldBump
    self.waveBump = waveBump
    self.kittyBump = kittyBump
    self.wave1 = wave1
    self.wave2 = wave2
    self.layerEnabled = layerEnabled
  }

  /// All 7 states as `ToggleEvent`s, in a fixed order — what `PresetStore.apply` hands
  /// `ControlRouter.apply` to restore a preset's toggle state absolutely. Unlike a live
  /// performer's toggle, every one of these always fires on recall (even to reassert
  /// "false"): a preset is a complete state, not a diff against whatever the router already
  /// held.
  func toggleEvents() -> [ToggleEvent] {
    [.sInvert(sInvert), .worldBumpEnabled(worldBump), .waveBumpEnabled(waveBump),
     .kittyBumpEnabled(kittyBump), .wave1Enabled(wave1), .wave2Enabled(wave2),
     .layerEnabled(layerEnabled)]
  }
}

/// Which imagery a saved layer pointed at — Task 15/16's `StickerSource`/`MovieSource`
/// selection, captured by index/path rather than by live `SeedSource` identity (a preset
/// outlives any particular in-memory source instance, and a sticker index or movie path is
/// what a future session can actually re-resolve into a source).
public enum SourceSelection: Codable, Equatable {
  case stickerIndex(Int)
  case moviePath(String)
}

/// One layer's captured placement, gating, and filter state — `imageMove`'s
/// position/scale/rotate plus `jit.gl.layer`'s z-order/enable (spec §02 §4-5), matched back
/// to a live `SeedSource` by `id` on recall.
public struct PresetLayer: Codable, Equatable {
  public var id: String
  public var sourceSelection: SourceSelection
  public var transform: LayerTransform
  public var settings: LayerSettings
  public var filters: [PresetFilterParams]

  public init(id: String, sourceSelection: SourceSelection, transform: LayerTransform,
              settings: LayerSettings, filters: [PresetFilterParams]) {
    self.id = id
    self.sourceSelection = sourceSelection
    self.transform = transform
    self.settings = settings
    self.filters = filters
  }
}

/// One `Filters/` class's captured parameters, tagged by which filter it applies to. Mirrors
/// each filter's own public properties field-for-field (see `BrcosaFilter`, `LumaKeyFilter`,
/// `ChromaKeyFilter`) — `.lumaKey` only carries `enabled` because that's the only property a
/// preset needs to restore per the design (the cascade's high/low luma/tol/fade values are
/// P3 keying-UI territory, not performed per-preset).
public enum PresetFilterParams: Codable, Equatable {
  case brcosa(brightness: Float, contrast: Float, saturation: Float, enabled: Bool)
  case lumaKey(enabled: Bool)
  case chromaKey(color: SIMD3<Float>, tol: Float, fade: Float, enabled: Bool)

  /// Snapshots one live `TextureFilter`'s current parameters, or nil for a filter type
  /// Presets doesn't model. No task has wired a per-layer `FilterChain` onto `SeedSource` yet
  /// (that protocol currently exposes only `id`/`tick`/`transform`/`layer` — see
  /// Sources/SeedSource.swift), so nothing calls this today; it exists so that wiring is a
  /// one-line `.compactMap(PresetFilterParams.capture)` away once a layer gains a filter
  /// chain to snapshot.
  public static func capture(from filter: TextureFilter) -> PresetFilterParams? {
    switch filter {
    case let f as BrcosaFilter:
      return .brcosa(brightness: f.brightness, contrast: f.contrast, saturation: f.saturation,
                     enabled: f.enabled)
    case let f as LumaKeyFilter:
      return .lumaKey(enabled: f.enabled)
    case let f as ChromaKeyFilter:
      return .chromaKey(color: f.keyColor, tol: f.tol, fade: f.fade, enabled: f.enabled)
    default:
      return nil
    }
  }

  /// Writes these captured parameters back onto a live filter instance — the inverse of
  /// `capture(from:)`. A case/type mismatch (e.g. a `.brcosa` handed a `ChromaKeyFilter`) is
  /// a silent no-op: callers are expected to pair each `PresetFilterParams` with the filter
  /// it was captured from (matching by position/id), the same contract `FilterChain.apply`
  /// already has with its type-erased `[TextureFilter]`.
  public func apply(to filter: TextureFilter) {
    switch (self, filter) {
    case let (.brcosa(b, c, s, en), f as BrcosaFilter):
      f.brightness = b; f.contrast = c; f.saturation = s; f.enabled = en
    case let (.lumaKey(en), f as LumaKeyFilter):
      f.enabled = en
    case let (.chromaKey(color, tol, fade, en), f as ChromaKeyFilter):
      f.keyColor = color; f.tol = tol; f.fade = fade; f.enabled = en
    default:
      break
    }
  }
}

/// Reads/writes `Preset`s as pretty-printed JSON, one `<name>.json` file per preset, under
/// `directory` (design §5 Presets). `directory` is created on first `save`, not at `init` —
/// listing/loading before any save has happened is just "nothing there yet," not an error.
public final class PresetStore {
  private let directory: URL
  private let encoder: JSONEncoder = {
    let e = JSONEncoder()
    e.outputFormatting = [.prettyPrinted, .sortedKeys]
    return e
  }()
  private let decoder = JSONDecoder()

  /// Default: `~/Library/Application Support/Feedbax/Presets`. Tests always pass an explicit
  /// temp directory instead, so this default is never exercised outside a real run.
  public static var defaultDirectory: URL {
    let support = FileManager.default.urls(for: .applicationSupportDirectory,
                                            in: .userDomainMask).first!
    return support.appendingPathComponent("Feedbax", isDirectory: true)
      .appendingPathComponent("Presets", isDirectory: true)
  }

  public init(directory: URL = PresetStore.defaultDirectory) {
    self.directory = directory
  }

  private func fileURL(for name: String) -> URL {
    directory.appendingPathComponent("\(name).json")
  }

  public func save(_ preset: Preset) throws {
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let data = try encoder.encode(preset)
    try data.write(to: fileURL(for: preset.name))
  }

  public func load(name: String) throws -> Preset {
    let data = try Data(contentsOf: fileURL(for: name))
    return try decoder.decode(Preset.self, from: data)
  }

  /// Preset names (no `.json` extension) found in `directory`, alphabetical. Empty — not a
  /// thrown error — if the directory doesn't exist yet (no preset has ever been saved there).
  public func list() -> [String] {
    guard let contents = try? FileManager.default.contentsOfDirectory(
      at: directory, includingPropertiesForKeys: nil
    ) else { return [] }
    return contents
      .filter { $0.pathExtension == "json" }
      .map { $0.deletingPathExtension().lastPathComponent }
      .sorted()
  }

  /// Snapshots the router's raw control state plus each layer's transform/settings into a
  /// `Preset`. Two fields are necessarily best-effort against the CURRENT `SeedSource`/
  /// `ControlRouter` surfaces (both narrower than what a full capture ideally needs — see
  /// each field's note) rather than left out of the produced `Preset` entirely, since
  /// downstream (Task 20's UI) still needs a complete, savable value back:
  /// - `toggles`: `ControlRouter` itself only tracks `sInvert` — the other five toggle
  ///   states live wherever `toggleHandler` forwards them (the engine/UI, not built yet), so
  ///   they capture at `PresetToggles`' own defaults. A caller that tracks live toggle state
  ///   should override those fields on the returned `Preset` before saving.
  /// - `sourceSelection`/`filters`: `SeedSource` doesn't yet expose which concrete source it
  ///   is or its filter chain (see `PresetFilterParams.capture(from:)`'s note), so these are
  ///   deterministic placeholders (`.stickerIndex(<layer index>)`, no filters) a caller with
  ///   that information should also override.
  public static func capture(name: String, router: ControlRouter, layers: [SeedSource]) -> Preset {
    let toggles = PresetToggles(sInvert: router.sInvert < 0)
    let presetLayers = layers.enumerated().map { index, layer in
      PresetLayer(id: layer.id, sourceSelection: .stickerIndex(index),
                 transform: layer.transform, settings: layer.layer, filters: [])
    }
    return Preset(name: name, slots: router.rawSlots, eraseControl: router.eraseControl,
                 toggles: toggles, layers: presetLayers)
  }

  /// Recalls a preset: the 9-slot control vector goes through `router.apply` — ramped, same
  /// glide a performer's own gesture would get (design §5 Presets: recall glides, it doesn't
  /// snap) — while `eraseControl`, layer transforms, and layer settings are set directly.
  /// Erase is never ramped in the original (spec §01 §2) and isn't a `ControlWrite` slot;
  /// transforms/settings are a performer-authored placement fact, not a live gesture, so
  /// there's no glide to reproduce for them either.
  public static func apply(_ preset: Preset, router: ControlRouter, layers: [SeedSource],
                           at time: TimeInterval) {
    var slots: [ControlSlot: Float] = [:]
    for slot in ControlSlot.allCases {
      slots[slot] = preset.slots[slot.rawValue]
    }
    router.apply(ControlWrite(slots: slots, toggles: preset.toggles.toggleEvents()), at: time)
    router.eraseControl = preset.eraseControl

    let layersByID = Dictionary(uniqueKeysWithValues: layers.map { ($0.id, $0) })
    for presetLayer in preset.layers {
      guard let layer = layersByID[presetLayer.id] else { continue }
      layer.transform = presetLayer.transform
      layer.layer = presetLayer.settings
      // Filters: no-op for the same reason `capture` can't snapshot them — SeedSource
      // doesn't expose a filter chain yet. Once it does, restore each with
      // `PresetFilterParams.apply(to:)` above.
    }
  }
}
