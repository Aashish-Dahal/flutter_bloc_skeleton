import '../../../../core/utils/typedf/index.dart';

class RefreshEntity {
  final String accessToken;
  final String refreshToken;

  RefreshEntity({required this.accessToken, required this.refreshToken});

  factory RefreshEntity.fromJson(JsonMap json) {
    return RefreshEntity(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  JsonMap toJson() {
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  static RefreshEntity get empty =>
      RefreshEntity(accessToken: '', refreshToken: '');
}
