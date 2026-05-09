import 'package:flutter/material.dart' show BuildContext;
import 'package:go_router/go_router.dart';

import '../pages/home_page.dart' show HomePage;
import 'home_route_paths.dart';

/// Declares all GoRouter routes owned by the home feature.
abstract final class HomeRoutes {
  static List<GoRoute> get routes => [
    GoRoute(
      path: HomeRoute.home.path,
      name: HomeRoute.home.routeName,
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
    ),
  ];
}
