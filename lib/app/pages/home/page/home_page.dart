import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/common/bloc/pagination_bloc.dart';
import '../../../injector.dart';
import '../../../models/post/index.dart';
import '../../../widgets/organisms/bloc_pagination_view.dart';
import '../../auth/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  final User? user;
  const HomePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(Logout());
            },
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
              subtitle: Text(data.reaction.toString()),
            );
          },
        ),
      ),
    );
  }
}
