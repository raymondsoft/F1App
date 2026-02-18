// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "F1UseCases",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "F1UseCases",
            targets: ["F1UseCases"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "F1UseCases"
        ),
        .testTarget(
            name: "F1UseCasesTests",
            dependencies: ["F1UseCases"]
        ),
    ]
)
