
import 'dart:ui';

class SupportedLocales {
  static const englishLocale = Locale('en');
  static const arabicLocale = Locale('ar');

  static List<Locale> get() {
    return const [
      englishLocale,
      arabicLocale,
    ];
  }
}