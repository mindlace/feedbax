import XCTest
@testable import FeedbaxKit

/// Generates `seconds` of a pure sine at `freq` Hz, `sampleRate` samples/sec.
func sine(_ freq: Float, seconds: Float, sampleRate: Float, amplitude: Float = 1.0) -> [Float] {
  let n = Int(seconds * sampleRate)
  return (0..<n).map { i in amplitude * sin(2 * Float.pi * freq * Float(i) / sampleRate) }
}

/// Runs `bq` over a generous burst of `freq` (long enough that the filter's transient decays
/// to a negligible fraction of the settled output), dropping the transient before returning —
/// isolates steady-state passband/stopband behavior for `rms(_:)` comparisons.
func processSine(_ bq: inout Biquad, freq: Float, sampleRate: Float = 48000) -> [Float] {
  let input = sine(freq, seconds: 0.2, sampleRate: sampleRate, amplitude: 1.0)
  let output = bq.process(buffer: input)
  let settleSamples = min(2000, output.count / 2)
  return Array(output[settleSamples...])
}

func rms(_ samples: [Float]) -> Float {
  guard !samples.isEmpty else { return 0 }
  let sumSq = samples.reduce(Float(0)) { $0 + $1 * $1 }
  return sqrt(sumSq / Float(samples.count))
}

final class AudioAnalysisTests: XCTestCase {
  func testBandpassSelectsItsBand() {
    var bq = Biquad(bandpass: 46.7, q: 0.92, gain: 1.02, sampleRate: 48000)
    let inBand = rms(processSine(&bq, freq: 46.7))
    var bq2 = Biquad(bandpass: 46.7, q: 0.92, gain: 1.02, sampleRate: 48000)
    let outOfBand = rms(processSine(&bq2, freq: 1000))
    XCTAssertGreaterThan(inBand, outOfBand * 10, "46.7 Hz passes, 1 kHz attenuates ≥20 dB")
  }
  func testSlideConvergence() {
    // slide~ semantics: step response after k samples leaves (1−1/slide)^k remaining.
    var s = SlideEnvelope(up: 100, down: 100)
    var y: Float = 0
    for _ in 0..<100 { y = s.process(1) }
    XCTAssertEqual(y, 1 - pow(1 - 1.0 / 100, 100), accuracy: 1e-3)   // ≈ 0.634
  }
  func testWorldBumpRespondsToBassBurst() {
    let bands = AudioBands(sampleRate: 48000)
    bands.ingest(sine(144.3, seconds: 0.5, sampleRate: 48000, amplitude: 0.8))
    let v = bands.frameValues().worldBump
    XCTAssertGreaterThan(v, 0.001)
    XCTAssertLessThan(v, 0.05, "×0.05 final scale keeps bumps subtle (spec §03 §7a)")
    let silent = AudioBands(sampleRate: 48000)
    silent.ingest([Float](repeating: 0, count: 24000))
    XCTAssertEqual(silent.frameValues().worldBump, 0, accuracy: 1e-4)
  }
  func testWaveBumpIsMeanSinceLastFrameTimes2Point2() {
    // DC into the 46.7 band ≈ blocked; use a 46.7 Hz sine and check the UNRECTIFIED mean
    // is near zero while worldBump (rectified) is not — the pipeline difference (spec §03 §7).
    let bands = AudioBands(sampleRate: 48000)
    bands.ingest(sine(46.7, seconds: 1.0, sampleRate: 48000, amplitude: 0.8))
    let f = bands.frameValues()
    XCTAssertEqual(abs(f.waveBumpRaw), 0.1, accuracy: 0.1, "no rectifier → mean ≈ 0-ish")
  }
  func testWaveBuffersShapeAndSmoothing() {
    let bands = AudioBands(sampleRate: 48000)
    bands.ingest(sine(46.7, seconds: 0.1, sampleRate: 48000, amplitude: 0.5))
    let f = bands.frameValues()
    XCTAssertEqual(f.wave1Points.count, 512, "framesize 1024 / downsample 2")
    XCTAssertEqual(f.wave2Points.count, 1024, "framesize 1024 cells of 512-sample group means (jit.catch~ refpage: downsample n averages each group of n)")
  }
  /// Wave 2's multiplier is `*~ -0.5` whose cold inlet is fed by a `gswitch` — a MESSAGE
  /// object (its refpage inlets are bang/int), so the −0.5 argument stays in force; the spec's
  /// "signal-patched cold inlet → silent" reading was wrong (diagnosis doc, "Audio couplings").
  func testWave2IsFedAtMinusHalfGain() {
    XCTAssertEqual(AudioBands(sampleRate: 48000).wave2InputGain, -0.5)
    let bands = AudioBands(sampleRate: 48000)
    bands.ingest(sine(60, seconds: 1.0, sampleRate: 48000, amplitude: 0.8))
    let points = bands.frameValues().wave2Points
    XCTAssertGreaterThan(points.map { abs($0) }.max()!, 0.001, "the ring is not structurally silent")
    let silent = AudioBands(sampleRate: 48000)
    silent.ingest([Float](repeating: 0, count: 48000))
    XCTAssertTrue(silent.frameValues().wave2Points.allSatisfy { $0 == 0 })
  }
  func testAveragingWaveBufferEmitsOneMeanPerGroup() {
    var buf = AveragingWaveBuffer(capacity: 4, group: 3)
    for _ in 0..<3 { buf.push(1) }
    XCTAssertEqual(buf.points(), [0, 0, 0, 1], "one full group → one cell, zero-padded before it")
    buf.push(2); buf.push(4)
    XCTAssertEqual(buf.points(), [0, 0, 0, 1], "a partial group emits nothing yet")
    buf.push(6)
    XCTAssertEqual(buf.points(), [0, 0, 1, 4], "mean of (2, 4, 6)")
  }
  func testKittyReceiverRectifiesAndSlews() {
    let r = KittyBumpReceiver()
    _ = r.process(-0.5)                       // abs() first
    let v = r.process(-0.5)
    XCTAssertGreaterThan(v, 0, "rectified"); XCTAssertLessThan(v, 0.5, "slewed by slide 22")
  }
  func testInputRMSTracksTheLastIngestedBatch() {
    let bands = AudioBands(sampleRate: 48000)
    XCTAssertEqual(bands.inputRMS, 0)
    bands.ingest(sine(440, seconds: 0.5, sampleRate: 48000, amplitude: 0.5))
    XCTAssertEqual(bands.inputRMS, 0.5 / sqrt(2), accuracy: 0.005, "RMS of a 0.5-amplitude sine")
    bands.ingest([Float](repeating: 0, count: 1024))
    XCTAssertEqual(bands.inputRMS, 0)
  }
  func testDecibelsFloorAtMinus90() {
    XCTAssertEqual(AudioBands.decibels(0.01), -40, accuracy: 0.01)
    XCTAssertEqual(AudioBands.decibels(1), 0, accuracy: 0.01)
    XCTAssertEqual(AudioBands.decibels(0), -90)
    XCTAssertEqual(AudioBands.decibels(1e-9), -90)
  }
}
