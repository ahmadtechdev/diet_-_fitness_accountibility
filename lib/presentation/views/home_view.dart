import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/notification_service.dart';
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
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: Obx(() => controller.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryPink,
                    strokeWidth: 2,
                  ),
                )
              : _buildContent(context, controller)),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FoodTrackerController controller) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildMotivationalBanner(context, controller),
          const SizedBox(height: 24),
          _buildQuickStats(context, controller),
          const SizedBox(height: 24),
          _buildTodaySection(context, controller),
          const SizedBox(height: 24),
          _buildWeeklyProgress(context, controller),
          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.romantic,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.favorite,
              color: AppColors.textOnPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppConstants.appTagline,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textOnPrimary.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          // Debug button for notification testing
          IconButton(
            onPressed: () => _testNotificationSetup(context),
            icon: const Icon(
              Icons.bug_report,
              color: AppColors.textOnPrimary,
            ),
            tooltip: 'Test Notifications',
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalBanner(BuildContext context, FoodTrackerController controller) {
    return MotivationalBanner(
      message: controller.getRandomMotivationalMessage(),
    );
  }

  Widget _buildQuickStats(BuildContext context, FoodTrackerController controller) {
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

  Widget _buildTodaySection(BuildContext context, FoodTrackerController controller) {
    final todayEntries = controller.todayEntries;
    
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
                Icon(
                  Icons.today, 
                  color: AppColors.primaryPink,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Today\'s Journey',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.dailyLog),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryPink,
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (todayEntries.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cleanDayLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.eco,
                        size: 48,
                        color: AppColors.cleanDayGreen,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No entries today yet!',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.cleanDayGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Start your healthy journey! 💚',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...todayEntries.take(3).map((entry) => _buildEntryItem(context, entry)),
            if (todayEntries.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Center(
                  child: Text(
                    '+${todayEntries.length - 3} more entries',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryItem(BuildContext context, entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(entry.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(entry.status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            entry.foodTypeEmoji,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.foodName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${entry.whoAte} • ${entry.statusEmoji} ${entry.status}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (entry.fine.totalExercises > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.junkFoodRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${entry.fine.totalExercises}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.junkFoodRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress(BuildContext context, FoodTrackerController controller) {
    final currentWeek = controller.currentWeekSummary;
    
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
                Icon(
                  Icons.calendar_view_week,
                  color: AppColors.primaryPink,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'This Week\'s ',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.summary),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryPink,
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('View Details'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (currentWeek != null) ...[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildProgressItem(
                      context,
                      'Clean Days',
                      '${currentWeek.cleanDays}/${currentWeek.totalDays}',
                      currentWeek.cleanPercentage / 100,
                      AppColors.cleanDayGreen,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: _buildProgressItem(
                      context,
                      'Combined Fines',
                      '${currentWeek.combinedFine.totalExercises}',
                      (currentWeek.combinedFine.totalExercises / 100).clamp(0.0, 1.0),
                      AppColors.junkFoodRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: _getAchievementGradient(currentWeek.achievementLevel),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: AppColors.textOnPrimary,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentWeek.achievementMessage,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${currentWeek.cleanPercentage.toStringAsFixed(1)}% Clean Days',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textOnPrimary.withOpacity(0.9),
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
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'No data for this week yet!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(BuildContext context, String title, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
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

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Get.toNamed(AppRoutes.dailyLog),
      icon: const Icon(
        Icons.add,
        color: AppColors.textOnPrimary,
        size: 24,
      ),
      label: Text(
        'Log Food',
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
    );
  }

  void _testNotificationSetup(BuildContext context) {
    Get.snackbar(
      '🔍 Debug Test',
      'Testing notification setup...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
    
    // Test notification service
    final notificationService = NotificationService();
    
    // Get current user ID from environment
    const String? userIdFromDefine = String.fromEnvironment('USER_ID');
    String userId = userIdFromDefine ?? 'him';
    
    Get.snackbar(
      '🔍 Debug Info',
      'Current user: $userId',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
    
    // Re-initialize notification service
    notificationService.initialize(userId).then((_) {
      Get.snackbar(
        '✅ Debug Complete',
        'Notification setup test completed!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }).catchError((error) {
      Get.snackbar(
        '❌ Debug Error',
        'Error: $error',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    });
  }
}
