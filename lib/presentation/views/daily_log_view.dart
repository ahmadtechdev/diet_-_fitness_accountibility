import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/utils/colors.dart';
import '../../core/constants/app_constants.dart';
import '../controllers/food_tracker_controller.dart';
import '../widgets/romantic_card.dart';
import '../widgets/food_entry_form.dart';
import '../widgets/main_layout.dart';

class DailyLogView extends StatelessWidget {
  const DailyLogView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FoodTrackerController>();

    return MainLayout(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryPink,
                AppColors.backgroundLight,
              ],
              stops: [0.0, 0.3],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Obx(() => controller.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildContent(context, controller)),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddEntryDialog(context, controller),
          icon: const Icon(Icons.add, color: AppColors.textOnPrimary),
          label: Text(
            'Add Entry',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: AppColors.primaryPink,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: AppColors.textOnPrimary),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.textOnPrimary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Food Log',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track your journey together 💕',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textOnPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: AppColors.textOnPrimary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, FoodTrackerController controller) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelector(context, controller),
          const SizedBox(height: 24),
          _buildTodayStats(context, controller),
          const SizedBox(height: 24),
          _buildEntriesList(context, controller),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, FoodTrackerController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: AppColors.primaryPink,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Select Date',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context, controller),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryPink.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryPink.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      color: AppColors.primaryPink,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        DateFormat('EEEE, MMMM d, y').format(controller.selectedDate),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primaryPink,
                      size: 20,
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

  Widget _buildTodayStats(BuildContext context, FoodTrackerController controller) {
    final todayEntries = controller.getEntriesForDate(controller.selectedDate);
    final cleanEntries = todayEntries.where((e) => e.status == AppConstants.cleanDay).length;
    final junkEntries = todayEntries.where((e) => e.status == AppConstants.junkFine).length;
    final cheatEntries = todayEntries.where((e) => e.status == AppConstants.cheatMeal).length;
    final totalFines = todayEntries.fold(0, (sum, entry) => sum + entry.fine.totalExercises);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.analytics,
                    color: AppColors.primaryPink,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Today\'s Summary',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 400;
                if (isSmallScreen) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context,
                              'Clean',
                              cleanEntries.toString(),
                              AppColors.cleanDayGreen,
                              Icons.eco,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              'Junk',
                              junkEntries.toString(),
                              AppColors.junkFoodRed,
                              Icons.warning,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context,
                              'Cheat',
                              cheatEntries.toString(),
                              AppColors.cheatMealOrange,
                              Icons.cake,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              'Fines',
                              totalFines.toString(),
                              AppColors.primaryPurple,
                              Icons.fitness_center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Clean',
                          cleanEntries.toString(),
                          AppColors.cleanDayGreen,
                          Icons.eco,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Junk',
                          junkEntries.toString(),
                          AppColors.junkFoodRed,
                          Icons.warning,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Cheat',
                          cheatEntries.toString(),
                          AppColors.cheatMealOrange,
                          Icons.cake,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Fines',
                          totalFines.toString(),
                          AppColors.primaryPurple,
                          Icons.fitness_center,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList(BuildContext context, FoodTrackerController controller) {
    final todayEntries = controller.getEntriesForDate(controller.selectedDate);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.list_alt,
                    color: AppColors.primaryPink,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Today\'s Entries',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${todayEntries.length} entries',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primaryPink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (todayEntries.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.restaurant_menu,
                          size: 32,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No entries for this date',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to add your first entry!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...todayEntries.map((entry) => _buildEntryItem(context, entry, controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryItem(BuildContext context, entry, FoodTrackerController controller) {
    final statusColor = _getStatusColor(entry.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              entry.foodTypeEmoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
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
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        entry.whoAte,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primaryPink,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${entry.statusEmoji} ${entry.status}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                if (entry.notes.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    entry.notes,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (entry.fine.totalExercises > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.junkFoodRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${entry.fine.totalExercises}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.junkFoodRed,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _editEntry(context, entry, controller),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    color: AppColors.textSecondary,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.textSecondary.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(32, 32),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => _deleteEntry(context, entry, controller),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    color: AppColors.errorRed,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.errorRed.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(32, 32),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.cleanDay:
        return AppColors.cleanDayGreen;
      case AppConstants.junkFine:
        return AppColors.junkFoodRed;
      default:
        return AppColors.textSecondary;
    }
  }

  Future<void> _selectDate(BuildContext context, FoodTrackerController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryPink,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.surfaceLight,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != controller.selectedDate) {
      controller.updateSelectedDate(picked);
    }
  }

  void _showAddEntryDialog(BuildContext context, FoodTrackerController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => FoodEntryForm(
        selectedDate: controller.selectedDate,
        onSave: (entry) {
          controller.addFoodEntry(
            date: entry.date,
            whoAte: entry.whoAte,
            foodType: entry.foodType,
            foodName: entry.foodName,
            quantity: entry.quantity,
            notes: entry.notes,
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  void _editEntry(BuildContext context, entry, FoodTrackerController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => FoodEntryForm(
        selectedDate: entry.date,
        initialEntry: entry,
        onSave: (updatedEntry) {
          controller.updateFoodEntry(updatedEntry);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteEntry(BuildContext context, entry, FoodTrackerController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.surfaceLight,
        title: Text(
          'Delete Entry',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${entry.foodName}"?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteFoodEntry(entry.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: AppColors.textOnPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Delete',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
