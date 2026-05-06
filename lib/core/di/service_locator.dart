import 'package:dio/dio.dart';
import 'package:firebase_push_notification_module/fcm_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/auth.dart';
import '../../features/cart/cart_di.dart';
import '../../features/home/home_di.dart';
import '../../shared/cubit/locale_cubit.dart';
import '../network/dio_client.dart';
import '../theme/app_theme.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );

  sl.registerLazySingleton<FirebaseNotificationService>(
    () => FirebaseNotificationService(
      FirebaseMessaging.instance,
      FlutterLocalNotificationsPlugin(),
      defaultIcon: "@mipmap/ic_launcher",
      showToken: true,
      getToken: (token) {},
      onLocalNotificationTab: (message) {},
      onFCMNotificationTab: (message) {},
    ),
  );

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()));

  // Core / Shared
  sl.registerLazySingleton(() => AppTheme());
  sl.registerLazySingleton(() => LocaleCubit());

  // Features registration
  initAuth();
  initCart();
  initHome();
}
