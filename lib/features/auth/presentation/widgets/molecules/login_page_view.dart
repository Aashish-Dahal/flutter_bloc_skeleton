import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/index.dart';
import '../../routes/auth_route_paths.dart';
import '../../state_management/auth_bloc.dart';
import '../../../../../core/utils/extension/context_extension/dialog_extension.dart';
import '../atoms/login_input_field.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  final formKey = GlobalKey<FormBuilderState>();

  void onAuthStateListener(BuildContext context, AuthState state) {
    state.maybeWhen(
      authenticated: (user) =>
          context.showSnackBar('Welcome back, ${user.username}'),
      failure: (message) => context.showSnackBar(message),
      orElse: () {},
    );
  }

  void onSignInButtonPressed() {
    if (formKey.isValid) {
      context.read<AuthBloc>().add(
        AuthEvent.loginRequested(userMap: formKey.formValue),
      );
    }
  }

  void onRegisterButtonPressed() {
    context.push(AuthRoute.register.path);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 20),
      child: Column(
        spacing: 20,
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .center,
        children: [
          const Text(loginTitle),
          const Text(loginSubtitle, textAlign: .center),
          LoginInputField(formKey: formKey),
          BlocConsumer<AuthBloc, AuthState>(
            listener: onAuthStateListener,
            builder: (_, state) {
              return ElevatedButton(
                onPressed: onSignInButtonPressed,
                child: const Text(loginButtonText),
              ).withLoading(state is AuthLoading);
            },
          ),
          const Text(noAccountText, textAlign: .center),
          OutlinedButton(
            onPressed: onRegisterButtonPressed,
            child: const Text(registerButtonText),
          ),
        ],
      ),
    );
  }
}
