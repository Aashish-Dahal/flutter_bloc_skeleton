import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/extension/context_extension/theme_extension.dart';
import '../../../../../core/utils/index.dart';
import '../../../../../shared/bloc/base_pagination_bloc.dart';
import '../../../../../shared/widgets/molecules/app_bloc_button.dart';
import '../../../../../core/utils/extension/context_extension/dialog_extension.dart';
import '../../../domain/entities/product_entity.dart';
import '../../state_management/edit_product_bloc/edit_product_bloc.dart';
import '../../state_management/get_all_products_bloc/product_pagination_bloc.dart';
import '../../state_management/get_product_by_id_bloc/get_product_by_id_bloc.dart';
import '../atoms/add_product_form_field.dart';

class EditProductView extends StatefulWidget {
  final ProductEntity initialData;
  const EditProductView({super.key, required this.initialData});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final formKey = GlobalKey<FormBuilderState>();

  void onEditProductStateListener(
    BuildContext context,
    EditProductState state,
  ) {
    state.maybeWhen(
      success: (product) {
        context.read<GetProductByIdBloc>().add(
          GetProductByIdEvent.productUpdatedLocally(product: product),
        );
        context.read<ProductPaginationBloc>().add(
          PaginationEvent.updateLocally(data: product),
        );
        context.showSnackBar('Product updated successfully: ${product.title}');
        context.pop();
      },
      failure: (message) => context.showSnackBar(message),
      orElse: () {},
    );
  }

  void onEditProductButtonPressed(EditProductBloc bloc) {
    if (formKey.isValid) {
      bloc.add(
        EditProductEvent.updatedProductRequested(
          productData: formKey.formValue,
          id: widget.initialData.id.toString(),
        ),
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
          Text(editProductTitle, style: context.titleLarge),
          const Text(editProductSubtitle),
          AddEditProductFormField(
            formKey: formKey,
            initialData: widget.initialData.toRequest(),
          ),
          AppBlocButton(
            bloc: context.read<EditProductBloc>(),
            label: editProductButtonText,
            onTap: onEditProductButtonPressed,
            listener: onEditProductStateListener,
            variant: ButtonVariant.elevated,
            isLoading: (state) => state is EditProductLoading,
          ),
        ],
      ),
    );
  }
}
