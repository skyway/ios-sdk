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
            url: "https://github.com/skyway/ios-sdk/releases/download/1.1.0/SkyWayRoom.xcframework.zip",
            checksum: "9bd7ca9ad5cf35a93dd1b0fa4359e44cb6f4c8369c1a7778b9b145b32e3cbe00"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.1.0/SkywayCore.xcframework.zip",
            checksum: "b485d79c85be598126dee643f2ffbfe3a39ec2230f57b2115cc1c004562df0bc"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.1.0/SkyWaySFUBot.xcframework.zip",
            checksum: "ae931a6febb73f535010a9dcfbca3485b6edd324486daa1a6a55cd0cb25b522b"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/104.0.0/WebRTC.xcframework.zip",
            checksum: "84722bec35c919945164edfa3f0577fc1c29bf2a14033d635bbe0b86ed0ef088"),

    ],
    swiftLanguageVersions: [.v5]
)
