import XCTest
import AVFoundation
import CoreVideo
import simd
@testable import FeedbaxKit

final class MovieSourceTests: XCTestCase {
  var fixtureURL: URL!

  override func setUpWithError() throws {
    fixtureURL = FileManager.default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
    try writeFixtureMovie(to: fixtureURL, frameCount: 12, size: 64, fps: 30)
  }

  override func tearDownWithError() throws {
    try? FileManager.default.removeItem(at: fixtureURL)
  }

  func testTickDeliversAdvancingFrames() throws {
    let ctx = try MetalContext()
    let src = MovieSource(context: ctx)
    src.load(url: fixtureURL)
    let first = try XCTUnwrap(firstFrame(src, ctx), "player produced no frame within 2 s")
    XCTAssertEqual(first.width, 64); XCTAssertEqual(first.height, 64)
    let redA = meanRed(ctx, first)
    Thread.sleep(forTimeInterval: 0.3)                       // ≥ 9 frames of the 30 fps sweep
    // `excluding: first` (see `firstFrame`'s doc comment) — without it this retry would
    // accept `tick`'s stale-cache fallback on its very first poll and never actually wait
    // for a fresh frame.
    let second = try XCTUnwrap(firstFrame(src, ctx, excluding: first))
    let redB = meanRed(ctx, second)
    XCTAssertGreaterThan(abs(redA - redB), 0.05,
                         "red sweep must advance — the movie plays on its own clock (design §5)")
  }

  /// Guards the double-attach risk a code-review pass caught: `AVPlayerLooper`'s queue wraps
  /// every ~0.4 s (the fixture's own duration), so 1.1 s of continuous ticking crosses at
  /// least two loop boundaries — two re-attaches of `output` to a new `currentItem`. Per
  /// Apple's documented single-attachment contract, skipping the detach-before-attach in
  /// `tick` risks `-[AVPlayerItem addOutput:]`'s documented "Cannot attach an output that is
  /// already attached" exception (an uncatchable `NSException`, not a Swift `Error` — a
  /// regression here would abort the whole test run, not just fail one case). Note: a
  /// deliberate stress attempt (temporarily reverting the detach fix, running up to 3.5 s /
  /// ~8 loop wraps) did not actually reproduce that exception on this SDK/OS — so treat this
  /// test as exercising the documented-contract risk and the "no crash, no nil" outcome, not
  /// as proof the exception is reachable here. Loose on purpose, per the task's timing
  /// contract: no assertion on which frame/loop iteration is current, only that `tick` keeps
  /// returning a texture throughout.
  func testTickSurvivesMultipleLoopBoundaries() throws {
    let ctx = try MetalContext()
    let src = MovieSource(context: ctx)
    src.load(url: fixtureURL)
    _ = try XCTUnwrap(firstFrame(src, ctx), "player produced no frame within 2 s")

    let end = Date().addingTimeInterval(1.1)          // > 2 loop boundaries at ~0.4 s/loop
    var tickCount = 0
    while Date() < end {
      let cb = ctx.queue.makeCommandBuffer()!
      let frame = FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: SIMD2(64, 64),
                               commandBuffer: cb, pool: ctx.pool)
      XCTAssertNotNil(src.tick(frame), "tick must keep returning a texture across loop boundaries")
      tickCount += 1
      RunLoop.current.run(until: Date().addingTimeInterval(0.02))
    }
    XCTAssertGreaterThan(tickCount, 10, "sanity: this actually polled repeatedly across the loop window")
  }

  /// `id`/`layer`/`transform` defaults, plus the AVPlayer-not-yet-loaded state — no real
  /// playback involved, so this is deterministic (unlike the timing test above).
  func testDefaultsMatchSeedSourceConventions() throws {
    let src = MovieSource(context: try MetalContext())
    XCTAssertEqual(src.id, "movie")
    XCTAssertEqual(src.layer.zOrder, 2)
    XCTAssertFalse(src.layer.enabled)
    XCTAssertEqual(src.transform.position, SIMD2<Float>.zero)
    XCTAssertFalse(src.isPlaying, "no file loaded yet")
  }

  // MARK: - Helpers (from the task-16 brief)

  func meanRed(_ ctx: MetalContext, _ tex: MTLTexture) -> Float {
    let px = ctx.readPixels(tex)
    return px.reduce(0) { $0 + $1.x } / Float(px.count)
  }

  /// Two documented deviations from the brief's literal helper (both sleep-mechanism
  /// tuning, per the task's "tune only the retry deadlines/sleeps" allowance — no assertion
  /// or threshold changed):
  ///
  /// 1. `Thread.sleep(forTimeInterval: 0.05)` → `RunLoop.current.run(until:)`. `swift test`
  ///    runs the test body synchronously on a thread whose run loop nothing else pumps;
  ///    confirmed with a throwaway debug harness that `AVPlayerItem.status` simply never
  ///    leaves `.unknown` — and `hasNewPixelBuffer` never turns true — under a bare
  ///    `Thread.sleep` loop, no matter how many iterations. `RunLoop.current.run(until:)`
  ///    blocks for the same wall-clock slice while also servicing AVFoundation's KVO/async
  ///    delivery, which is what actually lets the player reach `.readyToPlay`.
  /// 2. Added an `excluding:` parameter. `MovieSource.tick` is specified to fall back to
  ///    its cached texture whenever no new pixel buffer is ready (design §5's "repeats
  ///    frames" rule) — which means `tick` is non-nil on nearly every call once the first
  ///    frame has landed. The brief's plain `if let t = src.tick(frame) { return t }` would
  ///    therefore accept that stale cache on `second`'s very first poll and return
  ///    immediately, never actually waiting for playback to advance. `excluding:` keeps the
  ///    same "poll until non-nil, capped at `deadline`" contract, just also requiring the
  ///    result differ from a texture already sampled — the loose part (which frame, how
  ///    many polls) is untouched; only "must not be a no-op fallback" is added.
  func firstFrame(_ src: MovieSource, _ ctx: MetalContext, excluding previous: MTLTexture? = nil,
                  deadline: TimeInterval = 2) -> MTLTexture? {
    let end = Date().addingTimeInterval(deadline)
    while Date() < end {
      let cb = ctx.queue.makeCommandBuffer()!
      let frame = FrameContext(index: 0, time: 0, delta: 1 / 60, canvasSize: SIMD2(64, 64),
                               commandBuffer: cb, pool: ctx.pool)
      if let t = src.tick(frame), t !== previous { return t }
      RunLoop.current.run(until: Date().addingTimeInterval(0.05))
    }
    return nil
  }

  // MARK: - Fixture generator
  //
  // `writeFixtureMovie` used to live here as a private helper; Task 22's golden-frame
  // harness needed the identical generator to produce its own (committed, one-time)
  // `sweep.mov` fixture, so it now lives in `TestSupport/FixtureGenerators.swift` and both
  // call sites share it rather than keeping two copies in sync by hand.
}
