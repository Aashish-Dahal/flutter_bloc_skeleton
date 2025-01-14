import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../../core/utils/typedf/index.dart';
import '../../../models/user/index.dart';

abstract class AuthInterface {
  Future<Either<Failure, UserM>> signIn(JsonMap userMap);
  Future<Either<Failure, UserM>> getProfile();
}
