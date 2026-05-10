import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extension/context_extension/theme_extension.dart';
import '../../../../shared/widgets/molecules/bloc_state_builder.dart';
import '../routes/product_route_paths.dart';
import '../state_management/get_product_by_id_bloc/get_product_by_id_bloc.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;
  const ProductDetailPage({super.key, required this.id});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    final bloc = context.read<GetProductByIdBloc>();
    bloc.add(GetProductByIdRequested(id: widget.id));
    super.initState();
  }

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
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Flexible(
                      child: Text(product.title, style: context.titleLarge),
                    ),
                    IconButton(
                      onPressed: () {
                        context.push(
                          ProductRoute.editProduct.path,
                          extra: product,
                        );
                      },
                      icon: Icon(Icons.edit_outlined, color: AppColors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(product.description),
              ],
            ),
          );
        },
        onRetry: (bloc) => bloc.add(
          GetProductByIdEvent.getProductByIdRequested(id: widget.id),
        ),
      ),
    );
  }
}
