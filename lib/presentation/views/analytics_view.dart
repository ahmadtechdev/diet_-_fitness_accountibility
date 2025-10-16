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
      backgroundColor: AppColors.background,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.romantic,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text(
                'Analytics & Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Track your fitness journey together',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '📊 Comprehensive Analytics',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primaryPink,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMotivationalBanner(),
          const SizedBox(height: 24),
          _buildQuickStats(),
          const SizedBox(height: 24),
          _buildWeeklyProgress(),
          const SizedBox(height: 24),
          _buildMonthlyProgress(),
          const SizedBox(height: 24),
          _buildExerciseBreakdown(),
        ],
      ),
    );
  }

  Widget _buildIndividualAnalytics() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPersonAnalytics(AppConstants.him, 'Him', Colors.blue),
          const SizedBox(height: 24),
          _buildPersonAnalytics(AppConstants.her, 'Her', Colors.pink),
        ],
      ),
    );
  }

  Widget _buildPartnerDistributionAnalytics() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDistributionSummary(),
          const SizedBox(height: 24),
          _buildDistributionOverview(),
          const SizedBox(height: 24),
          _buildDistributionBreakdown(),
          const SizedBox(height: 24),
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
    
    if (cleanPercentage >= 80) {
      motivationalMessage = "🌟 Amazing! You're crushing your fitness goals together!";
      bannerColor = AppColors.cleanDayGreen;
    } else if (cleanPercentage >= 60) {
      motivationalMessage = "💪 Great progress! Keep up the excellent work!";
      bannerColor = Colors.orange;
    } else {
      motivationalMessage = "🚀 Every step counts! You're building healthy habits together!";
      bannerColor = AppColors.primaryPink;
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bannerColor.withOpacity(0.1), bannerColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bannerColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.favorite,
            color: bannerColor,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            motivationalMessage,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: bannerColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${cleanPercentage.toStringAsFixed(1)}% Clean Days',
            style: TextStyle(
              fontSize: 14,
              color: bannerColor.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
        const Text(
          'Quick Stats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
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
                Colors.orange,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildWeekProgressBar(),
        ],
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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Clean Days: $cleanDays'),
            Text('Total Days: $totalDays'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 0.8 ? AppColors.cleanDayGreen : 
            progress >= 0.6 ? Colors.orange : AppColors.junkFoodRed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${(progress * 100).toStringAsFixed(1)}% Clean',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: progress >= 0.8 ? AppColors.cleanDayGreen : 
                   progress >= 0.6 ? Colors.orange : AppColors.junkFoodRed,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildMonthlyChart(),
        ],
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
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.cleanDayGreen,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    cleanDays.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Clean Days', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.junkFoodRed,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    junkDays.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Junk Days', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseBreakdown() {
    final totalFines = _accountabilityController.totalPendingExercises;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exercise Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildExerciseItem('🔄', 'Jumping Ropes', totalFines.jumpingRopes),
          _buildExerciseItem('🦵', 'Squats', totalFines.squats),
          _buildExerciseItem('🤸', 'Jumping Jacks', totalFines.jumpingJacks),
          _buildExerciseItem('🏃', 'High Knees', totalFines.highKnees),
          _buildExerciseItem('💪', 'Pushups', totalFines.pushups),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(String emoji, String name, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '$count sets',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  person == AppConstants.him ? Icons.male : Icons.female,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$displayName Analytics',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Clean Day Percentage',
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${cleanPercentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 24,
                    color: color,
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

  Widget _buildPersonStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
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
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryPink.withOpacity(0.1), AppColors.primaryPurple.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryPink.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.share,
                color: AppColors.primaryPink,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Partner Distribution Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      totalDistribution.toString(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPink,
                      ),
                    ),
                    const Text(
                      'Total Shared Exercises',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.border,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${totalDistribution > 0 ? ((himFromHer / totalDistribution) * 100).toStringAsFixed(1) : '0.0'}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Text(
                      'Him from Her',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.border,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${totalDistribution > 0 ? ((herFromHim / totalDistribution) * 100).toStringAsFixed(1) : '0.0'}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    const Text(
                      'Her from Him',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Partner Distribution Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDistributionCard(
                  'Him gets from Her',
                  himFromHer.toString(),
                  Colors.blue,
                  Icons.arrow_downward,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDistributionCard(
                  'Her gets from Him',
                  herFromHim.toString(),
                  Colors.pink,
                  Icons.arrow_upward,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribution Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDistributionItem('Him from Her', Colors.blue, AppConstants.him, true),
          _buildDistributionItem('Her from Him', Colors.pink, AppConstants.her, true),
        ],
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              person == AppConstants.him ? Icons.male : Icons.female,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalFines fines • $totalExercises exercises',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionTrends() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Distribution Trends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildWeeklyTrendChart(),
        ],
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
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                'Week $week',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTrendBar('Him', himFromHer, Colors.blue),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTrendBar('Her', herFromHim, Colors.pink),
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
    
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  int _getCurrentWeek() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final daysSinceFirstDay = now.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).floor() + 1;
  }
}