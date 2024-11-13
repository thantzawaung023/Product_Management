import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class CurrentThemeSetting {
  factory CurrentThemeSetting() {
    return _instance;
  }

  CurrentThemeSetting._internal();

  static final CurrentThemeSetting _instance = CurrentThemeSetting._internal();
  static const _currentThemeKey = 'themModeType';

  Future<ThemeMode?> get() async {
    final box = GetStorage();
    final themeModeString = box.read<String?>(_currentThemeKey);
    if (themeModeString == 'ThemeMode.dark') {
      return ThemeMode.dark;
    } else if (themeModeString == 'ThemeMode.light') {
      return ThemeMode.light;
    }
    return ThemeMode.system; // Default if nothing is stored
  }

  Future<void> update({required ThemeMode themeMode}) async {
    final box = GetStorage();
    final themeModeString = themeMode.toString();
    await box.write(_currentThemeKey, themeModeString);
  }
}
