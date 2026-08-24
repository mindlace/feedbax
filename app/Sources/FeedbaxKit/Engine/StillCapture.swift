import Metal
import Foundation
import ImageIO
import CoreGraphics

/// Renders the current accumulator texture to a dated PNG file, deliberately fixing the
/// original's screencapture quirks — this is a clean render-target dump to a consistent PNG,
/// not a .jpg masquerading as PNG data via macOS screencapture (design §10, spec §04 §6).
public struct StillCapture {
  /// Writes the texture to a dated PNG file at the given directory (or `~/Pictures/Feedbax/`
  /// if nil), creates the directory on demand, and returns the file URL.
  ///
  /// Filename format: `feedbaxStill-YYYY-MM-dd-HHmmss.png` (POSIX locale formatter for
  /// deterministic test results).
  public static func write(_ texture: MTLTexture, context: MetalContext, directory: URL?,
                           date: Date) throws -> URL {
    // Read pixels from the texture using the context's readPixels method.
    let pixels = context.readPixels(texture)

    // Convert the float SIMD4<Float> pixels to a CGImage (rgba8Unorm).
    let cgImage = try pixelsToCGImage(pixels, width: texture.width, height: texture.height)

    // Determine the output directory.
    let outputDir = directory ?? FileManager.default.urls(for: .picturesDirectory,
                                                          in: .userDomainMask)[0]
                      .appendingPathComponent("Feedbax")

    // Create the directory if it doesn't exist.
    try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)

    // Format the date as YYYY-MM-dd-HHmmss using POSIX locale for determinism.
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd-HHmmss"
    let dateString = formatter.string(from: date)

    // Construct the filename and URL.
    let filename = "feedbaxStill-\(dateString).png"
    let fileURL = outputDir.appendingPathComponent(filename)

    // Write the PNG using CGImageDestination.
    guard let destination = CGImageDestinationCreateWithURL(fileURL as CFURL,
                                                            "public.png" as CFString,
                                                            1,
                                                            nil) else {
      throw FeedbaxError.failedToCreateImageDestination
    }

    CGImageDestinationAddImage(destination, cgImage, nil)
    guard CGImageDestinationFinalize(destination) else {
      throw FeedbaxError.failedToWriteImage
    }

    return fileURL
  }

  /// Converts an array of float SIMD4<Float> pixels (0–1 range, RGBA) to a CGImage.
  private static func pixelsToCGImage(_ pixels: [SIMD4<Float>], width: Int,
                                      height: Int) throws -> CGImage {
    // Convert float pixels (0–1 range) to UInt8 (0–255) RGBA bytes.
    var bytes = [UInt8]()
    bytes.reserveCapacity(pixels.count * 4)

    for pixel in pixels {
      let clamped = pixel.clamped(lowerBound: .zero, upperBound: .one) * 255
      let r = UInt8(clamped.x.rounded())
      let g = UInt8(clamped.y.rounded())
      let b = UInt8(clamped.z.rounded())
      let a = UInt8(clamped.w.rounded())
      bytes.append(contentsOf: [r, g, b, a])
    }

    // Create a CGImage from the byte data.
    let data = bytes.withUnsafeBytes { Data($0) }
    guard let dataProvider = CGDataProvider(data: data as CFData) else {
      throw FeedbaxError.failedToCreateDataProvider
    }

    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue)
    guard let cgImage = CGImage(width: width, height: height, bitsPerComponent: 8,
                                bitsPerPixel: 32, bytesPerRow: width * 4,
                                space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo,
                                provider: dataProvider, decode: nil, shouldInterpolate: false,
                                intent: .defaultIntent) else {
      throw FeedbaxError.failedToCreateCGImage
    }

    return cgImage
  }
}
