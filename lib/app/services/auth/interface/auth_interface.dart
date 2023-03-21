import '../../../models/user/index.dart';

abstract class AuthInterface {
  Future<User> performLogin();
}
