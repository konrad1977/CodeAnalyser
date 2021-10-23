// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "CodeAnalyser",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_11)
    ],
    products: [
        .library(
            name: "CodeAnalyser",
            targets: ["CodeAnalyser"]),
    ],
    dependencies: [
		.package(
			name: "Funswift",
			url: "https://github.com/konrad1977/funswift.git",
			.branch("main")
		)
    ],
    targets: [
        .target(
            name: "CodeAnalyser",
			dependencies: [
				.product(name: "Funswift", package: "Funswift")
			])
		,
        .testTarget(
            name: "CodeAnalyserTests",
            dependencies: ["CodeAnalyser"]),
    ]
)
