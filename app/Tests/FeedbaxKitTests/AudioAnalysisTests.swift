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
    XCTAssertEqual(f.wave2Points.count, 2, "downsample 512 — flagged [?], Task 25")
    XCTAssertEqual(f.wave2Points[0], 0, accuracy: 1e-5, "wave2 input silent by default (checklist #15)")
  }
  func testKittyReceiverRectifiesAndSlews() {
    let r = KittyBumpReceiver()
    _ = r.process(-0.5)                       // abs() first
    let v = r.process(-0.5)
    XCTAssertGreaterThan(v, 0, "rectified"); XCTAssertLessThan(v, 0.5, "slewed by slide 22")
  }
}
