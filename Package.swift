// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SkyWayRoom",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SkyWayRoom",
            targets: ["SkyWayRoom", "WebRTC"]),
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
            url: "https://github.com/skyway/ios-sdk/releases/download/4.1.1/SkyWayRoom.xcframework.zip",
            checksum: "e076685d52d113bc0924ca75eeebcc1da112f0033c9e0baec818a13dd079fd13"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/136.0.0/WebRTC.xcframework.zip",
            checksum: "490be6d4d30464195c9024258ae82775e68cee8538016894c0bbd9c7e7700b02"),

    ],
    swiftLanguageVersions: [.v5]
)
