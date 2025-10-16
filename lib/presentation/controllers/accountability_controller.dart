import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/models/accountability_entry.dart';
import '../../data/models/food_entry.dart';
import '../../data/models/fine_settings.dart';
import '../../core/constants/app_constants.dart';
import 'settings_controller.dart';

class AccountabilityController extends GetxController {
  // Observable lists
  final RxList<AccountabilityEntry> _accountabilityEntries = <AccountabilityEntry>[].obs;
  final RxList<AccountabilityEntry> _pendingEntries = <AccountabilityEntry>[].obs;
  final RxList<AccountabilityEntry> _completedEntries = <AccountabilityEntry>[].obs;

  // Observable state
  final RxBool _isLoading = false.obs;
  final RxString _selectedFilter = 'all'.obs; // 'all', 'pending', 'completed', 'my', 'partner'

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
        return _pendingEntries;
      case 'completed':
        return _completedEntries;
      case 'my':
        return _accountabilityEntries.where((entry) => !entry.isFromPartner).toList();
      case 'partner':
        return _accountabilityEntries.where((entry) => entry.isFromPartner).toList();
      default:
        return _accountabilityEntries;
    }
  }

  // Statistics
  int get totalPendingFines => _pendingEntries.length;
  int get totalCompletedFines => _completedEntries.length;
  int get myPendingFines => _pendingEntries.where((entry) => !entry.isFromPartner).length;
  int get partnerPendingFines => _pendingEntries.where((entry) => entry.isFromPartner).length;

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
    loadAccountabilityEntries();
  }

  // Create accountability entries from food entry using new fine system
  Future<void> createAccountabilityEntriesFromFoodEntry(FoodEntry foodEntry) async {
    try {
      // Get settings controller to access fine settings
      final settingsController = Get.find<SettingsController>();
      final fineSettings = settingsController.getFineSettingsForFoodType(foodEntry.foodType);
      
      // Create accountability entries using the new system
      final accountabilityEntries = AccountabilityEntry.createFromFoodEntryWithFineSettings(
        foodEntry: foodEntry,
        fineSettings: fineSettings,
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

  // Save accountability entries to storage
  Future<void> _saveAccountabilityEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = _accountabilityEntries
          .map((entry) => jsonEncode(entry.toJson()))
          .toList();
      await prefs.setStringList('accountability_entries', entriesJson);
    } catch (e) {
      print('Error saving accountability entries: $e');
    }
  }

  // Add accountability entries from food entries
  Future<void> addFromFoodEntries(List<FoodEntry> foodEntries) async {
    for (final foodEntry in foodEntries) {
      // Get fine settings for this food type
      FineSettings? fineSettings;
      try {
        final settingsController = Get.find<SettingsController>();
        fineSettings = settingsController.fineSettings
            .where((setting) => setting.foodType == foodEntry.foodType)
            .firstOrNull;
      } catch (e) {
        print('Settings controller not found: $e');
      }

      // Create distributed fines
      final distributedFines = ExerciseFine.createDistributedFines(
        foodEntry.foodType,
        foodEntry.quantity,
        foodEntry.whoAte,
        fineSettings,
      );

      // Create accountability entries based on who ate and distributed fines
      if (foodEntry.whoAte == AppConstants.both) {
        // Create entries for both Him and Her with distributed fines
        final himEntry = AccountabilityEntry.fromFoodEntry(
          foodEntryId: foodEntry.id,
          date: foodEntry.date,
          whoAte: AppConstants.him,
          foodType: foodEntry.foodType,
          foodName: foodEntry.foodName,
          quantity: foodEntry.quantity,
          fine: distributedFines['him']!,
          status: foodEntry.status,
          notes: foodEntry.notes,
          weekNumber: foodEntry.weekNumber,
        );
        
        final herEntry = AccountabilityEntry.fromFoodEntry(
          foodEntryId: foodEntry.id,
          date: foodEntry.date,
          whoAte: AppConstants.her,
          foodType: foodEntry.foodType,
          foodName: foodEntry.foodName,
          quantity: foodEntry.quantity,
          fine: distributedFines['her']!,
          status: foodEntry.status,
          notes: foodEntry.notes,
          weekNumber: foodEntry.weekNumber,
        );
        
        _addOrUpdateEntry(himEntry);
        _addOrUpdateEntry(herEntry);
      } else {
        // Create entry for the person who ate with their portion of the fine
        final personFine = foodEntry.whoAte == AppConstants.him 
            ? distributedFines['him']! 
            : distributedFines['her']!;
            
        final entry = AccountabilityEntry.fromFoodEntry(
          foodEntryId: foodEntry.id,
          date: foodEntry.date,
          whoAte: foodEntry.whoAte,
          foodType: foodEntry.foodType,
          foodName: foodEntry.foodName,
          quantity: foodEntry.quantity,
          fine: personFine,
          status: foodEntry.status,
          notes: foodEntry.notes,
          weekNumber: foodEntry.weekNumber,
        );
        
        _addOrUpdateEntry(entry);

        // If the other person also gets a portion of the fine, create an entry for them
        final otherPersonFine = foodEntry.whoAte == AppConstants.him 
            ? distributedFines['her']! 
            : distributedFines['him']!;
            
        if (otherPersonFine.totalExercises > 0) {
          final otherPersonEntry = AccountabilityEntry.fromFoodEntry(
            foodEntryId: foodEntry.id,
            date: foodEntry.date,
            whoAte: foodEntry.whoAte == AppConstants.him ? AppConstants.her : AppConstants.him,
            foodType: foodEntry.foodType,
            foodName: foodEntry.foodName,
            quantity: foodEntry.quantity,
            fine: otherPersonFine,
            status: foodEntry.status,
            notes: foodEntry.notes,
            weekNumber: foodEntry.weekNumber,
          );
          
          _addOrUpdateEntry(otherPersonEntry);
        }
      }
    }
    
    await _saveAccountabilityEntries();
    _updateFilteredLists();
  }

  // Add or update an accountability entry
  void _addOrUpdateEntry(AccountabilityEntry entry) {
    final existingIndex = _accountabilityEntries.indexWhere((e) => e.id == entry.id);
    if (existingIndex != -1) {
      _accountabilityEntries[existingIndex] = entry;
    } else {
      _accountabilityEntries.add(entry);
    }
  }

  // Mark an entry as completed
  Future<void> markAsCompleted(String entryId, String completedBy) async {
    final index = _accountabilityEntries.indexWhere((entry) => entry.id == entryId);
    if (index != -1) {
      _accountabilityEntries[index] = _accountabilityEntries[index].markAsCompleted(completedBy);
      await _saveAccountabilityEntries();
      _updateFilteredLists();
    }
  }

  // Mark an entry as pending (undo completion)
  Future<void> markAsPending(String entryId) async {
    final index = _accountabilityEntries.indexWhere((entry) => entry.id == entryId);
    if (index != -1) {
      _accountabilityEntries[index] = _accountabilityEntries[index].copyWith(
        isCompleted: false,
        completedAt: null,
        completedBy: '',
      );
      await _saveAccountabilityEntries();
      _updateFilteredLists();
    }
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

  // Clear all entries (for testing)
  Future<void> clearAllEntries() async {
    _accountabilityEntries.clear();
    _pendingEntries.clear();
    _completedEntries.clear();
    await _saveAccountabilityEntries();
  }
}
