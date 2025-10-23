import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/models/accountability_entry.dart';
import '../../data/models/food_entry.dart';
import '../../data/models/fine_settings.dart';
import '../../data/repositories/accountability_repository.dart';
import '../../core/constants/app_constants.dart';
import 'food_tracker_controller.dart';
import 'settings_controller.dart';

class AccountabilityController extends GetxController {
  // Repository
  final AccountabilityRepository _repository = AccountabilityRepository();
  
  // Observable lists
  final RxList<AccountabilityEntry> _accountabilityEntries = <AccountabilityEntry>[].obs;
  final RxList<AccountabilityEntry> _pendingEntries = <AccountabilityEntry>[].obs;
  final RxList<AccountabilityEntry> _completedEntries = <AccountabilityEntry>[].obs;

  // Observable state
  final RxBool _isLoading = false.obs;
  final RxString _selectedFilter = 'pending'.obs; // 'all', 'pending', 'completed', 'my', 'partner'

  // Getters
  List<AccountabilityEntry> get accountabilityEntries => _accountabilityEntries;
  List<AccountabilityEntry> get pendingEntries => _pendingEntries;
  List<AccountabilityEntry> get completedEntries => _completedEntries;
  bool get isLoading => _isLoading.value;
  String get selectedFilter => _selectedFilter.value;

  // Filtered entries based on current filter
  List<AccountabilityEntry> get filteredEntries {
    switch (_selectedFilter.value) {
      case 'pending':
        return List.from(_pendingEntries);
      case 'completed':
        return List.from(_completedEntries);
      case 'my':
        // Show all entries for "him" (both pending and completed)
        // This includes entries where whoAte is "Him" (regardless of isFromPartner)
        return _accountabilityEntries.where((entry) => entry.whoAte == AppConstants.him).toList();
      case 'partner':
        // Show all entries for "her" (both pending and completed)
        // This includes entries where whoAte is "Her" (regardless of isFromPartner)
        return _accountabilityEntries.where((entry) => entry.whoAte == AppConstants.her).toList();
      default:
        return List.from(_accountabilityEntries);
    }
  }

  // Statistics
  int get totalPendingFines => _pendingEntries.length;
  int get totalCompletedFines => _completedEntries.length;
  int get myPendingFines => _pendingEntries.where((entry) => entry.whoAte == AppConstants.him).length;
  int get partnerPendingFines => _pendingEntries.where((entry) => entry.whoAte == AppConstants.her).length;

  // Exercise totals
  ExerciseFine get totalPendingExercises {
    return _pendingEntries.fold(
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

  ExerciseFine get totalCompletedExercises {
    return _completedEntries.fold(
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

  // Completion rate
  double get completionRate {
    final total = _accountabilityEntries.length;
    if (total == 0) return 0.0;
    return _completedEntries.length / total;
  }

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }
  
  // Load data from Firebase
  Future<void> _loadData() async {
    _isLoading.value = true;
    try {
      // Listen to Firebase stream for real-time updates
      _repository.getAccountabilityEntries().listen((entries) {
        _accountabilityEntries.value = entries;
        _updateFilteredLists();
      });
      
      // Initial load
      final entries = await _repository.getAllAccountabilityEntriesOnce();
      _accountabilityEntries.value = entries;
      _updateFilteredLists();
      
    } catch (e) {
      print('Error loading accountability data: $e');
      // Fallback to SharedPreferences for migration
      await loadAccountabilityEntries();
    } finally {
      _isLoading.value = false;
    }
  }

  // Create accountability entries from food entry using new fine system
  Future<void> createAccountabilityEntriesFromFoodEntry(FoodEntry foodEntry) async {
    try {
      // Get settings controller to access fine settings
      final settingsController = Get.find<SettingsController>();
      final fineSettings = settingsController.getFineSettingsForFoodType(foodEntry.foodType);
      
      // Get food entries from FoodTrackerController to check weekly limits
      List<FoodEntry> existingFoodEntries = [];
      try {
        final foodController = Get.find<FoodTrackerController>();
        existingFoodEntries = foodController.foodEntries;
      } catch (e) {
        print('FoodTrackerController not found: $e');
      }
      
      // Create accountability entries using the new system
      final accountabilityEntries = AccountabilityEntry.createFromFoodEntryWithFineSettings(
        foodEntry: foodEntry,
        fineSettings: fineSettings,
        existingEntries: existingFoodEntries,
      );
      
      // Add to lists
      for (final entry in accountabilityEntries) {
        _accountabilityEntries.add(entry);
        if (!entry.isCompleted) {
          _pendingEntries.add(entry);
        } else {
          _completedEntries.add(entry);
        }
      }
      
      // Sort all lists by date descending (newest first)
      _accountabilityEntries.sort((a, b) => b.date.compareTo(a.date));
      _pendingEntries.sort((a, b) => b.date.compareTo(a.date));
      _completedEntries.sort((a, b) => b.date.compareTo(a.date));
      
      // Save to storage
      await _saveAccountabilityEntries();
      
    } catch (e) {
      print('Error creating accountability entries: $e');
    }
  }

  // Load accountability entries from storage
  Future<void> loadAccountabilityEntries() async {
    _isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = prefs.getStringList('accountability_entries') ?? [];
      
      _accountabilityEntries.clear();
      for (final entryJson in entriesJson) {
        final entry = AccountabilityEntry.fromJson(jsonDecode(entryJson));
        _accountabilityEntries.add(entry);
      }
      
      _updateFilteredLists();
    } catch (e) {
      print('Error loading accountability entries: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Save accountability entries to Firebase and backup to SharedPreferences
  Future<void> _saveAccountabilityEntries() async {
    try {
      // Save all entries to Firebase
      for (final entry in _accountabilityEntries) {
        await _repository.addAccountabilityEntry(entry);
      }
      
      // Backup to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = _accountabilityEntries
          .map((entry) => jsonEncode(entry.toJson()))
          .toList();
      await prefs.setStringList('accountability_entries', entriesJson);
    } catch (e) {
      print('Error saving accountability entries: $e');
    }
  }

  // Add accountability entries from food entries (DEPRECATED - use createAccountabilityEntriesFromFoodEntry instead)
  Future<void> addFromFoodEntries(List<FoodEntry> foodEntries) async {
    print('⚠️ DEPRECATED: addFromFoodEntries called - this should not happen!');
    print('   Use createAccountabilityEntriesFromFoodEntry instead');
    // This method is deprecated and should not be used
    // The new system uses createAccountabilityEntriesFromFoodEntry
  }

  // Add or update an accountability entry
  void _addOrUpdateEntry(AccountabilityEntry entry) {
    print('🔍 Adding Accountability Entry:');
    print('   Entry ID: ${entry.id}');
    print('   Who Ate: ${entry.whoAte}');
    print('   Food Type: ${entry.foodType}');
    print('   Fine Total: ${entry.fine.totalExercises}');
    print('   Fine Details: ${entry.fine.description}');
    
    final existingIndex = _accountabilityEntries.indexWhere((e) => e.id == entry.id);
    if (existingIndex != -1) {
      _accountabilityEntries[existingIndex] = entry;
      print('   ✅ Updated existing entry');
    } else {
      _accountabilityEntries.add(entry);
      print('   ✅ Added new entry');
    }
  }

  // Mark an entry as completed
  Future<void> markAsCompleted(String entryId, String completedBy) async {
    final index = _accountabilityEntries.indexWhere((entry) => entry.id == entryId);
    if (index != -1) {
      final updatedEntry = _accountabilityEntries[index].markAsCompleted(completedBy);
      _accountabilityEntries[index] = updatedEntry;
      
      try {
        await _repository.updateAccountabilityEntry(updatedEntry);
      } catch (e) {
        print('Error updating in Firebase: $e');
      }
      
      await _saveAccountabilityEntries();
      _updateFilteredLists();
    }
  }
  
  // Mark an entry as pending (undo completion)
  Future<void> markAsPending(String entryId) async {
    final index = _accountabilityEntries.indexWhere((entry) => entry.id == entryId);
    if (index != -1) {
      final updatedEntry = _accountabilityEntries[index].copyWith(
        isCompleted: false,
        completedAt: null,
        completedBy: '',
      );
      _accountabilityEntries[index] = updatedEntry;
      
      try {
        await _repository.updateAccountabilityEntry(updatedEntry);
      } catch (e) {
        print('Error updating in Firebase: $e');
      }
      
      await _saveAccountabilityEntries();
      _updateFilteredLists();
    }
  }

  // Clear all accountability entries (for testing)
  Future<void> clearAllEntries() async {
    print('🧹 Clearing all accountability entries...');
    _accountabilityEntries.clear();
    _pendingEntries.clear();
    _completedEntries.clear();
    await _saveAccountabilityEntries();
    _updateFilteredLists();
    print('✅ All accountability entries cleared');
  }

  // Set filter
  void setFilter(String filter) {
    _selectedFilter.value = filter;
  }

  // Update filtered lists
  void _updateFilteredLists() {
    _pendingEntries.clear();
    _completedEntries.clear();
    
    for (final entry in _accountabilityEntries) {
      if (entry.isCompleted) {
        _completedEntries.add(entry);
      } else {
        _pendingEntries.add(entry);
      }
    }
    
    // Sort both lists by date descending (newest first)
    _pendingEntries.sort((a, b) => b.date.compareTo(a.date));
    _completedEntries.sort((a, b) => b.date.compareTo(a.date));
  }

  // Get entries for a specific week
  List<AccountabilityEntry> getEntriesForWeek(int weekNumber) {
    return _accountabilityEntries.where((entry) => entry.weekNumber == weekNumber).toList();
  }

  // Get entries for a specific date
  List<AccountabilityEntry> getEntriesForDate(DateTime date) {
    return _accountabilityEntries.where((entry) => 
      entry.date.year == date.year &&
      entry.date.month == date.month &&
      entry.date.day == date.day
    ).toList();
  }

}
