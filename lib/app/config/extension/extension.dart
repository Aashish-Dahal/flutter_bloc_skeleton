import 'package:flutter/foundation.dart'
    show ChangeNotifier, Listenable, ValueListenable, ValueNotifier;
import 'package:flutter/material.dart'
    show
        BuildContext,
        ChangeNotifier,
        Color,
        FontWeight,
        Listenable,
        MediaQuery,
        ScaffoldFeatureController,
        ScaffoldMessenger,
        Size,
        SnackBar,
        SnackBarBehavior,
        SnackBarClosedReason,
        Text,
        TextStyle,
        Theme,
        ValueNotifier,
        Widget,
        Wrap,
        showModalBottomSheet;
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBase, BlocBuilderCondition;

extension BuildContextEntension<T> on BuildContext {
  /*------------------ responsive size --------------*/
  bool get isMobile => MediaQuery.of(this).size.width <= 500.0;

  bool get isTablet =>
      MediaQuery.of(this).size.width < 1024.0 &&
      MediaQuery.of(this).size.width >= 650.0;

  bool get isSmallTablet =>
      MediaQuery.of(this).size.width < 650.0 &&
      MediaQuery.of(this).size.width > 500.0;

  bool get isDesktop => MediaQuery.of(this).size.width >= 1024.0;

  bool get isSmall =>
      MediaQuery.of(this).size.width < 850.0 &&
      MediaQuery.of(this).size.width >= 560.0;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  Size get size => MediaQuery.of(this).size;

  /*------------------ text styles --------------*/

  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;

  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;

  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;

  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;

  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;

  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;

  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;

  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;

  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;

  TextStyle? get titleTextStyle => Theme.of(this).appBarTheme.titleTextStyle;

  TextStyle? get bodyExtraSmall =>
      bodySmall?.copyWith(fontSize: 10, height: 1.6, letterSpacing: .5);

  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;

  TextStyle? get dividerTextSmall => bodySmall?.copyWith(
      letterSpacing: 0.5, fontWeight: FontWeight.w700, fontSize: 12.0);

  TextStyle? get dividerTextLarge => bodySmall?.copyWith(
      letterSpacing: 1.5,
      fontWeight: FontWeight.w700,
      fontSize: 13.0,
      height: 1.23);

  /*------------------ Theme colors --------------*/

  Color get primaryColor => Theme.of(this).primaryColor;

  Color get primaryColorDark => Theme.of(this).primaryColorDark;

  Color get primaryColorLight => Theme.of(this).primaryColorLight;

  Color get primary => Theme.of(this).colorScheme.primary;

  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;

  Color get secondary => Theme.of(this).colorScheme.secondary;

  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;

  Color get cardColor => Theme.of(this).cardColor;

  Color get errorColor => Theme.of(this).colorScheme.error;

  Color get background => Theme.of(this).colorScheme.background;

  /*------------------ bottom sheet and snackbar  --------------*/

  Future<T?> showBottomSheet(
    Widget child, {
    bool isScrollControlled = true,
    Color? backgroundColor,
    Color? barrierColor,
  }) {
    return showModalBottomSheet(
      context: this,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      builder: (context) => Wrap(children: [child]),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      String message) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class HexColor extends Color {
  static int _fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll("#", "");
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString";
    }
    return int.parse(hexColorString, radix: 16);
  }

  HexColor(final String hexColor) : super(_fromHex(hexColor));
}

extension BreakWord on String {
  String get breakWord {
    String breakWord = '';
    for (var element in runes) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    }
    return breakWord;
  }
}

extension BlocExtensions<T> on BlocBase<T> {
  Listenable asListenable() {
    final notifier = ChangeNotifier();
    stream.listen((_) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      notifier.notifyListeners();
    });
    return notifier;
  }

  ValueListenable<T> asValueListenable({
    BlocBuilderCondition? notifyWhen,
  }) {
    final notifier = ValueNotifier<T>(state);
    stream.listen((value) {
      if (notifyWhen == null || notifyWhen(notifier.value, value)) {
        notifier.value = value;
      }
    });
    return notifier;
  }
}
