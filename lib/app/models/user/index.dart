import '../../core/utils/typedf/index.dart';

class User {
  final String email;
  final bool isLoggedIn;
  final String? password;
  User({required this.email, this.password, this.isLoggedIn = false});

  factory User.fromJson(JsonMap json) =>
      User(email: json["email"], password: json['password']);

  JsonMap toJson() => {"email": email, "password": password};
}
