import 'package:go_router/go_router.dart';
import '../pages/optimization_settings_page.dart';

class OptimizationRoutes {
  static const String optimizationSettings = '/optimization-settings';

  static List<RouteBase> get routes => [
        GoRoute(
          path: optimizationSettings,
          builder: (context, state) => const OptimizationSettingsPage(),
        ),
      ];
}
