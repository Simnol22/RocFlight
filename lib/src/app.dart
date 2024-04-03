import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roc_flight/src/views/find_view.dart';
import 'package:roc_flight/src/views/flight_view.dart';
import 'package:roc_flight/src/views/history_view.dart';
import 'package:roc_flight/src/views/home.dart';
import 'package:roc_flight/src/views/live_data_view.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  final FlexSchemeColor _schemeLight = FlexSchemeColor.from(
    primary: const Color(0xFF00296B),
    secondary: const Color(0xFFFF7B00),
  );

  final FlexSchemeColor _schemeDark = FlexSchemeColor.from(
    primary: const Color(0xFF6B8BC3),
  );

  final int _toDarkLevel = 30;
  final bool _swapColors = false;

  late final String? _fontFamily = GoogleFonts.notoSans().fontFamily;

  final TextTheme _textTheme = const TextTheme(
    displayLarge: TextStyle(fontSize: 57),
    displayMedium: TextStyle(fontSize: 45),
    displaySmall: TextStyle(fontSize: 36),
    labelSmall: TextStyle(fontSize: 11, letterSpacing: 0.5),
  );

  final FlexScheme _scheme = FlexScheme.bigStone;
  final bool _useScheme = true;
  final double _appBarElevation = 0.5;
  final double _appBarOpacity = 0.94;
  final bool _computeDarkTheme = true;

  final bool _transparentStatusBar = true;
  final FlexTabBarStyle _tabBarForAppBar = FlexTabBarStyle.forAppBar;
  final bool _tooltipsMatchBackground = true;
  final VisualDensity _visualDensity =
      FlexColorScheme.comfortablePlatformDensity;
  final TargetPlatform _platform = defaultTargetPlatform;
  final FlexSurfaceMode _surfaceMode =
      FlexSurfaceMode.highBackgroundLowScaffold;
  final int _blendLevel = 15;

  final FlexSubThemesData _subThemesData = const FlexSubThemesData(
    interactionEffects: true,
    defaultRadius: null,
    bottomSheetRadius: 24,
    useTextTheme: true,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorIsFilled: true,
    inputDecoratorUnfocusedHasBorder: true,
    inputDecoratorSchemeColor: SchemeColor.primary,

    chipSchemeColor: SchemeColor.primary,

    elevatedButtonElevation: 1,
    thickBorderWidth: 2, // Default is 2.0.
    thinBorderWidth: 1.5, // Default is 1.5.

    bottomNavigationBarBackgroundSchemeColor: SchemeColor.background,
  );

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          theme: FlexThemeData.light(
            colors: _useScheme ? null : _schemeLight,
            scheme: _scheme,
            swapColors: _swapColors,
            lightIsWhite: false,
            appBarStyle: FlexAppBarStyle.primary,
            appBarElevation: _appBarElevation,
            appBarOpacity: _appBarOpacity,
            transparentStatusBar: _transparentStatusBar,
            tabBarStyle: _tabBarForAppBar,
            surfaceMode: _surfaceMode,
            blendLevel: _blendLevel,
            tooltipsMatchBackground: _tooltipsMatchBackground,
            textTheme: _textTheme,
            primaryTextTheme: _textTheme,
            subThemesData: _subThemesData,
            visualDensity: _visualDensity,
            platform: _platform,
          ),
          darkTheme: FlexThemeData.dark(
            colors: (_useScheme && _computeDarkTheme)
                ? FlexColor.schemes[_scheme]!.light.toDark(_toDarkLevel)
                : _useScheme
                    ? null
                    : _computeDarkTheme
                        ? _schemeLight.toDark(_toDarkLevel)
                        : _schemeDark,
            scheme: _scheme,
            swapColors: _swapColors,
            darkIsTrueBlack: false,
            appBarStyle: FlexAppBarStyle.background,
            appBarElevation: _appBarElevation,
            appBarOpacity: _appBarOpacity,
            transparentStatusBar: _transparentStatusBar,
            tabBarStyle: _tabBarForAppBar,
            surfaceMode: _surfaceMode,
            blendLevel: _blendLevel,
            tooltipsMatchBackground: _tooltipsMatchBackground,
            fontFamily: _fontFamily,
            textTheme: _textTheme,
            primaryTextTheme: _textTheme,
            subThemesData: _subThemesData,
            visualDensity: _visualDensity,
            platform: _platform,
          ),
          themeMode: settingsController.themeMode,

          home: const HomeView(),
          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case HomeView.routeName:
                    return const HomeView();
                  case FlightView.routeName:
                    return const FlightView();
                  case HistoryView.routeName:
                    return const HistoryView();
                  case FindView.routeName:
                    return const FindView();
                  case LiveDataView.routeName:
                  default:
                    return const FlightView();
                }
              },
            );
          },
        );
      },
    );
  }
}
