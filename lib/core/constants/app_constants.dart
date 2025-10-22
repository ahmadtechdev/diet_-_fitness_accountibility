class AppConstants {
  // App Information
  static const String appName = "FitTogether";
  static const String appTagline = "Stronger hearts, healthier lives — together.";
  static const String appVersion = "1.0.0";
  
  // Food Types
  static const String majorJunk = "Major Junk";
  static const String coldDrink = "Cold Drink";
  static const String snacks = "Snacks";
  static const String desiOutside = "Desi Outside";
  static const String dessert = "Dessert";
  static const String clean = "Clean";
  
  // Person Types
  static const String him = "Him";
  static const String her = "Her";
  static const String both = "Both";
  
  // Legacy support
  static const String ahmad = "Him"; // For backward compatibility
  
  // Exercise Types
  static const String jumpingRopes = "Jumping Ropes";
  static const String squats = "Squats";
  static const String jumpingJacks = "Jumping Jacks";
  static const String highKnees = "High Knees";
  static const String pushups = "Pushups";
  
  // Status Types
  static const String cleanDay = "Clean Day";
  static const String junkFine = "Junk / Fine";
  static const String cheatMeal = "Cheat Meal";

  // Food Type Emojis
  static const Map<String, String> foodTypeEmojis = {
    majorJunk: "🍕",
    coldDrink: "🥤",
    snacks: "🍫",
    desiOutside: "🥘",
    dessert: "🍦",
    clean: "💚",
  };
  
  // Status Emojis
  static const Map<String, String> statusEmojis = {
    cleanDay: "💚",
    junkFine: "🔴",
  };
  
  // Exercise Emojis
  static const Map<String, String> exerciseEmojis = {
    jumpingRopes: "🔄",
    squats: "🦵",
    jumpingJacks: "🤸",
    highKnees: "🏃",
    pushups: "💪",
  };
  
  // Fine Structure - Based on your Google Sheet
  static const Map<String, Map<String, int>> fineStructure = {
    majorJunk: {
      jumpingRopes: 100,
      squats: 50,
      jumpingJacks: 50,
      highKnees: 0,
      pushups: 20,
    },
    coldDrink: {
      jumpingRopes: 0,
      squats: 0,
      jumpingJacks: 40,
      highKnees: 40,
      pushups: 0,
    },
    snacks: {
      jumpingRopes: 60,
      squats: 0,
      jumpingJacks: 0,
      highKnees: 0,
      pushups: 20,
    },
    desiOutside: {
      jumpingRopes: 100,
      squats: 40,
      jumpingJacks: 0,
      highKnees: 0,
      pushups: 30,
    },
    dessert: {
      jumpingRopes: 0,
      squats: 0,
      jumpingJacks: 0,
      highKnees: 50,
      pushups: 0,
    },
    clean: {
      jumpingRopes: 0,
      squats: 0,
      jumpingJacks: 0,
      highKnees: 0,
      pushups: 0,
    },
  };
  
  // Motivational Messages
  static const List<String> motivationalMessages = [
    "You're doing amazing together! 💕",
    "Every clean day is a victory! 🏆",
    "Love makes everything better! ❤️",
    "You're stronger together! 💪",
    "Keep up the great work! 🌟",
    "Your dedication inspires me! ✨",
    "Together you can achieve anything! 🚀",
    "Every step counts! 👫",
    "You're building healthy habits! 🌱",
    "Love and fitness go hand in hand! 💖",
  ];
  
  // Encouragement Messages for Fines
  static const List<String> fineEncouragementMessages = [
    "Time to burn those calories! 🔥",
    "Let's turn this into strength! 💪",
    "Exercise is love for your body! ❤️",
    "You've got this! 💪",
    "Every rep counts! 🏋️",
    "Stronger together! 👫",
    "Let's make it fun! 🎉",
    "Your future self will thank you! 🙏",
    "Turn this into a positive! ✨",
    "You're building discipline! 🌟",
  ];
  
  // Achievement Thresholds
  static const int excellentCleanPercentage = 90;
  static const int goodCleanPercentage = 70;
  static const int needsImprovementCleanPercentage = 50;
  
  // Achievement Messages
  static const Map<String, String> achievementMessages = {
    "excellent": "Fit Couple! You're amazing! 💯",
    "good": "Almost Perfect! Keep going! 🌟",
    "needs_improvement": "Needs Love + Lunges! 😆",
  };
  
  // Storage Keys
  static const String foodEntriesKey = "food_entries";
  static const String weeklySummariesKey = "weekly_summaries";
  static const String userPreferencesKey = "user_preferences";
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double smallRadius = 8.0;
}
