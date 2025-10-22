import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/colors.dart';
import '../controllers/food_tracker_controller.dart';
import '../controllers/accountability_controller.dart';
import '../../data/models/food_entry.dart';
import '../../data/models/accountability_entry.dart';
import 'package:intl/intl.dart';

class ComprehensiveAnalyticsView extends StatefulWidget {
  const ComprehensiveAnalyticsView({super.key});

  @override
  State<ComprehensiveAnalyticsView> createState() => _ComprehensiveAnalyticsViewState();
}

class _ComprehensiveAnalyticsViewState extends State<ComprehensiveAnalyticsView>
    with TickerProviderStateMixin {
  final FoodTrackerController _foodController = Get.find<FoodTrackerController>();
  final AccountabilityController _accountabilityController = Get.find<AccountabilityController>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Profile selection
  String _selectedProfile = 'Us'; // 'Us', 'Him', 'Her'
  
  // Date range selection
  DateTimeRange? _selectedDateRange;
  String _selectedFilter = 'This Week';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();

  // Chart data
  final List<FlSpot> _exercisesPerformedData = [];
  final List<FlSpot> _exercisesAddedData = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeDateRange();
    _loadAnalyticsData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _initializeDateRange() {
    final now = DateTime.now();
    _startDate = now.subtract(const Duration(days: 7));
    _endDate = now;
    _selectedDateRange = DateTimeRange(start: _startDate, end: _endDate);
  }

  void _loadAnalyticsData() {
    _updateChartData();
  }

  void _updateChartData() {
    final filteredEntries = _getFilteredEntries();
    _generateTrendData(filteredEntries);
  }

  List<FoodEntry> _getFilteredEntries() {
    List<FoodEntry> entries = _foodController.foodEntries.where((entry) {
      return entry.date.isAfter(_startDate.subtract(const Duration(days: 1))) &&
             entry.date.isBefore(_endDate.add(const Duration(days: 1)));
    }).toList();

    // Filter by profile if not combined
    if (_selectedProfile != 'Us') {
      entries = entries.where((entry) {
        if (_selectedProfile == 'Him') {
          return entry.whoAte == AppConstants.him || entry.whoAte == AppConstants.ahmad;
        } else if (_selectedProfile == 'Her') {
          return entry.whoAte == AppConstants.her;
        }
        return true; // Combined view
      }).toList();
    }

    return entries;
  }

  List<AccountabilityEntry> _getFilteredAccountabilityEntries() {
    List<AccountabilityEntry> entries = _accountabilityController.accountabilityEntries.where((entry) {
      return entry.date.isAfter(_startDate.subtract(const Duration(days: 1))) &&
             entry.date.isBefore(_endDate.add(const Duration(days: 1)));
    }).toList();

    // Filter by profile if not combined
    if (_selectedProfile != 'Us') {
      entries = entries.where((entry) {
        if (_selectedProfile == 'Him') {
          return entry.whoAte == AppConstants.him || entry.whoAte == AppConstants.ahmad;
        } else if (_selectedProfile == 'Her') {
          return entry.whoAte == AppConstants.her;
        }
        return true; // Combined view
      }).toList();
    }

    return entries;
  }

  void _generateTrendData(List<FoodEntry> entries) {
    // Get accountability entries for the date range
    final accountabilityEntries = _getFilteredAccountabilityEntries();
    
    // Group accountability entries by date
    final Map<String, List<AccountabilityEntry>> entriesByDate = {};
    for (final entry in accountabilityEntries) {
      final dateKey = DateFormat('yyyy-MM-dd').format(entry.date);
      entriesByDate.putIfAbsent(dateKey, () => []).add(entry);
    }

    // Generate trend data
    _exercisesPerformedData.clear();
    _exercisesAddedData.clear();

    final sortedDates = entriesByDate.keys.toList()..sort();
    
    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      final dayEntries = entriesByDate[date]!;
      
      // Calculate exercises performed (total exercises completed)
      final exercisesPerformed = dayEntries
          .where((e) => e.isCompleted)
          .fold(0, (sum, e) => sum + e.fine.totalExercises);
      
      // Calculate exercises added (total exercises assigned as fines)
      final exercisesAdded = dayEntries.fold(0, (sum, e) => sum + e.fine.totalExercises);
      
      _exercisesPerformedData.add(FlSpot(i.toDouble(), exercisesPerformed.toDouble()));
      _exercisesAddedData.add(FlSpot(i.toDouble(), exercisesAdded.toDouble()));
      
      // Debug information
      print('📊 Chart Data for Day ${i + 1}:');
      print('   Exercises Performed: $exercisesPerformed');
      print('   Exercises Added: $exercisesAdded');
      print('   Day Entries Count: ${dayEntries.length}');
    }
  }

  void _onProfileChanged(String profile) {
    // Add smooth transition animation
    _animationController.reset();
    setState(() {
      _selectedProfile = profile;
    });
    _loadAnalyticsData();
    _animationController.forward();
  }

  void _onFilterChanged(String filter) {
    // Add smooth transition animation
    _animationController.reset();
    setState(() {
      _selectedFilter = filter;
      final now = DateTime.now();
      
      switch (filter) {
        case 'Today':
          _startDate = DateTime(now.year, now.month, now.day);
          _endDate = now;
          break;
        case 'This Week':
          _startDate = now.subtract(Duration(days: now.weekday - 1));
          _endDate = now;
          break;
        case 'Last Week':
          _startDate = now.subtract(Duration(days: now.weekday + 6));
          _endDate = now.subtract(Duration(days: now.weekday));
          break;
        case 'This Month':
          _startDate = DateTime(now.year, now.month, 1);
          _endDate = now;
          break;
        case 'Last Month':
          final lastMonth = DateTime(now.year, now.month - 1, 1);
          _startDate = lastMonth;
          _endDate = DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
          break;
        case 'Custom':
          _showDateRangePicker();
          return;
      }
      
      _selectedDateRange = DateTimeRange(start: _startDate, end: _endDate);
    });
    _loadAnalyticsData();
    _animationController.forward();
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
             colorScheme: Theme.of(context).colorScheme.copyWith(
               primary: AppColors.primaryPink,
               onPrimary: Colors.white,
             ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Add smooth transition animation
      _animationController.reset();
      setState(() {
        _selectedDateRange = picked;
        _startDate = picked.start;
        _endDate = picked.end;
        _selectedFilter = 'Custom';
      });
      _loadAnalyticsData();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Comprehensive Analytics',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
         backgroundColor: AppColors.primaryPink,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileSelector(),
                const SizedBox(height: 16),
                _buildDateRangeSelector(),
                const SizedBox(height: 24),
                _buildSummaryCards(),
                const SizedBox(height: 24),
                _buildTrendCharts(),
                const SizedBox(height: 24),
                _buildCategoryBreakdown(),
                const SizedBox(height: 24),
                _buildPerformanceComparison(),
                const SizedBox(height: 24),
                _buildDetailedInsights(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile View',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildProfileChip('Us', '👫'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildProfileChip('Him', '👨'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildProfileChip('Her', '👩'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileChip(String profile, String emoji) {
    final isSelected = _selectedProfile == profile;
    return GestureDetector(
      onTap: () => _onProfileChanged(profile),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPink : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryPink : AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              profile,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date Range',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Today',
              'This Week',
              'Last Week',
              'This Month',
              'Last Month',
              'Custom',
            ].map((filter) => _buildFilterChip(filter)).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                '${DateFormat('MMM dd, yyyy').format(_startDate)} - ${DateFormat('MMM dd, yyyy').format(_endDate)}',
                style: const TextStyle(
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

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () => _onFilterChanged(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
           color: isSelected ? AppColors.primaryPink : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryPink : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          filter,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final filteredAccountabilityEntries = _getFilteredAccountabilityEntries();
    final totalDays = _endDate.difference(_startDate).inDays + 1;
    final totalExercisesPerformed = filteredAccountabilityEntries
        .where((e) => e.isCompleted)
        .fold(0, (sum, e) => sum + e.fine.totalExercises);
    final totalExercisesAdded = filteredAccountabilityEntries.fold(0, (sum, e) => sum + e.fine.totalExercises);
    final averageExercisesPerDay = totalDays > 0 ? (totalExercisesPerformed / totalDays).round() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exercise Metrics - ${_selectedProfile}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
               child: _buildMetricCard(
                 'Total Days',
                 totalDays.toString(),
                 Icons.calendar_today,
                 AppColors.primaryPink,
                 'Days tracked',
               ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Exercises Performed',
                totalExercisesPerformed.toString(),
                Icons.fitness_center,
                AppColors.jumpingJacks,
                'Total exercises completed',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Exercises Added',
                totalExercisesAdded.toString(),
                Icons.add_circle,
                AppColors.primaryPink,
                'Total sets added as fines',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Daily Average',
                averageExercisesPerDay.toString(),
                Icons.trending_up,
                AppColors.cleanDayGreen,
                'Exercises per day',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, [String? description]) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
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
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 2),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrendCharts() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trends Over Time - ${_selectedProfile}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your progress with visual insights',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          _buildTrendChart(),
        ],
      ),
    );
  }

  Widget _buildTrendChart() {
    if (_exercisesPerformedData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 8),
            Text(
              'No data available for ${_selectedProfile.toLowerCase()} view',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'Start logging meals to see your progress!',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Chart Legend
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Text(
                'Daily Progress Tracking',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem('Exercises Performed', AppColors.jumpingJacks),
                  _buildLegendItem('Exercises Added', AppColors.primaryPink),
                ],
              ),
            ],
          ),
        ),
        // Chart
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: _exercisesPerformedData.length > 1 ? (_exercisesPerformedData.length - 1).toDouble() : 1,
              minY: 0,
              maxY: _getMaxYValue(),
              baselineY: 0,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _getYInterval(),
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.border,
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < _exercisesPerformedData.length) {
                        return Text(
                          'Day ${value.toInt() + 1}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
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
                    interval: _getYInterval(),
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: AppColors.border, width: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: _exercisesPerformedData,
                  isCurved: true,
                  color: AppColors.jumpingJacks,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.jumpingJacks,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.jumpingJacks.withOpacity(0.1),
                  ),
                ),
                LineChartBarData(
                  spots: _exercisesAddedData,
                  isCurved: true,
                  color: AppColors.primaryPink,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.primaryPink,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primaryPink.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown() {
    final filteredEntries = _getFilteredEntries();
    final categoryData = _getCategoryBreakdown(filteredEntries);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category Breakdown - ${_selectedProfile}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Food type distribution analysis',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          if (categoryData.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.pie_chart, size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: 8),
                  Text(
                    'No data available for ${_selectedProfile.toLowerCase()} view',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          else
            Column(
              children: categoryData.entries.map((entry) {
                final percentage = (entry.value / filteredEntries.length * 100).round();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(entry.key),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '${entry.value} ($percentage%)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildPerformanceComparison() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Insights - ${_selectedProfile}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Personalized insights and achievements',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          _buildInsightCard(
            'Best Day',
            _getBestDay(),
            Icons.trending_up,
            AppColors.cleanDayGreen,
            'Highest exercise day',
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            'Average Daily Exercises',
            _getAverageExercises().toStringAsFixed(1),
            Icons.fitness_center,
            AppColors.jumpingJacks,
            'Daily exercise average',
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            'Total Sets Added',
            _getTotalSetsAdded().toString(),
            Icons.add_circle,
            AppColors.primaryPink,
            'Total sets added as fines',
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String value, IconData icon, Color color, [String? description]) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedInsights() {
    final filteredAccountabilityEntries = _getFilteredAccountabilityEntries();
    
    if (filteredAccountabilityEntries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.analytics, size: 64, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              Text(
                'No Data Available',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start logging meals for ${_selectedProfile.toLowerCase()} to see detailed insights here!',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Insights - ${_selectedProfile}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comprehensive breakdown of your data',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailedMetric('Total Entries', filteredAccountabilityEntries.length.toString(), 'All accountability entries'),
          _buildDetailedMetric('Exercises Performed', 
            filteredAccountabilityEntries.where((e) => e.isCompleted).fold(0, (sum, e) => sum + e.fine.totalExercises).toString(), 'Total exercises completed'),
          _buildDetailedMetric('Exercises Added', 
            filteredAccountabilityEntries.fold(0, (sum, e) => sum + e.fine.totalExercises).toString(), 'Total exercises assigned as fines'),
          _buildDetailedMetric('Average per Day', 
            (_getAverageExercises()).toStringAsFixed(1), 'Daily exercise average'),
          _buildDetailedMetric('Best Day', 
            _getBestDay(), 'Highest exercise performance'),
        ],
      ),
    );
  }

  Widget _buildDetailedMetric(String label, String value, [String? description]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 2),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Helper methods for chart scaling
  double _getMaxYValue() {
    final allValues = <double>[];
    allValues.addAll(_exercisesPerformedData.map((spot) => spot.y));
    allValues.addAll(_exercisesAddedData.map((spot) => spot.y));
    
    if (allValues.isEmpty) return 5.0;
    
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? maxValue * 1.2 : 5.0; // Add 20% padding
  }

  double _getYInterval() {
    final maxY = _getMaxYValue();
    if (maxY <= 5) return 1.0;
    if (maxY <= 10) return 2.0;
    if (maxY <= 20) return 5.0;
    return (maxY / 5).ceil().toDouble();
  }

  // Helper methods
  int _calculateCleanDays(List<FoodEntry> entries) {
    final Map<String, List<FoodEntry>> entriesByDate = {};
    for (final entry in entries) {
      final dateKey = DateFormat('yyyy-MM-dd').format(entry.date);
      entriesByDate.putIfAbsent(dateKey, () => []).add(entry);
    }

    int cleanDays = 0;
    for (final dayEntries in entriesByDate.values) {
      if (dayEntries.isNotEmpty) {
        // A day is clean if it has no junk food entries
        final hasJunkFood = dayEntries.any((e) => e.foodType != AppConstants.clean);
        if (!hasJunkFood) {
          cleanDays++;
        }
      }
    }
    return cleanDays;
  }

  Map<String, int> _getCategoryBreakdown(List<FoodEntry> entries) {
    final Map<String, int> breakdown = {};
    for (final entry in entries) {
      breakdown[entry.foodType] = (breakdown[entry.foodType] ?? 0) + 1;
    }
    return breakdown;
  }

   Color _getCategoryColor(String category) {
     switch (category) {
       case AppConstants.clean:
         return AppColors.cleanDayGreen;
       case AppConstants.majorJunk:
         return AppColors.junkFoodRed;
       default:
         return AppColors.textSecondary;
     }
   }

  String _getBestDay() {
    final filteredAccountabilityEntries = _getFilteredAccountabilityEntries();
    if (filteredAccountabilityEntries.isEmpty) return 'N/A';

    final Map<String, int> exercisesByDate = {};
    for (final entry in filteredAccountabilityEntries.where((e) => e.isCompleted)) {
      final dateKey = DateFormat('MMM dd').format(entry.date);
      exercisesByDate[dateKey] = (exercisesByDate[dateKey] ?? 0) + entry.fine.totalExercises;
    }

    if (exercisesByDate.isEmpty) return 'N/A';

    final bestDay = exercisesByDate.entries.reduce((a, b) => a.value > b.value ? a : b);
    return '${bestDay.key} (${bestDay.value} exercises)';
  }

  double _getAverageExercises() {
    final filteredAccountabilityEntries = _getFilteredAccountabilityEntries();
    if (filteredAccountabilityEntries.isEmpty) return 0.0;

    final totalDays = _endDate.difference(_startDate).inDays + 1;
    final totalExercises = filteredAccountabilityEntries
        .where((e) => e.isCompleted)
        .fold(0, (sum, e) => sum + e.fine.totalExercises);
    return totalExercises / totalDays;
  }

  int _getConsistencyScore() {
    final filteredEntries = _getFilteredEntries();
    if (filteredEntries.isEmpty) return 0;

    final totalDays = _endDate.difference(_startDate).inDays + 1;
    final daysWithEntries = _getDaysWithEntries(filteredEntries);
    return ((daysWithEntries / totalDays) * 100).round();
  }

  int _getDaysWithEntries(List<FoodEntry> entries) {
    final Set<String> uniqueDays = {};
    for (final entry in entries) {
      final dateKey = DateFormat('yyyy-MM-dd').format(entry.date);
      uniqueDays.add(dateKey);
    }
    return uniqueDays.length;
  }

  int _getTotalSetsAdded() {
    final filteredAccountabilityEntries = _getFilteredAccountabilityEntries();
    return filteredAccountabilityEntries.fold(0, (sum, e) => sum + e.fine.totalExercises);
  }
}
