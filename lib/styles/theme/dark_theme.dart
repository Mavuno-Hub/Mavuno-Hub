import 'package:flutter/material.dart';
import 'package:mavunohub/styles/pallete.dart';

ThemeData darkTheme = ThemeData(
   fontFamily: "Gilmer",
   textTheme: const TextTheme(
      bodyLarge: TextStyle(
          fontFamily: "Gilmer",
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: AppColor.white),
      bodyMedium: TextStyle(
          fontFamily: "Gilmer",
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: AppColor.white),
      bodySmall: TextStyle(
          fontFamily: "Gilmer",
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: AppColor.white)),
    brightness: Brightness.dark,
    hintColor: const Color.fromARGB(210, 176, 150, 127),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.dark,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColor.yellow),
      titleTextStyle: TextStyle(color: AppColor.yellow),
    ),
    colorScheme: const ColorScheme.dark(
        errorContainer: AppColor.error,
        surface: AppColor.valid,
        onError: AppColor.dark,
        background: AppColor.dark,
        onBackground: AppColor.white,
        primary: AppColor.dark,
        secondary: AppColor.accentDark,
        tertiary: AppColor.yellow));
