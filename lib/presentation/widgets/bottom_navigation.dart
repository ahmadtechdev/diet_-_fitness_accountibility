import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/colors.dart';
import '../../app/routes/app_routes.dart';
import '../controllers/accountability_controller.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Safely get the accountability controller, return 0 if not found
    int getPendingFinesCount() {
      try {
        final controller = Get.find<AccountabilityController>();
        return controller.totalPendingFines;
      } catch (e) {
        return 0; // Return 0 if controller not found
      }
    }
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home,
                label: 'Home',
                index: 0,
                isActive: currentIndex == 0,
                onTap: () {
                  onTap(0);
                  Get.offAllNamed(AppRoutes.home);
                },
              ),
              _buildNavItem(
                icon: Icons.restaurant,
                label: 'Log Food',
                index: 1,
                isActive: currentIndex == 1,
                onTap: () {
                  onTap(1);
                  Get.toNamed(AppRoutes.dailyLog);
                },
              ),
              Obx(() {
                final pendingCount = getPendingFinesCount();
                return _buildNavItem(
                  icon: Icons.check_circle,
                  label: 'Accountability',
                  index: 2,
                  isActive: currentIndex == 2,
                  onTap: () {
                    onTap(2);
                    Get.toNamed(AppRoutes.accountability);
                  },
                  badge: pendingCount > 0 ? pendingCount : null,
                );
              }),
              _buildNavItem(
                icon: Icons.menu,
                label: 'Menu',
                index: 3,
                isActive: currentIndex == 3,
                onTap: () {
                  onTap(3);
                  Scaffold.of(context).openDrawer();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
    int? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive 
              ? AppColors.primaryPink.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(
                  icon,
                  color: isActive ? AppColors.primaryPink : AppColors.textSecondary,
                  size: 20,
                ),
                if (badge != null && badge > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.junkFoodRed,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        badge > 99 ? '99+' : badge.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primaryPink : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
