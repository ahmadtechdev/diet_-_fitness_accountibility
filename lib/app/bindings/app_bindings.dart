import 'package:get/get.dart';
import '../../presentation/controllers/food_tracker_controller.dart';
import '../../presentation/controllers/accountability_controller.dart';
import '../../presentation/controllers/settings_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize controllers
    Get.lazyPut<FoodTrackerController>(() => FoodTrackerController(),fenix: true);
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true); // Lazy load settings controller
    Get.lazyPut<FoodTrackerController>(() => FoodTrackerController(), fenix: true); // Lazy load settings controller
    Get.lazyPut<AccountabilityController>(() => AccountabilityController(), fenix: true); // Lazy load settings controller

  }
}
