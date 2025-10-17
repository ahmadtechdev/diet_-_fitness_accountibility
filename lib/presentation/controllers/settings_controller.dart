import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/models/exercise.dart';
import '../../data/models/fine_set.dart';
import '../../data/models/fine_settings.dart';
import '../../data/models/distribution_rules.dart';
import '../../core/constants/app_constants.dart';

class SettingsController extends GetxController {
  // Observable lists
  final RxList<Exercise> _exercises = <Exercise>[].obs;
  final RxList<FineSet> _fineSets = <FineSet>[].obs;
  final RxList<FineSettings> _fineSettings = <FineSettings>[].obs;

  // Observable state
  final RxBool _isLoading = false.obs;
  final RxString _selectedTab = 'exercises'.obs;

  // Getters
  List<Exercise> get exercises => _exercises;
  List<FineSet> get fineSets => _fineSets;
  List<FineSettings> get fineSettings => _fineSettings;
  bool get isLoading => _isLoading.value;
  String get selectedTab => _selectedTab.value;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultData();
    loadSettings();
  }

  void _initializeDefaultData() {
    // Initialize default exercises if none exist
    if (_exercises.isEmpty) {
      _exercises.addAll(_getDefaultExercises());
    }

    // Initialize default fine sets if none exist
    if (_fineSets.isEmpty) {
      _fineSets.addAll(_getDefaultFineSets());
    }

    // Initialize default fine settings if none exist
    if (_fineSettings.isEmpty) {
      _fineSettings.addAll(_getDefaultFineSettings());
    }
  }

  List<Exercise> _getDefaultExercises() {
    return [
      Exercise(
        id: 'jumping_rope',
        name: 'Jumping Rope',
        unit: 'reps',
        emoji: '🔄',
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      Exercise(
        id: 'squat',
        name: 'Squats',
        unit: 'reps',
        emoji: '🦵',
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      Exercise(
        id: 'jumping_jack',
        name: 'Jumping Jacks',
        unit: 'reps',
        emoji: '🤸',
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      Exercise(
        id: 'high_knee',
        name: 'High Knees',
        unit: 'reps',
        emoji: '🏃',
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      Exercise(
        id: 'pushup',
        name: 'Pushups',
        unit: 'reps',
        emoji: '💪',
        createdAt: DateTime.now(),
        isDefault: true,
      ),
    ];
  }

  List<FineSet> _getDefaultFineSets() {
    final jumpingRope = _exercises.firstWhere((e) => e.id == 'jumping_rope');
    final squat = _exercises.firstWhere((e) => e.id == 'squat');
    final jumpingJack = _exercises.firstWhere((e) => e.id == 'jumping_jack');
    final pushup = _exercises.firstWhere((e) => e.id == 'pushup');

    return [
      FineSet(
        id: 'major_junk_him',
        title: 'Major Junk Food Fine (Him)',
        description: 'Fine for Him when eating major junk food',
        exercises: [
          FineSetExercise(
            exerciseId: jumpingRope.id,
            exerciseName: jumpingRope.name,
            exerciseEmoji: jumpingRope.emoji,
            quantity: 100,
          ),
          FineSetExercise(
            exerciseId: squat.id,
            exerciseName: squat.name,
            exerciseEmoji: squat.emoji,
            quantity: 50,
          ),
          FineSetExercise(
            exerciseId: jumpingJack.id,
            exerciseName: jumpingJack.name,
            exerciseEmoji: jumpingJack.emoji,
            quantity: 50,
          ),
          FineSetExercise(
            exerciseId: pushup.id,
            exerciseName: pushup.name,
            exerciseEmoji: pushup.emoji,
            quantity: 20,
          ),
        ],
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      FineSet(
        id: 'major_junk_her',
        title: 'Major Junk Food Fine (Her)',
        description: 'Fine for Her when eating major junk food',
        exercises: [
          FineSetExercise(
            exerciseId: jumpingRope.id,
            exerciseName: jumpingRope.name,
            exerciseEmoji: jumpingRope.emoji,
            quantity: 80,
          ),
          FineSetExercise(
            exerciseId: squat.id,
            exerciseName: squat.name,
            exerciseEmoji: squat.emoji,
            quantity: 40,
          ),
          FineSetExercise(
            exerciseId: jumpingJack.id,
            exerciseName: jumpingJack.name,
            exerciseEmoji: jumpingJack.emoji,
            quantity: 40,
          ),
          FineSetExercise(
            exerciseId: pushup.id,
            exerciseName: pushup.name,
            exerciseEmoji: pushup.emoji,
            quantity: 15,
          ),
        ],
        createdAt: DateTime.now(),
        isDefault: true,
      ),
    ];
  }

  List<FineSettings> _getDefaultFineSettings() {
    final majorJunkHim = _fineSets.firstWhere((fs) => fs.id == 'major_junk_him');
    final majorJunkHer = _fineSets.firstWhere((fs) => fs.id == 'major_junk_her');

    return [
      FineSettings(
        id: 'major_junk_settings',
        foodType: AppConstants.majorJunk,
        foodTypeEmoji: AppConstants.foodTypeEmojis[AppConstants.majorJunk]!,
        himFineSet: majorJunkHim,
        herFineSet: majorJunkHer,
        distributionRules: DistributionRules.defaultRules(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  // Exercise Management
  void addExercise(Exercise exercise) {
    _exercises.add(exercise);
    saveSettings();
  }

  void updateExercise(Exercise exercise) {
    final index = _exercises.indexWhere((e) => e.id == exercise.id);
    if (index != -1) {
      _exercises[index] = exercise;
      saveSettings();
    }
  }

  void deleteExercise(String exerciseId) {
    _exercises.removeWhere((e) => e.id == exerciseId);
    // Also remove from fine sets
    for (final fineSet in _fineSets) {
      fineSet.exercises.removeWhere((e) => e.exerciseId == exerciseId);
    }
    saveSettings();
  }

  // Fine Set Management
  void addFineSet(FineSet fineSet) {
    _fineSets.add(fineSet);
    saveSettings();
  }

  void updateFineSet(FineSet fineSet) {
    final index = _fineSets.indexWhere((fs) => fs.id == fineSet.id);
    if (index != -1) {
      _fineSets[index] = fineSet;
      saveSettings();
    }
  }

  void deleteFineSet(String fineSetId) {
    _fineSets.removeWhere((fs) => fs.id == fineSetId);
    // Also remove from fine settings
    for (final fineSetting in _fineSettings) {
      if (fineSetting.himFineSet?.id == fineSetId) {
        fineSetting.copyWith(himFineSet: null);
      }
      if (fineSetting.herFineSet?.id == fineSetId) {
        fineSetting.copyWith(herFineSet: null);
      }
    }
    saveSettings();
  }

  // Fine Settings Management
  void updateFineSettings(FineSettings fineSettings) {
    final index = _fineSettings.indexWhere((fs) => fs.id == fineSettings.id);
    if (index != -1) {
      _fineSettings[index] = fineSettings;
    } else {
      _fineSettings.add(fineSettings);
    }
    saveSettings();
  }

  FineSettings? getFineSettingsForFoodType(String foodType) {
    try {
      return _fineSettings.firstWhere((fs) => fs.foodType == foodType);
    } catch (e) {
      return null;
    }
  }

  // Tab Management
  void setSelectedTab(String tab) {
    _selectedTab.value = tab;
  }

  // Storage Management
  Future<void> saveSettings() async {
    try {
      _isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      
      // Save exercises
      final exercisesJson = _exercises.map((e) => e.toJson()).toList();
      await prefs.setString('exercises', jsonEncode(exercisesJson));
      
      // Save fine sets
      final fineSetsJson = _fineSets.map((fs) => fs.toJson()).toList();
      await prefs.setString('fine_sets', jsonEncode(fineSetsJson));
      
      // Save fine settings
      final fineSettingsJson = _fineSettings.map((fs) => fs.toJson()).toList();
      await prefs.setString('fine_settings', jsonEncode(fineSettingsJson));
      
    } catch (e) {
      print('Error saving settings: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadSettings() async {
    try {
      _isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      
      // Load exercises
      final exercisesString = prefs.getString('exercises');
      if (exercisesString != null) {
        final exercisesList = jsonDecode(exercisesString) as List;
        _exercises.value = exercisesList
            .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      
      // Load fine sets
      final fineSetsString = prefs.getString('fine_sets');
      if (fineSetsString != null) {
        final fineSetsList = jsonDecode(fineSetsString) as List;
        _fineSets.value = fineSetsList
            .map((fs) => FineSet.fromJson(fs as Map<String, dynamic>))
            .toList();
      }
      
      // Load fine settings
      final fineSettingsString = prefs.getString('fine_settings');
      if (fineSettingsString != null) {
        final fineSettingsList = jsonDecode(fineSettingsString) as List;
        _fineSettings.value = fineSettingsList
            .map((fs) => FineSettings.fromJson(fs as Map<String, dynamic>))
            .toList();
      }
      
    } catch (e) {
      print('Error loading settings: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> resetToDefaults() async {
    _exercises.clear();
    _fineSets.clear();
    _fineSettings.clear();
    _initializeDefaultData();
    await saveSettings();
  }

  // Reward Meal Management
  void addRewardMeal(String person) {
    for (final fineSetting in _fineSettings) {
      final currentRules = fineSetting.distributionRules;
      final newRules = person == AppConstants.him
          ? currentRules.copyWith(himCurrentRewardMeals: currentRules.himCurrentRewardMeals + 1)
          : currentRules.copyWith(herCurrentRewardMeals: currentRules.herCurrentRewardMeals + 1);
      
      final updatedFineSetting = FineSettings(
        id: fineSetting.id,
        foodType: fineSetting.foodType,
        foodTypeEmoji: fineSetting.foodTypeEmoji,
        himFineSet: fineSetting.himFineSet,
        herFineSet: fineSetting.herFineSet,
        distributionRules: newRules,
        createdAt: fineSetting.createdAt,
        updatedAt: DateTime.now(),
      );
      
      final index = _fineSettings.indexWhere((fs) => fs.id == fineSetting.id);
      if (index != -1) {
        _fineSettings[index] = updatedFineSetting;
      }
    }
    saveSettings();
  }

  void removeRewardMeal(String person) {
    for (final fineSetting in _fineSettings) {
      final currentRules = fineSetting.distributionRules;
      final currentRewardMeals = person == AppConstants.him 
          ? currentRules.himCurrentRewardMeals 
          : currentRules.herCurrentRewardMeals;
      
      if (currentRewardMeals > 0) {
        final newRules = person == AppConstants.him
            ? currentRules.copyWith(himCurrentRewardMeals: currentRewardMeals - 1)
            : currentRules.copyWith(herCurrentRewardMeals: currentRewardMeals - 1);
        
        final updatedFineSetting = FineSettings(
          id: fineSetting.id,
          foodType: fineSetting.foodType,
          foodTypeEmoji: fineSetting.foodTypeEmoji,
          himFineSet: fineSetting.himFineSet,
          herFineSet: fineSetting.herFineSet,
          distributionRules: newRules,
          createdAt: fineSetting.createdAt,
          updatedAt: DateTime.now(),
        );
        
        final index = _fineSettings.indexWhere((fs) => fs.id == fineSetting.id);
        if (index != -1) {
          _fineSettings[index] = updatedFineSetting;
        }
      }
    }
    saveSettings();
  }

  int getRewardMeals(String person) {
    if (_fineSettings.isEmpty) return 0;
    
    final firstFineSetting = _fineSettings.first;
    return person == AppConstants.him 
        ? firstFineSetting.distributionRules.himCurrentRewardMeals
        : firstFineSetting.distributionRules.herCurrentRewardMeals;
  }

  void setRewardMeals(String person, int count) {
    for (final fineSetting in _fineSettings) {
      final currentRules = fineSetting.distributionRules;
      final newRules = person == AppConstants.him
          ? currentRules.copyWith(himCurrentRewardMeals: count)
          : currentRules.copyWith(herCurrentRewardMeals: count);
      
      final updatedFineSetting = FineSettings(
        id: fineSetting.id,
        foodType: fineSetting.foodType,
        foodTypeEmoji: fineSetting.foodTypeEmoji,
        himFineSet: fineSetting.himFineSet,
        herFineSet: fineSetting.herFineSet,
        distributionRules: newRules,
        createdAt: fineSetting.createdAt,
        updatedAt: DateTime.now(),
      );
      
      final index = _fineSettings.indexWhere((fs) => fs.id == fineSetting.id);
      if (index != -1) {
        _fineSettings[index] = updatedFineSetting;
      }
    }
    saveSettings();
  }
}
