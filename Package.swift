// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SkyWayRoom",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SkyWayRoom",
            targets: ["SkyWayRoom", "SkyWayCore", "SkyWaySFUBot", "WebRTC"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .binaryTarget(
            name: "SkyWayRoom",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.2.3/SkyWayRoom.xcframework.zip",
            checksum: "2cb43e6299e148e4eba57b6afd8e54ad3bcc90306cfd7ae22b8933961bcf8836"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.2.3/SkyWayCore.xcframework.zip",
            checksum: "b8aa36b2194e5a6144ee65caa3019f69d3152dda5fe69d26ab2748974d718864"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.2.3/SkyWaySFUBot.xcframework.zip",
            checksum: "c4df7b5f6bcc1eba5bd5929f827ba1431c410863366ad034f2d69a1d43fc195d"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/120.0.0/WebRTC.xcframework.zip",
            checksum: "6883b2e09669e380041bac4097c40644681c63fd78772dcd94416b4d3fce1317"),

    ],
    swiftLanguageVersions: [.v5]
)
