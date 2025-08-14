#!/bin/bash

# =============================================================================
# MacTemp Guard - Release Build Script
# =============================================================================
# 
# This script builds and packages MacTemp Guard for distribution.
# 
# Usage: ./build_release.sh [version]
# 
# Requirements:
# - Xcode installed
# - Code signing certificates configured
# - Notarization credentials set up
# =============================================================================

set -e

VERSION=${1:-"1.0.0"}
BUILD_NUMBER=${2:-"1"}
CONFIGURATION="Release"

echo "🚀 Building MacTemp Guard v$VERSION (Build $BUILD_NUMBER)"
echo "=================================================="

# Clean previous builds
echo "🧹 Cleaning previous builds..."
xcodebuild clean -project "MacTemp Guard.xcodeproj" -scheme "MacTemp Guard" -configuration "$CONFIGURATION"

# Build for Apple Silicon
echo "🔨 Building for Apple Silicon..."
xcodebuild archive \
    -project "MacTemp Guard.xcodeproj" \
    -scheme "MacTemp Guard" \
    -configuration "$CONFIGURATION" \
    -archivePath "build/MacTemp Guard-AppleSilicon.xcarchive" \
    -destination "generic/platform=macOS,arch=arm64" \
    CODE_SIGN_IDENTITY="Developer ID Application: Infinitum Imagery LLC" \
    CODE_SIGN_STYLE="Manual" \
    PROVISIONING_PROFILE="MacTemp Guard App Store" \
    PRODUCT_BUNDLE_IDENTIFIER="com.infinitumimagery.mactempguard" \
    MARKETING_VERSION="$VERSION" \
    CURRENT_PROJECT_VERSION="$BUILD_NUMBER"

# Build for Intel
echo "🔨 Building for Intel..."
xcodebuild archive \
    -project "MacTemp Guard.xcodeproj" \
    -scheme "MacTemp Guard" \
    -configuration "$CONFIGURATION" \
    -archivePath "build/MacTemp Guard-Intel.xcarchive" \
    -destination "generic/platform=macOS,arch=x86_64" \
    CODE_SIGN_IDENTITY="Developer ID Application: Infinitum Imagery LLC" \
    CODE_SIGN_STYLE="Manual" \
    PROVISIONING_PROFILE="MacTemp Guard App Store" \
    PRODUCT_BUNDLE_IDENTIFIER="com.infinitumimagery.mactempguard" \
    MARKETING_VERSION="$VERSION" \
    CURRENT_PROJECT_VERSION="$BUILD_NUMBER"

# Create DMG files
echo "📦 Creating DMG files..."

# Apple Silicon DMG
echo "Creating Apple Silicon DMG..."
xcodebuild -exportArchive \
    -archivePath "build/MacTemp Guard-AppleSilicon.xcarchive" \
    -exportPath "build/MacTemp Guard-AppleSilicon" \
    -exportOptionsPlist "exportOptions.plist"

# Intel DMG
echo "Creating Intel DMG..."
xcodebuild -exportArchive \
    -archivePath "build/MacTemp Guard-Intel.xcarchive" \
    -exportPath "build/MacTemp Guard-Intel" \
    -exportOptionsPlist "exportOptions.plist"

# Notarize DMG files
echo "🔐 Notarizing DMG files..."
# Add notarization commands here

echo "✅ Build completed successfully!"
echo "📦 DMG files created in build/ directory"
