import 'package:flutter/material.dart';

import '../../../../injector.dart';
import '../../../../shared/widgets/organisms/bloc_pagination_view.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/product_usecase.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      body: BlocPaginationView<ProductEntity>(
        call: inject<ProductUsecase>(),
        itemBuilder: (data) {
          return ListTile(
            leading: Text(data.id.toString()),
            title: Text(data.title),
            subtitle: Text(data.description),
          );
        },
      ),
    );
  }
}
