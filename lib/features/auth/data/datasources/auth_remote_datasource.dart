import '../../../../core/network/dio_client.dart';
import '../../domain/entities/token_entity.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
  Future<TokenEntity> refreshToken(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<UserModel> login(String username, String password) async {
    final response = await _dioClient.post(
      '/auth/login',
      data: {
        'username': username,
        'password': password,
      },
    );

    return UserModel.fromJson(response.data);
  }

  @override
  Future<TokenEntity> refreshToken(String token) async {
    final response = await _dioClient.post(
      '/auth/refresh',
      data: {
        'refreshToken': token,
      },
    );

    return TokenEntity(
      accessToken: response.data['accessToken'],
      refreshToken: response.data['refreshToken'],
    );
  }
}
