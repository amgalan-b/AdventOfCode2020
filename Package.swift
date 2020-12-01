// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [
        .macOS(.v10_15),
    ],
    dependencies: [
        .package(name: "Babbage", path: "../Babbage"),
    ],
    targets: [
        .testTarget(
            name: "AdventOfCode",
            dependencies: ["Babbage"],
            path: "Sources",
            resources: [
                .copy("Resources"),
            ]),
    ]
)
