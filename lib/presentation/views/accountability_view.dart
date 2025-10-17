import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/utils/colors.dart';
import '../../core/constants/app_constants.dart';
import '../controllers/accountability_controller.dart';
import '../controllers/settings_controller.dart';
import '../widgets/romantic_card.dart';

class AccountabilityView extends StatelessWidget {
  const AccountabilityView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountabilityController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Accountability',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryPink),
        actions: [
          // Debug button to clear all entries
          IconButton(
            icon: const Icon(Icons.clear_all, color: AppColors.primaryPink),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Clear All Entries'),
                  content: const Text('This will clear all accountability entries. Are you sure?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.clearAllEntries();
                        Get.back();
                        Get.snackbar(
                          'Cleared!',
                          'All accountability entries have been cleared',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: AppColors.primaryPink,
                          colorText: AppColors.textOnPrimary,
                        );
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryPink,
            ),
          );
        }

        return Column(
          children: [
            // Filter Tabs
            _buildFilterTabs(controller),
            
            // Quick Stats
            _buildQuickStats(controller),
            
            // Entries List
            Expanded(
              child: controller.filteredEntries.isEmpty
                  ? _buildEmptyState()
                  : _buildEntriesList(controller),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterTabs(AccountabilityController controller) {
    final filters = [
      {'key': 'all', 'label': 'All', 'icon': Icons.list},
      {'key': 'pending', 'label': 'Pending', 'icon': Icons.pending},
      {'key': 'completed', 'label': 'Completed', 'icon': Icons.check_circle},
      {'key': 'my', 'label': 'Him', 'icon': Icons.male},
      {'key': 'partner', 'label': 'Her', 'icon': Icons.female},
    ];

    return Container(
      height: 60,
      margin: const EdgeInsets.all(16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = controller.selectedFilter == filter['key'];
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.primaryPink,
                  ),
                  const SizedBox(width: 4),
                  Text(filter['label'] as String),
                ],
              ),
              onSelected: (selected) {
                controller.setFilter(filter['key'] as String);
              },
              selectedColor: AppColors.primaryPink,
              checkmarkColor: Colors.white,
              backgroundColor: AppColors.primaryPink.withOpacity(0.1),
              side: BorderSide(
                color: AppColors.primaryPink.withOpacity(0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickStats(AccountabilityController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Main Stats Row
          Row(
            children: [
              Expanded(
                child: RomanticCard(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.pending_actions,
                        color: AppColors.junkFoodRed,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${controller.totalPendingFines}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.junkFoodRed,
                        ),
                      ),
                      const Text(
                        'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RomanticCard(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.cleanDayGreen,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${controller.totalCompletedFines}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.cleanDayGreen,
                        ),
                      ),
                      const Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RomanticCard(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.trending_up,
                        color: AppColors.primaryPink,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(controller.completionRate * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPink,
                        ),
                      ),
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Him/Her Breakdown
          Row(
            children: [
              Expanded(
                child: RomanticCard(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.male,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.myPendingFines}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const Text(
                        'Him Pending',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RomanticCard(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.female,
                        color: Colors.pink,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.partnerPendingFines}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      const Text(
                        'Her Pending',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RomanticCard(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.fitness_center,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.totalPendingExercises.totalExercises}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const Text(
                        'Total Exercises',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: AppColors.primaryPink.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No accountability entries found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start logging your food to see accountability entries here!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList(AccountabilityController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.filteredEntries.length,
      itemBuilder: (context, index) {
        final entry = controller.filteredEntries[index];
        return _buildAccountabilityEntry(entry, controller);
      },
    );
  }

  Widget _buildAccountabilityEntry(entry, AccountabilityController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: RomanticCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: entry.whoAte == AppConstants.her
                        ? Colors.pink.withOpacity(0.2)
                        : Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    entry.whoAte == AppConstants.her ? Icons.female : Icons.male,
                    color: entry.whoAte == AppConstants.her ? Colors.pink : Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.foodName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${entry.foodTypeEmoji} ${entry.foodType} • ${entry.whoAte} • ${DateFormat('MMM d').format(entry.date)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Completion Status
                GestureDetector(
                  onTap: () {
                    if (entry.isCompleted) {
                      controller.markAsPending(entry.id);
                    } else {
                      controller.markAsCompleted(entry.id, entry.whoAte == AppConstants.him ? 'Him' : 'Her');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: entry.isCompleted 
                          ? AppColors.cleanDayGreen.withOpacity(0.2)
                          : AppColors.junkFoodRed.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      entry.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: entry.isCompleted 
                          ? AppColors.cleanDayGreen
                          : AppColors.junkFoodRed,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Exercise Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: entry.isFromPartner 
                    ? Colors.orange.withOpacity(0.05)
                    : (entry.whoAte == AppConstants.her ? Colors.pink.withOpacity(0.05) : Colors.blue.withOpacity(0.05)),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: entry.isFromPartner 
                      ? Colors.orange.withOpacity(0.2)
                      : (entry.whoAte == AppConstants.her ? Colors.pink.withOpacity(0.2) : Colors.blue.withOpacity(0.2)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        color: entry.isFromPartner 
                            ? Colors.orange 
                            : (entry.whoAte == AppConstants.her ? Colors.pink : Colors.blue),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.isFromPartner 
                            ? 'Partner Distribution Fine:'
                            : 'Exercise Fine for ${entry.whoAte}:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: entry.isFromPartner 
                              ? Colors.orange 
                              : (entry.whoAte == AppConstants.her ? Colors.pink : Colors.blue),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: entry.isFromPartner 
                              ? Colors.orange.withOpacity(0.2)
                              : (entry.whoAte == AppConstants.her ? Colors.pink.withOpacity(0.2) : Colors.blue.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          entry.isFromPartner 
                              ? 'Partner Distribution' 
                              : (entry.whoAte == AppConstants.her ? 'Her Account' : 'His Account'),
                          style: TextStyle(
                            fontSize: 10,
                            color: entry.isFromPartner 
                                ? Colors.orange 
                                : (entry.whoAte == AppConstants.her ? Colors.pink : Colors.blue),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.fine.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Fine breakdown
                  _buildFineBreakdown(entry),
                ],
              ),
            ),
            
            // Completion Info
            if (entry.isCompleted) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.cleanDayGreen,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Completed by ${entry.completedBy} on ${DateFormat('MMM d, h:mm a').format(entry.completedAt!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.cleanDayGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFineBreakdown(entry) {
    final fine = entry.fine;
    final exercises = <Widget>[];
    
    if (fine.jumpingRopes > 0) {
      exercises.add(_buildExerciseChip('🔄', '${fine.jumpingRopes} sets Jumping Ropes'));
    }
    if (fine.squats > 0) {
      exercises.add(_buildExerciseChip('🦵', '${fine.squats} sets Squats'));
    }
    if (fine.jumpingJacks > 0) {
      exercises.add(_buildExerciseChip('🤸', '${fine.jumpingJacks} sets Jumping Jacks'));
    }
    if (fine.highKnees > 0) {
      exercises.add(_buildExerciseChip('🏃', '${fine.highKnees} sets High Knees'));
    }
    if (fine.pushups > 0) {
      exercises.add(_buildExerciseChip('💪', '${fine.pushups} sets Pushups'));
    }
    
    if (exercises.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Exercise Breakdown:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: exercises,
        ),
      ],
    );
  }

  Widget _buildExerciseChip(String emoji, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
