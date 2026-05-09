import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/extension/context_extension/dialog_extension.dart';
import '../../../../core/utils/extension/context_extension/theme_extension.dart';
import '../../../../shared/bloc/base_pagination_bloc.dart';
import '../../../../shared/widgets/organisms/bloc_pagination_view.dart';
import '../../../auth/presentation/state_management/auth_bloc.dart';
import '../../../cart/cart.dart';
import '../../domain/entities/product_entity.dart';
import '../routes/product_route_paths.dart';
import '../state_management/get_all_products_bloc/product_pagination_bloc.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => context.go(CartRoute.cart.path),
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeWhen(
                unauthenticated: (message) {
                  context.showSnackBar(message ?? "Logged out");
                },
                failure: (message) => context.showSnackBar(message),
                orElse: () {},
              );
            },
            child: IconButton(
              onPressed: () async {
                context.read<AuthBloc>().add(LogoutRequested());
              },
              icon: const Icon(Icons.logout_outlined),
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            sl<ProductPaginationBloc>()..add(const PaginationFetch()),
        child: BlocPaginationView<ProductEntity, ProductPaginationBloc>(
          padding: .symmetric(horizontal: 16, vertical: 8),
          showDivider: false,
          onPageLoaded: (page, data) {
            debugPrint("Page $page loaded with ${data.length} items");
          },
          itemBuilder: (context, data) {
            return Card(
              child: ListTile(
                onTap: () {
                  context.go(
                    ProductRoute.productDetail.path,
                    extra: data.id.toString(),
                  );
                },
                title: Text(
                  data.title,
                  style: context.bodyLarge?.copyWith(fontWeight: .w700),
                ),
                subtitle: Text(
                  data.description,
                  style: context.bodySmall,
                  maxLines: 3,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
