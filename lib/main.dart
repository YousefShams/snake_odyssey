import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app/application/app.dart';
import 'app/constants/constants.dart';
import 'app/locales/supported_locales.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
      EasyLocalization(
        startLocale: SupportedLocales.arabicLocale,
        supportedLocales: SupportedLocales.get(),
        path: AppConstants.translationsPath,
        fallbackLocale: SupportedLocales.englishLocale,
        child: const App()
      )
  );
}

