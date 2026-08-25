import Foundation

/// Ports `jit.catch~`'s capture behavior (spec §03 §4, §12 q.1): a fixed-`capacity` ring that
/// always holds the most recently ingested samples, oldest-to-newest. `jit.catch~`'s own
/// `@mode`/`@trigthresh`/`@trigdir` enum semantics are unresolved by the spec's listing pass
/// ("the exact difference... cannot be pinned down precisely" — spec §03 §12 q.1); this port
/// takes the spec's own recommended reading for a port: "capture the last `framesize` samples,
/// decimated by `downsample`" — a plain ring buffer plus stride decimation, not an
/// oscilloscope-style trigger.
struct WaveBuffer {
  private var storage: [Float]
  private var writeIndex = 0
  private var filled = 0
  let capacity: Int

  init(capacity: Int) {
    self.capacity = capacity
    self.storage = [Float](repeating: 0, count: capacity)
  }

  mutating func push(_ x: Float) {
    storage[writeIndex] = x
    writeIndex = (writeIndex + 1) % capacity
    filled = min(filled + 1, capacity)
  }

  /// Oldest→newest snapshot, zero-padded at the front if fewer than `capacity` samples have
  /// ever been pushed (mirrors a freshly-loaded `jit.catch~`'s all-zero matrix).
  func snapshot() -> [Float] {
    guard filled == capacity else {
      return [Float](repeating: 0, count: capacity - filled) + Array(storage[0..<filled])
    }
    return Array(storage[writeIndex...]) + Array(storage[..<writeIndex])
  }

  /// Ports `jit.catch~`'s `@downsample` for wave 1 (spec §03 §4): keep every `stride`-th
  /// sample of the chronological snapshot — `stride` 2 → 512 points. Wave 2 uses
  /// `AveragingWaveBuffer` below.
  func strideDecimated(by stride: Int) -> [Float] {
    let full = snapshot()
    guard stride > 0 else { return full }
    return Swift.stride(from: 0, to: full.count, by: stride).map { full[$0] }
  }
}

/// `jit.catch~ @downsample n` as its refpage defines it — "each group of n successive samples
/// are averaged" — followed by a `capacity`-cell frame of those means, oldest→newest. This is
/// wave 2's path (`loadmess 512 → downsample 512 → s wave2cmd`, `framesize 1024`): a 1024-cell
/// ring of 512-sample means, which is why the ring stays near-circular under a 60 Hz band
/// (diagnosis doc, "Audio couplings"; the exact history depth is flagged [measure] there).
/// 1024 cells × 512 samples ≈ 11.9 s of history at 44.1 kHz: for the first ~12 s after launch
/// the front of the ring is zero-padded (a perfect circle over most of its circumference), and
/// only ~1.4 cells change per 60 Hz frame — which is the "near-static ring" the diagnosis
/// predicts.
struct AveragingWaveBuffer {
  private var ring: WaveBuffer
  private let group: Int
  private var sum: Float = 0
  private var count = 0

  init(capacity: Int, group: Int) {
    precondition(group > 0)
    ring = WaveBuffer(capacity: capacity)
    self.group = group
  }

  mutating func push(_ x: Float) {
    sum += x
    count += 1
    if count == group {
      ring.push(sum / Float(group))
      sum = 0
      count = 0
    }
  }

  /// Oldest→newest cells, zero-padded at the front until `capacity` groups have completed.
  func points() -> [Float] { ring.snapshot() }
}
