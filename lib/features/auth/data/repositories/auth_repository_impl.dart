import '../../../../core/network/api_result.dart';
import '../../../../core/network/failures.dart';
import '../../domain/entities/token_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<UserEntity>> login(String username, String password) async {
    try {
      final userModel = await _remoteDataSource.login(username, password);
      return ApiResult.success(userModel.toEntity());
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<TokenEntity>> refreshToken(String token) async {
    try {
      final tokenEntity = await _remoteDataSource.refreshToken(token);
      return ApiResult.success(tokenEntity);
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<UserEntity>> signUp(
    String fullName,
    String email,
    String password,
  ) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<TokenEntity>> getCurrentSession() async {
    try {
      final tokenEntity = await _remoteDataSource.getCurrentSession();
      return ApiResult.success(tokenEntity);
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }
}
