import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelpers {
  // Convert Firestore Timestamp to DateTime
  static DateTime? toDateTime(dynamic value) {
    if (value == null) return null;
    
    if (value is Timestamp) {
      return value.toDate();
    }
    
    if (value is String) {
      return DateTime.parse(value);
    }
    
    if (value is DateTime) {
      return value;
    }
    
    return null;
  }
  
  // Convert DateTime to Firestore Timestamp
  static Timestamp toTimestamp(DateTime date) {
    return Timestamp.fromDate(date);
  }
  
  // Check if value is a Timestamp
  static bool isTimestamp(dynamic value) {
    return value is Timestamp;
  }
}

