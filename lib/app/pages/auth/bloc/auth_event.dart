part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignIn extends AuthEvent {
  final User user;
  const SignIn({required this.user});
  @override
  List<Object> get props => [user.email];
}

class SignOut extends AuthEvent {
  final String message;
  const SignOut({required this.message});
  @override
  List<Object> get props => [message];
}

class CheckSignInStatus extends AuthEvent {}
