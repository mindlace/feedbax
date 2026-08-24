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
  private func chronological() -> [Float] {
    guard filled == capacity else {
      return [Float](repeating: 0, count: capacity - filled) + Array(storage[0..<filled])
    }
    return Array(storage[writeIndex...]) + Array(storage[..<writeIndex])
  }

  /// Ports `jit.catch~`'s `@downsample` (spec §03 §4): keep every `stride`-th sample of the
  /// chronological snapshot. `stride` 2 → 512 points (wave 1); `stride` 512 → 2 points (wave
  /// 2 — anomalously coarse next to wave 1's ×2). Verified against the running patch (Task
  /// 25, spec §03 §12 q.2): wave 2's rendered shape did not change under a full-mic-mute or
  /// loud-transient A/B test, consistent with this coarse decimation rather than a dense
  /// audio-reactive line — left as-is, no contradicting observation.
  func strideDecimated(by stride: Int) -> [Float] {
    let full = chronological()
    guard stride > 0 else { return full }
    return Swift.stride(from: 0, to: full.count, by: stride).map { full[$0] }
  }
}
