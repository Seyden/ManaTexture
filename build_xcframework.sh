#!/bin/bash
set -euo pipefail

PROJECT="Texture/AsyncDisplayKit.xcodeproj"
SCHEME="AsyncDisplayKit"
FRAMEWORK_NAME="AsyncDisplayKit"
BUILD_DIR="$(pwd)/.build/xcframework-intermediates"
OUTPUT_DIR="$(pwd)/Frameworks"
XCFRAMEWORK_PATH="${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"

echo "==> Cleaning previous build artifacts"
rm -rf "$BUILD_DIR" "$XCFRAMEWORK_PATH"
mkdir -p "$BUILD_DIR" "$OUTPUT_DIR"

echo "==> Archiving for iOS device (arm64)"
xcodebuild archive \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "${BUILD_DIR}/ios.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    | xcpretty 2>/dev/null || true

# Fallback if xcpretty is not installed
if [ ! -d "${BUILD_DIR}/ios.xcarchive" ]; then
    xcodebuild archive \
        -project "$PROJECT" \
        -scheme "$SCHEME" \
        -configuration Release \
        -destination "generic/platform=iOS" \
        -archivePath "${BUILD_DIR}/ios.xcarchive" \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES
fi

echo "==> Archiving for iOS Simulator (arm64 + x86_64)"
xcodebuild archive \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration Release \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "${BUILD_DIR}/ios-simulator.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "==> Creating XCFramework"
xcodebuild -create-xcframework \
    -framework "${BUILD_DIR}/ios.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
    -framework "${BUILD_DIR}/ios-simulator.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
    -output "$XCFRAMEWORK_PATH"

echo ""
echo "✓ XCFramework created at: ${XCFRAMEWORK_PATH}"
echo ""
echo "To compute the checksum for a remote Package.swift binary target, run:"
echo "  swift package compute-checksum ${XCFRAMEWORK_PATH}.zip"
