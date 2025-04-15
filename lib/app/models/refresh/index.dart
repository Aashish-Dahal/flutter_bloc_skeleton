import '../../core/utils/typedf/index.dart';

class RefreshM {
  final String accessToken;
  final String refreshToken;

  RefreshM({required this.accessToken, required this.refreshToken});

  factory RefreshM.fromJson(JsonMap json) {
    return RefreshM(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  JsonMap toJson() {
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  static RefreshM get empty => RefreshM(accessToken: '', refreshToken: '');
}
