import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../data/models/fine_settings.dart';
import '../../data/models/distribution_rules.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/colors.dart';

class FineDistributionSection extends StatelessWidget {
  const FineDistributionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.romanticGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.textOnPrimary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.percent,
                        size: 24,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fine Distribution Rules',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Configure how fines are distributed between partners',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textOnPrimary.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: AppColors.textOnPrimary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Default: Him gets 20% when he fines her, Her gets 30% when she fines him',
                              style: TextStyle(
                                color: AppColors.textOnPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
    ));
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
      margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryPink.withOpacity(0.1), AppColors.secondaryBlue.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.romanticGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowLight,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.fineSetting.foodTypeEmoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.fineSetting.foodType,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Distribution Settings',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryLight.withOpacity(0.3), AppColors.secondaryBlue.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryPink.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPink.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.summarize,
                          color: AppColors.primaryPink,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Distribution Summary',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
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
              Expanded(
                child:                 Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '$label: ',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
                ),
              ),
              Text(
                '${value.round()}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                '${(100 - value).round()}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6) ?? Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: color,
                    inactiveTrackColor: color.withOpacity(0.3),
                    thumbColor: color,
                    overlayColor: color.withOpacity(0.2),
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                  ),
                  child: Slider(
                    value: value,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    onChanged: (newValue) {
                      onChanged(newValue);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 70,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withOpacity(0.5)),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    suffixText: '%',
                    suffixStyle: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
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
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
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
