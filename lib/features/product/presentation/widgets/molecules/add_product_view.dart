import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/extension/context_extension/theme_extension.dart';
import '../../../../../core/utils/index.dart';
import '../../../../../shared/widgets/molecules/app_bloc_button.dart';
import '../../state_management/add_product_bloc/add_product_bloc.dart';
import '../../../../../core/utils/extension/context_extension/dialog_extension.dart';
import '../atoms/add_product_form_field.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final formKey = GlobalKey<FormBuilderState>();

  void onAddProductStateListener(BuildContext context, AddProductState state) {
    state.maybeWhen(
      success: (product) {
        context.showSnackBar('Product added successfully: ${product.title}');
        context.pop();
      },
      failure: (message) => context.showSnackBar(message),
      orElse: () {},
    );
  }

  void onAddProductButtonPressed(AddProductBloc bloc) {
    if (formKey.isValid) {
      bloc.add(
        AddProductEvent.addProductRequested(productData: formKey.formValue),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 20, vertical: 20),
      child: Column(
        spacing: 20,
        crossAxisAlignment: .stretch,
        children: [
          Text(addProductTitle, style: context.titleLarge),
          const Text(addProductSubtitle),
          AddEditProductFormField(formKey: formKey),
          AppBlocButton(
            bloc: context.read<AddProductBloc>(),
            label: addProductButtonText,
            onTap: onAddProductButtonPressed,
            listener: onAddProductStateListener,
            variant: ButtonVariant.elevated,
            isLoading: (state) => state is AddProductLoading,
          ),
        ],
      ),
    );
  }
}
