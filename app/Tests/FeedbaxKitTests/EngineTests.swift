import XCTest
import Foundation
import simd
@testable import FeedbaxKit

/// Task 19: the assembled instrument — `Engine` wires router → audio → sources → core into
/// one per-frame `step`. The determinism test is the gate the golden-frame harness (Task 22)
/// stands on: two engines fed the same injected clock must land on byte-identical pixels,
/// which only holds if nothing in the frame recipe reaches for a live clock, a live mic, or
/// any other non-injected source of variance.
final class EngineTests: XCTestCase {
  func testDeterministicHeadlessRun() throws {
    // Two engines, same injected clock and inputs → byte-identical accumulators after 30 frames.
    // This is the property the golden harness (Task 22) stands on.
    let ctx = try MetalContext()
    func run() throws -> [SIMD4<Float>] {
      let e = try Engine(context: ctx)
      e.router.applyStartupDefaults(at: 0)
      e.setResolution(SIMD2(64, 36))
      var last: MTLTexture!
      for i in 0..<30 {
        let cb = ctx.queue.makeCommandBuffer()!
        last = e.step(at: Double(i) / 60, commandBuffer: cb)
        cb.commit(); cb.waitUntilCompleted(); ctx.pool.endFrame()
      }
      return ctx.readPixels(last)
    }
    let a = try run(), b = try run()
    for i in 0..<a.count { XCTAssertEqual(a[i], b[i], "pixel \(i) diverged") }
  }
  func testResolutionPresetListMatchesSpec() {
    XCTAssertEqual(Engine.resolutionPresets.count, 14)          // Constants table
    XCTAssertTrue(Engine.resolutionPresets.contains(SIMD2(7680, 4320)))
    XCTAssertEqual(Engine.frameRatePresets, [30, 60, 90, 100, 120], "five, not four (spec §01 §1)")
  }
  func testWorldBumpGateDefaultsOff() throws {
    let e = try Engine(context: try MetalContext())
    XCTAssertFalse(e.bumpsEnabled.world); XCTAssertFalse(e.bumpsEnabled.wave)
    XCTAssertFalse(e.bumpsEnabled.kitty)   // spec §03 §7 — all three default OFF
  }

  /// Fix-review item 9a: the kitty offset (`step`'s stage 3) is an ADDITIVE, non-persistent
  /// modulator contribution — it must not still be sitting on `sticker.transform` once `step`
  /// has returned. Injects real audio each frame (not silence) so the offset being asserted
  /// away is actually nonzero, not trivially zero either way.
  func testKittyOffsetDoesNotAccumulate() throws {
    let ctx = try MetalContext()
    let e = try Engine(context: ctx)
    e.bumpsEnabled.kitty = true
    let restTransform = e.sticker.transform
    for i in 0..<2 {
      // A fresh burst of the 46.7 Hz band every frame — `AudioBands.frameValues()` (called
      // inside `step`) resets the "since last frame" accumulator on every call, so without a
      // fresh `ingest` here, the second frame's `kittyBumpRaw` would just be zero regardless
      // of whether the restore this test is checking for is present.
      e.bands.ingest(sine(46.7, seconds: 0.05, sampleRate: 48000, amplitude: 0.8))
      let cb = ctx.queue.makeCommandBuffer()!
      _ = e.step(at: Double(i) / 60, commandBuffer: cb)
      cb.commit(); cb.waitUntilCompleted(); ctx.pool.endFrame()
      XCTAssertEqual(e.sticker.transform, restTransform,
                     "frame \(i): kitty's additive offset must not persist past the step it was applied in")
    }
  }

  /// Fix-review item 9b (and item 3 — presets previously dropped `layerMode` entirely, a gap
  /// the Task 19 report incorrectly claimed was already closed). Round-trips layer mode, a
  /// bump enable, and the sticker's selected index through `capturePreset`/`applyPreset`.
  func testPresetRoundTripsLayerModeBumpsAndSourceSelection() throws {
    // `Engine.init` resolves its sticker folder against the process's CURRENT WORKING
    // DIRECTORY (its own doc comment) — point that at a temp fixture folder so
    // `sticker.selectedIndex` has a real second item to select/restore. The ambient
    // directory `swift test` happens to run from has no guaranteed `input/` folder to test
    // this against otherwise.
    let originalCwd = FileManager.default.currentDirectoryPath
    let tempRoot = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let stickerFolder = tempRoot.appendingPathComponent("input/transparent-background")
    try FileManager.default.createDirectory(at: stickerFolder, withIntermediateDirectories: true)
    // Content doesn't need to be a valid image: `StickerSource.scan()` filters by extension
    // only, and `selectedIndex` is recorded regardless of whether the decode behind it
    // succeeds — this test cares about the INDEX round-tripping, not the pixels.
    try Data([0]).write(to: stickerFolder.appendingPathComponent("a.png"))
    try Data([0]).write(to: stickerFolder.appendingPathComponent("b.png"))
    XCTAssertTrue(FileManager.default.changeCurrentDirectoryPath(tempRoot.path))
    defer { FileManager.default.changeCurrentDirectoryPath(originalCwd) }

    let e = try Engine(context: try MetalContext())
    XCTAssertEqual(e.sticker.itemCount, 2, "fixture folder must actually resolve via cwd")

    e.layerMode = .movie
    e.bumpsEnabled.world = true
    e.sticker.selectedIndex = 1

    let preset = e.capturePreset(name: "roundtrip")
    XCTAssertEqual(preset.layerMode, "movie", "capturePreset must record layer mode")

    // Mutate every captured field away from what was captured, so recall — not coincidence
    // — is what has to put it back.
    e.layerMode = .sticker
    e.bumpsEnabled.world = false
    e.sticker.selectedIndex = 0

    e.applyPreset(preset, at: 0)

    XCTAssertEqual(e.layerMode, .movie, "layerMode restored (previously silently dropped)")
    XCTAssertTrue(e.bumpsEnabled.world, "bump enable restored")
    XCTAssertEqual(e.sticker.selectedIndex, 1, "sticker source selection restored")
  }
}
