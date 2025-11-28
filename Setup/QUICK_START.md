# Snooze iOS App - Quick Start Guide for MacinCloud

**Created: 2025-11-28**

Since SSH is restricted on MacinCloud, follow these steps using Remote Desktop:

---

## Step 1: Transfer Files to Your Mac

### Option A: Using Cloud Storage (Recommended)
1. Upload the entire `snooze_subscription_skeleton` folder to:
   - OneDrive (you already have this synced)
   - Google Drive
   - Dropbox

2. On your MacinCloud Mac, open the browser and download from your cloud storage

### Option B: Using File Sharing
1. On MacinCloud Remote Desktop, go to **System Preferences → Sharing**
2. Enable **File Sharing**
3. Connect from Windows using `\\205.251.13.89` in File Explorer

### Option C: Direct ZIP Upload
1. The archive is already at: `C:\Users\psytz\Downloads\snooze_v1_complete.tar.gz`
2. Upload to a file sharing service like:
   - https://wetransfer.com
   - https://file.io
3. Download the link on your Mac

---

## Step 2: Extract Files on Mac

Open Terminal on Mac and run:

```bash
cd ~/Downloads
tar -xzvf snooze_v1_complete.tar.gz
cd snooze_subscription_skeleton
```

---

## Step 3: Create Xcode Project

### 3.1 Open Xcode
- Launch Xcode from Applications
- If prompted, install additional components

### 3.2 Create New Project
1. **File → New → Project** (⇧⌘N)
2. Select **iOS → App**
3. Configure:
   - **Product Name**: `Snooze`
   - **Team**: Select your Apple Developer account
   - **Organization Identifier**: `com.yourcompany` (change to yours)
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Storage**: SwiftData ✓ (CHECK THIS!)
4. Click **Next**
5. Choose location (e.g., Desktop) and click **Create**

### 3.3 Replace Generated Files

1. In Xcode's Project Navigator, **delete**:
   - `ContentView.swift`
   - `Item.swift` (the auto-generated SwiftData model)

2. From Finder, drag these folders into your Xcode project:
   ```
   Models/
   Store/
   Views/
   Notifications/
   Theme/
   SnoozeApp.swift
   ```

3. In the dialog:
   - ✓ Copy items if needed
   - ✓ Create groups
   - Target: Snooze ✓

---

## Step 4: Configure StoreKit

### 4.1 Create StoreKit Configuration
1. **File → New → File** (⌘N)
2. Search for "StoreKit"
3. Select **StoreKit Configuration File**
4. Name: `Products.storekit`
5. Click **Create**

### 4.2 Add Subscription Product
1. Click **+** button → **Add Auto-Renewable Subscription**
2. Configure:
   - **Reference Name**: Snooze Pro Monthly
   - **Product ID**: `com.yourcompany.snooze.pro.monthly`
   - **Price**: $2.99
   - **Subscription Duration**: 1 Month
   - **Subscription Group**: Snooze Pro

### 4.3 Enable StoreKit Testing
1. **Product → Scheme → Edit Scheme** (⌘<)
2. Select **Run** on the left
3. Go to **Options** tab
4. Set **StoreKit Configuration**: `Products.storekit`

---

## Step 5: Update Info.plist

1. Select project in navigator
2. Select **Snooze** target
3. Go to **Info** tab
4. Add these entries (if not present):

| Key | Type | Value |
|-----|------|-------|
| `ITSAppUsesNonExemptEncryption` | Boolean | NO |
| `NSUserNotificationsUsageDescription` | String | Snooze needs notifications to remind you at your scheduled times. |

---

## Step 6: Configure Signing

1. Select project in navigator
2. Select **Snooze** target
3. Go to **Signing & Capabilities** tab
4. Check **Automatically manage signing**
5. Select your **Team**
6. Update **Bundle Identifier** to match your App Store Connect app

### Add Capabilities
Click **+ Capability** and add:
- **In-App Purchase** (for StoreKit)
- **Push Notifications** (optional, for future features)

---

## Step 7: Build and Test

### Test on Simulator
1. Select an iPhone simulator (e.g., iPhone 15 Pro)
2. Press **⌘R** to build and run
3. Test:
   - Creating reminders
   - Notification permissions
   - Dark/Light mode toggle
   - Subscription flow (sandbox testing)

### Test on Device (Optional)
1. Connect iPhone via USB
2. Select your device in the scheme selector
3. Trust the developer certificate on your device if prompted
4. Press **⌘R** to build and run

---

## Step 8: Prepare for TestFlight

1. Update version and build number in project settings
2. **Product → Archive** (must be on "Any iOS Device")
3. In Organizer window, click **Distribute App**
4. Select **TestFlight & App Store**
5. Follow the prompts to upload

---

## Troubleshooting

### "No such module 'SwiftData'"
- Ensure deployment target is iOS 17.0+
- Clean build folder: **Product → Clean Build Folder** (⇧⌘K)

### "Signing certificate error"
- Ensure you're signed into Xcode with your Apple ID
- Check that your Apple Developer account is active

### "StoreKit products not loading"
- Verify the StoreKit configuration file is selected in scheme
- Check product IDs match exactly

### Build errors in Swift files
- Check Swift syntax for typos
- Ensure all imports are correct
- Clean and rebuild: ⇧⌘K then ⌘B

---

## File Structure After Setup

```
Snooze/
├── Snooze.xcodeproj
├── Snooze/
│   ├── SnoozeApp.swift
│   ├── Info.plist
│   ├── Snooze.entitlements
│   ├── Assets.xcassets/
│   ├── Models/
│   │   └── Reminder.swift
│   ├── Store/
│   │   ├── SnoozeModel.swift
│   │   └── SubscriptionManager.swift
│   ├── Views/
│   │   ├── RootView.swift
│   │   ├── SnoozeHostView.swift
│   │   ├── SnoozeBar.swift
│   │   ├── SettingsView.swift
│   │   └── PaywallView.swift
│   ├── Notifications/
│   │   ├── NotificationService.swift
│   │   └── NotificationDelegate.swift
│   ├── Theme/
│   │   └── SnoozeTheme.swift
│   └── Preview Content/
└── Products.storekit
```

---

## Next Steps After Building

1. **Add App Icon**: Create 1024x1024 PNG and add to Assets.xcassets
2. **Create Screenshots**: For App Store listing
3. **Write App Description**: For App Store Connect
4. **Set Up App Store Connect**: Follow the APP_STORE_CONNECT_GUIDE.md
5. **Upload to TestFlight**: Follow TESTFLIGHT_GUIDE.md

---

*Questions? The Documentation/ folder contains detailed guides for each step.*
