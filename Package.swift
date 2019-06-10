// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "ElementDiff",
  products: [
    .library(name: "ElementDiff", targets: ["ElementDiff"]),
  ],
  dependencies: [],
  targets: [
    .target(name: "ElementDiff"),
  ]
)

