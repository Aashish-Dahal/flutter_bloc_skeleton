import 'package:easy_localization/easy_localization.dart' show EasyLocalization;

Future<void> initDependencies() async {
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];
}
