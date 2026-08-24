// swift-tools-version: 5.10
import PackageDescription

let package = Package(
  name: "Feedbax",
  platforms: [.macOS(.v14)],  // subject lifting + CAMetalDisplayLink floor (design §3)
  targets: [
    .target(
      name: "FeedbaxKit",
      resources: [.copy("Shaders"), .copy("Control/DefaultBindings.json")]
    ),
    .executableTarget(name: "feedbax-dev", dependencies: ["FeedbaxKit"]),
    .testTarget(
      name: "FeedbaxKitTests",
      dependencies: ["FeedbaxKit"],
      resources: [.copy("GoldenReferences")]
    ),
  ]
)
