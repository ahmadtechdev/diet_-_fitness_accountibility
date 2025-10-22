import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../data/models/fine_settings.dart';
import '../../data/models/fine_set.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/colors.dart';

class FineSettingsSection extends StatelessWidget {
  const FineSettingsSection({super.key});

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
                        Icons.settings,
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
                            'Fine Settings by Food Type',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Configure fines for different food types',
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddFineSettingsDialog(context),
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Add Settings'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textOnPrimary,
                      foregroundColor: AppColors.primaryPink,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Fine Settings List
          Expanded(
            child: Obx(() {
              if (controller.fineSettings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.settings,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No fine settings found',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create fine settings for each food type',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _showAddFineSettingsDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Create First Setting'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPink,
                          foregroundColor: AppColors.textOnPrimary,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.fineSettings.length,
                itemBuilder: (context, index) {
                  final fineSetting = controller.fineSettings[index];
                  return _FineSettingsCard(
                    fineSetting: fineSetting,
                    onEdit: () => _showEditFineSettingsDialog(context, fineSetting),
                    onDelete: () => _showDeleteFineSettingsDialog(context, fineSetting),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showAddFineSettingsDialog(BuildContext context) {
    final controller = Get.find<SettingsController>();
    String? selectedFoodType;
    FineSet? selectedHimFineSet;
    FineSet? selectedHerFineSet;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.surfaceLight,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.add,
                color: AppColors.primaryPink,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Add Fine Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Food Type Selection
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Food Type',
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.primaryPink.withOpacity(0.6),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                ),
                items: AppConstants.foodTypeEmojis.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Row(
                      children: [
                        Text(entry.value, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 12),
                        Text(entry.key),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedFoodType = value;
                },
              ),
              const SizedBox(height: 20),
              
              // Him Fine Set Selection
              DropdownButtonFormField<FineSet>(
                decoration: InputDecoration(
                  labelText: 'Him Fine Set',
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.primaryPink.withOpacity(0.6),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                ),
                items: controller.fineSets.map((fineSet) {
                  return DropdownMenuItem(
                    value: fineSet,
                    child: Text(fineSet.title),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedHimFineSet = value;
                },
              ),
              const SizedBox(height: 20),
              
              // Her Fine Set Selection
              DropdownButtonFormField<FineSet>(
                decoration: InputDecoration(
                  labelText: 'Her Fine Set',
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.primaryPink.withOpacity(0.6),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                ),
                items: controller.fineSets.map((fineSet) {
                  return DropdownMenuItem(
                    value: fineSet,
                    child: Text(fineSet.title),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedHerFineSet = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedFoodType != null) {
                final fineSettings = FineSettings.create(
                  foodType: selectedFoodType!,
                  foodTypeEmoji: AppConstants.foodTypeEmojis[selectedFoodType!]!,
                  himFineSet: selectedHimFineSet,
                  herFineSet: selectedHerFineSet,
                );
                controller.updateFineSettings(fineSettings);
                Get.back();
                Get.snackbar(
                  'Success',
                  'Fine settings added successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.cleanDayGreen,
                  colorText: AppColors.textOnPrimary,
                  icon: const Icon(Icons.check_circle, color: AppColors.textOnPrimary),
                  margin: const EdgeInsets.all(16),
                  borderRadius: 16,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPink,
              foregroundColor: AppColors.textOnPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditFineSettingsDialog(BuildContext context, FineSettings fineSetting) {
    final controller = Get.find<SettingsController>();
    FineSet? selectedHimFineSet = fineSetting.himFineSet;
    FineSet? selectedHerFineSet = fineSetting.herFineSet;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.surfaceLight,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.edit,
                color: AppColors.secondaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Edit Fine Settings: ${fineSetting.foodType}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Him Fine Set Selection
              DropdownButtonFormField<FineSet>(
                value: selectedHimFineSet,
                decoration: InputDecoration(
                  labelText: 'Him Fine Set',
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.primaryPink.withOpacity(0.6),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                ),
                items: controller.fineSets.map((fineSet) {
                  return DropdownMenuItem(
                    value: fineSet,
                    child: Text(fineSet.title),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedHimFineSet = value;
                },
              ),
              const SizedBox(height: 20),
              
              // Her Fine Set Selection
              DropdownButtonFormField<FineSet>(
                value: selectedHerFineSet,
                decoration: InputDecoration(
                  labelText: 'Her Fine Set',
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.primaryPink.withOpacity(0.6),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                ),
                items: controller.fineSets.map((fineSet) {
                  return DropdownMenuItem(
                    value: fineSet,
                    child: Text(fineSet.title),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedHerFineSet = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedFineSetting = fineSetting.copyWith(
                himFineSet: selectedHimFineSet,
                herFineSet: selectedHerFineSet,
              );
              controller.updateFineSettings(updatedFineSetting);
              Get.back();
              Get.snackbar(
                'Success',
                'Fine settings updated successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.cleanDayGreen,
                colorText: AppColors.textOnPrimary,
                icon: const Icon(Icons.check_circle, color: AppColors.textOnPrimary),
                margin: const EdgeInsets.all(16),
                borderRadius: 16,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryBlue,
              foregroundColor: AppColors.textOnPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteFineSettingsDialog(BuildContext context, FineSettings fineSetting) {
    final controller = Get.find<SettingsController>();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.surfaceLight,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.delete,
                color: AppColors.errorRed,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Delete Fine Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete fine settings for "${fineSetting.foodType}"?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.fineSettings.removeWhere((fs) => fs.id == fineSetting.id);
              controller.saveSettings();
              Get.back();
              Get.snackbar(
                'Success',
                'Fine settings deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.cleanDayGreen,
                colorText: AppColors.textOnPrimary,
                icon: const Icon(Icons.check_circle, color: AppColors.textOnPrimary),
                margin: const EdgeInsets.all(16),
                borderRadius: 16,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: AppColors.textOnPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _FineSettingsCard extends StatelessWidget {
  final FineSettings fineSetting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FineSettingsCard({
    required this.fineSetting,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
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
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppGradients.romantic,
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
                      fineSetting.foodTypeEmoji,
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
                        fineSetting.foodType,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Fine Configuration',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: AppColors.secondaryBlue,
                          size: 20,
                        ),
                        onPressed: onEdit,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.errorRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: AppColors.errorRed,
                          size: 20,
                        ),
                        onPressed: onDelete,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Fine Sets
            Column(
              children: [
                // Him Fine Set
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.secondaryBlue.withOpacity(0.1), AppColors.secondaryBlue.withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.secondaryBlue.withOpacity(0.3),
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
                              color: AppColors.secondaryBlue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.male,
                              color: AppColors.secondaryBlue,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Him',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (fineSetting.himFineSet != null) ...[
                        Text(
                          fineSetting.himFineSet!.title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Exercises:',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: fineSetting.himFineSet!.exercises.map((exercise) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryBlue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${exercise.quantity} ${exercise.exerciseName}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.secondaryBlue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ] else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.border.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'No fine set configured',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Her Fine Set
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryPink.withOpacity(0.1), AppColors.primaryPink.withOpacity(0.05)],
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
                              Icons.female,
                              color: AppColors.primaryPink,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Her',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryPink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (fineSetting.herFineSet != null) ...[
                        Text(
                          fineSetting.herFineSet!.title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Exercises:',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: fineSetting.herFineSet!.exercises.map((exercise) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryPink.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${exercise.quantity} ${exercise.exerciseName}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.primaryPink,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ] else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.border.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'No fine set configured',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
