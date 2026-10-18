// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "proscholy_common",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "proscholy-common", targets: ["proscholy_common"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "proscholy_common",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
