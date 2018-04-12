// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "LinogVapor",
    products: [
        .library(name: "LinogVapor", targets: ["LinogVapor"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/miroslavkovac/Lingo.git", from: "3.0.5")
    ],
    targets: [
        .target(name: "LinogVapor", dependencies: ["Vapor", "Lingo"], path: "Sources/"),
        .testTarget(name: "LingoVaporTests", dependencies: ["LinogVapor", "Vapor"])
    ]
)
