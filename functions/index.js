const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
admin.initializeApp();

/**
 * Cloud Function that triggers when a new notification document is created
 * in the couples/{coupleId}/notifications/{notificationId} collection
 */
exports.sendNotification = functions.firestore
  .document('couples/{coupleId}/notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    console.log('📨 Notification function triggered');
    
    const data = snap.data();
    const token = data.to;
    const coupleId = context.params.coupleId;
    const notificationId = context.params.notificationId;

    console.log(`Processing notification for couple: ${coupleId}, notification: ${notificationId}`);

    if (!token) {
      console.error('❌ No FCM token found in notification data');
      return null;
    }

    // Prepare the FCM message
    const message = {
      notification: {
        title: data.notification?.title || 'FitTogether',
        body: data.notification?.body || 'New entry added',
      },
      data: {
        ...data.data,
        notificationId: notificationId,
        coupleId: coupleId,
        type: data.data?.type || 'general',
        timestamp: new Date().toISOString(),
      },
      token: token,
      android: {
        priority: 'high',
        notification: {
          sound: 'default',
          clickAction: 'FLUTTER_NOTIFICATION_CLICK',
          channelId: 'high_importance_channel',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };

    try {
      console.log('📤 Sending FCM message...');
      const response = await admin.messaging().send(message);
      console.log('✅ Notification sent successfully:', response);
      
      // Update the notification document with success status
      await snap.ref.update({
        sent: true,
        sentAt: admin.firestore.FieldValue.serverTimestamp(),
        messageId: response,
        status: 'delivered',
      });
      
      return response;
    } catch (error) {
      console.error('❌ Error sending notification:', error);
      
      // Update the notification document with error status
      await snap.ref.update({
        sent: false,
        error: error.message,
        errorAt: admin.firestore.FieldValue.serverTimestamp(),
        status: 'failed',
      });
      
      throw error;
    }
  });

/**
 * Cloud Function to handle FCM token updates
 * Triggers when a token document is created/updated in couples/{coupleId}/tokens/{userId}
 */
exports.updateToken = functions.firestore
  .document('couples/{coupleId}/tokens/{userId}')
  .onWrite(async (change, context) => {
    const coupleId = context.params.coupleId;
    const userId = context.params.userId;
    
    console.log(`🔄 Token updated for user: ${userId} in couple: ${coupleId}`);
    
    const newData = change.after.exists ? change.after.data() : null;
    const oldData = change.before.exists ? change.before.data() : null;
    
    if (newData && newData.token) {
      console.log(`✅ New token registered for ${userId}: ${newData.token.substring(0, 20)}...`);
    }
    
    return null;
  });
