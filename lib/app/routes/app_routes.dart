import 'package:get/get.dart';
import '../../presentation/views/daily_log_view.dart';
import '../../presentation/views/analytics_view.dart';
import '../../presentation/views/summary_view.dart';
import '../../presentation/views/home_view.dart';
import '../../presentation/views/splash_view.dart';
import '../../presentation/views/accountability_view.dart';
import '../../presentation/views/settings_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String dailyLog = '/daily-log';
  static const String accountability = '/accountability';
  static const String analytics = '/analytics';
  static const String summary = '/summary';
  static const String settings = '/settings';
  
  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => const SplashView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: home,
      page: () => const HomeView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: dailyLog,
      page: () => const DailyLogView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: accountability,
      page: () => const AccountabilityView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: analytics,
      page: () => const AnalyticsView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: summary,
      page: () => const SummaryView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: settings,
      page: () => const SettingsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
