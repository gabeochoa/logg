// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bookmarkd",
    platforms: [
        .macOS(.v15),
        .iOS(.v15),
    ],
    products: [
        .executable(name: "bookmarkd", targets: ["bookmarkd"]),
    ],
    targets: [
        .executableTarget(name: "bookmarkd", path: "bookmarkd"),
    ]
)
