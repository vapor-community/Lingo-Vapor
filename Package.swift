// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "LingoVapor",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "LingoVapor", targets: ["LingoVapor"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.27.0"),
        .package(url: "https://github.com/miroslavkovac/Lingo.git", from: "3.1.0")
    ],
    targets: [
        .target(name: "LingoVapor", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Lingo", package: "Lingo")
        ], path: "Sources/"),
        .testTarget(name: "LingoVaporTests", dependencies: [
            .target(name: "LingoVapor")
        ])
    ]
)
