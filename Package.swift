// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EventLimiter",
    platforms: [.iOS(.v13), .tvOS(.v13), .macOS(.v10_15), .watchOS(.v6)],
    products: [
        .library(
            name: "EventLimiter",
            targets: ["EventLimiter"]
        )
    ],
    targets: [
        .target(
            name: "EventLimiter"
        ),
        .testTarget(
            name: "EventLimiterTests",
            dependencies: ["EventLimiter"]
        ),
    ]
)
