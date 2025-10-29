import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'core/utils/themes.dart';
import 'core/services/data_migration_service.dart';
import 'core/services/notification_service.dart';
import 'app/routes/app_routes.dart';
import 'app/bindings/app_bindings.dart';

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📨 Background message received: ${message.notification?.title}');
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  // Initialize Notification Service
  // Note: In a real app, you'd determine userId from authentication
  // For now, using 'him' as default (you'll update this when users login)
  final notificationService = NotificationService();
  
  // Check command line arguments or environment for user ID
  String userId = 'Her'; // Default
  
  // Check for dart-define first
  const String userIdFromDefine = String.fromEnvironment('USER_ID');
  if (userIdFromDefine.isNotEmpty) {
    userId = userIdFromDefine;
  }
  // Then check command line arguments
  else if (args.isNotEmpty && args[0] == 'her') {
    userId = 'Her';
  }
  
  print('🔍 Initializing notification service for user: $userId');
  await notificationService.initialize(userId);
  
  // Run data migration if needed
  try {
    final migrationService = DataMigrationService();
    final needsMigration = await migrationService.isMigrationNeeded();
    if (needsMigration) {
      print('🔄 Migrating data to Firebase...');
      await migrationService.migrateAllData();
      print('✅ Migration completed');
    }
  } catch (e) {
    print('⚠️ Migration error: $e');
  }
  
  runApp(const LoveAndFitnessApp());
}

class LoveAndFitnessApp extends StatelessWidget {
  const LoveAndFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Love & Fitness Tracker',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      initialBinding: AppBindings(),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
