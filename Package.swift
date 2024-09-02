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
            url: "https://github.com/skyway/ios-sdk/releases/download/2.1.0/SkyWayRoom.xcframework.zip",
            checksum: "1963f83e1cff8101497959322b4b77a8e1b6e4420e2cbc0b03db27db5156f40f"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.1.0/SkyWayCore.xcframework.zip",
            checksum: "663a94446cbda5f359fa9da428cf54f65c06deb44b871cd8c9dc2383398ec0b8"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/2.1.0/SkyWaySFUBot.xcframework.zip",
            checksum: "048a3fc42d79d00672f7746201b41e62bb28aa38bc9214431841aab23aea24a8"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/104.0.2/WebRTC.xcframework.zip",
            checksum: "32769426692bf091606135eabbddb98fb975f747f655cd587228dc3d3dac7a22"),

    ],
    swiftLanguageVersions: [.v5]
)
