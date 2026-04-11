import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../../core/validators/form_validator.dart';
import '../../../../../shared/widgets/atoms/input_field.dart';

class LoginInputField extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  const LoginInputField({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      initialValue: {"username": "emilys", "password": "emilyspass"},
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InputField(
            name: "username",
            hint: "Enter a username",
            validator: FormValidator.fullName,
          ),
          InputField(
            name: "password",
            hint: "Enter password",
            isPassword: true,
            validator: FormValidator.password,
          ),
        ],
      ),
    );
  }
}
