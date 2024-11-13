import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/utils/storage/them_setting.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    // Load theme from storage on initialization
    _loadTheme();
  }

  // Load theme from storage
  Future<void> _loadTheme() async {
    final storedTheme = await CurrentThemeSetting().get();
    if (storedTheme != null) {
      state = storedTheme;
    }
  }

  // Update theme mode and save it in storage
  void updateTheme(ThemeMode themeMode)async {
    state = themeMode;
    await CurrentThemeSetting().update(themeMode: themeMode);
  }
}
