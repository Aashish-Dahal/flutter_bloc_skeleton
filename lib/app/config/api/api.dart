import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import '../../../config.dart';
import 'auth_interceptor.dart';
import 'cache_options.dart';

late final Dio dio;

class InitDio {
  call() {
    dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        baseUrl: Config.baseUrl,
        connectTimeout: const Duration(milliseconds: 5000),
        receiveTimeout: const Duration(milliseconds: 5000),
      ),
    )..interceptors.addAll([
        DioAuthInterceptor(),
        DioCacheInterceptor(options: cacheOptions),
        LogInterceptor(requestBody: true, responseBody: true),
      ]);
  }
}
