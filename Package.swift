// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SkyWayRoom",
    platforms: [
        .iOS(.v14)
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
            url: "https://github.com/skyway/ios-sdk/releases/download/3.1.1/SkyWayRoom.xcframework.zip",
            checksum: "af41e725a0fcc11f2dace3af8a8ddf2e89374a189a1699e05c40ece092cd30e9"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/120.1.0/WebRTC.xcframework.zip",
            checksum: "c2085bf5c51121c6cfec204aaa42ff21a9f3b7f0253cf2b6bb32efa56efbff4e"),

    ],
    swiftLanguageVersions: [.v5]
)
