import 'package:flutter/material.dart';

import '../pallete.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: "Gilmer",
  hintColor: const Color.fromARGB(255, 124, 124, 124),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(
          fontFamily: "Gilmer",
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: AppColor.dark),
      bodyMedium: TextStyle(
          fontFamily: "Gilmer",
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: AppColor.dark),
      bodySmall: TextStyle(
          fontFamily: "Gilmer",
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: AppColor.dark)),
  appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      elevation: 0,
      iconTheme: IconThemeData(color: AppColor.yellow),
      titleTextStyle: TextStyle(color: AppColor.dark)),
  colorScheme: const ColorScheme.light(
      errorContainer: AppColor.error,
      onError: AppColor.dark,
      surface: AppColor.valid,
      onPrimary: AppColor.white,
      background: AppColor.white,
      onBackground: Color.fromARGB(255, 60, 52, 49),
      primary: AppColor.white,
      secondary: AppColor.accentLight,
      tertiary: AppColor.yellow),
);
