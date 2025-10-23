# 🚀 Cloud Functions Deployment Guide

## Complete Setup for Blaze Plan

Your notifications are now ready to use Cloud Functions with OAuth 2.0 HTTP v1 API!

## Architecture

```
Flutter App → Creates Firestore doc → Cloud Function triggers 
→ Admin SDK handles OAuth → Sends FCM HTTP v1 → Partner receives notification
```

## Prerequisites

✅ Firebase project with Blaze plan enabled
✅ Node.js installed
✅ Firebase CLI installed

## Step-by-Step Deployment

### Step 1: Install Firebase CLI

```bash
npm install -g firebase-tools
```

### Step 2: Login to Firebase

```bash
firebase login
```

This will open browser for authentication.

### Step 3: Navigate to Functions Folder

```bash
cd functions
```

### Step 4: Install Dependencies

```bash
npm install
```

Wait for installation to complete.

### Step 5: Deploy Cloud Functions

```bash
firebase deploy --only functions
```

This will:
- Upload your functions to Firebase
- Deploy to cloud
- Show you function URLs

**Expected output:**
```
✔  functions[sendNotification] Successful create operation.
```

### Step 6: Verify Deployment

1. Go to Firebase Console
2. Navigate to **Functions**
3. You should see `sendNotification` function
4. Status should be "Deployed"

## How It Works

### When Partner Adds Junk Food:

1. **FoodTrackerController** calls `notifyPartnerAboutJunkFood()`
2. **NotificationService** creates Firestore document in `notifications` collection
3. **Cloud Function** automatically triggers (`onCreate`)
4. **Cloud Function** reads partner's FCM token
5. **Admin SDK** handles OAuth 2.0 automatically
6. **Sends** via FCM HTTP v1 API
7. **Partner** receives notification!

## Set User IDs

In `lib/main.dart` line 33:

**Device 1 (Your phone):**
```dart
await notificationService.initialize('him');
```

**Device 2 (Partner's phone):**
```dart
await notificationService.initialize('her');
```

## Testing

1. Run app on both devices
2. Add junk food entry on Device 1
3. Device 2 should receive notification! 🎉

## Monitoring

### View Function Logs

```bash
firebase functions:log
```

### View in Firebase Console

1. Go to Firebase Console → Functions
2. Click on `sendNotification`
3. View **Logs** tab

## Files Structure

```
functions/
├── index.js          ✅ Cloud Function code
├── package.json      ✅ Dependencies
└── .gitignore        ✅ Ignore node_modules

lib/core/services/
└── notification_service.dart  ✅ Creates Firestore docs
```

## Troubleshooting

### "Functions deploy failed"

**Check:**
- Are you logged in? `firebase login`
- Do you have Blaze plan enabled?
- Check Node version: `node --version` (need 18+)

### "No notifications received"

**Check:**
- Cloud Function deployed? (check Firebase Console)
- FCM tokens saved in Firestore?
- Notification permissions granted?
- Check function logs for errors

### "Token not found"

**Solution:**
- Both partners must open app at least once
- Check Firestore: `couples/default_couple/tokens`
- Verify tokens exist for 'him' and 'her'

## Cost

**Still FREE!** You'll stay within free tier:
- 2M function invocations/month (you use ~100)
- FCM unlimited (always free)
- Firestore under limits

**Estimated monthly cost: $0.00** 💰

## Quick Commands

```bash
# Deploy functions
firebase deploy --only functions

# View logs
firebase functions:log

# Delete function (if needed)
firebase functions:delete sendNotification
```

## What's Already Done

✅ Cloud Function code (`functions/index.js`)
✅ Notification service creates Firestore docs
✅ Admin SDK handles OAuth automatically
✅ Uses FCM HTTP v1 API
✅ No deprecated Server Keys

## Next Steps

1. ✅ Upgrade to Blaze plan
2. ✅ Deploy Cloud Functions
3. ✅ Test notifications
4. ✅ Enjoy! 🎉

---

**Everything is ready! Just deploy Cloud Functions and you're done!** 🚀

