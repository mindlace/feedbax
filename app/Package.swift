// swift-tools-version: 5.10
import PackageDescription

let package = Package(
  name: "Feedbax",
  platforms: [.macOS(.v14)],  // subject lifting + CAMetalDisplayLink floor (design §3)
  products: [
    // Without an explicit product, FeedbaxKit is only reachable as an intra-package target
    // dependency (how `feedbax-dev` has always consumed it) — the `Feedbax.app` target (Task
    // 23) lives in the same Package.swift but is wired up by XcodeGen as a *separate* Xcode
    // target referencing `{ package: FeedbaxKit, product: FeedbaxKit }`, which resolves through
    // SwiftPM's package-product graph, not target names. That resolution fails with "Missing
    // package product 'FeedbaxKit'" unless a library product of that name is declared here.
    .library(name: "FeedbaxKit", targets: ["FeedbaxKit"])
  ],
  targets: [
    .target(
      name: "FeedbaxKit",
      resources: [.copy("Shaders"), .copy("Control/DefaultBindings.json")]
    ),
    .executableTarget(name: "feedbax-dev", dependencies: ["FeedbaxKit"]),
    .testTarget(
      name: "FeedbaxKitTests",
      dependencies: ["FeedbaxKit"],
      resources: [.copy("GoldenReferences"), .copy("Fixtures")]
    ),
  ]
)
