import 'package:firebase_push_notification_module/fcm_service.dart';
import 'package:flutter/material.dart'
    show debugPrint, runApp, WidgetsFlutterBinding;

import 'app.dart' show App;
import 'core/di/service_locator.dart' as di;
import 'core/network/background_sync_service.dart';
import 'core/storage/optimization_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await di.initFirebase();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await FirebaseMessaging.instance.subscribeToTopic("all");
  // await di.sl<FirebaseNotificationService>().initialize();

  // Initialize Background Sync
  await BackgroundSyncService.init();
  if (di.sl<OptimizationService>().autoDownloadOnWifi) {
    await BackgroundSyncService.schedulePeriodicSync();
  }

  runApp(const App());
}
