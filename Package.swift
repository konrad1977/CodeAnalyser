// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "CodeAnalyser",
    products: [
        .library(
            name: "CodeAnalyser",
            targets: ["CodeAnalyser"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "CodeAnalyser",
            dependencies: []),
        .testTarget(
            name: "CodeAnalyserTests",
            dependencies: ["CodeAnalyser"]),
    ]
)
