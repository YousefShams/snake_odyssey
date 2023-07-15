
import 'package:flutter/material.dart';

class AppFonts {
  static const fontFamily = "Poppins";

  static const lightFontWeight = FontWeight.w300;
  static const mediumFontWeight = FontWeight.w500;
  static const boldFontWeight = FontWeight.w700;

  static const double tinyFontSize = 12.0;
  static const double smallerFontSize = 14.0;
  static const double smallFontSize = 14.0;
  static const double mediumFontSize = 16.0;
  static const double largeFontSize = 18.0;
  static const double xLFontSize = 20.0;
  static const double xXLFontSize = 22.0;

  static getRegularStyle({double size = 14, Color color = Colors.black}) {
    return TextStyle(fontWeight: lightFontWeight, fontSize: size, color: color);
  }

  static getMediumStyle({double size = 16, Color color = Colors.black}) {
    return TextStyle(fontWeight: mediumFontWeight, fontSize: size, color: color);
  }

  static getBoldStyle({double size = 20, Color color = Colors.black}) {
    return TextStyle(fontWeight: boldFontWeight, fontSize: size, color: color);
  }
}