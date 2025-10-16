import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/utils/themes.dart';
import 'app/routes/app_routes.dart';
import 'app/bindings/app_bindings.dart';

void main() {
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
