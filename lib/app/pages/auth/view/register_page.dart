import 'package:flutter/material.dart'
    show AppBar, BuildContext, Center, Scaffold, StatelessWidget, Text, Widget;

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
      ),
      body: const Center(
        child: Text("Register Page"),
      ),
    );
  }
}
