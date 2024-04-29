import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/route_path.dart';
import '../../../core/utils/extension/build_extension.dart';
import '../../../core/utils/extension/common_extension.dart';
import '../bloc/auth_bloc.dart';
import '../page/register_page.dart';

mixin RegisterViewModal on State<RegisterPage> {
  final formKey = GlobalKey<FormBuilderState>();

  void onAuthStateListener(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      context.showSnackBar(state.message);
      context.go(AppPage.login.toPath);
    }
  }

  void onSignUpButtonPressed(BuildContext context) {
    if (formKey.currentState!.saveAndValidate()) {
      context.read<AuthBloc>().add(AuthSignUp(userMap: formKey.formValue));
    }
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }
}
