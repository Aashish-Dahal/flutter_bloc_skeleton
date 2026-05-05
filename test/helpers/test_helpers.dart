import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_bloc_skeleton/features/auth/presentation/bloc/auth_bloc.dart';

// ─── Mock classes ─────────────────────────────────────────────────────────────

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

// ─── Shared pump helper ───────────────────────────────────────────────────────

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget, {required MockAuthBloc authBloc}) async {
    await pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: Scaffold(body: widget),
        ),
      ),
    );
  }
}
