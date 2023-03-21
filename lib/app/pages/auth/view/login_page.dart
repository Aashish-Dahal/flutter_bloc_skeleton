import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Center,
        Column,
        CrossAxisAlignment,
        MainAxisAlignment,
        MainAxisSize,
        OutlinedButton,
        Scaffold,
        StatelessWidget,
        Text,
        Widget;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_skeleton/app/models/user/index.dart';
import 'package:flutter_bloc_skeleton/app/pages/auth/bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Welcome to Login Page"),
            OutlinedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(SignIn(
                      user:
                          User(email: "test@gmail.com", password: "password")));
                },
                child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
