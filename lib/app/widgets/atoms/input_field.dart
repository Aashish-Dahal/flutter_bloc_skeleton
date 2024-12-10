import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InputField extends FormBuilderTextField {
  final String? hint;
  InputField({super.key, required super.name, this.hint, super.validator})
      : super(
          decoration: InputDecoration(hintText: hint),
        );
}
