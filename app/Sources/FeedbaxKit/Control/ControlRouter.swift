import Foundation
import simd

/// Routes performer control input into per-frame `RenderParams` — the entire "control path"
/// of the original patch (spec §01 §4's shaderfx maps, spec §04 §1.2's shadeCtl arbitration),
/// minus the input devices themselves (Task 13/14 supply those as `ControlSurface`s). Owns
/// the 9-slot raw control vector, SInvert, the erase channel, and one `LinearRamp` per
/// smoothed slot.
public final class ControlRouter {
  /// Slots that pass through a `LinearRamp` on their way to `RenderParams`. `.scalebright`
  /// and `.nc` are excluded — dead in the original (spec §01 §4) — they're still stored in
  /// `rawSlots` so presets (Task 12) round-trip all 9 values, but never mapped or ramped.
  private static let rampedSlots: [ControlSlot] = [.hue, .bias, .panX, .panY, .zoom, .theta, .saturation]

  private let smoothMs: Double
  private let grainMs: Double

  /// Raw, unmapped values last written to each of the 9 slots, indexed by `ControlSlot
  /// .rawValue`. Task 12 (presets) reads/writes this whole array for save/recall.
  public private(set) var rawSlots: [Float]

  /// +1 (default) or −1 (spec §01 §4). A discrete toggle, not a ramped slot — see the
  /// per-mapping comments in `mappedTarget`/`tick` for exactly where it multiplies in: pan
  /// folds it in BEFORE the map (so a flip glides), zoom multiplies it in AFTER the ramp
  /// (so a flip is instant).
  public private(set) var sInvert: Float = 1

  /// Raw erase-knob position, 0...1. Deliberately NOT one of the 9 slots — spec §01 §2: the
  /// erase channel is the one control the original never routes through `mIniCtlSmooth`.
  /// Task 12's startup defaults set this to 1.0 (the persisted webui TRANSPARANCY slider);
  /// this router's own default (0) only holds until a preset or Task 12 sets it.
  public var eraseControl: Float = 0

  /// Devices polled once per `tick`, in order. Later surfaces win ties on any slot they both
  /// assert — spec §04 §1.2's last-write-wins arbitration between competing sources (e.g. a
  /// manual slider and an automatic/device-driven signal landing on the same pack inlet).
  public var surfaces: [ControlSurface] = []

  /// Engine hook for every toggle except `.sInvert`, which this router applies to its own
  /// `sInvert` state instead of forwarding.
  public var toggleHandler: ((ToggleEvent) -> Void)?

  private var ramps: [ControlSlot: LinearRamp]
  /// The mapped (pre-ramp) target last handed to each ramp. Diffing against THIS — not the
  /// raw slot value — is what makes an SInvert flip correctly retarget `panX`/`panY` (whose
  /// map folds SInvert in before the ramp) while leaving `zoom`'s ramp completely untouched
  /// (SInvert multiplies zoom AFTER its ramp, so no retarget is ever needed there). It's the
  /// generalized form of spec §04 §1.2's `zl.change` dedup: "recompute only when the value
  /// actually feeding the ramp changed," not just "when the raw input changed."
  private var lastRampTarget: [ControlSlot: Float]

  public init(smoothMs: Double = 100, grainMs: Double = 4) {
    self.smoothMs = smoothMs
    self.grainMs = grainMs
    self.rawSlots = Array(repeating: 0, count: ControlSlot.allCases.count)
    var ramps: [ControlSlot: LinearRamp] = [:]
    var targets: [ControlSlot: Float] = [:]
    for slot in ControlRouter.rampedSlots {
      let target = ControlRouter.mappedTarget(for: slot, raw: 0, sInvert: 1)
      ramps[slot] = LinearRamp(initial: target, smoothMs: smoothMs, grainMs: grainMs)
      targets[slot] = target
    }
    self.ramps = ramps
    self.lastRampTarget = targets
  }

  /// Applies one write immediately: raw slots, toggles, and the erase nudge all land right
  /// away (a preset recall, Task 12, uses this directly) — only the ramps keep gliding at
  /// their own pace toward whatever new targets this write implies.
  public func apply(_ write: ControlWrite, at time: TimeInterval) {
    mergeAndProcess(write, at: time)
  }

  /// One frame: poll every surface in order (last-writer-wins per slot), advance every ramp
  /// to `time`, and assemble the already-smoothed, already-mapped `RenderParams` the engine
  /// (Task 19) hands to `FeedbackCore`.
  public func tick(at time: TimeInterval) -> RenderParams {
    for surface in surfaces {
      if let write = surface.poll(time) {
        mergeAndProcess(write, at: time)
      }
    }
    let eraseAlpha = maxScale(eraseControl, 0, 1, 0.8, 1, exp: 3)   // spec §01 §2 — never ramped
    return RenderParams(
      zoom: ramps[.zoom]!.value(at: time) * sInvert,   // SInvert AFTER the ramp: an instant flip
      theta: ramps[.theta]!.value(at: time),
      offsetPx: SIMD2(ramps[.panX]!.value(at: time), ramps[.panY]!.value(at: time)),
      hueShift: ramps[.hue]!.value(at: time),
      satDelta: ramps[.saturation]!.value(at: time),
      lightDelta: ramps[.bias]!.value(at: time),
      eraseAlpha: eraseAlpha)
  }

  private func mergeAndProcess(_ write: ControlWrite, at time: TimeInterval) {
    for (slot, value) in write.slots {
      rawSlots[slot.rawValue] = value
    }
    for toggle in write.toggles {
      if case .sInvert(let on) = toggle {
        sInvert = on ? -1 : 1   // handled here — everything else forwards to the engine
      } else {
        toggleHandler?(toggle)
      }
    }
    if let step = write.eraseStep {
      eraseControl = min(1, max(0, eraseControl + step))
    }
    updateRampTargets(at: time)
  }

  /// Diff-before-broadcast (spec §04 §1.2's `zl.change`): only call `setTarget` — which
  /// resets a ramp's start point to wherever it currently sits — when the mapped value that
  /// slot should be gliding toward has actually changed. Calling `setTarget` every tick with
  /// an unchanged target would keep resetting the ramp's clock, and it would never converge.
  private func updateRampTargets(at time: TimeInterval) {
    for slot in ControlRouter.rampedSlots {
      let target = ControlRouter.mappedTarget(for: slot, raw: rawSlots[slot.rawValue], sInvert: sInvert)
      if lastRampTarget[slot] != target {
        ramps[slot]?.setTarget(target, at: time)
        lastRampTarget[slot] = target
      }
    }
  }

  /// The Constants table's per-slot map (spec §01 §4), verbatim. `panX`/`panY` fold SInvert
  /// in HERE, before the map — a flip glides in over the ramp. `zoom`'s SInvert multiply is
  /// deliberately absent from this function; `tick` applies it after evaluating the ramp, so
  /// a flip there is instant, not smoothed.
  private static func mappedTarget(for slot: ControlSlot, raw: Float, sInvert: Float) -> Float {
    switch slot {
    case .hue: return maxScale(raw, -1, 1, -0.05, 0.05, exp: 0.1)
    case .bias: return maxScale(raw, -1, 1, -0.04, 0.02, exp: 0.05)
    case .panX, .panY: return maxScale(raw * sInvert, -1, 1, -2000, 2000)
    case .zoom: return maxScale(raw, -1, 1, 0.4, 1.2)
    case .theta: return maxScale(raw, -1, 1, .pi, -.pi)          // reversed hi/lo, spec §01 §4
    case .saturation: return maxScale(raw, 0, 1, -0.05, 0.05, exp: 0.1)
    case .scalebright, .nc: return 0   // dead slots — unreachable: not in `rampedSlots`
    }
  }
}
