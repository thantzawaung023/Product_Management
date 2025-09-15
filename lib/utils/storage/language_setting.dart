import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class CurrentLanguageSetting {
  factory CurrentLanguageSetting() {
    return _instance;
  }
  CurrentLanguageSetting._internal();

  static final CurrentLanguageSetting _instance =
      CurrentLanguageSetting._internal();

  static const _currentLanguageKey = 'languageKey';

  Future<Locale?> get() async {
    final box = GetStorage();
    final languageString = box.read<String?>(_currentLanguageKey);
    if (languageString == 'en') {
      return const Locale('en');
    } else if (languageString == 'my') {
      return const Locale('my');
    }
    return const Locale('en'); // Default if nothing is stored
  }

  Future<void> update({required Locale language}) async {
    final box = GetStorage();
    final languageString = language.toString();
    await box.write(_currentLanguageKey, languageString);
  }
}
