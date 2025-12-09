import 'package:fpdart/fpdart.dart';

import '../../../../core/config/api/index.dart';
import '../../../../core/utils/enum/index.dart';
import '../../../../core/utils/typedf/index.dart' show JsonMap;
import '../../domain/entities/refresh_entity.dart';
import '../models/user_model.dart';

abstract class AuthApiService {
  Future<Either<Failure, ApiResponse<UserM>>> signIn(JsonMap userMap);
  Future<Either<Failure, ApiResponse<UserM>>> getProfile();
  Future<Either<Failure, ApiResponse<RefreshEntity>>> refreshToken(
    JsonMap body,
  );
}

class AuthApiServiceImpl implements AuthApiService {
  final DioService _dioService;

  AuthApiServiceImpl(DioService dioService) : _dioService = dioService;

  @override
  Future<Either<Failure, ApiResponse<UserM>>> signIn(JsonMap userMap) async {
    return _dioService.makeRequest<UserM, JsonMap>(
      type: RequestType.post,
      endpoint: ApiEndpoints.login,
      fromJson: UserM.fromJson,
      data: userMap,
    );
  }

  @override
  Future<Either<Failure, ApiResponse<UserM>>> getProfile() async {
    return _dioService.makeRequest<UserM, JsonMap>(
      type: RequestType.get,
      endpoint: ApiEndpoints.profile,
      fromJson: UserM.fromJson,
    );
  }

  @override
  Future<Either<Failure, ApiResponse<RefreshEntity>>> refreshToken(
    JsonMap body,
  ) async {
    return _dioService.makeRequest<RefreshEntity, JsonMap>(
      type: RequestType.post,
      endpoint: ApiEndpoints.refreshToken,
      fromJson: RefreshEntity.fromJson,
      data: body,
    );
  }
}
