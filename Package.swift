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
