// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "LingoProvider",
    products: [
        .library(name: "LingoProvider", targets: ["LingoProvider"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "2.0.0"),
        .package(url: "https://github.com/miroslavkovac/Lingo.git", from: "3.0.0"),
    ],
    targets: [
    .target(name: "LingoProvider", dependencies: ["Vapor", "Lingo"], path: "./Sources"),
        .testTarget(name: "LingoProviderTests", dependencies: ["Vapor", "LingoProvider"])
    ]
)
