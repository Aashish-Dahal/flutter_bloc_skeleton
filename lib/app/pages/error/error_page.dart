import 'package:flutter/material.dart'
    show AppBar, BuildContext, Center, Scaffold, StatelessWidget, Text, Widget;

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error Page"),
      ),
      body: const Center(
        child: Text("Not Found"),
      ),
    );
  }
}
