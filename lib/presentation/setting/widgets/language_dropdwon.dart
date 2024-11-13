import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/provider/language/language_provider.dart';

class LanguageDropdownTile extends StatelessWidget {
  const LanguageDropdownTile({
    super.key,
    required this.supportedLocales,
    required this.ref,
  });
  final Map<Locale, String> supportedLocales; // Map of locales to their names
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final languageNotifier = ref.read(languageProvider.notifier);
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(14)),
      child: DropdownButton(
          padding: const EdgeInsets.symmetric(vertical: 4),
          underline: const SizedBox(),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          hint: RichText(
              text: TextSpan(children: [
            const WidgetSpan(
                child: Icon(
              Icons.public,
              color: Colors.white,
            )),
            const WidgetSpan(
                child: SizedBox(
              width: 15,
            )),
            TextSpan(
                text: AppLocalizations.of(context)!.changeLanguage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                )),
          ])),
          iconSize: 36,
          isExpanded: true,
          dropdownColor: Colors.grey,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          items: supportedLocales.entries.map((valueItem) {
            return DropdownMenuItem(
              value: valueItem.key,
              child: Text(valueItem.value),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              languageNotifier.updateLanguage(newValue);
            }
          }),
    );
  }
}
