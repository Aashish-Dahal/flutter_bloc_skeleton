import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_push_notification_module/fcm_service.dart';
import 'package:flutter/material.dart'
    show Locale, debugPrint, runApp, WidgetsFlutterBinding;

import 'app.dart' show App;
import 'config.dart';
import 'core/di/service_locator.dart' as di;
import 'core/utils/assets/index.dart';
import 'core/utils/constants/index.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await FirebaseMessaging.instance.subscribeToTopic("all");
  // await di.sl<FirebaseNotificationService>().initialize();

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
