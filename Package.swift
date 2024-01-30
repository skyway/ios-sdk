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
            url: "https://github.com/skyway/ios-sdk/releases/download/1.8.2/SkyWayRoom.xcframework.zip",
            checksum: "7b68908622772808d149f4e56274fc6455211bf53ce56067a35a1e1353820812"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.8.2/SkyWayCore.xcframework.zip",
            checksum: "879737f6c72246c59178abf1a5eb6d2267a9fd5e22d09c9a8023a4969530c7cb"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.8.2/SkyWaySFUBot.xcframework.zip",
            checksum: "bcab68cf1989852cb1cfd75f68752a4e1ef87061de2d3bde39302b9ed4db9564"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/104.0.1/WebRTC.xcframework.zip",
            checksum: "9e6def6a337b8259fdfb2fef623e8b79947a6a1c4de9f9049d62fae0a21e012a"),

    ],
    swiftLanguageVersions: [.v5]
)
