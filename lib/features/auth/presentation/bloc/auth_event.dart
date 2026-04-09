part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginRequested({
    required String username,
    required String password,
  }) = LoginRequested;
  
  const factory AuthEvent.logoutRequested() = LogoutRequested;
  
  const factory AuthEvent.appStarted() = AppStarted;
}
