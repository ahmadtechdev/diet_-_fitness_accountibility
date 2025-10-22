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
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTabBar(context),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildWeeklySummary(context),
                  _buildMonthlySummary(context),
                  _buildExerciseAnalytics(context),
                  _buildDistributionAnalytics(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
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
                  backgroundColor: AppColors.textOnPrimary.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Summary & Analytics',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Comprehensive insights into your fitness journey',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textOnPrimary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.textOnPrimary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.analytics_outlined,
                  color: AppColors.textOnPrimary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Detailed Analytics',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppGradients.romantic,
          borderRadius: BorderRadius.circular(12),
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
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        tabs: const [
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Weekly'),
            ),
          ),
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Monthly'),
            ),
          ),
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Exercises'),
            ),
          ),
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Distribution'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentWeekCard(context),
          const SizedBox(height: 20),
          _buildWeeklyTrendChart(context),
          const SizedBox(height: 20),
          _buildWeeklyComparison(context),
          const SizedBox(height: 20),
          _buildWeeklyHistory(context),
        ],
      ),
    );
  }

  Widget _buildCurrentWeekCard(BuildContext context) {
    final currentWeek = _foodController.currentWeekSummary;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.romantic,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: AppColors.textOnPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'This Week Summary',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (currentWeek != null) ...[
              _buildWeekOverview(context, currentWeek),
              const SizedBox(height: 24),
              _buildPersonSummary(context, currentWeek.ahmadSummary, 'Him', '👨', AppColors.secondaryBlue),
              const SizedBox(height: 16),
              _buildPersonSummary(context, currentWeek.herSummary, 'Her', '👩', AppColors.primaryPink),
            ] else
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.textOnPrimary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 48,
                        color: AppColors.textOnPrimary.withOpacity(0.7),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No data for this week yet',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textOnPrimary.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start logging your food entries!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textOnPrimary.withOpacity(0.6),
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

  Widget _buildWeekOverview(BuildContext context, summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textOnPrimary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textOnPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.emoji_events,
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
                  summary.achievementMessage,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Week ${summary.weekNumber} • ${summary.cleanDays}/${summary.totalDays} clean days',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textOnPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${summary.cleanPercentage.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonSummary(BuildContext context, summary, String name, String emoji, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textOnPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textOnPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Text(
                name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textOnPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${summary.totalEntries} entries',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Clean',
                  summary.cleanEntries.toString(),
                  AppColors.cleanDayGreen,
                  Icons.eco,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  context,
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

  Widget _buildStatItem(BuildContext context, String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: color,
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

  Widget _buildWeeklyTrendChart(BuildContext context) {
    final weeklySummaries = _foodController.weeklySummaries;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.cleanDayGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: AppColors.cleanDayGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Weekly Clean Days Trend',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: weeklySummaries.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            size: 48,
                            color: AppColors.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No data available yet',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start tracking to see your progress',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: AppColors.border,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                                  strokeColor: AppColors.surfaceLight,
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
      ),
    );
  }

  Widget _buildWeeklyComparison(BuildContext context) {
    final currentWeek = _foodController.currentWeekSummary;
    final lastWeek = _foodController.weeklySummaries.length > 1 
        ? _foodController.weeklySummaries[_foodController.weeklySummaries.length - 2]
        : null;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    Icons.compare_arrows,
                    color: AppColors.primaryPink,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Week-over-Week ',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (currentWeek != null && lastWeek != null) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildComparisonCard(
                      context,
                      'This Week',
                      currentWeek.cleanDays,
                      currentWeek.totalDays,
                      AppColors.primaryPink,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildComparisonCard(
                      context,
                      'Last Week',
                      lastWeek.cleanDays,
                      lastWeek.totalDays,
                      AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildImprovementIndicator(context, currentWeek, lastWeek),
            ] else
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.trending_flat,
                      size: 48,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Need more data for comparison',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Track for at least 2 weeks to see trends',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary.withOpacity(0.7),
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

  Widget _buildComparisonCard(BuildContext context, String title, int cleanDays, int totalDays, Color color) {
    final percentage = totalDays > 0 ? (cleanDays / totalDays * 100) : 0.0;
    
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
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$cleanDays/$totalDays',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementIndicator(BuildContext context, currentWeek, lastWeek) {
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
      improvementColor = AppColors.textSecondary;
      improvementIcon = Icons.trending_flat;
      improvementText = '0.0%';
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: improvementColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: improvementColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: improvementColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(improvementIcon, color: improvementColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Improvement: $improvementText',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: improvementColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyHistory(BuildContext context) {
    final weeklySummaries = _foodController.weeklySummaries;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    Icons.history,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Weekly History',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (weeklySummaries.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.history,
                      size: 48,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No weekly data available yet',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your weekly summaries will appear here',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...weeklySummaries.take(5).map((summary) => _buildWeeklySummaryItem(context, summary)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummaryItem(BuildContext context, summary) {
    final achievementColor = _getAchievementColor(summary.achievementLevel);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: achievementColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: achievementColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: achievementColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getAchievementIcon(summary.achievementLevel),
              color: achievementColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Week ${summary.weekNumber}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${summary.cleanDays}/${summary.totalDays} clean days',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (summary.combinedFine.totalExercises > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${summary.combinedFine.totalExercises} total exercises',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${summary.cleanPercentage.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: achievementColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      summary.achievementMessage,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: achievementColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.end,
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

  Widget _buildMonthlySummary(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthlyOverview(context),
          const SizedBox(height: 20),
          _buildMonthlyChart(context),
          const SizedBox(height: 20),
          _buildMonthlyComparison(context),
          const SizedBox(height: 20),
          _buildMonthlyTrends(context),
        ],
      ),
    );
  }

  Widget _buildMonthlyOverview(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = now.month;
    final monthEntries = _foodController.foodEntries
        .where((e) => e.date.month == currentMonth)
        .toList();

    final cleanDays = monthEntries.where((e) => e.status == AppConstants.cleanDay).length;
    final junkDays = monthEntries.where((e) => e.status == AppConstants.junkFine).length;
    final totalDays = monthEntries.length;
    final cleanPercentage = totalDays > 0 ? (cleanDays / totalDays * 100) : 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.romantic,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_month,
                    color: AppColors.textOnPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Monthly Overview',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textOnPrimary,
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
                  child: _buildMonthlyStatCard(
                    context,
                    'Clean Days',
                    cleanDays.toString(),
                    AppColors.cleanDayGreen,
                    Icons.eco,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMonthlyStatCard(
                    context,
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
                color: AppColors.textOnPrimary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.textOnPrimary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.textOnPrimary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.trending_up, color: AppColors.textOnPrimary, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Clean Day Percentage',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textOnPrimary.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${cleanPercentage.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w500,
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
      ),
    );
  }

  Widget _buildMonthlyStatCard(BuildContext context, String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textOnPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textOnPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textOnPrimary.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyChart(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = now.month;
    final monthEntries = _foodController.foodEntries
        .where((e) => e.date.month == currentMonth)
        .toList();

    final cleanDays = monthEntries.where((e) => e.status == AppConstants.cleanDay).length;
    final junkDays = monthEntries.where((e) => e.status == AppConstants.junkFine).length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    Icons.pie_chart,
                    color: AppColors.primaryPink,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Monthly Distribution',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                      titleStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                    PieChartSectionData(
                      color: AppColors.junkFoodRed,
                      value: junkDays.toDouble(),
                      title: '$junkDays',
                      radius: 50,
                      titleStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(context, 'Clean Days', AppColors.cleanDayGreen),
                _buildLegendItem(context, 'Junk Days', AppColors.junkFoodRed),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
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
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyComparison(BuildContext context) {
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

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    Icons.compare_arrows,
                    color: AppColors.secondaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Month-over-Month Comparison',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (currentTotalDays > 0 && lastTotalDays > 0) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildComparisonCard(
                      context,
                      'This Month',
                      currentCleanDays,
                      currentTotalDays,
                      AppColors.primaryPink,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildComparisonCard(
                      context,
                      'Last Month',
                      lastCleanDays,
                      lastTotalDays,
                      AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
            ] else
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.trending_flat,
                      size: 48,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Need more data for comparison',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Track for at least 2 months to see trends',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary.withOpacity(0.7),
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

  Widget _buildMonthlyTrends(BuildContext context) {
    final now = DateTime.now();
    final months = List.generate(6, (index) {
      final month = now.month - index;
      return month <= 0 ? month + 12 : month;
    }).reversed.toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.cleanDayGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: AppColors.cleanDayGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '6-Month Trend',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
      ),
    );
  }

  Widget _buildExerciseAnalytics(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExerciseOverview(context),
          const SizedBox(height: 20),
          _buildExerciseBreakdown(context),
          const SizedBox(height: 20),
          _buildExerciseTrends(context),
          const SizedBox(height: 20),
          _buildExerciseComparison(context),
        ],
      ),
    );
  }

  Widget _buildExerciseOverview(BuildContext context) {
    final totalFines = _accountabilityController.totalPendingExercises;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.romantic,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: AppColors.textOnPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Exercise Overview',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textOnPrimary,
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
                  child: _buildExerciseStatCard(
                    context,
                    'Total Exercises',
                    totalFines.totalExercises.toString(),
                    AppColors.textOnPrimary,
                    Icons.fitness_center,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildExerciseStatCard(
                    context,
                    'Pending',
                    _accountabilityController.totalPendingFines.toString(),
                    AppColors.cheatMealOrange,
                    Icons.pending,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseStatCard(BuildContext context, String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textOnPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textOnPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textOnPrimary.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseBreakdown(BuildContext context) {
    final totalFines = _accountabilityController.totalPendingExercises;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.junkFoodRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.bar_chart,
                    color: AppColors.junkFoodRed,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Exercise Breakdown',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
    ));
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

  Widget _buildExerciseTrends(BuildContext context) {
    final weeklySummaries = _foodController.weeklySummaries;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    Icons.trending_up,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Exercise Trends',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
    ));
  }

  Widget _buildExerciseComparison(BuildContext context) {
    final himEntries = _accountabilityController.accountabilityEntries
        .where((e) => e.whoAte == AppConstants.him)
        .toList();
    final herEntries = _accountabilityController.accountabilityEntries
        .where((e) => e.whoAte == AppConstants.her)
        .toList();

    final himTotal = himEntries.fold(0, (sum, e) => sum + e.fine.totalExercises);
    final herTotal = herEntries.fold(0, (sum, e) => sum + e.fine.totalExercises);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    Icons.compare_arrows,
                    color: AppColors.secondaryTeal,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Exercise Comparison',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildPersonExerciseCard(context, 'Him', himTotal, AppColors.secondaryBlue, Icons.male),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPersonExerciseCard(context, 'Her', herTotal, AppColors.primaryPink, Icons.female),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonExerciseCard(BuildContext context, String name, int total, Color color, IconData icon) {
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
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            total.toString(),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$name Exercises',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionAnalytics(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDistributionOverview(context),
          const SizedBox(height: 20),
          _buildDistributionChart(context),
          const SizedBox(height: 20),
          _buildDistributionBreakdown(context),
          const SizedBox(height: 20),
          _buildDistributionTrends(context),
        ],
      ),
    );
  }

  Widget _buildDistributionOverview(BuildContext context) {
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
        decoration: BoxDecoration(
          gradient: AppGradients.romantic,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.share,
                    color: AppColors.textOnPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Partner Distribution',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textOnPrimary,
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
                  child: _buildDistributionStatCard(
                    context,
                    'Total Shared',
                    totalDistribution.toString(),
                    AppColors.textOnPrimary,
                    Icons.share,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDistributionStatCard(
                    context,
                    'Him from Her',
                    himFromHer.toString(),
                    AppColors.secondaryBlue,
                    Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDistributionStatCard(
                    context,
                    'Her from Him',
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

  Widget _buildDistributionStatCard(BuildContext context, String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textOnPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textOnPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textOnPrimary.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionChart(BuildContext context) {
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
        padding: const EdgeInsets.all(24),
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
                    Icons.pie_chart,
                    color: AppColors.primaryPink,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Distribution Breakdown',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: AppColors.secondaryBlue,
                      value: himFromHer.toDouble(),
                      title: '$himFromHer',
                      radius: 50,
                      titleStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                    PieChartSectionData(
                      color: AppColors.primaryPink,
                      value: herFromHim.toDouble(),
                      title: '$herFromHim',
                      radius: 50,
                      titleStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(context, 'Him from Her', AppColors.secondaryBlue),
                _buildLegendItem(context, 'Her from Him', AppColors.primaryPink),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionBreakdown(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    Icons.analytics,
                    color: AppColors.secondaryTeal,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Detailed Distribution',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDistributionItem(context, 'Him from Her', AppColors.secondaryBlue, AppConstants.him, true),
            const SizedBox(height: 16),
            _buildDistributionItem(context, 'Her from Him', AppColors.primaryPink, AppConstants.her, true),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionItem(BuildContext context, String title, Color color, String person, bool isFromPartner) {
    final entries = _accountabilityController.accountabilityEntries
        .where((e) => e.whoAte == person && e.isFromPartner == isFromPartner)
        .toList();
    
    final totalExercises = entries.fold(0, (sum, e) => sum + e.fine.totalExercises);
    final totalFines = entries.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
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
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalFines fines • $totalExercises exercises',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  Widget _buildDistributionTrends(BuildContext context) {
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
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    Icons.trending_up,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Weekly Distribution Trends',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                          color: AppColors.secondaryBlue,
                          width: 15,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          toY: herFromHim.toDouble(),
                          color: AppColors.primaryPink,
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(context, 'Him from Her', AppColors.secondaryBlue),
                _buildLegendItem(context, 'Her from Him', AppColors.primaryPink),
              ],
            ),
          ],
        ),
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