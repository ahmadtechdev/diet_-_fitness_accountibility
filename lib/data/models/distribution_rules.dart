import 'package:equatable/equatable.dart';

class DistributionRules extends Equatable {
  final int himEatsMoreThanOnceHimPercentage; // 70%
  final int himEatsMoreThanOnceHerPercentage; // 30%
  final int herEatsHimPercentage; // 40%
  final int herEatsHerPercentage; // 60%
  final int bothEatPercentage; // 50% each

  const DistributionRules({
    required this.himEatsMoreThanOnceHimPercentage,
    required this.himEatsMoreThanOnceHerPercentage,
    required this.herEatsHimPercentage,
    required this.herEatsHerPercentage,
    required this.bothEatPercentage,
  });

  factory DistributionRules.defaultRules() {
    return const DistributionRules(
      himEatsMoreThanOnceHimPercentage: 70,
      himEatsMoreThanOnceHerPercentage: 30,
      herEatsHimPercentage: 40,
      herEatsHerPercentage: 60,
      bothEatPercentage: 50,
    );
  }

  factory DistributionRules.fromJson(Map<String, dynamic> json) {
    return DistributionRules(
      himEatsMoreThanOnceHimPercentage: json['himEatsMoreThanOnceHimPercentage'] as int,
      himEatsMoreThanOnceHerPercentage: json['himEatsMoreThanOnceHerPercentage'] as int,
      herEatsHimPercentage: json['herEatsHimPercentage'] as int,
      herEatsHerPercentage: json['herEatsHerPercentage'] as int,
      bothEatPercentage: json['bothEatPercentage'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'himEatsMoreThanOnceHimPercentage': himEatsMoreThanOnceHimPercentage,
      'himEatsMoreThanOnceHerPercentage': himEatsMoreThanOnceHerPercentage,
      'herEatsHimPercentage': herEatsHimPercentage,
      'herEatsHerPercentage': herEatsHerPercentage,
      'bothEatPercentage': bothEatPercentage,
    };
  }

  DistributionRules copyWith({
    int? himEatsMoreThanOnceHimPercentage,
    int? himEatsMoreThanOnceHerPercentage,
    int? herEatsHimPercentage,
    int? herEatsHerPercentage,
    int? bothEatPercentage,
  }) {
    return DistributionRules(
      himEatsMoreThanOnceHimPercentage: himEatsMoreThanOnceHimPercentage ?? this.himEatsMoreThanOnceHimPercentage,
      himEatsMoreThanOnceHerPercentage: himEatsMoreThanOnceHerPercentage ?? this.himEatsMoreThanOnceHerPercentage,
      herEatsHimPercentage: herEatsHimPercentage ?? this.herEatsHimPercentage,
      herEatsHerPercentage: herEatsHerPercentage ?? this.herEatsHerPercentage,
      bothEatPercentage: bothEatPercentage ?? this.bothEatPercentage,
    );
  }

  @override
  List<Object?> get props => [
    himEatsMoreThanOnceHimPercentage,
    himEatsMoreThanOnceHerPercentage,
    herEatsHimPercentage,
    herEatsHerPercentage,
    bothEatPercentage,
  ];
}
