import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String username;
  final String email;
  final String fullname;
  final String gender;
  final String profile;
  final String? accessToken;
  final String? refreshToken;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.fullname,
    required this.gender,
    required this.profile,
    this.accessToken,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    fullname,
    gender,
    profile,
    accessToken,
    refreshToken,
  ];
}
