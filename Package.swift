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
            url: "https://github.com/skyway/ios-sdk/releases/download/2.0.5/SkyWayRoom.xcframework.zip",
            checksum: "696d4f25353406086a161d29c64f87d7d26e2f0073660a8261cdaf2f2f047217"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.0.5/SkyWayCore.xcframework.zip",
            checksum: "023e23d3397db7c7e20f5abb31c65b07b1d0a8d940703292f16cc434286daeb8"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.0.5/SkyWaySFUBot.xcframework.zip",
            checksum: "e5f106ea036836a7efb8b2d294839107d2ace1f456f81be8183ab6ad7a31b740"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/104.0.2/WebRTC.xcframework.zip",
            checksum: "32769426692bf091606135eabbddb98fb975f747f655cd587228dc3d3dac7a22"),

    ],
    swiftLanguageVersions: [.v5]
)
