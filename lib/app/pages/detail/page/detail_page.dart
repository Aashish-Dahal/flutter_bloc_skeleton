import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/post/index.dart';
import '../../auth/bloc/auth_bloc.dart';

class DetailPage extends StatelessWidget {
  final Posts post;
  const DetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Page"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(Logout());
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: ListTile(
        leading: Text(post.id.toString()),
        title: Text(post.title),
        subtitle: Text(post.body),
      ),
    );
  }
}
