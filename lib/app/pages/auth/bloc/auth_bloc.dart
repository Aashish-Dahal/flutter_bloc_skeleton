import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/typedf/index.dart';
import '../../../models/user/index.dart';
import '../../../repository/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;
  AuthBloc(this.authRepo) : super(AuthInitial()) {
    on<AuthStatus>(_getProfile);
    on<AuthSignIn>(_signIn);
    add(AuthStatus());
  }
  _getProfile(AuthStatus event, Emitter<AuthState> emit) async {
    final res = await authRepo.getProfile();
    res.match(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(Authenticated(r.data)),
    );
  }

  _signIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await authRepo.signIn(event.userMap);
    res.match(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(Authenticated(r.data)),
    );
  }
}
