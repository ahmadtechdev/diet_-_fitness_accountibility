import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String id;
  final String name;
  final String unit;
  final String emoji;
  final DateTime createdAt;
  final bool isDefault;

  const Exercise({
    required this.id,
    required this.name,
    required this.unit,
    required this.emoji,
    required this.createdAt,
    this.isDefault = false,
  });

  factory Exercise.create({
    required String name,
    required String unit,
    required String emoji,
  }) {
    return Exercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      unit: unit,
      emoji: emoji,
      createdAt: DateTime.now(),
      isDefault: false,
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String,
      emoji: json['emoji'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'emoji': emoji,
      'createdAt': createdAt.toIso8601String(),
      'isDefault': isDefault,
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? unit,
    String? emoji,
    DateTime? createdAt,
    bool? isDefault,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      emoji: emoji ?? this.emoji,
      createdAt: createdAt ?? this.createdAt,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [id, name, unit, emoji, createdAt, isDefault];

  @override
  String toString() => '$emoji $name ($unit)';
}
