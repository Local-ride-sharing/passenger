import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:passenger/src/utils/constants.dart';

class ThemeHelper {
  final int value;

  ThemeHelper(this.value) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: backgroundColor,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
  }

  bool get isDark => value == ThemeValue.light
      ? false
      : value == ThemeValue.systemPreferred
          ? SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark
          : true;

  MaterialColor get accentColor => Colors.red;

  Color get primaryColor => isDark ? Colors.white : Colors.black;

  Color get backgroundColor => isDark ? Colors.black : Colors.white;

  Color get secondaryColor => isDark ? Colors.grey.shade900 : Colors.grey.shade50;

  /*Color get secondaryColor => isDark ? Colors.grey.shade900 : Colors.grey.shade50;*/

  Color get mapBackgroundColor => isDark ? Color(0xFF212121) : Color(0xFFf5f5f5);

  Color get textColor => isDark ? Colors.grey.shade100 : Colors.grey.shade900;

  Color get iconColor => isDark ? Colors.grey.shade100 : Colors.grey.shade800;

  Color get shadowColor => isDark ? Colors.white12 : Colors.black12;

  Color get hintColor => isDark ? Colors.grey : Colors.grey;

  Color get errorColor => isDark ? Colors.redAccent.shade400 : Colors.redAccent.shade400;

  Color get successColor => isDark ? Colors.greenAccent.shade400 : Colors.greenAccent.shade400;

  Color get shimmerBaseColor => isDark ? Colors.grey.shade800 : Colors.grey.shade100;

  Color get shimmerHighlightColor => isDark ? Colors.grey.shade900 : Colors.grey.shade50;

  Color get vehicleSelectionBorder => isDark ? Colors.deepOrange.shade900 : Colors.red;

  Color get redShade => isDark ? secondaryColor : errorColor.withOpacity(0.04);

  Color get vehicleSelectionBackground => isDark ? Colors.deepOrange.shade900.withOpacity(.15) : Colors.red.withOpacity(.15);
}
