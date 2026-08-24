import AVFoundation
import Foundation

/// One render frame's worth of audio analysis (spec §03 §9's per-frame pseudocode) — sampled
/// once per the `ctrlbang`/`audiobang` cadence, not once per audio sample. Task 18 draws
/// `wave1Points`/`wave2Points`/consumes `waveBumpRaw`; Task 19 wires `worldBump` into
/// `RenderParams` and routes `kittyBumpRaw` through `KittyBumpReceiver` into sticker
/// transforms. All three "bump" enables default OFF in the original (spec §03 §10) — that
/// gating is engine-side (Task 19); the DSP here always runs regardless.
public struct FrameAudio {
  /// 144.3 Hz band → `abs~` → `slide~` 2500/2500 → `average~` absolute(100) → snapshot ×
  /// 0.05 (spec §03 §7a). Drives the main videoplane's Z position downstream.
  public var worldBump: Float
  /// 46.7 Hz band × 2.2 → mean since last frame, **no rectifier** (spec §03 §7b) — this is
  /// deliberately signed/raw, unlike `worldBump`; see the test file's note on why its mean
  /// sits near zero for a steady tone.
  public var waveBumpRaw: Float
  /// 46.7 Hz band → mean since last frame, unscaled (spec §03 §7c). Rectify + slew happen
  /// receiver-side (`KittyBumpReceiver`, spec §04 §1.3), not here.
  public var kittyBumpRaw: Float
  /// Wave-1 ring (1024 samples) downsampled ×2 → 512 points, each run through its own
  /// persistent `SlideEnvelope(up: 8, down: 3)` cell — `jit.slide`'s per-cell smoothing
  /// (spec §03 §4).
  public var wave1Points: [Float]
  /// Wave-2 ring (1024 samples) downsampled ×512 → 2 points, unsmoothed (spec §03 §4 — wave
  /// 2's matrix reaches its graph "unsmoothed"). Anomalously coarse relative to wave 1's ×2 —
  /// verified against the running patch (Task 25): with wave 2 enabled alone and no other
  /// change, muting the mic entirely and playing a loud transient both left the rendered
  /// shape unchanged, consistent with the coarse-decimation/near-silent-input reading rather
  /// than a dense audio-reactive line.
  public var wave2Points: [Float]
}

/// The whole per-buffer analysis chain (spec §03 §3, §7, §9), with an injectable input so it
/// is fully unit-testable without a microphone — `ingest` takes plain sample arrays, and
/// `AudioAnalysis` (below) is the only piece that actually touches `AVAudioEngine`.
public final class AudioBands {
  /// Checklist #15 (spec §03 §3, §12 q.8 — "the single highest-impact unresolved item in
  /// this file for a port"): wave 2's input in the original is near-silent by default,
  /// because its EQ's cold-inlet multiplier is signal-patched from a duplicate `gswitch`
  /// whose default-selected candidate is itself unconnected. **Verified live against
  /// `patches/Feedbax.maxpat` (Task 25, 2026-08-24):** with wave 2 enabled alone (wave 1
  /// disabled) and DSP/mic running, (a) muting `adc~` entirely produced zero visible change
  /// in wave 2's rendered shape, and (b) a loud transient (system chime played through the
  /// speakers into the mic) produced no reactivity beyond ordinary render-loop jitter — both
  /// consistent with a near-zero effective input multiplier. The 0.0 default is confirmed
  /// correct, not a guess. Reviving wave 2 (a nonzero gain) is an operator tunable for a port,
  /// not a parity requirement — the original's default *is* silent.
  public var wave2InputGain: Float = 0.0

  /// Guards every stored property below. `AudioAnalysis.handle(_:)` calls `ingest` from the
  /// realtime audio-input-tap thread (`AVAudioEngine` installs the tap callback on its own
  /// render thread, never the caller's), while `Engine.step` calls `frameValues` from the
  /// main/display-link thread — both read AND write the same biquad/slide/running-average/
  /// ring-buffer state, with no synchronization that would otherwise exist. Left unguarded,
  /// that's a genuine data race (Swift's exclusivity enforcement can trap with "Simultaneous
  /// accesses to a variable" the moment the two threads overlap on the same stored property).
  /// A plain lock is sufficient here rather than a lock-free handoff: both critical sections
  /// are short and allocation-free (bounded by `samples.count` and `framesize`/downsample
  /// respectively), so contention is brief and doesn't risk the kind of priority-inversion
  /// stall a longer or blocking critical section would on the realtime thread.
  private let lock = NSLock()

  private var wave1Biquad: Biquad
  private var wave2Biquad: Biquad
  private var worldBumpBiquad: Biquad

  private var worldBumpSlide: SlideEnvelope
  private var worldBumpRunningAverage: RunningAverage
  private var worldBumpSnapshot: Float = 0

  // "mean since last frame" accumulators — the `avg~`-on-bang semantics (spec §03 glossary):
  // sum+count reset every `frameValues()` call, exactly like `avg~` reset by its trigger bang.
  private var waveBumpSum: Float = 0
  private var waveBumpCount: Int = 0
  private var kittyBumpSum: Float = 0
  private var kittyBumpCount: Int = 0

  private var wave1Ring: WaveBuffer
  private var wave2Ring: WaveBuffer
  // One persistent SlideEnvelope per decimated wave-1 point — `jit.slide`'s per-cell
  // smoothing carries state across frames independently for each point index (spec §03 §4).
  private var wave1PointSliders: [SlideEnvelope]

  private static let framesize = 1024      // jit.catch~ @framesize (spec §03 §4), both chains
  private static let wave1Downsample = 2   // jit.catch~[3] @downsample (spec §03 §4)
  private static let wave2Downsample = 512 // jit.catch~[214] @downsample (spec §03 §4, [?])

  public init(sampleRate: Float) {
    // Bands/freq/Q/gain verbatim from spec §03 §3's parity table.
    wave1Biquad = Biquad(bandpass: 46.7, q: 0.92, gain: 1.02, sampleRate: sampleRate)
    wave2Biquad = Biquad(bandpass: 60.0, q: 2.05, gain: 0.90, sampleRate: sampleRate)
    worldBumpBiquad = Biquad(bandpass: 144.3, q: 1.77, gain: 0.71, sampleRate: sampleRate)

    worldBumpSlide = SlideEnvelope(up: 2500, down: 2500)
    worldBumpRunningAverage = RunningAverage(window: 100, mode: .absolute)

    wave1Ring = WaveBuffer(capacity: Self.framesize)
    wave2Ring = WaveBuffer(capacity: Self.framesize)
    let wave1PointCount = Self.framesize / Self.wave1Downsample
    wave1PointSliders = (0..<wave1PointCount).map { _ in SlideEnvelope(up: 8, down: 3) }
  }

  /// Runs every sample through all three EQ chains and accumulates their per-frame state.
  /// Mic tap or test injection — `AudioAnalysis` is the only caller that means "mic tap";
  /// tests call this directly with synthetic buffers.
  public func ingest(_ samples: [Float]) {
    lock.lock()
    defer { lock.unlock() }
    for s in samples {
      // worldBump (spec §03 §7a): biquad → abs → slide(2500/2500) → runningAvg(absolute,100).
      // The running average's *last* value is what `frameValues()` snapshots — this is
      // `average~`'s continuous output sampled by `snapshot~`, not a separate accumulator.
      let worldBand = worldBumpBiquad.process(s)
      let worldEnv = worldBumpSlide.process(abs(worldBand))
      worldBumpSnapshot = worldBumpRunningAverage.process(worldEnv)

      // Wave-1's single biquad output fans out three ways, exactly as in the original
      // (spec §03 §3's table + §7b/§7c): the waveform-1 matrix, the wavebump accumulator
      // (×2.2, unrectified), and the kittybump accumulator (×1, unrectified) all read the
      // *same* filtered sample — not three independently-filtered copies.
      let wave1Sample = wave1Biquad.process(s)
      wave1Ring.push(wave1Sample)
      waveBumpSum += wave1Sample * 2.2
      waveBumpCount += 1
      kittyBumpSum += wave1Sample
      kittyBumpCount += 1

      // Wave-2 (spec §03 §3, §9): input pre-scaled by wave2InputGain before its own biquad.
      let wave2Sample = wave2Biquad.process(s * wave2InputGain)
      wave2Ring.push(wave2Sample)
    }
  }

  /// Sampled once per render frame (spec §03 §7 "sampled once per frame", §9's ctrlbang/
  /// audiobang cadence). Resets the wave/kitty since-last-frame accumulators — `avg~`'s
  /// bang-triggered reset semantics.
  public func frameValues() -> FrameAudio {
    lock.lock()
    defer { lock.unlock() }
    let worldBump = worldBumpSnapshot * 0.05

    let waveBumpRaw = waveBumpCount > 0 ? waveBumpSum / Float(waveBumpCount) : 0
    let kittyBumpRaw = kittyBumpCount > 0 ? kittyBumpSum / Float(kittyBumpCount) : 0
    waveBumpSum = 0
    waveBumpCount = 0
    kittyBumpSum = 0
    kittyBumpCount = 0

    let wave1Raw = wave1Ring.strideDecimated(by: Self.wave1Downsample)
    var wave1Points = [Float](repeating: 0, count: wave1Raw.count)
    for i in 0..<wave1Raw.count {
      wave1Points[i] = wave1PointSliders[i].process(wave1Raw[i])
    }
    let wave2Points = wave2Ring.strideDecimated(by: Self.wave2Downsample)

    return FrameAudio(worldBump: worldBump, waveBumpRaw: waveBumpRaw, kittyBumpRaw: kittyBumpRaw,
                       wave1Points: wave1Points, wave2Points: wave2Points)
  }
}

/// The webUI-side receiver for `kittybumpsignal` (spec §04 §1.3): `abs()` then a
/// **control-rate** `slide 22 14` — Max's non-tilde `slide`, stepped once per received value
/// (i.e. once per frame, since `kittyBumpRaw` arrives once per frame), not per audio sample
/// like `slide~`. Rectify-then-slew happens entirely here, not in `AudioBands` — `kittyBumpRaw`
/// itself is unrectified (spec §03 §7c).
public final class KittyBumpReceiver {
  private var slide = SlideEnvelope(up: 22, down: 14)

  public init() {}

  public func process(_ raw: Float) -> Float {
    slide.process(abs(raw))
  }
}

/// AVAudioEngine input tap → `AudioBands`. Deliberately thin: every DSP decision lives in
/// `Biquad`/`SlideEnvelope`/`RunningAverage`/`WaveBuffer`/`AudioBands`, all of which are
/// unit-tested with injected buffers. This class is **not** unit-tested — CI has no
/// microphone — so its tap-format and start/stop behavior have only been reasoned about, not
/// exercised; treat it as needing a manual/live smoke test before relying on it.
public final class AudioAnalysis {
  /// `uiGain` (spec §03 §2): a raw multiply on the tapped samples, applied before
  /// `AudioBands.ingest`. Deliberately **unsmoothed** — the original's `*~ 1.` cold-inlet
  /// gain has no `mIniCtlSmooth` ramp, unlike most other webUI-driven controls.
  public var inputGain: Float = 1.0

  private let engine = AVAudioEngine()
  private let bands: AudioBands
  private let tapBus: AVAudioNodeBus = 0
  private var isRunning = false

  public init(bands: AudioBands) throws {
    self.bands = bands
  }

  /// Installs the input tap at the input node's own native format (hardware-determined —
  /// AVAudioEngine does not resample a differing sample rate for you on a tap) and starts the
  /// engine. Multi-channel input is downmixed to mono by averaging before `bands.ingest`.
  /// Spec §03 §2 targets 48 kHz mono; the caller must construct `AudioBands` with whatever
  /// sample rate the actual input hardware reports, or the biquad center frequencies will be
  /// off — this path has no automated coverage to catch that mismatch.
  ///
  /// Idempotent (`start()` while already running, or `stop()` while already stopped, are both
  /// no-ops) — Task 16's `MovieSource` review caught a double-attach crash from exactly this
  /// missing guard on a different AV object; guarding here up front since this class has no
  /// automated test to catch the same class of bug.
  public func start() throws {
    guard !isRunning else { return }
    let input = engine.inputNode
    let format = input.inputFormat(forBus: tapBus)
    input.installTap(onBus: tapBus, bufferSize: 1024, format: format) { [weak self] buffer, _ in
      self?.handle(buffer)
    }
    try engine.start()
    isRunning = true
  }

  public func stop() {
    guard isRunning else { return }
    engine.inputNode.removeTap(onBus: tapBus)
    engine.stop()
    isRunning = false
  }

  private func handle(_ buffer: AVAudioPCMBuffer) {
    guard let channelData = buffer.floatChannelData else { return }
    let frameCount = Int(buffer.frameLength)
    let channelCount = Int(buffer.format.channelCount)
    guard frameCount > 0, channelCount > 0 else { return }

    var mono = [Float](repeating: 0, count: frameCount)
    for ch in 0..<channelCount {
      let src = channelData[ch]
      for i in 0..<frameCount { mono[i] += src[i] }
    }
    let channelScale = Float(channelCount)
    let gain = inputGain
    for i in 0..<frameCount { mono[i] = (mono[i] / channelScale) * gain }
    bands.ingest(mono)
  }
}
