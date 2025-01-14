import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../core/validators/auth_validator.dart';
import '../atoms/input_field.dart';

class LoginInputField extends StatelessWidget with AuthValidator {
  final GlobalKey<FormBuilderState> formKey;
  LoginInputField({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InputField(
            name: "username",
            hint: "Enter Username",

            // validator: emailValidator,
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
