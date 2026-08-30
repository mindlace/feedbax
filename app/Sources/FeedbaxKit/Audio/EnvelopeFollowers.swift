import Foundation

/// Ports `slide~` (spec §03 glossary): an asymmetric one-pole envelope smoother, `y += (x−y)
/// / slide`, using `up` while rising (`x >= y`) and `down` while falling — `up`/`down` are in
/// samples-to-converge, not ms (the Max object's own units). This is the *signal-rate* form,
/// stepped once per audio sample — used inside `AudioBands`' worldBump chain (spec §03 §7a)
/// and, per-cell, inside `WaveBuffer`'s `jit.slide` port. `ImageBumpReceiver` (spec §04 §1.3)
/// uses the same struct but steps it once per *received value* instead — Max's non-tilde
/// `slide` object is the control-rate sibling of `slide~` and shares this exact recurrence.
public struct SlideEnvelope {
  private var y: Float = 0
  private let up: Float
  private let down: Float

  /// - Parameters:
  ///   - up: samples-to-converge while the input exceeds the current output (attack).
  ///   - down: samples-to-converge while the input is below the current output (release).
  public init(up: Float, down: Float) {
    self.up = up
    self.down = down
  }

  public mutating func process(_ x: Float) -> Float {
    let slide = x >= y ? up : down
    y += (x - y) / slide
    return y
  }
}

/// Ports `average~` (spec §03 glossary): a continuously-updated running average over the last
/// `window` samples. Only `average~`'s `"absolute"` mode is live in the patch — `worldBump`'s
/// chain sets it once at load and the `"rms"`/`"bipolar"` alternate messages exist but are
/// never triggered (spec §03 §7a: "dead"); `Mode` therefore has a single case rather than
/// modeling `average~`'s full mode vocabulary (`rms`/`bipolar`/`absolute`/`mean`, spec §03
/// glossary), since nothing in this port ever selects the others.
public struct RunningAverage {
  public enum Mode {
    case absolute
  }

  private var ring: [Float]
  private var writeIndex = 0
  private var filled = 0
  private var runningSum: Float = 0

  public init(window: Int, mode: Mode) {
    self.ring = [Float](repeating: 0, count: max(window, 1))
    _ = mode  // reserved: only .absolute exists today, see the type's doc comment above.
  }

  /// Absolute-mode running average: combines each sample as `|x|` before averaging, per
  /// `average~ absolute` (spec §03 §7a).
  public mutating func process(_ x: Float) -> Float {
    let v = abs(x)
    runningSum -= ring[writeIndex]
    ring[writeIndex] = v
    runningSum += v
    writeIndex = (writeIndex + 1) % ring.count
    filled = min(filled + 1, ring.count)
    return runningSum / Float(filled)
  }
}
