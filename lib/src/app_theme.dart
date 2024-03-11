import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ETS colors
  static const Color etsLightRed = Color(0xffef3e45);
  static const Color etsDarkRed = Color(0xffbf311a);
  static const Color etsLightGrey = Color(0xff807f83);
  static const Color etsDarkGrey = Color(0xff636467);
  static const Color etsBlack = Color(0xff2e2a25);

  // Backgrounds
  static const Color darkThemeBackground = Color(0xff303030);
  static const Color lightThemeBackground = Color(0xffffffff);
  static const Color scaffoldDarkBackground = Color(0xff121212);
  static const Color scaffoldLightBackground = Color(0xfffafafa);

  // App|ETS colors
  static const Color appletsPurple = Color(0xff19375f);
  static const Color appletsDarkPurple = Color(0xff122743);

  // Grade colors
  static const Color gradeFailureMin = Color(0xffd32f2f);
  static const Color gradeFailureMax = Color(0xffff7043);
  static const Color gradePassing = Color(0xfffff176);
  static const Color gradeGoodMin = Color(0xffaed581);
  static const Color gradeGoodMax = Color(0xff43a047);

  // Primary
  static const Color primary = etsLightRed;

  // Primary dark
  static const Color primaryDark = Color(0xff121212);

  // Accent
  static const Color accent = etsLightRed;

  /// Light theme
  static ThemeData lightTheme() {
    final ThemeData lightTheme = ThemeData.light();
    return lightTheme.copyWith(
        primaryColor: etsLightRed,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: etsLightRed,
            foregroundColor: primaryDark,
          ),
        ),
        //bottomNavigationBarTheme: lightTheme.bottomNavigationBarTheme.copyWith(selectedItemColor: etsLightRed),
        snackBarTheme: const SnackBarThemeData(
            backgroundColor: lightThemeBackground, contentTextStyle: TextStyle(color: primaryDark)),
        colorScheme: lightTheme.colorScheme
            .copyWith(primary: etsLightRed, secondary: etsLightRed)
            .copyWith(secondary: etsLightRed)
            .copyWith(surfaceTint: Colors.white));
  }

  /// Dark theme
  static ThemeData darkTheme() {
    final ThemeData darkTheme = ThemeData.dark();
    return darkTheme.copyWith(
        scaffoldBackgroundColor: scaffoldDarkBackground,
        cardColor: const Color(0xff1e1e1e),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: etsLightRed,
            foregroundColor: Colors.white,
          ),
        ),
        //bottomNavigationBarTheme: darkTheme.bottomNavigationBarTheme.copyWith(selectedItemColor: etsLightRed),
        snackBarTheme:
            const SnackBarThemeData(backgroundColor: primaryDark, contentTextStyle: TextStyle(color: Colors.white)),
        colorScheme: darkTheme.colorScheme
            .copyWith(primary: etsLightRed, secondary: etsLightRed)
            .copyWith(secondary: etsLightRed)
            .copyWith(surface: const Color(0xff1e1e1e), surfaceTint: const Color(0xff1e1e1e)));
  }
}
