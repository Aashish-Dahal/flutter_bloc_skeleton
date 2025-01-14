import 'package:easy_localization/easy_localization.dart' show EasyLocalization;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/api/api.dart';
import 'config/theme/app_theme.dart';
import 'core/common/bloc/pagination_bloc.dart';
import 'core/utils/bloc_observer.dart';
import 'core/utils/enum/index.dart';
import 'core/utils/path_provider/index.dart';
import 'pages/auth/bloc/auth_bloc.dart';
import 'services/index.dart';

late SharedPreferences preferences;
final getIt = GetIt.instance;

Future<void> initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPathProvider.initPath();
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];
  InitDio()();
  _initBlocInstance();
  preferences = await SharedPreferences.getInstance();
  Bloc.observer = SkeletonBlocObserver();
}

_initBlocInstance() {
  getIt.registerSingleton(
    FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );
  getIt.registerLazySingleton(() => AppTheme());
  getIt.registerLazySingleton(() => AuthBloc(authService));
  getIt.registerLazySingleton(
    () => PaginationBloc(postService.getPost, type: PaginationType.cursor)
      ..add(const CursorBasePagination()),
  );
}
