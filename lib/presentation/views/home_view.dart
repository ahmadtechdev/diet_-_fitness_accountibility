import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/colors.dart';
import '../../core/constants/app_constants.dart';
import '../../app/routes/app_routes.dart';
import '../controllers/food_tracker_controller.dart';
import '../widgets/romantic_card.dart';
import '../widgets/quick_stats_card.dart';
import '../widgets/motivational_banner.dart';
import '../widgets/main_layout.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FoodTrackerController>();
    
    return MainLayout(
      currentIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.romantic,
          ),
          child: SafeArea(
            child: Obx(() => controller.isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _buildContent(controller)),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.toNamed(AppRoutes.dailyLog),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Log Food',
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

  Widget _buildContent(FoodTrackerController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildMotivationalBanner(controller),
          const SizedBox(height: 24),
          _buildQuickStats(controller),
          const SizedBox(height: 24),
          _buildTodaySection(controller),
          const SizedBox(height: 24),
          _buildWeeklyProgress(controller),
          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstants.appName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AppConstants.appTagline,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMotivationalBanner(FoodTrackerController controller) {
    return MotivationalBanner(
      message: controller.getRandomMotivationalMessage(),
    );
  }

  Widget _buildQuickStats(FoodTrackerController controller) {
    return Row(
      children: [
        Expanded(
          child: QuickStatsCard(
            title: 'Clean Days',
            value: controller.totalCleanDays.toString(),
            icon: Icons.eco,
            color: AppColors.cleanDayGreen,
            gradient: AppGradients.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: QuickStatsCard(
            title: 'Total Fines',
            value: controller.totalFines.totalExercises.toString(),
            icon: Icons.fitness_center,
            color: AppColors.junkFoodRed,
            gradient: AppGradients.error,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaySection(FoodTrackerController controller) {
    final todayEntries = controller.todayEntries;
    
    return RomanticCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.today, color: AppColors.primaryPink),
              const SizedBox(width: 8),
              const Text(
                'Today\'s Journey',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.dailyLog),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (todayEntries.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cleanDayLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.eco,
                      size: 48,
                      color: AppColors.cleanDayGreen,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No entries today yet!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.cleanDayGreen,
                      ),
                    ),
                    Text(
                      'Start your healthy journey! 💚',
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
            ...todayEntries.take(3).map((entry) => _buildEntryItem(entry)),
          if (todayEntries.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: Text(
                  '+${todayEntries.length - 3} more entries',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEntryItem(entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getStatusColor(entry.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getStatusColor(entry.status).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Text(
            entry.foodTypeEmoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.foodName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${entry.whoAte} • ${entry.statusEmoji} ${entry.status}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
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
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress(FoodTrackerController controller) {
    final currentWeek = controller.currentWeekSummary;
    
    return RomanticCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Icon(Icons.calendar_view_week, color: AppColors.primaryPink),
                const SizedBox(width: 8),
                const Text(
                  'This Week\'s Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                // const Spacer(),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.summary),
                  child: const Text('View Details'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (currentWeek != null) ...[
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildProgressItem(
                    'Clean Days',
                    '${currentWeek.cleanDays}/${currentWeek.totalDays}',
                    currentWeek.cleanPercentage / 100,
                    AppColors.cleanDayGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: _buildProgressItem(
                    'Combined Fines',
                    '${currentWeek.combinedFine.totalExercises}',
                    (currentWeek.combinedFine.totalExercises / 100).clamp(0.0, 1.0),
                    AppColors.junkFoodRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: _getAchievementGradient(currentWeek.achievementLevel),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentWeek.achievementMessage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${currentWeek.cleanPercentage.toStringAsFixed(1)}% Clean Days',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'No data for this week yet!',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
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

  LinearGradient _getAchievementGradient(String level) {
    switch (level) {
      case 'excellent':
        return AppGradients.success;
      case 'good':
        return AppGradients.warning;
      default:
        return AppGradients.error;
    }
  }
}
