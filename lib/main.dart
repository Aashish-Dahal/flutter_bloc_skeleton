import 'package:firebase_push_notification_module/fcm_service.dart';
import 'package:flutter/material.dart'
    show debugPrint, runApp, WidgetsFlutterBinding;

import 'app.dart' show App;
import 'core/di/service_locator.dart' as di;
import 'core/security/screen_record_block.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await di.initFirebase();
  // await SecurityService.enable();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await FirebaseMessaging.instance.subscribeToTopic("all");
  // await di.sl<FirebaseNotificationService>().initialize();

  runApp(const App());
}
