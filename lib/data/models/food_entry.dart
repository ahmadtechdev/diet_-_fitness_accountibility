import 'package:equatable/equatable.dart';
import '../../core/constants/app_constants.dart';
import 'fine_set.dart';
import 'fine_settings.dart';

class FoodEntry extends Equatable {
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

  const FoodEntry({
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
  });

  factory FoodEntry.create({
    required DateTime date,
    required String whoAte,
    required String foodType,
    required String foodName,
    required double quantity,
    String notes = '',
    FineSettings? fineSettings,
  }) {
    final weekNumber = _getWeekNumber(date);
    final fine = ExerciseFine.calculateFromFineSettings(
      foodType, 
      quantity, 
      whoAte, 
      fineSettings
    );
    final status = _getStatus(foodType);
    
    return FoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: date,
      whoAte: whoAte,
      foodType: foodType,
      foodName: foodName,
      quantity: quantity,
      fine: fine,
      status: status,
      notes: notes,
      weekNumber: weekNumber,
    );
  }

  static int _getWeekNumber(DateTime date) {
    // Get the week number of the year
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).floor() + 1;
  }

  static String _getStatus(String foodType) {
    switch (foodType) {
      case AppConstants.clean:
        return AppConstants.cleanDay;
      default:
        return AppConstants.junkFine;
    }
  }

  String get foodTypeEmoji => AppConstants.foodTypeEmojis[foodType] ?? "🍽️";
  String get statusEmoji => AppConstants.statusEmojis[status] ?? "❓";

  FoodEntry copyWith({
    String? id,
    DateTime? date,
    String? whoAte,
    String? foodType,
    String? foodName,
    double? quantity,
    ExerciseFine? fine,
    String? status,
    String? notes,
    int? weekNumber,
  }) {
    return FoodEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      whoAte: whoAte ?? this.whoAte,
      foodType: foodType ?? this.foodType,
      foodName: foodName ?? this.foodName,
      quantity: quantity ?? this.quantity,
      fine: fine ?? this.fine,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      weekNumber: weekNumber ?? this.weekNumber,
    );
  }

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
    };
  }

  factory FoodEntry.fromJson(Map<String, dynamic> json) {
    return FoodEntry(
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
      ];
}

class ExerciseFine extends Equatable {
  final int jumpingRopes;
  final int squats;
  final int jumpingJacks;
  final int highKnees;
  final int pushups;

  const ExerciseFine({
    required this.jumpingRopes,
    required this.squats,
    required this.jumpingJacks,
    required this.highKnees,
    required this.pushups,
  });

  // Legacy method for backward compatibility
  factory ExerciseFine.calculate(String foodType, double quantity, String whoAte) {
    final baseFine = AppConstants.fineStructure[foodType] ?? {
      AppConstants.jumpingRopes: 0,
      AppConstants.squats: 0,
      AppConstants.jumpingJacks: 0,
      AppConstants.highKnees: 0,
      AppConstants.pushups: 0,
    };

    // If both ate, each person does half
    final multiplier = whoAte == AppConstants.both ? 0.5 : 1.0;

    return ExerciseFine(
      jumpingRopes: (baseFine[AppConstants.jumpingRopes]! * quantity * multiplier).round(),
      squats: (baseFine[AppConstants.squats]! * quantity * multiplier).round(),
      jumpingJacks: (baseFine[AppConstants.jumpingJacks]! * quantity * multiplier).round(),
      highKnees: (baseFine[AppConstants.highKnees]! * quantity * multiplier).round(),
      pushups: (baseFine[AppConstants.pushups]! * quantity * multiplier).round(),
    );
  }

  // New method using FineSettings
  factory ExerciseFine.calculateFromFineSettings(
    String foodType, 
    double quantity, 
    String whoAte, 
    FineSettings? fineSettings
  ) {
    // If no fine settings provided, fall back to legacy calculation
    if (fineSettings == null) {
      return ExerciseFine.calculate(foodType, quantity, whoAte);
    }

    // Determine which fine set to use based on who ate
    FineSet? selectedFineSet;
    double himPercentage = 0.0;
    double herPercentage = 0.0;

    if (whoAte == AppConstants.both) {
      // Both ate - 50/50 split
      himPercentage = fineSettings.distributionRules.bothEatPercentage / 100.0;
      herPercentage = fineSettings.distributionRules.bothEatPercentage / 100.0;
      selectedFineSet = fineSettings.himFineSet; // Use him's fine set as base
    } else if (whoAte == AppConstants.him || whoAte == AppConstants.ahmad) {
      // Him ate - check if more than once this week
      // For now, assume it's more than once (you can add week tracking logic later)
      himPercentage = fineSettings.distributionRules.himEatsMoreThanOnceHimPercentage / 100.0;
      herPercentage = fineSettings.distributionRules.himEatsMoreThanOnceHerPercentage / 100.0;
      selectedFineSet = fineSettings.himFineSet;
    } else if (whoAte == AppConstants.her) {
      // Her ate
      himPercentage = fineSettings.distributionRules.herEatsHimPercentage / 100.0;
      herPercentage = fineSettings.distributionRules.herEatsHerPercentage / 100.0;
      selectedFineSet = fineSettings.herFineSet;
    }

    // If no fine set is configured, return zero fine
    if (selectedFineSet == null || selectedFineSet.exercises.isEmpty) {
      return const ExerciseFine(
        jumpingRopes: 0,
        squats: 0,
        jumpingJacks: 0,
        highKnees: 0,
        pushups: 0,
      );
    }

    // Calculate fines based on the selected fine set
    int jumpingRopes = 0;
    int squats = 0;
    int jumpingJacks = 0;
    int highKnees = 0;
    int pushups = 0;

    for (final exercise in selectedFineSet.exercises) {
      final totalQuantity = exercise.quantity * quantity;
      
      // Apply percentage based on who ate
      final finalQuantity = whoAte == AppConstants.both 
          ? (totalQuantity * 0.5).round() // 50/50 split
          : (whoAte == AppConstants.him || whoAte == AppConstants.ahmad)
              ? (totalQuantity * himPercentage).round()
              : (totalQuantity * herPercentage).round();

      // Map exercise names to the legacy structure
      switch (exercise.exerciseName.toLowerCase()) {
        case 'jumping rope':
        case 'jumping ropes':
          jumpingRopes += finalQuantity;
          break;
        case 'squat':
        case 'squats':
          squats += finalQuantity;
          break;
        case 'jumping jack':
        case 'jumping jacks':
          jumpingJacks += finalQuantity;
          break;
        case 'high knee':
        case 'high knees':
          highKnees += finalQuantity;
          break;
        case 'pushup':
        case 'pushups':
          pushups += finalQuantity;
          break;
      }
    }

    return ExerciseFine(
      jumpingRopes: jumpingRopes,
      squats: squats,
      jumpingJacks: jumpingJacks,
      highKnees: highKnees,
      pushups: pushups,
    );
  }

  // Method to create distributed fines for Him and Her
  static Map<String, ExerciseFine> createDistributedFines(
    String foodType,
    double quantity,
    String whoAte,
    FineSettings? fineSettings,
  ) {
    if (fineSettings == null) {
      final baseFine = ExerciseFine.calculate(foodType, quantity, whoAte);
      return {
        'him': baseFine,
        'her': const ExerciseFine(jumpingRopes: 0, squats: 0, jumpingJacks: 0, highKnees: 0, pushups: 0),
      };
    }

    // Determine which fine set to use based on who ate
    FineSet? selectedFineSet;
    double himPercentage = 0.0;
    double herPercentage = 0.0;

    if (whoAte == AppConstants.both) {
      // Both ate - 50/50 split
      himPercentage = fineSettings.distributionRules.bothEatPercentage / 100.0;
      herPercentage = fineSettings.distributionRules.bothEatPercentage / 100.0;
      selectedFineSet = fineSettings.himFineSet; // Use him's fine set as base
    } else if (whoAte == AppConstants.him || whoAte == AppConstants.ahmad) {
      // Him ate - check if more than once this week
      // For now, assume it's more than once (you can add week tracking logic later)
      himPercentage = fineSettings.distributionRules.himEatsMoreThanOnceHimPercentage / 100.0;
      herPercentage = fineSettings.distributionRules.himEatsMoreThanOnceHerPercentage / 100.0;
      selectedFineSet = fineSettings.himFineSet;
    } else if (whoAte == AppConstants.her) {
      // Her ate
      himPercentage = fineSettings.distributionRules.herEatsHimPercentage / 100.0;
      herPercentage = fineSettings.distributionRules.herEatsHerPercentage / 100.0;
      selectedFineSet = fineSettings.herFineSet;
    }

    // If no fine set is configured, return zero fines
    if (selectedFineSet == null || selectedFineSet.exercises.isEmpty) {
      return {
        'him': const ExerciseFine(jumpingRopes: 0, squats: 0, jumpingJacks: 0, highKnees: 0, pushups: 0),
        'her': const ExerciseFine(jumpingRopes: 0, squats: 0, jumpingJacks: 0, highKnees: 0, pushups: 0),
      };
    }

    // Calculate base exercises
    int baseJumpingRopes = 0;
    int baseSquats = 0;
    int baseJumpingJacks = 0;
    int baseHighKnees = 0;
    int basePushups = 0;

    for (final exercise in selectedFineSet.exercises) {
      final finalQuantity = (exercise.quantity * quantity).round();
      
      switch (exercise.exerciseId.toLowerCase()) {
        case 'jumping_rope':
        case 'jumping_ropes':
          baseJumpingRopes += finalQuantity;
          break;
        case 'squat':
        case 'squats':
          baseSquats += finalQuantity;
          break;
        case 'jumping_jack':
        case 'jumping_jacks':
          baseJumpingJacks += finalQuantity;
          break;
        case 'high_knee':
        case 'high_knees':
          baseHighKnees += finalQuantity;
          break;
        case 'pushup':
        case 'pushups':
          basePushups += finalQuantity;
          break;
      }
    }

    // Distribute exercises according to percentages
    final himFine = ExerciseFine(
      jumpingRopes: (baseJumpingRopes * himPercentage).round(),
      squats: (baseSquats * himPercentage).round(),
      jumpingJacks: (baseJumpingJacks * himPercentage).round(),
      highKnees: (baseHighKnees * himPercentage).round(),
      pushups: (basePushups * himPercentage).round(),
    );

    final herFine = ExerciseFine(
      jumpingRopes: (baseJumpingRopes * herPercentage).round(),
      squats: (baseSquats * herPercentage).round(),
      jumpingJacks: (baseJumpingJacks * herPercentage).round(),
      highKnees: (baseHighKnees * herPercentage).round(),
      pushups: (basePushups * herPercentage).round(),
    );

    return {
      'him': himFine,
      'her': herFine,
    };
  }

  int get totalExercises => jumpingRopes + squats + jumpingJacks + highKnees + pushups;

  String get description {
    final exercises = <String>[];
    
    if (jumpingRopes > 0) exercises.add('$jumpingRopes JR');
    if (squats > 0) exercises.add('$squats SQ');
    if (jumpingJacks > 0) exercises.add('$jumpingJacks JJ');
    if (highKnees > 0) exercises.add('$highKnees HN');
    if (pushups > 0) exercises.add('$pushups PU');
    
    return exercises.isEmpty ? 'No exercises' : exercises.join(' + ');
  }

  Map<String, dynamic> toJson() {
    return {
      'jumpingRopes': jumpingRopes,
      'squats': squats,
      'jumpingJacks': jumpingJacks,
      'highKnees': highKnees,
      'pushups': pushups,
    };
  }

  factory ExerciseFine.fromJson(Map<String, dynamic> json) {
    return ExerciseFine(
      jumpingRopes: json['jumpingRopes'] as int,
      squats: json['squats'] as int,
      jumpingJacks: json['jumpingJacks'] as int,
      highKnees: json['highKnees'] as int,
      pushups: json['pushups'] as int,
    );
  }

  @override
  List<Object?> get props => [jumpingRopes, squats, jumpingJacks, highKnees, pushups];
}
