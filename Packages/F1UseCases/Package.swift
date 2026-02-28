// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "F1UseCases",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "F1UseCases",
            targets: ["F1UseCases"]
        ),
    ],
    dependencies: [
        .package(path: "../F1Domain")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "F1UseCases",
            dependencies: [
                .product(name: "F1Domain", package: "F1Domain")
            ]
        ),
        .testTarget(
            name: "F1UseCasesTests",
            dependencies: [
                "F1UseCases",
                .product(name: "F1Domain", package: "F1Domain")
            ]
        ),
    ]
)
