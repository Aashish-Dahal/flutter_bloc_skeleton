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
import '../../injector.dart' show sl;
import '../../models/refresh/index.dart';
import '../../repository/auth_repo.dart';
import 'api_endpoints.dart';
import 'api_response.dart';
import 'dio_client.dart';

class DioAuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await sl<FlutterSecureStorage>().read(
        key: SecureStorageKey.bearerToken.name,
      );
      options.headers.addAll({
        HttpHeaders.authorizationHeader: "Bearer $token",
      });
      handler.next(options);
    } catch (_) {}
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.path == ApiEndpoints.login ||
        response.requestOptions.path == ApiEndpoints.refreshToken) {
      await Future.wait([
        sl<FlutterSecureStorage>().write(
          key: SecureStorageKey.bearerToken.name,
          value: response.data?['accessToken'],
        ),
        sl<FlutterSecureStorage>().write(
          key: SecureStorageKey.refreshToken.name,
          value: response.data?['refreshToken'],
        ),
      ]);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final accessToken = await sl<FlutterSecureStorage>().read(
      key: SecureStorageKey.bearerToken.name,
    );

    if (err.response?.statusCode == 401 && accessToken != null) {
      final refreshToken = await sl<FlutterSecureStorage>().read(
        key: SecureStorageKey.refreshToken.name,
      );

      final response = await sl<AuthRepository>().refreshToken({
        "refreshToken": refreshToken,
      });

      err.requestOptions.headers[HttpHeaders.authorizationHeader] =
          response
              .getRight()
              .getOrElse(
                () => ApiResponse(data: RefreshM.empty, statusCode: 200),
              )
              .data
              .refreshToken;

      handler.resolve(await sl<DioClient>().dio.fetch(err.requestOptions));
    }
    handler.next(err);
  }
}
