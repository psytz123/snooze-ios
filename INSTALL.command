#!/bin/bash
# Snooze iOS App - One-Click Installer
# Double-click this file on your Mac to set up the Xcode project
#
# Created: 2025-11-28

cd "$(dirname "$0")"
SCRIPT_DIR="$(pwd)"

echo "========================================"
echo "  Snooze iOS App Installer"
echo "========================================"
echo ""

# Check for Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode not found. Please install Xcode from the App Store."
    echo "Press any key to exit..."
    read -n 1
    exit 1
fi

echo "✅ Xcode found: $(xcodebuild -version | head -1)"

# Create project directory
PROJECT_DIR=~/Desktop/SnoozeApp
mkdir -p "$PROJECT_DIR/Snooze"

echo "📁 Creating project at: $PROJECT_DIR"

# Copy source files
cp -r "$SCRIPT_DIR/Models" "$PROJECT_DIR/Snooze/" 2>/dev/null
cp -r "$SCRIPT_DIR/Store" "$PROJECT_DIR/Snooze/" 2>/dev/null
cp -r "$SCRIPT_DIR/Views" "$PROJECT_DIR/Snooze/" 2>/dev/null
cp -r "$SCRIPT_DIR/Notifications" "$PROJECT_DIR/Snooze/" 2>/dev/null
cp -r "$SCRIPT_DIR/Theme" "$PROJECT_DIR/Snooze/" 2>/dev/null
cp "$SCRIPT_DIR/SnoozeApp.swift" "$PROJECT_DIR/Snooze/" 2>/dev/null

echo "✅ Source files copied"

# Create Package.swift for Swift Package
cat > "$PROJECT_DIR/Package.swift" << 'PKGEOF'
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Snooze",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Snooze", targets: ["Snooze"])
    ],
    targets: [
        .target(name: "Snooze", path: "Snooze")
    ]
)
PKGEOF

echo "✅ Package.swift created"

# Create Assets
mkdir -p "$PROJECT_DIR/Snooze/Assets.xcassets/AppIcon.appiconset"
mkdir -p "$PROJECT_DIR/Snooze/Assets.xcassets/AccentColor.colorset"

cat > "$PROJECT_DIR/Snooze/Assets.xcassets/Contents.json" << 'EOF'
{"info":{"author":"xcode","version":1}}
EOF

cat > "$PROJECT_DIR/Snooze/Assets.xcassets/AppIcon.appiconset/Contents.json" << 'EOF'
{"images":[{"idiom":"universal","platform":"ios","size":"1024x1024"}],"info":{"author":"xcode","version":1}}
EOF

cat > "$PROJECT_DIR/Snooze/Assets.xcassets/AccentColor.colorset/Contents.json" << 'EOF'
{"colors":[{"color":{"color-space":"srgb","components":{"alpha":"1.000","blue":"0.980","green":"0.600","red":"0.380"}},"idiom":"universal"}],"info":{"author":"xcode","version":1}}
EOF

echo "✅ Assets created"

# Create Info.plist
cat > "$PROJECT_DIR/Snooze/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDisplayName</key>
    <string>Snooze</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>ITSAppUsesNonExemptEncryption</key>
    <false/>
    <key>NSUserNotificationsUsageDescription</key>
    <string>Snooze needs notifications to remind you at your scheduled times.</string>
    <key>UILaunchScreen</key>
    <dict/>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
    </array>
</dict>
</plist>
EOF

echo "✅ Info.plist created"

echo ""
echo "========================================"
echo "  Setup Complete!"
echo "========================================"
echo ""
echo "Opening Xcode..."
echo ""

# Open in Xcode
cd "$PROJECT_DIR"
open -a Xcode .

echo "NEXT STEPS in Xcode:"
echo "1. File → New → Project → iOS App"
echo "2. Name: Snooze, SwiftUI, SwiftData enabled"
echo "3. Delete ContentView.swift"
echo "4. Drag Snooze folder from ~/Desktop/SnoozeApp/Snooze into project"
echo "5. Build and Run (Cmd+R)"
echo ""
echo "Press any key to close..."
read -n 1
