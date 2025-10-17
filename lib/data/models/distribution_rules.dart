import 'package:equatable/equatable.dart';

class DistributionRules extends Equatable {
  final int himEatsMoreThanOnceHimPercentage; // 70%
  final int himEatsMoreThanOnceHerPercentage; // 30%
  final int herEatsHimPercentage; // 40%
  final int herEatsHerPercentage; // 60%
  final int bothEatPercentage; // 50% each
  
  // Weekly meal limits
  final int himWeeklyJunkMealLimit;
  final int herWeeklyJunkMealLimit;
  
  // Reward system
  final bool rewardSystemEnabled;
  final int junkFreeWeekReward; // Extra meals allowed after junk-free week
  final int rewardExpiryDays; // How long the reward lasts
  
  // Current reward meals available
  final int himCurrentRewardMeals; // Current reward meals available for him
  final int herCurrentRewardMeals; // Current reward meals available for her

  const DistributionRules({
    required this.himEatsMoreThanOnceHimPercentage,
    required this.himEatsMoreThanOnceHerPercentage,
    required this.herEatsHimPercentage,
    required this.herEatsHerPercentage,
    required this.bothEatPercentage,
    required this.himWeeklyJunkMealLimit,
    required this.herWeeklyJunkMealLimit,
    required this.rewardSystemEnabled,
    required this.junkFreeWeekReward,
    required this.rewardExpiryDays,
    required this.himCurrentRewardMeals,
    required this.herCurrentRewardMeals,
  });

  factory DistributionRules.defaultRules() {
    return const DistributionRules(
      himEatsMoreThanOnceHimPercentage: 70,
      himEatsMoreThanOnceHerPercentage: 30,
      herEatsHimPercentage: 40,
      herEatsHerPercentage: 60,
      bothEatPercentage: 50,
      himWeeklyJunkMealLimit: 1,
      herWeeklyJunkMealLimit: 1,
      rewardSystemEnabled: true,
      junkFreeWeekReward: 1,
      rewardExpiryDays: 7,
      himCurrentRewardMeals: 0,
      herCurrentRewardMeals: 0,
    );
  }

  factory DistributionRules.fromJson(Map<String, dynamic> json) {
    return DistributionRules(
      himEatsMoreThanOnceHimPercentage: json['himEatsMoreThanOnceHimPercentage'] as int,
      himEatsMoreThanOnceHerPercentage: json['himEatsMoreThanOnceHerPercentage'] as int,
      herEatsHimPercentage: json['herEatsHimPercentage'] as int,
      herEatsHerPercentage: json['herEatsHerPercentage'] as int,
      bothEatPercentage: json['bothEatPercentage'] as int,
      himWeeklyJunkMealLimit: json['himWeeklyJunkMealLimit'] as int? ?? 1,
      herWeeklyJunkMealLimit: json['herWeeklyJunkMealLimit'] as int? ?? 1,
      rewardSystemEnabled: json['rewardSystemEnabled'] as bool? ?? true,
      junkFreeWeekReward: json['junkFreeWeekReward'] as int? ?? 1,
      rewardExpiryDays: json['rewardExpiryDays'] as int? ?? 7,
      himCurrentRewardMeals: json['himCurrentRewardMeals'] as int? ?? 0,
      herCurrentRewardMeals: json['herCurrentRewardMeals'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'himEatsMoreThanOnceHimPercentage': himEatsMoreThanOnceHimPercentage,
      'himEatsMoreThanOnceHerPercentage': himEatsMoreThanOnceHerPercentage,
      'herEatsHimPercentage': herEatsHimPercentage,
      'herEatsHerPercentage': herEatsHerPercentage,
      'bothEatPercentage': bothEatPercentage,
      'himWeeklyJunkMealLimit': himWeeklyJunkMealLimit,
      'herWeeklyJunkMealLimit': herWeeklyJunkMealLimit,
      'rewardSystemEnabled': rewardSystemEnabled,
      'junkFreeWeekReward': junkFreeWeekReward,
      'rewardExpiryDays': rewardExpiryDays,
      'himCurrentRewardMeals': himCurrentRewardMeals,
      'herCurrentRewardMeals': herCurrentRewardMeals,
    };
  }

  DistributionRules copyWith({
    int? himEatsMoreThanOnceHimPercentage,
    int? himEatsMoreThanOnceHerPercentage,
    int? herEatsHimPercentage,
    int? herEatsHerPercentage,
    int? bothEatPercentage,
    int? himWeeklyJunkMealLimit,
    int? herWeeklyJunkMealLimit,
    bool? rewardSystemEnabled,
    int? junkFreeWeekReward,
    int? rewardExpiryDays,
    int? himCurrentRewardMeals,
    int? herCurrentRewardMeals,
  }) {
    return DistributionRules(
      himEatsMoreThanOnceHimPercentage: himEatsMoreThanOnceHimPercentage ?? this.himEatsMoreThanOnceHimPercentage,
      himEatsMoreThanOnceHerPercentage: himEatsMoreThanOnceHerPercentage ?? this.himEatsMoreThanOnceHerPercentage,
      herEatsHimPercentage: herEatsHimPercentage ?? this.herEatsHimPercentage,
      herEatsHerPercentage: herEatsHerPercentage ?? this.herEatsHerPercentage,
      bothEatPercentage: bothEatPercentage ?? this.bothEatPercentage,
      himWeeklyJunkMealLimit: himWeeklyJunkMealLimit ?? this.himWeeklyJunkMealLimit,
      herWeeklyJunkMealLimit: herWeeklyJunkMealLimit ?? this.herWeeklyJunkMealLimit,
      rewardSystemEnabled: rewardSystemEnabled ?? this.rewardSystemEnabled,
      junkFreeWeekReward: junkFreeWeekReward ?? this.junkFreeWeekReward,
      rewardExpiryDays: rewardExpiryDays ?? this.rewardExpiryDays,
      himCurrentRewardMeals: himCurrentRewardMeals ?? this.himCurrentRewardMeals,
      herCurrentRewardMeals: herCurrentRewardMeals ?? this.herCurrentRewardMeals,
    );
  }

  @override
  List<Object?> get props => [
    himEatsMoreThanOnceHimPercentage,
    himEatsMoreThanOnceHerPercentage,
    herEatsHimPercentage,
    herEatsHerPercentage,
    bothEatPercentage,
    himWeeklyJunkMealLimit,
    herWeeklyJunkMealLimit,
    rewardSystemEnabled,
    junkFreeWeekReward,
    rewardExpiryDays,
    himCurrentRewardMeals,
    herCurrentRewardMeals,
  ];
}
