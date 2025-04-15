import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import '../../../config.dart';
import 'auth_interceptor.dart';
import 'cache_options.dart';

class DioClient {
  late final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          contentType: Headers.jsonContentType,
          baseUrl: Config.baseUrl,
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
        ),
      ) {
    dio.interceptors.addAll([
      DioAuthInterceptor(),
      DioCacheInterceptor(options: cacheOptions),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }
}
