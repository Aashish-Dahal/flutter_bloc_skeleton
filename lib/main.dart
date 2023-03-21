import 'package:easy_localization/easy_localization.dart' show EasyLocalization;
import 'package:flutter/material.dart'
    show Locale, WidgetsFlutterBinding, runApp;

import 'app/app.dart' show App;
import 'app/init.dart' show initDependencies;
import 'config.dart' show Config;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(EasyLocalization(
    useOnlyLangCode: true,
    startLocale: const Locale(Config.locale),
    supportedLocales: const [
      Locale('en'),
      Locale('ne'),
    ],
    path: "assets/translations",
    child: const App(),
  ));
}
