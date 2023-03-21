import 'package:flutter/material.dart';
import 'package:flutter_bloc_skeleton/app/config/extension/extension.dart';
import 'package:flutter_bloc_skeleton/app/config/routes/route_path.dart';
import 'package:flutter_bloc_skeleton/app/pages/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc_skeleton/app/pages/auth/view/login_page.dart';
import 'package:flutter_bloc_skeleton/app/pages/auth/view/register_page.dart';
import 'package:flutter_bloc_skeleton/app/pages/error/error_page.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  late final AuthBloc authBloc;
  GoRouter get router => _goRouter;
  AppRouter(this.authBloc);

  late final GoRouter _goRouter = GoRouter(
      initialLocation: AppPage.login.toPath,
      refreshListenable: authBloc.asListenable(),
      navigatorKey: _rootNavigatorKey,
      routes: <GoRoute>[
        GoRoute(
          path: AppPage.home.toPath,
          name: AppPage.home.toName,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppPage.login.toPath,
          name: AppPage.login.toName,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppPage.register.toPath,
          name: AppPage.register.toName,
          builder: (context, state) => const RegisterPage(),
        ),
      ],
      errorBuilder: (context, state) => const ErrorPage(),
      redirect: (context, _) {
        final state = authBloc.state;
        if (state is Authenticated) {
          return AppPage.home.toPath;
        }
        return null;
      });
}
