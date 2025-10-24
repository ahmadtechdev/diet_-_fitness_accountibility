# 🔥 Blaze Plan Required

## Current Status: ❌ Spark Plan

Your Firebase project `energicview` is currently on the **Spark (free) plan**, but Cloud Functions require the **Blaze (pay-as-you-go) plan**.

## Error Message:
```
Your project energicview must be on the Blaze (pay-as-you-go) plan to complete this command.
```

## Solution: Upgrade to Blaze Plan

### Step 1: Visit Firebase Console
Click this link: https://console.firebase.google.com/project/energicview/usage/details

### Step 2: Upgrade to Blaze
1. Click **"Upgrade to Blaze"**
2. Add a payment method (credit card)
3. Confirm the upgrade

### Step 3: Deploy Functions
After upgrading, run:
```bash
firebase deploy --only functions
```

## Why Blaze Plan?

Cloud Functions require:
- ✅ **Cloud Build API** - For building functions
- ✅ **Artifact Registry API** - For storing function code
- ✅ **Cloud Functions API** - For running functions

These APIs are only available on Blaze plan.

## Cost Information

**Good News:** You'll likely stay within the **free tier**:

- **Cloud Functions**: 2M invocations/month (FREE)
- **FCM**: Always FREE
- **Firestore**: 50K reads, 20K writes/day (FREE)
- **Cloud Build**: 120 minutes/month (FREE)

**Estimated monthly cost: $0.00** 💰

## What Happens After Upgrade?

1. ✅ APIs will be enabled automatically
2. ✅ Functions will deploy successfully
3. ✅ Notifications will work
4. ✅ You'll stay within free limits

## Alternative: Test Without Functions

If you want to test the app without notifications:

1. **Run the app**: `flutter run`
2. **Test data sync**: Add food entries
3. **See real-time updates**: Both devices sync
4. **Add notifications later**: When ready for Blaze

## Files Ready

✅ `firebase.json` - Configuration
✅ `functions/index.js` - Cloud Function code
✅ `functions/package.json` - Dependencies
✅ All notification code integrated

---

**Next Step:** Upgrade to Blaze plan, then deploy functions! 🚀
