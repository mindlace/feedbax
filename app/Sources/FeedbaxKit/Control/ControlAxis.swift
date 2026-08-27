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
