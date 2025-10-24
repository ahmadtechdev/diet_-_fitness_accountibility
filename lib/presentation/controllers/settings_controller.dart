import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/models/exercise.dart';
import '../../data/models/fine_set.dart';
import '../../data/models/fine_settings.dart';
import '../../data/models/distribution_rules.dart';
import '../../data/repositories/settings_repository.dart';
import '../../core/constants/app_constants.dart';

class SettingsController extends GetxController {
  // Repository
  final SettingsRepository _repository = SettingsRepository();
  
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
    _loadData();
  }
  
  // Load data from Firebase
  Future<void> _loadData() async {
    _isLoading.value = true;
    try {
      // Listen to Firebase stream for real-time updates
      _repository.getSettings().listen((settings) {
        if (settings.containsKey('exercises')) {
          final exercisesList = settings['exercises'] as List;
          _exercises.value = exercisesList
              .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        
        if (settings.containsKey('fineSets')) {
          final fineSetsList = settings['fineSets'] as List;
          _fineSets.value = fineSetsList
              .map((fs) => FineSet.fromJson(fs as Map<String, dynamic>))
              .toList();
        }
        
        if (settings.containsKey('fineSettings')) {
          final fineSettingsList = settings['fineSettings'] as List;
          _fineSettings.value = fineSettingsList
              .map((fs) => FineSettings.fromJson(fs as Map<String, dynamic>))
              .toList();
        }
      });
      
      // Initial load
      final settings = await _repository.getAllSettingsOnce();
      if (settings.containsKey('exercises')) {
        final exercisesList = settings['exercises'] as List;
        _exercises.value = exercisesList
            .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      
      if (settings.containsKey('fineSets')) {
        final fineSetsList = settings['fineSets'] as List;
        _fineSets.value = fineSetsList
            .map((fs) => FineSet.fromJson(fs as Map<String, dynamic>))
            .toList();
      }
      
      if (settings.containsKey('fineSettings')) {
        final fineSettingsList = settings['fineSettings'] as List;
        _fineSettings.value = fineSettingsList
            .map((fs) => FineSettings.fromJson(fs as Map<String, dynamic>))
            .toList();
      }
      
      // Initialize defaults if no data exists
      if (_exercises.isEmpty || _fineSets.isEmpty || _fineSettings.isEmpty) {
        _initializeDefaultData();
        await saveSettings();
      }
      
    } catch (e) {
      print('Error loading settings from Firebase: $e');
      // Fallback to SharedPreferences for migration
      await loadSettings();
    } finally {
      _isLoading.value = false;
    }
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
    } else {
      // Check if all food types have fine settings, add missing ones
      final allFoodTypes = [
        AppConstants.majorJunk,
        AppConstants.coldDrink,
        AppConstants.snacks,
        AppConstants.desiOutside,
        AppConstants.dessert,
      ];
      
      // Ensure all fine sets exist first
      final defaultFineSets = _getDefaultFineSets();
      for (final fineSet in defaultFineSets) {
        if (!_fineSets.any((fs) => fs.id == fineSet.id)) {
          _fineSets.add(fineSet);
        }
      }
      
      // Ensure all fine settings exist
      final defaultFineSettings = _getDefaultFineSettings();
      for (final defaultSetting in defaultFineSettings) {
        if (!_fineSettings.any((fs) => fs.foodType == defaultSetting.foodType)) {
          _fineSettings.add(defaultSetting);
        }
      }
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
    final highKnee = _exercises.firstWhere((e) => e.id == 'high_knee');
    final pushup = _exercises.firstWhere((e) => e.id == 'pushup');

    return [
      // Major Junk - Based on image: 80 Jump Ropes + 40 Squats + 40 Jumping Jacks + 40 High Knees + 10 Pushups
      FineSet(
        id: 'major_junk_him',
        title: 'Major Junk Food Fine (Him)',
        description: 'Fine for Him when eating major junk food',
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
            exerciseId: highKnee.id,
            exerciseName: highKnee.name,
            exerciseEmoji: highKnee.emoji,
            quantity: 40,
          ),
          FineSetExercise(
            exerciseId: pushup.id,
            exerciseName: pushup.name,
            exerciseEmoji: pushup.emoji,
            quantity: 10,
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
            exerciseId: highKnee.id,
            exerciseName: highKnee.name,
            exerciseEmoji: highKnee.emoji,
            quantity: 40,
          ),
          FineSetExercise(
            exerciseId: pushup.id,
            exerciseName: pushup.name,
            exerciseEmoji: pushup.emoji,
            quantity: 10,
          ),
        ],
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      // Desi Outside - Based on image: 60 Jump Ropes + 30 Squats + 30 Jumping Jacks + 30 High Knees + 10 Pushups
      FineSet(
        id: 'desi_outside_him',
        title: 'Desi Outside Fine (Him)',
        description: 'Fine for Him when eating desi outside food',
        exercises: [
          FineSetExercise(
            exerciseId: jumpingRope.id,
            exerciseName: jumpingRope.name,
            exerciseEmoji: jumpingRope.emoji,
            quantity: 60,
          ),
          FineSetExercise(
            exerciseId: squat.id,
            exerciseName: squat.name,
            exerciseEmoji: squat.emoji,
            quantity: 30,
          ),
          FineSetExercise(
            exerciseId: jumpingJack.id,
            exerciseName: jumpingJack.name,
            exerciseEmoji: jumpingJack.emoji,
            quantity: 30,
          ),
          FineSetExercise(
            exerciseId: highKnee.id,
            exerciseName: highKnee.name,
            exerciseEmoji: highKnee.emoji,
            quantity: 30,
          ),
          FineSetExercise(
            exerciseId: pushup.id,
            exerciseName: pushup.name,
            exerciseEmoji: pushup.emoji,
            quantity: 10,
          ),
        ],
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      FineSet(
        id: 'desi_outside_her',
        title: 'Desi Outside Fine (Her)',
        description: 'Fine for Her when eating desi outside food',
        exercises: [
          FineSetExercise(
            exerciseId: jumpingRope.id,
            exerciseName: jumpingRope.name,
            exerciseEmoji: jumpingRope.emoji,
            quantity: 60,
          ),
          FineSetExercise(
            exerciseId: squat.id,
            exerciseName: squat.name,
            exerciseEmoji: squat.emoji,
            quantity: 30,
          ),
          FineSetExercise(
            exerciseId: jumpingJack.id,
            exerciseName: jumpingJack.name,
            exerciseEmoji: jumpingJack.emoji,
            quantity: 30,
          ),
          FineSetExercise(
            exerciseId: highKnee.id,
            exerciseName: highKnee.name,
            exerciseEmoji: highKnee.emoji,
            quantity: 30,
          ),
          FineSetExercise(
            exerciseId: pushup.id,
            exerciseName: pushup.name,
            exerciseEmoji: pushup.emoji,
            quantity: 10,
          ),
        ],
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      // Dessert - Based on image: 70 Jump Ropes + 30 Squats + 40 Jumping Jacks + 40 High Knees + 10 Pushups
      FineSet(
        id: 'dessert_him',
        title: 'Dessert Fine (Him)',
        description: 'Fine for Him when eating dessert',
        exercises: [
          FineSetExercise(
            exerciseId: jumpingRope.id,
            exerciseName: jumpingRope.name,
            exerciseEmoji: jumpingRope.emoji,
            quantity: 70,
          ),
          FineSetExercise(
            exerciseId: squat.id,
            exerciseName: squat.name,
            exerciseEmoji: squat.emoji,
            quantity: 30,
          ),
          FineSetExercise(
            exerciseId: jumpingJack.id,
            exerciseName: jumpingJack.name,
            exerciseEmoji: jumpingJack.emoji,
            quantity: 40,
          ),
          FineSetExercise(
            exerciseId: highKnee.id,
            exerciseName: highKnee.name,
            exerciseEmoji: highKnee.emoji,
            quantity: 40,
          ),
          FineSetExercise(
            exerciseId: pushup.id,
            exerciseName: pushup.name,
            exerciseEmoji: pushup.emoji,
            quantity: 10,
          ),
        ],
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      FineSet(
        id: 'dessert_her',
        title: 'Dessert Fine (Her)',
        description: 'Fine for Her when eating dessert',
        exercises: [
          FineSetExercise(
            exerciseId: jumpingRope.id,
            exerciseName: jumpingRope.name,
            exerciseEmoji: jumpingRope.emoji,
            quantity: 70,
          ),
          FineSetExercise(
            exerciseId: squat.id,
            exerciseName: squat.name,
            exerciseEmoji: squat.emoji,
            quantity: 30,
          ),
          FineSetExercise(
            exerciseId: jumpingJack.id,
            exerciseName: jumpingJack.name,
            exerciseEmoji: jumpingJack.emoji,
            quantity: 40,
          ),
          FineSetExercise(
            exerciseId: highKnee.id,
            exerciseName: highKnee.name,
            exerciseEmoji: highKnee.emoji,
            quantity: 40,
          ),
          FineSetExercise(
            exerciseId: pushup.id,
            exerciseName: pushup.name,
            exerciseEmoji: pushup.emoji,
            quantity: 10,
          ),
        ],
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      // Cold Drink - Based on image: 20 Jump Ropes + 15 Squats + 15 Jumping Jacks + 15 High Knees + 5 Pushups
      FineSet(
        id: 'cold_drink_him',
        title: 'Cold Drink Fine (Him)',
        description: 'Fine for Him when drinking cold drinks',
        exercises: [
          FineSetExercise(
            exerciseId: jumpingRope.id,
            exerciseName: jumpingRope.name,
            exerciseEmoji: jumpingRope.emoji,
            quantity: 20,
          ),
          FineSetExercise(
            exerciseId: squat.id,
            exerciseName: squat.name,
            exerciseEmoji: squat.emoji,
            quantity: 15,
          ),
          FineSetExercise(
            exerciseId: jumpingJack.id,
            exerciseName: jumpingJack.name,
            exerciseEmoji: jumpingJack.emoji,
            quantity: 15,
          ),
          FineSetExercise(
            exerciseId: highKnee.id,
            exerciseName: highKnee.name,
            exerciseEmoji: highKnee.emoji,
            quantity: 15,
          ),
          FineSetExercise(
            exerciseId: pushup.id,
            exerciseName: pushup.name,
            exerciseEmoji: pushup.emoji,
            quantity: 5,
          ),
        ],
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      FineSet(
        id: 'cold_drink_her',
        title: 'Cold Drink Fine (Her)',
        description: 'Fine for Her when drinking cold drinks',
        exercises: [
          FineSetExercise(
            exerciseId: jumpingRope.id,
            exerciseName: jumpingRope.name,
            exerciseEmoji: jumpingRope.emoji,
            quantity: 20,
          ),
          FineSetExercise(
            exerciseId: squat.id,
            exerciseName: squat.name,
            exerciseEmoji: squat.emoji,
            quantity: 15,
          ),
          FineSetExercise(
            exerciseId: jumpingJack.id,
            exerciseName: jumpingJack.name,
            exerciseEmoji: jumpingJack.emoji,
            quantity: 15,
          ),
          FineSetExercise(
            exerciseId: highKnee.id,
            exerciseName: highKnee.name,
            exerciseEmoji: highKnee.emoji,
            quantity: 15,
          ),
          FineSetExercise(
            exerciseId: pushup.id,
            exerciseName: pushup.name,
            exerciseEmoji: pushup.emoji,
            quantity: 5,
          ),
        ],
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      // Snacks - Based on image: 10 Jump Ropes + 10 Squats + 10 Jumping Jacks + 10 High Knees + 2 Pushups
      FineSet(
        id: 'snacks_him',
        title: 'Snacks Fine (Him)',
        description: 'Fine for Him when eating snacks',
        exercises: [
          FineSetExercise(
            exerciseId: jumpingRope.id,
            exerciseName: jumpingRope.name,
            exerciseEmoji: jumpingRope.emoji,
            quantity: 10,
          ),
          FineSetExercise(
            exerciseId: squat.id,
            exerciseName: squat.name,
            exerciseEmoji: squat.emoji,
            quantity: 10,
          ),
          FineSetExercise(
            exerciseId: jumpingJack.id,
            exerciseName: jumpingJack.name,
            exerciseEmoji: jumpingJack.emoji,
            quantity: 10,
          ),
          FineSetExercise(
            exerciseId: highKnee.id,
            exerciseName: highKnee.name,
            exerciseEmoji: highKnee.emoji,
            quantity: 10,
          ),
          FineSetExercise(
            exerciseId: pushup.id,
            exerciseName: pushup.name,
            exerciseEmoji: pushup.emoji,
            quantity: 2,
          ),
        ],
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      FineSet(
        id: 'snacks_her',
        title: 'Snacks Fine (Her)',
        description: 'Fine for Her when eating snacks',
        exercises: [
          FineSetExercise(
            exerciseId: jumpingRope.id,
            exerciseName: jumpingRope.name,
            exerciseEmoji: jumpingRope.emoji,
            quantity: 10,
          ),
          FineSetExercise(
            exerciseId: squat.id,
            exerciseName: squat.name,
            exerciseEmoji: squat.emoji,
            quantity: 10,
          ),
          FineSetExercise(
            exerciseId: jumpingJack.id,
            exerciseName: jumpingJack.name,
            exerciseEmoji: jumpingJack.emoji,
            quantity: 10,
          ),
          FineSetExercise(
            exerciseId: highKnee.id,
            exerciseName: highKnee.name,
            exerciseEmoji: highKnee.emoji,
            quantity: 10,
          ),
          FineSetExercise(
            exerciseId: pushup.id,
            exerciseName: pushup.name,
            exerciseEmoji: pushup.emoji,
            quantity: 2,
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
    final coldDrinkHim = _fineSets.firstWhere((fs) => fs.id == 'cold_drink_him');
    final coldDrinkHer = _fineSets.firstWhere((fs) => fs.id == 'cold_drink_her');
    final snacksHim = _fineSets.firstWhere((fs) => fs.id == 'snacks_him');
    final snacksHer = _fineSets.firstWhere((fs) => fs.id == 'snacks_her');
    final desiOutsideHim = _fineSets.firstWhere((fs) => fs.id == 'desi_outside_him');
    final desiOutsideHer = _fineSets.firstWhere((fs) => fs.id == 'desi_outside_her');
    final dessertHim = _fineSets.firstWhere((fs) => fs.id == 'dessert_him');
    final dessertHer = _fineSets.firstWhere((fs) => fs.id == 'dessert_her');

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
      FineSettings(
        id: 'cold_drink_settings',
        foodType: AppConstants.coldDrink,
        foodTypeEmoji: AppConstants.foodTypeEmojis[AppConstants.coldDrink]!,
        himFineSet: coldDrinkHim,
        herFineSet: coldDrinkHer,
        distributionRules: DistributionRules.defaultRules(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      FineSettings(
        id: 'snacks_settings',
        foodType: AppConstants.snacks,
        foodTypeEmoji: AppConstants.foodTypeEmojis[AppConstants.snacks]!,
        himFineSet: snacksHim,
        herFineSet: snacksHer,
        distributionRules: DistributionRules.defaultRules(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      FineSettings(
        id: 'desi_outside_settings',
        foodType: AppConstants.desiOutside,
        foodTypeEmoji: AppConstants.foodTypeEmojis[AppConstants.desiOutside]!,
        himFineSet: desiOutsideHim,
        herFineSet: desiOutsideHer,
        distributionRules: DistributionRules.defaultRules(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      FineSettings(
        id: 'dessert_settings',
        foodType: AppConstants.dessert,
        foodTypeEmoji: AppConstants.foodTypeEmojis[AppConstants.dessert]!,
        himFineSet: dessertHim,
        herFineSet: dessertHer,
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
      
      // Save to Firebase
      await _repository.saveAllSettings(
        exercises: _exercises,
        fineSets: _fineSets,
        fineSettings: _fineSettings,
      );
      
      // Backup to SharedPreferences
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

}
