import 'package:equatable/equatable.dart';
import 'fine_set.dart';
import 'distribution_rules.dart';

class FineSettings extends Equatable {
  final String id;
  final String foodType;
  final String foodTypeEmoji;
  final FineSet? himFineSet;
  final FineSet? herFineSet;
  final DistributionRules distributionRules;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FineSettings({
    required this.id,
    required this.foodType,
    required this.foodTypeEmoji,
    this.himFineSet,
    this.herFineSet,
    required this.distributionRules,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FineSettings.create({
    required String foodType,
    required String foodTypeEmoji,
    FineSet? himFineSet,
    FineSet? herFineSet,
    DistributionRules? distributionRules,
  }) {
    final now = DateTime.now();
    return FineSettings(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodType: foodType,
      foodTypeEmoji: foodTypeEmoji,
      himFineSet: himFineSet,
      herFineSet: herFineSet,
      distributionRules: distributionRules ?? DistributionRules.defaultRules(),
      createdAt: now,
      updatedAt: now,
    );
  }

  factory FineSettings.fromJson(Map<String, dynamic> json) {
    return FineSettings(
      id: json['id'] as String,
      foodType: json['foodType'] as String,
      foodTypeEmoji: json['foodTypeEmoji'] as String,
      himFineSet: json['himFineSet'] != null 
          ? FineSet.fromJson(json['himFineSet'] as Map<String, dynamic>)
          : null,
      herFineSet: json['herFineSet'] != null 
          ? FineSet.fromJson(json['herFineSet'] as Map<String, dynamic>)
          : null,
      distributionRules: DistributionRules.fromJson(
        json['distributionRules'] as Map<String, dynamic>
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodType': foodType,
      'foodTypeEmoji': foodTypeEmoji,
      'himFineSet': himFineSet?.toJson(),
      'herFineSet': herFineSet?.toJson(),
      'distributionRules': distributionRules.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  FineSettings copyWith({
    String? id,
    String? foodType,
    String? foodTypeEmoji,
    FineSet? himFineSet,
    FineSet? herFineSet,
    DistributionRules? distributionRules,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FineSettings(
      id: id ?? this.id,
      foodType: foodType ?? this.foodType,
      foodTypeEmoji: foodTypeEmoji ?? this.foodTypeEmoji,
      himFineSet: himFineSet ?? this.himFineSet,
      herFineSet: herFineSet ?? this.herFineSet,
      distributionRules: distributionRules ?? this.distributionRules,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id, 
    foodType, 
    foodTypeEmoji, 
    himFineSet, 
    herFineSet, 
    distributionRules, 
    createdAt, 
    updatedAt
  ];
}

