import SwiftUI

/// A square, absolute-position XY surface — the port of the original's two Mira multitouch
/// pads (spec §04 §1.2–1.3; design §7). The dot FOLLOWS the bound values, so a trackpad
/// gesture or a preset recall moves it, and a drag SETS them from the pointer position. There
/// is no state inside the view to drift from the router's truth.
public struct XYPad: View {
  @Binding private var x: Double
  @Binding private var y: Double
  private let xRange: ClosedRange<Double>
  private let yRange: ClosedRange<Double>

  public init(x: Binding<Double>, y: Binding<Double>,
              xRange: ClosedRange<Double>, yRange: ClosedRange<Double>) {
    _x = x
    _y = y
    self.xRange = xRange
    self.yRange = yRange
  }

  public var body: some View {
    GeometryReader { geometry in
      let size = geometry.size
      ZStack {
        RoundedRectangle(cornerRadius: 6).fill(Color(nsColor: .controlBackgroundColor))
        RoundedRectangle(cornerRadius: 6).strokeBorder(Color.secondary.opacity(0.4))
        Path { path in
          path.move(to: CGPoint(x: size.width / 2, y: 0))
          path.addLine(to: CGPoint(x: size.width / 2, y: size.height))
          path.move(to: CGPoint(x: 0, y: size.height / 2))
          path.addLine(to: CGPoint(x: size.width, y: size.height / 2))
        }
        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
        Circle()
          .fill(Color.accentColor)
          .frame(width: 14, height: 14)
          .position(dotPosition(in: size))
      }
      .contentShape(Rectangle())
      // `minimumDistance: 0` so a tap-and-hold jumps the dot immediately, like touching a pad.
      .gesture(DragGesture(minimumDistance: 0).onChanged { drag in
        let unit = Self.unitPoint(drag.location, in: size)
        x = Self.value(unit.x, in: xRange)
        y = Self.value(unit.y, in: yRange)
      })
    }
    .aspectRatio(1, contentMode: .fit)
  }

  private func dotPosition(in size: CGSize) -> CGPoint {
    CGPoint(x: Self.unit(x, in: xRange) * size.width,
            y: (1 - Self.unit(y, in: yRange)) * size.height)
  }

  // MARK: - Pure mapping (unit-tested)

  /// Pointer → unit square, clamped, with SwiftUI's downward y flipped so the top of the pad
  /// is y = 1 — "up on the pad" is +raw (design §4's `y` rule).
  static func unitPoint(_ location: CGPoint, in size: CGSize) -> (x: Double, y: Double) {
    let ux = min(1, max(0, location.x / max(size.width, 1)))
    let uy = min(1, max(0, 1 - location.y / max(size.height, 1)))
    return (Double(ux), Double(uy))
  }

  static func value(_ unit: Double, in range: ClosedRange<Double>) -> Double {
    range.lowerBound + unit * (range.upperBound - range.lowerBound)
  }

  static func unit(_ value: Double, in range: ClosedRange<Double>) -> Double {
    (value - range.lowerBound) / (range.upperBound - range.lowerBound)
  }
}
