class User {
  final String email;
  final bool isLoggedIn;
  final String? password;
  User({required this.email, this.password, this.isLoggedIn = false});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(email: json["email"], password: json['password']);

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}
