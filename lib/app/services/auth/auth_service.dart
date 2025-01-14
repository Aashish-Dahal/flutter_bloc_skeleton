import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../config/api/api.dart';
import '../../core/error/failure.dart';
import '../../core/utils/typedf/index.dart';
import '../../models/user/index.dart';
import 'interface/auth_interface.dart' show AuthInterface;

class AuthService implements AuthInterface {
  @override
  Future<Either<Failure, UserM>> signIn(JsonMap userMap) async {
    try {
      final res = await dio.post("/auth/login", data: userMap);
      return right(UserM.fromJson(res.data));
    } on DioException catch (e) {
      return left(Failure(message: e.response?.data['message']));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserM>> getProfile() async {
    try {
      final res = await dio.get("/auth/me");
      return right(UserM.fromJson(res.data));
    } on DioException catch (e) {
      return left(Failure(message: e.response?.data['message']));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, dynamic>> refreshToken(JsonMap body) async {
    try {
      final res = await dio.post("/auth/refresh", data: body);
      return right(res.data);
    } on DioException catch (e) {
      return left(Failure(message: e.response?.data['message']));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
