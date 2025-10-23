import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/repositories/food_entries_repository.dart';
import '../../data/repositories/accountability_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/models/food_entry.dart';
import '../../data/models/accountability_entry.dart';
import '../../data/models/exercise.dart';
import '../../data/models/fine_set.dart';
import '../../data/models/fine_settings.dart';
import '../../core/constants/app_constants.dart';

class DataMigrationService {
  final FoodEntriesRepository _foodRepository = FoodEntriesRepository();
  final AccountabilityRepository _accountabilityRepository = AccountabilityRepository();
  final SettingsRepository _settingsRepository = SettingsRepository();
  
  // Check if migration is needed
  Future<bool> isMigrationNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if SharedPreferences has data
      final hasFoodEntries = prefs.containsKey(AppConstants.foodEntriesKey);
      final hasAccountabilityEntries = prefs.containsKey('accountability_entries');
      final hasSettings = prefs.containsKey('exercises') || 
                         prefs.containsKey('fine_sets') || 
                         prefs.containsKey('fine_settings');
      
      if (!hasFoodEntries && !hasAccountabilityEntries && !hasSettings) {
        return false; // No data to migrate
      }
      
      // Check if Firebase already has data
      final firebaseFoodEntries = await _foodRepository.getAllFoodEntriesOnce();
      final firebaseAccountabilityEntries = await _accountabilityRepository.getAllAccountabilityEntriesOnce();
      final firebaseSettings = await _settingsRepository.getAllSettingsOnce();
      
      // If Firebase has data, migration already done
      if (firebaseFoodEntries.isNotEmpty || 
          firebaseAccountabilityEntries.isNotEmpty || 
          firebaseSettings.isNotEmpty) {
        return false;
      }
      
      return true; // Migration needed
    } catch (e) {
      print('Error checking migration status: $e');
      return false;
    }
  }
  
  // Migrate all data from SharedPreferences to Firebase
  Future<void> migrateAllData() async {
    try {
      print('🚀 Starting data migration from SharedPreferences to Firebase...');
      
      // Migrate food entries
      await _migrateFoodEntries();
      
      // Migrate accountability entries
      await _migrateAccountabilityEntries();
      
      // Migrate settings
      await _migrateSettings();
      
      print('✅ Data migration completed successfully!');
    } catch (e) {
      print('❌ Error during data migration: $e');
      rethrow;
    }
  }
  
  // Migrate food entries
  Future<void> _migrateFoodEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = prefs.getString(AppConstants.foodEntriesKey);
      
      if (entriesJson == null) {
        print('No food entries to migrate');
        return;
      }
      
      final List<dynamic> entriesList = json.decode(entriesJson);
      final foodEntries = entriesList
          .map((json) => FoodEntry.fromJson(json))
          .toList();
      
      print('📝 Migrating ${foodEntries.length} food entries...');
      
      for (final entry in foodEntries) {
        try {
          await _foodRepository.addFoodEntry(entry);
        } catch (e) {
          print('Error migrating food entry ${entry.id}: $e');
        }
      }
      
      print('✅ Food entries migration completed');
    } catch (e) {
      print('Error migrating food entries: $e');
      rethrow;
    }
  }
  
  // Migrate accountability entries
  Future<void> _migrateAccountabilityEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = prefs.getStringList('accountability_entries') ?? [];
      
      if (entriesJson.isEmpty) {
        print('No accountability entries to migrate');
        return;
      }
      
      print('📝 Migrating ${entriesJson.length} accountability entries...');
      
      for (final entryJson in entriesJson) {
        try {
          final entry = AccountabilityEntry.fromJson(jsonDecode(entryJson));
          await _accountabilityRepository.addAccountabilityEntry(entry);
        } catch (e) {
          print('Error migrating accountability entry: $e');
        }
      }
      
      print('✅ Accountability entries migration completed');
    } catch (e) {
      print('Error migrating accountability entries: $e');
      rethrow;
    }
  }
  
  // Migrate settings
  Future<void> _migrateSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      List<Exercise> exercises = [];
      List<FineSet> fineSets = [];
      List<FineSettings> fineSettings = [];
      
      // Load exercises
      final exercisesString = prefs.getString('exercises');
      if (exercisesString != null) {
        final exercisesList = jsonDecode(exercisesString) as List;
        exercises = exercisesList
            .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      
      // Load fine sets
      final fineSetsString = prefs.getString('fine_sets');
      if (fineSetsString != null) {
        final fineSetsList = jsonDecode(fineSetsString) as List;
        fineSets = fineSetsList
            .map((fs) => FineSet.fromJson(fs as Map<String, dynamic>))
            .toList();
      }
      
      // Load fine settings
      final fineSettingsString = prefs.getString('fine_settings');
      if (fineSettingsString != null) {
        final fineSettingsList = jsonDecode(fineSettingsString) as List;
        fineSettings = fineSettingsList
            .map((fs) => FineSettings.fromJson(fs as Map<String, dynamic>))
            .toList();
      }
      
      if (exercises.isEmpty && fineSets.isEmpty && fineSettings.isEmpty) {
        print('No settings to migrate');
        return;
      }
      
      print('📝 Migrating settings (exercises: ${exercises.length}, fine sets: ${fineSets.length}, fine settings: ${fineSettings.length})...');
      
      await _settingsRepository.saveAllSettings(
        exercises: exercises,
        fineSets: fineSets,
        fineSettings: fineSettings,
      );
      
      print('✅ Settings migration completed');
    } catch (e) {
      print('Error migrating settings: $e');
      rethrow;
    }
  }
  
  // Clear SharedPreferences after successful migration (optional)
  Future<void> clearSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.foodEntriesKey);
      await prefs.remove(AppConstants.weeklySummariesKey);
      await prefs.remove('accountability_entries');
      await prefs.remove('exercises');
      await prefs.remove('fine_sets');
      await prefs.remove('fine_settings');
      print('✅ SharedPreferences cleared');
    } catch (e) {
      print('Error clearing SharedPreferences: $e');
    }
  }
}

