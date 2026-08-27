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
