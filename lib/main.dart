import 'package:flutter/material.dart';
import 'package:mavunohub/responsive/desktop_body.dart';
import 'package:mavunohub/responsive/tablet_body.dart';
import 'responsive/mobile_body.dart';
import 'responsive/responsive_layout.dart';
import 'styles/theme/dark_theme.dart';
import 'styles/theme/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: ResponsiveLayout(
        mobileBody: const MobileScaffold(),
        tabletBody: const TabletScaffold(),
        desktopBody: const DesktopScaffold(),
      ),
    );
  }
}
