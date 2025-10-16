import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../widgets/exercise_management_section.dart';
import '../widgets/fine_set_management_section.dart';
import '../widgets/fine_distribution_section.dart';
import '../widgets/fine_settings_section.dart';

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
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6C5CE7), // Purple gradient start
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Row(
                      children: [
                        Icon(Icons.refresh, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('Reset to Defaults'),
                      ],
                    ),
                    content: const Text('Are you sure you want to reset all settings to default values? This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
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
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            icon: const Icon(Icons.check_circle, color: Colors.white),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(
              icon: Icon(Icons.settings),
              text: 'Fine Settings',
            ),
            Tab(
              icon: Icon(Icons.sports_gymnastics),
              text: 'Fine Sets',
            ),
            Tab(
              icon: Icon(Icons.percent),
              text: 'Distribution',
            ),
            Tab(
              icon: Icon(Icons.fitness_center),
              text: 'Exercises',
            ),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return TabBarView(
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
        );
      }),
    );
  }
}
