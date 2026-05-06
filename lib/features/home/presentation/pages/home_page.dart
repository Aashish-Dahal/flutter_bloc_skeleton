import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/route_path.dart';
import '../../../../shared/bloc/base_pagination_bloc.dart';
import '../../../../shared/widgets/organisms/bloc_pagination_view.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/product_pagination_bloc.dart';

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
            onPressed: () => context.go(AppPage.cart.toPath),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            sl<ProductPaginationBloc>()..add(const PaginationFetch()),
        child: BlocPaginationView<ProductEntity, ProductPaginationBloc>(
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
