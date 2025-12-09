import 'package:easy_localization/easy_localization.dart' show EasyLocalization;
import 'package:firebase_push_notification_module/fcm_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/api/index.dart' show DioClient, DioService;
import 'core/config/theme/app_theme.dart';
import 'core/utils/bloc_observer.dart';
import 'core/utils/path_provider/index.dart';
import 'features/auth/data/datasources/auth_api_service.dart';
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/data/datasources/product_api_service.dart';
import 'features/home/domain/repository/product_repository.dart';
import 'features/home/domain/usecases/product_usecase.dart';

late SharedPreferences preferences;
final inject = GetIt.instance;

Future<void> initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerSecureStorage();
  _registerFCM();
  await Future.wait([
    _initPathProvider(),
    _initLocalization(),
    _initPreferences(),
  ]);
  _registerAppTheme();
  _registerDioService();
  _registerBloc();
  _registerServices();
  _registerRepository();
  _registerUseCases();
}

void _registerBloc() {
  inject.registerLazySingleton<AuthBloc>(() => AuthBloc(inject<AuthUsecase>()));
}

void _registerAppTheme() {
  inject.registerLazySingleton(() => AppTheme());
}

void _registerDioService() {
  inject.registerSingleton<DioClient>(DioClient());

  inject.registerSingleton<DioService>(
    DioService(dioClient: inject<DioClient>()),
  );
}

void _registerSecureStorage() {
  inject.registerSingleton(
    FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );
}

void _registerFCM() {
  inject.registerSingleton<FirebaseNotificationService>(
    FirebaseNotificationService(
      FirebaseMessaging.instance,
      FlutterLocalNotificationsPlugin(),
      defaultIcon: "@mipmap/ic_launcher",
      showToken: true,
      getToken: (token) {},
      onLocalNotificationTab: (message) {},
      onFCMNotificationTab: (message) {},
    ),
  );
}

void _registerServices() {
  inject
    ..registerLazySingleton<AuthApiService>(
      () => AuthApiServiceImpl(inject<DioService>()),
    )
    ..registerLazySingleton<ProductApiService>(
      () => ProductApiServiceImpl(inject<DioService>()),
    );
}

void _registerRepository() {
  inject.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(inject<AuthApiService>()),
  );
}

void _registerUseCases() {
  inject
    ..registerLazySingleton<AuthUsecase>(
      () => AuthUsecase(inject<AuthRepository>()),
    )
    ..registerLazySingleton<ProductUsecase>(
      () => ProductUsecase(inject<ProductRepository>()),
    );
}

Future<void> _initLocalization() async {
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];
  Bloc.observer = SkeletonBlocObserver();
}

Future<void> _initPathProvider() async {
  await AppPathProvider.initPath();
}

Future<void> _initPreferences() async {
  preferences = await SharedPreferences.getInstance();
}
