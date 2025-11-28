# TestFlight Deployment Guide for Snooze

Step-by-step guide to deploy Snooze to TestFlight for beta testing.

---

## Option A: Manual Deployment (Xcode)

### Step 1: Prepare for Archive

1. **Connect your Apple ID in Xcode**:
   - Xcode → **Settings** → **Accounts**
   - Add your Apple ID if not already added
   - Download certificates: Click your team → **Download Manual Profiles**

2. **Select target device**:
   - In the scheme selector, choose **Any iOS Device (arm64)**
   - NOT a simulator

3. **Verify build settings**:
   - Select **Snooze** target → **General**
   - Version: `1.0.0`
   - Build: `1` (increment for each upload)

### Step 2: Create Archive

1. **Clean build folder**:
   ```
   Product → Clean Build Folder (⇧⌘K)
   ```

2. **Create archive**:
   ```
   Product → Archive (⇧⌘B then Product → Archive)
   ```

3. Wait for archive to complete (1-3 minutes)

4. **Organizer window** opens automatically with your archive

### Step 3: Upload to App Store Connect

1. In Organizer, select your archive
2. Click **Distribute App**
3. Select **App Store Connect** → **Next**
4. Select **Upload** → **Next**
5. Options:
   - [x] Upload your app's symbols (recommended)
   - [x] Manage Version and Build Number (let Xcode manage)
6. Select your **Distribution Certificate** and **Provisioning Profile**
7. Click **Upload**

Upload takes 5-15 minutes depending on connection speed.

### Step 4: Wait for Processing

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **My Apps** → **Snooze** → **TestFlight**
3. Build appears as **Processing** (takes 10-30 minutes)
4. Once processed, status changes to **Ready to Test** or **Missing Compliance**

### Step 5: Export Compliance

If you see **Missing Compliance**:

1. Click the build number
2. Answer: **Does your app use encryption?**
   - Select **No** (Snooze uses only standard HTTPS)
3. Click **Start Internal Testing**

### Step 6: Internal Testing

Internal testers = Your team (up to 100 App Store Connect users)

1. Go to **TestFlight** → **Internal Testing**
2. Click **+** next to **App Store Connect Users**
3. Add testers (must have App Store Connect access)
4. Testers receive email invitation
5. They install **TestFlight app** and accept invite

### Step 7: External Testing (Optional)

External testers = Anyone with email (up to 10,000)

1. Go to **TestFlight** → **External Testing**
2. Click **+** to create a new group
3. Add **Build** to the group
4. Fill in **Test Information**:
   - **What to Test**: `Test snooze functionality, subscription flow, dark/light modes`
   - **Beta App Description**: Same as App Store description
   - **Email**: Your support email
5. Click **Submit for Review** (required for external testing)
6. Wait for Beta App Review (usually 24-48 hours)
7. Once approved, add tester emails

---

## Option B: Fastlane Automation

### Step 1: Install Fastlane

```bash
# Using Homebrew (recommended)
brew install fastlane

# Or using RubyGems
sudo gem install fastlane -NV
```

### Step 2: Initialize Fastlane

```bash
cd /path/to/snooze_subscription_skeleton
fastlane init
```

Select: **4. Manual setup**

### Step 3: Configure Fastfile

Create/edit `fastlane/Fastfile`:

```ruby
default_platform(:ios)

platform :ios do
  desc "Push a new beta build to TestFlight"
  lane :beta do
    # Increment build number
    increment_build_number(
      xcodeproj: "Snooze.xcodeproj"
    )

    # Build the app
    build_app(
      scheme: "Snooze",
      export_method: "app-store",
      output_directory: "./build",
      output_name: "Snooze.ipa"
    )

    # Upload to TestFlight
    upload_to_testflight(
      skip_waiting_for_build_processing: true
    )
  end

  desc "Take screenshots"
  lane :screenshots do
    capture_screenshots
  end

  desc "Deploy a new version to the App Store"
  lane :release do
    build_app(scheme: "Snooze")
    upload_to_app_store(
      skip_metadata: true,
      skip_screenshots: true
    )
  end
end
```

### Step 4: Configure Appfile

Edit `fastlane/Appfile`:

```ruby
app_identifier("com.yourcompany.snooze")
apple_id("your@email.com")
team_id("XXXXXXXXXX")  # Your Team ID from Developer Portal
```

### Step 5: Run Fastlane

```bash
# Deploy to TestFlight
fastlane beta

# First time: You'll be prompted to sign in
# Fastlane stores credentials in Keychain
```

### Step 6: Automate with GitHub Actions (Optional)

Create `.github/workflows/testflight.yml`:

```yaml
name: TestFlight Deploy

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  deploy:
    runs-on: macos-latest

    steps:
    - uses: actions/checkout@v4

    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: '3.2'
        bundler-cache: true

    - name: Install Fastlane
      run: bundle install

    - name: Install certificates
      env:
        MATCH_PASSWORD: ${{ secrets.MATCH_PASSWORD }}
        MATCH_GIT_URL: ${{ secrets.MATCH_GIT_URL }}
      run: fastlane match appstore --readonly

    - name: Build and upload
      env:
        APP_STORE_CONNECT_API_KEY: ${{ secrets.ASC_API_KEY }}
      run: fastlane beta
```

---

## Testing Checklist

### Before Distributing

- [ ] Test on real device (not just simulator)
- [ ] Verify notifications work when app is backgrounded
- [ ] Test subscription purchase flow (use Sandbox account)
- [ ] Test subscription restore
- [ ] Verify dark mode looks correct
- [ ] Test with VoiceOver enabled
- [ ] Check all snooze intervals work correctly

### Create Sandbox Test Account

1. Go to App Store Connect → **Users and Access** → **Sandbox**
2. Click **+** to add Sandbox Tester
3. Use a unique email (can be fake domain)
4. On test device: **Settings** → **App Store** → **Sandbox Account**

### Test Subscription Flow

1. Tap upgrade → See paywall
2. Tap Continue → Purchase dialog appears
3. Authenticate with Sandbox account
4. Verify `isSubscribed` becomes `true`
5. Test Restore Purchases button

---

## Troubleshooting

### "No accounts with App Store Connect access"
- Ensure your Apple ID is added to the App Store Connect team
- Check role permissions in Users and Access

### "Profile doesn't match bundle identifier"
```bash
# In Xcode
Product → Clean Build Folder
# Then re-archive
```

### Build stuck in "Processing"
- Normal processing time: 10-30 minutes
- If >1 hour: Check App Store Connect status page
- Try uploading again

### "Missing Compliance" won't go away
- Answer the encryption question for EACH build
- Or add to Info.plist:
```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

### Fastlane authentication issues
```bash
# Clear credentials and re-authenticate
fastlane spaceauth -u your@email.com
```

---

## Quick Reference

### Build Number Convention

| Version | Build | When |
|---------|-------|------|
| 1.0.0 | 1 | Initial TestFlight |
| 1.0.0 | 2 | Bug fix during beta |
| 1.0.0 | 3 | Final for App Store |
| 1.0.1 | 1 | First patch release |

### Fastlane Commands

```bash
fastlane beta          # Upload to TestFlight
fastlane release       # Upload for App Store Review
fastlane screenshots   # Generate screenshots
fastlane match         # Sync certificates
```

### Useful Links

- [App Store Connect](https://appstoreconnect.apple.com)
- [TestFlight Documentation](https://developer.apple.com/testflight/)
- [Fastlane Documentation](https://docs.fastlane.tools)
- [Apple Developer Forums](https://developer.apple.com/forums/)

---

*Last Updated: 2025-11-28*
