import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure.dart';
import '../../../core/utils/typedf/index.dart';

abstract class AuthInterface {
  Future<Either<Failure, AuthResponse>> signUp(JsonMap userMap);
  Future<Either<Failure, AuthResponse>> signIn(JsonMap userMap);
  Future<Either<Failure, String>> logout();
}
