import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth.dart';
import '../../features/cart/cart.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../../shared/widgets/organisms/page_not_found.dart';
import '../utils/extension/bloc_extension.dart';
import 'route_path.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final AuthBloc authBloc;
  AppRouter(this.authBloc);

  late final _goRouter = GoRouter(
    initialLocation: AppPage.login.toPath,
    refreshListenable: authBloc.asListenable(),
    navigatorKey: rootNavigatorKey,

    // ONE REDIRECT TO RULE THEM ALL
    redirect: (context, state) {
      final authState = authBloc.state;
      final bool isAuthenticated = authState is Authenticated;

      // Check if the user is currently on an "Auth" page (Login or Register)
      final bool isAuthPage =
          state.matchedLocation == AppPage.login.toPath ||
          state.matchedLocation == AppPage.register.toPath;

      // 1. If not authenticated and not on an auth page, force to Login
      if (!isAuthenticated && !isAuthPage) {
        return AppPage.login.toPath;
      }

      // 2. If authenticated and trying to access Login/Register, force to Home
      if (isAuthenticated && isAuthPage) {
        return AppPage.home.toPath;
      }

      // 3. Otherwise, let them go where they want
      return null;
    },

    routes: [
      GoRoute(
        path: AppPage.home.toPath,
        name: AppPage.home.toName,
        builder: (context, state) => const HomePage(),
      ),
      ...CartRoutes.routes,
      ...AuthRoutes.routes,
    ],
    errorBuilder: (context, state) => const PageNotFoundView(),
  );

  GoRouter get router => _goRouter;
}
