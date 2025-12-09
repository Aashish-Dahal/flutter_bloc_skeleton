import 'package:fpdart/fpdart.dart';

import '../../../../core/config/api/api_error.dart';
import '../../../../core/config/api/api_response.dart';
import '../../../../core/utils/typedf/index.dart';
import '../../domain/entities/refresh_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_api_service.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthApiService _authApiService;

  AuthRepositoryImpl(AuthApiService authApiService)
    : _authApiService = authApiService;
  @override
  Future<Either<Failure, ApiResponse<UserEntity>>> getProfile() async {
    final result = await _authApiService.getProfile();
    return result.map((response) {
      final userModel = response.data;
      final userEntity = userModel.toEntity();
      return ApiResponse<UserEntity>(
        data: userEntity,
        statusCode: response.statusCode,
      );
    });
  }

  @override
  Future<Either<Failure, ApiResponse<UserEntity>>> signIn(
    JsonMap userMap,
  ) async {
    final result = await _authApiService.signIn(userMap);
    return result.map((response) {
      final userModel = response.data;
      final userEntity = userModel.toEntity();
      return ApiResponse<UserEntity>(
        data: userEntity,
        statusCode: response.statusCode,
      );
    });
  }

  @override
  Future<Either<Failure, ApiResponse<RefreshEntity>>> refreshToken(
    JsonMap body,
  ) {
    return _authApiService.refreshToken(body);
  }
}
