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

import '../../../features/auth/domain/entities/refresh_entity.dart';
import '../../../features/auth/domain/usecases/auth_usecase.dart';
import '../../../injector.dart';
import '../../utils/enum/index.dart' show SecureStorageKey;
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
      final token = await inject<FlutterSecureStorage>().read(
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
        inject<FlutterSecureStorage>().write(
          key: SecureStorageKey.bearerToken.name,
          value: response.data?['accessToken'],
        ),
        inject<FlutterSecureStorage>().write(
          key: SecureStorageKey.refreshToken.name,
          value: response.data?['refreshToken'],
        ),
      ]);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final accessToken = await inject<FlutterSecureStorage>().read(
      key: SecureStorageKey.bearerToken.name,
    );

    if (err.response?.statusCode == 401 && accessToken != null) {
      final refreshToken = await inject<FlutterSecureStorage>().read(
        key: SecureStorageKey.refreshToken.name,
      );

      final response = await inject<AuthUsecase>().callRefresh({
        "refreshToken": refreshToken,
      });

      err.requestOptions.headers[HttpHeaders.authorizationHeader] =
          response
              .getRight()
              .getOrElse(
                () => ApiResponse(data: RefreshEntity.empty, statusCode: 200),
              )
              .data
              .refreshToken;

      handler.resolve(await inject<DioClient>().dio.fetch(err.requestOptions));
    }
    handler.next(err);
  }
}
