import 'package:flutter/material.dart';

import '../pallete.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: "Gilmer",
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontFamily: "Gilmer", 
      fontWeight: FontWeight.w900,
      fontSize: 16,
      color: AppColor.dark
    ),bodyMedium: TextStyle(
      fontFamily: "Gilmer", 
      fontWeight: FontWeight.w900,
      fontSize: 14,
      color: AppColor.dark
    ),bodySmall: TextStyle(
      fontFamily: "Gilmer", 
      fontWeight: FontWeight.w900,
      fontSize: 12,
      color: AppColor.dark
    )
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      elevation: 0,
      iconTheme: IconThemeData(color: AppColor.yellow),
      titleTextStyle: TextStyle(color: AppColor.yellow)),
  colorScheme: const ColorScheme.light(
      background: AppColor.accentLight,
      onBackground: AppColor.dark,
      primary: AppColor.accentLight,
      secondary: AppColor.white,tertiary: AppColor.yellow),
);
 