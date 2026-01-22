import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nexpaylab/app/data/service/local_storage_service.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class ThemeModel extends ChangeNotifier {
  ThemeModel(this._localStorageService) {
    _loadTheme();
    currentTheme = FlexThemeData.light(
      scheme: FlexScheme.greys,
      primary: OlaColors.gray800,
      secondary: OlaColors.gray800,
      tertiary: OlaColors.gray800,
      onPrimary: Colors.white,
      scaffoldBackground: Colors.white,
      appBarBackground: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      appBarElevation: 0,
      applyElevationOverlayColor: true,
      appBarStyle: FlexAppBarStyle.scaffoldBackground,
      useMaterial3: true,
      typography: Typography.material2021(platform: defaultTargetPlatform),
      subThemesData: const FlexSubThemesData(
        elevatedButtonSchemeColor: SchemeColor.primary,
        inputDecoratorBorderType: FlexInputBorderType.outline,
      ),
    ).copyWith(
      iconTheme: const IconThemeData(color: Colors.black),
      textTheme: Typography.material2021(platform: defaultTargetPlatform)
          .black
          .apply(bodyColor: Colors.black, displayColor: Colors.black),
    );

    darkTheme = FlexThemeData.dark(
      scheme: FlexScheme.greys,
      primary: Colors.grey,
      secondary: OlaColors.backgroundBtn,
      tertiary: OlaColors.actionBtnColor,
      onPrimary: Colors.white,
      scaffoldBackground: OlaColors.appbackground,
      surface: const Color.fromARGB(255, 1, 13, 25),
      onSurface: Colors.white,
      appBarElevation: 0,
      applyElevationOverlayColor: true,
      appBarStyle: FlexAppBarStyle.scaffoldBackground,
      useMaterial3: true,
      typography: Typography.material2021(platform: defaultTargetPlatform),
      subThemesData: const FlexSubThemesData(
        elevatedButtonSchemeColor: SchemeColor.primary,
        inputDecoratorBorderType: FlexInputBorderType.outline,
      ),
    ).copyWith(
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: Typography.material2021(platform: defaultTargetPlatform)
          .white
          .apply(bodyColor: Colors.white, displayColor: Colors.white),
    );
  }

  static const _themKey = 'app_theme_mode';
  final LocalStorageService _localStorageService;

  ThemeData? currentTheme;
  ThemeData? darkTheme;
  ThemeMode? themeMode;

  void _loadTheme() {
    final savedTheme = _localStorageService.getString(_themKey);
    if (savedTheme == 'dark') {
      themeMode = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();

    var valueToSave = 'system';
    if (mode == ThemeMode.dark) valueToSave = 'dark';
    if (mode == ThemeMode.light) valueToSave = 'light';

    await _localStorageService.saveString(_themKey, valueToSave);
  }

  void toggleTheme() {
    final newMode =
        (themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    setTheme(newMode);
  }
}
