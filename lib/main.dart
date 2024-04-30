import 'package:easy_localization/easy_localization.dart' show EasyLocalization;
import 'package:flutter/material.dart' show Locale, runApp;

import 'app/app.dart' show App;
import 'app/core/utils/assets/index.dart';
import 'app/core/utils/constants/index.dart';
import 'app/injector.dart' show initDependencies;
import 'config.dart' show Config;

void main() async {
  await initDependencies();

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
