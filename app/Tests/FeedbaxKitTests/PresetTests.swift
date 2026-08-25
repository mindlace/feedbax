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
  func testApplyRestoresSlotsRampedAndTransformsDirectly() throws {
    final class FakeLayer: SeedSource {
      let id = "sticker"; var transform = LayerTransform(); var layer = LayerSettings()
      func tick(_ frame: FrameContext) -> MTLTexture? { nil }
    }
    let router = ControlRouter()
    _ = router.tick(at: 0)                       // ramps at rest on slot value 0
    let layer = FakeLayer()
    let preset = Preset(name: "p", slots: [1, 0, 0, 0, 0, 0, 0, 0, 0], eraseControl: 0.3,
                        toggles: PresetToggles(), layers: [
                          PresetLayer(id: "sticker", sourceSelection: .stickerIndex(0),
                                      transform: LayerTransform(position: SIMD2(0.5, 0), scale: SIMD2(1, 1),
                                                                rotationZDegrees: 0),
                                      settings: LayerSettings(zOrder: 2, enabled: true), filters: [])])
    PresetStore.apply(preset, router: router, layers: [layer], at: 1.0)
    XCTAssertEqual(router.rawSlots[0], 1)
    XCTAssertEqual(layer.transform.position.x, 0.5, "transforms restore directly")
    // Recall RAMPS (design §5 Presets — glide, not snap): 10 ms in, hue is mid-flight.
    let mid = router.tick(at: 1.010)
    let settled = router.tick(at: 1.2)
    XCTAssertNotEqual(mid.hueShift, settled.hueShift, accuracy: 1e-5)
  }
}
