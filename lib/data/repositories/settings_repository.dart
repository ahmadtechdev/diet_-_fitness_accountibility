import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise.dart';
import '../models/fine_set.dart';
import '../models/fine_settings.dart';

class SettingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get document reference for settings
  DocumentReference get _settingsDocument {
    return _firestore.collection('couples').doc(_getCurrentCoupleId()).collection('settings').doc('main');
  }
  
  // Helper method to get current couple ID
  String _getCurrentCoupleId() {
    return 'default_couple';
  }
  
  // Get all settings
  Stream<Map<String, dynamic>> getSettings() {
    return _settingsDocument.snapshots().map((doc) {
      if (!doc.exists) {
        return <String, dynamic>{};
      }
      return doc.data() as Map<String, dynamic>;
    });
  }
  
  // Save exercises
  Future<void> saveExercises(List<Exercise> exercises) async {
    try {
      final exercisesJson = exercises.map((e) => e.toJson()).toList();
      await _settingsDocument.set({
        'exercises': exercisesJson,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving exercises: $e');
      rethrow;
    }
  }
  
  // Save fine sets
  Future<void> saveFineSets(List<FineSet> fineSets) async {
    try {
      final fineSetsJson = fineSets.map((fs) => fs.toJson()).toList();
      await _settingsDocument.set({
        'fineSets': fineSetsJson,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving fine sets: $e');
      rethrow;
    }
  }
  
  // Save fine settings
  Future<void> saveFineSettings(List<FineSettings> fineSettings) async {
    try {
      final fineSettingsJson = fineSettings.map((fs) => fs.toJson()).toList();
      await _settingsDocument.set({
        'fineSettings': fineSettingsJson,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving fine settings: $e');
      rethrow;
    }
  }
  
  // Save all settings at once
  Future<void> saveAllSettings({
    required List<Exercise> exercises,
    required List<FineSet> fineSets,
    required List<FineSettings> fineSettings,
  }) async {
    try {
      final exercisesJson = exercises.map((e) => e.toJson()).toList();
      final fineSetsJson = fineSets.map((fs) => fs.toJson()).toList();
      final fineSettingsJson = fineSettings.map((fs) => fs.toJson()).toList();
      
      await _settingsDocument.set({
        'exercises': exercisesJson,
        'fineSets': fineSetsJson,
        'fineSettings': fineSettingsJson,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving all settings: $e');
      rethrow;
    }
  }
  
  // Get all settings as a one-time read
  Future<Map<String, dynamic>> getAllSettingsOnce() async {
    try {
      final doc = await _settingsDocument.get();
      if (!doc.exists) {
        return <String, dynamic>{};
      }
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error getting settings: $e');
      rethrow;
    }
  }
}

