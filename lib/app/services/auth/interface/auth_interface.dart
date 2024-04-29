import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../../core/utils/typedf/index.dart';

abstract class AuthInterface {
  Future<Either<Failure, UserCredential>> signUp(JsonMap userMap);
  Future<Either<Failure, UserCredential>> signIn(JsonMap userMap);
  Future<Either<Failure, String>> logout();
}
