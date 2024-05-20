import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase/index.dart';

class DioAuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      IdTokenResult? result =
          await firebaseAuth.currentUser?.getIdTokenResult(true);
      if (result?.token != null) {
        options.headers.addAll(
          {HttpHeaders.authorizationHeader: "Bearer ${result?.token}"},
        );
      }
      handler.next(options);
    } catch (_) {
      firebaseAuth.signOut();
    }
  }
}
