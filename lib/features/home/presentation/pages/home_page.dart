import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/extension/context_extension/dialog_extension.dart';
import '../../../../shared/bloc/base_pagination_bloc.dart';
import '../../../../shared/widgets/organisms/bloc_pagination_view.dart';
import '../../../auth/presentation/state_management/auth_bloc.dart';
import '../../../cart/cart.dart';
import '../../domain/entities/product_entity.dart';
import '../state_management/product_pagination_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
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
          onPageLoaded: (page, data) {
            debugPrint("Page $page loaded with ${data.length} items");
          },
          itemBuilder: (context, data) {
            return ListTile(
              leading: Text(data.id.toString()),
              title: Text(data.title),
              subtitle: Text(data.description),
            );
          },
        ),
      ),
    );
  }
}
