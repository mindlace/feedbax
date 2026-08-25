import XCTest
@testable import FeedbaxKit

/// Every constant below was MEASURED from Max 9.1.5 — a live `scale` object driven from a
/// `message` box, printed through `sprintf v%.12f` -> `print`. None of it is derived from the
/// spec or from the Max documentation, both of which describe the modern (`@classic 0`)
/// formula that this object does NOT use by default. 62 points across 11 configurations were
/// captured; these are the ones that pin the behaviour.
final class MaxScaleTests: XCTestCase {
  /// Float carries ~7 significant digits, so compare relatively rather than absolutely —
  /// an absolute epsilon that is fair to 0.0005 is meaningless at 1570.8.
  private func assertRel(_ actual: Float, _ expected: Double,
                         _ rel: Double = 1e-6,
                         file: StaticString = #filePath, line: UInt = #line) {
    let tol = max(abs(expected) * rel, 1e-9)
    XCTAssertEqual(Double(actual), expected, accuracy: tol, file: file, line: line)
  }

  // MARK: - Exponent <= 1 is IGNORED (plain linear map)

  /// The three HSL mappings the router actually uses. Their exponents (0.1, 0.05, 0.1) are
  /// all <= 1, so classic mode drops them entirely and maps linearly. The modern formula
  /// would raise the normalised input to those powers and produce deltas 2-73x larger —
  /// that discrepancy is what washed the instrument to white in under a second.
  func testHueMapIsLinearDespiteExponentPointOne() {
    assertRel(maxScale(0.011905, -1, 1, -0.05, 0.05, exp: 0.1), 0.00059525)
  }

  func testBiasMapIsLinearDespiteExponentPointZeroFive() {
    assertRel(maxScale(0.392857, -1, 1, -0.04, 0.02, exp: 0.05), 0.00178571)
  }

  func testSaturationMapIsLinearDespiteExponentPointOne() {
    assertRel(maxScale(0.71131, 0, 1, -0.05, 0.05, exp: 0.1), 0.021131)
  }

  /// Second, independent confirmation that a fractional exponent changes nothing: an
  /// exponent of 0.5 over 0...1 gives exactly the straight line.
  func testFractionalExponentIsIgnored() {
    assertRel(maxScale(0.001, 0, 1, 0.8, 1, exp: 0.5), 0.8002)
    assertRel(maxScale(0.5, 0, 1, 0.8, 1, exp: 0.5), 0.9)
  }

  /// Exponent 1 (the default) is the same linear map.
  func testDefaultExponentIsLinear() {
    assertRel(maxScale(0.25, 0, 1, 0.8, 1), 0.85)
    assertRel(maxScale(0.5, 0, 1, 0.8, 1), 0.9)
    assertRel(maxScale(0.75, 0, 1, 0.8, 1), 0.95)
  }

  /// An inverted output range (theta maps to +pi...-pi) needs no special handling — the
  /// linear branch already produces the descending line.
  func testInvertedOutputRange() {
    assertRel(maxScale(-0.5, -1, 1, .pi, -.pi), 1.570796325, 1e-6)
    assertRel(maxScale(0.0, -1, 1, .pi, -.pi), 0.0)
    assertRel(maxScale(0.5, -1, 1, .pi, -.pi), -1.570796325, 1e-6)
  }

  // MARK: - Exponent > 1 takes the curved branch

  /// The erase-alpha mapping, `scale 0 1 0.8 1 3`. Classic mode evaluates
  /// outLow + (outHigh - outLow) * pow(exponent, x - inHigh) — note the base is the
  /// EXPONENT and the term is the RAW input, not a normalised fraction.
  func testEraseAlphaCurve() {
    assertRel(maxScale(0.1, 0, 1, 0.8, 1, exp: 3), 0.874408211602)
    assertRel(maxScale(0.25, 0, 1, 0.8, 1, exp: 3), 0.887738267530)
    assertRel(maxScale(0.5, 0, 1, 0.8, 1, exp: 3), 0.915470053838)
    assertRel(maxScale(0.75, 0, 1, 0.8, 1, exp: 3), 0.951967137130)
    assertRel(maxScale(0.9, 0, 1, 0.8, 1, exp: 3), 0.979191691968)
    assertRel(maxScale(1.0, 0, 1, 0.8, 1, exp: 3), 1.0)
  }

  /// x == inLow with inLow <= 0 is an exact-equality special case that returns outLow.
  func testExactInLowReturnsOutLow() {
    assertRel(maxScale(0.0, 0, 1, 0.8, 1, exp: 3), 0.8)
  }

  /// The sharpest characterisation of that special case: the curve is DISCONTINUOUS at
  /// inLow. One millionth above zero jumps to 0.8667, not 0.8. Anything that "smooths" the
  /// special case into a continuous curve is wrong.
  func testCurveIsDiscontinuousJustAboveInLow() {
    assertRel(maxScale(1e-6, 0, 1, 0.8, 1, exp: 3), 0.866666739908)
  }

  /// The exponent term uses the RAW input, un-normalised — this is what distinguishes the
  /// classic formula from every plausible near-miss. Over 0...100 the curve is
  /// pow(1.02, x - 100); if the input were normalised to 0...1 first, x = 50 would give
  /// 1.02^-0.5 = 0.9902 rather than the measured 0.3715.
  ///
  /// Tolerance is 5e-6 rather than 1e-6 here for a reason that is NOT slop in the formula:
  /// the exponent arrives as a `Float`, and `Float(1.02)` is 1.0199999809, high by 1.9e-8
  /// relatively. Raising that to the -75th power multiplies the error by 75, giving a
  /// 1.4e-6 relative floor on the x = 25 point no matter how the function is written. It is
  /// the parameter type, not the arithmetic — the formula reproduces the measurement to
  /// 5e-12 when the exponent is passed in full precision.
  func testExponentTermUsesRawUnNormalisedInput() {
    assertRel(maxScale(100, 0, 100, 0, 1, exp: 1.02), 1.0, 5e-6)
    assertRel(maxScale(50, 0, 100, 0, 1, exp: 1.02), 0.371527882127, 5e-6)
    assertRel(maxScale(25, 0, 100, 0, 1, exp: 1.02), 0.226457713418, 5e-6)
  }

  /// Same point over a 0...2 domain: pow(3, 2 - 2) = 1, so the top of the range is still
  /// outHigh. A normalised formula would agree here — it is the interior points above that
  /// separate them.
  func testCurvedBranchHitsOutHighAtInHigh() {
    assertRel(maxScale(2.0, 0, 2, 0.8, 1, exp: 3), 1.0)
  }
}
