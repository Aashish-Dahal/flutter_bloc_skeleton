import 'package:flutter/material.dart';

import '../../../../core/utils/extension/context_extension/theme_extension.dart';
import '../../../../shared/widgets/molecules/bloc_state_builder.dart';
import '../state_management/get_product_by_id_bloc/get_product_by_id_bloc.dart';

class ProductDetailPage extends StatelessWidget {
  final String id;
  const ProductDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Detail Page")),
      body: BlocStateBuilder<GetProductByIdBloc, GetProductByIdState>(
        onLoaded: (context, state) {
          final product = (state as ProductLoaded).res;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: context.titleLarge),
                const SizedBox(height: 8),
                Text(product.description),
              ],
            ),
          );
        },
        onRetry: (bloc) =>
            bloc.add(GetProductByIdEvent.getProductByIdRequested(id: id)),
      ),
    );
  }
}
