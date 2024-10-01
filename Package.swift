// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "PrimeComponents",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "PrimeComponents",
            targets: [
                "PrimeScenes",
                "PrimeUtilities",
            ]
        ),
        // PrimeComponentsLTE (“long-term evolution”) is a library that helps
        // clients with transitioning to PrimeComponents by exposing
        // certain internal targets.
        // When the package reaches v1.0, this library will be removed.
        .library(
            name: "PrimeComponentsLTE",
            targets: ["PrimeComponentsLTE"]
        ),
    ],
    targets: [
        .target(
            name: "PrimeComponentsLTE",
            dependencies: [
                "PrimeDesign",
                "PrimeInterfaces",
                "PrimeNetworking",
                "PrimeServices",
            ]
        ),
        .target(name: "PrimeDesign"),
        .target(name: "PrimeInterfaces"),
        .target(
            name: "PrimeNetworking",
            dependencies: ["PrimeInterfaces"]
        ),
        .target(name: "PrimeScenes"),
        .target(
            name: "PrimeServices",
            dependencies: ["PrimeInterfaces"]
        ),
        .target(name: "PrimeUtilities"),
        .target(
            name: "TestUtilities",
            path: "Tests/Utilities"
        ),
        .testTarget(
            name: "PrimeServicesTests",
            dependencies: [
                "PrimeServices",
                "TestUtilities",
            ]
        ),
        .testTarget(
            name: "PrimeUtilitiesTests",
            dependencies: ["PrimeUtilities"]
        ),
    ]
)
