import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/colors.dart';
import '../../core/constants/app_constants.dart';
import '../controllers/food_tracker_controller.dart';
import '../controllers/accountability_controller.dart';
import '../controllers/settings_controller.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final FoodTrackerController _foodController = Get.find<FoodTrackerController>();
  final AccountabilityController _accountabilityController = Get.find<AccountabilityController>();
  final SettingsController _settingsController = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCombinedAnalytics(),
                  _buildIndividualAnalytics(),
                  _buildPartnerDistributionAnalytics(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        gradient: AppGradients.romantic,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.textOnPrimary,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Analytics & Summary',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Track your fitness journey together',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textOnPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              '📊 Comprehensive Analytics',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppGradients.romantic,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPink.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: AppColors.textOnPrimary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: 'Combined'),
          Tab(text: 'Individual'),
          Tab(text: 'Distribution'),
        ],
      ),
    );
  }

  Widget _buildCombinedAnalytics() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMotivationalBanner(),
          const SizedBox(height: 20),
          _buildQuickStats(),
          const SizedBox(height: 20),
          _buildWeeklyProgress(),
          const SizedBox(height: 20),
          _buildMonthlyProgress(),
          const SizedBox(height: 20),
          _buildExerciseBreakdown(),
        ],
      ),
    );
  }

  Widget _buildIndividualAnalytics() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          _buildPersonAnalytics(AppConstants.him, 'Him', AppColors.secondaryBlue),
          const SizedBox(height: 20),
          _buildPersonAnalytics(AppConstants.her, 'Her', AppColors.primaryPink),
        ],
      ),
    );
  }

  Widget _buildPartnerDistributionAnalytics() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDistributionSummary(),
          const SizedBox(height: 20),
          _buildDistributionOverview(),
          const SizedBox(height: 20),
          _buildDistributionBreakdown(),
          const SizedBox(height: 20),
          _buildDistributionTrends(),
        ],
      ),
    );
  }

  Widget _buildMotivationalBanner() {
    final cleanDays = _foodController.foodEntries
        .where((e) => e.status == AppConstants.cleanDay).length;
    final totalDays = _foodController.foodEntries.length;
    final cleanPercentage = totalDays > 0 ? (cleanDays / totalDays * 100) : 0.0;
    
    String motivationalMessage;
    Color bannerColor;
    IconData bannerIcon;
    
    if (cleanPercentage >= 80) {
      motivationalMessage = "🌟 Amazing! You're crushing your fitness goals together!";
      bannerColor = AppColors.cleanDayGreen;
      bannerIcon = Icons.star;
    } else if (cleanPercentage >= 60) {
      motivationalMessage = "💪 Great progress! Keep up the excellent work!";
      bannerColor = AppColors.cheatMealOrange;
      bannerIcon = Icons.trending_up;
    } else {
      motivationalMessage = "🚀 Every step counts! You're building healthy habits together!";
      bannerColor = AppColors.primaryPink;
      bannerIcon = Icons.favorite;
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              bannerColor.withOpacity(0.1),
              bannerColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: bannerColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bannerColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                bannerIcon,
                color: bannerColor,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              motivationalMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bannerColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: bannerColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: bannerColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                '${cleanPercentage.toStringAsFixed(1)}% Clean Days',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: bannerColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    final totalEntries = _foodController.foodEntries.length;
    final cleanDays = _foodController.foodEntries
        .where((e) => e.status == AppConstants.cleanDay).length;
    final junkDays = _foodController.foodEntries
        .where((e) => e.status == AppConstants.junkFine).length;
    final totalFines = _accountabilityController.totalPendingExercises;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Quick Stats',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Days',
                totalEntries.toString(),
                AppColors.primaryPink,
                Icons.calendar_today,
                AppGradients.romantic,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Clean Days',
                cleanDays.toString(),
                AppColors.cleanDayGreen,
                Icons.eco,
                AppGradients.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Junk Days',
                junkDays.toString(),
                AppColors.junkFoodRed,
                Icons.fastfood,
                AppGradients.error,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Total Fines',
                totalFines.toString(),
                AppColors.cheatMealOrange,
                Icons.fitness_center,
                AppGradients.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon, LinearGradient gradient) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
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
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textOnPrimary.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgress() {
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
                  child: Icon(
                    Icons.trending_up,
                    color: AppColors.primaryPink,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'This Week Progress',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildWeekProgressBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekProgressBar() {
    final currentWeek = _getCurrentWeek();
    final weekEntries = _foodController.foodEntries
        .where((e) => e.weekNumber == currentWeek)
        .toList();
    
    final cleanDays = weekEntries.where((e) => e.status == AppConstants.cleanDay).length;
    final totalDays = weekEntries.length;
    final progress = totalDays > 0 ? cleanDays / totalDays : 0.0;

    Color progressColor;
    if (progress >= 0.8) {
      progressColor = AppColors.cleanDayGreen;
    } else if (progress >= 0.6) {
      progressColor = AppColors.cheatMealOrange;
    } else {
      progressColor = AppColors.junkFoodRed;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cleanDayGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Clean Days: $cleanDays',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.cleanDayGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Total Days: $totalDays',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    progressColor,
                    progressColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: progressColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: progressColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            '${(progress * 100).toStringAsFixed(1)}% Clean',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: progressColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyProgress() {
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
                    color: AppColors.secondaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calendar_month,
                    color: AppColors.secondaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Monthly Overview',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildMonthlyChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyChart() {
    final now = DateTime.now();
    final currentMonth = now.month;
    final monthEntries = _foodController.foodEntries
        .where((e) => e.date.month == currentMonth)
        .toList();

    final cleanDays = monthEntries.where((e) => e.status == AppConstants.cleanDay).length;
    final junkDays = monthEntries.where((e) => e.status == AppConstants.junkFine).length;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppGradients.success,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cleanDayGreen.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      cleanDays.toString(),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Clean Days',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppGradients.error,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.junkFoodRed.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      junkDays.toString(),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Junk Days',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseBreakdown() {
    final totalFines = _accountabilityController.totalPendingExercises;
    
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
                    color: AppColors.cheatMealOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    color: AppColors.cheatMealOrange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Exercise Breakdown',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildExerciseItem('🔄', 'Jumping Ropes', totalFines.jumpingRopes, AppColors.jumpingRopes),
            _buildExerciseItem('🦵', 'Squats', totalFines.squats, AppColors.squats),
            _buildExerciseItem('🤸', 'Jumping Jacks', totalFines.jumpingJacks, AppColors.jumpingJacks),
            _buildExerciseItem('🏃', 'High Knees', totalFines.highKnees, AppColors.highKnees),
            _buildExerciseItem('💪', 'Pushups', totalFines.pushups, AppColors.pushups),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(String emoji, String name, int count, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              '$count sets',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonAnalytics(String person, String displayName, Color color) {
    final personEntries = _foodController.foodEntries
        .where((e) => e.whoAte == person)
        .toList();
    
    final cleanDays = personEntries.where((e) => e.status == AppConstants.cleanDay).length;
    final junkDays = personEntries.where((e) => e.status == AppConstants.junkFine).length;
    final totalDays = personEntries.length;
    final cleanPercentage = totalDays > 0 ? (cleanDays / totalDays * 100) : 0.0;

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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    person == AppConstants.him ? Icons.male : Icons.female,
                    color: AppColors.textOnPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '$displayName Analytics',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildPersonStatCard(
                    'Clean Days',
                    cleanDays.toString(),
                    AppColors.cleanDayGreen,
                    Icons.eco,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPersonStatCard(
                    'Junk Days',
                    junkDays.toString(),
                    AppColors.junkFoodRed,
                    Icons.fastfood,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.1),
                    color.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Clean Day Percentage',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${cleanPercentage.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionSummary() {
    final himFromHer = _accountabilityController.accountabilityEntries
        .where((e) => e.whoAte == AppConstants.him && e.isFromPartner)
        .fold(0, (sum, e) => sum + e.fine.totalExercises);
    
    final herFromHim = _accountabilityController.accountabilityEntries
        .where((e) => e.whoAte == AppConstants.her && e.isFromPartner)
        .fold(0, (sum, e) => sum + e.fine.totalExercises);

    final totalDistribution = himFromHer + herFromHim;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryPink.withOpacity(0.1),
              AppColors.primaryPurple.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryPink.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
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
                    Icons.share,
                    color: AppColors.primaryPink,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Partner Distribution Summary',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryPink.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    totalDistribution.toString(),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.primaryPink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total Shared Exercises',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${totalDistribution > 0 ? ((himFromHer / totalDistribution) * 100).toStringAsFixed(1) : '0.0'}%',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.secondaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Him from Her',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPink.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${totalDistribution > 0 ? ((herFromHim / totalDistribution) * 100).toStringAsFixed(1) : '0.0'}%',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.primaryPink,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Her from Him',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionOverview() {
    final himFromHer = _accountabilityController.accountabilityEntries
        .where((e) => e.whoAte == AppConstants.him && e.isFromPartner)
        .fold(0, (sum, e) => sum + e.fine.totalExercises);
    
    final herFromHim = _accountabilityController.accountabilityEntries
        .where((e) => e.whoAte == AppConstants.her && e.isFromPartner)
        .fold(0, (sum, e) => sum + e.fine.totalExercises);

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
                    color: AppColors.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.analytics,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Partner Distribution Overview',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildDistributionCard(
                    'Him gets from Her',
                    himFromHer.toString(),
                    AppColors.secondaryBlue,
                    Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDistributionCard(
                    'Her gets from Him',
                    herFromHim.toString(),
                    AppColors.primaryPink,
                    Icons.arrow_upward,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionBreakdown() {
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
                    color: AppColors.secondaryTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.area_chart,
                    color: AppColors.secondaryTeal,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Distribution Breakdown',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDistributionItem('Him from Her', AppColors.secondaryBlue, AppConstants.him, true),
            _buildDistributionItem('Her from Him', AppColors.primaryPink, AppConstants.her, true),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionItem(String title, Color color, String person, bool isFromPartner) {
    final entries = _accountabilityController.accountabilityEntries
        .where((e) => e.whoAte == person && e.isFromPartner == isFromPartner)
        .toList();
    
    final totalExercises = entries.fold(0, (sum, e) => sum + e.fine.totalExercises);
    final totalFines = entries.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.8)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              person == AppConstants.him ? Icons.male : Icons.female,
              color: AppColors.textOnPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$totalFines fines',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$totalExercises exercises',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionTrends() {
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
                    color: AppColors.cheatMealOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: AppColors.cheatMealOrange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Weekly Distribution Trends',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildWeeklyTrendChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyTrendChart() {
    final currentWeek = _getCurrentWeek();
    final weeks = List.generate(4, (index) => currentWeek - index);
    
    return Column(
      children: weeks.reversed.map((week) {
        final weekEntries = _accountabilityController.accountabilityEntries
            .where((e) => e.weekNumber == week)
            .toList();
        
        final himFromHer = weekEntries
            .where((e) => e.whoAte == AppConstants.him && e.isFromPartner)
            .fold(0, (sum, e) => sum + e.fine.totalExercises);
        
        final herFromHim = weekEntries
            .where((e) => e.whoAte == AppConstants.her && e.isFromPartner)
            .fold(0, (sum, e) => sum + e.fine.totalExercises);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryPink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Week $week',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primaryPink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTrendBar('Him', himFromHer, AppColors.secondaryBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTrendBar('Her', herFromHim, AppColors.primaryPink),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrendBar(String label, int value, Color color) {
    final maxValue = 50; // Adjust based on your data
    final height = (value / maxValue * 40).clamp(4.0, 40.0);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  int _getCurrentWeek() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final daysSinceFirstDay = now.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).floor() + 1;
  }
}
