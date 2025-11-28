# App Store Connect Setup Guide for Snooze

Complete step-by-step guide to configure Snooze for App Store submission.

---

## Prerequisites

- [ ] Apple Developer Program membership ($99/year)
- [ ] Xcode 15+ installed
- [ ] Apple ID with two-factor authentication enabled
- [ ] Privacy Policy URL (we'll create this in a later step)

---

## Step 1: Create App ID in Apple Developer Portal

### 1.1 Register Bundle Identifier

1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Identifiers** → **+** button
4. Select **App IDs** → Continue
5. Select **App** → Continue
6. Fill in:
   - **Description**: `Snooze Reminder App`
   - **Bundle ID**: Select **Explicit** and enter: `com.yourcompany.snooze`
     > Replace `yourcompany` with your company/developer name

### 1.2 Enable Capabilities

Check these capabilities:
- [x] **Push Notifications** (for local notifications)
- [x] **In-App Purchase** (for subscriptions)

Click **Continue** → **Register**

---

## Step 2: Create App in App Store Connect

### 2.1 New App Setup

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **My Apps** → **+** → **New App**
3. Fill in:

| Field | Value |
|-------|-------|
| **Platforms** | iOS |
| **Name** | Snooze – Remind Me Later |
| **Primary Language** | English (U.S.) |
| **Bundle ID** | Select the ID from Step 1 |
| **SKU** | `snooze-ios-v1` |
| **User Access** | Full Access |

4. Click **Create**

---

## Step 3: Configure In-App Purchase (Subscription)

### 3.1 Create Subscription Group

1. In your app page, go to **Monetization** → **Subscriptions**
2. Click **Create** under Subscription Groups
3. Enter:
   - **Reference Name**: `Snooze Pro`
   - **Subscription Group Reference Name**: `snooze_pro_group`
4. Click **Create**

### 3.2 Create Subscription Product

1. Click **Create** under the new subscription group
2. Fill in:

| Field | Value |
|-------|-------|
| **Reference Name** | Snooze Pro Monthly |
| **Product ID** | `com.yourcompany.snooze.pro.monthly` |
| **Subscription Duration** | 1 Month |

3. Click **Create**

### 3.3 Configure Subscription Details

1. **Subscription Prices**:
   - Click **Add Subscription Price**
   - Select base country (e.g., United States)
   - Choose price tier (suggested: **$0.99 - $2.99/month**)
   - Apple auto-generates prices for other countries

2. **Localizations** (at minimum, add English):
   - **Subscription Display Name**: `Snooze Pro`
   - **Description**: `Unlimited snoozes, custom Tonight time, and all future pro features.`

3. **Review Information** (for App Review):
   - **Screenshot**: Take a screenshot of the paywall
   - **Review Notes**: `Test account not required. Free tier allows 10 snoozes/day. Subscription unlocks unlimited.`

### 3.4 Update Your Code

Open `Store/SubscriptionManager.swift` and update the product ID:

```swift
// Change this line:
private let subscriptionProductID = "com.yourcompany.snooze.pro.monthly"

// To your actual product ID:
private let subscriptionProductID = "com.yourcompany.snooze.pro.monthly"
```

---

## Step 4: App Information & Metadata

### 4.1 App Information

Navigate to **App Information** in your app page:

| Field | Value |
|-------|-------|
| **Name** | Snooze – Remind Me Later |
| **Subtitle** | One-tap reminders, zero friction |
| **Category** | Productivity |
| **Secondary Category** | Utilities |
| **Content Rights** | Does not contain third-party content |
| **Age Rating** | Click to complete questionnaire (should be 4+) |

### 4.2 Privacy Policy

- **Privacy Policy URL**: `https://yourwebsite.com/snooze/privacy`
  > You MUST have a privacy policy for subscription apps

### 4.3 App Privacy

Go to **App Privacy** and complete the questionnaire:

**Data Collection**: Select **No** for all types (Snooze collects no user data)

If you add analytics later, update this section.

---

## Step 5: Version Information

### 5.1 Screenshots (Required)

You need screenshots for:
- **6.7" Display** (iPhone 15 Pro Max) - Required
- **6.5" Display** (iPhone 11 Pro Max) - Required
- **5.5" Display** (iPhone 8 Plus) - Optional but recommended

**Screenshot dimensions**:
| Device | Size |
|--------|------|
| 6.7" | 1290 × 2796 px |
| 6.5" | 1284 × 2778 px |
| 5.5" | 1242 × 2208 px |

**Recommended screenshots**:
1. Empty state with Snooze Bar visible
2. Reminder list with multiple items
3. Paywall/Pro features
4. Settings screen (optional)

### 5.2 App Description

```
Snooze lets you postpone anything with a single tap. No typing, no menus—just fast, one-tap reminders.

SIMPLE & FAST
• Tap 30m, 1h, or Tonight to snooze instantly
• Reminders fire even when the app is closed
• Clean, minimal interface that stays out of your way

DESIGNED FOR REAL LIFE
Perfect for when you're driving, in a meeting, or just busy. See a notification you can't act on right now? Snooze it.

FREE TO USE
• 10 free snoozes per day
• Upgrade to Snooze Pro for unlimited reminders

SNOOZE PRO ($X.XX/month)
• Unlimited snoozes
• Custom "Tonight" time
• All future pro features included

Privacy-focused: No tracking, no accounts, no data collection.
```

### 5.3 Keywords

```
snooze, reminder, remind me later, notifications, productivity, quick, fast, one-tap, postpone, delay
```

### 5.4 Support & Marketing URLs

| Field | Value |
|-------|-------|
| **Support URL** | `https://yourwebsite.com/snooze/support` |
| **Marketing URL** | `https://yourwebsite.com/snooze` (optional) |

### 5.5 Version & Build

| Field | Value |
|-------|-------|
| **Version** | 1.0.0 |
| **Copyright** | © 2024 Your Name |
| **What's New** | Initial release |

---

## Step 6: Build Configuration in Xcode

### 6.1 Update Project Settings

1. Open your Xcode project
2. Select the **Snooze** target
3. Go to **General** tab:

| Setting | Value |
|---------|-------|
| **Display Name** | Snooze |
| **Bundle Identifier** | com.yourcompany.snooze |
| **Version** | 1.0.0 |
| **Build** | 1 |
| **Minimum Deployment** | iOS 17.0 |

### 6.2 Signing & Capabilities

1. Go to **Signing & Capabilities** tab
2. Select your **Team**
3. Ensure **Automatically manage signing** is checked
4. Add capabilities (click **+ Capability**):
   - **Push Notifications**
   - **In-App Purchase**

### 6.3 App Icons

Create app icons using:
- [App Icon Generator](https://appicon.co/) or
- [SF Symbols](https://developer.apple.com/sf-symbols/) with custom design

Required sizes for iOS:
- 1024×1024 (App Store)
- 180×180 (@3x)
- 120×120 (@2x)
- 60×60 (@1x)

Place in `Assets.xcassets/AppIcon`

---

## Step 7: StoreKit Configuration (Testing)

### 7.1 Create StoreKit Configuration File

For testing subscriptions in simulator:

1. In Xcode: **File** → **New** → **File**
2. Search for **StoreKit Configuration File**
3. Name it `StoreKitConfig.storekit`
4. Add your subscription:
   - Click **+** → **Add Auto-Renewable Subscription**
   - **Reference Name**: Snooze Pro Monthly
   - **Product ID**: `com.yourcompany.snooze.pro.monthly`
   - **Price**: $0.99
   - **Subscription Duration**: 1 Month

### 7.2 Enable StoreKit Testing

1. Edit your scheme: **Product** → **Scheme** → **Edit Scheme**
2. Select **Run** → **Options**
3. Set **StoreKit Configuration** to your `.storekit` file

Now you can test purchases in the simulator!

---

## Step 8: Pre-Submission Checklist

Before submitting for review:

- [ ] Bundle ID matches App Store Connect
- [ ] Version number matches (1.0.0)
- [ ] App icon added to Assets
- [ ] Screenshots uploaded for all required sizes
- [ ] App description complete
- [ ] Privacy policy URL live and accessible
- [ ] In-App Purchase configured and ready for review
- [ ] Product ID in code matches App Store Connect
- [ ] StoreKit tested in simulator
- [ ] Tested on real device via TestFlight (next step)

---

## Next Steps

1. **TestFlight Deployment** → See `TESTFLIGHT_GUIDE.md`
2. **Privacy Policy** → See `PRIVACY_POLICY.md`
3. **Submit for Review** → After TestFlight testing

---

## Troubleshooting

### "Product not found" error
- Ensure product ID exactly matches App Store Connect
- Wait 24-48 hours after creating product (propagation delay)
- Use StoreKit configuration file for simulator testing

### Subscription not showing price
- Products take time to propagate
- Check Agreements in App Store Connect (must accept Paid Apps agreement)
- Verify subscription is in "Ready to Submit" or "Approved" state

### Signing errors
- Ensure Apple Developer membership is active
- Check that Bundle ID is registered
- Try: Xcode → **Product** → **Clean Build Folder**

---

*Last Updated: 2025-11-28*
