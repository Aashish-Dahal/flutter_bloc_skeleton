import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/route_path.dart';
import '../../../core/utils/extension/build_extension.dart';
import '../../../core/utils/extension/common_extension.dart';
import '../bloc/auth_bloc.dart';
import '../page/login_page.dart';

mixin LoginViewModal on State<LoginPage> {
  final formKey = GlobalKey<FormBuilderState>();

  void onAuthStateListener(BuildContext context, AuthState state) {
    if (state is AuthFailure) {
      context.showSnackBar(state.message);
    }
  }

  void onSignInButtonPressed(BuildContext context) {
    if (formKey.currentState!.saveAndValidate()) {
      context.read<AuthBloc>().add(AuthSignIn(userMap: formKey.formValue));
    }
  }

  void onRegisterButtonPressed(BuildContext context) {
    context.push(AppPage.register.toPath);
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }
}
