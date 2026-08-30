import XCTest
import Foundation
import Combine
@testable import FeedbaxKit

final class EngineViewModelTests: XCTestCase {
  func testAxisWritesAreAssertedOnceThenDrained() {
    let vm = EngineViewModel()
    vm.axis(.slot(.hue), changedTo: 0.5)
    vm.axis(.layer(.scale), changedTo: -0.25)
    let w = vm.poll(0)!
    XCTAssertEqual(w.slots[.hue]!, 0.5, accuracy: 1e-6)
    XCTAssertEqual(w.layer[.scale]!, -0.25, accuracy: 1e-6, "layer axes go out on the layer channel")
    XCTAssertNil(vm.poll(0), "drained after poll — sliders assert on change only")
  }

  func testAxisRanges() {
    XCTAssertEqual(EngineViewModel.range(for: .slot(.hue)), -1.0...1.0)
    XCTAssertEqual(EngineViewModel.range(for: .slot(.saturation)), 0.0...1.0,
                   "sat is the one unipolar slot (spec §04 §1.2)")
    XCTAssertEqual(EngineViewModel.range(for: .layer(.rotate)), -1.0...1.0)
  }
  /// The webUI faders are `slider` widgets with `size 2, min −1` (BRIGHTNESS, HUE-SHIFT, ZOOM,
  /// rotate) or `size 1` (SATURATION); their number boxes show the INTERNAL value, so Max's
  /// "BRIGHTNESS 1." is raw 0.0 and "HUE 1.1" is raw 0.1. rotate is negated on its way into
  /// slot 6 (`* -1.`). (diagnosis doc, "The control vector actually in the screenshots")
  func testMaxPanelValueConvention() {
    XCTAssertEqual(EngineViewModel.maxPanelValue(for: .bias, raw: 0), 1.0, accuracy: 1e-9)
    XCTAssertEqual(EngineViewModel.maxPanelValue(for: .hue, raw: 0.1), 1.1, accuracy: 1e-9)
    XCTAssertEqual(EngineViewModel.maxPanelValue(for: .zoom, raw: -0.25), 0.75, accuracy: 1e-9)
    XCTAssertEqual(EngineViewModel.maxPanelValue(for: .theta, raw: 0.26092), 0.73908, accuracy: 1e-6)
    XCTAssertEqual(EngineViewModel.maxPanelValue(for: .saturation, raw: 0.5), 0.5, accuracy: 1e-9)
    XCTAssertEqual(EngineViewModel.maxPanelValue(for: .panX, raw: 0.3), 0.3, accuracy: 1e-9)
  }
  func testToggleEmitsEvent() {
    let vm = EngineViewModel()
    vm.setSInvert(true)
    XCTAssertEqual(vm.poll(0)?.toggles, [.sInvert(true)])
  }

  /// Review finding: `init` was seeding layerMode/erase/res/rate/sticker mirrors but never
  /// `sliderValues` — the panel's 7 primary sliders rendered at zero while the engine was
  /// already running the non-zero `applyStartupDefaults` vector, and the first touch of any
  /// slider would have snapped the render to the widget's stale zero. Pins that the mirror
  /// tracks `engine.router.rawSlots`, not this class's own zero literal.
  func testSliderValuesSeedFromLiveEngineStartupVector() throws {
    let engine = try Engine(context: try MetalContext())
    engine.router.applyStartupDefaults(at: 0)
    let vm = EngineViewModel(engine: engine)
    for slot: ControlSlot in [.hue, .bias, .panX, .panY, .zoom, .theta, .saturation] {
      XCTAssertEqual(vm.axisValues[.slot(slot)]!, Double(engine.router.rawSlots[slot.rawValue]),
                     accuracy: 1e-6, "slot \(slot) should mirror the startup vector, not zero")
    }
    XCTAssertEqual(vm.axisValues[.layer(.scale)]!, -0.253, accuracy: 1e-6, "layer channel seeds too")
  }

  /// Same gap, the recall path: after `recallPreset`, the sliders must show the PRESET's
  /// values, not whatever they last displayed.
  func testRecallPresetSeedsSliderValues() throws {
    let engine = try Engine(context: try MetalContext())
    engine.router.applyStartupDefaults(at: 0)
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let store = PresetStore(directory: dir)
    let vm = EngineViewModel(engine: engine, presetStore: store)

    var slots = [Float](repeating: 0, count: ControlSlot.allCases.count)
    slots[ControlSlot.hue.rawValue] = 0.3
    slots[ControlSlot.saturation.rawValue] = 0.9
    let preset = Preset(name: "known", slots: slots, eraseControl: 0.4,
                        toggles: PresetToggles(), layers: [])
    try store.save(preset)

    vm.recallPreset(named: "known")

    XCTAssertEqual(vm.axisValues[.slot(.hue)]!, 0.3, accuracy: 1e-6)
    XCTAssertEqual(vm.axisValues[.slot(.saturation)]!, 0.9, accuracy: 1e-6)
  }

  /// Final review, finding 4: three independent flip memories (`KeyboardTrackpadSurface`'s old
  /// per-key `toggleState`, `GamepadSurface`'s old per-button `buttonFlipState`, and this
  /// class's `@Published` mirrors) never reconciled with each other or with the router's own
  /// `sInvert`. Single source of truth now: a write applied to the router by ANY surface must
  /// show up in `EngineViewModel`'s mirror on its very next `poll`, AND `KeyboardTrackpadSurface`
  /// itself must compute its OWN next flip from that same, now-current truth — not a memory it
  /// kept locally from before this fix.
  func testTruthReconciliationAcrossKeyboardAndViewModelAfterAnExternalFlip() throws {
    let engine = try Engine(context: try MetalContext())
    engine.router.applyStartupDefaults(at: 0)
    let vm = EngineViewModel(engine: engine)
    XCTAssertFalse(vm.sInvertOn)

    // "flip SInvert via keyboard-style write to the router" — apply exactly the `ControlWrite`
    // ANY surface's `poll` could produce, bypassing `KeyboardTrackpadSurface` entirely (this
    // stands in for a gamepad press, a preset recall, or any other surface that owns the
    // router — the point is that it's NOT this view model, and NOT the keyboard surface below).
    engine.router.apply(ControlWrite(toggles: [.sInvert(true)]), at: 0)
    XCTAssertTrue(engine.router.sInvert < 0)

    // The view model has no pending write of its own this poll — but must still pick up truth.
    XCTAssertNil(vm.poll(0), "no pending slots/toggles of its own, so poll still returns nil")
    XCTAssertTrue(vm.sInvertOn, "mirror must reflect truth after the next poll, not stay stale")

    // Keyboard's next `i` press must compute the CORRECT next value — false, flipping OFF the
    // inversion an entirely different surface just turned ON — not `true` again, which is what
    // stale local per-key memory (still believing it had never been pressed) would have emitted.
    let keyboardSnapshot = ControlStateSnapshot(
      sInvert: { engine.router.sInvert < 0 },
      worldBumpEnabled: { engine.bumpsEnabled.world },
      waveBumpEnabled: { engine.bumpsEnabled.wave },
      imageBumpEnabled: { engine.bumpsEnabled.image },
      wave1Enabled: { engine.waveforms.wave1Enabled },
      wave2Enabled: { engine.waveforms.wave2Enabled },
      layerEnabled: { engine.sticker.layer.enabled })
    let keyboard = KeyboardTrackpadSurface(bindings: try BindingsLoader.load(from: nil),
                                           stateSnapshot: keyboardSnapshot)
    keyboard.keyDown("i")
    XCTAssertEqual(keyboard.poll(0)?.toggles, [.sInvert(false)],
                   "keyboard computes its next flip from live truth, not stale local memory")
  }

  func testWarpFilterMirrorsSetter() {
    let vm = EngineViewModel()
    XCTAssertEqual(vm.warpFilter, .nearest)
    vm.setWarpFilter(.linear)
    XCTAssertEqual(vm.warpFilter, .linear)
  }

  func testPollDoesNotRepublishWhenNothingChanged() throws {
    let engine = try Engine(context: try MetalContext())
    let vm = EngineViewModel(engine: engine, presetStore: PresetStore())
    var publishCount = 0
    let subscription = vm.objectWillChange.sink { _ in publishCount += 1 }
    defer { subscription.cancel() }

    _ = vm.poll(0)          // first poll may legitimately publish (mirrors sync to truth)
    publishCount = 0
    _ = vm.poll(1)
    _ = vm.poll(2)
    XCTAssertEqual(publishCount, 0,
                   "an idle frame must not re-render the operator panel")
  }

  func testPollStillPublishesWhenTruthChanges() throws {
    let engine = try Engine(context: try MetalContext())
    let vm = EngineViewModel(engine: engine, presetStore: PresetStore())
    _ = vm.poll(0)
    var publishCount = 0
    let subscription = vm.objectWillChange.sink { _ in publishCount += 1 }
    defer { subscription.cancel() }

    engine.waveforms.wave1Enabled = !engine.waveforms.wave1Enabled
    _ = vm.poll(1)
    XCTAssertGreaterThan(publishCount, 0, "a real change still reaches the panel")
    XCTAssertEqual(vm.wave1On, engine.waveforms.wave1Enabled)
  }

  /// Spec §7: the pad dot and every slider follow the router — a trackpad gesture or a preset
  /// moves them. `poll` refreshes the axis mirrors from truth exactly like the toggle mirrors.
  func testAxisMirrorsFollowRouterTruth() throws {
    let engine = try Engine(context: try MetalContext())
    engine.router.applyStartupDefaults(at: 0)
    let vm = EngineViewModel(engine: engine)
    engine.router.apply(ControlWrite(slots: [.panX: 0.4], layer: [.x: -0.6]), at: 0)   // some other surface
    _ = vm.poll(0)
    XCTAssertEqual(vm.axisValues[.slot(.panX)]!, 0.4, accuracy: 1e-6)
    XCTAssertEqual(vm.axisValues[.layer(.x)]!, -0.6, accuracy: 1e-6)
  }

  /// The same optimistic reapply toggles get: a slider being dragged must not flicker back to
  /// the pre-drag truth for the one tick before the router applies its write.
  func testOwnPendingWriteSurvivesTheTruthRefresh() throws {
    let engine = try Engine(context: try MetalContext())
    engine.router.applyStartupDefaults(at: 0)
    let vm = EngineViewModel(engine: engine)
    vm.axis(.slot(.hue), changedTo: 0.9)
    let w = vm.poll(0)
    XCTAssertEqual(w?.slots[.hue], 0.9)
    XCTAssertEqual(vm.axisValues[.slot(.hue)]!, 0.9, accuracy: 1e-6, "mirror shows the drag, not the stale truth")
  }

  func testPadsDefaultToTheOriginalLayoutWithoutAStore() {
    XCTAssertEqual(EngineViewModel().bindings.pads, Bindings.defaultPads)
  }

  func testSetPadAxisUpdatesTheMirrorAndPersistsThroughTheStore() throws {
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let file = dir.appendingPathComponent("Bindings.json")
    let store = try BindingsStore(userFileURL: file)
    let vm = EngineViewModel(bindingsStore: store)
    vm.setPadAxis(pad: 1, .y, to: .slot(.zoom))
    XCTAssertEqual(vm.bindings.pads[1], PadAssignment(x: .slot(.panX), y: .slot(.zoom)))
    XCTAssertEqual(try BindingsStore(userFileURL: file).bindings.pads[1].y, .slot(.zoom), "written to disk")
    try? FileManager.default.removeItem(at: dir)
  }
}
