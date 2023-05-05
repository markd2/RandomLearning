// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OnboardingKit",
    platforms: [
      .iOS(.v15)
    ],
    products: [
        .library(
            name: "OnboardingKit",
            targets: ["NavigationMod", "LoginMod"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NavigationMod",
            dependencies: []),
        .testTarget(
            name: "NavigationModTests",
            dependencies: ["NavigationMod"]),

        .target(
            name: "LoginMod",
            dependencies: []),
        .testTarget(
            name: "LoginModTests",
            dependencies: ["LoginMod"])
    ]
)
