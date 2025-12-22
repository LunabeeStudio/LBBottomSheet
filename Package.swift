// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LBBottomSheet",
    platforms: [.iOS(.v15)],
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
    swiftLanguageModes: [.v5]
)
