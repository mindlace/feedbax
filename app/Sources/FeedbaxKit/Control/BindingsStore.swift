import Foundation

/// Where the bindings table actually comes from (design §6.6): the performer's own file under
/// Application Support if there is one, else the bundled `DefaultBindings.json`. "The
/// bindings table is data, not code" (design §5) only means something if the data can be
/// edited without a rebuild — and pad reassignment from the operator panel has to land
/// somewhere that survives a relaunch.
///
/// `save` round-trips the WHOLE `Bindings` struct, so a hand-edited key or gesture row in the
/// user file is preserved when the panel changes a pad. Bindings are read once at bootstrap;
/// hot reload while running is out of scope (design §11).
public final class BindingsStore {
  public private(set) var bindings: Bindings
  private let userFileURL: URL?

  /// `~/Library/Application Support/Feedbax/Bindings.json` — beside `PresetStore`'s `Presets/`.
  public static var defaultUserFileURL: URL {
    let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    return support.appendingPathComponent("Feedbax", isDirectory: true)
      .appendingPathComponent("Bindings.json")
  }

  /// Loads the user file when it exists, else the bundled default. A user file that exists but
  /// fails to decode THROWS — a broken venue file must be a loud failure at startup, not a
  /// silent fallback to defaults the performer didn't ask for. `nil` means bundled only and
  /// makes `save` a no-op (tests, and any caller that wants a read-only table).
  public init(userFileURL: URL?) throws {
    self.userFileURL = userFileURL
    if let userFileURL, FileManager.default.fileExists(atPath: userFileURL.path) {
      bindings = try BindingsLoader.load(from: userFileURL)
    } else {
      bindings = try BindingsLoader.load(from: nil)
    }
  }

  /// For callers that already hold a table (tests).
  public init(bindings: Bindings, userFileURL: URL?) {
    self.bindings = bindings
    self.userFileURL = userFileURL
  }

  /// The one mutation the operator panel makes (design §7). Applies in memory first so a save
  /// failure (read-only disk) still leaves the running instrument on the new assignment.
  public func setPads(_ pads: [PadAssignment]) throws {
    bindings.pads = pads
    try save()
  }

  public func save() throws {
    guard let userFileURL else { return }
    try FileManager.default.createDirectory(at: userFileURL.deletingLastPathComponent(),
                                            withIntermediateDirectories: true)
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    try encoder.encode(bindings).write(to: userFileURL)
  }
}
