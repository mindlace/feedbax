import Foundation

/// The 9-slot control vector's slot identities (spec §04 §1.1's confirmed webui layout:
/// `pack 0. ×9` sends exactly these 9 floats, in this order — indices 0–8). Two slots are
/// dead: `.scalebright` and `.nc` are never wired to anything downstream in the original
/// (spec §01 §4), but `ControlRouter` still stores them so a preset (Task 12) round-trips
/// all 9 values, not just the 7 that are actually mapped.
public enum ControlSlot: Int, CaseIterable, Codable {
  case hue = 0, bias, scalebright, panX, panY, zoom, theta, nc, saturation
}

/// A discrete performer action that bypasses the ramp entirely (spec §01 §4). Unlike a slot
/// write, a toggle is a one-shot event, dispatched to `ControlRouter.toggleHandler` (or, for
/// `.sInvert`, consumed by the router itself) the instant it arrives — the original's hard
/// cuts, not smoothed values.
public enum ToggleEvent: Equatable, Codable {
  case sInvert(Bool)
  case worldBumpEnabled(Bool)
  case waveBumpEnabled(Bool)
  case imageBumpEnabled(Bool)
  case wave1Enabled(Bool)
  case wave2Enabled(Bool)
  case imageEnabled(Bool)
  case fullscreen
  case stillCapture
}

/// A partial assertion from one control surface (or a preset recall): only the slots and
/// toggles it currently drives — design doc §5's `ControlWrite`. `eraseStep` is a controller
/// ruling pulled forward from Task 14's note: a relative nudge (e.g. a d-pad tap) applied
/// immediately to `ControlRouter.eraseControl` and clamped to 0...1. It is deliberately NOT
/// a slot — the erase channel lives outside the 9-slot vector and is never ramped (spec §01
/// §2) — so it gets its own field rather than overloading `slots`.
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

/// A performer input device — Task 13 (keyboard/trackpad) and Task 14 (gamepad) implement
/// this. `poll` takes a bare `TimeInterval` rather than the design doc's full `FrameContext`
/// (design §5): surfaces need only a clock to time their own gestures/ramps, not textures or
/// a command buffer, and `TimeInterval` keeps them constructible and testable without Metal.
/// This narrowing is recorded in the design doc §5.
public protocol ControlSurface: AnyObject {
  var id: String { get }
  /// Called once per `ControlRouter.tick`. Return nil to assert nothing this frame — lets
  /// the router's last-writer-wins arbitration (spec §04 §1.2) fall through to whatever an
  /// earlier surface (or the previous frame's raw slots) already holds.
  func poll(_ time: TimeInterval) -> ControlWrite?
}

/// A read-only view onto the engine/router's ACTUAL current boolean state for every toggle that
/// carries a flip (final review, finding 4). Before this existed, `KeyboardTrackpadSurface` and
/// `GamepadSurface` each kept their own private per-key/per-button on/off memory, and
/// `EngineViewModel` kept a third, `@Published`, copy — three independent memories with no
/// mechanism to reconcile, so a key press could flip the router's real state while the operator
/// panel's toggle kept showing the OLD value, and the panel's next click then asserted a flip
/// computed from that stale value on top of an already-flipped truth. This closure bundle is
/// the single source both flip-memory surfaces now query AT POLL TIME (not at the moment the
/// key/button physically went down — see `KeyboardTrackpadSurface.resolveToggles`'s doc comment
/// for why that timing matters) instead of keeping memory of their own.
///
/// A plain struct of closures, not a protocol: `AppBootstrap.start()` builds one that reads a
/// live `Engine` (`router.sInvert`, `bumpsEnabled`, `waveforms.waveNEnabled`,
/// `sticker.layer.enabled` — all already-queryable truth, nothing new added to `Engine` itself);
/// tests build one from local fakes with no `Engine`/Metal dependency at all.
public struct ControlStateSnapshot {
  public var sInvert: () -> Bool
  public var worldBumpEnabled: () -> Bool
  public var waveBumpEnabled: () -> Bool
  public var imageBumpEnabled: () -> Bool
  public var wave1Enabled: () -> Bool
  public var wave2Enabled: () -> Bool
  public var imageEnabled: () -> Bool
  /// The router's current RAW value for any axis (design §5). A relative gesture nudges FROM
  /// this at poll time rather than from a private accumulator — otherwise a slider or preset
  /// that moved the axis is undone by the next trackpad nudge (spec §2, finding 1).
  public var rawValue: (ControlAxis) -> Float

  public init(sInvert: @escaping () -> Bool, worldBumpEnabled: @escaping () -> Bool,
              waveBumpEnabled: @escaping () -> Bool, imageBumpEnabled: @escaping () -> Bool,
              wave1Enabled: @escaping () -> Bool, wave2Enabled: @escaping () -> Bool,
              imageEnabled: @escaping () -> Bool,
              rawValue: @escaping (ControlAxis) -> Float = { _ in 0 }) {
    self.sInvert = sInvert
    self.worldBumpEnabled = worldBumpEnabled
    self.waveBumpEnabled = waveBumpEnabled
    self.imageBumpEnabled = imageBumpEnabled
    self.wave1Enabled = wave1Enabled
    self.wave2Enabled = wave2Enabled
    self.imageEnabled = imageEnabled
    self.rawValue = rawValue
  }

  /// Looks up the live truth for whichever boolean-carrying case `template` is — its OWN
  /// associated Bool is ignored, this returns what the engine/router actually holds right now,
  /// the value `resolvingFlip` should be handed the OPPOSITE of. `.fullscreen`/`.stillCapture`
  /// are one-shot UI actions with no persistent on/off state to query (`ToggleEvent`'s own doc
  /// comment), so this returns `nil` for them — callers fall back to firing them unconditionally
  /// via `resolvingFlip`'s own pass-through for those two cases.
  public func current(for template: ToggleEvent) -> Bool? {
    switch template {
    case .sInvert: return sInvert()
    case .worldBumpEnabled: return worldBumpEnabled()
    case .waveBumpEnabled: return waveBumpEnabled()
    case .imageBumpEnabled: return imageBumpEnabled()
    case .wave1Enabled: return wave1Enabled()
    case .wave2Enabled: return wave2Enabled()
    case .imageEnabled: return imageEnabled()
    case .fullscreen, .stillCapture: return nil
    }
  }

  /// Every toggle reads as `value`, unconditionally and forever — the default for a surface
  /// built with no live `Engine` to query (a bare unit test constructing
  /// `KeyboardTrackpadSurface`/`GamepadSurface` directly, same as `EngineViewModel()`'s own
  /// nil-engine convenience). NOT a stand-in for real reconciliation: a test that actually cares
  /// about the truth-driven flip (finding 4) needs a snapshot that can change between polls,
  /// e.g. closing over a `var` the test mutates itself to simulate the router having applied a
  /// previous write.
  public static func constant(_ value: Bool,
                              rawValue: @escaping (ControlAxis) -> Float = { _ in 0 }) -> ControlStateSnapshot {
    ControlStateSnapshot(sInvert: { value }, worldBumpEnabled: { value }, waveBumpEnabled: { value },
                         imageBumpEnabled: { value }, wave1Enabled: { value }, wave2Enabled: { value },
                         imageEnabled: { value }, rawValue: rawValue)
  }
}

extension ToggleEvent {
  /// Reference-window label (design §8.1). Exhaustive on purpose: a new toggle without a name
  /// is a compile error, not a blank row.
  public var displayName: String {
    switch self {
    case .sInvert: return "SInvert"
    case .worldBumpEnabled: return "World bump"
    case .waveBumpEnabled: return "Wave bump"
    case .imageBumpEnabled: return "Image bump"
    case .wave1Enabled: return "Wave 1"
    case .wave2Enabled: return "Wave 2"
    case .imageEnabled: return "Image on/off"
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
