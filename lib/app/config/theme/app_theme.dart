import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
        primarySwatch: AppColors.primary,
        textTheme: const TextTheme(
            displayLarge: TextStyle(fontWeight: FontWeight.bold)));
  }

  static ThemeData get dark {
    return ThemeData(textTheme: const TextTheme());
  }
}
