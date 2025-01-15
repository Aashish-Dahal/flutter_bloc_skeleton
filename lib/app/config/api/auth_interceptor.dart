import 'dart:io';

import 'package:dio/dio.dart';

import '../supabase/index.dart';

class DioAuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      String? token = supabaseClient.auth.currentSession?.accessToken;
      options.headers
          .addAll({HttpHeaders.authorizationHeader: "Bearer $token"});
      handler.next(options);
    } catch (_) {
      supabaseClient.auth.signOut();
    }
  }
}
