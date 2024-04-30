import 'package:flutter/material.dart';
import '../../core/utils/extension/common_extension.dart';

class AppColors {
  static const MaterialColor primary = MaterialColor(0xFF2196F3, <int, Color>{
    50: Color(0xFFE0F2F8),
    100: Color(0xFFB3E5FC),
    200: Color(0xFF81D4FA),
    300: Color(0xFF4FC3F7),
    400: Color(0xFF29B6F6),
    500: Color(0xFF2196F3),
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  });
  static Color black = "#333333".toColor();
  static Color greyDark = "#999999".toColor();
  static Color greyLight = "#F3F4F8".toColor();
  static Color secondary = "#097693".toColor();
  static Color warning = "#BD5D06".toColor();
  static Color error = "#A40E15".toColor();
}
