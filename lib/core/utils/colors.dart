import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Romantic Pink & Purple Theme
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color primaryPurple = Color(0xFF9C27B0);
  static const Color primaryLight = Color(0xFFF8BBD9);
  static const Color primaryDark = Color(0xFFAD1457);
  
  // Secondary Colors - Soft & Elegant
  static const Color secondaryBlue = Color(0xFF2196F3);
  static const Color secondaryTeal = Color(0xFF00BCD4);
  static const Color secondaryLight = Color(0xFFE3F2FD);
  
  // Status Colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);
  static const Color infoBlue = Color(0xFF2196F3);
  
  // Clean Day Colors
  static const Color cleanDayGreen = Color(0xFF4CAF50);
  static const Color cleanDayLight = Color(0xFFE8F5E8);
  
  // Cheat Meal Colors
  static const Color cheatMealOrange = Color(0xFFFF9800);
  static const Color cheatMealLight = Color(0xFFFFF3E0);
  
  // Junk Food Colors
  static const Color junkFoodRed = Color(0xFFF44336);
  static const Color junkFoodLight = Color(0xFFFFEBEE);
  
  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color border = Color(0xFFE0E0E0);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPink, primaryPurple],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryBlue, secondaryTeal],
  );
  
  static const LinearGradient romanticGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPink, primaryPurple, secondaryBlue],
  );
  
  // Exercise Type Colors
  static const Color jumpingRopes = Color(0xFF4CAF50);
  static const Color squats = Color(0xFF2196F3);
  static const Color jumpingJacks = Color(0xFFFF9800);
  static const Color highKnees = Color(0xFF9C27B0);
  static const Color pushups = Color(0xFFF44336);
  
  // Food Type Colors
  static const Color majorJunk = Color(0xFFF44336);
  static const Color coldDrink = Color(0xFF2196F3);
  static const Color snacks = Color(0xFFFF9800);
  static const Color desiOutside = Color(0xFF795548);
  static const Color dessert = Color(0xFFE91E63);
  static const Color clean = Color(0xFF4CAF50);
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
}

class AppGradients {
  static const LinearGradient romantic = LinearGradient(
    colors: [AppColors.primaryPink, AppColors.primaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient success = LinearGradient(
    colors: [AppColors.cleanDayGreen, Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient warning = LinearGradient(
    colors: [AppColors.cheatMealOrange, Color(0xFFFFB74D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient error = LinearGradient(
    colors: [AppColors.junkFoodRed, Color(0xFFEF5350)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
