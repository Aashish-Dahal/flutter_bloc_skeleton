import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/extension/common_extension.dart';
import '../../../widgets/organisms/login_input_view.dart';
import '../bloc/auth_bloc.dart';
import '../view_modal/login_view_modal.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginViewModal {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to Login Page"),
            const SizedBox(
              height: 20,
            ),
            LoginInputView(
              formKey: formKey,
            ),
            const SizedBox(
              height: 20,
            ),
            BlocConsumer<AuthBloc, AuthState>(
              listener: onAuthStateListener,
              builder: (_, state) {
                return ElevatedButton(
                  onPressed: () => onSignInButtonPressed(context),
                  child: const Text("Login"),
                ).withLoading(state is AuthLoading);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Don't have an account?",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () => onRegisterButtonPressed(context),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
