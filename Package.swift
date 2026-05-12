// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ManaTexture",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "ManaTexture",
            targets: ["AsyncDisplayKit"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "AsyncDisplayKit",
            url: "https://github.com/Seyden/ManaTexture/releases/download/v3.2.0/AsyncDisplayKit.xcframework.zip",
            checksum: "f70fda9d7117ea9d8dc5935c9fcb4a890a29f2004713c43119bc89a13fa7f133"
        ),
    ]
)
