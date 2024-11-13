import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/utils/storage/language_setting.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>(
    (ref) => LanguageNotifier());

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('en')) {
    // Load Language from storage on initialization
    _loadLanguage();
  }

  // Load theme from storage
  Future<void> _loadLanguage() async {
    final language = await CurrentLanguageSetting().get();
    if (language != null) {
      state = language;
    }
  }

  // Update theme mode and save it in storage
  void updateLanguage(Locale language) async {
    state = language;
    await CurrentLanguageSetting().update(language: language);
  }
}
