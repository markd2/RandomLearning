// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "ArgParserFun",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "repeat",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .executableTarget(
            name: "maths",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
    ]
)
