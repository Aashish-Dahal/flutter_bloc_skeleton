import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/extension/bloc_extension.dart';
import '../../pages/auth/bloc/auth_bloc.dart';
import '../../pages/index.dart';
import '../firebase/index.dart';
import 'route_path.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  late final AuthBloc authBloc;
  GoRouter get router => _goRouter;
  AppRouter(this.authBloc);

  late final _goRouter = GoRouter(
    initialLocation: AppPage.login.toPath,
    refreshListenable: authBloc.asListenable(),
    navigatorKey: rootNavigatorKey,
    routes: <GoRoute>[
      GoRoute(
        path: AppPage.home.toPath,
        name: AppPage.home.toName,
        redirect: (context, state) {
          final state = authBloc.state;
          if (state is Unauthenticated) {
            return AppPage.login.toPath;
          }
          return null;
        },
        builder: (context, state) => HomePage(
          user: firebaseAuth.currentUser,
        ),
      ),
      GoRoute(
        path: AppPage.login.toPath,
        name: AppPage.login.toName,
        redirect: (context, state) {
          final state = authBloc.state;
          if (state is Authenticated) {
            return AppPage.home.toPath;
          }
          return null;
        },
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppPage.register.toPath,
        name: AppPage.register.toName,
        builder: (context, state) => const RegisterPage(),
      ),
    ],
    errorBuilder: (context, state) => const RouteNotFound(),
    redirect: (context, _) {
      final isLoggedIn = firebaseAuth.currentUser != null;
      if (isLoggedIn) {
        return AppPage.home.toPath;
      }
      return null;
    },
  );
}
