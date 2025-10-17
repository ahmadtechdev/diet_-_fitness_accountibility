import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/models/food_entry.dart';
import '../../data/models/weekly_summary.dart';
import '../../data/models/fine_settings.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/colors.dart';
import 'accountability_controller.dart';
import 'settings_controller.dart';

class FoodTrackerController extends GetxController {
  // Observable lists
  final RxList<FoodEntry> _foodEntries = <FoodEntry>[].obs;
  final RxList<WeeklySummary> _weeklySummaries = <WeeklySummary>[].obs;
  
  // Observable state
  final RxBool _isLoading = false.obs;
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final RxString _selectedWeek = ''.obs;
  
  // Getters
  List<FoodEntry> get foodEntries => _foodEntries;
  List<WeeklySummary> get weeklySummaries => _weeklySummaries;
  bool get isLoading => _isLoading.value;
  DateTime get selectedDate => _selectedDate.value;
  String get selectedWeek => _selectedWeek.value;
  
  // Today's entries
  List<FoodEntry> get todayEntries {
    final today = DateTime.now();
    return _foodEntries.where((entry) => 
      entry.date.year == today.year &&
      entry.date.month == today.month &&
      entry.date.day == today.day
    ).toList();
  }
  
  // Current week entries
  List<FoodEntry> get currentWeekEntries {
    final currentWeek = _getWeekNumber(DateTime.now());
    return _foodEntries.where((entry) => entry.weekNumber == currentWeek).toList();
  }
  
  // Statistics
  int get totalCleanDays {
    return _foodEntries.where((entry) => entry.status == AppConstants.cleanDay).length;
  }
  
  int get totalJunkDays {
    return _foodEntries.where((entry) => entry.status == AppConstants.junkFine).length;
  }
  
  
  ExerciseFine get totalFines {
    return _foodEntries.fold(
      const ExerciseFine(jumpingRopes: 0, squats: 0, jumpingJacks: 0, highKnees: 0, pushups: 0),
      (total, entry) => ExerciseFine(
        jumpingRopes: total.jumpingRopes + entry.fine.jumpingRopes,
        squats: total.squats + entry.fine.squats,
        jumpingJacks: total.jumpingJacks + entry.fine.jumpingJacks,
        highKnees: total.highKnees + entry.fine.highKnees,
        pushups: total.pushups + entry.fine.pushups,
      ),
    );
  }
  
  double get overallCleanPercentage {
    if (_foodEntries.isEmpty) return 0.0;
    return (totalCleanDays / _foodEntries.length) * 100;
  }
  
  String get overallAchievementLevel {
    if (overallCleanPercentage >= 90) return 'excellent';
    if (overallCleanPercentage >= 70) return 'good';
    return 'needs_improvement';
  }
  
  String get overallAchievementMessage {
    return AppConstants.achievementMessages[overallAchievementLevel]!;
  }
  
  @override
  void onInit() {
    super.onInit();
    _loadData();
  }
  
  // Load data from SharedPreferences
  Future<void> _loadData() async {
    _isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load food entries
      final entriesJson = prefs.getString(AppConstants.foodEntriesKey);
      if (entriesJson != null) {
        final List<dynamic> entriesList = json.decode(entriesJson);
        _foodEntries.value = entriesList
            .map((json) => FoodEntry.fromJson(json))
            .toList();
      }
      
      // Load weekly summaries
      final summariesJson = prefs.getString(AppConstants.weeklySummariesKey);
      if (summariesJson != null) {
        final List<dynamic> summariesList = json.decode(summariesJson);
        _weeklySummaries.value = summariesList
            .map((json) => WeeklySummary.fromJson(json))
            .toList();
      }
      
      // Generate weekly summaries if not exists
      if (_weeklySummaries.isEmpty) {
        _generateWeeklySummaries();
      }
      
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save food entries
      final entriesJson = json.encode(_foodEntries.map((e) => e.toJson()).toList());
      await prefs.setString(AppConstants.foodEntriesKey, entriesJson);
      
      // Save weekly summaries
      final summariesJson = json.encode(_weeklySummaries.map((e) => e.toJson()).toList());
      await prefs.setString(AppConstants.weeklySummariesKey, summariesJson);
      
    } catch (e) {
      print('Error saving data: $e');
    }
  }
  
  // Add new food entry
  Future<void> addFoodEntry({
    required DateTime date,
    required String whoAte,
    required String foodType,
    required String foodName,
    required double quantity,
    String notes = '',
  }) async {
    // Get fine settings for this food type
    FineSettings? fineSettings;
    try {
      final settingsController = Get.find<SettingsController>();
      fineSettings = settingsController.fineSettings
          .where((setting) => setting.foodType == foodType)
          .firstOrNull;
    } catch (e) {
      print('Settings controller not found: $e');
    }
    
    final entry = FoodEntry.create(
      date: date,
      whoAte: whoAte,
      foodType: foodType,
      foodName: foodName,
      quantity: quantity,
      notes: notes,
      fineSettings: fineSettings,
      existingEntries: _foodEntries, // Pass existing entries to check weekly limits
    );
    
    _foodEntries.add(entry);
    _generateWeeklySummaries();
    await _saveData();
    
    // Create accountability entries for this food entry
    try {
      final accountabilityController = Get.find<AccountabilityController>();
      await accountabilityController.createAccountabilityEntriesFromFoodEntry(entry);
    } catch (e) {
      print('Accountability controller not found: $e');
    }
    
    // Show success message
    Get.snackbar(
      'Entry Added! 💕',
      '${entry.foodTypeEmoji} $foodName logged successfully!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: entry.status == AppConstants.cleanDay 
          ? AppColors.cleanDayGreen 
          : AppColors.junkFoodRed,
      colorText: AppColors.textOnPrimary,
    );
  }
  
  // Update food entry
  Future<void> updateFoodEntry(FoodEntry entry) async {
    final index = _foodEntries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _foodEntries[index] = entry;
      _generateWeeklySummaries();
      await _saveData();
    }
  }
  
  // Delete food entry
  Future<void> deleteFoodEntry(String entryId) async {
    _foodEntries.removeWhere((entry) => entry.id == entryId);
    _generateWeeklySummaries();
    await _saveData();
    
    Get.snackbar(
      'Entry Deleted',
      'Food entry removed successfully',
      snackPosition: SnackPosition.TOP,
    );
  }
  
  // Generate weekly summaries
  void _generateWeeklySummaries() {
    if (_foodEntries.isEmpty) {
      _weeklySummaries.clear();
      return;
    }
    
    final weeks = _foodEntries.map((e) => e.weekNumber).toSet().toList()..sort();
    _weeklySummaries.value = weeks.map((week) => 
      WeeklySummary.fromFoodEntries(_foodEntries, week)
    ).toList();
  }
  
  // Get entries for specific date
  List<FoodEntry> getEntriesForDate(DateTime date) {
    return _foodEntries.where((entry) => 
      entry.date.year == date.year &&
      entry.date.month == date.month &&
      entry.date.day == date.day
    ).toList();
  }
  
  // Get entries for specific week
  List<FoodEntry> getEntriesForWeek(int weekNumber) {
    return _foodEntries.where((entry) => entry.weekNumber == weekNumber).toList();
  }
  
  // Get weekly summary for specific week
  WeeklySummary? getWeeklySummary(int weekNumber) {
    try {
      return _weeklySummaries.firstWhere((summary) => summary.weekNumber == weekNumber);
    } catch (e) {
      return null;
    }
  }
  
  // Get current week summary
  WeeklySummary? get currentWeekSummary {
    final currentWeek = _getWeekNumber(DateTime.now());
    return getWeeklySummary(currentWeek);
  }
  
  // Update selected date
  void updateSelectedDate(DateTime date) {
    _selectedDate.value = date;
  }
  
  // Update selected week
  void updateSelectedWeek(String week) {
    _selectedWeek.value = week;
  }
  
  // Get random motivational message
  String getRandomMotivationalMessage() {
    final messages = AppConstants.motivationalMessages;
    return messages[DateTime.now().millisecondsSinceEpoch % messages.length];
  }
  
  // Get random fine encouragement message
  String getRandomFineEncouragementMessage() {
    final messages = AppConstants.fineEncouragementMessages;
    return messages[DateTime.now().millisecondsSinceEpoch % messages.length];
  }
  
  // Helper method to get week number
  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).floor() + 1;
  }
  
  // Sync with accountability controller
  void _syncWithAccountability() {
    // This method is no longer needed as accountability entries are created directly
    // when food entries are added via createAccountabilityEntriesFromFoodEntry
    print('ℹ️ _syncWithAccountability called - this is now handled directly in addFoodEntry');
  }
  
  // Check weekly limits for a person
  Map<String, dynamic> checkWeeklyLimits(String whoAte, String foodType) {
    final currentWeek = _getWeekNumber(DateTime.now());
    final weekEntries = _foodEntries.where((entry) => 
      entry.weekNumber == currentWeek && 
      entry.whoAte == whoAte && 
      entry.foodType == foodType
    ).toList();
    
    final totalQuantity = weekEntries.fold(0.0, (sum, entry) => sum + entry.quantity);
    
    // Get settings for this food type
    FineSettings? fineSettings;
    try {
      final settingsController = Get.find<SettingsController>();
      fineSettings = settingsController.fineSettings
          .where((setting) => setting.foodType == foodType)
          .firstOrNull;
    } catch (e) {
      print('Settings controller not found: $e');
    }
    
    int weeklyLimit = 1; // Default limit
    if (fineSettings != null) {
      weeklyLimit = whoAte == AppConstants.him 
          ? fineSettings.distributionRules.himWeeklyJunkMealLimit
          : fineSettings.distributionRules.herWeeklyJunkMealLimit;
    }
    
    return {
      'current': totalQuantity,
      'limit': weeklyLimit,
      'remaining': weeklyLimit - totalQuantity,
      'exceeded': totalQuantity >= weeklyLimit,
      'entries': weekEntries,
    };
  }
  
  // Get weekly summary for a person
  Map<String, dynamic> getWeeklySummaryForPerson(String whoAte) {
    final currentWeek = _getWeekNumber(DateTime.now());
    final weekEntries = _foodEntries.where((entry) => 
      entry.weekNumber == currentWeek && 
      (entry.whoAte == whoAte || entry.whoAte == AppConstants.both)
    ).toList();
    
    final cleanEntries = weekEntries.where((e) => e.foodType == AppConstants.clean).length;
    final junkEntries = weekEntries.where((e) => e.foodType != AppConstants.clean).length;
    final totalFines = weekEntries.fold(0, (sum, entry) => sum + entry.fine.totalExercises);
    
    return {
      'cleanDays': cleanEntries,
      'junkDays': junkEntries,
      'totalFines': totalFines,
      'entries': weekEntries,
      'isJunkFree': junkEntries == 0,
    };
  }
  
  // Clear all data (for testing)
  Future<void> clearAllData() async {
    _foodEntries.clear();
    _weeklySummaries.clear();
    await _saveData();
    Get.snackbar(
      'Data Cleared',
      'All entries have been removed',
      snackPosition: SnackPosition.TOP,
    );
  }
}
