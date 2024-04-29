part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSignUp extends AuthEvent {
  final JsonMap userMap;
  const AuthSignUp({required this.userMap});
  @override
  List<Object> get props => [userMap];
}

class AuthSignIn extends AuthEvent {
  final JsonMap userMap;
  const AuthSignIn({required this.userMap});
  @override
  List<Object> get props => [userMap];
}

class Logout extends AuthEvent {}
