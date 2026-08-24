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

/// Parses `--soak WxH@fps` (e.g. `7680x4320@60`), the optional `--seconds N` (default 60), and
/// the optional `--accumulator-format rgba16f|rgba8` (default rgba8). Returns nil when `--soak`
/// isn't present at all — the caller falls through to the normal windowed app, unchanged from
/// before Task 24. A `--soak` that IS present but malformed (bad WxH@fps, unknown format name)
/// exits immediately with a usage error rather than silently falling through — a typo in a CI
/// gate's invocation should fail loudly, not quietly run the windowed app and report nothing.
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

  var seconds = 60.0
  if let secondsIndex = args.firstIndex(of: "--seconds"), secondsIndex + 1 < args.count,
     let parsed = Double(args[secondsIndex + 1]), parsed > 0 {
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
/// it's what actually bounds achievable throughput. `cpuMs` is the host-clock time to encode
/// and submit (`engine.step` + `commit()`, BEFORE the blocking wait) — CPU-side cost only.
/// `gpuMs` is the command buffer's own `gpuEndTime - gpuStartTime` — actual device execution
/// time, populated once the buffer has completed.
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

  let sortedCPU = cpuMs.sorted(), sortedGPU = gpuMs.sorted(), sortedFrame = frameMs.sorted()
  func report(_ label: String, _ sorted: [Double]) {
    print(String(format: "%@: p50=%.3fms p95=%.3fms p99=%.3fms max=%.3fms",
                 label, percentile(sorted, 0.50), percentile(sorted, 0.95),
                 percentile(sorted, 0.99), sorted.last ?? 0))
  }
  report("CPU  ", sortedCPU)
  report("GPU  ", sortedGPU)
  report("Frame", sortedFrame)

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

/// `PreviewView` + `OperatorPanel` side by side (Task 20's "panel beside PreviewView in an
/// HSplitView"). `@ObservedObject`, not a plain `let`, is what makes this redraw — and, in
/// particular, re-invoke `PreviewView.updateNSView` with a fresh `hudEnabled` — whenever the
/// operator panel changes `EngineViewModel.hudEnabled` or any other `@Published` mirror.
struct ContentView: View {
  let engine: Engine
  let keyboardSurface: KeyboardTrackpadSurface
  @ObservedObject var viewModel: EngineViewModel

  var body: some View {
    HSplitView {
      PreviewView(engine: engine, surface: keyboardSurface, hudEnabled: viewModel.hudEnabled)
        .frame(minWidth: 480, minHeight: 360)
      OperatorPanel(vm: viewModel)
        .frame(minWidth: 300, idealWidth: 340)
    }
  }
}

/// SwiftUI's `App` protocol requires a bare `init()` (the system constructs the app struct
/// itself), so `bootstrap` can't be passed in as a constructor argument — it's the file-scope
/// global built above instead, referenced directly from `body`.
struct FeedbaxApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup("Feedbax") {
      ContentView(
        engine: bootstrap.engine, keyboardSurface: bootstrap.keyboardSurface,
        viewModel: bootstrap.viewModel
      )
      .frame(minWidth: 800, minHeight: 400)
    }
  }
}

FeedbaxApp.main()
