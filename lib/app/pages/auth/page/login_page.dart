import 'package:flutter/material.dart';

import '../../../widgets/organisms/login_page_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page"), actions: []),
      body: LoginPageView(),
    );
  }
}
