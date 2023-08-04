
// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:easy_localization/easy_localization.dart';

class AppStrings {

  static String get appTitle => "appTitle".tr();

  static String get play => "play".tr();
  static String get score => "score".tr();

  static String get howTitle => "howTitle".tr();
  static String get movementTitle => "movementTitle".tr();
  static String get shootTitle => "shootTitle".tr();
  static String get foodTitle => "foodTitle".tr();

  static String get movement => "movement".tr();
  static String get shooting => "shooting".tr();
  static String get findFood => "findFood".tr();

  static String get settingsTitle => "settingsTitle".tr();
  static String get speedTitle => "speedTitle".tr();
  static String get doneButton => "doneButton".tr();

  static String get languageTitle => "languageTitle".tr();
  static String get english => "english".tr();
  static String get arabic => "arabic".tr();


  static String getLanguageFromCode(String code) {
    if(code =='ar') {
      return arabic;
    }
    else {
      return english;
    }
  }
}