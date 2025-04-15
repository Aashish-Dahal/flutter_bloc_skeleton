import 'package:flutter/material.dart' show BuildContext, Locale;

import '../../../config/routes/app_routes.dart';

const supportLocales = [Locale('en'), Locale('ne')];

BuildContext get globalContext => rootNavigatorKey.currentState!.context;
