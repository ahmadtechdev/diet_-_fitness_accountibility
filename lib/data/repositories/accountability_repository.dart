import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/accountability_entry.dart';

class AccountabilityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get collection reference for accountability entries
  CollectionReference get _accountabilityCollection {
    return _firestore.collection('couples').doc(_getCurrentCoupleId()).collection('accountability_entries');
  }
  
  // Helper method to get current couple ID
  String _getCurrentCoupleId() {
    return 'default_couple';
  }
  
  // Get all accountability entries
  Stream<List<AccountabilityEntry>> getAccountabilityEntries() {
    return _accountabilityCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AccountabilityEntry.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    });
  }
  
  // Get accountability entries for a specific date
  Stream<List<AccountabilityEntry>> getAccountabilityEntriesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    return _accountabilityCollection
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AccountabilityEntry.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    });
  }
  
  // Get accountability entries for a specific week
  Stream<List<AccountabilityEntry>> getAccountabilityEntriesForWeek(int weekNumber) {
    return _accountabilityCollection
        .where('weekNumber', isEqualTo: weekNumber)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AccountabilityEntry.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    });
  }
  
  // Add a new accountability entry
  Future<void> addAccountabilityEntry(AccountabilityEntry entry) async {
    try {
      final data = entry.toJson();
      // Convert DateTime to Timestamp for Firestore
      data['date'] = Timestamp.fromDate(entry.date);
      if (entry.completedAt != null) {
        data['completedAt'] = Timestamp.fromDate(entry.completedAt!);
      }
      
      await _accountabilityCollection.doc(entry.id).set(data);
    } catch (e) {
      print('Error adding accountability entry: $e');
      rethrow;
    }
  }
  
  // Update an accountability entry
  Future<void> updateAccountabilityEntry(AccountabilityEntry entry) async {
    try {
      final data = entry.toJson();
      // Convert DateTime to Timestamp for Firestore
      data['date'] = Timestamp.fromDate(entry.date);
      if (entry.completedAt != null) {
        data['completedAt'] = Timestamp.fromDate(entry.completedAt!);
      }
      
      await _accountabilityCollection.doc(entry.id).update(data);
    } catch (e) {
      print('Error updating accountability entry: $e');
      rethrow;
    }
  }
  
  // Delete an accountability entry
  Future<void> deleteAccountabilityEntry(String entryId) async {
    try {
      await _accountabilityCollection.doc(entryId).delete();
    } catch (e) {
      print('Error deleting accountability entry: $e');
      rethrow;
    }
  }
  
  // Get all accountability entries as a one-time read
  Future<List<AccountabilityEntry>> getAllAccountabilityEntriesOnce() async {
    try {
      final snapshot = await _accountabilityCollection
          .orderBy('date', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return AccountabilityEntry.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    } catch (e) {
      print('Error getting accountability entries: $e');
      rethrow;
    }
  }
}

