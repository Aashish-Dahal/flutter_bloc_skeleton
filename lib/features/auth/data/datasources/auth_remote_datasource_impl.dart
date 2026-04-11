import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/enum/index.dart';
import '../../domain/entities/token_entity.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;
  final FlutterSecureStorage _storage;

  AuthRemoteDataSourceImpl(this._dioClient, this._storage);

  @override
  Future<UserModel> login(String username, String password) async {
    final response = await _dioClient.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );

    return UserModel.fromJson(response.data);
  }

  @override
  Future<TokenEntity> refreshToken(String token) async {
    final response = await _dioClient.post(
      '/auth/refresh',
      data: {'refreshToken': token},
    );

    return TokenEntity(
      accessToken: response.data['accessToken'],
      refreshToken: response.data['refreshToken'],
    );
  }

  @override
  Future<TokenEntity> getCurrentSession() async {
    final accessToken = await _storage.read(
      key: SecureStorageKey.bearerToken.name,
    );
    final refreshToken = await _storage.read(
      key: SecureStorageKey.refreshToken.name,
    );
    return TokenEntity(
      accessToken: accessToken ?? '',
      refreshToken: refreshToken ?? '',
    );
  }
}
