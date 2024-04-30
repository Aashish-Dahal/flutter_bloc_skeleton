import 'dart:io';

import 'package:dio/dio.dart';
import '../firebase/index.dart';

class DioAuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      String? token = await firebaseAuth.currentUser?.getIdToken(true);

      if (token != null) {
        options.headers
            .addAll({HttpHeaders.authorizationHeader: "Bearer $token"});
      }
      handler.next(options);
    } catch (_) {
      firebaseAuth.signOut();
    }
  }
}
