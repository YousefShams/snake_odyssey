import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:snake/app/locales/supported_locales.dart';
import 'package:snake/app/resources/app_strings.dart';

class SettingsLanguageButton extends StatelessWidget {
  final Function update;
  const SettingsLanguageButton({Key? key, required this.update}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      underline: const SizedBox.shrink(),
      icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.white,),
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      borderRadius: BorderRadius.circular(20),
      value: context.locale,
      onChanged: (Locale? value) {  },
      items: SupportedLocales.get().map((locale) =>
          DropdownMenuItem(
            alignment: Alignment.center,
            value: locale,
            onTap: () { context.setLocale(locale); update(); },
            child: Text(AppStrings.getLanguageFromCode("$locale")),
          )
      ).toList(),
    );
  }
}
