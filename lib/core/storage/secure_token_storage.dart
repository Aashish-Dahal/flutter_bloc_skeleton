import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/exceptions.dart';
import '../utils/enum/index.dart';
import 'token_storage.dart';

final class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage _storage;

  static final _accessTokenKey = SecureStorageKey.bearerToken.name;
  static final _refreshTokenKey = SecureStorageKey.refreshToken.name;

  const SecureTokenStorage(this._storage);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await Future.wait([
        _storage.write(key: _accessTokenKey, value: accessToken),
        _storage.write(key: _refreshTokenKey, value: refreshToken),
      ]);
    } catch (e) {
      throw StorageException('Failed to save tokens: $e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      throw StorageException('Failed to read access token: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      throw StorageException('Failed to read refresh token: $e');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await Future.wait([
        _storage.delete(key: _accessTokenKey),
        _storage.delete(key: _refreshTokenKey),
      ]);
    } catch (e) {
      throw StorageException('Failed to clear tokens: $e');
    }
  }
}
