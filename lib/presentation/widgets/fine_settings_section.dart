import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../data/models/fine_settings.dart';
import '../../data/models/fine_set.dart';
import '../../core/constants/app_constants.dart';

class FineSettingsSection extends StatelessWidget {
  const FineSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade50, Colors.pink.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.settings, size: 24, color: Colors.purple),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fine Settings by Food Type',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    Text(
                      'Configure fines for different food types',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddFineSettingsDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Settings'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        // Fine Settings List
        Expanded(
          child: Obx(() {
            if (controller.fineSettings.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No fine settings found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      'Create fine settings for each food type',
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
    );
  }

  void _showAddFineSettingsDialog(BuildContext context) {
    final controller = Get.find<SettingsController>();
    String? selectedFoodType;
    FineSet? selectedHimFineSet;
    FineSet? selectedHerFineSet;

    Get.dialog(
      AlertDialog(
        title: const Text('Add Fine Settings'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Food Type Selection
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Food Type',
                  border: OutlineInputBorder(),
                ),
                items: AppConstants.foodTypeEmojis.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Row(
                      children: [
                        Text(entry.value),
                        const SizedBox(width: 8),
                        Text(entry.key),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedFoodType = value;
                },
              ),
              const SizedBox(height: 16),
              
              // Him Fine Set Selection
              DropdownButtonFormField<FineSet>(
                decoration: const InputDecoration(
                  labelText: 'Him Fine Set',
                  border: OutlineInputBorder(),
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
              const SizedBox(height: 16),
              
              // Her Fine Set Selection
              DropdownButtonFormField<FineSet>(
                decoration: const InputDecoration(
                  labelText: 'Her Fine Set',
                  border: OutlineInputBorder(),
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
                );
              }
            },
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
        title: Text('Edit Fine Settings: ${fineSetting.foodType}'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Him Fine Set Selection
              DropdownButtonFormField<FineSet>(
                value: selectedHimFineSet,
                decoration: const InputDecoration(
                  labelText: 'Him Fine Set',
                  border: OutlineInputBorder(),
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
              const SizedBox(height: 16),
              
              // Her Fine Set Selection
              DropdownButtonFormField<FineSet>(
                value: selectedHerFineSet,
                decoration: const InputDecoration(
                  labelText: 'Her Fine Set',
                  border: OutlineInputBorder(),
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
              );
            },
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
        title: const Text('Delete Fine Settings'),
        content: Text('Are you sure you want to delete fine settings for "${fineSetting.foodType}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
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
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
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
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade100, Colors.red.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      fineSetting.foodTypeEmoji,
                      style: const TextStyle(fontSize: 24),
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
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        'Fine Configuration',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                    onPressed: onEdit,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: onDelete,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Fine Sets
            Row(
              children: [
                // Him Fine Set
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.male, color: Colors.blue, size: 16),
                            ),
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
                        if (fineSetting.himFineSet != null) ...[
                          Text(
                            fineSetting.himFineSet!.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            fineSetting.himFineSet!.exercisesDescription,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ] else
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'No fine set configured',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Her Fine Set
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade50, Colors.pink.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.pink.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.pink.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.female, color: Colors.pink, size: 16),
                            ),
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
                        if (fineSetting.herFineSet != null) ...[
                          Text(
                            fineSetting.herFineSet!.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            fineSetting.herFineSet!.exercisesDescription,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ] else
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'No fine set configured',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
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
