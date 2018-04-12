// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "LingoVapor",
    products: [
        .library(name: "LingoVapor", targets: ["LingoVapor"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/miroslavkovac/Lingo.git", from: "3.0.5")
    ],
    targets: [
        .target(name: "LingoVapor", dependencies: ["Vapor", "Lingo"], path: "Sources/"),
        .testTarget(name: "LingoVaporTests", dependencies: ["LingoVapor", "Vapor"])
    ]
)
