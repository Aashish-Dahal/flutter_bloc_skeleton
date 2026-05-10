import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/extension/context_extension/dialog_extension.dart';
import '../../../auth/presentation/state_management/auth_bloc.dart';

import '../routes/product_route_paths.dart';

import '../widgets/organisms/product_view.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Page"),
        actions: [
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
      body: ProductView(),

      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          context.push(ProductRoute.addProduct.path);
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
