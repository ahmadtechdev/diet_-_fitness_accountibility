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
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Accountability',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppColors.primaryPink,
          size: 24,
        ),
        actions: [
          // Elegant clear button with proper styling
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.junkFoodRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.clear_all,
                color: AppColors.junkFoodRed,
                size: 20,
              ),
              onPressed: () => _showClearDialog(context, controller),
              tooltip: 'Clear All Entries',
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: AppColors.primaryPink,
                  strokeWidth: 2,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading accountability data...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            const SizedBox(height: 8),
            // Filter Tabs
            _buildFilterTabs(context, controller),
            
            const SizedBox(height: 16),
            // Quick Stats
            _buildQuickStats(context, controller),
            
            const SizedBox(height: 16),
            // Entries List
            Expanded(
              child: controller.filteredEntries.isEmpty
                  ? _buildEmptyState(context)
                  : _buildEntriesList(context, controller),
            ),
          ],
        );
      }),
    );
  }

  void _showClearDialog(BuildContext context, AccountabilityController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Clear All Entries',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(
          'This will permanently clear all accountability entries. This action cannot be undone.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearAllEntries();
              Navigator.of(context).pop();
              Get.snackbar(
                'Cleared!',
                'All accountability entries have been cleared',
                snackPosition: SnackPosition.TOP,
                backgroundColor: AppColors.junkFoodRed,
                colorText: AppColors.textOnPrimary,
                borderRadius: 12,
                margin: const EdgeInsets.all(16),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.junkFoodRed,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context, AccountabilityController controller) {
    final filters = [
      {'key': 'all', 'label': 'All', 'icon': Icons.list_alt, 'color': AppColors.primaryPink},
      {'key': 'pending', 'label': 'Pending', 'icon': Icons.pending_actions, 'color': AppColors.junkFoodRed},
      {'key': 'completed', 'label': 'Completed', 'icon': Icons.check_circle, 'color': AppColors.cleanDayGreen},
      {'key': 'my', 'label': 'Him', 'icon': Icons.male, 'color': Colors.blue},
      {'key': 'partner', 'label': 'Her', 'icon': Icons.female, 'color': Colors.pink},
    ];

    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = controller.selectedFilter == filter['key'];
          final filterColor = filter['color'] as Color;
          
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 18,
                    color: isSelected ? AppColors.textOnPrimary : filterColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    filter['label'] as String,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected ? AppColors.textOnPrimary : filterColor,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
              onSelected: (selected) {
                controller.setFilter(filter['key'] as String);
              },
              selectedColor: filterColor,
              backgroundColor: filterColor.withOpacity(0.1),
              side: BorderSide(
                color: isSelected ? filterColor : filterColor.withOpacity(0.3),
                width: isSelected ? 1.5 : 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: isSelected ? 2 : 0,
              shadowColor: filterColor.withOpacity(0.3),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, AccountabilityController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Main Stats Row - Primary Metrics
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.pending_actions,
                  value: '${controller.totalPendingFines}',
                  label: 'Pending',
                  color: AppColors.junkFoodRed,
                  gradient: AppGradients.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.check_circle,
                  value: '${controller.totalCompletedFines}',
                  label: 'Completed',
                  color: AppColors.cleanDayGreen,
                  gradient: AppGradients.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.trending_up,
                  value: '${(controller.completionRate * 100).toInt()}%',
                  label: 'Progress',
                  color: AppColors.primaryPink,
                  gradient: AppGradients.romantic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Secondary Stats Row - Detailed Breakdown
          Row(
            children: [
              Expanded(
                child: _buildSecondaryStatCard(
                  context,
                  icon: Icons.male,
                  value: '${controller.myPendingFines}',
                  label: 'Him Pending',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSecondaryStatCard(
                  context,
                  icon: Icons.female,
                  value: '${controller.partnerPendingFines}',
                  label: 'Her Pending',
                  color: Colors.pink,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSecondaryStatCard(
                  context,
                  icon: Icons.fitness_center,
                  value: '${controller.totalPendingExercises.totalExercises}',
                  label: 'Total Exercises',
                  color: AppColors.cheatMealOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Gradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.textOnPrimary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: AppColors.textOnPrimary,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textOnPrimary.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Beautiful gradient container for the icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppGradients.romantic,
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPink.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 60,
                color: AppColors.textOnPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No accountability entries found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Start logging your food to see accountability entries here!\nTrack your progress together as a couple.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Elegant call-to-action button
            Container(
              decoration: BoxDecoration(
                gradient: AppGradients.romantic,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPink.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to food logging or home
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.textOnPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Start Logging Food',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntriesList(BuildContext context, AccountabilityController controller) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: controller.filteredEntries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = controller.filteredEntries[index];
        return _buildAccountabilityEntry(context, entry, controller);
      },
    );
  }

  Widget _buildAccountabilityEntry(BuildContext context, entry, AccountabilityController controller) {
    final isHer = entry.whoAte == AppConstants.her;
    final isCompleted = entry.isCompleted;
    final isFromPartner = entry.isFromPartner;
    
    // Determine colors based on entry type
    final primaryColor = isFromPartner 
        ? AppColors.cheatMealOrange 
        : (isHer ? Colors.pink : Colors.blue);
    final backgroundColor = primaryColor.withOpacity(0.05);
    final borderColor = primaryColor.withOpacity(0.2);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted ? AppColors.cleanDayGreen.withOpacity(0.3) : borderColor,
            width: isCompleted ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isCompleted 
                  ? AppColors.cleanDayGreen.withOpacity(0.1)
                  : AppColors.shadowLight,
              blurRadius: isCompleted ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  // Person Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: isFromPartner 
                          ? AppGradients.warning
                          : (isHer ? AppGradients.romantic : AppGradients.success),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isFromPartner 
                          ? Icons.people 
                          : (isHer ? Icons.female : Icons.male),
                      color: AppColors.textOnPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Food Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.foodName,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              entry.foodTypeEmoji,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              entry.foodType,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('MMM d').format(entry.date),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Completion Toggle
                  GestureDetector(
                    onTap: () {
                      if (isCompleted) {
                        controller.markAsPending(entry.id);
                      } else {
                        controller.markAsCompleted(entry.id, isHer ? 'Her' : 'Him');
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: isCompleted 
                            ? AppGradients.success
                            : AppGradients.error,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: (isCompleted ? AppColors.cleanDayGreen : AppColors.junkFoodRed).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: AppColors.textOnPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Fine Details Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fine Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.fitness_center,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isFromPartner 
                                  ? 'Partner Distribution Fine'
                                  : 'Exercise Fine for ${entry.whoAte}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isFromPartner 
                                  ? 'Shared accountability exercise'
                                  : 'Personal exercise fine',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Account Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          isFromPartner 
                              ? 'Shared' 
                              : (isHer ? 'Her Account' : 'His Account'),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Fine Description
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      entry.fine.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Exercise Breakdown
                  _buildFineBreakdown(context, entry),
                  
                  // Completion Info
                  if (isCompleted) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cleanDayGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.cleanDayGreen.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.cleanDayGreen,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Completed by ${entry.completedBy} on ${DateFormat('MMM d, h:mm a').format(entry.completedAt!)}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.cleanDayGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFineBreakdown(BuildContext context, entry) {
    final fine = entry.fine;
    final exercises = <Widget>[];
    
    // Create exercise chips with proper styling
    if (fine.jumpingRopes > 0) {
      exercises.add(_buildExerciseChip(context, '🔄', '${fine.jumpingRopes} sets', 'Jumping Ropes', AppColors.jumpingRopes));
    }
    if (fine.squats > 0) {
      exercises.add(_buildExerciseChip(context, '🦵', '${fine.squats} sets', 'Squats', AppColors.squats));
    }
    if (fine.jumpingJacks > 0) {
      exercises.add(_buildExerciseChip(context, '🤸', '${fine.jumpingJacks} sets', 'Jumping Jacks', AppColors.jumpingJacks));
    }
    if (fine.highKnees > 0) {
      exercises.add(_buildExerciseChip(context, '🏃', '${fine.highKnees} sets', 'High Knees', AppColors.highKnees));
    }
    if (fine.pushups > 0) {
      exercises.add(_buildExerciseChip(context, '💪', '${fine.pushups} sets', 'Pushups', AppColors.pushups));
    }
    
    if (exercises.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.list_alt,
              color: AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'Exercise Breakdown',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: exercises,
        ),
      ],
    );
  }

  Widget _buildExerciseChip(BuildContext context, String emoji, String count, String exercise, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                exercise,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
