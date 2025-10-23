import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_entry.dart';

class FoodEntriesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get collection reference for food entries
  CollectionReference get _foodEntriesCollection {
    return _firestore.collection('couples').doc(_getCurrentCoupleId()).collection('food_entries');
  }
  
  // Helper method to get current couple ID (you can enhance this with actual user management)
  String _getCurrentCoupleId() {
    // For now, we'll use a default couple ID
    // In a real app, this would come from authenticated user
    return 'default_couple';
  }
  
  // Get all food entries
  Stream<List<FoodEntry>> getFoodEntries() {
    return _foodEntriesCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FoodEntry.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    });
  }
  
  // Get food entries for a specific date
  Stream<List<FoodEntry>> getFoodEntriesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    return _foodEntriesCollection
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FoodEntry.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    });
  }
  
  // Get food entries for a specific week
  Stream<List<FoodEntry>> getFoodEntriesForWeek(int weekNumber) {
    return _foodEntriesCollection
        .where('weekNumber', isEqualTo: weekNumber)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FoodEntry.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    });
  }
  
  // Add a new food entry
  Future<void> addFoodEntry(FoodEntry entry) async {
    try {
      final data = entry.toJson();
      // Convert DateTime to Timestamp for Firestore
      data['date'] = Timestamp.fromDate(entry.date);
      
      await _foodEntriesCollection.doc(entry.id).set(data);
    } catch (e) {
      print('Error adding food entry: $e');
      rethrow;
    }
  }
  
  // Update a food entry
  Future<void> updateFoodEntry(FoodEntry entry) async {
    try {
      final data = entry.toJson();
      // Convert DateTime to Timestamp for Firestore
      data['date'] = Timestamp.fromDate(entry.date);
      
      await _foodEntriesCollection.doc(entry.id).update(data);
    } catch (e) {
      print('Error updating food entry: $e');
      rethrow;
    }
  }
  
  // Delete a food entry
  Future<void> deleteFoodEntry(String entryId) async {
    try {
      await _foodEntriesCollection.doc(entryId).delete();
    } catch (e) {
      print('Error deleting food entry: $e');
      rethrow;
    }
  }
  
  // Get all food entries as a one-time read (for initial load or migration)
  Future<List<FoodEntry>> getAllFoodEntriesOnce() async {
    try {
      final snapshot = await _foodEntriesCollection
          .orderBy('date', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return FoodEntry.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    } catch (e) {
      print('Error getting food entries: $e');
      rethrow;
    }
  }
}

