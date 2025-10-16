import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../data/models/fine_set.dart';
import '../../data/models/exercise.dart';
import '../../core/constants/app_constants.dart';

class FineSetManagementSection extends StatelessWidget {
  const FineSetManagementSection({super.key});

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
              const Icon(Icons.sports_gymnastics, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Fine Sets',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAddFineSetDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Fine Set'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // Fine Set List
        Expanded(
          child: Obx(() {
            if (controller.fineSets.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_gymnastics, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No fine sets found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      'Create your first fine set to get started',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              itemCount: controller.fineSets.length,
              itemBuilder: (context, index) {
                final fineSet = controller.fineSets[index];
                return _FineSetCard(
                  fineSet: fineSet,
                  onEdit: () => _showEditFineSetDialog(context, fineSet),
                  onDelete: () => _showDeleteFineSetDialog(context, fineSet),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  void _showAddFineSetDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final controller = Get.find<SettingsController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Add New Fine Set'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Fine Set Title',
                  hintText: 'e.g., Major Junk Food Fine',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Brief description of this fine set',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
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
              if (titleController.text.isNotEmpty) {
                final fineSet = FineSet.create(
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  exercises: [], // Will be configured in edit dialog
                );
                controller.addFineSet(fineSet);
                Get.back();
                // Open edit dialog to configure exercises
                _showEditFineSetDialog(context, fineSet);
                Get.snackbar(
                  'Success',
                  'Fine set created. Please configure exercises.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditFineSetDialog(BuildContext context, FineSet fineSet) {
    final controller = Get.find<SettingsController>();
    final exercises = fineSet.exercises.toList();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Edit Fine Set: ${fineSet.title}'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  // Exercise List
                  Expanded(
                    child: exercises.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.sports_gymnastics, size: 48, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('No exercises added yet'),
                                Text('Tap "Add Exercise" to get started', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: exercises.length,
                            itemBuilder: (context, index) {
                              final exercise = exercises[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.withOpacity(0.1),
                                    child: Text(exercise.exerciseEmoji, style: const TextStyle(fontSize: 20)),
                                  ),
                                  title: Text(exercise.exerciseName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text('Quantity: ${exercise.quantity}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _showEditExerciseQuantityDialog(
                                          context,
                                          exercise,
                                          (updatedExercise) {
                                            setState(() {
                                              exercises[index] = updatedExercise;
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            exercises.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const Divider(),
                  // Add Exercise Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddExerciseToFineSetDialog(
                        context,
                        (exercise) {
                          setState(() {
                            exercises.add(exercise);
                          });
                        },
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Exercise'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
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
                  final updatedFineSet = fineSet.copyWith(exercises: exercises);
                  controller.updateFineSet(updatedFineSet);
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Fine set updated successfully',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddExerciseToFineSetDialog(
    BuildContext context,
    Function(FineSetExercise) onAdd,
  ) {
    final controller = Get.find<SettingsController>();
    final quantityController = TextEditingController(text: '1');
    Exercise? selectedExercise;

    Get.dialog(
      AlertDialog(
        title: const Text('Add Exercise to Fine Set'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<Exercise>(
              decoration: const InputDecoration(
                labelText: 'Select Exercise',
                border: OutlineInputBorder(),
              ),
              items: controller.exercises.map((exercise) {
                return DropdownMenuItem(
                  value: exercise,
                  child: Row(
                    children: [
                      Text(exercise.emoji),
                      const SizedBox(width: 8),
                      Text(exercise.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (exercise) {
                selectedExercise = exercise;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedExercise != null && quantityController.text.isNotEmpty) {
                final quantity = int.tryParse(quantityController.text) ?? 1;
                final fineSetExercise = FineSetExercise(
                  exerciseId: selectedExercise!.id,
                  exerciseName: selectedExercise!.name,
                  exerciseEmoji: selectedExercise!.emoji,
                  quantity: quantity,
                );
                onAdd(fineSetExercise);
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditExerciseQuantityDialog(
    BuildContext context,
    FineSetExercise exercise,
    Function(FineSetExercise) onUpdate,
  ) {
    final quantityController = TextEditingController(text: exercise.quantity.toString());

    Get.dialog(
      AlertDialog(
        title: Text('Edit ${exercise.exerciseName}'),
        content: TextField(
          controller: quantityController,
          decoration: const InputDecoration(
            labelText: 'Quantity',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity = int.tryParse(quantityController.text) ?? exercise.quantity;
              final updatedExercise = exercise.copyWith(quantity: quantity);
              onUpdate(updatedExercise);
              Get.back();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteFineSetDialog(BuildContext context, FineSet fineSet) {
    final controller = Get.find<SettingsController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Fine Set'),
        content: Text('Are you sure you want to delete "${fineSet.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteFineSet(fineSet.id);
              Get.back();
              Get.snackbar(
                'Success',
                'Fine set deleted successfully',
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

class _FineSetCard extends StatelessWidget {
  final FineSet fineSet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FineSetCard({
    required this.fineSet,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          child: const Icon(Icons.sports_gymnastics),
        ),
        title: Text(
          fineSet.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(fineSet.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exercises (${fineSet.exercises.length}):',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (fineSet.exercises.isEmpty)
                  const Text('No exercises configured')
                else
                  ...fineSet.exercises.map((exercise) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Text(exercise.exerciseEmoji),
                            const SizedBox(width: 8),
                            Text('${exercise.quantity} ${exercise.exerciseName}'),
                          ],
                        ),
                      )),
                const SizedBox(height: 8),
                Text(
                  'Total: ${fineSet.totalExercises} exercises',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
