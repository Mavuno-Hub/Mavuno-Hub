import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavunohub/auth/auth_service.dart';
import 'package:mavunohub/firebase_options.dart';
import 'package:mavunohub/screens/app_screens/log_in_page.dart';
import 'styles/theme/dark_theme.dart';
import 'styles/theme/light_theme.dart';

import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
            name: 'mavunohub',
            options: const FirebaseOptions(
                apiKey: "AIzaSyCi1SJ7abwOZzexunwohYlyXVEmluRXtgU",
                appId: "1:914748917180:web:69d19a583a5ae594ddd7b9",
                messagingSenderId: "914748917180",
                projectId: "mavunohub-37adb"))
        .whenComplete(() {
      print("completedAppInitialize");
    });
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: GetMaterialApp(
       color: Theme.of(context).colorScheme.background,
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        // home: const ResponsiveLayout(
        //   mobileBody: MobileScaffold(),
        //   tabletBody: TabletScaffold(),
        //   desktopBody: DesktopScaffold(),
        // ),
        home: const LogInUser(),
      ),
    );
  }
}

