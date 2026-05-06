import 'package:flutter/material.dart';

import '../../../../l10n/s.dart';
import '../widgets/molecules/login_page_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).greeting)),
      body: LoginPageView(),
    );
  }
}
