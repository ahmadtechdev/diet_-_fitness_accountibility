import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../data/models/fine_settings.dart';
import '../../data/models/distribution_rules.dart';
import '../../core/constants/app_constants.dart';

class FineDistributionSection extends StatelessWidget {
  const FineDistributionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              const Icon(Icons.percent, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Fine Distribution Rules',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Distribution Rules
        Expanded(
          child: Obx(() {
            if (controller.fineSettings.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.percent, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No fine settings found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      'Configure fine settings first',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              itemCount: controller.fineSettings.length,
              itemBuilder: (context, index) {
                final fineSetting = controller.fineSettings[index];
                return _FineDistributionCard(
                  fineSetting: fineSetting,
                  onUpdate: (updatedSetting) {
                    controller.updateFineSettings(updatedSetting);
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

class _FineDistributionCard extends StatefulWidget {
  final FineSettings fineSetting;
  final Function(FineSettings) onUpdate;

  const _FineDistributionCard({
    required this.fineSetting,
    required this.onUpdate,
  });

  @override
  State<_FineDistributionCard> createState() => _FineDistributionCardState();
}

class _FineDistributionCardState extends State<_FineDistributionCard> {
  late DistributionRules _rules;

  @override
  void initState() {
    super.initState();
    _rules = widget.fineSetting.distributionRules;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  widget.fineSetting.foodTypeEmoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.fineSetting.foodType,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Weekly Meal Limits
            _buildWeeklyMealLimits(),
            
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            
            // Distribution Rules
            _buildDistributionRule(
              context,
              'Him eats junk (>limit/week)',
              'Him gets',
              _rules.himEatsMoreThanOnceHimPercentage.toDouble(),
              (value) {
                setState(() {
                  _rules = _rules.copyWith(
                    himEatsMoreThanOnceHimPercentage: value.round(),
                    himEatsMoreThanOnceHerPercentage: (100 - value).round(),
                  );
                });
                _saveChanges();
              },
              Colors.blue,
            ),
            
            _buildDistributionRule(
              context,
              'Her eats junk',
              'Her gets',
              _rules.herEatsHerPercentage.toDouble(),
              (value) {
                setState(() {
                  _rules = _rules.copyWith(
                    herEatsHerPercentage: value.round(),
                    herEatsHimPercentage: (100 - value).round(),
                  );
                });
                _saveChanges();
              },
              Colors.pink,
            ),
            
            _buildDistributionRule(
              context,
              'Both eat together',
              'Each gets',
              _rules.bothEatPercentage.toDouble(),
              (value) {
                setState(() {
                  _rules = _rules.copyWith(bothEatPercentage: value.round());
                });
                _saveChanges();
              },
              Colors.purple,
            ),
            
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            
            // Reward System
            _buildRewardSystem(),
            
            const SizedBox(height: 16),
            
            // Summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Summary:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Weekly Limits:', 'Him: ${_rules.himWeeklyJunkMealLimit}, Her: ${_rules.herWeeklyJunkMealLimit}'),
                  _buildSummaryRow('Him eats >limit/week:', '${_rules.himEatsMoreThanOnceHimPercentage}% Him, ${_rules.himEatsMoreThanOnceHerPercentage}% Her'),
                  _buildSummaryRow('Her eats:', '${_rules.herEatsHerPercentage}% Her, ${_rules.herEatsHimPercentage}% Him'),
                  _buildSummaryRow('Both eat:', '${_rules.bothEatPercentage}% each'),
                  if (_rules.rewardSystemEnabled)
                    _buildSummaryRow('Reward System:', '${_rules.junkFreeWeekReward} extra meals for ${_rules.rewardExpiryDays} days'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyMealLimits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Junk Meal Limits',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Him's limit
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.male, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Him',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Meals per week',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            controller: TextEditingController(text: _rules.himWeeklyJunkMealLimit.toString()),
                            onChanged: (value) {
                              final intValue = int.tryParse(value) ?? 1;
                              if (intValue >= 0 && intValue <= 7) {
                                setState(() {
                                  _rules = _rules.copyWith(himWeeklyJunkMealLimit: intValue);
                                });
                                _saveChanges();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Her's limit
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.pink.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.female, color: Colors.pink, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Her',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Meals per week',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            controller: TextEditingController(text: _rules.herWeeklyJunkMealLimit.toString()),
                            onChanged: (value) {
                              final intValue = int.tryParse(value) ?? 1;
                              if (intValue >= 0 && intValue <= 7) {
                                setState(() {
                                  _rules = _rules.copyWith(herWeeklyJunkMealLimit: intValue);
                                });
                                _saveChanges();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRewardSystem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.card_giftcard, color: Colors.orange, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Reward System',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Switch(
              value: _rules.rewardSystemEnabled,
              onChanged: (value) {
                setState(() {
                  _rules = _rules.copyWith(rewardSystemEnabled: value);
                });
                _saveChanges();
              },
              activeColor: Colors.orange,
            ),
          ],
        ),
        if (_rules.rewardSystemEnabled) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Extra meals after junk-free week',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        controller: TextEditingController(text: _rules.junkFreeWeekReward.toString()),
                        onChanged: (value) {
                          final intValue = int.tryParse(value) ?? 1;
                          if (intValue >= 0 && intValue <= 3) {
                            setState(() {
                              _rules = _rules.copyWith(junkFreeWeekReward: intValue);
                            });
                            _saveChanges();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Reward expires (days)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        controller: TextEditingController(text: _rules.rewardExpiryDays.toString()),
                        onChanged: (value) {
                          final intValue = int.tryParse(value) ?? 7;
                          if (intValue >= 1 && intValue <= 14) {
                            setState(() {
                              _rules = _rules.copyWith(rewardExpiryDays: intValue);
                            });
                            _saveChanges();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '💡 If someone has a junk-free week, they get extra meals as a reward!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDistributionRule(
    BuildContext context,
    String title,
    String label,
    double value,
    Function(double) onChanged,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('$label: '),
            Text(
              '${value.round()}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const Spacer(),
            Text(
              '${(100 - value).round()}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                min: 0,
                max: 100,
                divisions: 100,
                activeColor: color,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 60,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  suffixText: '%',
                ),
                controller: TextEditingController(text: value.round().toString()),
                onChanged: (text) {
                  final intValue = int.tryParse(text) ?? 0;
                  if (intValue >= 0 && intValue <= 100) {
                    onChanged(intValue.toDouble());
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    final updatedSetting = widget.fineSetting.copyWith(
      distributionRules: _rules,
    );
    widget.onUpdate(updatedSetting);
  }
}
