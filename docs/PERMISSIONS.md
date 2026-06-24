# ZeScan - App Permissions Documentation

## Overview
This document describes all permissions required by ZeScan and explains when and why each permission is used.

---

## Required Permissions

### 1. 📷 **Camera Permission**

**Android Declaration:**
```xml
<uses-permission android:name="android.permission.CAMERA"/>
```

**Purpose:**  
To scan and capture documents using the device camera with ML Kit document scanner.

**When Used:**
- When user taps "Start Scanning" button
- When user activates ML Kit scanner for document capture
- Camera opens with automatic edge detection and document enhancement

**Required:** ✅ **Yes** (Core feature - app cannot function without it)

**User Message:**
> "ZeScan needs camera access to scan and capture documents. This allows you to take photos of papers, receipts, and other documents."

**Permission Flow:**
1. User taps "Start Scanning"
2. App shows educational dialog explaining why permission is needed
3. User taps "Continue"
4. Android OS shows permission dialog
5. User grants/denies permission

---

### 2. 🖼️ **Photo Library Permission**

**Android Declaration (Version-specific):**

**For Android 12 and below (API 32 and below):**
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
```

**For Android 13+ (API 33+):**
```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

**Purpose:**  
To access and import images from the device's photo library/gallery for PDF conversion.

**When Used:**
- When user taps "Import from Gallery" button
- When user wants to convert existing photos to PDF documents
- ML Kit scanner can access gallery with this permission

**Required:** ⚠️ **Optional** (Only needed for gallery import feature)

**User Message:**
> "ZeScan needs access to your photo library to import images and convert them to PDF documents. You can select which photos to use."

**Note:**  
Android automatically handles the version-specific permission. Apps targeting Android 13+ will use `READ_MEDIA_IMAGES` while older devices use `READ_EXTERNAL_STORAGE`.

---

### 3. 🌐 **Internet Permission**

**Android Declaration:**  
(Automatically included, no explicit declaration needed)

**Purpose:**  
To send feedback, bug reports, and feature requests to the backend API.

**When Used:**
- When user submits feedback from Settings → Send Feedback
- When user submits bug report from Settings → Report a Bug
- When user submits feature request from Settings → Request a Feature

**Required:** ⚠️ **Optional** (Only needed for feedback features)

**API Endpoint:**  
`https://zescan.zeppelinlabs.digital/api/feedback`

**Data Sent:**
- User email (optional)
- Subject and message
- App version (automatic)
- Device info (automatic)

**User Message:**  
No permission dialog needed (automatically granted for all apps)

---

## Permission Handling Strategy

### Educational Dialogs

Before requesting any permission, ZeScan shows an educational dialog explaining:
- **What** permission is needed
- **Why** it's needed
- **When** it will be used
- **What** features require it

This helps users understand and increases permission grant rate.

### Permission States

ZeScan handles three permission states:

1. **Granted** ✅  
   Permission is granted, feature works normally

2. **Denied (First Time)** ⚠️  
   Shows educational dialog, can request again

3. **Permanently Denied** 🚫  
   Shows "Open Settings" dialog with instructions:
   > "This permission was previously denied. To use this feature, please enable it in Settings.  
   > Settings → Apps → ZeScan → Permissions"

---

## Version Management

### App Version Display

**Location:** Settings → About ZeScan

**Implementation:**  
Version is automatically fetched from `pubspec.yaml` using `package_info_plus`:

```dart
final packageInfo = await PackageInfo.fromPlatform();
final version = packageInfo.version; // e.g., "1.0.0"
```

**Current Version:** `1.0.0+1`

**Where Version Appears:**
- Settings screen: "About ZeScan - Version 1.0.0"
- About dialog: "ZeScan Scanner - Version 1.0.0"
- Feedback API: Automatically included with submissions

**How to Update:**
Edit version in `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

Format: `major.minor.patch+build`
- `1.0.0` - Version name (shown to users)
- `+1` - Build number (used by stores)

The app automatically reads this value, no manual updates needed elsewhere!

---

## Privacy & Security

### On-Device Processing
- All document scanning and PDF processing happens locally
- No document images are sent to servers
- Camera and photo access stay on-device only

### Network Usage
- Only used for feedback submission (optional feature)
- No analytics or tracking
- No advertising SDKs (currently)

### Data Collection
When submitting feedback (user-initiated only):
- Email (optional, user-provided)
- Feedback message (user-provided)
- App version (automatic)
- Device info (automatic, e.g., "Samsung Galaxy S23 (Android 14)")

**No automatic data collection or telemetry**

---

## Android Manifest Summary

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Camera access for document scanning (REQUIRED) -->
    <uses-permission android:name="android.permission.CAMERA"/>
    
    <!-- Photo library access for gallery import (OPTIONAL) -->
    <!-- Android 12 and below -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" 
                     android:maxSdkVersion="32"/>
    
    <!-- Android 13+ -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    
    <!-- Internet access for feedback API (OPTIONAL, auto-granted) -->
    <!-- Declared automatically, no explicit permission needed -->
    
    <application ...>
        ...
    </application>
</manifest>
```

---

## Testing Permissions

### How to Test Permission Flows:

1. **First Launch Test:**
   - Install app fresh
   - Tap "Start Scanning"
   - Verify educational dialog appears
   - Grant permission
   - Verify scanner opens

2. **Denied Permission Test:**
   - Deny permission when asked
   - Tap "Start Scanning" again
   - Verify educational dialog appears again
   - Grant permission
   - Verify scanner opens

3. **Permanently Denied Test:**
   - Go to Settings → Apps → ZeScan → Permissions
   - Deny camera permission
   - In app, tap "Start Scanning"
   - Verify "Open Settings" dialog appears
   - Tap "Open Settings"
   - Verify system settings open

4. **Gallery Import Test:**
   - Tap "Import from Gallery"
   - Verify educational dialog for photos
   - Grant permission
   - Verify gallery/ML Kit opens

### Reset Permissions:
```bash
# Android
adb shell pm reset-permissions com.zeppelinlabs.digital.zescan

# Or manually:
Settings → Apps → ZeScan → Permissions → Reset
```

---

## Future Considerations

### Potential Future Permissions:

1. **WRITE_EXTERNAL_STORAGE** (if needed)
   - To export PDFs to Downloads folder
   - Android 10+ uses scoped storage instead

2. **NOTIFICATION** (Android 13+)
   - If we add export progress notifications
   - Or scanning completion alerts

3. **Location** (if needed)
   - For adding location tags to scanned documents
   - Optional feature

**Note:** Any new permissions must:
- Have clear educational dialogs
- Be optional (gracefully degrade if denied)
- Follow principle of least privilege
- Be documented here

---

## Contact & Support

For questions about permissions or privacy:
- **Email:** info.adnansultan@gmail.com
- **Website:** https://zescan.zeppelinlabs.digital
- **Privacy Policy:** https://zescan.zeppelinlabs.digital/privacy

---

**Last Updated:** June 24, 2026  
**App Version:** 1.0.0  
**Document Version:** 1.0
