import Foundation

/// One trackpad gesture's target and gain: which raw `ControlSlot` it accumulates into, and
/// how much of the gesture's delta lands per unit (design §5's "which gesture drives which
/// slot + sensitivity"). Remapping a gesture — even swapping which axis pinch drives — is a
/// JSON edit to `slot`/`sensitivity`, not a code change (design §5: "the bindings table...
/// is a versioned JSON resource loaded at startup and hot-reloadable").
public struct TrackpadAxis: Equatable {
  public var slot: ControlSlot
  public var sensitivity: Float

  public init(slot: ControlSlot, sensitivity: Float) {
    self.slot = slot
    self.sensitivity = sensitivity
  }
}

/// The three trackpad gestures the surface recognizes (design §5 baseline-local-input): a
/// two-finger drag is the original's shader-pan touch role (`panX`/`panY`), pinch/magnify
/// drives `zoom`, and an option-held drag takes `hue` (x) / `theta` (y).
public struct TrackpadBindings: Equatable {
  public var panX: TrackpadAxis
  public var panY: TrackpadAxis
  public var zoom: TrackpadAxis
  public var hue: TrackpadAxis
  public var theta: TrackpadAxis

  public init(panX: TrackpadAxis, panY: TrackpadAxis, zoom: TrackpadAxis, hue: TrackpadAxis,
              theta: TrackpadAxis) {
    self.panX = panX
    self.panY = panY
    self.zoom = zoom
    self.hue = hue
    self.theta = theta
  }
}

/// The keyboard/trackpad bindings table (design §5): a versioned, hot-reloadable JSON
/// resource mapping performer input to the `ControlSurface` vocabulary. `keys` names, per
/// key, WHICH `ToggleEvent` case it fires — the Bool that case carries is only a placeholder
/// (always decoded `true`). A toggle's real on/off state is the surface's OWN per-key flip
/// memory, not something the binding file can know ahead of time: the file just says "the
/// `i` key is the SInvert toggle," and `KeyboardTrackpadSurface.keyDown` resolves whether
/// this particular press is turning it on or off (standing ruling, Task 13).
public struct Bindings: Equatable {
  public var version: Int
  public var keys: [String: ToggleEvent]
  public var trackpad: TrackpadBindings

  public init(version: Int, keys: [String: ToggleEvent], trackpad: TrackpadBindings) {
    self.version = version
    self.keys = keys
    self.trackpad = trackpad
  }
}

// MARK: - Human-writable marker names

/// `ToggleEvent`'s compiler-synthesized `Codable` conformance wraps a single associated Bool
/// as `{"_0": true}` — technically round-trippable, but unreadable in a table a performer is
/// meant to hand-edit. These markers give the bindings JSON a flat `"i": "sInvert"` instead;
/// only `Bindings`' own custom `Codable` (below) uses them.
extension ToggleEvent {
  static func fromMarker(_ name: String, flip: Bool = true) -> ToggleEvent? {
    switch name {
    case "sInvert": return .sInvert(flip)
    case "worldBumpEnabled": return .worldBumpEnabled(flip)
    case "waveBumpEnabled": return .waveBumpEnabled(flip)
    case "kittyBumpEnabled": return .kittyBumpEnabled(flip)
    case "wave1Enabled": return .wave1Enabled(flip)
    case "wave2Enabled": return .wave2Enabled(flip)
    case "layerEnabled": return .layerEnabled(flip)
    case "fullscreen": return .fullscreen
    case "stillCapture": return .stillCapture
    default: return nil
    }
  }

  var marker: String {
    switch self {
    case .sInvert: return "sInvert"
    case .worldBumpEnabled: return "worldBumpEnabled"
    case .waveBumpEnabled: return "waveBumpEnabled"
    case .kittyBumpEnabled: return "kittyBumpEnabled"
    case .wave1Enabled: return "wave1Enabled"
    case .wave2Enabled: return "wave2Enabled"
    case .layerEnabled: return "layerEnabled"
    case .fullscreen: return "fullscreen"
    case .stillCapture: return "stillCapture"
    }
  }

  /// This event with its associated Bool (if any) replaced by `flip` — how
  /// `KeyboardTrackpadSurface` turns a bindings-file placeholder into the real, alternating
  /// on/off state it tracks per key. Cases with no Bool are one-shot UI actions
  /// (`.fullscreen`, `.stillCapture` — see `PresetToggles`' own note that these aren't
  /// persistent state); they ignore `flip` and pass through unchanged, since pressing "f"
  /// fires the same event every time rather than alternating.
  func resolvingFlip(_ flip: Bool) -> ToggleEvent {
    switch self {
    case .sInvert: return .sInvert(flip)
    case .worldBumpEnabled: return .worldBumpEnabled(flip)
    case .waveBumpEnabled: return .waveBumpEnabled(flip)
    case .kittyBumpEnabled: return .kittyBumpEnabled(flip)
    case .wave1Enabled: return .wave1Enabled(flip)
    case .wave2Enabled: return .wave2Enabled(flip)
    case .layerEnabled: return .layerEnabled(flip)
    case .fullscreen, .stillCapture: return self
    }
  }
}

/// Same rationale as the `ToggleEvent` markers above: `ControlSlot`'s synthesized `Codable`
/// (it has an `Int` raw value) would round-trip as a bare index, which reads as noise next to
/// a hand-edited sensitivity number. `TrackpadAxis`'s custom `Codable` spells the slot out.
extension ControlSlot {
  static func fromMarker(_ name: String) -> ControlSlot? {
    switch name {
    case "hue": return .hue
    case "bias": return .bias
    case "scalebright": return .scalebright
    case "panX": return .panX
    case "panY": return .panY
    case "zoom": return .zoom
    case "theta": return .theta
    case "nc": return .nc
    case "saturation": return .saturation
    default: return nil
    }
  }

  var marker: String {
    switch self {
    case .hue: return "hue"
    case .bias: return "bias"
    case .scalebright: return "scalebright"
    case .panX: return "panX"
    case .panY: return "panY"
    case .zoom: return "zoom"
    case .theta: return "theta"
    case .nc: return "nc"
    case .saturation: return "saturation"
    }
  }
}

// MARK: - Codable

extension TrackpadAxis: Codable {
  private enum CodingKeys: String, CodingKey { case slot, sensitivity }

  public init(from decoder: Decoder) throws {
    let c = try decoder.container(keyedBy: CodingKeys.self)
    let name = try c.decode(String.self, forKey: .slot)
    guard let slot = ControlSlot.fromMarker(name) else {
      throw DecodingError.dataCorruptedError(
        forKey: .slot, in: c, debugDescription: "Unknown control slot marker '\(name)'")
    }
    self.slot = slot
    self.sensitivity = try c.decode(Float.self, forKey: .sensitivity)
  }

  public func encode(to encoder: Encoder) throws {
    var c = encoder.container(keyedBy: CodingKeys.self)
    try c.encode(slot.marker, forKey: .slot)
    try c.encode(sensitivity, forKey: .sensitivity)
  }
}

extension TrackpadBindings: Codable {}

extension Bindings: Codable {
  private enum CodingKeys: String, CodingKey { case version, keys, trackpad }

  public init(from decoder: Decoder) throws {
    let c = try decoder.container(keyedBy: CodingKeys.self)
    version = try c.decode(Int.self, forKey: .version)
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
    trackpad = try c.decode(TrackpadBindings.self, forKey: .trackpad)
  }

  public func encode(to encoder: Encoder) throws {
    var c = encoder.container(keyedBy: CodingKeys.self)
    try c.encode(version, forKey: .version)
    let rawKeys = Dictionary(uniqueKeysWithValues: keys.map { ($0.key, $0.value.marker) })
    try c.encode(rawKeys, forKey: .keys)
    try c.encode(trackpad, forKey: .trackpad)
  }
}

/// Loads a `Bindings` table from disk, or the bundled default when `url` is nil — design §5's
/// "hot-reloadable": a performer (or Task 20's UI) can point this at a venue-specific file
/// without a rebuild.
public final class BindingsLoader {
  public static func load(from url: URL?) throws -> Bindings {
    let resolvedURL: URL
    if let url {
      resolvedURL = url
    } else {
      guard let bundled = Bundle.module.url(forResource: "DefaultBindings", withExtension: "json") else {
        throw BindingsLoaderError.bundledResourceMissing
      }
      resolvedURL = bundled
    }
    let data = try Data(contentsOf: resolvedURL)
    return try JSONDecoder().decode(Bindings.self, from: data)
  }
}

public enum BindingsLoaderError: Error {
  case bundledResourceMissing
}
