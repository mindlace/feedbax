import AVFoundation
import CoreVideo
import Metal
import QuartzCore

/// The "movie" half of `jit.movie` (design §"SeedSource"; spec §02 §1's picsvid `jit.movie`
/// object plays "still image or movie" from the scanned folder — stills are `StickerSource`,
/// Task 15; this is the movie half). Backed by `AVQueuePlayer` + `AVPlayerLooper` for looped
/// playback, and `AVPlayerItemVideoOutput` for zero-copy delivery of decoded frames into
/// Metal via `CVMetalTextureCache` — no CPU round trip, unlike `StickerSource`'s CG decode.
///
/// **The load-bearing rule (design §5): movies advance on their own clock.** `AVPlayer`
/// runs its own decode/presentation timeline against the host clock the moment `load(url:)`
/// calls `play()`; `tick` never drives playback — it only asks "is there a newer decoded
/// frame than the one I last handed out?" This mirrors spec §02 §3's own finding about the
/// original patch: `jit.movie` is *not* wired to the per-frame `imgbang` bus the way stills
/// are re-banged on selection — a movie's frame advance was always independent of the render
/// clock, just implicitly (via `jit.movie`'s internal QuickTime playback) rather than via an
/// explicit output object the way this port makes it. A 30 fps source under a 60 Hz engine
/// therefore naturally repeats frames on the frames where nothing new has decoded yet — same
/// visible behavior as the original, not a bug to paper over.
public final class MovieSource: SeedSource {
  // Fixed, like `StickerSource.id` — this codebase only ever wires up one movie/picsvid
  // slot (see the `SeedSource` doc's build order: sticker folder → `MovieSource` next).
  public let id = "movie"

  // `LayerSettings()`'s own defaults (zOrder 2, enabled false) match the picsvid layer's
  // instantiation the same way `StickerSource`'s do (spec §02 §1 `@layer 2`, §04 §1.4
  // enable-off at load) — nothing draws until the UI turns this layer on.
  public var transform = LayerTransform()
  public var layer = LayerSettings()

  private let context: MetalContext
  private var textureCache: CVMetalTextureCache?

  private var player: AVQueuePlayer?
  private var looper: AVPlayerLooper?
  private var output: AVPlayerItemVideoOutput?
  // `AVPlayerLooper` does not loop the exact `AVPlayerItem` instance handed to it as
  // `templateItem` — verified empirically (a throwaway debug harness logging
  // `currentItem === templateItem` came back false from the very first loop pass): it
  // clones the template into its own internally-managed queue items, none of which carry
  // an output added to the original. So `output` must be re-attached to whatever
  // `player.currentItem` actually is, every time that identity changes (including across
  // loop wraps) — tracked here rather than via KVO, since `tick` already polls once a frame.
  private var attachedItem: AVPlayerItem?

  // The cached frame `tick` falls back to when no new pixel buffer has decoded since the
  // last call. `cvTexture` is held alongside `mtlTexture` purely to keep its backing
  // IOSurface alive — `CVMetalTextureCacheCreateTextureFromImage` returns an `MTLTexture`
  // that wraps, but does not itself retain, that IOSurface; if the `CVMetalTexture` were
  // allowed to deallocate, the `MTLTexture` would be reading freed/reused GPU memory.
  private var cachedMTLTexture: MTLTexture?
  private var cachedCVTexture: CVMetalTexture?

  /// Mirrors `AVQueuePlayer.rate != 0` — true once `load(url:)` has started playback. No
  /// file loaded yet (or playback paused) reads false.
  public var isPlaying: Bool { (player?.rate ?? 0) != 0 }

  public init(context: MetalContext) {
    self.context = context
    // Failure here (a headless/software-only Metal device) just means `tick` will always
    // fall through to the "no cache" branch and return nil — no reason to make `init` throw
    // for a condition the caller can't act on differently.
    CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, context.device, nil, &textureCache)
  }

  /// Starts looped playback of `url` immediately — decode-on-selection for movies means
  /// "start the player," not "decode a frame," since frames only exist as the player
  /// produces them (design §5's rule, honored here rather than in `tick`). The output is
  /// added to this first `item`, and `attachedItem` is set to match — `tick` is what
  /// actually keeps it attached to whatever item is *really* playing, and it needs
  /// `attachedItem` to start out correct (not nil) so its very first re-attach check knows
  /// to detach from *this* item rather than skipping the detach and double-attaching (see
  /// `tick`'s comment on `remove(output)`).
  public func load(url: URL) {
    let item = AVPlayerItem(url: url)
    let out = AVPlayerItemVideoOutput(pixelBufferAttributes: [
      kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
      kCVPixelBufferMetalCompatibilityKey as String: true,
    ])
    item.add(out)
    output = out

    let queuePlayer = AVQueuePlayer()
    looper = AVPlayerLooper(player: queuePlayer, templateItem: item)
    player = queuePlayer
    cachedMTLTexture = nil
    cachedCVTexture = nil
    attachedItem = item
    queuePlayer.play()
  }

  /// Fetches — never advances — the current frame (design §5). `hasNewPixelBuffer` is
  /// checked at the player's current host-clock-mapped item time; when nothing new has
  /// decoded since the last call (the 30-fps-under-60-Hz repeat case, or playback not yet
  /// started), this returns whatever was cached last time, exactly like `StickerSource.tick`
  /// returning its cache — the difference is *why* the cache is stale (the clock hasn't
  /// produced a new frame yet, vs. nothing has re-selected).
  public func tick(_ frame: FrameContext) -> MTLTexture? {
    guard let output, let textureCache else { return cachedMTLTexture }
    // Re-attach on every identity change of `player.currentItem` — see `attachedItem`'s
    // doc comment. Cheap when nothing has changed (a reference comparison), and this is
    // the only hook `tick` has into "the looper just advanced to its next queued item."
    //
    // `attachedItem?.remove(output)` runs before `current.add(output)`: Apple's documented
    // contract for `AVPlayerItemOutput` is one attached `AVPlayerItem` at a time, and
    // `-[AVPlayerItem addOutput:]` is documented to raise "Cannot attach an output that is
    // already attached" if that's violated. A code-review pass flagged the skip-the-detach
    // version as a crash risk under sustained looping; a stress test here (up to 3.5 s, ~8
    // loop wraps) did not actually trigger the exception on this SDK/OS, so this fix rests
    // on the documented contract rather than a locally-reproduced crash — still the right
    // call, since relying on undocumented tolerance for a double-attach is fragile across OS
    // versions regardless of what this one machine does today. `load(url:)` sets
    // `attachedItem` to its initial item precisely so this remove call has something valid
    // to target on the very first re-attach too.
    if let current = player?.currentItem, current !== attachedItem {
      attachedItem?.remove(output)
      current.add(output)
      attachedItem = current
    }
    let itemTime = output.itemTime(forHostTime: CACurrentMediaTime())
    guard output.hasNewPixelBuffer(forItemTime: itemTime),
          let pixelBuffer = output.copyPixelBuffer(forItemTime: itemTime, itemTimeForDisplay: nil)
    else {
      return cachedMTLTexture
    }

    var cvTexture: CVMetalTexture?
    let status = CVMetalTextureCacheCreateTextureFromImage(
      kCFAllocatorDefault, textureCache, pixelBuffer, nil, .bgra8Unorm,
      CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer), 0, &cvTexture)
    guard status == kCVReturnSuccess, let cvTexture,
          let mtlTexture = CVMetalTextureGetTexture(cvTexture)
    else {
      return cachedMTLTexture
    }

    cachedCVTexture = cvTexture     // keeps the IOSurface backing mtlTexture alive
    cachedMTLTexture = mtlTexture
    // Apple's guidance for `CVMetalTextureCache` in a sustained render loop: flush
    // periodically (once per frame is the documented cadence) so textures whose
    // `CVMetalTexture`/`MTLTexture` wrappers have already been released get reclaimed
    // instead of accumulating for the cache's lifetime. Placed on the fresh-texture path
    // (not the fallback-to-cache path above) because that's the only path where the cache
    // actually grew this tick — nothing to reclaim on a repeat-frame tick that made no new
    // cache entry.
    CVMetalTextureCacheFlush(textureCache, 0)
    return mtlTexture
  }
}
