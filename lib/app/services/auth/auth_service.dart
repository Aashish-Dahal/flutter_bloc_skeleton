import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../config/firebase/index.dart';
import '../../core/error/failure.dart';
import '../../core/error/index.dart';
import '../../core/utils/typedf/index.dart';
import 'interface/auth_interface.dart' show AuthInterface;

class AuthService implements AuthInterface {
  @override
  Future<Either<Failure, UserCredential>> signIn(JsonMap userMap) async {
    try {
      final user = await firebaseAuth.signInWithEmailAndPassword(
        email: userMap['email'],
        password: userMap['password'],
      );
      return right(user);
    } on FirebaseAuthException catch (e) {
      return left(Failure(message: getMessageForCode(e.code)));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signUp(JsonMap userMap) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
        email: userMap['email'],
        password: userMap['password'],
      );
      return right(user);
    } on FirebaseAuthException catch (e) {
      return left(Failure(message: getMessageForCode(e.code)));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      await firebaseAuth.signOut();
      return right('Logout successful');
    } on FirebaseAuthException catch (e) {
      return left(Failure(message: getMessageForCode(e.code)));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
