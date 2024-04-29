import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../core/validators/auth_validator.dart';
import '../atoms/input_field.dart';

class LoginInputView extends StatelessWidget with AuthValidator {
  final GlobalKey<FormBuilderState> formKey;
  LoginInputView({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InputField(
            name: "email",
            hint: "Enter email address",
            validator: emailValidator,
          ),
          const SizedBox(
            height: 10,
          ),
          InputField(
            name: "password",
            hint: "Enter password",
            validator: passwordValidator,
          ),
        ],
      ),
    );
  }
}
