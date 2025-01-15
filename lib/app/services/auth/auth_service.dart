import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/supabase/index.dart';
import '../../core/error/failure.dart';
import '../../core/utils/typedf/index.dart';
import 'interface/auth_interface.dart' show AuthInterface;

class AuthService implements AuthInterface {
  @override
  Future<Either<Failure, AuthResponse>> signIn(JsonMap userMap) async {
    try {
      final user = await supabaseClient.auth.signInWithPassword(
        email: userMap['email'],
        password: userMap['password'],
      );
      return right(user);
    } on AuthException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> signUp(JsonMap userMap) async {
    try {
      final user = await supabaseClient.auth.signUp(
        email: userMap['email'],
        password: userMap['password'],
      );
      return right(user);
    } on AuthException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      await supabaseClient.auth.signOut();
      return right('Logout successful');
    } on AuthException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
