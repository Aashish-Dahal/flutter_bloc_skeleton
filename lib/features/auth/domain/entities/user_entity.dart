import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String username;
  final String email;
  final String fullname;
  final String gender;
  final String profile;
  final String? accessToken;
  final String? refreshToken;

  const UserEntity({
    this.username = '',
    this.email = '',
    this.fullname = '',
    this.gender = '',
    this.profile = '',
    this.accessToken,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [
    username,
    email,
    fullname,
    gender,
    profile,
    accessToken,
    refreshToken,
  ];
}
