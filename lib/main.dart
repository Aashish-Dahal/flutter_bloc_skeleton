import 'package:easy_localization/easy_localization.dart' show EasyLocalization;
import 'package:firebase_push_notification_module/fcm_service.dart';
import 'package:flutter/material.dart' show Locale, debugPrint, runApp;

import 'app/app.dart' show App;
import 'app/core/utils/assets/index.dart';
import 'app/core/utils/constants/index.dart';
import 'app/injector.dart' show initDependencies;
import 'config.dart' show Config;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.messageId}');
}

void main() async {
  await initDependencies();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.subscribeToTopic("all");
  await sl<FirebaseNotificationService>().initialize();

  runApp(
    EasyLocalization(
      useOnlyLangCode: true,
      startLocale: const Locale(Config.locale),
      supportedLocales: supportLocales,
      path: Assets.translations,
      child: const App(),
    ),
  );
}
