import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/extension/bloc_extension.dart';
import '../../injector.dart';
import '../../models/post/index.dart';
import '../../pages/auth/bloc/auth_bloc.dart';
import '../../pages/detail/page/detail_page.dart';
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
    refreshListenable: Listenable.merge([
      authBloc.asListenable(),
      Connectivity().onConnectivityChanged.asListenable(),
    ]),
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
      GoRoute(
        path: AppPage.error.toPath,
        name: AppPage.error.toName,
        builder: (context, state) => const RouteNotFound(),
      ),
      GoRoute(
        path: AppPage.detail.toPath,
        name: AppPage.detail.toName,
        builder: (context, state) => DetailPage(post: state.extra as Posts),
      ),
    ],
    errorBuilder: (context, state) => const RouteNotFound(),
    redirect: (context, state) async {
      final isLoggedIn = firebaseAuth.currentUser != null;
      final loggingIn = state.matchedLocation == AppPage.login.toPath;

      final isOffline = (await Connectivity().checkConnectivity())
          .contains(ConnectivityResult.none);

      if (state.topRoute?.path != AppPage.error.toPath) {
        preferences.setString(
          "previousPath",
          state.topRoute?.path ?? AppPage.home.toPath,
        );
      }
      final previousPath =
          preferences.getString("previousPath") ?? AppPage.home.toPath;
      log("previous path $previousPath");

      if (isLoggedIn && loggingIn) {
        return AppPage.home.toPath;
      }
      if (isOffline) {
        return AppPage.error.toPath;
      }
      if (!isOffline && state.matchedLocation == AppPage.error.toPath) {
        return previousPath;
      }

      return null;
    },
  );
}
