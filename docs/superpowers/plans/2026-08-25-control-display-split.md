# Control/Display Split Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Split the instrument into two independent windows — an Output window on the projector and a Controls window on the laptop — by moving the frame clock out of the render view and into an always-running `EngineHost`, so the feedback loop keeps evolving whether or not a window is open.

**Architecture:** Today `MetalHostView` *is* the engine driver: it owns the `FrameClock`, owns the `OutputStage`, and is the only caller of `engine.step`. This plan inverts that. A new `EngineHost` (in `FeedbaxKit`) owns the engine, the output stage, and a swappable `FrameDriver` — `DisplayLinkDriver` (vsync, wrapping the existing `FrameClock`) whenever an output window is attached, `TimerDriver` (a `DispatchSourceTimer` at `engine.frameRate`) whenever there isn't. `RenderView` shrinks to a `CAMetalLayer` that attaches/detaches itself. Input moves to one app-level `NSEvent` local monitor so focus stops mattering. Both entry points then declare the same two `Window` scenes from a shared `FeedbaxScenes`.

**Tech Stack:** Swift 5.10, SwiftUI + AppKit, Metal / `CAMetalDisplayLink`, XCTest, SwiftPM (`app/Package.swift`) + XcodeGen (`app/project.yml`) for the `.app` bundle.

**Spec:** `docs/superpowers/specs/2026-08-24-control-display-split-design.md`

## Global Constraints

- Deployment floor is macOS 14 (`Package.swift`: `platforms: [.macOS(.v14)]`) — `CAMetalDisplayLink` and SwiftUI's `Window` scene both require it. Do not raise or lower it.
- Both entry points must behave identically (design §8): `app/App/FeedbaxApp.swift` (bundle) and `app/Sources/feedbax-dev/main.swift` (`swift run`). The **only** licensed difference is `feedbax-dev`'s `NSApplicationDelegateAdaptor` activation-policy workaround.
- Tests must be run as `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app` — `xcode-select -p` on this machine is CommandLineTools, which ships no XCTest, and plain `swift test` dies with `no such module 'XCTest'` naming an arbitrary file. `swift build` / `swift run` need no prefix.
- All new engine-facing tests are headless. `MetalContext()` + `MetalContext.readPixels(_:)` work in the test process (see `EngineInvariantTests`, `WaveformTests`); a real `CAMetalLayer`/display link does not. Anything needing a window is verified by hand, not by tests.
- The engine is single-threaded by convention: `engine.step` and `router.tick` run on the main thread only. Every driver must deliver its tick on `DispatchQueue.main`.
- `TimerDriver` runs at the full `engine.frameRate` when nothing is attached (spec's open question, resolved: the image you get back on reopening is the one you would have had).
- Never restore `try?` around `OutputStage` construction — spec calls out `PreviewView.swift:100` as a silent-failure bug; the replacement must throw.
- Conventional Commits for every commit (`feat:`, `fix:`, `refactor:`, `test:`).

---

### Task 1: `FrameDriver` protocol, `TimerDriver`, `DisplayLinkDriver`

**Files:**
- Create: `app/Sources/FeedbaxKit/Engine/FrameDriver.swift`
- Test: `app/Tests/FeedbaxKitTests/FrameDriverTests.swift`

**Interfaces:**
- Consumes: `FrameClock` (existing, `app/Sources/FeedbaxKit/Engine/FrameClock.swift`) — `init(layer:rate:tick:)`, `updateRate(_:)`, `invalidate()`, `static shouldRetune(currentEngineRate:builtRate:)`.
- Produces:
  - `struct FrameTick { let drawable: CAMetalDrawable? }`
  - `protocol FrameDriver: AnyObject { var rate: Int { get }; func updateRate(_ newRate: Int); func invalidate() }`
  - `final class TimerDriver: FrameDriver` — `init(rate: Int, queue: DispatchQueue = .main, tick: @escaping (FrameTick) -> Void)`
  - `final class DisplayLinkDriver: FrameDriver` — `init(layer: CAMetalLayer, rate: Int, tick: @escaping (FrameTick) -> Void)`

- [ ] **Step 1: Write the failing tests**

Create `app/Tests/FeedbaxKitTests/FrameDriverTests.swift`:

```swift
import XCTest
import Foundation
@testable import FeedbaxKit

/// `DisplayLinkDriver` has no test here for the same reason `FrameClock` never had one — it
/// needs a real `CAMetalLayer` on a real display, which the test process has no window server
/// for. `TimerDriver` is the windowless half and is fully testable.
final class FrameDriverTests: XCTestCase {
  func testTimerDriverTicksAtRoughlyItsRate() {
    let ticked = expectation(description: "timer ticked at least 5 times")
    var count = 0
    let driver = TimerDriver(rate: 60) { tick in
      XCTAssertNil(tick.drawable, "a windowless driver presents nothing")
      count += 1
      if count == 5 { ticked.fulfill() }
    }
    // 5 frames at 60 Hz is ~83 ms; 2 s is a generous ceiling for a loaded CI machine.
    wait(for: [ticked], timeout: 2.0)
    driver.invalidate()
  }

  func testInvalidateStopsTheTimer() {
    var count = 0
    let driver = TimerDriver(rate: 60) { _ in count += 1 }
    let firstBatch = expectation(description: "some frames arrived")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { firstBatch.fulfill() }
    wait(for: [firstBatch], timeout: 2.0)
    XCTAssertGreaterThan(count, 0, "timer should have fired before invalidate")

    driver.invalidate()
    let countAtInvalidate = count
    let afterInvalidate = expectation(description: "waited past several tick intervals")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { afterInvalidate.fulfill() }
    wait(for: [afterInvalidate], timeout: 2.0)
    XCTAssertEqual(count, countAtInvalidate, "no ticks after invalidate")
  }

  func testUpdateRateRetunesAndIsANoOpAtTheSameRate() {
    let driver = TimerDriver(rate: 60) { _ in }
    XCTAssertEqual(driver.rate, 60)
    driver.updateRate(60)
    XCTAssertEqual(driver.rate, 60, "same rate — nothing to retune")
    driver.updateRate(30)
    XCTAssertEqual(driver.rate, 30)
    driver.invalidate()
  }

  func testRateIsClampedToAtLeastOne() {
    let driver = TimerDriver(rate: 0) { _ in }
    XCTAssertEqual(driver.rate, 1, "a zero/negative rate would make the tick interval infinite")
    driver.invalidate()
  }
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter FrameDriverTests`
Expected: FAIL — `cannot find 'TimerDriver' in scope`.

- [ ] **Step 3: Write the implementation**

Create `app/Sources/FeedbaxKit/Engine/FrameDriver.swift`:

```swift
import Foundation
import Dispatch
import QuartzCore
import Metal

/// One frame's worth of "go" from a driver. `drawable` is non-nil only when the driver is
/// bound to a live output window (`DisplayLinkDriver`) — the windowless `TimerDriver` still
/// steps the engine every tick, it just has nothing to present into. That nil is the whole
/// reason the feedback accumulator keeps evolving with no window open (spec goal 2).
public struct FrameTick {
  public let drawable: CAMetalDrawable?
  public init(drawable: CAMetalDrawable?) { self.drawable = drawable }
}

/// What `EngineHost` pulls frames from. Two implementations, swapped on window attach/detach:
/// `DisplayLinkDriver` (vsync-locked to the output window's display) and `TimerDriver` (a
/// plain repeating timer, used when there is no window at all). `CAMetalDisplayLink` cannot
/// exist without a `CAMetalLayer`, which is exactly why the second implementation is needed.
public protocol FrameDriver: AnyObject {
  /// The rate this driver is currently pinned to — compared against `Engine.frameRate` every
  /// tick so a live frame-rate-preset switch retunes the running driver (the existing
  /// `FrameClock.shouldRetune` contract, preserved).
  var rate: Int { get }
  func updateRate(_ newRate: Int)
  /// Callers MUST invoke this before dropping their last reference: neither a run-loop-
  /// attached `CAMetalDisplayLink` nor a resumed `DispatchSourceTimer` stops merely because
  /// nothing external retains it.
  func invalidate()
}

/// The windowless clock. Delivers on `queue` (main by default) because `Engine.step` and
/// `ControlRouter.tick` are main-thread-only by convention throughout this codebase.
public final class TimerDriver: FrameDriver {
  public private(set) var rate: Int
  private let queue: DispatchQueue
  private let tick: (FrameTick) -> Void
  private var timer: DispatchSourceTimer?

  public init(rate: Int, queue: DispatchQueue = .main, tick: @escaping (FrameTick) -> Void) {
    // A zero or negative rate would make the repeat interval infinite (or negative) and the
    // engine would silently stop evolving — the exact failure this driver exists to prevent.
    self.rate = max(rate, 1)
    self.queue = queue
    self.tick = tick
    schedule()
  }

  private func schedule() {
    timer?.cancel()
    let interval = 1.0 / Double(rate)
    let source = DispatchSource.makeTimerSource(queue: queue)
    // Leeway is a power hint, not slop we care about: nothing downstream reads wall-clock
    // deltas from this driver (`EngineHost` stamps its own `CACurrentMediaTime`).
    source.schedule(deadline: .now() + interval, repeating: interval, leeway: .milliseconds(1))
    source.setEventHandler { [weak self] in
      self?.tick(FrameTick(drawable: nil))
    }
    source.resume()
    timer = source
  }

  /// Same guard `FrameClock.updateRate` uses, so both drivers no-op identically on the
  /// overwhelming majority of frames where the rate has not changed.
  public func updateRate(_ newRate: Int) {
    let clamped = max(newRate, 1)
    guard FrameClock.shouldRetune(currentEngineRate: clamped, builtRate: rate) else { return }
    rate = clamped
    schedule()   // a timer source's interval is not settable in place — reschedule
  }

  public func invalidate() {
    timer?.cancel()
    timer = nil
  }

  deinit { timer?.cancel() }
}

/// The windowed clock — a thin `FrameDriver` face on the existing `FrameClock`, which already
/// wraps `CAMetalDisplayLink` and already retunes in place. All this adds is the `FrameTick`
/// shape, so `EngineHost` never has to know which kind of clock it is holding.
public final class DisplayLinkDriver: FrameDriver {
  private let clock: FrameClock
  public var rate: Int { clock.rate }

  public init(layer: CAMetalLayer, rate: Int, tick: @escaping (FrameTick) -> Void) {
    clock = FrameClock(layer: layer, rate: rate) { update in
      tick(FrameTick(drawable: update.drawable))
    }
  }

  public func updateRate(_ newRate: Int) { clock.updateRate(newRate) }
  public func invalidate() { clock.invalidate() }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter FrameDriverTests`
Expected: PASS (4 tests).

- [ ] **Step 5: Commit**

```bash
git add app/Sources/FeedbaxKit/Engine/FrameDriver.swift app/Tests/FeedbaxKitTests/FrameDriverTests.swift
git commit -m "feat(engine): add FrameDriver with timer and display-link implementations"
```

---

### Task 2: `EngineHost` — the engine owns the clock

**Files:**
- Create: `app/Sources/FeedbaxKit/Engine/EngineHost.swift`
- Test: `app/Tests/FeedbaxKitTests/EngineHostTests.swift`

**Interfaces:**
- Consumes: Task 1's `FrameTick`, `FrameDriver`, `TimerDriver`, `DisplayLinkDriver`. Existing: `Engine.step(at:commandBuffer:) -> MTLTexture`, `Engine.frameRate`, `Engine.context` (`MetalContext`: `.device`, `.queue`, `.pool.endFrame()`, `.readPixels(_:)`), `Engine.bands.inputRMS`, `Engine.audioStatus`, `AudioBands.decibels(_:)`, `OutputStage.init(context:pixelFormat:) throws`, `OutputStage.draw(accumulator:into:commandBuffer:drawableSize:statusLine:)`, `OutputStage.hudEnabled`, `OutputStage.recordFrameTime(_:)`.
- Produces:
  - `protocol RenderTarget: AnyObject { var metalLayer: CAMetalLayer { get }; var drawableSizePixels: SIMD2<Int> { get } }`
  - `protocol FrameDriverFactory { func makeWindowless(rate:tick:) -> FrameDriver; func makeDisplayLinked(target:rate:tick:) -> FrameDriver }`
  - `struct SystemFrameDriverFactory: FrameDriverFactory`
  - `final class EngineHost` — `init(engine:factory:pixelFormat:) throws`, `start()`, `attach(_ target: RenderTarget)`, `detach(_ target: RenderTarget)`, `var hudEnabled: Bool`, `private(set) var frameCount: Int`, `var isAttached: Bool`

The factory indirection exists purely so these tests can run headless: `DisplayLinkDriver` needs a real display, a fake factory needs nothing.

- [ ] **Step 1: Write the failing tests**

Create `app/Tests/FeedbaxKitTests/EngineHostTests.swift`:

```swift
import XCTest
import Foundation
import Metal
import QuartzCore
import simd
@testable import FeedbaxKit

/// A `FrameDriver` that never fires on its own — the test calls `fire()` when it wants a
/// frame. This is what makes "did the swap drop or double-step a frame?" a deterministic
/// assertion instead of a race against two real clocks.
final class ManualDriver: FrameDriver {
  private(set) var rate: Int
  private(set) var invalidated = false
  private let tick: (FrameTick) -> Void
  init(rate: Int, tick: @escaping (FrameTick) -> Void) { self.rate = rate; self.tick = tick }
  func fire() { tick(FrameTick(drawable: nil)) }
  func updateRate(_ newRate: Int) { rate = newRate }
  func invalidate() { invalidated = true }
}

final class FakeDriverFactory: FrameDriverFactory {
  var windowless: [ManualDriver] = []
  var displayLinked: [ManualDriver] = []
  func makeWindowless(rate: Int, tick: @escaping (FrameTick) -> Void) -> FrameDriver {
    let d = ManualDriver(rate: rate, tick: tick); windowless.append(d); return d
  }
  func makeDisplayLinked(target: RenderTarget, rate: Int,
                         tick: @escaping (FrameTick) -> Void) -> FrameDriver {
    let d = ManualDriver(rate: rate, tick: tick); displayLinked.append(d); return d
  }
}

/// A `RenderTarget` with a layer nothing ever presents into — the fake factory never builds a
/// real display link, so the layer is only ever passed around, never drawn to.
final class FakeTarget: RenderTarget {
  let metalLayer = CAMetalLayer()
  var drawableSizePixels = SIMD2(320, 240)
}

final class EngineHostTests: XCTestCase {
  private func makeHost(_ factory: FakeDriverFactory) throws -> EngineHost {
    let engine = try Engine(context: try MetalContext())
    engine.setResolution(SIMD2(64, 64))
    return try EngineHost(engine: engine, factory: factory)
  }

  func testHostStepsWithNoTargetAttached() throws {
    let factory = FakeDriverFactory()
    let host = try makeHost(factory)
    host.start()
    XCTAssertEqual(factory.windowless.count, 1, "no window → windowless driver")
    XCTAssertTrue(factory.displayLinked.isEmpty)
    XCTAssertEqual(host.frameCount, 0)

    factory.windowless[0].fire()
    factory.windowless[0].fire()
    XCTAssertEqual(host.frameCount, 2, "the engine steps with no window in existence")
  }

  func testAttachSwapsDriversWithoutDroppingOrDoubleSteppingAFrame() throws {
    let factory = FakeDriverFactory()
    let host = try makeHost(factory)
    host.start()
    factory.windowless[0].fire()
    XCTAssertEqual(host.frameCount, 1)

    let target = FakeTarget()
    host.attach(target)
    XCTAssertTrue(factory.windowless[0].invalidated, "the old driver must be stopped")
    XCTAssertEqual(factory.displayLinked.count, 1)

    // A stale tick from the invalidated driver (already in flight when the swap happened)
    // must not step the engine a second time for the same frame.
    factory.windowless[0].fire()
    XCTAssertEqual(host.frameCount, 1, "stale driver ticks are ignored after a swap")

    factory.displayLinked[0].fire()
    XCTAssertEqual(host.frameCount, 2, "the new driver drives, continuing the same count")
  }

  func testDetachReturnsToTheWindowlessDriver() throws {
    let factory = FakeDriverFactory()
    let host = try makeHost(factory)
    host.start()
    let target = FakeTarget()
    host.attach(target)
    XCTAssertTrue(host.isAttached)

    host.detach(target)
    XCTAssertFalse(host.isAttached)
    XCTAssertTrue(factory.displayLinked[0].invalidated)
    XCTAssertEqual(factory.windowless.count, 2, "a fresh windowless driver takes over")

    factory.windowless[1].fire()
    XCTAssertEqual(host.frameCount, 1, "engine keeps stepping after the window closes")
  }

  func testDetachOfAStaleTargetIsIgnored() throws {
    let factory = FakeDriverFactory()
    let host = try makeHost(factory)
    host.start()
    let first = FakeTarget()
    let second = FakeTarget()
    host.attach(first)
    host.attach(second)
    // `first`'s view is torn down AFTER `second` attached (AppKit orders teardown after
    // setup on a window swap) — it must not detach the target that is actually live.
    host.detach(first)
    XCTAssertTrue(host.isAttached, "detach from a target that no longer owns the host is a no-op")
  }

  /// The test that encodes "closing the output window doesn't lose your image."
  func testAccumulatorSurvivesDetachAndReattach() throws {
    let factory = FakeDriverFactory()
    let engine = try Engine(context: try MetalContext())
    engine.setResolution(SIMD2(64, 64))
    engine.router.applyStartupDefaults(at: 0)
    let host = try EngineHost(engine: engine, factory: factory)
    host.start()

    for _ in 0..<8 { factory.windowless[0].fire() }
    let target = FakeTarget()
    host.attach(target)
    host.detach(target)
    for _ in 0..<2 { factory.windowless[1].fire() }

    // Non-black pixels prove the accumulator still holds evolved content rather than having
    // been reallocated/cleared by the attach/detach cycle (`FeedbackCore.resize` is the only
    // thing that legitimately clears it, and nothing here resizes).
    let commandBuffer = engine.context.queue.makeCommandBuffer()!
    let accumulator = engine.step(at: 1.0, commandBuffer: commandBuffer)
    commandBuffer.commit()
    commandBuffer.waitUntilCompleted()
    engine.context.pool.endFrame()
    let pixels = engine.context.readPixels(accumulator)
    XCTAssertTrue(pixels.contains { $0.x > 0.001 || $0.y > 0.001 || $0.z > 0.001 },
                  "the feedback image survived the window closing")
  }

  func testHudEnabledIsForwardedToTheOutputStage() throws {
    let factory = FakeDriverFactory()
    let host = try makeHost(factory)
    host.hudEnabled = false
    XCTAssertFalse(host.outputStage.hudEnabled)
    host.hudEnabled = true
    XCTAssertTrue(host.outputStage.hudEnabled)
  }

  func testDriverIsRetunedWhenTheEngineFrameRateChanges() throws {
    let factory = FakeDriverFactory()
    let host = try makeHost(factory)
    host.start()
    host.engine.frameRate = 30
    factory.windowless[0].fire()
    XCTAssertEqual(factory.windowless[0].rate, 30,
                   "a live frame-rate preset switch retunes the running driver")
  }
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter EngineHostTests`
Expected: FAIL — `cannot find 'EngineHost' in scope`.

- [ ] **Step 3: Write the implementation**

Create `app/Sources/FeedbaxKit/Engine/EngineHost.swift`:

```swift
import Foundation
import Metal
import QuartzCore
import simd

/// Whatever the host can present a finished frame into — in the app, exactly one thing: the
/// output window's `RenderView`. Deliberately narrow (a layer and its pixel size, nothing
/// else) so `EngineHost` never reaches into AppKit view state.
public protocol RenderTarget: AnyObject {
  var metalLayer: CAMetalLayer { get }
  var drawableSizePixels: SIMD2<Int> { get }
}

/// Builds drivers. Exists so `EngineHostTests` can run headless: the real factory hands back a
/// `DisplayLinkDriver` that needs a live display, the test factory hands back a hand-fired
/// fake, and `EngineHost`'s own attach/detach logic is identical either way.
public protocol FrameDriverFactory {
  func makeWindowless(rate: Int, tick: @escaping (FrameTick) -> Void) -> FrameDriver
  func makeDisplayLinked(target: RenderTarget, rate: Int,
                         tick: @escaping (FrameTick) -> Void) -> FrameDriver
}

public struct SystemFrameDriverFactory: FrameDriverFactory {
  public init() {}
  public func makeWindowless(rate: Int, tick: @escaping (FrameTick) -> Void) -> FrameDriver {
    TimerDriver(rate: rate, tick: tick)
  }
  public func makeDisplayLinked(target: RenderTarget, rate: Int,
                                tick: @escaping (FrameTick) -> Void) -> FrameDriver {
    DisplayLinkDriver(layer: target.metalLayer, rate: rate, tick: tick)
  }
}

/// Owns the engine and the clock that drives it, for the entire lifetime of the process.
///
/// This is the inversion the control/display split is really made of. Before it, the render
/// view owned the `FrameClock` and was the only caller of `engine.step`, which meant no window
/// = no rendering — and for a feedback instrument, no rendering means the accumulator stops
/// evolving. The image is the state. Here, the host steps forever and merely *presents* into a
/// target when one happens to be attached.
public final class EngineHost {
  public let engine: Engine
  /// Internal (not private) so `EngineHostTests` can assert the HUD forwarding; nothing
  /// outside the module sees it.
  let outputStage: OutputStage
  private let factory: FrameDriverFactory
  private var driver: FrameDriver?
  private weak var target: RenderTarget?
  private var lastFrameTimestamp: CFTimeInterval?

  /// Bumped on every driver swap and captured by the tick closure handed to each driver. A
  /// driver that was invalidated mid-flight can still deliver one last tick (a display link
  /// already inside its callback, a timer handler already dispatched); without this stamp
  /// that stale tick would step the engine a second time for a frame the new driver is about
  /// to step too. Compare-and-drop is cheaper and more obvious than trying to make teardown
  /// synchronous.
  private var generation: Int = 0

  public private(set) var frameCount: Int = 0
  public var isAttached: Bool { target != nil }

  public var hudEnabled: Bool = true {
    didSet { outputStage.hudEnabled = hudEnabled }
  }

  /// Throws whatever `OutputStage.init` throws. The old code built it with `try?` inside
  /// `MetalHostView.viewDidMoveToWindow` and silently rendered nothing forever if it failed
  /// (spec, "Fix carried along"); a shader/pipeline failure is a launch-time fatal, and the
  /// callers of this initializer already print-and-exit the same way they do for `Engine`.
  public init(engine: Engine, factory: FrameDriverFactory = SystemFrameDriverFactory(),
              pixelFormat: MTLPixelFormat = .bgra8Unorm) throws {
    self.engine = engine
    self.factory = factory
    self.outputStage = try OutputStage(context: engine.context, pixelFormat: pixelFormat)
    self.outputStage.hudEnabled = hudEnabled
  }

  /// Starts the windowless clock. Called once at bootstrap, BEFORE any window exists — that
  /// ordering is the point (spec goal 2).
  public func start() {
    guard driver == nil else { return }
    installDriver { [weak self] gen, tick in
      guard let self else { return nil }
      return self.factory.makeWindowless(rate: self.engine.frameRate, tick: tick)
    }
  }

  /// The output window opened (or moved to a new screen and rebuilt its layer). Swaps to a
  /// vsync-locked driver bound to that window's display.
  public func attach(_ target: RenderTarget) {
    self.target = target
    installDriver { [weak self] gen, tick in
      guard let self else { return nil }
      return self.factory.makeDisplayLinked(target: target, rate: self.engine.frameRate, tick: tick)
    }
  }

  /// The output window closed. Swaps back to the timer so the loop keeps evolving. A detach
  /// from a target that is no longer the live one is ignored: AppKit tears the old view down
  /// AFTER the new one has been set up, so an unguarded detach would kill a freshly attached
  /// window's driver.
  public func detach(_ target: RenderTarget) {
    guard self.target === target else { return }
    self.target = nil
    installDriver { [weak self] gen, tick in
      guard let self else { return nil }
      return self.factory.makeWindowless(rate: self.engine.frameRate, tick: tick)
    }
  }

  private func installDriver(_ build: (Int, @escaping (FrameTick) -> Void) -> FrameDriver?) {
    driver?.invalidate()
    generation &+= 1
    let gen = generation
    driver = build(gen) { [weak self] tick in
      guard let self, gen == self.generation else { return }
      self.renderFrame(tick)
    }
  }

  /// One frame: step the engine, present into the drawable if there is one, commit, release
  /// the frame's pooled leases. Structurally the same body `MetalHostView.renderFrame` had —
  /// the difference is that `tick.drawable` is now allowed to be nil.
  private func renderFrame(_ tick: FrameTick) {
    // The frame-rate preset picker only mutates `engine.frameRate`; polling it here (once per
    // tick, a no-op unless it actually changed — `FrameClock.shouldRetune`) is what makes a
    // live switch retune the running driver instead of waiting for a relaunch.
    driver?.updateRate(engine.frameRate)

    let commandBuffer = engine.context.queue.makeCommandBuffer()!
    let now = CACurrentMediaTime()
    let accumulator = engine.step(at: now, commandBuffer: commandBuffer)

    if let drawable = tick.drawable, let target {
      let db = AudioBands.decibels(engine.bands.inputRMS)
      let inputDB = db.isFinite ? Int(max(-90, min(20, db)).rounded()) : -90
      outputStage.draw(accumulator: accumulator, into: drawable, commandBuffer: commandBuffer,
                       drawableSize: target.drawableSizePixels,
                       statusLine: "\(engine.audioStatus)   in \(inputDB) dB")
    }

    commandBuffer.commit()
    // Frame-scoped pooled leases are only valid for the frame that leased them
    // (`TexturePool.endFrame`'s own doc comment) — this is that once-per-frame call site.
    engine.context.pool.endFrame()

    if let lastFrameTimestamp {
      outputStage.recordFrameTime(now - lastFrameTimestamp)
    }
    lastFrameTimestamp = now
    frameCount &+= 1
  }

  deinit { driver?.invalidate() }
}
```

Note on `installDriver`: the `gen` parameter is passed to the builder for symmetry but unused by the real builders — if the compiler warns about the unused closure parameter, name it `_`.

- [ ] **Step 4: Run tests to verify they pass**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter EngineHostTests`
Expected: PASS (7 tests).

- [ ] **Step 5: Commit**

```bash
git add app/Sources/FeedbaxKit/Engine/EngineHost.swift app/Tests/FeedbaxKitTests/EngineHostTests.swift
git commit -m "feat(engine): add EngineHost owning the frame clock and output stage"
```

---

### Task 3: `RenderView` — the render view stops driving

**Files:**
- Create: `app/Sources/FeedbaxKit/UI/RenderView.swift`
- Delete: `app/Sources/FeedbaxKit/UI/PreviewView.swift`
- Test: none new (this file is a `CAMetalLayer` + AppKit window callbacks — the same
  untestable boundary `FrameClock` documents; its logic all moved to Task 2, which is tested)

**Interfaces:**
- Consumes: Task 2's `EngineHost` (`attach(_:)`, `detach(_:)`), `RenderTarget`.
- Produces:
  - `final class RenderView: NSView, RenderTarget` — `init(host: EngineHost)`, `var metalLayer: CAMetalLayer`, `var drawableSizePixels: SIMD2<Int>`
  - `struct DisplayView: NSViewRepresentable` — `init(host: EngineHost)`

This deletes `PreviewView.swift` outright (spec, "Migration notes": 220 lines that become three things). The render loop moved to `EngineHost` in Task 2; the input handling moves to `PerformerInputMonitor` in Task 4. Copy the input-forwarding doc comments out of `PreviewView.swift` before deleting it — Task 4 re-uses them.

- [ ] **Step 1: Read the file being replaced**

Read `app/Sources/FeedbaxKit/UI/PreviewView.swift` in full. Task 4 needs its `keyDown`/`scrollWheel`/`magnify`/`mouseDragged` bodies and their doc comments verbatim (the view-height normalization rationale in particular is hard-won and must survive).

- [ ] **Step 2: Write `RenderView`**

Create `app/Sources/FeedbaxKit/UI/RenderView.swift`:

```swift
import SwiftUI
import AppKit
import Metal
import QuartzCore
import simd

/// SwiftUI's bridge to `RenderView` — the output window's entire content.
public struct DisplayView: NSViewRepresentable {
  public let host: EngineHost

  public init(host: EngineHost) { self.host = host }

  public func makeNSView(context: Context) -> RenderView { RenderView(host: host) }
  public func updateNSView(_ nsView: RenderView, context: Context) {}
}

/// A `CAMetalLayer` that knows how big it is and tells `EngineHost` when it comes and goes.
/// That is the whole job. It used to own the `FrameClock`, the `OutputStage`, the call to
/// `engine.step`, and every input event; all four moved out (`EngineHost`, Task 2, and
/// `PerformerInputMonitor`, Task 4) so that closing this window no longer stops the
/// instrument.
public final class RenderView: NSView, RenderTarget {
  private let host: EngineHost
  private let layerForMetal = CAMetalLayer()

  public var metalLayer: CAMetalLayer { layerForMetal }
  public var drawableSizePixels: SIMD2<Int> {
    SIMD2(Int(layerForMetal.drawableSize.width), Int(layerForMetal.drawableSize.height))
  }

  public init(host: EngineHost) {
    self.host = host
    super.init(frame: .zero)
    wantsLayer = true
    layerForMetal.device = host.engine.context.device
    layerForMetal.pixelFormat = .bgra8Unorm
    // The engine's own passes never touch this layer (they draw into the private-storage
    // accumulator `OutputStage` reads FROM) — framebuffer-only is safe and is the cheaper
    // drawable-allocation mode.
    layerForMetal.framebufferOnly = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("RenderView is built programmatically by DisplayView, never from a nib/storyboard")
  }

  public override func makeBackingLayer() -> CALayer { layerForMetal }

  public override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()
    syncDrawableSize()
    guard window != nil else {
      // Window closed. `EngineHost.detach` swaps back to the timer driver — the engine keeps
      // stepping, the accumulator keeps evolving, and reopening the window picks the image up
      // where it actually is rather than where it was when the window closed.
      host.detach(self)
      return
    }
    host.attach(self)
  }

  deinit { host.detach(self) }

  public override func setFrameSize(_ newSize: NSSize) {
    super.setFrameSize(newSize)
    syncDrawableSize()
  }

  /// Also covers moving the window to a projector with a different backing scale — AppKit
  /// sends `viewDidChangeBackingProperties` for that, and the drawable has to follow or the
  /// output is drawn at the old screen's pixel density.
  public override func viewDidChangeBackingProperties() {
    super.viewDidChangeBackingProperties()
    syncDrawableSize()
  }

  private func syncDrawableSize() {
    let scale = window?.backingScaleFactor ?? 1
    layerForMetal.contentsScale = scale
    layerForMetal.drawableSize = CGSize(width: bounds.width * scale, height: bounds.height * scale)
  }
}
```

- [ ] **Step 3: Delete the old view**

```bash
git rm app/Sources/FeedbaxKit/UI/PreviewView.swift
```

- [ ] **Step 4: Build**

Run: `swift build --package-path app`
Expected: FAIL, with errors only in `app/App/FeedbaxApp.swift` and `app/Sources/feedbax-dev/main.swift` (`cannot find 'PreviewView' in scope`). Those two entry points are rewritten in Task 5 — **do not** patch them here beyond what Step 5 does.

- [ ] **Step 5: Keep both entry points compiling with a temporary two-line edit**

In BOTH `app/App/FeedbaxApp.swift` and `app/Sources/feedbax-dev/main.swift`, replace the
`PreviewView(engine:surface:hudEnabled:)` line inside `ContentView.body` with:

```swift
      DisplayView(host: bootstrap.host)
        .frame(minWidth: 480, minHeight: 360)
```

This requires `AppBootstrap.host`, which does not exist yet — so instead, for this task only,
build the host locally in each entry point right after `bootstrap`:

```swift
let host: EngineHost = {
  do { return try EngineHost(engine: bootstrap.engine) } catch {
    FileHandle.standardError.write(Data("Feedbax: failed to start the renderer: \(error)\n".utf8))
    exit(1)
  }
}()
host.start()
```

and pass `host` to `DisplayView`. Task 5 deletes all of this and moves it into `AppBootstrap`.

- [ ] **Step 6: Build and run the whole suite**

Run: `swift build --package-path app`
Expected: PASS.
Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app`
Expected: PASS — the full suite, not just the new files. `GoldenFrameTests` and `WarpParityTests` in particular must still pass; nothing here should have changed a rendered pixel.

- [ ] **Step 7: Commit**

```bash
git add -A app/Sources/FeedbaxKit/UI app/App app/Sources/feedbax-dev
git commit -m "refactor(ui): replace PreviewView with RenderView driven by EngineHost"
```

---

### Task 4: `PerformerInputMonitor` — focus stops mattering

**Files:**
- Create: `app/Sources/FeedbaxKit/UI/PerformerInputMonitor.swift`
- Test: `app/Tests/FeedbaxKitTests/PerformerInputMonitorTests.swift`

**Interfaces:**
- Consumes: `KeyboardTrackpadSurface` (`keyDown(_ key: String)`, `scroll(dx:dy:)`, `magnify(_:)`, `modifiedDrag(dx:dy:)`), `Bindings`.
- Produces:
  - `enum PerformerInputMonitor.Decision { case forward, passThrough }`
  - `static func decideKey(firstResponderIsTextEditor: Bool, characters: String?) -> Decision`
  - `static func decidePointer(eventIsInOutputWindow: Bool) -> Decision`
  - `final class PerformerInputMonitor` — `init(surface:outputWindowIdentifier:)`, `install()`, `uninstall()`

**Gating rules** (spec: "the monitor must pass events through untouched when the first responder is an `NSText`-family view"):

1. **Keys** — forwarded no matter which window is key, EXCEPT when the key window's first
   responder is an `NSText`-family view (the preset-name field). Otherwise typing `e` into a
   preset name would fire the erase binding.
2. **Pointer gestures** (scroll / magnify / option-drag) — forwarded ONLY when the event's own
   window is the output window. This is narrower than the spec's flat "forward scrollWheel /
   magnify", and deliberately: the control panel is a scrollable form of sliders, and a
   two-finger scroll there must scroll the panel, not pan the shader. Pointer gestures are
   aimed at a thing under the cursor; keys are not.

- [ ] **Step 1: Write the failing tests**

Create `app/Tests/FeedbaxKitTests/PerformerInputMonitorTests.swift`:

```swift
import XCTest
import AppKit
@testable import FeedbaxKit

/// The monitor's *decisions* are pure and tested here. Installing a real
/// `NSEvent.addLocalMonitorForEvents` monitor and synthesizing events through a live app needs
/// a window server the test process does not have, so the install/uninstall plumbing is
/// verified by hand (Task 5's manual pass), exactly as `FrameClock` always has been.
final class PerformerInputMonitorTests: XCTestCase {
  func testKeysForwardWhenNoTextFieldIsFocused() {
    XCTAssertEqual(
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: false, characters: "e"),
      .forward)
  }

  func testKeysPassThroughWhileTypingInATextField() {
    XCTAssertEqual(
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: true, characters: "e"),
      .passThrough,
      "typing a preset name must not fire the erase binding")
  }

  func testKeysWithNoCharactersPassThrough() {
    XCTAssertEqual(
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: false, characters: nil),
      .passThrough)
    XCTAssertEqual(
      PerformerInputMonitor.decideKey(firstResponderIsTextEditor: false, characters: ""),
      .passThrough)
  }

  func testPointerGesturesOnlyForwardFromTheOutputWindow() {
    XCTAssertEqual(PerformerInputMonitor.decidePointer(eventIsInOutputWindow: true), .forward)
    XCTAssertEqual(PerformerInputMonitor.decidePointer(eventIsInOutputWindow: false),
                   .passThrough,
                   "two-finger scroll over the control panel scrolls the panel")
  }

  func testTextEditorDetectionRecognizesFieldEditorsAndTextViews() {
    XCTAssertTrue(PerformerInputMonitor.isTextEditor(NSTextView()))
    XCTAssertTrue(PerformerInputMonitor.isTextEditor(NSTextField()))
    XCTAssertFalse(PerformerInputMonitor.isTextEditor(NSView()))
    XCTAssertFalse(PerformerInputMonitor.isTextEditor(nil))
  }

  func testForwardedKeysReachTheSurface() throws {
    let bindings = try BindingsLoader.load(from: nil)
    let surface = KeyboardTrackpadSurface(bindings: bindings)
    let monitor = PerformerInputMonitor(surface: surface, outputWindowIdentifier: "output")
    monitor.handleKey(characters: "e", firstResponderIsTextEditor: false)
    XCTAssertNotNil(surface.poll(0), "a forwarded key produced a control write")
  }

  func testTypedKeysDoNotReachTheSurface() throws {
    let bindings = try BindingsLoader.load(from: nil)
    let surface = KeyboardTrackpadSurface(bindings: bindings)
    let monitor = PerformerInputMonitor(surface: surface, outputWindowIdentifier: "output")
    monitor.handleKey(characters: "e", firstResponderIsTextEditor: true)
    XCTAssertNil(surface.poll(0), "a key typed into a text field produced no control write")
  }
}
```

If `BindingsLoader.load(from: nil)` is not the signature used elsewhere, match whatever
`AppBootstrap.start()` calls — it is the same loader.

- [ ] **Step 2: Run tests to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter PerformerInputMonitorTests`
Expected: FAIL — `cannot find 'PerformerInputMonitor' in scope`.

- [ ] **Step 3: Write the implementation**

Create `app/Sources/FeedbaxKit/UI/PerformerInputMonitor.swift`:

```swift
import AppKit
import Foundation

/// One app-level `NSEvent` local monitor, installed once at bootstrap, replacing the
/// per-view input overrides `MetalHostView` used to carry. That is spec goal 4: a performer
/// tweaking a slider in the control window can still hit a key binding without clicking back
/// into the output window first.
public final class PerformerInputMonitor {
  private let surface: KeyboardTrackpadSurface
  private let outputWindowIdentifier: String
  private var monitor: Any?

  public enum Decision { case forward, passThrough }

  public init(surface: KeyboardTrackpadSurface, outputWindowIdentifier: String) {
    self.surface = surface
    self.outputWindowIdentifier = outputWindowIdentifier
  }

  /// Keys are forwarded regardless of which window is key — that is the whole point — but a
  /// local monitor also sees keystrokes destined for the control panel's own text fields
  /// (the preset-name field). Forwarding those would fire bindings while typing.
  public static func decideKey(firstResponderIsTextEditor: Bool, characters: String?) -> Decision {
    guard let characters, !characters.isEmpty else { return .passThrough }
    return firstResponderIsTextEditor ? .passThrough : .forward
  }

  /// Pointer gestures are narrower than keys on purpose: they are aimed at whatever is under
  /// the cursor. The control window is a scrollable form of sliders, so a two-finger scroll
  /// there must scroll the form, not pan the shader.
  public static func decidePointer(eventIsInOutputWindow: Bool) -> Decision {
    eventIsInOutputWindow ? .forward : .passThrough
  }

  /// `NSTextView` covers SwiftUI's `TextField` too: AppKit hands an editing text field its
  /// window's shared *field editor*, which is an `NSTextView`, as first responder.
  public static func isTextEditor(_ responder: NSResponder?) -> Bool {
    guard let responder else { return false }
    if responder is NSText { return true }
    if let view = responder as? NSView, view.isKind(of: NSTextField.self) { return true }
    return false
  }

  /// Internal seam the tests drive directly — the real monitor closure below is a thin shell
  /// over this plus `decideKey`.
  func handleKey(characters: String?, firstResponderIsTextEditor: Bool) {
    guard Self.decideKey(firstResponderIsTextEditor: firstResponderIsTextEditor,
                         characters: characters) == .forward,
          let characters else { return }
    surface.keyDown(characters)
  }

  /// Installs the monitor. Returning nil from the handler CONSUMES the event, which is what
  /// keeps a forwarded key from also reaching (say) a SwiftUI button's key equivalent;
  /// returning the event passes it through untouched.
  public func install() {
    guard monitor == nil else { return }
    monitor = NSEvent.addLocalMonitorForEvents(
      matching: [.keyDown, .scrollWheel, .magnify, .leftMouseDragged]
    ) { [weak self] event in
      guard let self else { return event }
      return self.handle(event) == .forward ? nil : event
    }
  }

  public func uninstall() {
    if let monitor { NSEvent.removeMonitor(monitor) }
    monitor = nil
  }

  deinit { uninstall() }

  private func handle(_ event: NSEvent) -> Decision {
    switch event.type {
    case .keyDown:
      let responder = (event.window ?? NSApp.keyWindow)?.firstResponder
      let isText = Self.isTextEditor(responder)
      // Escape and `f` both toggle fullscreen (spec §01 §1: "the original's Esc"; `f` is also
      // the bindings-table fullscreen key, `DefaultBindings.json`). Escape carries no
      // `ToggleEvent` at all, so it is handled here directly; `f` is ALSO forwarded to the
      // surface so its `.fullscreen` toggle still flows the normal control path — harmless,
      // since `Engine.handle(_:)`'s `.fullscreen` case is a deliberate no-op.
      if !isText, event.keyCode == 53 || event.charactersIgnoringModifiers == "f" {
        outputWindow()?.toggleFullScreen(nil)
        if event.keyCode == 53 { return .forward }   // Escape: consumed, nothing to forward
      }
      guard Self.decideKey(firstResponderIsTextEditor: isText,
                           characters: event.charactersIgnoringModifiers) == .forward else {
        return .passThrough
      }
      surface.keyDown(event.charactersIgnoringModifiers!)
      return .forward

    case .scrollWheel:
      guard isOutputWindowEvent(event), let height = eventViewHeight(event) else { return .passThrough }
      // `scrollingDeltaX/Y` are raw POINTS and one fast swipe can report 5–40 of them; fed
      // straight into `accumulate`'s ±1 range that slams the pan accumulator to its clamp in a
      // single event. Dividing by the output view's height turns "drag the full height of the
      // output" into "drive the axis across its whole −1...1 range", and scales with the
      // window automatically. `KeyboardTrackpadSurface` is deliberately AppKit-free and has no
      // view geometry of its own, which is why this normalization lives here.
      surface.scroll(dx: Float(event.scrollingDeltaX) / height,
                     dy: Float(event.scrollingDeltaY) / height)
      return .forward

    case .magnify:
      guard isOutputWindowEvent(event) else { return .passThrough }
      // `magnification` is already a small per-event ratio, not raw points — no normalization.
      surface.magnify(Float(event.magnification))
      return .forward

    case .leftMouseDragged:
      // Option-held drag: x → hue, y → theta (`KeyboardTrackpadSurface.modifiedDrag`). Plain
      // drags are intentionally not forwarded — the output view has no click-drag role in P1.
      guard event.modifierFlags.contains(.option), isOutputWindowEvent(event),
            let height = eventViewHeight(event) else { return .passThrough }
      surface.modifiedDrag(dx: Float(event.deltaX) / height, dy: Float(event.deltaY) / height)
      return .forward

    default:
      return .passThrough
    }
  }

  private func outputWindow() -> NSWindow? {
    NSApp.windows.first { $0.identifier?.rawValue == outputWindowIdentifier }
  }

  private func isOutputWindowEvent(_ event: NSEvent) -> Bool {
    Self.decidePointer(
      eventIsInOutputWindow: event.window != nil && event.window === outputWindow()
    ) == .forward
  }

  /// The output window's content height in points — the normalization denominator the old
  /// per-view handlers got from `bounds.height`.
  private func eventViewHeight(_ event: NSEvent) -> Float? {
    guard let height = event.window?.contentView?.bounds.height, height > 0 else { return nil }
    return Float(height)
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter PerformerInputMonitorTests`
Expected: PASS (7 tests).

- [ ] **Step 5: Commit**

```bash
git add app/Sources/FeedbaxKit/UI/PerformerInputMonitor.swift app/Tests/FeedbaxKitTests/PerformerInputMonitorTests.swift
git commit -m "feat(ui): forward performer input from an app-level event monitor"
```

---

### Task 5: `FeedbaxScenes` — two windows, one bootstrap

**Files:**
- Create: `app/Sources/FeedbaxKit/UI/FeedbaxScenes.swift`
- Modify: `app/Sources/FeedbaxKit/UI/AppBootstrap.swift` (add `host` + `inputMonitor`)
- Modify: `app/App/FeedbaxApp.swift` (replace `ContentView` + `WindowGroup` wholesale)
- Modify: `app/Sources/feedbax-dev/main.swift` (same, keeping its `AppDelegate`)
- Test: `app/Tests/FeedbaxKitTests/AppBootstrapTests.swift` (extend)

**Interfaces:**
- Consumes: Task 2's `EngineHost`, Task 3's `DisplayView`, Task 4's `PerformerInputMonitor`, existing `OperatorPanel(vm:)` and `EngineViewModel`.
- Produces:
  - `enum FeedbaxWindow { static let outputID = "output"; static let controlsID = "controls" }`
  - `struct FeedbaxScenes: Scene` — `init(bootstrap: AppBootstrap)`
  - `AppBootstrap.host: EngineHost`, `AppBootstrap.inputMonitor: PerformerInputMonitor`

- [ ] **Step 1: Write the failing test**

Add to `app/Tests/FeedbaxKitTests/AppBootstrapTests.swift`:

```swift
  func testWindowIdentifiersAreDistinctAndStable() {
    // The monitor finds the output window by identifier (`PerformerInputMonitor
    // .outputWindow()`), and SwiftUI restores each `Window` scene's frame by its id — both
    // break silently if these two ever collide or drift.
    XCTAssertEqual(FeedbaxWindow.outputID, "output")
    XCTAssertEqual(FeedbaxWindow.controlsID, "controls")
    XCTAssertNotEqual(FeedbaxWindow.outputID, FeedbaxWindow.controlsID)
  }
```

- [ ] **Step 2: Run test to verify it fails**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter AppBootstrapTests`
Expected: FAIL — `cannot find 'FeedbaxWindow' in scope`.

- [ ] **Step 3: Write the scenes**

Create `app/Sources/FeedbaxKit/UI/FeedbaxScenes.swift`:

```swift
import SwiftUI

/// Window ids, in one place because two unrelated mechanisms depend on them: SwiftUI restores
/// each `Window` scene's frame and screen across launches keyed by id, and
/// `PerformerInputMonitor` finds the output window by matching `NSWindow.identifier`.
public enum FeedbaxWindow {
  public static let outputID = "output"
  public static let controlsID = "controls"
}

/// The instrument's whole window layout, shared verbatim by both entry points so `swift run`
/// and `Feedbax.app` cannot drift (design §8). Two `Window` scenes rather than `WindowGroup`s:
/// `Window` is single-instance and gets a Window-menu entry for free, so a closed window can
/// always be brought back (spec goal 3).
///
/// Closing either window tears down only that window's views. `EngineHost` is untouched and
/// keeps stepping — closing the output window swaps it back to the timer driver rather than
/// stopping the feedback loop (spec goal 2).
public struct FeedbaxScenes: Scene {
  private let bootstrap: AppBootstrap

  public init(bootstrap: AppBootstrap) { self.bootstrap = bootstrap }

  public var body: some Scene {
    Window("Output", id: FeedbaxWindow.outputID) {
      DisplayView(host: bootstrap.host)
        .frame(minWidth: 320, minHeight: 240)
        // The output is the projector image: no padding, no chrome inside the window, and a
        // black ground so letterboxing around an aspect-fit frame reads as intentional.
        .background(Color.black)
        .ignoresSafeArea()
    }
    .defaultSize(width: 1280, height: 720)

    Window("Controls", id: FeedbaxWindow.controlsID) {
      OperatorPanel(vm: bootstrap.viewModel)
        .frame(minWidth: 300, minHeight: 400)
    }
    .defaultSize(width: 720, height: 800)
  }
}
```

- [ ] **Step 4: Extend `AppBootstrap`**

In `app/Sources/FeedbaxKit/UI/AppBootstrap.swift`:

Add the stored properties alongside `engine` / `keyboardSurface` / `viewModel`:

```swift
  public let host: EngineHost
  public let inputMonitor: PerformerInputMonitor
```

Add them to the private `init`'s parameter list and assignments, following the existing style.

In `start()`, after `viewModel` is built and the surfaces are registered, and before the
`AudioAnalysis` block, add:

```swift
    // The host owns the clock from here on, and starts stepping BEFORE any window exists —
    // that ordering is the point of the split (spec goal 2). `OutputStage` construction now
    // throws out of here instead of being swallowed by `try?` inside the render view.
    let host = try EngineHost(engine: engine)
    host.start()
    host.hudEnabled = viewModel.hudEnabled

    let inputMonitor = PerformerInputMonitor(
      surface: keyboard, outputWindowIdentifier: FeedbaxWindow.outputID)
    inputMonitor.install()
```

and pass both into the `AppBootstrap(...)` return.

`EngineViewModel.hudEnabled` no longer has a view to flow into (it used to reach `OutputStage`
through `PreviewView`'s `updateNSView`). Wire it to the host instead — in `EngineViewModel`,
add:

```swift
  /// Set by `AppBootstrap.start()`. The HUD toggle used to reach `OutputStage` by way of
  /// `PreviewView.updateNSView`; with the output stage owned by `EngineHost` there is no view
  /// in that path any more, so the toggle talks to the host directly.
  public weak var host: EngineHost?
```

and in the `hudEnabled` toggle's setter path (`setHUDEnabled` or wherever `hudEnabled` is
mutated — check `EngineViewModel.swift:333` and its call site in `OperatorPanel`), add
`host?.hudEnabled = hudEnabled`. If `hudEnabled` is a bare `@Published public var` bound
directly by the panel's `Toggle`, give it a `didSet { host?.hudEnabled = hudEnabled }`.

Then in `AppBootstrap.start()`, after building the host: `viewModel.host = host`.

- [ ] **Step 5: Rewrite `app/App/FeedbaxApp.swift`**

Replace the whole `ContentView` struct and the `WindowGroup` body with the shared scenes:

```swift
import SwiftUI
import Foundation
import FeedbaxKit

/// The `Feedbax.app` bundle's `@main` entry point. Everything about *what* the app consists of
/// — the engine, the always-running `EngineHost`, the input monitor, both windows — lives in
/// `FeedbaxKit` (`AppBootstrap`, `FeedbaxScenes`) so this bundle and `feedbax-dev` cannot
/// drift (design §8). Unlike `feedbax-dev`, a real bundle with an Info.plist already launches
/// as a regular, frontmost, focusable app via Launch Services, so there is no
/// activation-policy workaround here.
///
/// `AppBootstrap.start()` can throw (a GPU-less machine, a corrupt bundled
/// `DefaultBindings.json`, a failed output-stage pipeline) — there is no windowed way to
/// recover, so a failure prints to stderr and exits before any window opens.
let bootstrap: AppBootstrap = {
  do {
    return try AppBootstrap.start()
  } catch {
    FileHandle.standardError.write(Data("Feedbax: failed to start the engine: \(error)\n".utf8))
    exit(1)
  }
}()

@main
struct FeedbaxApp: App {
  var body: some Scene {
    FeedbaxScenes(bootstrap: bootstrap)
  }
}
```

- [ ] **Step 6: Rewrite the tail of `app/Sources/feedbax-dev/main.swift`**

Leave `--soak` and everything above it untouched. Replace only `ContentView`, the
`FeedbaxApp` struct's `body`, and keep `AppDelegate` exactly as it is:

```swift
struct FeedbaxApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    FeedbaxScenes(bootstrap: bootstrap)
  }
}

FeedbaxApp.main()
```

Delete the file's now-unused `ContentView` struct and the temporary local `host` from Task 3
Step 5 (in both entry points).

- [ ] **Step 7: Build and run everything**

Run: `swift build --package-path app`
Expected: PASS, no warnings about unused `PreviewView`/`ContentView` remnants.
Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app`
Expected: PASS — whole suite.

- [ ] **Step 8: Manual verification pass**

Run: `swift run --package-path app feedbax-dev`

Confirm each, and report what you actually saw (not what you expect):
1. Two windows open: "Output" (black, rendering) and "Controls" (the operator panel).
2. Moving a slider in Controls changes the Output image while Controls stays frontmost.
3. Pressing a bound key (e.g. `e`, erase) with **Controls** focused changes the Output image.
4. Typing into the preset-name field does NOT fire bindings.
5. Two-finger scroll over the Controls panel scrolls the panel; over Output it pans the shader.
6. Green button / ⌃⌘F on Output goes fullscreen; `f` and Escape toggle it from either window.
7. Close the Output window. The app stays alive; Controls still works. Reopen it from
   **Window → Output** — the image has kept evolving (it is not the frame it was closed on,
   and not a black/reset accumulator).
8. Quit and relaunch: each window comes back on the screen and at the size it was left.

- [ ] **Step 9: Commit**

```bash
git add -A app docs
git commit -m "feat(ui): split output and controls into separate windows"
```

---

### Task 6: Stop republishing unchanged mirrors every frame

**Files:**
- Modify: `app/Sources/FeedbaxKit/UI/EngineViewModel.swift:172-183` (`refreshMirrorsFromTruth`)
- Test: `app/Tests/FeedbaxKitTests/EngineViewModelTests.swift` (extend)

**Interfaces:**
- Consumes: existing `EngineViewModel` mirrors (`sInvertOn`, `layerOn`, `wave1On`, `wave2On`, `worldBumpOn`, `waveBumpOn`, `kittyBumpOn`, `eraseValue`) and `objectWillChange`.
- Produces: no new API — `refreshMirrorsFromTruth` publishes only on actual change.

`poll` runs `refreshMirrorsFromTruth` every frame, which assigns eight `@Published`
properties at 60 Hz whether or not anything changed, firing `objectWillChange` and
re-evaluating `OperatorPanel.body` 60 times a second. Spec, "Fix carried along": the split is
what makes it bite, since the panel is now its own window with its own draw cycle.

- [ ] **Step 1: Write the failing test**

Add to `app/Tests/FeedbaxKitTests/EngineViewModelTests.swift`:

```swift
  func testPollDoesNotRepublishWhenNothingChanged() throws {
    let engine = try Engine(context: try MetalContext())
    let vm = EngineViewModel(engine: engine, presetStore: PresetStore())
    var publishCount = 0
    let subscription = vm.objectWillChange.sink { _ in publishCount += 1 }
    defer { subscription.cancel() }

    _ = vm.poll(0)          // first poll may legitimately publish (mirrors sync to truth)
    publishCount = 0
    _ = vm.poll(1)
    _ = vm.poll(2)
    XCTAssertEqual(publishCount, 0,
                   "an idle frame must not re-render the operator panel")
  }

  func testPollStillPublishesWhenTruthChanges() throws {
    let engine = try Engine(context: try MetalContext())
    let vm = EngineViewModel(engine: engine, presetStore: PresetStore())
    _ = vm.poll(0)
    var publishCount = 0
    let subscription = vm.objectWillChange.sink { _ in publishCount += 1 }
    defer { subscription.cancel() }

    engine.waveforms.wave1Enabled = !engine.waveforms.wave1Enabled
    _ = vm.poll(1)
    XCTAssertGreaterThan(publishCount, 0, "a real change still reaches the panel")
    XCTAssertEqual(vm.wave1On, engine.waveforms.wave1Enabled)
  }
```

Add `import Combine` at the top of the test file if it is not already there.

- [ ] **Step 2: Run tests to verify they fail**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter EngineViewModelTests`
Expected: FAIL on `testPollDoesNotRepublishWhenNothingChanged` — publishCount is 2 (one per poll), not 0.

- [ ] **Step 3: Write the implementation**

Replace `refreshMirrorsFromTruth` in `app/Sources/FeedbaxKit/UI/EngineViewModel.swift`:

```swift
  /// The read side of finding 4's single-owner fix — see `poll`'s call site for why this runs
  /// every frame. `engine == nil` (the bare `EngineViewModel()` unit tests construct) makes
  /// this a harmless no-op, same as every other engine-touching method in this class.
  ///
  /// Every assignment here is guarded by a compare, because `poll` runs at the frame rate: a
  /// bare assignment to a `@Published` property fires `objectWillChange` even when the value
  /// is identical, which re-evaluated `OperatorPanel.body` 60 times a second for nothing. With
  /// the panel in its own window (the control/display split) that waste is a whole window's
  /// draw cycle, not a corner of one.
  private func refreshMirrorsFromTruth() {
    guard let engine else { return }
    func assign<T: Equatable>(_ keyPath: ReferenceWritableKeyPath<EngineViewModel, T>, _ value: T) {
      if self[keyPath: keyPath] != value { self[keyPath: keyPath] = value }
    }
    assign(\.sInvertOn, engine.router.sInvert < 0)   // `sInvert` is ±1 — ControlRouter's doc
    assign(\.layerOn, engine.sticker.layer.enabled)  // sticker/movie in lockstep — Engine.handle
    assign(\.wave1On, engine.waveforms.wave1Enabled)
    assign(\.wave2On, engine.waveforms.wave2Enabled)
    assign(\.worldBumpOn, engine.bumpsEnabled.world)
    assign(\.waveBumpOn, engine.bumpsEnabled.wave)
    assign(\.kittyBumpOn, engine.bumpsEnabled.kitty)
    assign(\.eraseValue, Double(engine.router.eraseControl))
  }
```

`assign` needs the mirrors to be settable through a `ReferenceWritableKeyPath`. They are
declared `public private(set)`, which is settable from inside the type — but a key path
cannot see through `private(set)` from a nested function in every Swift version. If the
compiler rejects it, drop the helper and write eight explicit guards instead:

```swift
    let newSInvert = engine.router.sInvert < 0
    if sInvertOn != newSInvert { sInvertOn = newSInvert }
```

...repeated for each mirror. Correctness is identical; take whichever compiles.

- [ ] **Step 4: Run tests to verify they pass**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app --filter EngineViewModelTests`
Expected: PASS.

- [ ] **Step 5: Run the whole suite and commit**

Run: `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app`
Expected: PASS.

```bash
git add app/Sources/FeedbaxKit/UI/EngineViewModel.swift app/Tests/FeedbaxKitTests/EngineViewModelTests.swift
git commit -m "perf(ui): publish operator-panel mirrors only when they actually change"
```

---

### Task 7: Mark the spec implemented and update the docs

**Files:**
- Modify: `docs/superpowers/specs/2026-08-24-control-display-split-design.md` (status + open question)
- Modify: `README.md` (only if it describes the app as a single window — check first)

- [ ] **Step 1: Resolve the spec's status and open question**

In the spec, change `**Status:** draft for review` to
`**Status:** implemented 2026-08-25 (docs/superpowers/plans/2026-08-25-control-display-split.md)`.

Replace the "Open question" section's body with the decision as taken:

```markdown
**Resolved:** `TimerDriver` runs at the full `engine.frameRate` when nothing is attached.
Throttling would make the loop's evolution depend on whether anyone was watching, which for a
feedback instrument is a behavioral change, not an optimization.
```

- [ ] **Step 2: Check the README**

Run: `grep -n -i "window\|preview" README.md`

If the README describes a single window or names `PreviewView`, update it to describe the two
windows (Output on the projector, Controls on the laptop, either reopenable from the Window
menu). If it says nothing about windows, change nothing.

- [ ] **Step 3: Commit**

```bash
git add docs README.md
git commit -m "docs: mark the control/display split spec implemented"
```

---

## Self-Review

**Spec coverage:**

| Spec item | Task |
|---|---|
| Goal 1 — separate windows on separate screens | 5 |
| Goal 2 — engine runs with either/both windows closed | 1 (`TimerDriver`), 2 (`EngineHost`), 3 (`RenderView` detach) |
| Goal 3 — either window reopenable from the Window menu | 5 (`Window` scenes) |
| Goal 4 — bindings work whenever the app is frontmost | 4 |
| Goal 5 — both entry points identical | 5 (shared `FeedbaxScenes`) |
| `EngineHost` | 2 |
| `FrameDriver` + `DisplayLinkDriver` + `TimerDriver` | 1 |
| Scenes | 5 |
| `RenderView` (was `MetalHostView`) | 3 |
| `OutputStage` moves up, `try?` becomes loud | 2 |
| Input monitor + text-field care | 4 |
| Fix carried along — `refreshMirrorsFromTruth` | 6 |
| Testing — host steps with no target | 2 (`testHostStepsWithNoTargetAttached`) |
| Testing — attach/detach swaps without drop or double-step | 2 (`testAttachSwapsDriversWithoutDroppingOrDoubleSteppingAFrame`) |
| Testing — accumulator survives detach/reattach | 2 (`testAccumulatorSurvivesDetachAndReattach`) |
| Testing — key monitor forwards, and doesn't while typing | 4 |
| Migration note — `PreviewView.swift` doesn't survive as one file | 3 (deleted; split across `FrameDriver`/`EngineHost`/`RenderView`/`PerformerInputMonitor`) |
| Open question — `TimerDriver` rate | Resolved to full rate (Global Constraints, Task 7) |

Non-goals honored: no preview in the control window (Task 5 puts only `OperatorPanel` there),
no display-picker UI (native fullscreen only), no networked surface.

**Deviation from the spec, deliberate:** the spec says the monitor forwards `scrollWheel` and
`magnify` unconditionally. Task 4 forwards pointer gestures only from the output window, so
scrolling the control panel scrolls the panel. Rationale is in Task 4's gating rules and in
the shipped code comment.

**Not carried over from `MetalHostView`:** `acceptsFirstResponder` / `makeFirstResponder` /
the empty `mouseDown` override. All three existed to make a view-level responder chain
deliver input; with an app-level monitor there is no responder chain to win.

**Type consistency check:** `FrameTick`, `FrameDriver.rate/updateRate/invalidate`,
`RenderTarget.metalLayer/drawableSizePixels`, `EngineHost.start/attach/detach/hudEnabled/
frameCount/isAttached/engine/outputStage`, `FeedbaxWindow.outputID/controlsID`,
`PerformerInputMonitor.decideKey/decidePointer/isTextEditor/handleKey/install/uninstall`,
`AppBootstrap.host/inputMonitor` — each name is defined in exactly one task and used with the
same spelling in every later task.
