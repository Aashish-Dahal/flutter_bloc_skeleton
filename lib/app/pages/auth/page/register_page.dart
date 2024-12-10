import 'package:flutter/material.dart';

import '../../../widgets/organisms/register_page_body.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
      ),
      body: RegisterPageBody(),
    );
  }
}
