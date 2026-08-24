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
  private let folder: URL
  private var cachedTexture: MTLTexture?

  /// Sorted by filename (spec §02 §2's folder listing order — deterministic, not directory
  /// insertion order).
  public private(set) var items: [URL] = []

  /// Fires with the new count after `rescan()` — the `movsFound`-changed equivalent (spec
  /// §02 §1), so a bound UI (Task 20) can refresh its slider range.
  public var onCountChanged: ((Int) -> Void)?

  public var itemCount: Int { items.count }

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
    scan()
    setSelectedIndex(0, force: true)
    onCountChanged?(itemCount)
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
