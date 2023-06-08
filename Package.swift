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
            url: "https://github.com/skyway/ios-sdk/releases/download/1.4.0/SkyWayRoom.xcframework.zip",
            checksum: "f776384723aa722977b3f3de9ffc43312e1311b0719ea20f8104048f44d2ed45"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.4.0/SkywayCore.xcframework.zip",
            checksum: "55e53958f36dfd06bfc38e176e161a0d72ebca3b53b476233955dc095112459c"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.4.0/SkyWaySFUBot.xcframework.zip",
            checksum: "18fb46588bcce75d77823f87ac89685133fb06f66c0fe7aaa1eb2cbd7a73764b"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/104.0.1/WebRTC.xcframework.zip",
            checksum: "9e6def6a337b8259fdfb2fef623e8b79947a6a1c4de9f9049d62fae0a21e012a"),

    ],
    swiftLanguageVersions: [.v5]
)
