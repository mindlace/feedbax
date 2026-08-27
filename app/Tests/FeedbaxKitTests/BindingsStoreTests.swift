import XCTest
@testable import FeedbaxKit

/// Spec §6.6: `~/Library/Application Support/Feedbax/Bindings.json` is an OVERLAY over the
/// bundled default — each section it supplies replaces the bundled one, the rest keep flowing
/// from the app — and `save` writes back only the pads plus whatever sections the file itself
/// already carried.
final class BindingsStoreTests: XCTestCase {
  private var userFile: URL!

  override func setUpWithError() throws {
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    userFile = dir.appendingPathComponent("Bindings.json")
  }

  override func tearDownWithError() throws {
    try? FileManager.default.removeItem(at: userFile.deletingLastPathComponent())
  }

  func testMissingUserFileFallsBackToTheBundledDefault() throws {
    let store = try BindingsStore(userFileURL: userFile)
    XCTAssertEqual(store.bindings, try BindingsLoader.load(from: nil))
    XCTAssertFalse(FileManager.default.fileExists(atPath: userFile.path), "reading never creates the file")
  }

  func testNilUserFileMeansBundledOnlyAndSaveIsANoOp() throws {
    let store = try BindingsStore(userFileURL: nil)
    XCTAssertNoThrow(try store.setPads(Bindings.defaultPads.reversed()))
    XCTAssertEqual(store.bindings.pads, Bindings.defaultPads.reversed(), "in-memory change still applies")
  }

  func testUserFileWinsOverTheBundledDefault() throws {
    var custom = try BindingsLoader.load(from: nil)
    custom.keys["q"] = .sInvert(true)
    try FileManager.default.createDirectory(at: userFile.deletingLastPathComponent(), withIntermediateDirectories: true)
    try JSONEncoder().encode(custom).write(to: userFile)
    let store = try BindingsStore(userFileURL: userFile)
    XCTAssertEqual(store.bindings.keys["q"], .sInvert(true))
  }

  func testABrokenUserFileIsALoudFailureNotASilentFallback() throws {
    try FileManager.default.createDirectory(at: userFile.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("{\"version\": 1}".utf8).write(to: userFile)
    XCTAssertThrowsError(try BindingsStore(userFileURL: userFile))
  }

  func testSetPadsPersistsAndPreservesHandEditedRows() throws {
    var custom = try BindingsLoader.load(from: nil)
    custom.keys["q"] = .sInvert(true)
    try FileManager.default.createDirectory(at: userFile.deletingLastPathComponent(), withIntermediateDirectories: true)
    try JSONEncoder().encode(custom).write(to: userFile)

    let store = try BindingsStore(userFileURL: userFile)
    let swapped = [PadAssignment(x: .slot(.hue), y: .slot(.bias)), Bindings.defaultPads[1]]
    try store.setPads(swapped)

    let reloaded = try BindingsStore(userFileURL: userFile)
    XCTAssertEqual(reloaded.bindings.pads, swapped)
    XCTAssertEqual(reloaded.bindings.keys["q"], .sInvert(true), "the hand-edited key survived the round trip")
    XCTAssertEqual(reloaded.bindings.trackpad, custom.trackpad, "gesture rows untouched, in order")
  }

  func testSaveCreatesTheDirectory() throws {
    let store = try BindingsStore(userFileURL: userFile)
    try store.save()
    XCTAssertTrue(FileManager.default.fileExists(atPath: userFile.path))
  }

  // MARK: - Overlay semantics (final-review finding 3)

  /// Writes `json` to the user file, creating its directory.
  private func writeUserFile(_ json: String) throws {
    try FileManager.default.createDirectory(at: userFile.deletingLastPathComponent(),
                                            withIntermediateDirectories: true)
    try Data(json.utf8).write(to: userFile)
  }

  /// The written file's top-level JSON keys — what `save` actually chose to persist.
  private func userFileKeys() throws -> Set<String> {
    let object = try JSONSerialization.jsonObject(with: Data(contentsOf: userFile))
    return Set((object as! [String: Any]).keys)
  }

  /// The bug this replaces: one pad reassignment froze the WHOLE bundled table in the user
  /// file, so a later fix to `DefaultBindings.json` (a gesture sign, a new key) never reached
  /// a performer who had ever touched a pad picker.
  func testAPadsOnlyUserFileStillTakesKeysAndGesturesFromTheBundledDefault() throws {
    try writeUserFile("""
      { "version": 2, "pads": [{"x": "hue", "y": "bias"}, {"x": "panX", "y": "panY"}] }
      """)
    let store = try BindingsStore(userFileURL: userFile)
    let bundled = try BindingsLoader.load(from: nil)
    XCTAssertEqual(store.bindings.pads[0], PadAssignment(x: .slot(.hue), y: .slot(.bias)),
                   "the section the file supplies wins")
    XCTAssertEqual(store.bindings.keys, bundled.keys, "and every section it doesn't keeps flowing")
    XCTAssertEqual(store.bindings.trackpad, bundled.trackpad)
  }

  /// A performer who only ever moved a pad picker gets a pads-only file — nothing else is
  /// frozen, so bundled-default changes keep arriving.
  func testSetPadsOnAFreshStoreWritesOnlyVersionAndPads() throws {
    let store = try BindingsStore(userFileURL: userFile)
    try store.setPads([PadAssignment(x: .slot(.hue), y: .slot(.bias)), Bindings.defaultPads[1]])
    XCTAssertEqual(try userFileKeys(), ["version", "pads"],
                   "no keys/trackpad section: nothing the performer never edited is pinned")
    XCTAssertEqual(try BindingsStore(userFileURL: userFile).bindings.pads[0],
                   PadAssignment(x: .slot(.hue), y: .slot(.bias)))
  }

  /// A hand-authored venue file keeps its hand-authored sections — and gains no new ones.
  func testAHandAuthoredKeysFileKeepsItsKeysAndGainsNoTrackpadSection() throws {
    try writeUserFile("""
      { "version": 2, "keys": { "z": "sInvert" } }
      """)
    let store = try BindingsStore(userFileURL: userFile)
    XCTAssertEqual(store.bindings.keys, ["z": .sInvert(true)], "a keys section REPLACES the bundled one")
    try store.setPads(Bindings.defaultPads.reversed())

    XCTAssertEqual(try userFileKeys(), ["version", "keys", "pads"],
                   "the trackpad table stays the app's to change")
    let reloaded = try BindingsStore(userFileURL: userFile)
    XCTAssertEqual(reloaded.bindings.keys, ["z": .sInvert(true)])
    XCTAssertEqual(reloaded.bindings.pads, Bindings.defaultPads.reversed())
    XCTAssertEqual(reloaded.bindings.trackpad, try BindingsLoader.load(from: nil).trackpad)
  }

  /// The old `save` wrote the whole `Bindings`; such a file is simply an overlay with every
  /// section present, so it needs no migration — it keeps behaving exactly as it did.
  func testAnOldFormatFullTableFileLoadsAndItsGesturesWin() throws {
    var custom = try BindingsLoader.load(from: nil)
    custom.trackpad = [TrackpadBinding(gesture: .pinch, modifiers: [],
                                       target: .single(TrackpadAxis(axis: .slot(.zoom), sensitivity: -1)))]
    try FileManager.default.createDirectory(at: userFile.deletingLastPathComponent(),
                                            withIntermediateDirectories: true)
    try JSONEncoder().encode(custom).write(to: userFile)

    let store = try BindingsStore(userFileURL: userFile)
    XCTAssertEqual(store.bindings.trackpad, custom.trackpad, "one row, not the bundled ten")
    try store.setPads(Bindings.defaultPads.reversed())
    XCTAssertEqual(try userFileKeys(), ["version", "keys", "trackpad", "pads"],
                   "every section it supplied is written back")
    XCTAssertEqual(try BindingsStore(userFileURL: userFile).bindings.trackpad, custom.trackpad)
  }

  func testAnOverlayWithTheWrongVersionThrows() throws {
    try writeUserFile("""
      { "version": 3, "pads": [{"x": "hue", "y": "bias"}, {"x": "panX", "y": "panY"}] }
      """)
    XCTAssertThrowsError(try BindingsStore(userFileURL: userFile))
  }

  func testAnOverlayWithThreePadsThrows() throws {
    try writeUserFile("""
      { "version": 2, "pads": [{"x": "hue", "y": "bias"}, {"x": "panX", "y": "panY"},
                               {"x": "zoom", "y": "theta"}] }
      """)
    XCTAssertThrowsError(try BindingsStore(userFileURL: userFile))
  }

  /// Same rule `Bindings` itself enforces: two rows for one (gesture, modifiers) would make
  /// `trackpadBinding(for:)` silently pick the first.
  func testAnOverlayWithDuplicateTrackpadRowsThrows() throws {
    try writeUserFile("""
      { "version": 2, "trackpad": [
          {"gesture": "pinch", "modifiers": [], "axis": {"axis": "zoom", "sensitivity": 1.0}},
          {"gesture": "pinch", "modifiers": [], "axis": {"axis": "saturation", "sensitivity": 1.0}}
      ] }
      """)
    XCTAssertThrowsError(try BindingsStore(userFileURL: userFile))
  }

  /// An unknown toggle marker in an overlay's `keys` is rejected the same way `Bindings`'
  /// own codec rejects it — the shared key codec, not a second copy that could drift.
  func testAnOverlayWithAnUnknownToggleMarkerThrows() throws {
    try writeUserFile("""
      { "version": 2, "keys": { "z": "notAToggle" } }
      """)
    XCTAssertThrowsError(try BindingsStore(userFileURL: userFile))
  }
}
