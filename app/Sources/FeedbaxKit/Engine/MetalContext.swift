import Metal
import Foundation

/// One Metal device/queue/shader-library set for the whole engine.
///
/// Shaders are compiled from source at runtime rather than loaded from a prebuilt
/// metallib. SwiftPM's native build system — the one `swift build`/`swift test` use for
/// this package's required invocations — copies `.metal` resources verbatim; it does not
/// compile them into a `default.metallib` the way the Xcode/`swiftbuild` backends do. A
/// checked-in metallib would therefore be a second artifact that could silently drift from
/// the `.metal` source it's supposed to represent — a parity test could keep passing
/// against a stale compiled shader while the source it's meant to verify had already
/// changed. Compiling every `.metal` file from source on each launch removes that failure
/// mode entirely: the source is the only thing that can ever be tested.
///
/// Each `.metal` file is compiled into its own `MTLLibrary` rather than concatenated into
/// one translation unit, because later shader files define file-scoped static helpers
/// (`rgb2hsl`, etc.) whose names would collide across files if compiled together.
public final class MetalContext {
  public let device: MTLDevice
  public let queue: MTLCommandQueue
  public let libraries: [MTLLibrary]
  public let pool: TexturePool
  private var pipelines: [String: MTLComputePipelineState] = [:]

  public init() throws {
    guard let device = MTLCreateSystemDefaultDevice() else { throw FeedbaxError.noMetalDevice }
    self.device = device
    self.queue = device.makeCommandQueue()!
    let urls = Bundle.module.urls(forResourcesWithExtension: "metal", subdirectory: "Shaders") ?? []
    self.libraries = try urls.map { url in
      let source = try String(contentsOf: url, encoding: .utf8)
      return try device.makeLibrary(source: source, options: nil)
    }
    self.pool = TexturePool(device: device)
  }

  public func computePipeline(_ name: String) throws -> MTLComputePipelineState {
    if let p = pipelines[name] { return p }
    guard let fn = libraries.compactMap({ $0.makeFunction(name: name) }).first else {
      throw FeedbaxError.missingShader(name)
    }
    let p = try device.makeComputePipelineState(function: fn)
    pipelines[name] = p
    return p
  }

  /// Shared-storage texture the CPU can fill — for tests and still decode, never the hot loop.
  public func makeTexture(width: Int, height: Int, format: MTLPixelFormat,
                          pixels: [SIMD4<Float>]?) -> MTLTexture {
    let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: format, width: width,
                                                     height: height, mipmapped: false)
    d.usage = [.shaderRead, .shaderWrite, .renderTarget]
    d.storageMode = .shared
    let tex = device.makeTexture(descriptor: d)!
    guard let pixels else { return tex }
    let region = MTLRegionMake2D(0, 0, width, height)
    switch format {
    case .rgba16Float:
      let halves = pixels.map { SIMD4<Float16>(Float16($0.x), Float16($0.y), Float16($0.z), Float16($0.w)) }
      halves.withUnsafeBytes { tex.replace(region: region, mipmapLevel: 0,
                                           withBytes: $0.baseAddress!, bytesPerRow: width * 8) }
    case .rgba8Unorm, .bgra8Unorm:
      let swap = format == .bgra8Unorm
      var bytes = [UInt8](); bytes.reserveCapacity(pixels.count * 4)
      for p in pixels {
        let c = p.clamped(lowerBound: .zero, upperBound: .one) * 255
        let r = UInt8(c.x.rounded()), g = UInt8(c.y.rounded()), b = UInt8(c.z.rounded()), a = UInt8(c.w.rounded())
        bytes.append(contentsOf: swap ? [b, g, r, a] : [r, g, b, a])
      }
      bytes.withUnsafeBytes { tex.replace(region: region, mipmapLevel: 0,
                                          withBytes: $0.baseAddress!, bytesPerRow: width * 4) }
    default: fatalError("unsupported upload format \(format)")
    }
    return tex
  }

  /// Blit to a shared buffer and decode to floats. Handles rgba8Unorm, bgra8Unorm, rgba16Float.
  public func readPixels(_ tex: MTLTexture) -> [SIMD4<Float>] {
    let bpp = tex.pixelFormat == .rgba16Float ? 8 : 4
    let buf = device.makeBuffer(length: tex.width * tex.height * bpp, options: .storageModeShared)!
    let cb = queue.makeCommandBuffer()!
    let blit = cb.makeBlitCommandEncoder()!
    blit.copy(from: tex, sourceSlice: 0, sourceLevel: 0,
              sourceOrigin: MTLOrigin(), sourceSize: MTLSize(width: tex.width, height: tex.height, depth: 1),
              to: buf, destinationOffset: 0,
              destinationBytesPerRow: tex.width * bpp, destinationBytesPerImage: 0)
    blit.endEncoding()
    cb.commit(); cb.waitUntilCompleted()
    let count = tex.width * tex.height
    switch tex.pixelFormat {
    case .rgba16Float:
      let p = buf.contents().bindMemory(to: SIMD4<Float16>.self, capacity: count)
      return (0..<count).map { SIMD4<Float>(Float(p[$0].x), Float(p[$0].y), Float(p[$0].z), Float(p[$0].w)) }
    case .rgba8Unorm, .bgra8Unorm:
      let swap = tex.pixelFormat == .bgra8Unorm
      let p = buf.contents().bindMemory(to: UInt8.self, capacity: count * 4)
      return (0..<count).map { i in
        let o = i * 4
        let r = Float(p[o + (swap ? 2 : 0)]) / 255, g = Float(p[o + 1]) / 255
        let b = Float(p[o + (swap ? 0 : 2)]) / 255, a = Float(p[o + 3]) / 255
        return SIMD4(r, g, b, a)
      }
    default: fatalError("unsupported readback format \(tex.pixelFormat)")
    }
  }
}

public enum FeedbaxError: Error {
  case noMetalDevice
  case missingShader(String)
  case failedToCreateImageDestination
  case failedToWriteImage
  case failedToCreateDataProvider
  case failedToCreateCGImage
}
