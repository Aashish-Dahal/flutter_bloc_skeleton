import 'package:fpdart/fpdart.dart';

import '../config/api/api_endpoints.dart';
import '../config/api/api_error.dart';
import '../config/api/api_response.dart';
import '../config/api/dio_service.dart';
import '../core/utils/enum/index.dart';
import '../core/utils/typedf/index.dart';
import '../injector.dart';
import '../models/refresh/index.dart';
import '../models/user/index.dart';

abstract class AuthApiService {
  Future<Either<Failure, ApiResponse<UserM>>> signIn(JsonMap userMap);
  Future<Either<Failure, ApiResponse<UserM>>> getProfile();
  Future<Either<Failure, ApiResponse<RefreshM>>> refreshToken(JsonMap body);
}

class AuthApiServiceImpl implements AuthApiService {
  @override
  Future<Either<Failure, ApiResponse<UserM>>> signIn(JsonMap userMap) async {
    return await sl<DioService>().makeRequest<UserM, JsonMap>(
      type: RequestType.post,
      endpoint: ApiEndpoints.login,
      fromJson: UserM.fromJson,
      data: userMap,
    );
  }

  @override
  Future<Either<Failure, ApiResponse<UserM>>> getProfile() async {
    return await sl<DioService>().makeRequest<UserM, JsonMap>(
      type: RequestType.get,
      endpoint: ApiEndpoints.profile,
      fromJson: UserM.fromJson,
    );
  }

  @override
  Future<Either<Failure, ApiResponse<RefreshM>>> refreshToken(
    JsonMap body,
  ) async {
    return await sl<DioService>().makeRequest<RefreshM, JsonMap>(
      type: RequestType.post,
      endpoint: ApiEndpoints.refreshToken,
      fromJson: RefreshM.fromJson,
      data: body,
    );
  }
}
