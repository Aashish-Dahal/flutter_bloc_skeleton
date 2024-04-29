import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Column,
        CrossAxisAlignment,
        ElevatedButton,
        MainAxisAlignment,
        Scaffold,
        StatelessWidget,
        Text,
        Widget;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  final User? user;
  const HomePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Welcome password To Flutter Bloc Skeleton Template ${user?.email}",
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(Logout());
              },
              child: const Text("Logout"),),
        ],
      ),
    );
  }
}
