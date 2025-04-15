import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/route_path.dart';
import '../../core/utils/extension/common_extension.dart';
import '../../core/utils/extension/context_extension/dialog_extension.dart';
import '../../pages/auth/bloc/auth_bloc.dart';
import '../molecules/register_input_field.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<RegisterPageView> {
  final formKey = GlobalKey<FormBuilderState>();

  void onAuthStateListener(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      context.showSnackBar(state.message);
      context.go(AppPage.login.toPath);
    }
  }

  void onSignUpButtonPressed() {
    if (formKey.currentState!.saveAndValidate()) {
      // context.read<AuthBloc>().add(AuthSignUp(userMap: formKey.formValue));
    }
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
          const Text("Welcome to Register Page"),
          RegisterInputField(formKey: formKey),
          BlocConsumer<AuthBloc, AuthState>(
            listener: onAuthStateListener,
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () => onSignUpButtonPressed,
                child: const Text("Register"),
              ).withLoading(state is AuthLoading);
            },
          ),
        ],
      ),
    );
  }
}
