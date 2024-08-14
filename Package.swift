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
            url: "https://github.com/skyway/ios-sdk/releases/download/2.0.8/SkyWayRoom.xcframework.zip",
            checksum: "97167bae1309deaef69e671fe4b61372232b696fe9ff9e520770dfc61c3856ad"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.0.8/SkyWayCore.xcframework.zip",
            checksum: "5e955e47654701142905569bb6a66bd28a83a8e278982b2b9c303824d3098ed9"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.0.8/SkyWaySFUBot.xcframework.zip",
            checksum: "5ee923e532b9347f623602e97ba4d0a37a14f700beec10890130cb7c1f9cf461"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/104.0.2/WebRTC.xcframework.zip",
            checksum: "32769426692bf091606135eabbddb98fb975f747f655cd587228dc3d3dac7a22"),

    ],
    swiftLanguageVersions: [.v5]
)
