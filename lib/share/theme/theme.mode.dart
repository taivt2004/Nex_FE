import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  ThemeModel() {
    currentTheme = FlexThemeData.light(
      primary: const Color(0xff2970ff),
      onPrimary: const Color(0xff2970ff),
      scheme: FlexScheme.bahamaBlue,
      appBarElevation: 0.5,
      applyElevationOverlayColor: true,
      appBarStyle: FlexAppBarStyle.scaffoldBackground,
      useMaterial3: false,
      typography: Typography.material2021(platform: defaultTargetPlatform),
    );
    darkTheme = FlexThemeData.dark(
      primary: const Color(0xff2970ff),
      onPrimary: const Color(0xff499eef),
      scheme: FlexScheme.bahamaBlue,
      scaffoldBackground: const Color(0xFF121314),
      appBarElevation: 2,
      applyElevationOverlayColor: true,
      appBarStyle: FlexAppBarStyle.scaffoldBackground,
      useMaterial3: false,
      typography: Typography.material2021(platform: defaultTargetPlatform),
    );
    themeMode = ThemeMode.dark;
  }
  ThemeData? currentTheme;
  ThemeData? darkTheme;
  ThemeMode? themeMode;

  void toggleTheme() {
    themeMode = (themeMode == ThemeMode.dark)
        ? ThemeMode.light
        : ThemeMode.dark;
    notifyListeners();
  }
}
