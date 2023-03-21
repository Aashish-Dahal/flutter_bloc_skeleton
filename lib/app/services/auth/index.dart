import 'package:flutter_bloc_skeleton/app/models/user/index.dart';
import 'package:flutter_bloc_skeleton/app/services/auth/interface/auth_interface.dart'
    show AuthInterface;

class AuthService implements AuthInterface {
  @override
  Future<User> performLogin() {
    return Future(() => User(email: "test@gmail.com", isLoggedIn: true));
  }
}
