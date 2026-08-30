import Foundation
import CoreGraphics
import ImageIO
import Metal
import simd

/// The "picsvid" still-image source: scans a folder, decodes whichever file is currently
/// selected, and hands the compositor a texture for it (design §"SeedSource"; spec §02 §1's
/// `movsFound`-style folder enumeration, image half only — movies are `MovieSource`, Task 16).
///
/// Decode happens on **selection**, never in `tick` (design §5; spec §02 §3): flipping
/// through 40 stickers should cost 40 decodes total, not 40 decodes per second. `tick` only
/// ever returns whatever `selectedIndex`'s setter already put in `cachedTexture` — swapping a
/// sticker is a UI action, not a render-loop cost, and the identity check in
/// `testSelectionDecodesOnceAndTickReturnsCache` is what pins that down.
public final class StickerSource: SeedSource {
  // `id` is fixed rather than per-instance: `Preset`/`PresetLayer` (Task 12) match a saved
  // layer back to a live `SeedSource` by this string, and this codebase only ever wires up
  // one sticker layer (see `PresetTests`' `"sticker"` fixtures) — same convention as the
  // instrument's single picsvid slot.
  public let id = "sticker"

  // Placement/gating defaults mirror the original patch's picsvid layer at load:
  // - `zOrder = 2` is `LayerSettings`'s own default (spec §02 §1's `jit.gl.layer @layer 2`).
  // - `enabled = false` is `LayerSettings`'s own default ("pic enable" starts explicitly off
  //   via `loadmess 0`, spec §04 §1.4's toggle table) — nothing draws until the UI turns this
  //   layer on.
  // - `scale = (0.747, 0.747)` is the "pic-size" slider's persisted load value (spec §04
  //   §1.4's per-control table: `pic-size | slider[12] | imageMove[4]/[5] | 0.747`);
  //   position/rotation stay at `LayerTransform`'s own zero defaults.
  public var transform = LayerTransform(scale: SIMD2<Float>(0.747, 0.747))
  public var layer = LayerSettings()

  /// Extensions this source scans for. The original umenu's `types` filter (spec §02 §1) is
  /// `["MooV","MPEG","mpg4","VfW","WMV","PICT","PNG","GIFf","TIFF","BMP"]` — movies and
  /// stills mixed in one list, PICT included (a legacy Mac format with no modern decoder).
  /// This is the still-image subset re-expressed as file extensions, movies dropped
  /// (`MovieSource`, Task 16, owns those) and PICT swapped for the still formats CoreGraphics
  /// actually decodes today (jpg/jpeg/heic) — same intent as the original filter, not a
  /// literal transcription of it.
  private static let imageExtensions: Set<String> =
    ["png", "gif", "tif", "tiff", "bmp", "jpg", "jpeg", "heic"]

  private let context: MetalContext

  /// The scanned folder. Public because the operator panel needs it to build thumbnail URLs
  /// and to name the drop target on screen — read-only; the only way to put a file in it from
  /// the UI is `importImages(from:)`.
  public let folder: URL

  private var cachedTexture: MTLTexture?

  /// Sorted by filename (spec §02 §2's folder listing order — deterministic, not directory
  /// insertion order).
  public private(set) var items: [URL] = []

  /// Fires with the new count after `rescan()` — the `movsFound`-changed equivalent (spec
  /// §02 §1), so a bound UI (Task 20) can refresh its slider range.
  public var onCountChanged: ((Int) -> Void)?

  public var itemCount: Int { items.count }

  /// Display names for `items`, in the same order — what the panel's thumbnail grid labels
  /// each tile with, so the UI never has to reason about `URL`s it doesn't own.
  public var itemNames: [String] { items.map(\.lastPathComponent) }

  private var _selectedIndex = 0

  /// Setting this decodes immediately (see the type doc above) and caches the result; `tick`
  /// never touches the decoder. Out-of-range values clamp into `0..<itemCount` rather than
  /// trapping — a UI slider mid-drag will walk through values a discrete file list doesn't
  /// have yet. Re-selecting the index that's already current is a no-op (see
  /// `setSelectedIndex(_:force:)`) — the original patch's `zl change` dedupe (spec §02 §2:
  /// "re-selecting the same file is a no-op").
  public var selectedIndex: Int {
    get { _selectedIndex }
    set { setSelectedIndex(newValue, force: false) }
  }

  /// The shared selection path for `selectedIndex`'s setter, `select(normalized:)`, and
  /// `rescan()`. `force: false` (the normal case) dedupes: if the clamped index equals
  /// `_selectedIndex` AND a texture is already cached, this is a no-op — the original
  /// patch's `zl change` before its `prepend read` (spec §02 §2: "re-selecting the same file
  /// is a no-op"). That dedupe matters here specifically because `select(normalized:)` is
  /// fed by a continuous touch/slider stream (spec §02 §2 item 4) that can call this dozens
  /// of times a second while sitting on one item; without it, every one of those calls would
  /// re-decode from disk — exactly the per-frame cost the type doc's decode-on-selection
  /// design exists to avoid, just moved from "per frame" to "per pointer-move event."
  /// `force: true` (only `rescan()`) bypasses the dedupe deliberately: a rescan can leave
  /// `_selectedIndex` numerically unchanged (it always resets to 0) while the file *at* that
  /// index has changed — dropping a new `a-first.png` into the folder, or `c-blue.png`
  /// disappearing and something else sorting into index 0 — so the cache must never survive
  /// a rescan on index-equality alone.
  private func setSelectedIndex(_ newValue: Int, force: Bool) {
    guard itemCount > 0 else { _selectedIndex = 0; cachedTexture = nil; return }
    let clamped = min(max(newValue, 0), itemCount - 1)
    if !force, clamped == _selectedIndex, cachedTexture != nil { return }
    _selectedIndex = clamped
    cachedTexture = Self.decodeImage(at: items[clamped], context: context)
  }

  public init(context: MetalContext, folder: URL) {
    self.context = context
    self.folder = folder
    scan()
    if itemCount > 0 { setSelectedIndex(0, force: true) }   // decode the first sticker up front
  }

  /// `0...1` → index (spec §02 §2 item 4 — the picker slider's mapping). `v = 1.0` maps to
  /// the LAST item, not one past it: `min(Int(v·count), count−1)` rather than a bare
  /// `Int(v·count)`, matching `testNormalizedSelectionAndRescanReset`'s `select(normalized:
  /// 0.99)` landing on index 2 of 3. Routes through `selectedIndex`'s setter, so the same-
  /// index dedupe documented there applies here too.
  public func select(normalized: Float) {
    guard itemCount > 0 else { return }
    let idx = min(Int(normalized * Float(itemCount)), itemCount - 1)
    selectedIndex = max(idx, 0)
  }

  /// Repopulates `items` from disk and resets selection to the first item (spec §02 §2): a
  /// rescan mid-session (a file added or removed) must not leave `selectedIndex` pointing at
  /// a file that no longer exists, or silently keep showing a stale decode of a deleted one.
  /// Uses `force: true` — see `setSelectedIndex(_:force:)` — so a rescan always re-decodes
  /// index 0 even when the index number didn't change.
  public func rescan() {
    rescan(selecting: nil)
  }

  /// `rescan()` with a say in where selection lands: `nil` keeps the reset-to-first rule
  /// above, a file name lands on that file if it survived the rescan (and falls back to index
  /// 0 if it didn't). Only `importImages(from:)` passes a name — dropping a sticker on the
  /// panel should put *that* sticker on screen, not silently jump to whatever sorts first.
  public func rescan(selecting fileName: String?) {
    scan()
    let target = fileName.flatMap { name in items.firstIndex { $0.lastPathComponent == name } } ?? 0
    setSelectedIndex(target, force: true)
    onCountChanged?(itemCount)
  }

  /// What `importImages(from:)` did, in file names: `imported` are now in the folder (under
  /// the names they landed with, which may be suffixed — see below), `skipped` are the ones
  /// that were not images this source can decode, or that failed to copy.
  public struct ImportResult: Equatable {
    public let imported: [String]
    public let skipped: [String]
    public var isEmpty: Bool { imported.isEmpty && skipped.isEmpty }
  }

  /// Copies dropped/chosen files into `folder` and rescans — the operator's way to get images
  /// in front of the instrument without leaving it (spec §02 §9 describes a `dropfile` "drop a
  /// folder here!" affordance in the original patch that was never actually wired to anything;
  /// this is that affordance, wired).
  ///
  /// Copy rather than reference-in-place, deliberately: `folder` stays the single answer to
  /// "what can this instrument show," so the list survives a relaunch and stays the seam the
  /// design's later jukebox queue feeds. Three rules fall out of that:
  /// - A directory contributes the images directly inside it (not recursively) — a dropped
  ///   folder is a set of stickers, not a tree to crawl.
  /// - A name that already exists in the folder gets a `-2`/`-3` suffix rather than
  ///   overwriting; the resident file may be one the performer has been using all night.
  /// - A file that is ALREADY in `folder` is selected, not re-copied, so dragging a sticker
  ///   out of the very folder being scanned doesn't breed duplicates of itself.
  ///
  /// Non-throwing: a mixed drop (some images, a `.txt`, an unreadable file) should import
  /// what it can and *report* the rest, never abandon the good files or raise a modal
  /// mid-performance. Everything not imported comes back in `skipped` for the panel to show.
  @discardableResult
  public func importImages(from urls: [URL]) -> ImportResult {
    var imported: [String] = []
    var skipped: [String] = []

    for url in expand(urls) {
      guard Self.imageExtensions.contains(url.pathExtension.lowercased()) else {
        skipped.append(url.lastPathComponent)
        continue
      }
      if url.deletingLastPathComponent().standardizedFileURL == folder.standardizedFileURL {
        imported.append(url.lastPathComponent)   // already home — select it, don't clone it
        continue
      }
      do {
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let destination = availableDestination(for: url.lastPathComponent)
        try FileManager.default.copyItem(at: url, to: destination)
        imported.append(destination.lastPathComponent)
      } catch {
        skipped.append(url.lastPathComponent)
      }
    }

    // Nothing landed → don't touch selection at all. A rejected drop must not yank the
    // performer off the sticker they were showing (which a bare `rescan()` would, by resetting
    // to index 0).
    if !imported.isEmpty { rescan(selecting: imported.first) }
    return ImportResult(imported: imported, skipped: skipped)
  }

  /// Directories contribute their immediate children (sorted, so a dropped folder imports in
  /// the same order it will later scan in); everything else passes through untouched.
  private func expand(_ urls: [URL]) -> [URL] {
    urls.flatMap { url -> [URL] in
      var isDirectory: ObjCBool = false
      guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory),
            isDirectory.boolValue else { return [url] }
      let children = (try? FileManager.default.contentsOfDirectory(
        at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])) ?? []
      return children
        .filter { Self.imageExtensions.contains($0.pathExtension.lowercased()) }
        .sorted { $0.lastPathComponent < $1.lastPathComponent }
    }
  }

  /// `sticker.png` → `sticker.png`, or `sticker-2.png`, `sticker-3.png`… — the first name in
  /// that series not already taken on disk.
  private func availableDestination(for fileName: String) -> URL {
    let candidate = folder.appendingPathComponent(fileName)
    guard FileManager.default.fileExists(atPath: candidate.path) else { return candidate }
    let base = candidate.deletingPathExtension().lastPathComponent
    let ext = candidate.pathExtension
    for suffix in 2... {
      let next = folder.appendingPathComponent("\(base)-\(suffix)").appendingPathExtension(ext)
      if !FileManager.default.fileExists(atPath: next.path) { return next }
    }
    return candidate   // unreachable: the loop above is unbounded
  }

  /// Cached-texture read only — see the type doc's decode-on-selection rule. A missing or
  /// empty folder (`itemCount == 0`) returns nil rather than a placeholder texture, same as
  /// a disabled layer (`Compositor.drawPlan`; Task 19's determinism test depends on this).
  public func tick(_ frame: FrameContext) -> MTLTexture? { cachedTexture }

  private func scan() {
    let found = (try? FileManager.default.contentsOfDirectory(
      at: folder, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])) ?? []
    items = found
      .filter { Self.imageExtensions.contains($0.pathExtension.lowercased()) }
      .sorted { $0.lastPathComponent < $1.lastPathComponent }
  }

  /// `CGImageSource` decode → draw into a premultiplied `CGContext` → CPU un-premultiply →
  /// upload via `MetalContext.makeTexture`.
  ///
  /// PNG (and the other formats here) store STRAIGHT alpha on disk — that's the format
  /// spec's own convention. But `CGContext` only ever hands back PREMULTIPLIED pixels from a
  /// `draw(_:in:)` call; there is no un-premultiplied `CGBitmapInfo` CoreGraphics will
  /// actually render into. So this un-premultiplies by hand, once, right here at decode time
  /// (never per-frame — see the type doc), which is what makes the compositor's straight-
  /// alpha blend (design §5) match what the source file actually encoded, i.e. Jitter's own
  /// convention: a 50%-alpha blue pixel should read back as full-strength blue at half
  /// coverage, not half-strength blue (`testStraightAlphaSurvivesDecode`).
  private static func decodeImage(at url: URL, context: MetalContext) -> MTLTexture? {
    guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
          let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else { return nil }
    let width = cgImage.width, height = cgImage.height
    guard width > 0, height > 0 else { return nil }

    var raw = [UInt8](repeating: 0, count: width * height * 4)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard let ctx = CGContext(data: &raw, width: width, height: height, bitsPerComponent: 8,
                              bytesPerRow: width * 4, space: colorSpace,
                              bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
      return nil
    }
    // No flip needed: a freshly-created `CGContext(data:...)` writes its buffer starting
    // from the image's own top row at byte offset 0 — verified against a real round trip
    // through `CGImageDestination`/`CGImageSource`, not assumed — so `raw`'s row order
    // already matches `MetalContext.makeTexture`'s row-major upload convention.
    ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

    var pixels = [SIMD4<Float>](repeating: .zero, count: width * height)
    for i in 0..<(width * height) {
      let o = i * 4
      let a = Float(raw[o + 3]) / 255
      if a > 0 {
        let r = Float(raw[o]) / 255, g = Float(raw[o + 1]) / 255, b = Float(raw[o + 2]) / 255
        pixels[i] = SIMD4(r / a, g / a, b / a, a)
      } else {
        pixels[i] = SIMD4(0, 0, 0, 0)
      }
    }
    return context.makeTexture(width: width, height: height, format: .rgba8Unorm, pixels: pixels)
  }
}
