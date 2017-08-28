import PackageDescription

let package = Package(
    name: "LingoProvider",
    dependencies: [
        	.Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
            .Package(url: "https://github.com/miroslavkovac/Lingo.git", majorVersion: 3),
        ]
)
