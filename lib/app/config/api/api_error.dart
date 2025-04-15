class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class Failure {
  final String message;
  Failure({
    this.message = 'An unexpected error occurred. Please try again later.',
  });
}

String getMessageForCode(String code) {
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
