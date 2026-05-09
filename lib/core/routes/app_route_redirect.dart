import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:go_router/go_router.dart' show GoRouterState;

import '../../features/auth/presentation/routes/auth_route_paths.dart'
    show AuthRoute;
import '../../features/auth/presentation/state_management/auth_bloc.dart'
    show AuthBloc, AuthInitial, AuthLoading, Authenticated;
import '../../features/home/presentation/routes/home_route_paths.dart'
    show HomeRoute;
import '../di/service_locator.dart' show sl;
import '../storage/token_storage.dart';

class AppRouterRedirect {
  static final authPages = {AuthRoute.login.path, AuthRoute.register.path};

  static FutureOr<String?> redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final authState = context.read<AuthBloc>().state;
    final location = state.matchedLocation;

    final isAuthPage = authPages.contains(location);
    final isLoginPage = location == AuthRoute.login.path;

    final token = await sl<TokenStorage>().getAccessToken();
    log(
      'User authenticated, token: $token $isLoginPage $isAuthPage $isLoginPage ${state.uri}',
    );

    /// App booting
    if (authState is AuthInitial || authState is AuthLoading) {
      if (token == null && !isAuthPage && !isLoginPage) {
        return AuthRoute.login.path;
      }

      return null;
    }

    /// Not authenticated
    if (authState is! Authenticated) {
      if (!isAuthPage && !isLoginPage) {
        return AuthRoute.login.path;
      }

      return null;
    }

    /// Already logged in
    if (isLoginPage && token != null) {
      return HomeRoute.home.path;
    }

    return null;
  }
}
