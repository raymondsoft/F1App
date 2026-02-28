// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "F1Data",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "F1Data",
            targets: ["F1Data"]
        ),
    ],
    dependencies: [
        .package(path: "../F1Domain")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "F1Data",
            dependencies: [
                .product(name: "F1Domain", package: "F1Domain")
            ]
        ),
        .testTarget(
            name: "F1DataTests",
            dependencies: [
                "F1Data",
                .product(name: "F1Domain", package: "F1Domain")
            ],
            resources: [
                .process("Helpers/Fixtures")
            ]
        ),
    ]
)
