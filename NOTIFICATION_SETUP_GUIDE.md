# 🔔 Firebase Notifications Setup Guide

## Overview

Your app now has Firebase Cloud Messaging (FCM) notifications! When one partner adds a junk food entry, the other partner gets notified with exercise details.

## How It Works - Complete Explanation

### Step 1: Understanding FCM Architecture

```
Your Phone (Partner 1)                      Your Partner's Phone (Partner 2)
      ↓                                              ↓
App adds junk food entry                    Notification arrives
      ↓                                              ↓
Sends notification request to              System shows notification
Firebase Cloud Functions                    (even if app is closed)
      ↓                                              ↓
Firebase forwards to FCM                    User taps notification
      ↓                                              ↓
FCM finds partner's device token            App opens to show details
      ↓                                              ↓
FCM sends notification to partner           Accountability page opens
```

### Step 2: FCM Token (The Key Concept)

Every device gets a **unique FCM token** (like a phone number for notifications).

Example token: `eR9zX8mP...verylongstring`

**How we use it:**
1. When app starts, device gets a token
2. We save this token to Firestore under the user's ID
3. When sending notification, we look up partner's token
4. We tell FCM: "Send notification to this token"

### Step 3: The Three States of Your App

FCM handles notifications differently based on app state:

```
State 1: TERMINATED (App Closed)
  → Notification comes from system
  → User sees notification badge
  → When user taps, app opens
  → Handler: Firebase console automatically handles

State 2: BACKGROUND (App Open but Minimized)
  → FirebaseMessaging.onBackgroundMessage() is called
  → System shows notification
  → User taps to bring app to foreground
  → Handler: firebaseMessagingBackgroundHandler in main.dart

State 3: FOREGROUND (App Active)
  → FCM can't show notification directly
  → onMessage callback is triggered
  → We convert to local notification
  → Handler: _handleForegroundMessage in NotificationService
```

### Step 4: How We Send Notifications

**Current Implementation:**
We store notification requests in Firestore and use Cloud Functions to send them.

**The Flow:**
1. Partner 1 adds junk food entry
2. FoodTrackerController calls `notifyPartnerAboutJunkFood()`
3. Creates notification document in Firestore
4. Cloud Function (you'll create this) reads the document
5. Cloud Function sends actual FCM notification
6. Partner 2 receives notification

### Step 5: Android Configuration

Firebase needs some files configured for Android:

#### A. google-services.json
✅ Already exists in `android/app/google-services.json`

#### B. AndroidManifest.xml
Add these permissions in `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Add these INSIDE <manifest> tag -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<!-- Add these INSIDE <application> tag -->
<meta-data
    android:name="com.google.firebase.messaging.default_notification_icon"
    android:resource="@mipmap/ic_launcher" />
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="high_importance_channel" />
```

#### C. Application.kt
Create `android/app/src/main/kotlin/com/example/couple_diet_fitness/MainActivity.kt`:

```kotlin
package com.example.couple_diet_fitness

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
```

### Step 6: Cloud Functions Setup (To Actually Send Notifications)

You need to create a Cloud Function that reads from Firestore and sends FCM notifications.

#### Option A: Use Firebase Console (Easier)

1. Go to Firebase Console → Functions
2. Click "Create Function"
3. Use this code:

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.firestore
  .document('couples/{coupleId}/notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const data = snap.data();
    
    const message = {
      notification: {
        title: data.notification.title,
        body: data.notification.body,
      },
      data: data.data || {},
      token: data.to,
    };

    try {
      await admin.messaging().send(message);
      console.log('Notification sent successfully');
    } catch (error) {
      console.error('Error sending notification:', error);
    }
  });
```

#### Option B: Local Setup (More Control)

1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login: `firebase login`
3. Init: `firebase init functions`
4. Deploy: `firebase deploy --only functions`

### Step 7: Testing Your Notifications

**Setup:**
1. Install app on two phones (yours and partner's)
2. In main.dart, set one phone to `'him'` and other to `'her'`

**Test:**
1. Partner 1 (Him): Add a junk food entry
2. Partner 2 (Her): Should receive notification with exercise details
3. Check logs: Look for "Notification sent to partner"

**Troubleshooting:**
- Check Firebase Console → Cloud Messaging for errors
- Check device logs: `flutter logs`
- Verify tokens are saved in Firestore
- Check notification permissions on device

### Step 8: User IDs (Quick Setup)

Right now, the app uses 'him' and 'her' as user IDs.

**To make it production-ready:**

```dart
// In main.dart, replace:
await notificationService.initialize('him');

// With actual user detection:
final userId = await determineUserId(); // Your auth logic
await notificationService.initialize(userId);
```

### Step 9: What Happens When Notification Arrives

**Notification Contains:**
- Title: "💪 Exercise Time!"
- Body: "Your love ate Pizza! You have 170 exercises to do. 100 JR + 50 SQ + 20 PU"
- Data: { type: 'junk_food_entry', whoAte: 'Him', foodName: 'Pizza' }

**When Partner Taps:**
```dart
void _onNotificationTapped(NotificationResponse response) {
  // Navigate to accountability page
  Get.toNamed(AppRoutes.accountability);
}
```

### Step 10: Code Flow (Step by Step)

```
1. User adds junk food entry
   ↓
2. FoodTrackerController.addFoodEntry()
   ↓
3. Checks if status == 'Junk / Fine'
   ↓
4. NotificationService.notifyPartnerAboutJunkFood()
   ↓
5. Creates Firestore document in notifications collection
   ↓
6. Cloud Function triggers (onCreate)
   ↓
7. Cloud Function reads partner's FCM token
   ↓
8. Cloud Function calls admin.messaging().send()
   ↓
9. FCM delivers to partner's device
   ↓
10. Partner receives notification
```

## File Structure

```
lib/
├── core/
│   └── services/
│       └── notification_service.dart  ← Handles all FCM logic
├── main.dart  ← Initializes FCM and background handler
└── presentation/
    └── controllers/
        └── food_tracker_controller.dart  ← Sends notifications

Firestore Database:
couples/
  └── default_couple/
      ├── tokens/
      │   ├── him/ → { token: "..." }
      │   └── her/ → { token: "..." }
      └── notifications/  ← Created when sending notification
```

## Quick Setup Checklist

- [x] Dependencies added (firebase_messaging, flutter_local_notifications)
- [x] NotificationService created
- [x] Main.dart updated with initialization
- [x] FoodTrackerController sends notifications
- [ ] AndroidManifest.xml configured
- [ ] Cloud Function deployed
- [ ] Test on two devices

## Common Issues

**"No notification received"**
- Check if Cloud Function is deployed
- Verify FCM token is saved in Firestore
- Check notification permissions on device
- Look for errors in Firebase Console

**"Notification arrives late"**
- Cloud Functions have cold start delay
- Use Firebase Cloud Messaging API directly for instant delivery
- Consider using Firebase Admin SDK from your backend

**"Token not found"**
- Partner's app hasn't been opened yet
- Call `refreshPartnerToken()` manually
- Check Firestore for saved tokens

## Learning Resources

1. **Firebase Cloud Messaging Docs**: https://firebase.google.com/docs/cloud-messaging
2. **Flutter Notifications**: https://pub.dev/packages/firebase_messaging
3. **Cloud Functions**: https://firebase.google.com/docs/functions

## Next Steps

1. **Deploy Cloud Function** (Critical - notifications won't work without this)
2. **Configure AndroidManifest.xml** (For Android notifications)
3. **Test on two devices** (Make sure notifications work)
4. **Add more notification types** (Clean days, weekly summaries, etc.)

---

**Pro Tip:** Start with the Cloud Function deployment - that's the most important step. Once deployed, notifications will work end-to-end!

