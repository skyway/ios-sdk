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
            url: "https://github.com/skyway/ios-sdk/releases/download/2.0.4/SkyWayRoom.xcframework.zip",
            checksum: "9e381d5c9d6abc04da62eb358d2a08a42869175fb1e01c7599adb293e1ab0fe0"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.0.4/SkyWayCore.xcframework.zip",
            checksum: "dbabd2d4b4f84fe49e0a54a118a1cb43b6ab20b9f4feb2caeaac18125a7037df"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.0.4/SkyWaySFUBot.xcframework.zip",
            checksum: "21711ab9eccdbe0d8e6cb5e9f21406eff27e65d3ff7313c42d652d8fd6f9ff40"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/104.0.2/WebRTC.xcframework.zip",
            checksum: "32769426692bf091606135eabbddb98fb975f747f655cd587228dc3d3dac7a22"),

    ],
    swiftLanguageVersions: [.v5]
)
