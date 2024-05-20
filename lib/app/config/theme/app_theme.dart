import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: AppColors.primary,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.bold),
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        isDense: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          fixedSize: const MaterialStatePropertyAll(Size.fromHeight(45)),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
          backgroundColor: const MaterialStatePropertyAll(AppColors.primary),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(textTheme: const TextTheme());
  }
}
