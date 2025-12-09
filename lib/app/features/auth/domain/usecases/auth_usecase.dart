import 'package:fpdart/fpdart.dart';

import '../../../../core/config/api/api_error.dart';
import '../../../../core/config/api/api_response.dart';
import '../../../../core/utils/typedf/index.dart';
import '../entities/refresh_entity.dart';
import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class AuthUsecase {
  final AuthRepository authRepository;

  AuthUsecase(this.authRepository);
  Future<Either<Failure, ApiResponse<UserEntity>>> callProfile() {
    return authRepository.getProfile();
  }

  Future<Either<Failure, ApiResponse<UserEntity>>> callSignIn(JsonMap userMap) {
    return authRepository.signIn(userMap);
  }

  Future<Either<Failure, ApiResponse<RefreshEntity>>> callRefresh(
    JsonMap userMap,
  ) {
    return authRepository.refreshToken(userMap);
  }
}
