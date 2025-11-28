#!/bin/bash
# Snooze iOS App - Xcode Project Setup Script
# Run this script on your MacinCloud Mac to create the Xcode project
#
# Usage: chmod +x setup_xcode_project.sh && ./setup_xcode_project.sh
#
# Created: 2025-11-28

set -e

echo "================================================"
echo "  Snooze iOS App - Xcode Project Setup"
echo "================================================"
echo ""

# Configuration
PROJECT_NAME="Snooze"
BUNDLE_ID="com.yourcompany.snooze"  # Change this!
TEAM_ID=""  # Your Apple Developer Team ID
DEPLOYMENT_TARGET="17.0"

# Get the script directory (where project files should be)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Project root: $PROJECT_ROOT"
echo ""

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed. Please install Xcode from the App Store."
    exit 1
fi

XCODE_VERSION=$(xcodebuild -version | head -1)
echo "✅ Found $XCODE_VERSION"

# Check for Swift files
SWIFT_COUNT=$(find "$PROJECT_ROOT" -name "*.swift" 2>/dev/null | wc -l | tr -d ' ')
echo "✅ Found $SWIFT_COUNT Swift source files"
echo ""

# Create Xcode project directory
XCODE_PROJECT_DIR="$PROJECT_ROOT/$PROJECT_NAME"
mkdir -p "$XCODE_PROJECT_DIR"
mkdir -p "$XCODE_PROJECT_DIR/$PROJECT_NAME"
mkdir -p "$XCODE_PROJECT_DIR/$PROJECT_NAME/Assets.xcassets"
mkdir -p "$XCODE_PROJECT_DIR/$PROJECT_NAME/Preview Content"

echo "Creating Xcode project structure..."

# Copy Swift source files maintaining structure
echo "Copying source files..."
for dir in Models Store Views Notifications Theme; do
    if [ -d "$PROJECT_ROOT/$dir" ]; then
        mkdir -p "$XCODE_PROJECT_DIR/$PROJECT_NAME/$dir"
        cp -r "$PROJECT_ROOT/$dir/"* "$XCODE_PROJECT_DIR/$PROJECT_NAME/$dir/" 2>/dev/null || true
        echo "  ✅ Copied $dir/"
    fi
done

# Copy main app file
if [ -f "$PROJECT_ROOT/SnoozeApp.swift" ]; then
    cp "$PROJECT_ROOT/SnoozeApp.swift" "$XCODE_PROJECT_DIR/$PROJECT_NAME/"
    echo "  ✅ Copied SnoozeApp.swift"
fi

# Create Assets.xcassets Contents.json
cat > "$XCODE_PROJECT_DIR/$PROJECT_NAME/Assets.xcassets/Contents.json" << 'EOF'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create AccentColor asset
mkdir -p "$XCODE_PROJECT_DIR/$PROJECT_NAME/Assets.xcassets/AccentColor.colorset"
cat > "$XCODE_PROJECT_DIR/$PROJECT_NAME/Assets.xcassets/AccentColor.colorset/Contents.json" << 'EOF'
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.980",
          "green" : "0.600",
          "red" : "0.380"
        }
      },
      "idiom" : "universal"
    },
    {
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ],
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "1.000",
          "green" : "0.700",
          "red" : "0.480"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create AppIcon asset
mkdir -p "$XCODE_PROJECT_DIR/$PROJECT_NAME/Assets.xcassets/AppIcon.appiconset"
cat > "$XCODE_PROJECT_DIR/$PROJECT_NAME/Assets.xcassets/AppIcon.appiconset/Contents.json" << 'EOF'
{
  "images" : [
    {
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create Preview Assets
mkdir -p "$XCODE_PROJECT_DIR/$PROJECT_NAME/Preview Content/Preview Assets.xcassets"
cat > "$XCODE_PROJECT_DIR/$PROJECT_NAME/Preview Content/Preview Assets.xcassets/Contents.json" << 'EOF'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create Info.plist
cat > "$XCODE_PROJECT_DIR/$PROJECT_NAME/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>CFBundleDisplayName</key>
    <string>Snooze</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UILaunchScreen</key>
    <dict/>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>ITSAppUsesNonExemptEncryption</key>
    <false/>
    <key>NSUserNotificationsUsageDescription</key>
    <string>Snooze needs notifications to remind you at your scheduled times.</string>
    <key>UIStatusBarStyle</key>
    <string>UIStatusBarStyleDefault</string>
    <key>UIViewControllerBasedStatusBarAppearance</key>
    <true/>
</dict>
</plist>
EOF

echo "  ✅ Created Info.plist"

# Create entitlements file
cat > "$XCODE_PROJECT_DIR/$PROJECT_NAME/$PROJECT_NAME.entitlements" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.storekit.access-purchase-history</key>
    <true/>
</dict>
</plist>
EOF

echo "  ✅ Created entitlements file"

# Create project.pbxproj (minimal Xcode project file)
XCODEPROJ_DIR="$XCODE_PROJECT_DIR/$PROJECT_NAME.xcodeproj"
mkdir -p "$XCODEPROJ_DIR"

echo ""
echo "================================================"
echo "  Setup Complete!"
echo "================================================"
echo ""
echo "Project files are ready at:"
echo "  $XCODE_PROJECT_DIR"
echo ""
echo "NEXT STEPS:"
echo ""
echo "1. Open Xcode"
echo ""
echo "2. Create new project:"
echo "   • File → New → Project"
echo "   • Choose 'App' under iOS"
echo "   • Product Name: Snooze"
echo "   • Team: Select your team"
echo "   • Organization Identifier: com.yourcompany"
echo "   • Interface: SwiftUI"
echo "   • Language: Swift"
echo "   • Storage: SwiftData ✓"
echo ""
echo "3. Replace generated files:"
echo "   • Delete the auto-generated ContentView.swift"
echo "   • Drag and drop all folders from:"
echo "     $XCODE_PROJECT_DIR/$PROJECT_NAME/"
echo "   • Make sure 'Copy items if needed' is UNCHECKED"
echo "   • Make sure 'Create folder references' is selected"
echo ""
echo "4. Add StoreKit Configuration:"
echo "   • File → New → File"
echo "   • Search for 'StoreKit'"
echo "   • Choose 'StoreKit Configuration File'"
echo "   • Name it: Products.storekit"
echo "   • Add subscription product:"
echo "     - Reference Name: Snooze Pro Monthly"
echo "     - Product ID: com.yourcompany.snooze.pro.monthly"
echo "     - Price: \$2.99/month"
echo ""
echo "5. Configure signing:"
echo "   • Select project in navigator"
echo "   • Select Snooze target"
echo "   • Signing & Capabilities tab"
echo "   • Select your Team"
echo "   • Update Bundle Identifier"
echo ""
echo "6. Build and Run:"
echo "   • Select an iPhone simulator"
echo "   • Press ⌘R to build and run"
echo ""
echo "================================================"
