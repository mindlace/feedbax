import XCTest
@testable import FeedbaxKit

/// Spec §6.6: `~/Library/Application Support/Feedbax/Bindings.json` wins over the bundled
/// default; pad reassignment writes the whole table back so hand edits survive.
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
}
