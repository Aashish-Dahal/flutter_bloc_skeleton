import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/bloc/base_pagination_bloc.dart' show PaginationFetch;
import '../pages/product_detail_page.dart';
import '../pages/product_page.dart' show ProductPage;
import '../state_management/get_all_products_bloc/product_pagination_bloc.dart'
    show ProductPaginationBloc;
import '../state_management/get_product_by_id_bloc/get_product_by_id_bloc.dart';
import 'product_route_paths.dart';

/// Declares all GoRouter routes owned by the home feature.
abstract final class ProductRoutes {
  static List<GoRoute> get routes => [
    GoRoute(
      path: ProductRoute.product.path,
      name: ProductRoute.product.routeName,
      builder: (BuildContext context, GoRouterState state) => BlocProvider(
        create: (context) =>
            sl<ProductPaginationBloc>()..add(const PaginationFetch()),
        child: const ProductPage(),
      ),
      routes: [
        GoRoute(
          path: ProductRoute.productDetail.path,
          builder: (BuildContext context, GoRouterState state) => BlocProvider(
            create: (context) =>
                sl<GetProductByIdBloc>()
                  ..add(GetProductByIdRequested(id: state.extra as String)),

            child: ProductDetailPage(id: state.extra as String),
          ),
        ),
      ],
    ),
  ];
}
