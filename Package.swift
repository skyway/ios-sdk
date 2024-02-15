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
            url: "https://github.com/skyway/ios-sdk/releases/download/1.8.4/SkyWayRoom.xcframework.zip",
            checksum: "c94dc757f413d252485efe3b1d6e8a0822a62b689d583ea55822058bbf1d030d"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.8.4/SkyWayCore.xcframework.zip",
            checksum: "b354ee200a9cdd0ca5b16c82e0210e27e3b523b8d029d50e5064d42edfd166db"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.8.4/SkyWaySFUBot.xcframework.zip",
            checksum: "d47b0a9c149ed8012dba837b849d01e53761ac83a3667e75ac1111a187337b70"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/104.0.2/WebRTC.xcframework.zip",
            checksum: "32769426692bf091606135eabbddb98fb975f747f655cd587228dc3d3dac7a22"),

    ],
    swiftLanguageVersions: [.v5]
)
