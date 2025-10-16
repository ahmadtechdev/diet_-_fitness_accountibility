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
                _buildHeader(),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Obx(() => controller.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildContent(controller)),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddEntryDialog(context, controller),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Add Entry',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppColors.primaryPink,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Food Log',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Track your journey together 💕',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.restaurant,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(FoodTrackerController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelector(controller),
          const SizedBox(height: 24),
          _buildTodayStats(controller),
          const SizedBox(height: 24),
          _buildEntriesList(controller),
          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildDateSelector(FoodTrackerController controller) {
    return RomanticCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_today, color: AppColors.primaryPink),
              SizedBox(width: 8),
              Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Builder(
            builder: (context) => InkWell(
              onTap: () => _selectDate(context, controller),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryPink.withOpacity(0.3),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      color: AppColors.primaryPink,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('EEEE, MMMM d, y').format(controller.selectedDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    // const Spacer(),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primaryPink,
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTodayStats(FoodTrackerController controller) {
    final todayEntries = controller.getEntriesForDate(controller.selectedDate);
    final cleanEntries = todayEntries.where((e) => e.status == AppConstants.cleanDay).length;
    final junkEntries = todayEntries.where((e) => e.status == AppConstants.junkFine).length;
    final totalFines = todayEntries.fold(0, (sum, entry) => sum + entry.fine.totalExercises);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Clean',
            cleanEntries.toString(),
            AppColors.cleanDayGreen,
            Icons.eco,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Junk',
            junkEntries.toString(),
            AppColors.junkFoodRed,
            Icons.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Junk',
            junkEntries.toString(),
            AppColors.cheatMealOrange,
            Icons.cake,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Fines',
            totalFines.toString(),
            AppColors.primaryPurple,
            Icons.fitness_center,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList(FoodTrackerController controller) {
    final todayEntries = controller.getEntriesForDate(controller.selectedDate);
    
    return RomanticCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.list, color: AppColors.primaryPink),
              const SizedBox(width: 8),
              const Text(
                'Today\'s Entries',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${todayEntries.length} entries',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
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
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No entries for this date',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the + button to add your first entry!',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...todayEntries.map((entry) => _buildEntryItem(entry, controller)),
        ],
      ),
    );
  }

  Widget _buildEntryItem(entry, FoodTrackerController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(entry.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(entry.status).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getStatusColor(entry.status).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        entry.whoAte,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusColor(entry.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${entry.statusEmoji} ${entry.status}',
                          style: TextStyle(
                            fontSize: 12,
                            color: _getStatusColor(entry.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (entry.notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.notes,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
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
                    style: const TextStyle(
                      fontSize: 12,
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
                    onPressed: () => _editEntry(entry, controller),
                    icon: const Icon(Icons.edit, size: 16),
                    color: AppColors.textSecondary,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  IconButton(
                    onPressed: () => _deleteEntry(entry, controller),
                    icon: const Icon(Icons.delete, size: 16),
                    color: AppColors.errorRed,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
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
              onPrimary: Colors.white,
              surface: Colors.white,
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

  void _editEntry(entry, FoodTrackerController controller) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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

  void _deleteEntry(entry, FoodTrackerController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Entry'),
        content: Text('Are you sure you want to delete "${entry.foodName}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteFoodEntry(entry.id);
              Get.back();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }
}
