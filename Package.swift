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
            url: "https://github.com/skyway/ios-sdk/releases/download/2.3.2/SkyWayRoom.xcframework.zip",
            checksum: "854fe92884ad596706dbee9eee4b026555ae383faf798aa24d2e0af1f7fe0a52"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.3.2/SkyWayCore.xcframework.zip",
            checksum: "8be93c10ef91a501f3c834e61f8c3627d867205bc93417291a8ccf7f49810491"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.3.2/SkyWaySFUBot.xcframework.zip",
            checksum: "a2df06dc9301a578c5c4f6d3dda4174a378044d2c837691faad3d13b260abe17"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/120.0.0/WebRTC.xcframework.zip",
            checksum: "6883b2e09669e380041bac4097c40644681c63fd78772dcd94416b4d3fce1317"),

    ],
    swiftLanguageVersions: [.v5]
)
