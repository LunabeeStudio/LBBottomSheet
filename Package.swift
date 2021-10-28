// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LBBottomSheet",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "LBBottomSheet",
            targets: ["LBBottomSheet"]),
    ],
    targets: [
        .target(
            name: "LBBottomSheet",
            dependencies: [])
    ],
    swiftLanguageVersions: [.v5]
)
