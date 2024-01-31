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
            url: "https://github.com/skyway/ios-sdk/releases/download/1.8.3/SkyWayRoom.xcframework.zip",
            checksum: "653045da086be8b65d293d2b712998d12e86b11afceea1e7eb2551bc72e2f0af"),
        .binaryTarget(
            name: "SkyWayCore",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.8.3/SkyWayCore.xcframework.zip",
            checksum: "f985f1066284de3264cbe0b86ec3885b324ccb667454f254f4e1521b3c94d398"),
        .binaryTarget(
            name: "SkyWaySFUBot",
            url: "https://github.com/skyway/ios-sdk/releases/download/1.8.3/SkyWaySFUBot.xcframework.zip",
            checksum: "8dea6af7793b373b23788b00b5be6702ee5407ccdb1351363d5194ed3cb1ae62"),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/skyway/skyway-ios-webrtc-specs/releases/download/104.0.1/WebRTC.xcframework.zip",
            checksum: "9e6def6a337b8259fdfb2fef623e8b79947a6a1c4de9f9049d62fae0a21e012a"),

    ],
    swiftLanguageVersions: [.v5]
)
