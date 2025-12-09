import 'package:fpdart/fpdart.dart';

import '../../../../core/config/api/api_error.dart';
import '../../../../core/config/api/api_response.dart';
import '../../../../core/utils/typedf/index.dart';
import '../entities/refresh_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, ApiResponse<UserEntity>>> signIn(JsonMap userMap);
  Future<Either<Failure, ApiResponse<UserEntity>>> getProfile();
  Future<Either<Failure, ApiResponse<RefreshEntity>>> refreshToken(
    JsonMap body,
  );
}
