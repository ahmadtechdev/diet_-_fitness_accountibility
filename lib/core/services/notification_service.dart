import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Step 1: Understanding Firebase Cloud Messaging (FCM)
/// 
/// FCM works in 3 states:
/// 1. TERMINATED - App is closed → Handled by native code (handlers in main.dart)
/// 2. BACKGROUND - App is open but in background → onBackgroundMessage callback
/// 3. FOREGROUND - App is open and active → onMessage callback
///
/// Each device gets a unique FCM token that identifies it. We store this token
/// in Firestore so we can send notifications to specific devices.

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isInitialized = false;
  String? _currentUserId;
  String? _partnerToken;

  /// Step 2: Initialize FCM and Local Notifications
  /// 
  /// This method:
  /// 1. Requests notification permissions from the user
  /// 2. Gets the FCM token (unique device identifier)
  /// 3. Initializes local notifications for foreground notifications
  /// 4. Sets up listeners for incoming messages
  /// 5. Saves the token to Firestore
  
  Future<void> initialize(String userId) async {
    if (_isInitialized) return;
    
    _currentUserId = userId;
    
    try {
      // Request permission to send notifications
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ User granted notification permission');
      } else {
        print('❌ User declined notification permission');
        return;
      }

      // Initialize local notifications for foreground display
      await _initializeLocalNotifications();

      // Get FCM token (this identifies your device)
      String? token = await _fcm.getToken();
      if (token != null) {
        print('📱 FCM Token: $token');
        await _saveTokenToFirestore(token);
      }

      // Listen for token refresh (token can change)
      _fcm.onTokenRefresh.listen((newToken) {
        print('🔄 Token refreshed: $newToken');
        _saveTokenToFirestore(newToken);
      });

      // Listen for foreground messages (when app is open)
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Load partner's token
      await _loadPartnerToken();

      _isInitialized = true;
      print('✅ Notification service initialized');
    } catch (e) {
      print('❌ Error initializing notifications: $e');
    }
  }

  /// Step 3: Initialize Local Notifications
  /// 
  /// Local notifications are used to show notifications when the app is in FOREGROUND
  /// FCM can't show notifications directly when app is open, so we use local notifications
  
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'Important Notifications',
      description: 'Notifications for junk food entries',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Step 4: Handle Foreground Messages
  /// 
  /// When app is open and a notification arrives, FCM calls this
  /// We convert it to a local notification to show it
  
  void _handleForegroundMessage(RemoteMessage message) {
    print('📨 Foreground message received: ${message.notification?.title}');
    
    _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'New Entry',
      message.notification?.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'Important Notifications',
          channelDescription: 'Notifications for junk food entries',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  /// Step 5: Handle Notification Tap
  /// 
  /// When user taps on a notification, we can navigate to specific page
  
  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Notification tapped: ${response.payload}');
    // You can navigate to specific page here using Get.toNamed()
  }

  /// Step 6: Save Token to Firestore
  /// 
  /// Store the FCM token in Firestore so we can send notifications to this device
  /// We store it under the user's ID
  
  Future<void> _saveTokenToFirestore(String token) async {
    try {
      await _firestore
          .collection('couples')
          .doc('default_couple')
          .collection('tokens')
          .doc(_currentUserId ?? 'user1')
          .set({
        'token': token,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      print('✅ Token saved to Firestore');
    } catch (e) {
      print('❌ Error saving token: $e');
    }
  }

  /// Step 7: Load Partner's Token
  /// 
  /// Load the other person's FCM token so we can send them notifications
  
  Future<void> _loadPartnerToken() async {
    try {
      // Determine partner ID (if current user is 'him', partner is 'her' and vice versa)
      String partnerId = _currentUserId == 'him' ? 'her' : 'him';
      
      final doc = await _firestore
          .collection('couples')
          .doc('default_couple')
          .collection('tokens')
          .doc(partnerId)
          .get();

      if (doc.exists) {
        _partnerToken = doc.data()?['token'] as String?;
        print('✅ Partner token loaded: ${_partnerToken?.substring(0, 20)}...');
      } else {
        print('⚠️ Partner token not found');
      }
    } catch (e) {
      print('❌ Error loading partner token: $e');
    }
  }

  /// Step 8: Send Notification to Partner
  /// 
  /// This is the method you'll call when someone adds a junk food entry
  /// It sends a notification to the partner's device
  
  Future<void> sendNotificationToPartner({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      if (_partnerToken == null) {
        print('⚠️ Partner token not available, loading...');
        await _loadPartnerToken();
      }

      if (_partnerToken == null) {
        print('❌ Cannot send notification: Partner token not found');
        return;
      }

      // Send notification using FCM
      await _firestore.collection('couples').doc('default_couple').collection('notifications').add({
        'to': _partnerToken,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': data ?? {},
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('✅ Notification sent to partner');
    } catch (e) {
      print('❌ Error sending notification: $e');
    }
  }

  /// Step 9: Send Notification When Junk Food Entry Added
  /// 
  /// This creates a custom notification message when someone adds junk food
  
  Future<void> notifyPartnerAboutJunkFood({
    required String whoAte,
    required String foodName,
    required String exerciseCount,
    required String exerciseDetails,
  }) async {
    String title = whoAte == 'Him' ? '💪 Exercise Time!' : '💪 Exercise Time!';
    String body = whoAte == 'Him' 
        ? 'Your love ate $foodName! You have $exerciseCount exercises to do.\n$exerciseDetails'
        : 'Your love ate $foodName! You have $exerciseCount exercises to do.\n$exerciseDetails';

    await sendNotificationToPartner(
      title: title,
      body: body,
      data: {
        'type': 'junk_food_entry',
        'whoAte': whoAte,
        'foodName': foodName,
      },
    );
  }

  /// Step 10: Refresh Partner Token
  /// 
  /// Call this if partner's token might have changed
  
  Future<void> refreshPartnerToken() async {
    await _loadPartnerToken();
  }
}

/// Step 11: Background Message Handler
/// 
/// This is called when app is in BACKGROUND state
/// MUST be top-level function (not inside a class)

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📨 Background message received: ${message.notification?.title}');
  // Background messages are automatically shown by system
  // You can add additional processing here if needed
}

