import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_skeleton/app/services/auth/index.dart';

import '../../../models/user/index.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<SignIn>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await _authService.performLogin();
        if (response.isLoggedIn) {
          emit(Authenticated());
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthFailed());
      }
    });
    on<SignOut>((event, emit) async {
      if (state is Authenticated) {
        //logout
      }
    });
    on<CheckSignInStatus>((event, emit) async {
      //check login status
    });
  }
}
