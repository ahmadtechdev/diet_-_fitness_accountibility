import 'package:equatable/equatable.dart';
import 'food_entry.dart';
import '../../core/constants/app_constants.dart';

class WeeklySummary extends Equatable {
  final int weekNumber;
  final DateTime startDate;
  final DateTime endDate;
  final PersonSummary ahmadSummary;
  final PersonSummary herSummary;
  final int cleanDays;
  final int totalDays;
  final double cleanPercentage;
  final String achievementLevel;

  const WeeklySummary({
    required this.weekNumber,
    required this.startDate,
    required this.endDate,
    required this.ahmadSummary,
    required this.herSummary,
    required this.cleanDays,
    required this.totalDays,
    required this.cleanPercentage,
    required this.achievementLevel,
  });

  factory WeeklySummary.fromFoodEntries(List<FoodEntry> entries, int weekNumber) {
    final weekEntries = entries.where((entry) => entry.weekNumber == weekNumber).toList();
    
    if (weekEntries.isEmpty) {
      final startDate = _getStartOfWeek(weekNumber);
      return WeeklySummary(
        weekNumber: weekNumber,
        startDate: startDate,
        endDate: startDate.add(const Duration(days: 6)),
        ahmadSummary: PersonSummary.empty(AppConstants.ahmad),
        herSummary: PersonSummary.empty(AppConstants.her),
        cleanDays: 0,
        totalDays: 0,
        cleanPercentage: 0.0,
        achievementLevel: 'needs_improvement',
      );
    }

    final startDate = _getStartOfWeek(weekNumber);
    final endDate = startDate.add(const Duration(days: 6));
    
    final ahmadEntries = weekEntries.where((entry) => entry.whoAte == AppConstants.ahmad).toList();
    final herEntries = weekEntries.where((entry) => entry.whoAte == AppConstants.her).toList();
    final bothEntries = weekEntries.where((entry) => entry.whoAte == AppConstants.both).toList();
    
    final ahmadSummary = PersonSummary.fromEntries(ahmadEntries, AppConstants.ahmad);
    final herSummary = PersonSummary.fromEntries(herEntries, AppConstants.her);
    
    // Add half of "both" entries to each person
    for (final entry in bothEntries) {
      ahmadSummary.addHalfEntry(entry);
      herSummary.addHalfEntry(entry);
    }
    
    final cleanDays = weekEntries.where((entry) => entry.status == AppConstants.cleanDay).length;
    final totalDays = weekEntries.map((entry) => entry.date.day).toSet().length;
    final cleanPercentage = totalDays > 0 ? (cleanDays / totalDays) * 100 : 0.0;
    
    final achievementLevel = _getAchievementLevel(cleanPercentage);
    
    return WeeklySummary(
      weekNumber: weekNumber,
      startDate: startDate,
      endDate: endDate,
      ahmadSummary: ahmadSummary,
      herSummary: herSummary,
      cleanDays: cleanDays,
      totalDays: totalDays,
      cleanPercentage: cleanPercentage,
      achievementLevel: achievementLevel,
    );
  }

  static DateTime _getStartOfWeek(int weekNumber) {
    final year = DateTime.now().year;
    final firstDayOfYear = DateTime(year, 1, 1);
    final firstMonday = firstDayOfYear.subtract(Duration(days: firstDayOfYear.weekday - 1));
    final startOfWeek = firstMonday.add(Duration(days: (weekNumber - 1) * 7));
    return startOfWeek;
  }

  static String _getAchievementLevel(double cleanPercentage) {
    if (cleanPercentage >= 90) return 'excellent';
    if (cleanPercentage >= 70) return 'good';
    return 'needs_improvement';
  }

  ExerciseFine get combinedFine {
    return ExerciseFine(
      jumpingRopes: ahmadSummary.totalFine.jumpingRopes + herSummary.totalFine.jumpingRopes,
      squats: ahmadSummary.totalFine.squats + herSummary.totalFine.squats,
      jumpingJacks: ahmadSummary.totalFine.jumpingJacks + herSummary.totalFine.jumpingJacks,
      highKnees: ahmadSummary.totalFine.highKnees + herSummary.totalFine.highKnees,
      pushups: ahmadSummary.totalFine.pushups + herSummary.totalFine.pushups,
    );
  }

  String get achievementMessage {
    switch (achievementLevel) {
      case 'excellent':
        return AppConstants.achievementMessages['excellent']!;
      case 'good':
        return AppConstants.achievementMessages['good']!;
      default:
        return AppConstants.achievementMessages['needs_improvement']!;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'weekNumber': weekNumber,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'ahmadSummary': ahmadSummary.toJson(),
      'herSummary': herSummary.toJson(),
      'cleanDays': cleanDays,
      'totalDays': totalDays,
      'cleanPercentage': cleanPercentage,
      'achievementLevel': achievementLevel,
    };
  }

  factory WeeklySummary.fromJson(Map<String, dynamic> json) {
    return WeeklySummary(
      weekNumber: json['weekNumber'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      ahmadSummary: PersonSummary.fromJson(json['ahmadSummary'] as Map<String, dynamic>),
      herSummary: PersonSummary.fromJson(json['herSummary'] as Map<String, dynamic>),
      cleanDays: json['cleanDays'] as int,
      totalDays: json['totalDays'] as int,
      cleanPercentage: (json['cleanPercentage'] as num).toDouble(),
      achievementLevel: json['achievementLevel'] as String,
    );
  }

  @override
  List<Object?> get props => [
        weekNumber,
        startDate,
        endDate,
        ahmadSummary,
        herSummary,
        cleanDays,
        totalDays,
        cleanPercentage,
        achievementLevel,
      ];
}

class PersonSummary extends Equatable {
  final String name;
  final ExerciseFine totalFine;
  final int totalEntries;
  final int cleanEntries;
  final int junkEntries;
  final int cheatEntries;

  const PersonSummary({
    required this.name,
    required this.totalFine,
    required this.totalEntries,
    required this.cleanEntries,
    required this.junkEntries,
    required this.cheatEntries,
  });

  factory PersonSummary.empty(String name) {
    return PersonSummary(
      name: name,
      totalFine: const ExerciseFine(
        jumpingRopes: 0,
        squats: 0,
        jumpingJacks: 0,
        highKnees: 0,
        pushups: 0,
      ),
      totalEntries: 0,
      cleanEntries: 0,
      junkEntries: 0,
      cheatEntries: 0,
    );
  }

  factory PersonSummary.fromEntries(List<FoodEntry> entries, String name) {
    ExerciseFine totalFine = const ExerciseFine(
      jumpingRopes: 0,
      squats: 0,
      jumpingJacks: 0,
      highKnees: 0,
      pushups: 0,
    );

    int cleanEntries = 0;
    int junkEntries = 0;
    int cheatEntries = 0;

    for (final entry in entries) {
      totalFine = ExerciseFine(
        jumpingRopes: totalFine.jumpingRopes + entry.fine.jumpingRopes,
        squats: totalFine.squats + entry.fine.squats,
        jumpingJacks: totalFine.jumpingJacks + entry.fine.jumpingJacks,
        highKnees: totalFine.highKnees + entry.fine.highKnees,
        pushups: totalFine.pushups + entry.fine.pushups,
      );

      switch (entry.status) {
        case AppConstants.cleanDay:
          cleanEntries++;
          break;
        case AppConstants.junkFine:
          junkEntries++;
          break;
      }
    }

    return PersonSummary(
      name: name,
      totalFine: totalFine,
      totalEntries: entries.length,
      cleanEntries: cleanEntries,
      junkEntries: junkEntries,
      cheatEntries: cheatEntries,
    );
  }

  void addHalfEntry(FoodEntry entry) {
    // This method is used to add half of a "both" entry
    // In a real implementation, you'd need to modify the totalFine
    // For now, we'll handle this in the WeeklySummary.fromFoodEntries method
  }

  double get cleanPercentage {
    return totalEntries > 0 ? (cleanEntries / totalEntries) * 100 : 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'totalFine': totalFine.toJson(),
      'totalEntries': totalEntries,
      'cleanEntries': cleanEntries,
      'junkEntries': junkEntries,
      'cheatEntries': cheatEntries,
    };
  }

  factory PersonSummary.fromJson(Map<String, dynamic> json) {
    return PersonSummary(
      name: json['name'] as String,
      totalFine: ExerciseFine.fromJson(json['totalFine'] as Map<String, dynamic>),
      totalEntries: json['totalEntries'] as int,
      cleanEntries: json['cleanEntries'] as int,
      junkEntries: json['junkEntries'] as int,
      cheatEntries: json['cheatEntries'] as int,
    );
  }

  @override
  List<Object?> get props => [
        name,
        totalFine,
        totalEntries,
        cleanEntries,
        junkEntries,
        cheatEntries,
      ];
}
