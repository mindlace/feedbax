import Metal

/// One texture-to-texture GPU stage, and the ordered chain that runs them (design §5).
/// Task 22's golden scenarios attach these to a movie layer (P1's only live use — design
/// §10); P3 puts them on the camera chain.
public protocol TextureFilter: AnyObject {
  var id: String { get }
  var enabled: Bool { get set }
  /// Texture in → pool-leased texture out. Leases belong to the CHAIN's frame scope;
  /// outputs are valid this frame only (design §5).
  func apply(_ input: MTLTexture, _ frame: FrameContext) -> MTLTexture
}

public final class FilterChain {
  public var filters: [TextureFilter] = []
  public init(_ filters: [TextureFilter] = []) { self.filters = filters }
  /// Disabled filters are skipped — the texture passes through untouched, so a chain of
  /// all-disabled filters is a true identity (see testChainSkipsDisabledFilters).
  public func apply(_ input: MTLTexture, _ frame: FrameContext) -> MTLTexture {
    filters.reduce(input) { tex, f in f.enabled ? f.apply(tex, frame) : tex }
  }
}
