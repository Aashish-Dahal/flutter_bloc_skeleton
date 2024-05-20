import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/extension/common_extension.dart';
import '../../../widgets/organisms/register_input_view.dart';
import '../bloc/auth_bloc.dart';
import '../view_modal/register_view_modal.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with RegisterViewModal {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to Register Page"),
            const SizedBox(
              height: 20,
            ),
            RegisterInputView(
              formKey: formKey,
            ),
            const SizedBox(
              height: 20,
            ),
            BlocConsumer<AuthBloc, AuthState>(
              listener: onAuthStateListener,
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () => onSignUpButtonPressed(context),
                  child: const Text("Register"),
                ).withLoading(state is AuthLoading);
              },
            ),
          ],
        ),
      ),
    );
  }
}
