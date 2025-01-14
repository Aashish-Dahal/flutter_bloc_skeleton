import 'dart:io' show HttpHeaders;

import 'package:dio/dio.dart'
    show
        DioException,
        ErrorInterceptorHandler,
        Interceptor,
        RequestInterceptorHandler,
        RequestOptions,
        Response,
        ResponseInterceptorHandler;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage;
import 'package:fpdart/fpdart.dart';

import '../../core/utils/enum/index.dart' show SecureStorageKey;
import '../../injector.dart' show getIt;
import '../../services/index.dart';
import 'api.dart';

class DioAuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await getIt<FlutterSecureStorage>()
          .read(key: SecureStorageKey.bearerToken.name);
      options.headers
          .addAll({HttpHeaders.authorizationHeader: "Bearer $token"});
      handler.next(options);
    } catch (_) {}
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.path == "/auth/login" ||
        response.requestOptions.path == "/auth/refresh") {
      await Future.wait([
        getIt<FlutterSecureStorage>().write(
          key: SecureStorageKey.bearerToken.name,
          value: response.data?['accessToken'],
        ),
        getIt<FlutterSecureStorage>().write(
          key: SecureStorageKey.refreshToken.name,
          value: response.data?['refreshToken'],
        ),
      ]);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final accessToken = await getIt<FlutterSecureStorage>()
        .read(key: SecureStorageKey.bearerToken.name);

    if (err.response?.statusCode == 401 && accessToken != null) {
      final refreshToken = await getIt<FlutterSecureStorage>()
          .read(key: SecureStorageKey.refreshToken.name);

      final response = await authService.refreshToken({
        "refreshToken": refreshToken,
      });

      err.requestOptions.headers[HttpHeaders.authorizationHeader] =
          response.getRight().getOrElse(() => null)["accessToken"];

      handler.resolve(await dio.fetch(err.requestOptions));
    }
    handler.next(err);
  }
}
