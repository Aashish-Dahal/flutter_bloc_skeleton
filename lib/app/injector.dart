import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' show EasyLocalization;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/api/api.dart';
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
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];
  InitDio()();
  preferences = await SharedPreferences.getInstance();
  Bloc.observer = SkeletonBlocObserver();
  _initBlocInstance();
  FlutterError.onError = (error) {
    log(error.exceptionAsString(), stackTrace: error.stack);
  };
}

_initBlocInstance() {
  getIt.registerLazySingleton(() => AuthBloc(authService));
  getIt.registerLazySingleton(
    () => PaginationBloc(postService.getPost, type: PaginationType.cursor)
      ..add(const CursorBasePagination()),
  );
}
