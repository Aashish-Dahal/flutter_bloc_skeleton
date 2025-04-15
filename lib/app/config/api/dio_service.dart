import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../config.dart';
import '../../core/utils/enum/index.dart';
import '../../core/utils/typedf/index.dart';
import 'api_error.dart';
import 'api_response.dart';
import 'dio_client.dart';

class DioService {
  final DioClient dioClient;
  DioService({required this.dioClient});

  Future<Either<Failure, ApiResponse<T>>> makeRequest<T, R>({
    required RequestType type,
    required String endpoint,
    required T Function(R) fromJson,
    JsonMap? data,
    JsonMap? queryParameters,
    Function(ApiResponse<T>)? onSuccess,
    Function(Failure)? onError,
  }) async {
    try {
      late Response response;
      final url = '${Config.baseUrl}$endpoint';
      switch (type) {
        case RequestType.get:
          response = await dioClient.dio.get(
            url,
            queryParameters: queryParameters,
          );
          break;
        case RequestType.post:
          response = await dioClient.dio.post(
            url,
            data: data,
            queryParameters: queryParameters,
          );
        case RequestType.put:
          response = await dioClient.dio.put(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
        case RequestType.delete:
          response = await dioClient.dio.delete(
            url,
            data: data,
            queryParameters: queryParameters,
          );
      }
      final parsedData = fromJson(response.data['data']);

      final apiResponse = ApiResponse<T>(
        data: parsedData,
        statusCode: response.statusCode ?? 200,
      );
      if (onSuccess != null) {
        return onSuccess(apiResponse);
      }
      return right(apiResponse);
    } on DioException catch (e) {
      final failure = Failure(
        message: e.response?.data['message'] ?? 'Network error occurred',
      );
      if (onError != null) {
        return onError(failure);
      }
      return left(failure);
    } catch (e) {
      final failure = Failure(message: e.toString());
      if (onError != null) {
        return onError(failure);
      }
      return left(failure);
    }
  }
}
