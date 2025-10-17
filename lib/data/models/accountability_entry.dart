import 'package:equatable/equatable.dart';
import '../../core/constants/app_constants.dart';
import 'food_entry.dart' show ExerciseFine, FoodEntry;
import 'fine_settings.dart';

class AccountabilityEntry extends Equatable {
  final String id;
  final DateTime date;
  final String whoAte;
  final String foodType;
  final String foodName;
  final double quantity;
  final ExerciseFine fine;
  final String status;
  final String notes;
  final int weekNumber;
  final bool isCompleted;
  final DateTime? completedAt;
  final String completedBy;
  final bool isFromPartner;

  const AccountabilityEntry({
    required this.id,
    required this.date,
    required this.whoAte,
    required this.foodType,
    required this.foodName,
    required this.quantity,
    required this.fine,
    required this.status,
    required this.notes,
    required this.weekNumber,
    required this.isCompleted,
    this.completedAt,
    required this.completedBy,
    required this.isFromPartner,
  });

  factory AccountabilityEntry.fromFoodEntry({
    required String foodEntryId,
    required DateTime date,
    required String whoAte,
    required String foodType,
    required String foodName,
    required double quantity,
    required ExerciseFine fine,
    required String status,
    required String notes,
    required int weekNumber,
  }) {
    // Split fines between partners
    final splitFine = _splitFineBetweenPartners(fine, whoAte);
    
    return AccountabilityEntry(
      id: '${foodEntryId}_${whoAte == AppConstants.both ? 'both' : whoAte}',
      date: date,
      whoAte: whoAte,
      foodType: foodType,
      foodName: foodName,
      quantity: quantity,
      fine: splitFine,
      status: status,
      notes: notes,
      weekNumber: weekNumber,
      isCompleted: false,
      completedBy: '',
      isFromPartner: whoAte == AppConstants.her, // Mark as from partner if it's "Her"
    );
  }

  // New method using FineSettings
  static List<AccountabilityEntry> createFromFoodEntryWithFineSettings({
    required FoodEntry foodEntry,
    FineSettings? fineSettings,
    List<FoodEntry>? existingEntries, // Add existing entries to check weekly limits
  }) {
    final List<AccountabilityEntry> entries = [];
    
    // Use distributed fines to get proper sharing logic
    final distributedFines = ExerciseFine.createDistributedFines(
      foodEntry.foodType,
      foodEntry.quantity,
      foodEntry.whoAte,
      fineSettings,
      existingEntries: existingEntries,
    );
    
    final himFine = distributedFines['him']!;
    final herFine = distributedFines['her']!;
    
    print('🔍 Accountability Entry Creation Debug:');
    print('   Who Ate: ${foodEntry.whoAte}');
    print('   Him Fine Total: ${himFine.totalExercises}');
    print('   Her Fine Total: ${herFine.totalExercises}');
    
    // Only create entries if there are actual fines to be applied
    if (himFine.totalExercises == 0 && herFine.totalExercises == 0) {
      print('   ✅ NO ACCOUNTABILITY ENTRIES - No fines to apply');
      return entries;
    }
    
    if (foodEntry.whoAte == AppConstants.both) {
      // Create separate entries for both Him and Her
      if (himFine.totalExercises > 0) {
        entries.add(AccountabilityEntry(
          id: '${foodEntry.id}_him',
          date: foodEntry.date,
          whoAte: AppConstants.him,
          foodType: foodEntry.foodType,
          foodName: foodEntry.foodName,
          quantity: foodEntry.quantity,
          fine: himFine,
          status: foodEntry.status,
          notes: foodEntry.notes,
          weekNumber: foodEntry.weekNumber,
          isCompleted: false,
          completedBy: '',
          isFromPartner: false,
        ));
      }
      
      if (herFine.totalExercises > 0) {
        entries.add(AccountabilityEntry(
          id: '${foodEntry.id}_her',
          date: foodEntry.date,
          whoAte: AppConstants.her,
          foodType: foodEntry.foodType,
          foodName: foodEntry.foodName,
          quantity: foodEntry.quantity,
          fine: herFine,
          status: foodEntry.status,
          notes: foodEntry.notes,
          weekNumber: foodEntry.weekNumber,
          isCompleted: false,
          completedBy: '',
          isFromPartner: true,
        ));
      }
    } else {
      // Single person entry - but still use distributed fines for sharing logic
      final personFine = foodEntry.whoAte == AppConstants.him ? himFine : herFine;
      final otherPersonFine = foodEntry.whoAte == AppConstants.him ? herFine : himFine;
      
      // Create entry for the person who ate
      if (personFine.totalExercises > 0) {
        entries.add(AccountabilityEntry(
          id: '${foodEntry.id}_${foodEntry.whoAte}',
          date: foodEntry.date,
          whoAte: foodEntry.whoAte,
          foodType: foodEntry.foodType,
          foodName: foodEntry.foodName,
          quantity: foodEntry.quantity,
          fine: personFine,
          status: foodEntry.status,
          notes: foodEntry.notes,
          weekNumber: foodEntry.weekNumber,
          isCompleted: false,
          completedBy: '',
          isFromPartner: false,
        ));
      }
      
      // Create entry for the other person if they also get a portion of the fine
      if (otherPersonFine.totalExercises > 0) {
        final otherPerson = foodEntry.whoAte == AppConstants.him ? AppConstants.her : AppConstants.him;
        entries.add(AccountabilityEntry(
          id: '${foodEntry.id}_${otherPerson}',
          date: foodEntry.date,
          whoAte: otherPerson,
          foodType: foodEntry.foodType,
          foodName: foodEntry.foodName,
          quantity: foodEntry.quantity,
          fine: otherPersonFine,
          status: foodEntry.status,
          notes: foodEntry.notes,
          weekNumber: foodEntry.weekNumber,
          isCompleted: false,
          completedBy: '',
          isFromPartner: true,
        ));
      }
    }
    
    return entries;
  }

  static ExerciseFine _splitFineBetweenPartners(ExerciseFine originalFine, String whoAte) {
    if (whoAte == AppConstants.both) {
      // If both ate, each person gets half
      return ExerciseFine(
        jumpingRopes: (originalFine.jumpingRopes / 2).round(),
        squats: (originalFine.squats / 2).round(),
        jumpingJacks: (originalFine.jumpingJacks / 2).round(),
        highKnees: (originalFine.highKnees / 2).round(),
        pushups: (originalFine.pushups / 2).round(),
      );
    } else {
      // If one person ate, they get the full fine
      return originalFine;
    }
  }

  AccountabilityEntry markAsCompleted(String completedBy) {
    return copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
      completedBy: completedBy,
    );
  }

  AccountabilityEntry copyWith({
    String? id,
    DateTime? date,
    String? whoAte,
    String? foodType,
    String? foodName,
    int? quantity,
    ExerciseFine? fine,
    String? status,
    String? notes,
    int? weekNumber,
    bool? isCompleted,
    DateTime? completedAt,
    String? completedBy,
    bool? isFromPartner,
  }) {
    return AccountabilityEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      whoAte: whoAte ?? this.whoAte,
      foodType: foodType ?? this.foodType,
      foodName: foodName ?? this.foodName,
      quantity: (quantity ?? this.quantity).toDouble(),
      fine: fine ?? this.fine,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      weekNumber: weekNumber ?? this.weekNumber,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      completedBy: completedBy ?? this.completedBy,
      isFromPartner: isFromPartner ?? this.isFromPartner,
    );
  }

  String get foodTypeEmoji => AppConstants.foodTypeEmojis[foodType] ?? "🍽️";
  String get statusEmoji => AppConstants.statusEmojis[status] ?? "❓";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'whoAte': whoAte,
      'foodType': foodType,
      'foodName': foodName,
      'quantity': quantity,
      'fine': fine.toJson(),
      'status': status,
      'notes': notes,
      'weekNumber': weekNumber,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'completedBy': completedBy,
      'isFromPartner': isFromPartner,
    };
  }

  factory AccountabilityEntry.fromJson(Map<String, dynamic> json) {
    return AccountabilityEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      whoAte: json['whoAte'] as String,
      foodType: json['foodType'] as String,
      foodName: json['foodName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      fine: ExerciseFine.fromJson(json['fine'] as Map<String, dynamic>),
      status: json['status'] as String,
      notes: json['notes'] as String,
      weekNumber: json['weekNumber'] as int,
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      completedBy: json['completedBy'] as String,
      isFromPartner: json['isFromPartner'] as bool,
    );
  }

  @override
  List<Object?> get props => [
        id,
        date,
        whoAte,
        foodType,
        foodName,
        quantity,
        fine,
        status,
        notes,
        weekNumber,
        isCompleted,
        completedAt,
        completedBy,
        isFromPartner,
      ];
}

