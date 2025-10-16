import 'package:equatable/equatable.dart';

class FineSet extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<FineSetExercise> exercises;
  final DateTime createdAt;
  final bool isDefault;

  const FineSet({
    required this.id,
    required this.title,
    required this.description,
    required this.exercises,
    required this.createdAt,
    this.isDefault = false,
  });

  factory FineSet.create({
    required String title,
    required String description,
    required List<FineSetExercise> exercises,
  }) {
    return FineSet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      exercises: exercises,
      createdAt: DateTime.now(),
      isDefault: false,
    );
  }

  factory FineSet.fromJson(Map<String, dynamic> json) {
    return FineSet(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      exercises: (json['exercises'] as List)
          .map((e) => FineSetExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isDefault': isDefault,
    };
  }

  FineSet copyWith({
    String? id,
    String? title,
    String? description,
    List<FineSetExercise>? exercises,
    DateTime? createdAt,
    bool? isDefault,
  }) {
    return FineSet(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      exercises: exercises ?? this.exercises,
      createdAt: createdAt ?? this.createdAt,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  int get totalExercises => exercises.fold(0, (sum, exercise) => sum + exercise.quantity);

  String get exercisesDescription {
    if (exercises.isEmpty) return 'No exercises';
    return exercises.map((e) => '${e.quantity} ${e.exerciseName}').join(' + ');
  }

  @override
  List<Object?> get props => [id, title, description, exercises, createdAt, isDefault];

  @override
  String toString() => '$title: $exercisesDescription';
}

class FineSetExercise extends Equatable {
  final String exerciseId;
  final String exerciseName;
  final String exerciseEmoji;
  final int quantity;

  const FineSetExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.exerciseEmoji,
    required this.quantity,
  });

  factory FineSetExercise.fromJson(Map<String, dynamic> json) {
    return FineSetExercise(
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      exerciseEmoji: json['exerciseEmoji'] as String,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'exerciseEmoji': exerciseEmoji,
      'quantity': quantity,
    };
  }

  FineSetExercise copyWith({
    String? exerciseId,
    String? exerciseName,
    String? exerciseEmoji,
    int? quantity,
  }) {
    return FineSetExercise(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      exerciseEmoji: exerciseEmoji ?? this.exerciseEmoji,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [exerciseId, exerciseName, exerciseEmoji, quantity];

  @override
  String toString() => '$exerciseEmoji $quantity $exerciseName';
}
