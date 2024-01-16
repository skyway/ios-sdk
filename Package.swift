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
            url: "https://github.com/skyway/ios-sdk/releases/download/1.8.1/SkyWayRoom.xcframework.zip",
            checksum: "10d5b10836b4fe63bece672637847a4c8baa95d566ea29ecab6e88944a6799b0"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.8.1/SkyWayCore.xcframework.zip",
            checksum: "9b198e406fe198ef5052ac9296c2aecd180f48e4b628e87b966cb0106ce99969"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.8.1/SkyWaySFUBot.xcframework.zip",
            checksum: "cd237d3c5e3b0df52120d691130b9117d8ade1ff3cebf60812588dcdc9a00853"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/104.0.1/WebRTC.xcframework.zip",
            checksum: "9e6def6a337b8259fdfb2fef623e8b79947a6a1c4de9f9049d62fae0a21e012a"),

    ],
    swiftLanguageVersions: [.v5]
)
