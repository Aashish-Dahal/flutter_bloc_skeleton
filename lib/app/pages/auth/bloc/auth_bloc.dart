import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/strings/index.dart';
import '../../../core/utils/typedf/index.dart';
import '../../../services/auth/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_signUp);
    on<AuthSignIn>(_signIn);
    on<Logout>(_logout);
  }
  _signUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await authService.signUp(event.userMap);
    res.fold((l) => emit(AuthFailure(l.message!)),
        (r) => emit(const AuthSuccess(signUpSuccess)),);
  }

  _signIn(AuthSignIn event, Emitter<AuthState> emit) async {
    final res = await authService.signIn(event.userMap);
    res.fold((l) => emit(AuthFailure(l.message!)),
        (r) => emit(Authenticated(r.user!)),);
  }

  _logout(Logout event, Emitter<AuthState> emit) async {
    final res = await authService.logout();
    res.fold((l) => emit(AuthFailure(l.message!)),
        (r) => emit(Unauthenticated(message: r)),);
  }
}
