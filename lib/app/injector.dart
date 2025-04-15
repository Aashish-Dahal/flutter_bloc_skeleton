import 'package:easy_localization/easy_localization.dart' show EasyLocalization;
import 'package:firebase_push_notification_module/fcm_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/api/index.dart' show DioClient, DioService;
import 'config/theme/app_theme.dart';
import 'core/common/bloc/pagination_bloc.dart';
import 'core/utils/index.dart'
    show AppPathProvider, PaginationType, SkeletonBlocObserver;
import 'pages/auth/bloc/auth_bloc.dart';
import 'repository/index.dart'
    show AuthRepository, AuthRepositoryImpl, PostRepository, PostRepositoryImpl;
import 'services/index.dart'
    show AuthApiService, AuthApiServiceImpl, PostApiService, PostApiServiceImpl;

late SharedPreferences preferences;
final sl = GetIt.instance;

Future<void> initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPathProvider.initPath();
  await EasyLocalization.ensureInitialized();

  EasyLocalization.logger.enableBuildModes = [];
  _initServiceLocator();
  preferences = await SharedPreferences.getInstance();
  Bloc.observer = SkeletonBlocObserver();
}

_initServiceLocator() {
  //Dio client
  sl.registerSingleton<DioClient>(DioClient());

  // Dio service
  sl.registerSingleton<DioService>(DioService(dioClient: sl<DioClient>()));

  sl.registerSingleton(
    FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );
  sl.registerLazySingleton(() => AppTheme());

  //services
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  sl.registerSingleton<PostApiService>(PostApiServiceImpl());
  //Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<PostRepository>(PostRepositoryImpl());

  //blocs
  sl.registerLazySingleton(() => AuthBloc(sl<AuthRepository>()));

  sl.registerLazySingleton(
    () => PaginationBloc(
      sl<PostRepository>().getPost,
      type: PaginationType.cursor,
    )..add(const CursorBasePagination()),
  );

  // Firebase messaging
  sl.registerSingleton<FirebaseNotificationService>(
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
