import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/colors.dart';
import '../../app/routes/app_routes.dart';
import '../controllers/accountability_controller.dart';
import '../views/comprehensive_analytics_view.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Safely get the accountability controller, return default values if not found
    Map<String, int> getAccountabilityStats() {
      try {
        final controller = Get.find<AccountabilityController>();
        return {
          'pending': controller.totalPendingFines,
          'completed': controller.totalCompletedFines,
          'my': controller.myPendingFines,
          'partner': controller.partnerPendingFines,
        };
      } catch (e) {
        return {
          'pending': 0,
          'completed': 0,
          'my': 0,
          'partner': 0,
        };
      }
    }
    
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          // Header
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryPink, AppColors.primaryPurple],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Love & Fitness',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Together We Grow Stronger 💕',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // // Quick Stats
          // Container(
          //   margin: const EdgeInsets.all(16),
          //   padding: const EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [AppColors.primaryPink.withOpacity(0.1), AppColors.primaryPurple.withOpacity(0.1)],
          //     ),
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(color: AppColors.primaryPink.withOpacity(0.3)),
          //   ),
          //   child: Obx(() {
          //     final stats = getAccountabilityStats();
          //     return Column(
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //           children: [
          //             _buildQuickStat(
          //               'Pending',
          //               '${stats['pending']}',
          //               AppColors.junkFoodRed,
          //             ),
          //             _buildQuickStat(
          //               'Completed',
          //               '${stats['completed']}',
          //               AppColors.cleanDayGreen,
          //             ),
          //           ],
          //         ),
          //         const SizedBox(height: 12),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //           children: [
          //             _buildQuickStat(
          //               'My Fines',
          //               '${stats['my']}',
          //               AppColors.primaryPink,
          //             ),
          //             _buildQuickStat(
          //               'Partner',
          //               '${stats['partner']}',
          //               AppColors.primaryPurple,
          //             ),
          //           ],
          //         ),
          //       ],
          //     );
          //   }),
          // ),
          //
          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                    Get.offAllNamed(AppRoutes.home);
                  },
                ),
              
                _buildDrawerItem(
                  icon: Icons.analytics,
                  title: 'Analytics & Summary',
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(AppRoutes.analytics);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.trending_up,
                  title: 'Comprehensive Analytics',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const ComprehensiveAnalyticsView());
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.summarize,
                  title: 'Summary',
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(AppRoutes.summary);
                  },
                ),
                const Divider(color: AppColors.border),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(AppRoutes.settings);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.info,
                  title: 'About',
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Made with 💕 for Us',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String title, String value, Color color) {
    return Column(
      children: [
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
            color: color.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primaryPink,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      hoverColor: AppColors.primaryPink.withOpacity(0.1),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(
          'About Love & Fitness',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'A beautiful app designed for couples to track their diet and fitness journey together. Stay accountable, stay motivated, and grow stronger as a team! 💕',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.primaryPink),
            ),
          ),
        ],
      ),
    );
  }
}
