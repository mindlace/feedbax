import SwiftUI
import AppKit
import Foundation
import Dispatch
import Metal
import simd
import FeedbaxKit

// MARK: - Soak mode (Task 24)
//
// design §10's P1 gate: "sustains 8K/60 for ≥ 10 min at parity defaults on a base M4 mini
// (p99 frame time < 16.7 ms, measured by a built-in frame-time HUD)". `--soak WxH@fps
// --seconds N` runs that measurement headless — no window, no display link — via a tight loop
// that waits for each frame's GPU work to finish (`waitUntilCompleted`) before starting the
// next, the same idiom `GoldenRunner.render` uses for deterministic headless stepping. That's
// a MORE conservative measurement than a live, triple-buffered `FrameClock` gets: a real
// display link overlaps one frame's GPU execution with the next frame's CPU encode, where this
// loop runs them fully serially. So the p99 this prints is a pessimistic stand-in for the real
// (better) overlapped frame time the gate actually cares about — a PASS here is a safe PASS.
//
// **`--seconds` is UNPACED, not a wall-clock timer.** It sets how many simulated frames run
// (`seconds × fps`, fed to the engine's clock as `time = frameIndex / fps`) — nothing throttles
// the loop to that rate, so it rips through frames as fast as `waitUntilCompleted` allows. On a
// fast GPU that finishes each frame well under budget, `--seconds 600` does NOT run for 10
// real-world minutes and is therefore NOT a genuine sustained/thermal soak — see
// `docs/superpowers/plans/p1-soak-gate.md`'s "Simulated duration vs. wall clock" section. The
// final summary below prints both durations explicitly so this is never silently ambiguous.

/// `--soak`'s parsed value: target canvas size/rate, how long to run, and which accumulator
/// pixel format to build the engine with (design §4: "RGBA8 accumulator by default; RGBA16F
/// as a quality toggle where bandwidth allows" — `--accumulator-format rgba16f` reaches that
/// toggle, now that `Engine.init` takes it as a parameter instead of a hardcoded constant).
struct SoakConfig {
  var size: SIMD2<Int>
  var fps: Int
  var seconds: Double
  var accumulatorFormat: MTLPixelFormat
  var accumulatorFormatLabel: String
}

/// Parses `--soak WxH@fps` (e.g. `7680x4320@60`), the optional `--seconds N` (default 60,
/// SIMULATED seconds — see the file-level soak-mode comment above), and the optional
/// `--accumulator-format rgba16f|rgba8` (default rgba8). Returns nil when `--soak` isn't
/// present at all — the caller falls through to the normal windowed app, unchanged from before
/// Task 24. A `--soak` that IS present but malformed (bad WxH@fps, an unparseable/non-positive
/// `--seconds` value, unknown format name) exits immediately with a usage error rather than
/// silently falling through or silently defaulting — a typo in a CI gate's invocation should
/// fail loudly, not quietly run the wrong thing (or the windowed app) and report nothing.
func parseSoakConfig(_ args: [String]) -> SoakConfig? {
  guard let soakIndex = args.firstIndex(of: "--soak") else { return nil }
  func usageError(_ message: String) -> Never {
    FileHandle.standardError.write(Data("feedbax-dev: \(message)\n".utf8))
    exit(64)
  }
  guard soakIndex + 1 < args.count else {
    usageError("--soak requires a WxH@fps argument, e.g. --soak 7680x4320@60")
  }
  let spec = args[soakIndex + 1]
  let atParts = spec.split(separator: "@")
  guard atParts.count == 2, let fps = Int(atParts[1]), fps > 0 else {
    usageError("couldn't parse --soak value '\(spec)' — expected WxH@fps, e.g. 7680x4320@60")
  }
  let dims = atParts[0].split(separator: "x")
  guard dims.count == 2, let width = Int(dims[0]), let height = Int(dims[1]),
        width > 0, height > 0 else {
    usageError("couldn't parse --soak value '\(spec)' — expected WxH@fps, e.g. 7680x4320@60")
  }

  // Default (no `--seconds` at all) stays 60; once the FLAG is present, every failure mode —
  // missing value, unparseable, zero/negative — fails loudly instead of silently falling back
  // to that default, mirroring `--soak`'s own value and `--accumulator-format`'s unknown-name
  // handling above.
  var seconds = 60.0
  if let secondsIndex = args.firstIndex(of: "--seconds") {
    guard secondsIndex + 1 < args.count else {
      usageError("--seconds requires a value, e.g. --seconds 600")
    }
    let value = args[secondsIndex + 1]
    guard let parsed = Double(value), parsed > 0 else {
      usageError("couldn't parse --seconds value '\(value)' — expected a positive number of simulated seconds")
    }
    seconds = parsed
  }

  var format: MTLPixelFormat = .rgba8Unorm
  var formatLabel = "rgba8"
  if let formatIndex = args.firstIndex(of: "--accumulator-format"), formatIndex + 1 < args.count {
    switch args[formatIndex + 1].lowercased() {
    case "rgba16f", "rgba16float": format = .rgba16Float; formatLabel = "rgba16f"
    case "rgba8", "rgba8unorm": format = .rgba8Unorm; formatLabel = "rgba8"
    default: usageError("unknown --accumulator-format '\(args[formatIndex + 1])' — expected rgba8 or rgba16f")
    }
  }

  return SoakConfig(size: SIMD2(width, height), fps: fps, seconds: seconds,
                    accumulatorFormat: format, accumulatorFormatLabel: formatLabel)
}

/// Nearest-rank percentile over a PRE-SORTED array — matches how frame-time HUDs conventionally
/// report percentiles (the observed Nth-ranked sample, not an interpolated value between two).
func percentile(_ sorted: [Double], _ p: Double) -> Double {
  guard !sorted.isEmpty else { return 0 }
  let rank = Int((p * Double(sorted.count)).rounded(.up))
  return sorted[min(max(rank - 1, 0), sorted.count - 1)]
}

/// Runs the soak and returns a process exit code (0 PASS, 1 FAIL) so this can gate CI the way
/// any other check does. Builds a fresh headless `Engine` (own `MetalContext`, no
/// `AppBootstrap`/live microphone — matching `GoldenRunner`'s headless convention, not
/// `AppBootstrap.start()`'s windowed-app one), applies the webUI-parity startup vector
/// (`ControlRouter.applyStartupDefaults`, spec §04 §1.1 — the same one `AppBootstrap.start()`
/// applies for a real session), turns the sticker layer on (design's "pic enable" toggle
/// defaults off; the soak exercises the layer path a performer's session would actually hit),
/// and leaves waveforms at their own parity default (`WaveformRenderer.wave1Enabled` is already
/// `true` out of the box). The sticker folder (`input/transparent-background/`) is empty in a
/// fresh checkout; `StickerSource.tick` tolerates that by returning nil (its own doc comment),
/// so the layer draws nothing but every other stage of the frame recipe — erase, warp,
/// composite, waveform overlay — still runs exactly as it would with a folder full of stickers.
///
/// Per frame: `frameMs` is the full wall-clock loop iteration (encode through
/// `waitUntilCompleted` returning) — what's graded against the gate, since in this serial loop
/// it's what actually bounds achievable throughput. `cpuMs` is the host-clock time from just
/// before creating that frame's command buffer through `commit()` returning — i.e.
/// command-buffer creation + `engine.step`'s encode + `commit()`'s submit, all BEFORE the
/// blocking wait — CPU-side cost only. `gpuMs` is the command buffer's own `gpuEndTime -
/// gpuStartTime` — actual device execution time, populated once the buffer has completed.
///
/// The loop itself is UNPACED (see the file-level comment above): `frameCount` bounds how many
/// frames run, not how long the process runs for. The final summary prints the real wall-clock
/// elapsed time alongside the simulated duration so that distinction is never left implicit.
func runSoak(_ config: SoakConfig) -> Int32 {
  print("feedbax-dev --soak: \(config.size.x)x\(config.size.y)@\(config.fps) for " +
        "\(Int(config.seconds))s, accumulator=\(config.accumulatorFormatLabel)")

  let context: MetalContext
  let engine: Engine
  do {
    context = try MetalContext()
    engine = try Engine(context: context, accumulatorFormat: config.accumulatorFormat)
  } catch {
    FileHandle.standardError.write(Data("feedbax-dev: failed to start the engine: \(error)\n".utf8))
    return 1
  }

  engine.router.applyStartupDefaults(at: 0)
  engine.setResolution(config.size)
  engine.frameRate = config.fps
  engine.sticker.layer.enabled = true

  let frameCount = Int((config.seconds * Double(config.fps)).rounded())
  var cpuMs: [Double] = []; cpuMs.reserveCapacity(frameCount)
  var gpuMs: [Double] = []; gpuMs.reserveCapacity(frameCount)
  var frameMs: [Double] = []; frameMs.reserveCapacity(frameCount)

  func nowNs() -> UInt64 { DispatchTime.now().uptimeNanoseconds }
  let progressEvery = max(config.fps, 1)   // ~once per simulated second
  let loopStart = nowNs()   // real wall clock — the loop is unpaced, this is NOT `config.seconds`
  for i in 0..<frameCount {
    let time = Double(i) / Double(config.fps)
    let frameStart = nowNs()

    let commandBuffer = context.queue.makeCommandBuffer()!
    _ = engine.step(at: time, commandBuffer: commandBuffer)
    commandBuffer.commit()
    let cpuEnd = nowNs()
    commandBuffer.waitUntilCompleted()
    let frameEnd = nowNs()
    context.pool.endFrame()

    cpuMs.append(Double(cpuEnd - frameStart) / 1_000_000)
    gpuMs.append((commandBuffer.gpuEndTime - commandBuffer.gpuStartTime) * 1000)
    frameMs.append(Double(frameEnd - frameStart) / 1_000_000)

    if (i + 1) % progressEvery == 0 || i == frameCount - 1 {
      print("  ...\(i + 1)/\(frameCount) frames (\(Int(Double(i + 1) / Double(config.fps)))s simulated)")
    }
  }
  let loopEnd = nowNs()

  let sortedCPU = cpuMs.sorted(), sortedGPU = gpuMs.sorted(), sortedFrame = frameMs.sorted()
  func report(_ label: String, _ sorted: [Double]) {
    print(String(format: "%@: p50=%.3fms p95=%.3fms p99=%.3fms max=%.3fms",
                 label, percentile(sorted, 0.50), percentile(sorted, 0.95),
                 percentile(sorted, 0.99), sorted.last ?? 0))
  }
  report("CPU  ", sortedCPU)
  report("GPU  ", sortedGPU)
  report("Frame", sortedFrame)

  // The loop is UNPACED (file-level comment above) — `config.seconds`/`frameCount` bound the
  // SIMULATED timeline fed to the engine's clock, not how long this process actually ran.
  // Printing both, explicitly, every run: a fast GPU finishes `--seconds 600` in well under 10
  // real minutes, which means that invocation alone is NOT the sustained/thermal soak design
  // §10 wants — see docs/superpowers/plans/p1-soak-gate.md's "Simulated duration vs. wall
  // clock" section for how to actually get a real-time-bounded run.
  let wallClockSeconds = Double(loopEnd - loopStart) / 1_000_000_000
  let simulatedSeconds = Double(frameCount) / Double(config.fps)
  print(String(format: "Elapsed: %.2fs wall-clock (unpaced) for %.0fs simulated (%d frames @ %dfps)",
               wallClockSeconds, simulatedSeconds, frameCount, config.fps))

  // design §10's P1 gate, literally: "p99 frame time < 16.7 ms".
  let gateMs = 16.7
  let framesP99 = percentile(sortedFrame, 0.99)
  let passed = framesP99 < gateMs
  print(passed
    ? String(format: "PASS: frame p99 %.3fms < %.3fms gate", framesP99, gateMs)
    : String(format: "FAIL: frame p99 %.3fms >= %.3fms gate", framesP99, gateMs))
  return passed ? 0 : 1
}

if let soakConfig = parseSoakConfig(CommandLine.arguments) {
  exit(runSoak(soakConfig))
}

// Engine assembly (Task 19/20) now lives in `AppBootstrap` (Task 23) so `Feedbax.app`'s
// `FeedbaxApp.swift` can share it verbatim instead of duplicating the do/catch below.
let bootstrap: AppBootstrap
do {
  bootstrap = try AppBootstrap.start()
} catch {
  FileHandle.standardError.write(Data("feedbax-dev: failed to start the engine: \(error)\n".utf8))
  exit(1)
}

/// `swift run`'s unbundled executable has no Info.plist/nib, so — unlike a proper `.app`
/// bundle (Task 23) — nothing makes this process the frontmost, regular, focusable app on its
/// own; without this, the window can open behind other apps or never accept keystrokes at all
/// (review item: "keyboard likely never reaches MetalHostView" — this is the other half of
/// that fix, `MetalHostView.viewDidMoveToWindow`'s `makeFirstResponder` call is the first).
/// `NSApplicationDelegateAdaptor` is SwiftUI's hook for exactly this kind of one-time AppKit
/// setup that has to run from `applicationDidFinishLaunching`, not from a `Scene`'s `body`.
/// `Feedbax.app`'s `FeedbaxApp.swift` doesn't need this: a real bundle with an Info.plist
/// already launches as a regular, frontmost, focusable app via Launch Services.
final class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    NSApp.setActivationPolicy(.regular)
    NSApp.activate()
  }
}

struct FeedbaxApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    FeedbaxScenes(bootstrap: bootstrap)
  }
}

FeedbaxApp.main()
