import XCTest
import simd
@testable import FeedbaxKit

final class PresetTests: XCTestCase {
  func testStartupVectorIsTheMeasuredSteadyState() {
    // NOT the webui `loadbang` list (obj-89). That list is superseded 137 ms after load by
    // `r ctrlbang` re-emitting the webUI pack at frame rate and by the `loadbang -> pipe
    // 1500` button burst, and never returns. These 9 floats are the measured steady state on
    // `s shadeCtl` in the running patch, identical across three launches — see
    // `ControlRouter.startupVector`'s doc comment before "fixing" this back.
    XCTAssertEqual(ControlRouter.startupVector,
                   [0.1, 0.0, 0.0, 0.0, 0.0, -0.25, 0.26092064967168305, 0.0, 0.5])
    let r = ControlRouter()
    r.applyStartupDefaults(at: 0)
    XCTAssertEqual(r.rawSlots, ControlRouter.startupVector)
    XCTAssertEqual(r.eraseControl, 1.0, "TRANSPARANCY persisted 1.0 → hard clear until moved (spec §04 §1.4)")
  }
  func testPresetRoundTripsThroughJSON() throws {
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let store = PresetStore(directory: dir)
    let preset = Preset(name: "saturday", slots: ControlRouter.startupVector, eraseControl: 0.6,
                        toggles: PresetToggles(sInvert: true, worldBump: false, waveBump: true,
                                               kittyBump: false, wave1: true, wave2: false, layerEnabled: true),
                        layers: [PresetLayer(id: "sticker", sourceSelection: .stickerIndex(3),
                                             transform: LayerTransform(position: SIMD2(0.2, -0.1),
                                                                       scale: SIMD2(0.747, 0.747),
                                                                       rotationZDegrees: 15),
                                             settings: LayerSettings(zOrder: 2, enabled: true),
                                             filters: [])])
    try store.save(preset)
    XCTAssertEqual(store.list(), ["saturday"])
    XCTAssertEqual(try store.load(name: "saturday"), preset)
  }

  /// Final review, minor finding 6: `testPresetRoundTripsThroughJSON` above encodes and decodes
  /// through the SAME struct, so it stays green through a coordinated rename of a
  /// `PresetToggles` field — it can't tell "the field is called `kittyBump`" from "whatever
  /// `PresetToggles` calls its bump field round-trips." The bindings markers
  /// (`"layerEnabled"`/`"kittyBumpEnabled"`) have a test guard for their frozen spelling; this
  /// one, guarding `PresetToggles`' OWN frozen field names (2026-08-29 design doc §4's other
  /// frozen name), did not. This decodes a hand-written JSON literal — standing in for a preset
  /// file saved before this change — so it fails if `kittyBump` or `layerEnabled` is ever
  /// renamed, independent of whatever `PresetToggles` currently encodes.
  func testPresetTogglesDecodesPreExistingJSONWithFrozenFieldNames() throws {
    let json = """
    {
      "sInvert": true,
      "worldBump": false,
      "waveBump": true,
      "kittyBump": true,
      "wave1": false,
      "wave2": true,
      "layerEnabled": true
    }
    """
    let toggles = try JSONDecoder().decode(PresetToggles.self, from: Data(json.utf8))
    XCTAssertTrue(toggles.sInvert)
    XCTAssertFalse(toggles.worldBump)
    XCTAssertTrue(toggles.waveBump)
    XCTAssertTrue(toggles.kittyBump, "the frozen \"kittyBump\" key must still decode into kittyBump")
    XCTAssertFalse(toggles.wave1)
    XCTAssertTrue(toggles.wave2)
    XCTAssertTrue(toggles.layerEnabled, "the frozen \"layerEnabled\" key must still decode into layerEnabled")
  }

  /// Recall glides EVERYTHING now: the 9 slots through the slot ramps (as before) and the layer
  /// placement through the router's layer channel (design §4) — never by poking
  /// `layer.transform`, which `Engine.step` overwrites from `router.layerTransform` on the very
  /// next frame anyway. Settings (z-order/enable) still restore directly.
  func testApplyRecallsSlotsAndLayerPlacementThroughTheRouter() throws {
    final class FakeLayer: SeedSource {
      let id = "sticker"; var transform = LayerTransform(); var layer = LayerSettings()
      func tick(_ frame: FrameContext) -> MTLTexture? { nil }
    }
    let router = ControlRouter()
    _ = router.tick(at: 0)                       // ramps at rest
    let layer = FakeLayer()
    let preset = Preset(name: "p", slots: [1, 0, 0, 0, 0, 0, 0, 0, 0], eraseControl: 0.3,
                        toggles: PresetToggles(), layers: [
                          PresetLayer(id: "sticker", sourceSelection: .stickerIndex(0),
                                      transform: LayerTransform(position: SIMD2(0.85, 0), scale: SIMD2(1, 1),
                                                                rotationZDegrees: 90),
                                      settings: LayerSettings(zOrder: 2, enabled: true), filters: [])])
    PresetStore.apply(preset, router: router, layers: [layer], at: 1.0)
    XCTAssertEqual(router.rawSlots[0], 1)
    XCTAssertEqual(router.rawLayer, [0.5, 0, 0, 0.5], "inverse-mapped into the layer channel")
    XCTAssertTrue(layer.layer.enabled, "settings restore directly")
    XCTAssertEqual(layer.transform, LayerTransform(), "transform is NOT written directly — Engine.step does that")
    // Recall RAMPS (design §5 Presets — glide, not snap): 10 ms in, both hue and x are mid-flight.
    let mid = router.tick(at: 1.010)
    let midX = router.layerTransform.position.x
    let settled = router.tick(at: 1.2)
    XCTAssertNotEqual(mid.hueShift, settled.hueShift, accuracy: 1e-5)
    XCTAssertNotEqual(midX, 0.85, accuracy: 1e-3)
    XCTAssertEqual(router.layerTransform.position.x, 0.85, accuracy: 1e-3)
    XCTAssertEqual(router.layerTransform.rotationZDegrees, 90, accuracy: 1e-2)
  }
}
