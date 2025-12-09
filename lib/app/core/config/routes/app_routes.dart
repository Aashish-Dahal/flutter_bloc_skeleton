import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/auth/presentation/pages/register_page.dart';
import '../../../features/home/presentation/pages/home_page.dart';
import '../../../shared/widgets/organisms/page_not_found.dart';
import '../../utils/extension/bloc_extension.dart';
import 'route_path.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  late final AuthBloc authBloc;
  GoRouter get router => _goRouter;
  AppRouter(this.authBloc);

  late final _goRouter = GoRouter(
    initialLocation:
        authBloc.state is Authenticated
            ? AppPage.home.toPath
            : AppPage.login.toPath,
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
        builder: (context, state) => HomePage(),
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
    errorBuilder: (context, state) => const PageNotFoundView(),
    redirect: (context, _) {
      final isLoggedIn = authBloc.state is Authenticated;
      if (isLoggedIn) {
        return AppPage.home.toPath;
      }
      return null;
    },
  );
}
