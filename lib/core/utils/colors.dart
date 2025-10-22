import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Lavender Dreams Theme (Elegant & Peaceful)
  static const Color primaryPink = Color(0xFFC5A3D9); // Soft Lavender
  static const Color primaryPurple = Color(0xFFB699C9); // Deeper Lavender
  static const Color primaryLight = Color(0xFFE5D9F2); // Very Light Lavender
  static const Color primaryDark = Color(0xFF9B7EB5); // Muted Purple

  // Secondary Colors - Soft & Elegant
  static const Color secondaryBlue = Color(0xFFA4C4D4); // Dusty Blue
  static const Color secondaryTeal = Color(0xFF95B8C4); // Soft Teal
  static const Color secondaryLight = Color(0xFFE8F2F7); // Very Light Blue

  // Status Colors - Soft & Muted
  static const Color successGreen = Color(0xFFB8D4C8); // Soft Eucalyptus
  static const Color warningOrange = Color(0xFFF5C59A); // Soft Apricot
  static const Color errorRed = Color(0xFFD9A5A5); // Dusty Rose
  static const Color infoBlue = Color(0xFFA4C4D4); // Dusty Blue

  // Clean Day Colors
  static const Color cleanDayGreen = Color(0xFFB8D4C8); // Soft Eucalyptus
  static const Color cleanDayLight = Color(0xFFE8F5F0); // Very Light Green

  // Cheat Meal Colors
  static const Color cheatMealOrange = Color(0xFFF5C59A); // Soft Apricot
  static const Color cheatMealLight = Color(0xFFFFF5E8); // Cream Apricot

  // Junk Food Colors
  static const Color junkFoodRed = Color(0xFFD9A5A5); // Dusty Rose
  static const Color junkFoodLight = Color(0xFFFFF0F0); // Very Light Rose

  // Background Colors
  static const Color background = Color(0xFFF8F6F9); // Off-White Lavender
  static const Color backgroundLight = Color(0xFFF8F6F9); // Off-White Lavender
  static const Color backgroundDark = Color(0xFF2A2433); // Dark Purple-Grey
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceDark = Color(0xFF3A3344); // Deep Purple-Grey
  static const Color border = Color(0xFFE5DFF2); // Soft Lavender Border

  // Text Colors
  static const Color textPrimary = Color(0xFF4A4458); // Dark Purple-Grey
  static const Color textSecondary = Color(0xFF8B7E9B); // Muted Purple
  static const Color textLight = Color(0xFFC4B8D4); // Light Purple-Grey
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC5A3D9), Color(0xFFA4C4D4)], // Lavender to Dusty Blue
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFA4C4D4), Color(0xFF95B8C4)], // Dusty Blue to Soft Teal
  );

  static const LinearGradient romanticGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC5A3D9), Color(0xFFB699C9), Color(0xFFA4C4D4)], // Lavender Dream
  );

  // Exercise Type Colors - Soft Pastels
  static const Color jumpingRopes = Color(0xFFB8D4C8); // Soft Eucalyptus
  static const Color squats = Color(0xFFA4C4D4); // Dusty Blue
  static const Color jumpingJacks = Color(0xFFF5C59A); // Soft Apricot
  static const Color highKnees = Color(0xFFC5A3D9); // Soft Lavender
  static const Color pushups = Color(0xFFD9A5A5); // Dusty Rose

  // Food Type Colors - Soft & Muted
  static const Color majorJunk = Color(0xFFD9A5A5); // Dusty Rose
  static const Color coldDrink = Color(0xFFA4C4D4); // Dusty Blue
  static const Color snacks = Color(0xFFF5C59A); // Soft Apricot
  static const Color desiOutside = Color(0xFFB8A89B); // Warm Taupe
  static const Color dessert = Color(0xFFF5D4D8); // Blush Pink
  static const Color clean = Color(0xFFB8D4C8); // Soft Eucalyptus

  // Shadow Colors - Very Subtle
  static const Color shadowLight = Color(0x0A000000); // 4% opacity
  static const Color shadowMedium = Color(0x14000000); // 8% opacity
  static const Color shadowDark = Color(0x1F000000); // 12% opacity
}

class AppGradients {
  static const LinearGradient romantic = LinearGradient(
    colors: [Color(0xFFC5A3D9), Color(0xFFF5D4D8)], // Lavender to Blush
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient success = LinearGradient(
    colors: [Color(0xFFB8D4C8), Color(0xFFA8C69F)], // Soft Eucalyptus
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warning = LinearGradient(
    colors: [Color(0xFFF5C59A), Color(0xFFFFD4A8)], // Soft Apricot
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient error = LinearGradient(
    colors: [Color(0xFFD9A5A5), Color(0xFFE8B8B8)], // Dusty Rose
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}