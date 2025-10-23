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
                  _buildSummaryRow('Him eats junk:', '${_rules.himEatsMoreThanOnceHimPercentage}% Him, ${_rules.himEatsMoreThanOnceHerPercentage}% Her'),
                  _buildSummaryRow('Her eats junk:', '${_rules.herEatsHerPercentage}% Her, ${_rules.herEatsHimPercentage}% Him'),
                  _buildSummaryRow('Both eat:', '${_rules.bothEatPercentage}% each'),
                ],
              ),
            ),
          ],
        ),
      ),
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
