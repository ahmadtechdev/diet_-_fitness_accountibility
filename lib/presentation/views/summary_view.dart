import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/utils/colors.dart';
import '../../core/constants/app_constants.dart';
import '../controllers/food_tracker_controller.dart';
import '../controllers/accountability_controller.dart';
import '../controllers/settings_controller.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({super.key});

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final FoodTrackerController _foodController = Get.find<FoodTrackerController>();
  final AccountabilityController _accountabilityController = Get.find<AccountabilityController>();
  final SettingsController _settingsController = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
                  _buildWeeklySummary(),
                  _buildMonthlySummary(),
                  _buildExerciseAnalytics(),
                  _buildDistributionAnalytics(),
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
                'Summary & Analytics',
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
            'Comprehensive insights into your fitness journey',
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
                  '📊 Detailed Analytics',
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
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        isScrollable: true,
        tabs: const [
          Tab(text: 'Weekly'),
          Tab(text: 'Monthly'),
          Tab(text: 'Exercises'),
          Tab(text: 'Distribution'),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentWeekCard(),
          const SizedBox(height: 24),
          _buildWeeklyTrendChart(),
          const SizedBox(height: 24),
          _buildWeeklyComparison(),
          const SizedBox(height: 24),
          _buildWeeklyHistory(),
        ],
      ),
    );
  }

  Widget _buildCurrentWeekCard() {
    final currentWeek = _foodController.currentWeekSummary;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.romantic,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.3),
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
              const Icon(Icons.calendar_today, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text(
                'This Week Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (currentWeek != null) ...[
            _buildWeekOverview(currentWeek),
            const SizedBox(height: 20),
            _buildPersonSummary(currentWeek.ahmadSummary, 'Him', '👨', Colors.blue),
            const SizedBox(height: 12),
            _buildPersonSummary(currentWeek.herSummary, 'Her', '👩', Colors.pink),
          ] else
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 48,
                      color: Colors.white70,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No data for this week yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Start logging your food entries!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeekOverview(summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary.achievementMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Week ${summary.weekNumber} • ${summary.cleanDays}/${summary.totalDays} clean days',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${summary.cleanPercentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonSummary(summary, String name, String emoji, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${summary.totalEntries} entries',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Clean',
                  summary.cleanEntries.toString(),
                  AppColors.cleanDayGreen,
                  Icons.eco,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Junk',
                  summary.junkEntries.toString(),
                  AppColors.junkFoodRed,
                  Icons.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrendChart() {
    final weeklySummaries = _foodController.weeklySummaries;
    
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
            'Weekly Clean Days Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: weeklySummaries.isEmpty
                ? const Center(
                    child: Text(
                      'No data available yet',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() < weeklySummaries.length) {
                                return Text(
                                  'W${weeklySummaries[value.toInt()].weekNumber}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: weeklySummaries.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(), entry.value.cleanDays.toDouble());
                          }).toList(),
                          isCurved: true,
                          color: AppColors.cleanDayGreen,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: AppColors.cleanDayGreen,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.cleanDayGreen.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyComparison() {
    final currentWeek = _foodController.currentWeekSummary;
    final lastWeek = _foodController.weeklySummaries.length > 1 
        ? _foodController.weeklySummaries[_foodController.weeklySummaries.length - 2]
        : null;

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
            'Week-over-Week Comparison',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (currentWeek != null && lastWeek != null) ...[
            Row(
              children: [
                Expanded(
                  child: _buildComparisonCard(
                    'This Week',
                    currentWeek.cleanDays,
                    currentWeek.totalDays,
                    AppColors.primaryPink,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildComparisonCard(
                    'Last Week',
                    lastWeek.cleanDays,
                    lastWeek.totalDays,
                    AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildImprovementIndicator(currentWeek, lastWeek),
          ] else
            const Center(
              child: Text(
                'Need more data for comparison',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(String title, int cleanDays, int totalDays, Color color) {
    final percentage = totalDays > 0 ? (cleanDays / totalDays * 100) : 0.0;
    
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
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$cleanDays/$totalDays',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementIndicator(currentWeek, lastWeek) {
    final currentPercentage = currentWeek.totalDays > 0 ? (currentWeek.cleanDays / currentWeek.totalDays * 100) : 0.0;
    final lastPercentage = lastWeek.totalDays > 0 ? (lastWeek.cleanDays / lastWeek.totalDays * 100) : 0.0;
    final improvement = currentPercentage - lastPercentage;
    
    Color improvementColor;
    IconData improvementIcon;
    String improvementText;
    
    if (improvement > 0) {
      improvementColor = AppColors.cleanDayGreen;
      improvementIcon = Icons.trending_up;
      improvementText = '+${improvement.toStringAsFixed(1)}%';
    } else if (improvement < 0) {
      improvementColor = AppColors.junkFoodRed;
      improvementIcon = Icons.trending_down;
      improvementText = '${improvement.toStringAsFixed(1)}%';
    } else {
      improvementColor = Colors.grey;
      improvementIcon = Icons.trending_flat;
      improvementText = '0.0%';
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: improvementColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: improvementColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(improvementIcon, color: improvementColor, size: 20),
          const SizedBox(width: 8),
          Text(
            'Improvement: $improvementText',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: improvementColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyHistory() {
    final weeklySummaries = _foodController.weeklySummaries;
    
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
            'Weekly History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (weeklySummaries.isEmpty)
            const Center(
              child: Text(
                'No weekly data available yet',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            ...weeklySummaries.take(5).map((summary) => _buildWeeklySummaryItem(summary)),
        ],
      ),
    );
  }

  Widget _buildWeeklySummaryItem(summary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getAchievementColor(summary.achievementLevel).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getAchievementColor(summary.achievementLevel).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getAchievementColor(summary.achievementLevel).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getAchievementIcon(summary.achievementLevel),
              color: _getAchievementColor(summary.achievementLevel),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Week ${summary.weekNumber}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${summary.cleanDays}/${summary.totalDays} clean days',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (summary.combinedFine.totalExercises > 0)
                  Text(
                    '${summary.combinedFine.totalExercises} total exercises',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${summary.cleanPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getAchievementColor(summary.achievementLevel),
                ),
              ),
              Text(
                summary.achievementMessage,
                style: TextStyle(
                  fontSize: 12,
                  color: _getAchievementColor(summary.achievementLevel),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySummary() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthlyOverview(),
          const SizedBox(height: 24),
          _buildMonthlyChart(),
          const SizedBox(height: 24),
          _buildMonthlyComparison(),
          const SizedBox(height: 24),
          _buildMonthlyTrends(),
        ],
      ),
    );
  }

  Widget _buildMonthlyOverview() {
    final now = DateTime.now();
    final currentMonth = now.month;
    final monthEntries = _foodController.foodEntries
        .where((e) => e.date.month == currentMonth)
        .toList();

    final cleanDays = monthEntries.where((e) => e.status == AppConstants.cleanDay).length;
    final junkDays = monthEntries.where((e) => e.status == AppConstants.junkFine).length;
    final totalDays = monthEntries.length;
    final cleanPercentage = totalDays > 0 ? (cleanDays / totalDays * 100) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.romantic,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.3),
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
              const Icon(Icons.calendar_month, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Monthly Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMonthlyStatCard(
                  'Clean Days',
                  cleanDays.toString(),
                  AppColors.cleanDayGreen,
                  Icons.eco,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMonthlyStatCard(
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
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Clean Day Percentage',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${cleanPercentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
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

  Widget _buildMonthlyChart() {
    final now = DateTime.now();
    final currentMonth = now.month;
    final monthEntries = _foodController.foodEntries
        .where((e) => e.date.month == currentMonth)
        .toList();

    final cleanDays = monthEntries.where((e) => e.status == AppConstants.cleanDay).length;
    final junkDays = monthEntries.where((e) => e.status == AppConstants.junkFine).length;

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
            'Monthly Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    color: AppColors.cleanDayGreen,
                    value: cleanDays.toDouble(),
                    title: '$cleanDays',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: AppColors.junkFoodRed,
                    value: junkDays.toDouble(),
                    title: '$junkDays',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Clean Days', AppColors.cleanDayGreen),
              _buildLegendItem('Junk Days', AppColors.junkFoodRed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyComparison() {
    final now = DateTime.now();
    final currentMonth = now.month;
    final lastMonth = currentMonth == 1 ? 12 : currentMonth - 1;
    
    final currentMonthEntries = _foodController.foodEntries
        .where((e) => e.date.month == currentMonth)
        .toList();
    final lastMonthEntries = _foodController.foodEntries
        .where((e) => e.date.month == lastMonth)
        .toList();

    final currentCleanDays = currentMonthEntries.where((e) => e.status == AppConstants.cleanDay).length;
    final lastCleanDays = lastMonthEntries.where((e) => e.status == AppConstants.cleanDay).length;
    final currentTotalDays = currentMonthEntries.length;
    final lastTotalDays = lastMonthEntries.length;

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
            'Month-over-Month Comparison',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (currentTotalDays > 0 && lastTotalDays > 0) ...[
            Row(
              children: [
                Expanded(
                  child: _buildComparisonCard(
                    'This Month',
                    currentCleanDays,
                    currentTotalDays,
                    AppColors.primaryPink,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildComparisonCard(
                    'Last Month',
                    lastCleanDays,
                    lastTotalDays,
                    AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
          ] else
            const Center(
              child: Text(
                'Need more data for comparison',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrends() {
    final now = DateTime.now();
    final months = List.generate(6, (index) {
      final month = now.month - index;
      return month <= 0 ? month + 12 : month;
    }).reversed.toList();

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
            '6-Month Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 30,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < months.length) {
                          return Text(
                            'M${months[value.toInt()]}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: months.asMap().entries.map((entry) {
                  final monthEntries = _foodController.foodEntries
                      .where((e) => e.date.month == entry.value)
                      .toList();
                  final cleanDays = monthEntries.where((e) => e.status == AppConstants.cleanDay).length;
                  
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: cleanDays.toDouble(),
                        color: AppColors.cleanDayGreen,
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseAnalytics() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExerciseOverview(),
          const SizedBox(height: 24),
          _buildExerciseBreakdown(),
          const SizedBox(height: 24),
          _buildExerciseTrends(),
          const SizedBox(height: 24),
          _buildExerciseComparison(),
        ],
      ),
    );
  }

  Widget _buildExerciseOverview() {
    final totalFines = _accountabilityController.totalPendingExercises;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.romantic,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.3),
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
              const Icon(Icons.fitness_center, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Exercise Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildExerciseStatCard(
                  'Total Exercises',
                  totalFines.totalExercises.toString(),
                  Colors.white,
                  Icons.fitness_center,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildExerciseStatCard(
                  'Pending',
                  _accountabilityController.totalPendingFines.toString(),
                  Colors.orange,
                  Icons.pending,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
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
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: [
                  totalFines.jumpingRopes,
                  totalFines.squats,
                  totalFines.jumpingJacks,
                  totalFines.highKnees,
                  totalFines.pushups,
                ].reduce((a, b) => a > b ? a : b).toDouble() + 10,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = ['JR', 'SQ', 'JJ', 'HK', 'PU'];
                        if (value.toInt() < labels.length) {
                          return Text(
                            labels[value.toInt()],
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: totalFines.jumpingRopes.toDouble(),
                        color: AppColors.jumpingRopes,
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: totalFines.squats.toDouble(),
                        color: AppColors.squats,
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: totalFines.jumpingJacks.toDouble(),
                        color: AppColors.jumpingJacks,
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: totalFines.highKnees.toDouble(),
                        color: AppColors.highKnees,
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(
                        toY: totalFines.pushups.toDouble(),
                        color: AppColors.pushups,
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildExerciseLegend('Jumping Ropes', AppColors.jumpingRopes, totalFines.jumpingRopes),
              _buildExerciseLegend('Squats', AppColors.squats, totalFines.squats),
              _buildExerciseLegend('Jumping Jacks', AppColors.jumpingJacks, totalFines.jumpingJacks),
              _buildExerciseLegend('High Knees', AppColors.highKnees, totalFines.highKnees),
              _buildExerciseLegend('Pushups', AppColors.pushups, totalFines.pushups),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseLegend(String label, Color color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label ($count)',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseTrends() {
    final weeklySummaries = _foodController.weeklySummaries;
    
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
            'Exercise Trends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: weeklySummaries.isEmpty
                ? const Center(
                    child: Text(
                      'No data available yet',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() < weeklySummaries.length) {
                                return Text(
                                  'W${weeklySummaries[value.toInt()].weekNumber}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: weeklySummaries.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(), entry.value.combinedFine.totalExercises.toDouble());
                          }).toList(),
                          isCurved: true,
                          color: AppColors.junkFoodRed,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: AppColors.junkFoodRed,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.junkFoodRed.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseComparison() {
    final himEntries = _accountabilityController.accountabilityEntries
        .where((e) => e.whoAte == AppConstants.him)
        .toList();
    final herEntries = _accountabilityController.accountabilityEntries
        .where((e) => e.whoAte == AppConstants.her)
        .toList();

    final himTotal = himEntries.fold(0, (sum, e) => sum + e.fine.totalExercises);
    final herTotal = herEntries.fold(0, (sum, e) => sum + e.fine.totalExercises);

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
            'Exercise Comparison',
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
                child: _buildPersonExerciseCard('Him', himTotal, Colors.blue, Icons.male),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPersonExerciseCard('Her', herTotal, Colors.pink, Icons.female),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonExerciseCard(String name, int total, Color color, IconData icon) {
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
            total.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            '$name Exercises',
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

  Widget _buildDistributionAnalytics() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDistributionOverview(),
          const SizedBox(height: 24),
          _buildDistributionChart(),
          const SizedBox(height: 24),
          _buildDistributionBreakdown(),
          const SizedBox(height: 24),
          _buildDistributionTrends(),
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

    final totalDistribution = himFromHer + herFromHim;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.romantic,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.3),
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
              const Icon(Icons.share, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Partner Distribution',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDistributionStatCard(
                  'Total Shared',
                  totalDistribution.toString(),
                  Colors.white,
                  Icons.share,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDistributionStatCard(
                  'Him from Her',
                  himFromHer.toString(),
                  Colors.blue,
                  Icons.arrow_downward,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDistributionStatCard(
                  'Her from Him',
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

  Widget _buildDistributionStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionChart() {
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
            'Distribution Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    color: Colors.blue,
                    value: himFromHer.toDouble(),
                    title: '$himFromHer',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.pink,
                    value: herFromHim.toDouble(),
                    title: '$herFromHim',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Him from Her', Colors.blue),
              _buildLegendItem('Her from Him', Colors.pink),
            ],
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
            'Detailed Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDistributionItem('Him from Her', Colors.blue, AppConstants.him, true),
          const SizedBox(height: 12),
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
    final currentWeek = _getCurrentWeek();
    final weeks = List.generate(4, (index) => currentWeek - index);
    
    // Calculate the maximum value for Y-axis
    double maxY = 0;
    for (final week in weeks) {
      final weekEntries = _accountabilityController.accountabilityEntries
          .where((e) => e.weekNumber == week)
          .toList();
      
      final himFromHer = weekEntries
          .where((e) => e.whoAte == AppConstants.him && e.isFromPartner)
          .fold(0, (sum, e) => sum + e.fine.totalExercises);
      
      final herFromHim = weekEntries
          .where((e) => e.whoAte == AppConstants.her && e.isFromPartner)
          .fold(0, (sum, e) => sum + e.fine.totalExercises);
      
      final weekMax = [himFromHer, herFromHim].reduce((a, b) => a > b ? a : b);
      if (weekMax > maxY) {
        maxY = weekMax.toDouble();
      }
    }
    
    // Add some padding to the max value and ensure minimum height
    maxY = (maxY * 1.1).clamp(10.0, double.infinity);
    
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
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < weeks.length) {
                          return Text(
                            'W${weeks[value.toInt()]}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: weeks.asMap().entries.map((entry) {
                  final weekEntries = _accountabilityController.accountabilityEntries
                      .where((e) => e.weekNumber == entry.value)
                      .toList();
                  
                  final himFromHer = weekEntries
                      .where((e) => e.whoAte == AppConstants.him && e.isFromPartner)
                      .fold(0, (sum, e) => sum + e.fine.totalExercises);
                  
                  final herFromHim = weekEntries
                      .where((e) => e.whoAte == AppConstants.her && e.isFromPartner)
                      .fold(0, (sum, e) => sum + e.fine.totalExercises);

                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: himFromHer.toDouble(),
                        color: Colors.blue,
                        width: 15,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: herFromHim.toDouble(),
                        color: Colors.pink,
                        width: 15,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Him from Her', Colors.blue),
              _buildLegendItem('Her from Him', Colors.pink),
            ],
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

  Color _getAchievementColor(String level) {
    switch (level) {
      case 'excellent':
        return AppColors.cleanDayGreen;
      case 'good':
        return Colors.orange;
      default:
        return AppColors.junkFoodRed;
    }
  }

  IconData _getAchievementIcon(String level) {
    switch (level) {
      case 'excellent':
        return Icons.emoji_events;
      case 'good':
        return Icons.trending_up;
      default:
        return Icons.fitness_center;
    }
  }
}