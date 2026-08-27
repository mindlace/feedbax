import Foundation
import simd

/// Routes performer control input into per-frame `RenderParams` — the entire "control path"
/// of the original patch (spec §01 §4's shaderfx maps, spec §04 §1.2's shadeCtl arbitration),
/// minus the input devices themselves (Task 13/14 supply those as `ControlSurface`s). Owns
/// the 9-slot raw control vector, the 4-axis image-layer vector (design §4), SInvert, the
/// erase channel, and one `LinearRamp` per smoothed slot.
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

  public init(smoothMs: Double = 100, grainMs: Double = 4) {
    self.smoothMs = smoothMs
    self.grainMs = grainMs
    self.rawSlots = Array(repeating: 0, count: ControlSlot.allCases.count)
    var ramps: [ControlSlot: LinearRamp] = [:]
    var targets: [ControlSlot: Float] = [:]
    for slot in ControlRouter.rampedSlots {
      // Cold start (spec §01 §4): the geometry ramps seed from whatever raw 0 maps to — the
      // original never emits a value for these until the first control message unpacks a
      // target (`mIniCtlSmooth`'s `line` is silent until then), and raw-0 IS that "nothing
      // has happened yet" state. The three HSL ramps are the exception — `coldStartSeed`
      // below seeds them AT their mapped startup-vector values, so the startup vector lands
      // without any glide at all.
      let target = ControlRouter.coldStartSeed(for: slot)
        ?? ControlRouter.mappedTarget(for: slot, raw: 0, sInvert: 1)
      ramps[slot] = LinearRamp(initial: target, smoothMs: smoothMs, grainMs: grainMs)
      targets[slot] = target
    }
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
    self.ramps = ramps
    self.lastRampTarget = targets
  }

  /// Applies one write immediately: raw slots, toggles, and the erase nudge all land right
  /// away (a preset recall, Task 12, uses this directly) — only the ramps keep gliding at
  /// their own pace toward whatever new targets this write implies.
  public func apply(_ write: ControlWrite, at time: TimeInterval) {
    mergeAndProcess(write, at: time)
  }

  /// The 9-slot control vector a fresh session actually runs on, index-for-index against
  /// `ControlSlot`'s declaration order (hue, bias, scalebright, panX, panY, zoom, theta, nc,
  /// saturation).
  ///
  /// **This is a MEASURED value, not a value read off the patch.** Do not "correct" it back
  /// to the vector in the webui's `loadbang` message (feedbax.webui.maxpat obj-89,
  /// `0.011905 0.392857 0.755952 -0.354023 -0.5 -0.634044 0.281234 0. 0.71131`). That
  /// message is real, and it is genuinely the first thing to reach `s shadeCtl` — but
  /// instrumenting the *running* patch at `s shadeCtl` shows it is superseded 137 ms after
  /// load and never returns. Two mechanisms do it:
  ///
  /// 1. **`r ctrlbang` re-emission at frame rate.** The render clock bangs the webUI `pack`
  ///    object's hot inlet once per frame (60 Hz). A Max `pack` re-emits its own stored
  ///    contents on a hot-inlet bang, so from the very first rendered frame the vector on
  ///    `shadeCtl` is the pack's own state — the widget positions — not the one-shot
  ///    `loadbang` list. The `loadbang` list only ever wins the handful of milliseconds
  ///    before the first `ctrlbang`.
  /// 2. **The `loadbang -> pipe 1500` startup burst.** A delayed button cascade writes
  ///    hue / brightness / saturation directly at t ≈ 1500 ms, settling the pack (and hence
  ///    every subsequent frame's vector) on the values below.
  ///
  /// The vector below is the steady state after both, captured identically across three
  /// independent patch launches. Under the corrected classic-mode `maxScale` (see
  /// `mappedTarget` / `maxScale`) it maps to these per-frame HSL deltas:
  ///
  /// - hue        raw  0.1        -> hueShift   **+0.005** / frame (slow forward hue rotation)
  /// - bias       raw  0.0        -> lightDelta **-0.01**  / frame (**negative** — this is the
  ///              restoring term, the decay that keeps the feedback loop from integrating to
  ///              white; a positive lightDelta here is the bug, not the fix)
  /// - saturation raw  0.5        -> satDelta   **exactly 0.0** / frame (0.5 is the exact
  ///              midpoint of the 0...1 domain mapping onto -0.05...0.05, so saturation is
  ///              perfectly neutral — it neither blooms nor bleaches)
  ///
  /// Slots not listed are geometry (`panX`/`panY` centred at 0, `zoom` -0.25, `theta`
  /// 0.26092…) or dead (`scalebright`, `nc`).
  public static let startupVector: [Float] = [
    0.1, 0.0, 0.0, 0.0, 0.0, -0.25, 0.26092064967168305, 0.0, 0.5
  ]

  /// Reproduces the original's cold start: the webui's loadbang-fired startup vector lands
  /// (ramped, same as any other `apply`), and TRANSPARANCY — the webui's persisted erase
  /// slider — comes up at 1.0, a hard clear that stays until the performer first touches
  /// erase (spec §04 §1.4). `eraseControl` is set directly, not via `ControlWrite.eraseStep`
  /// (a relative nudge): this is an absolute "here is where the session starts," not a step.
  public func applyStartupDefaults(at time: TimeInterval) {
    var slots: [ControlSlot: Float] = [:]
    for slot in ControlSlot.allCases {
      slots[slot] = ControlRouter.startupVector[slot.rawValue]
    }
    var layer: [LayerAxis: Float] = [:]
    for axis in LayerAxis.allCases {
      layer[axis] = ControlRouter.startupLayerVector[axis.rawValue]
    }
    apply(ControlWrite(slots: slots, layer: layer), at: time)
    eraseControl = 1.0
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
    var mappedLayer: [LayerAxis: Float] = [:]
    for axis in LayerAxis.allCases {
      mappedLayer[axis] = layerRamps[axis]!.value(at: time)
    }
    layerTransform = ControlRouter.layerTransform(from: mappedLayer)
    // Never ramped (spec §01 §2). `scale 0 1 0.8 1 3` in Max's default classic mode is
    // `0.8 + 0.2·pow(3, x-1)`, and it is discontinuous at 0: exactly 0 gives 0.8, but 1e-6
    // gives 0.8667. So the knob's floor is 0.8 only at a hard zero — the useful range runs
    // 0.8667 (just off zero) to 1.0 (full clear), passing 0.9155 at half. See `maxScale`.
    let eraseAlpha = maxScale(eraseControl, 0, 1, 0.8, 1, exp: 3)
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
    for (axis, value) in write.layer {
      rawLayer[axis.rawValue] = value
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
    for axis in LayerAxis.allCases {
      let target = ControlRouter.mappedLayerTarget(for: axis, raw: rawLayer[axis.rawValue])
      if lastLayerTarget[axis] != target {
        layerRamps[axis]?.setTarget(target, at: time)
        lastLayerTarget[axis] = target
      }
    }
  }

  /// Seeds the three HSL ramps AT their mapped startup-vector values, so the startup vector
  /// is already in force on frame 0 and no glide happens at all.
  ///
  /// **Do not reintroduce a glide from the gen `param` defaults here.** The HSL pix's three
  /// `param` objects do declare non-zero defaults — `param hue_shift 0.02`,
  /// `param saturation 0.5`, `param lightness 0.5` — and an earlier version of this function
  /// returned those RAW numbers, which then became the *origin* of a 100 ms glide down to
  /// the (much smaller) mapped startup targets. That is a modeling error twice over:
  ///
  /// 1. **Wrong units.** `0.02`/`0.5`/`0.5` are *shader-side* values — they sit where
  ///    `hueShift`/`satDelta`/`lightDelta` sit, already past the map. Feeding them to a ramp
  ///    whose other endpoint is a `maxScale` OUTPUT (order ±0.005…0.05) mixes the two sides
  ///    of the map: `0.5` as a per-frame lightness delta is 50× the largest value the bias
  ///    map can ever produce.
  /// 2. **Wrong role.** A `param` default is the shader's *static* value during the sub-frame
  ///    window before the first `hue_shift $1` message lands — never the starting point of a
  ///    glide. `r ctrlbang` bangs the webUI `pack`'s hot inlet from frame one (the same
  ///    mechanism that supersedes the `loadbang` vector — see `startupVector`), so a real
  ///    launch has a fully-formed control vector on `s shadeCtl` before the first rendered
  ///    frame. There is no interval over which the patch interpolates from the param default
  ///    to the control value; the control value is simply what frame 1 already uses.
  ///
  /// Measured cost of the old behavior: frames 3-6 were 100% white pixels — a visible white
  /// flash at every launch — because ~+0.28 lightness/frame and ~+0.30 saturation/frame
  /// (the glide's early portion) drive the additively-blended feedback plane straight past
  /// its `[0,1]` clip into `hsl2rgb`'s `l=1` white.
  ///
  /// The geometry slots (`panX`/`panY`/`zoom`/`theta`) have no baked pix default and are not
  /// what flashed, so they fall through to `nil` and keep the raw-0 rest seeding, which is
  /// the honest "no control message has arrived" state for a bare `ControlRouter()`.
  ///
  /// This affects the INITIAL seed only. Every later control change still retargets through
  /// `updateRampTargets` and glides over `smoothMs` exactly as before.
  private static func coldStartSeed(for slot: ControlSlot) -> Float? {
    switch slot {
    case .hue, .saturation, .bias:
      return mappedTarget(for: slot, raw: startupVector[slot.rawValue], sInvert: 1)
    default:
      return nil
    }
  }

  /// The Constants table's per-slot map (spec §01 §4), verbatim. `panX`/`panY` fold SInvert
  /// in HERE, before the map — a flip glides in over the ramp. `zoom`'s SInvert multiply is
  /// deliberately absent from this function; `tick` applies it after evaluating the ramp, so
  /// a flip there is instant, not smoothed.
  ///
  /// The `exp:` arguments below are kept verbatim from the patch, but note that in Max's
  /// default classic mode an exponent <= 1 is IGNORED — so `hue`, `bias` and `saturation`
  /// are plain straight lines across their output ranges, not the eased curves the argument
  /// suggests. Hue spans -0.05...0.05 linearly (measured startup raw 0.1 -> +0.005), bias
  /// spans -0.04...0.02 linearly (raw 0.0 -> -0.01, i.e. the midpoint of -1...1 lands BELOW
  /// zero because the output range is asymmetric), saturation spans -0.05...0.05 linearly
  /// over a 0...1 domain (raw 0.5 -> exactly 0). See `maxScale` for why, and
  /// `startupVector` for where those raw values come from.
  ///
  /// Internal rather than `private` so `EngineInvariantTests` can assert the sign of the
  /// `bias` map at the real `startupVector` value directly — the single cheapest check that
  /// would have caught the whiteout (a positive `lightDelta` is an integrator that gains
  /// energy every frame). Not `public`: the map is an implementation detail of the router.
  static func mappedTarget(for slot: ControlSlot, raw: Float, sInvert: Float) -> Float {
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
}
