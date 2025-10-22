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
    List<FoodEntry>? existingEntries, // Add existing entries to check weekly limits
  }) {
    final weekNumber = 1; // Not used anymore since we removed weekly limits
    final fine = ExerciseFine.calculateFromFineSettings(
      foodType, 
      quantity, 
      whoAte, 
      fineSettings,
      existingEntries: existingEntries,
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

  // Helper method to get week number using ISO week standard (Monday start)
  static int _getWeekNumber(DateTime date) {
    // Get the Monday of the week containing the date
    final mondayOfWeek = date.subtract(Duration(days: date.weekday - 1));
    
    // Get the Monday of the first week of the year
    final firstMondayOfYear = DateTime(date.year, 1, 1);
    final firstMonday = firstMondayOfYear.subtract(Duration(days: firstMondayOfYear.weekday - 1));
    
    // Calculate weeks between first Monday and current Monday
    final daysBetween = mondayOfWeek.difference(firstMonday).inDays;
    final weekNumber = (daysBetween / 7).floor() + 1;
    
    return weekNumber;
  }

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
    FineSettings? fineSettings,
    {List<FoodEntry>? existingEntries} // Add existing entries to check weekly limits
  ) {
    // If no fine settings provided, fall back to legacy calculation
    if (fineSettings == null) {
      return ExerciseFine.calculate(foodType, quantity, whoAte);
    }

    // Skip fine calculation for clean food - we only track junk food fines
    if (foodType == AppConstants.clean) {
      return const ExerciseFine(
        jumpingRopes: 0,
        squats: 0,
        jumpingJacks: 0,
        highKnees: 0,
        pushups: 0,
      );
    }

    print('🔍 ULTRA SIMPLIFIED Individual Fine Calculation:');
    print('   Person: $whoAte');
    print('   Food Type: $foodType');
    print('   ⚠️ FINES APPLIED - No limits, always apply fines for junk food');

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
      // Now properly check if it's more than once using existing entries
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

  // ULTRA SIMPLIFIED: Just distribute fines based on who ate - NO LIMITS!
  static Map<String, ExerciseFine> createDistributedFines(
    String foodType,
    double quantity,
    String whoAte,
    FineSettings? fineSettings,
    {List<FoodEntry>? existingEntries}
  ) {
    print('🔍 ULTRA SIMPLIFIED Fine Calculation:');
    print('   Who Ate: $whoAte');
    print('   Food Type: $foodType');
    print('   Quantity: $quantity');

    // Skip clean food
    if (foodType == AppConstants.clean) {
      print('   ✅ NO FINES - Clean food');
      return {
        'him': const ExerciseFine(jumpingRopes: 0, squats: 0, jumpingJacks: 0, highKnees: 0, pushups: 0),
        'her': const ExerciseFine(jumpingRopes: 0, squats: 0, jumpingJacks: 0, highKnees: 0, pushups: 0),
      };
    }

    if (fineSettings == null) {
      print('   ⚠️ NO FINE SETTINGS - Using legacy calculation');
      final baseFine = ExerciseFine.calculate(foodType, quantity, whoAte);
      return {
        'him': baseFine,
        'her': const ExerciseFine(jumpingRopes: 0, squats: 0, jumpingJacks: 0, highKnees: 0, pushups: 0),
      };
    }

    print('   ⚠️ FINES APPLIED - No limits, always apply fines for junk food');

    // Get the base fine set
    FineSet? baseFineSet;
    if (whoAte == AppConstants.him || whoAte == AppConstants.ahmad) {
      baseFineSet = fineSettings.himFineSet;
    } else if (whoAte == AppConstants.her) {
      baseFineSet = fineSettings.herFineSet;
    } else if (whoAte == AppConstants.both) {
      baseFineSet = fineSettings.himFineSet; // Use him's as base for both
    }

    if (baseFineSet == null || baseFineSet.exercises.isEmpty) {
      print('   ⚠️ NO FINE SET CONFIGURED');
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

    for (final exercise in baseFineSet.exercises) {
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

    // Apply distribution rules
    double himPercentage = 0.0;
    double herPercentage = 0.0;

    if (whoAte == AppConstants.him || whoAte == AppConstants.ahmad) {
      // Him ate - use his distribution rules
      himPercentage = fineSettings.distributionRules.himEatsMoreThanOnceHimPercentage / 100.0;
      herPercentage = fineSettings.distributionRules.himEatsMoreThanOnceHerPercentage / 100.0;
    } else if (whoAte == AppConstants.her) {
      // Her ate - use her distribution rules
      himPercentage = fineSettings.distributionRules.herEatsHimPercentage / 100.0;
      herPercentage = fineSettings.distributionRules.herEatsHerPercentage / 100.0;
    } else if (whoAte == AppConstants.both) {
      // Both ate - use both distribution rules
      himPercentage = fineSettings.distributionRules.bothEatPercentage / 100.0;
      herPercentage = fineSettings.distributionRules.bothEatPercentage / 100.0;
    }

    print('   Distribution: Him ${(himPercentage * 100).toInt()}%, Her ${(herPercentage * 100).toInt()}%');
    print('   Base Exercises: JR=$baseJumpingRopes, S=$baseSquats, JJ=$baseJumpingJacks, HK=$baseHighKnees, P=$basePushups');

    // Create distributed fines with proper whole number allocation
    final himFine = ExerciseFine(
      jumpingRopes: _distributeExercises(baseJumpingRopes, himPercentage, herPercentage, true),
      squats: _distributeExercises(baseSquats, himPercentage, herPercentage, true),
      jumpingJacks: _distributeExercises(baseJumpingJacks, himPercentage, herPercentage, true),
      highKnees: _distributeExercises(baseHighKnees, himPercentage, herPercentage, true),
      pushups: _distributeExercises(basePushups, himPercentage, herPercentage, true),
    );

    final herFine = ExerciseFine(
      jumpingRopes: _distributeExercises(baseJumpingRopes, himPercentage, herPercentage, false),
      squats: _distributeExercises(baseSquats, himPercentage, herPercentage, false),
      jumpingJacks: _distributeExercises(baseJumpingJacks, himPercentage, herPercentage, false),
      highKnees: _distributeExercises(baseHighKnees, himPercentage, herPercentage, false),
      pushups: _distributeExercises(basePushups, himPercentage, herPercentage, false),
    );

    print('   Final Fines: Him ${himFine.totalExercises}, Her ${herFine.totalExercises}');

    return {
      'him': himFine,
      'her': herFine,
    };
  }

  // Helper method to distribute exercises with proper whole number allocation
  static int _distributeExercises(int totalExercises, double himPercentage, double herPercentage, bool isForHim) {
    if (totalExercises == 0) return 0;
    
    // Calculate the exact decimal values
    final himExact = totalExercises * himPercentage;
    final herExact = totalExercises * herPercentage;
    
    // Round to get whole numbers
    final himRounded = himExact.round();
    final herRounded = herExact.round();
    
    print('     Exercise Distribution: Total=$totalExercises, Him=${himExact.toStringAsFixed(1)}→$himRounded, Her=${herExact.toStringAsFixed(1)}→$herRounded');
    
    // If the sum of rounded values equals the total, we're good
    if (himRounded + herRounded == totalExercises) {
      final result = isForHim ? himRounded : herRounded;
      print('     ✅ Perfect distribution: ${isForHim ? 'Him' : 'Her'} gets $result');
      return result;
    }
    
    // If the sum is less than total, distribute the remainder
    if (himRounded + herRounded < totalExercises) {
      final remainder = totalExercises - (himRounded + herRounded);
      print('     📈 Adding remainder $remainder to higher percentage person');
      // Give the remainder to the person with the higher percentage
      if (isForHim && himPercentage >= herPercentage) {
        final result = himRounded + remainder;
        print('     ✅ Him gets remainder: $himRounded + $remainder = $result');
        return result;
      } else if (!isForHim && herPercentage > himPercentage) {
        final result = herRounded + remainder;
        print('     ✅ Her gets remainder: $herRounded + $remainder = $result');
        return result;
      } else {
        final result = isForHim ? himRounded : herRounded;
        print('     ✅ ${isForHim ? 'Him' : 'Her'} gets original: $result');
        return result;
      }
    }
    
    // If the sum is more than total, adjust by reducing the person with lower percentage
    if (himRounded + herRounded > totalExercises) {
      final excess = (himRounded + herRounded) - totalExercises;
      print('     📉 Reducing excess $excess from lower percentage person');
      if (isForHim && himPercentage <= herPercentage) {
        final result = (himRounded - excess).clamp(0, totalExercises);
        print('     ✅ Him reduced: $himRounded - $excess = $result');
        return result;
      } else if (!isForHim && herPercentage < himPercentage) {
        final result = (herRounded - excess).clamp(0, totalExercises);
        print('     ✅ Her reduced: $herRounded - $excess = $result');
        return result;
      } else {
        final result = isForHim ? himRounded : herRounded;
        print('     ✅ ${isForHim ? 'Him' : 'Her'} gets original: $result');
        return result;
      }
    }
    
    final result = isForHim ? himRounded : herRounded;
    print('     ✅ Default: ${isForHim ? 'Him' : 'Her'} gets $result');
    return result;
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
