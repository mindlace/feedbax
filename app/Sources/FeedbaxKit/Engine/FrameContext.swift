import Metal

/// Per-frame context handed to every SeedSource/TextureFilter/ControlSurface/Modulator
/// (design §5). `time`/`delta` are injectable so tests and golden runs use a fixed clock.
public struct FrameContext {
  public let index: Int
  public let time: TimeInterval
  public let delta: TimeInterval
  public let canvasSize: SIMD2<Int>
  public let commandBuffer: MTLCommandBuffer
  public let pool: TexturePool

  public init(index: Int, time: TimeInterval, delta: TimeInterval,
              canvasSize: SIMD2<Int>, commandBuffer: MTLCommandBuffer, pool: TexturePool) {
    self.index = index; self.time = time; self.delta = delta
    self.canvasSize = canvasSize; self.commandBuffer = commandBuffer; self.pool = pool
  }
}

/// Frame-scoped texture recycling. Leases are valid for the current frame only; the
/// filter CHAIN owns its leases (design §5) — at 8K one rgba16Float surface is ~254 MB,
/// so per-filter allocation would be ruinous.
public final class TexturePool {
  private struct Key: Hashable { let w: Int, h: Int, format: MTLPixelFormat.RawValue, usage: MTLTextureUsage.RawValue }
  private let device: MTLDevice
  private var free: [Key: [MTLTexture]] = [:]
  private var inFlight: [(Key, MTLTexture)] = []

  public init(device: MTLDevice) { self.device = device }

  public func lease(width: Int, height: Int, format: MTLPixelFormat, usage: MTLTextureUsage) -> MTLTexture {
    let key = Key(w: width, h: height, format: format.rawValue, usage: usage.rawValue)
    let tex: MTLTexture
    if let recycled = free[key]?.popLast() {
      tex = recycled
    } else {
      let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: format, width: width, height: height, mipmapped: false)
      d.usage = usage
      d.storageMode = .private
      tex = device.makeTexture(descriptor: d)!
    }
    inFlight.append((key, tex))
    return tex
  }

  /// Return every lease to the free lists. Call once per frame after the command buffer commits.
  public func endFrame() {
    for (key, tex) in inFlight { free[key, default: []].append(tex) }
    inFlight.removeAll(keepingCapacity: true)
  }
}
