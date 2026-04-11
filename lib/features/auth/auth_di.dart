import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/di/service_locator.dart';
import '../../core/network/dio_client.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/auth_remote_datasource_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/refresh_token_usecase.dart';
import 'domain/usecases/session_usecase.dart';
import 'domain/usecases/signup_usecase.dart';
import 'presentation/bloc/auth_bloc.dart';

void initAuth() {
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<DioClient>(), sl<FlutterSecureStorage>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => SessionUseCase(sl()));

  sl.registerLazySingleton(() => RefreshTokenUseCase(sl()));

  // Blocs
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      signupUseCase: sl<SignupUseCase>(),
      sessionUseCase: sl<SessionUseCase>(),
    ),
  );
}
