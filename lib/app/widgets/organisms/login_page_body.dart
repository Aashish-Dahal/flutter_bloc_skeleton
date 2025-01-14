import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/route_path.dart';
import '../../core/utils/extension/common_extension.dart';
import '../../core/utils/extension/context_extension/dialog_extension.dart';
import '../../pages/auth/bloc/auth_bloc.dart';
import '../molecules/login_input_field.dart';

class LoginPageBody extends StatefulWidget {
  const LoginPageBody({super.key});

  @override
  State<LoginPageBody> createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<LoginPageBody> {
  final formKey = GlobalKey<FormBuilderState>();

  void onAuthStateListener(BuildContext context, AuthState state) {
    if (state is AuthFailure) {
      context.showSnackBar(state.message);
    }
  }

  void onSignInButtonPressed() {
    if (formKey.currentState!.saveAndValidate()) {
      context.read<AuthBloc>().add(AuthSignIn(userMap: formKey.formValue));
    }
  }

  void onRegisterButtonPressed() {
    context.push(AppPage.register.toPath);
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Welcome to Login Page"),
          LoginInputField(
            formKey: formKey,
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: onAuthStateListener,
            builder: (_, state) {
              return ElevatedButton(
                onPressed: onSignInButtonPressed,
                child: const Text("Login"),
              ).withLoading(state is AuthLoading);
            },
          ),
          const Text(
            "Don't have an account?",
            textAlign: TextAlign.center,
          ),
          OutlinedButton(
            onPressed: onRegisterButtonPressed,
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }
}
