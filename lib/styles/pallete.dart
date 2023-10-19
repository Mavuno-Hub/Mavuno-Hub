import 'package:flutter/material.dart';

class AppColor {
  static MaterialColor colorScheme = const MaterialColor(
    0xFFFFAE00,
    <int, Color>{
      50: Color(0xFFFFAE00),
      100: Color(0xFFFFAE00),
      200: Color(0xFFFFAE00),
      300: Color(0xFFFFAE00),
      400: Color(0xFFFFAE00),
      500: Color(0xFFFFAE00),
      600: Color(0xFFFFAE00),
      700: Color(0xFFFFAE00),
      800: Color(0xFFFFAE00),
      900: Color(0xFFFFAE00),
    },
  );

  // ignore: constant_identifier_names
  static const Color dark = Color(0xFF352F2D);
  static const Color accentDark = Color(0xFF403936);
  static const Color hintText = Color(0xFFc1b6b4);
  static const Color accentLight = Color.fromARGB(255, 236, 236, 236);
  static const Color yellow = Color(0xFFFFAE00);
  static const Color error = Color.fromARGB(255, 255, 17, 0);
  static const Color valid = Color.fromARGB(255, 90, 201, 0);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
}
