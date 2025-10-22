import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Lavender Dreams Theme (Vibrant yet Elegant)
  static const Color primaryPink = Color(0xFFAB7AC6); // Rich Lavender (more saturated)
  static const Color primaryPurple = Color(0xFF9B6FB5); // Deep Lavender
  static const Color primaryLight = Color(0xFFD4C3E5); // Light Lavender
  static const Color primaryDark = Color(0xFF7D5A96); // Dark Purple

  // Secondary Colors - Clear & Elegant
  static const Color secondaryBlue = Color(0xFF6FA8C4); // Clear Dusty Blue
  static const Color secondaryTeal = Color(0xFF5EA3B8); // Vibrant Soft Teal
  static const Color secondaryLight = Color(0xFFD4E8F0); // Light Blue

  // Status Colors - Clear & Visible
  static const Color successGreen = Color(0xFF7AB892); // Clear Eucalyptus
  static const Color warningOrange = Color(0xFFE5A86B); // Clear Apricot
  static const Color errorRed = Color(0xFFCE8585); // Clear Dusty Rose
  static const Color infoBlue = Color(0xFF6FA8C4); // Clear Dusty Blue

  // Clean Day Colors
  static const Color cleanDayGreen = Color(0xFF7AB892); // Clear Eucalyptus
  static const Color cleanDayLight = Color(0xFFE0F2E9); // Very Light Green

  // Cheat Meal Colors
  static const Color cheatMealOrange = Color(0xFFE5A86B); // Clear Apricot
  static const Color cheatMealLight = Color(0xFFFFF0DC); // Cream Apricot

  // Junk Food Colors
  static const Color junkFoodRed = Color(0xFFCE8585); // Clear Dusty Rose
  static const Color junkFoodLight = Color(0xFFFFE8E8); // Very Light Rose

  // Background Colors
  static const Color background = Color(0xFFF5F3F7); // Off-White Lavender (slightly darker)
  static const Color backgroundLight = Color(0xFFF5F3F7); // Off-White Lavender
  static const Color backgroundDark = Color(0xFF2A2433); // Dark Purple-Grey
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceDark = Color(0xFF3A3344); // Deep Purple-Grey
  static const Color border = Color(0xFFD4C3E5); // Clear Lavender Border

  // Text Colors - Higher Contrast
  static const Color textPrimary = Color(0xFF2D2438); // Very Dark Purple-Grey (better contrast)
  static const Color textSecondary = Color(0xFF6B5D7A); // Medium Purple (more visible)
  static const Color textLight = Color(0xFFA89BB5); // Light Purple-Grey
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFAB7AC6), Color(0xFF6FA8C4)], // Rich Lavender to Clear Blue
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6FA8C4), Color(0xFF5EA3B8)], // Clear Blue to Vibrant Teal
  );

  static const LinearGradient romanticGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFAB7AC6), Color(0xFF9B6FB5), Color(0xFF6FA8C4)], // Lavender Dream
  );

  // Exercise Type Colors - Clear Pastels
  static const Color jumpingRopes = Color(0xFF7AB892); // Clear Eucalyptus
  static const Color squats = Color(0xFF6FA8C4); // Clear Dusty Blue
  static const Color jumpingJacks = Color(0xFFE5A86B); // Clear Apricot
  static const Color highKnees = Color(0xFFAB7AC6); // Rich Lavender
  static const Color pushups = Color(0xFFCE8585); // Clear Dusty Rose

  // Food Type Colors - Clear & Vibrant
  static const Color majorJunk = Color(0xFFCE8585); // Clear Dusty Rose
  static const Color coldDrink = Color(0xFF6FA8C4); // Clear Dusty Blue
  static const Color snacks = Color(0xFFE5A86B); // Clear Apricot
  static const Color desiOutside = Color(0xFF9D8B7D); // Warm Taupe (more saturated)
  static const Color dessert = Color(0xFFE8B5BB); // Clear Blush Pink
  static const Color clean = Color(0xFF7AB892); // Clear Eucalyptus

  // Shadow Colors - Balanced
  static const Color shadowLight = Color(0x14000000); // 8% opacity
  static const Color shadowMedium = Color(0x1F000000); // 12% opacity
  static const Color shadowDark = Color(0x29000000); // 16% opacity
}

class AppGradients {
  static const LinearGradient romantic = LinearGradient(
    colors: [Color(0xFFAB7AC6), Color(0xFFE8B5BB)], // Rich Lavender to Clear Blush
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient success = LinearGradient(
    colors: [Color(0xFF7AB892), Color(0xFF6BAA7F)], // Clear Eucalyptus
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warning = LinearGradient(
    colors: [Color(0xFFE5A86B), Color(0xFFF5C087)], // Clear Apricot
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient error = LinearGradient(
    colors: [Color(0xFFCE8585), Color(0xFFDC9A9A)], // Clear Dusty Rose
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}