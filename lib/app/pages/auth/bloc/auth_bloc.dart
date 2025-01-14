import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/typedf/index.dart';
import '../../../models/user/index.dart';
import '../../../services/auth/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AuthStatus>(_getProfile);
    on<AuthSignIn>(_signIn);
    add(AuthStatus());
  }
  _getProfile(AuthStatus event, Emitter<AuthState> emit) async {
    final res = await authService.getProfile();
    res.match(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(Authenticated(r)),
    );
  }

  _signIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await authService.signIn(event.userMap);
    res.match(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(Authenticated(r)),
    );
  }
}
