import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server failure occurred']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache failure occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failed']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

String getFirebaseErrorMessage(String code) {
  switch (code) {
    case 'invalid-email':
      return 'The email address is invalid.';
    case 'user-disabled':
      return 'The user account has been disabled.';
    case 'user-not-found':
      return 'There is no user corresponding to the given email address.';
    case 'wrong-password':
      return 'The password is invalid for the given email address.';
    case 'invalid-credential':
      return 'The email and password is invalid.';
    default:
      return 'An unknown error occurred.';
  }
}
