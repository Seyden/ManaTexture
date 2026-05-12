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
        // Pre-built XCFramework produced by build_xcframework.sh
        .binaryTarget(
            name: "AsyncDisplayKit",
            path: "Frameworks/AsyncDisplayKit.xcframework"
        ),
    ]
)
