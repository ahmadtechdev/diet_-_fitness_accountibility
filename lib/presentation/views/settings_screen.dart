import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../widgets/exercise_management_section.dart';
import '../widgets/fine_set_management_section.dart';
import '../widgets/fine_distribution_section.dart';
import '../widgets/fine_settings_section.dart';
import '../../core/utils/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final SettingsController controller = Get.put(SettingsController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      final tabs = ['fine_settings', 'fine_sets', 'distribution', 'exercises'];
      controller.setSelectedTab(tabs[_tabController.index]);
    });
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
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textOnPrimary,
          ),
        ),
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.textOnPrimary, size: 24),
              onPressed: () => _showResetDialog(),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.romanticGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              tabs: [
                _buildTab(Icons.settings, 'Fine Settings'),
                _buildTab(Icons.sports_gymnastics, 'Fine Sets'),
                _buildTab(Icons.percent, 'Distribution'),
                _buildTab(Icons.fitness_center, 'Exercises'),
              ],
              labelColor: AppColors.textOnPrimary,
              unselectedLabelColor: AppColors.textOnPrimary.withOpacity(0.7),
              indicatorColor: AppColors.textOnPrimary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPink),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading settings...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.backgroundLight, AppColors.primaryLight],
            ),
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              // Fine Settings (First)
              const FineSettingsSection(),
              // Fine Set Management
              const FineSetManagementSection(),
              // Fine Distribution Rules
              const FineDistributionSection(),
              // Exercise Management (Last)
              const ExerciseManagementSection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTab(IconData icon, String text) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }

  void _showResetDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.surfaceLight,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warningOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.refresh,
                color: AppColors.warningOrange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Reset to Defaults',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to reset all settings to default values? This action cannot be undone.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.resetToDefaults();
              Get.back();
              Get.snackbar(
                'Success',
                'Settings reset to defaults',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.cleanDayGreen,
                colorText: AppColors.textOnPrimary,
                icon: const Icon(Icons.check_circle, color: AppColors.textOnPrimary),
                margin: const EdgeInsets.all(16),
                borderRadius: 16,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warningOrange,
              foregroundColor: AppColors.textOnPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
