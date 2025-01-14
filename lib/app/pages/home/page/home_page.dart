import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/common/bloc/pagination_bloc.dart';
import '../../../injector.dart';
import '../../../models/post/index.dart';
import '../../../widgets/organisms/bloc_pagination_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: BlocProvider<PaginationBloc>(
        create: (context) => getIt<PaginationBloc>(),
        child: BlocPaginationView<Posts>(
          itemBuilder: (data) {
            return ListTile(
              leading: Text(data.id.toString()),
              title: Text(data.title),
              subtitle: Text(data.body),
            );
          },
        ),
      ),
    );
  }
}
