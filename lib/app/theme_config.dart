import 'package:flutter/material.dart';
import 'package:webblen_web_app/constants/custom_colors.dart';

final String fontFamily = "Helvetica Neue";

ThemeData regularTheme = ThemeData(
  backgroundColor: Colors.white,
  accentColor: CustomColors.webblenRed,
  brightness: Brightness.light,
  fontFamily: fontFamily,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.black,
  ),
);

ThemeData darkTheme = ThemeData(
  backgroundColor: CustomColors.webblenDarkGray,
  accentColor: CustomColors.webblenRed,
  brightness: Brightness.dark,
  fontFamily: fontFamily,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.white,
  ),
);

List<ThemeData> appThemes = [
  regularTheme,
  darkTheme,
];
