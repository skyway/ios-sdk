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
            url: "https://github.com/skyway/ios-sdk/releases/download/2.2.2/SkyWayRoom.xcframework.zip",
            checksum: "a7fa9999c62372bf487cc51e5b01a89de2c0318822c53b69b97d53df874b1339"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.2.2/SkyWayCore.xcframework.zip",
            checksum: "5441f956dc8de284be590a805ffdd927473572516993d9bd486707a3dbc9028b"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.2.2/SkyWaySFUBot.xcframework.zip",
            checksum: "09472c8c0cc673903dfef2d74ad6ad8287ff5b442cd3438edab2c2dd7e9a51b4"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/120.0.0/WebRTC.xcframework.zip",
            checksum: "6883b2e09669e380041bac4097c40644681c63fd78772dcd94416b4d3fce1317"),

    ],
    swiftLanguageVersions: [.v5]
)
