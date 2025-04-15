import 'package:fpdart/fpdart.dart';

import '../config/api/api_error.dart';
import '../config/api/api_response.dart';
import '../core/utils/typedf/index.dart';
import '../injector.dart';
import '../models/refresh/index.dart';
import '../models/user/index.dart';
import '../services/auth_service.dart';

abstract class AuthRepository {
  Future<Either<Failure, ApiResponse<UserM>>> signIn(JsonMap userMap);
  Future<Either<Failure, ApiResponse<UserM>>> getProfile();
  Future<Either<Failure, ApiResponse<RefreshM>>> refreshToken(JsonMap body);
}

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either<Failure, ApiResponse<UserM>>> getProfile() {
    return sl<AuthApiService>().getProfile();
  }

  @override
  Future<Either<Failure, ApiResponse<UserM>>> signIn(JsonMap userMap) {
    return sl<AuthApiService>().signIn(userMap);
  }

  @override
  Future<Either<Failure, ApiResponse<RefreshM>>> refreshToken(JsonMap body) {
    return sl<AuthApiService>().refreshToken(body);
  }
}
