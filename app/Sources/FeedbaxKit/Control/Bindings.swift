import Foundation

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
