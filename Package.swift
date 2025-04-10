// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "BookMarked",
    platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v14)],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "BookMarked",
            dependencies: []
        )
    ]
)
