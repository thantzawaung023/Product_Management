import 'package:flutter/material.dart';

import '../utils.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class Validators {
  static String? validateRequiredField({
    required String? value,
    required String labelText,
    required BuildContext context,
  }) {
    final localization = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return '$labelText ${localization.isRequired}';
    }
    return null;
  }

  static String? validateEmail({
    required String? value,
    required String labelText,
    required BuildContext context,
  }) {
    final localization = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return '$labelText ${localization.isRequired}';
    }
    if (!Regxs.validateEmail(value)) {
      return '$labelText ${localization.invalidFormat}';
    }
    return null;
  }

  static String? validatePassword({
    required String? value,
    required String labelText,
    required BuildContext context,
  }) {
    final localization = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return '$labelText ${localization.isRequired}';
    }
    if (!Regxs.validatePassword(value)) {
      return localization.passwordMustHave;
    }
    return null;
  }

  static String? validateAddressName({
    required String? value,
    required String labelText,
    required BuildContext context,
  }) {
    final localization = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return '$labelText ${localization.isRequired}';
    }
    if (!Regxs.validateAddressName(value)) {
      return '$labelText ${localization.invalidFormat}';
    }
    return null;
  }

  static String? validateAddressLocation({
    required String? value,
    required String labelText,
    required BuildContext context,
  }) {
    final localization = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return '$labelText ${localization.isRequired}';
    }
    if (!Regxs.validateAddressLocation(value)) {
      return '$labelText ${localization.invalidFormat} ${localization.locationShouldBe}';
    }
    return null;
  }
}
