# 💕 Love & Fitness Tracker

A beautiful and romantic Flutter app for couples to track their diet and fitness journey together! Turn "junk food fines" into exercise challenges and stay accountable as a team.

## ✨ Features

### 🍽️ Food Tracking
- **Daily Food Logging**: Track what you both eat with beautiful, intuitive interface
- **Food Categories**: Major Junk, Cold Drinks, Snacks, Desi Outside Food, Desserts, and Clean meals
- **Automatic Fine Calculation**: Based on your custom fine structure
- **Shared Meals**: When both eat together, fines are split in half

### 💪 Exercise Fines System
- **Jumping Ropes**: 100 reps for major junk food
- **Squats**: 50 reps for major junk food  
- **Jumping Jacks**: 50 reps for major junk food
- **High Knees**: 40 reps for cold drinks
- **Pushups**: 20 reps for major junk food

### 📊 Analytics & Insights
- **Beautiful Charts**: Pie charts, bar charts, and line graphs
- **Weekly Progress**: Track your clean days and achievements
- **Food Type Distribution**: See what you eat most
- **Exercise Breakdown**: Visualize your fitness journey
- **Achievement Levels**: 
  - 💯 90%+ = Fit Couple
  - 🌟 70-89% = Almost Perfect  
  - 💪 Below 70% = Needs Love + Lunges

### 💕 Romantic Design
- **Beautiful UI**: Modern, elegant design with romantic pink and purple theme
- **Smooth Animations**: Heart animations, pulse effects, and smooth transitions
- **Motivational Messages**: Daily encouragement and achievement celebrations
- **Couple-Focused**: Designed specifically for couples to enjoy together

## 🏗️ Architecture

### Clean Architecture with GetX
```
lib/
├── app/
│   ├── routes/          # App routing
│   ├── bindings/        # Dependency injection
│   └── modules/         # Feature modules
├── core/
│   ├── constants/       # App constants
│   ├── utils/          # Colors, themes, utilities
│   └── services/       # Core services
├── data/
│   ├── models/         # Data models
│   └── repositories/   # Data repositories
└── presentation/
    ├── controllers/    # GetX controllers
    ├── views/         # UI screens
    └── widgets/       # Reusable widgets
```

### State Management
- **GetX**: Reactive state management
- **Observable Lists**: Real-time UI updates
- **Local Storage**: SharedPreferences for data persistence

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd couple_diet_fitness
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screenshots

### Home Screen
- Beautiful gradient background
- Daily motivation banner
- Quick stats cards
- Today's entries preview
- Weekly progress overview

### Daily Log
- Date selector
- Food entry form with beautiful animations
- Real-time fine calculation
- Entry management (edit/delete)

### Analytics Dashboard
- Clean days trend chart
- Food type distribution pie chart
- Exercise breakdown bar chart
- Weekly trends
- Overall achievement card

### Weekly Summary
- Current week overview
- Individual progress (Ahmad & Her)
- Combined exercise fines
- Weekly history
- Achievement levels

## 🎨 Design System

### Colors
- **Primary**: Romantic Pink (#E91E63) & Purple (#9C27B0)
- **Success**: Clean Day Green (#4CAF50)
- **Warning**: Cheat Meal Orange (#FF9800)
- **Error**: Junk Food Red (#F44336)

### Typography
- **Display**: Bold, large headings
- **Body**: Clean, readable text
- **Labels**: Medium weight for UI elements

### Components
- **Romantic Cards**: Elevated cards with shadows
- **Gradient Buttons**: Beautiful gradient backgrounds
- **Animated Hearts**: Pulse and scale animations
- **Progress Indicators**: Linear and circular progress

## 🔧 Customization

### Fine Structure
Edit `lib/core/constants/app_constants.dart` to modify the fine structure:

```dart
static const Map<String, Map<String, int>> fineStructure = {
  majorJunk: {
    jumpingRopes: 100,
    squats: 50,
    jumpingJacks: 50,
    highKnees: 0,
    pushups: 20,
  },
  // ... other food types
};
```

### Colors & Themes
Modify `lib/core/utils/colors.dart` and `lib/core/utils/themes.dart` to customize the app's appearance.

## 📦 Dependencies

- **get**: ^4.6.6 - State management
- **fl_chart**: ^0.68.0 - Beautiful charts
- **intl**: ^0.19.0 - Date formatting
- **shared_preferences**: ^2.2.2 - Local storage
- **equatable**: ^2.0.5 - Value equality

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 💝 Made with Love

This app was created with love for couples who want to stay healthy and accountable together. Every feature is designed to make your fitness journey more enjoyable and romantic!

---

**Happy Tracking! 💕💪**
