import XCTest
import Foundation
@testable import FeedbaxKit

final class EngineViewModelTests: XCTestCase {
  func testSliderWritesAreAssertedOnceThenDrained() {
    let vm = EngineViewModel()
    vm.slider(.hue, changedTo: 0.5)
    let w = vm.poll(0)!
    XCTAssertEqual(w.slots[.hue]!, 0.5, accuracy: 1e-6)
    XCTAssertNil(vm.poll(0)?.slots[.hue], "drained after poll — sliders assert on change only")
  }
  func testSliderRanges() {
    XCTAssertEqual(EngineViewModel.range(for: .hue), -1.0...1.0)
    XCTAssertEqual(EngineViewModel.range(for: .saturation), 0.0...1.0,
                   "sat is the one unipolar slot (spec §04 §1.2)")
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
      XCTAssertEqual(vm.sliderValues[slot]!, Double(engine.router.rawSlots[slot.rawValue]),
                     accuracy: 1e-6, "slot \(slot) should mirror the startup vector, not zero")
    }
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

    XCTAssertEqual(vm.sliderValues[.hue]!, 0.3, accuracy: 1e-6)
    XCTAssertEqual(vm.sliderValues[.saturation]!, 0.9, accuracy: 1e-6)
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
      kittyBumpEnabled: { engine.bumpsEnabled.kitty },
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
}
