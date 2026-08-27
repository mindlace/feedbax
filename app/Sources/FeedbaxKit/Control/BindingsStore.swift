import Foundation

/// The performer's own file as an OVERLAY over the bundled table (design §6.6): `version` plus
/// any subset of `pads` / `keys` / `trackpad`. Each section the file supplies REPLACES the
/// bundled one wholesale; each section it omits keeps flowing from `DefaultBindings.json`.
///
/// Why this shape rather than the whole `Bindings` struct: `save` used to round-trip the
/// entire table, so the first time a performer touched a pad picker, the app's key table,
/// gesture rows and every `sensitivity` were frozen into their file forever — a later fix to
/// the bundled defaults (a flipped gesture sign, a new key) could never reach them again. That
/// is exactly what bit the Task 12 run pass. An overlay persists only what the performer
/// actually changed, so the parts they never touched stay the app's to improve.
///
/// **No migration needed for the old format.** A full-table file written by the previous
/// `save` — `version`, `keys`, `trackpad`, `pads`, all present — is simply an overlay in which
/// every section happens to be supplied, so it decodes as-is and keeps behaving exactly as it
/// did (its hand edits still win, and `save` writes all four sections back).
///
/// Sections are validated with the same helpers `Bindings`' own codec uses
/// (`Bindings.checkVersion` / `toggleEvents(fromMarkers:)` / `rejectDuplicateRows` /
/// `requireTwoPads`, Bindings.swift), so a rule can't hold for a full table and quietly not
/// hold for an overlay.
public struct BindingsOverlay: Equatable {
  public var version: Int
  public var pads: [PadAssignment]?
  public var keys: [String: ToggleEvent]?
  public var trackpad: [TrackpadBinding]?

  public init(version: Int = Bindings.currentVersion, pads: [PadAssignment]? = nil,
              keys: [String: ToggleEvent]? = nil, trackpad: [TrackpadBinding]? = nil) {
    self.version = version
    self.pads = pads
    self.keys = keys
    self.trackpad = trackpad
  }

  /// `base` with every section this overlay supplies swapped in. Section-level, not
  /// row-level: a `keys` table in the user file is the whole key table, not additions to the
  /// bundled one — the same "modifiers select a row, they don't stack" plainness the bindings
  /// table has everywhere else (design §6.1).
  public func applied(to base: Bindings) -> Bindings {
    var result = base
    if let pads { result.pads = pads }
    if let keys { result.keys = keys }
    if let trackpad { result.trackpad = trackpad }
    return result
  }
}

extension BindingsOverlay: Codable {
  public init(from decoder: Decoder) throws {
    let c = try decoder.container(keyedBy: Bindings.CodingKeys.self)
    version = try c.decode(Int.self, forKey: .version)
    try Bindings.checkVersion(version, forKey: .version, in: c)
    if let raw = try c.decodeIfPresent([String: String].self, forKey: .keys) {
      keys = try Bindings.toggleEvents(fromMarkers: raw, forKey: .keys, in: c)
    }
    if let rows = try c.decodeIfPresent([TrackpadBinding].self, forKey: .trackpad) {
      try Bindings.rejectDuplicateRows(rows, forKey: .trackpad, in: c)
      trackpad = rows
    }
    if let assignments = try c.decodeIfPresent([PadAssignment].self, forKey: .pads) {
      try Bindings.requireTwoPads(assignments, forKey: .pads, in: c)
      pads = assignments
    }
  }

  public func encode(to encoder: Encoder) throws {
    var c = encoder.container(keyedBy: Bindings.CodingKeys.self)
    try c.encode(version, forKey: .version)
    if let keys { try c.encode(Bindings.markers(from: keys), forKey: .keys) }
    try c.encodeIfPresent(trackpad, forKey: .trackpad)
    try c.encodeIfPresent(pads, forKey: .pads)
  }
}

/// Where the bindings table actually comes from (design §6.6): the bundled
/// `DefaultBindings.json`, with the performer's own file under Application Support applied
/// over it as a `BindingsOverlay`. "The bindings table is data, not code" (design §5) only
/// means something if the data can be edited without a rebuild — and pad reassignment from the
/// operator panel has to land somewhere that survives a relaunch.
///
/// `save` writes back the pads plus ONLY the sections the user file itself supplied, tracked
/// in `userSupplied`. A hand-authored venue file keeps its hand-authored sections; a file that
/// only ever held pads stays pads-only, and every bundled-default change keeps reaching it.
/// Bindings are read once at bootstrap; hot reload while running is out of scope (design §11).
public final class BindingsStore {
  public private(set) var bindings: Bindings
  private let userFileURL: URL?
  /// Which sections the user file was found carrying — the sections `save` must write back so
  /// a hand edit isn't silently dropped by the very save that persists a pad move.
  private var userSupplied: (keys: Bool, trackpad: Bool) = (false, false)

  /// `~/Library/Application Support/Feedbax/Bindings.json` — beside `PresetStore`'s `Presets/`.
  public static var defaultUserFileURL: URL {
    let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    return support.appendingPathComponent("Feedbax", isDirectory: true)
      .appendingPathComponent("Bindings.json")
  }

  /// Loads the bundled table, then applies the user file's overlay when there is one. A user
  /// file that exists but fails to decode THROWS — a broken venue file must be a loud failure
  /// at startup, not a silent fallback to defaults the performer didn't ask for. `nil` means
  /// bundled only and makes `save` a no-op (tests, and any caller that wants a read-only table).
  public init(userFileURL: URL?) throws {
    self.userFileURL = userFileURL
    var table = try BindingsLoader.load(from: nil)
    if let userFileURL, FileManager.default.fileExists(atPath: userFileURL.path) {
      let overlay = try JSONDecoder().decode(BindingsOverlay.self,
                                             from: try Data(contentsOf: userFileURL))
      table = overlay.applied(to: table)
      userSupplied = (keys: overlay.keys != nil, trackpad: overlay.trackpad != nil)
    }
    bindings = table
  }

  /// For callers that already hold a table (tests). Nothing was read from a user file, so
  /// `save` writes a pads-only overlay.
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

  /// `.atomic` — a write interrupted midway (crash, full disk, power) would otherwise leave a
  /// truncated file, and `init` deliberately refuses to start on a file it can't decode, so a
  /// half-written save would brick the next launch rather than degrade it.
  public func save() throws {
    guard let userFileURL else { return }
    try FileManager.default.createDirectory(at: userFileURL.deletingLastPathComponent(),
                                            withIntermediateDirectories: true)
    let overlay = BindingsOverlay(version: bindings.version,
                                  pads: bindings.pads,
                                  keys: userSupplied.keys ? bindings.keys : nil,
                                  trackpad: userSupplied.trackpad ? bindings.trackpad : nil)
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    try encoder.encode(overlay).write(to: userFileURL, options: .atomic)
  }
}
