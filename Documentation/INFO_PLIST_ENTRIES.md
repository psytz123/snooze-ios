# Required Info.plist Entries for Snooze

Add these entries to your Xcode project's Info.plist for App Store submission.

---

## How to Add Entries

### Option 1: Xcode UI
1. Select your project in Navigator
2. Select **Snooze** target
3. Go to **Info** tab
4. Add entries under **Custom iOS Target Properties**

### Option 2: Edit Info.plist Directly
1. Right-click `Info.plist` → **Open As** → **Source Code**
2. Add XML entries inside the `<dict>` tags

---

## Required Entries

### 1. Export Compliance (Encryption)

Prevents "Missing Compliance" popup for each build.

**Key**: `ITSAppUsesNonExemptEncryption`
**Type**: Boolean
**Value**: `NO`

```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

> Snooze only uses HTTPS (standard iOS networking), which is exempt.

---

### 2. User Notifications Description

Required for notification permission dialog.

**Key**: `NSUserNotificationsUsageDescription`
**Type**: String
**Value**: `Snooze needs notifications to remind you at your scheduled times.`

```xml
<key>NSUserNotificationsUsageDescription</key>
<string>Snooze needs notifications to remind you at your scheduled times.</string>
```

---

### 3. App Transport Security (Already Default)

iOS enforces HTTPS by default. No entry needed unless you use HTTP.

```xml
<!-- Only add if you need HTTP (not recommended) -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
</dict>
```

---

## Recommended Entries

### 4. Background Modes (Optional - for future features)

If you later add background refresh:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>processing</string>
</array>
```

> **Note**: Not needed for v1.0 - local notifications work without background modes.

---

### 5. Supported Interface Orientations

Lock to portrait for simpler UI:

```xml
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
```

---

### 6. Status Bar Style

For consistent appearance:

```xml
<key>UIStatusBarStyle</key>
<string>UIStatusBarStyleDefault</string>
<key>UIViewControllerBasedStatusBarAppearance</key>
<true/>
```

---

## Complete Info.plist Template

Here's a minimal complete Info.plist for Snooze:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Bundle Configuration -->
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

    <!-- Display Name -->
    <key>CFBundleDisplayName</key>
    <string>Snooze</string>

    <!-- App Requirements -->
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UILaunchScreen</key>
    <dict/>

    <!-- Supported Orientations -->
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

    <!-- Export Compliance -->
    <key>ITSAppUsesNonExemptEncryption</key>
    <false/>

    <!-- Notifications Permission -->
    <key>NSUserNotificationsUsageDescription</key>
    <string>Snooze needs notifications to remind you at your scheduled times.</string>

    <!-- Appearance -->
    <key>UIStatusBarStyle</key>
    <string>UIStatusBarStyleDefault</string>
    <key>UIViewControllerBasedStatusBarAppearance</key>
    <true/>
</dict>
</plist>
```

---

## Verification Checklist

Before submitting:

- [ ] `ITSAppUsesNonExemptEncryption` is set to `false`
- [ ] `NSUserNotificationsUsageDescription` has user-friendly text
- [ ] Bundle identifier matches App Store Connect
- [ ] Version and build numbers are correct
- [ ] Display name is set to "Snooze"

---

*Last Updated: 2025-11-28*
