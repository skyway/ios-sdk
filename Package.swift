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
            url: "https://github.com/skyway/ios-sdk/releases/download/1.0.0/SkyWayRoom.xcframework.zip",
            checksum: "3f42e1ea0671fb0555cb33b4072cad315def6f9d5a5204a7fb7b9958db65743e"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.0.0/SkywayCore.xcframework.zip",
            checksum: "e86d13e1099a6a48b33dccc3e93931e036d982479dd5fbc6af5c94137a4d1b0f"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.0.0/SkyWaySFUBot.xcframework.zip",
            checksum: "72b1fec6ac742c571ad36575b5b54009b25e3db1d8c911b6a50e3b2a509f8607"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc/releases/download/104.0.1/WebRTC.xcframework.zip",
            checksum: "84722bec35c919945164edfa3f0577fc1c29bf2a14033d635bbe0b86ed0ef088"),

    ],
    swiftLanguageVersions: [.v5]
)
