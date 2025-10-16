import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../data/models/exercise.dart';
import '../../core/constants/app_constants.dart';

class ExerciseManagementSection extends StatelessWidget {
  const ExerciseManagementSection({super.key});

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
              colors: [Colors.blue.shade50, Colors.purple.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fitness_center, size: 24, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exercise Library',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    Text(
                      'Manage your custom exercises',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddExerciseDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Exercise'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        // Exercise List
        Expanded(
          child: Obx(() {
            if (controller.exercises.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No exercises found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      'Add your first exercise to get started',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              itemCount: controller.exercises.length,
              itemBuilder: (context, index) {
                final exercise = controller.exercises[index];
                return _ExerciseCard(
                  exercise: exercise,
                  onEdit: () => _showEditExerciseDialog(context, exercise),
                  onDelete: () => _showDeleteExerciseDialog(context, exercise),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  void _showAddExerciseDialog(BuildContext context) {
    final nameController = TextEditingController();
    final unitController = TextEditingController();
    final emojiController = TextEditingController();
    final controller = Get.find<SettingsController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Add New Exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise Name',
                hintText: 'e.g., Jumping Rope',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText: 'Unit',
                hintText: 'e.g., reps, minutes, seconds',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emojiController,
              decoration: const InputDecoration(
                labelText: 'Emoji',
                hintText: 'e.g., 🔄',
                border: OutlineInputBorder(),
              ),
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
              if (nameController.text.isNotEmpty &&
                  unitController.text.isNotEmpty &&
                  emojiController.text.isNotEmpty) {
                final exercise = Exercise.create(
                  name: nameController.text.trim(),
                  unit: unitController.text.trim(),
                  emoji: emojiController.text.trim(),
                );
                controller.addExercise(exercise);
                Get.back();
                Get.snackbar(
                  'Success',
                  'Exercise added successfully',
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

  void _showEditExerciseDialog(BuildContext context, Exercise exercise) {
    final nameController = TextEditingController(text: exercise.name);
    final unitController = TextEditingController(text: exercise.unit);
    final emojiController = TextEditingController(text: exercise.emoji);
    final controller = Get.find<SettingsController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText: 'Unit',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emojiController,
              decoration: const InputDecoration(
                labelText: 'Emoji',
                border: OutlineInputBorder(),
              ),
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
              if (nameController.text.isNotEmpty &&
                  unitController.text.isNotEmpty &&
                  emojiController.text.isNotEmpty) {
                final updatedExercise = exercise.copyWith(
                  name: nameController.text.trim(),
                  unit: unitController.text.trim(),
                  emoji: emojiController.text.trim(),
                );
                controller.updateExercise(updatedExercise);
                Get.back();
                Get.snackbar(
                  'Success',
                  'Exercise updated successfully',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteExerciseDialog(BuildContext context, Exercise exercise) {
    final controller = Get.find<SettingsController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Exercise'),
        content: Text('Are you sure you want to delete "${exercise.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteExercise(exercise.id);
              Get.back();
              Get.snackbar(
                'Success',
                'Exercise deleted successfully',
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

class _ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExerciseCard({
    required this.exercise,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.purple.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              exercise.emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          exercise.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'Unit: ${exercise.unit}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
      ),
    );
  }
}
