// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mavunohub/features/rss.dart';
// import 'package:mavunohub/logic/auth/auth_service.dart';
// import 'package:mavunohub/firebase_options.dart';
// import 'package:mavunohub/models/update_firestore.dart';
// import 'package:mavunohub/responsive/desktop_body.dart';
// import 'package:mavunohub/responsive/mobile_body.dart';
// import 'package:mavunohub/screens/app_screens/log_in_page.dart';
// import 'package:mavunohub/screens/app_screens/news.dart';
// import 'package:mavunohub/user_controller.dart';
// import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
// import 'styles/theme/dark_theme.dart';
// import 'styles/theme/light_theme.dart';
// // import 'dart:io';
// import 'package:provider/provider.dart';
// // import 'package:firebase_core/firebase_core';

// import 'package:flutter_native_splash/flutter_native_splash.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // if (Firebase.apps.isEmpty) {
//   //   await Firebase.initializeApp(
//   //           name: 'mavunohub',
//   //           options: const FirebaseOptions(
//   //               apiKey: "AIzaSyCi1SJ7abwOZzexunwohYlyXVEmluRXtgU",
//   //               appId: "1:914748917180:web:69d19a583a5ae594ddd7b9",
//   //               messagingSenderId: "914748917180",
//   //               projectId: "mavunohub-37adb"))
//   //       .whenComplete(() {
//   //     print("completedAppInitialize");
//   //   });
//   // }
//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   MpesaFlutterPlugin.setConsumerKey(
//       'ksMDZuRG1c9AIUZf3QFdAWjnNll7bM5dbGTuIkH9jGxVkcjv');
//   MpesaFlutterPlugin.setConsumerSecret(
//       'DIns5VnZxwNFRoioNY8AhMawpwZpIjhAd896KhkCWJDvG37VjHtsWZn8rAripA33');
//   // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
//   // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

// // For enabling Firebase Emulator Tool
//   //
// //   @override
//   // void initState() {
//   //   // String host = Platform.isAndroid ? '10.0.2.2:8080' : 'localhost:8080';
//   //   FlutterNativeSplash.remove();
//   //   // Firebase.instance.settings(
//   //   //   host: host,
//   //   //   sslEnabled: false,
//   //   //   persistenceEnabled: false,
//   //   // );
//   //   // super.initState();
//   // }

//     @override
//   void initState() {
//     // super.initState();
//     initialization();
//     // super.initState();
//   }
//   void initialization() async {
//     await Future.delayed(const Duration(seconds: 1));
//     FlutterNativeSplash.remove();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<AuthService>(
//           create: (_) => AuthService(FirebaseAuth.instance),
//         ),
//         StreamProvider(
//           create: (context) => context.read<AuthService>().authStateChanges,
//           initialData: null,
//         ),
//       ],
//       child: GetMaterialApp(
//         color: Theme.of(context).colorScheme.background,
//         debugShowCheckedModeBanner: false,
//         theme: lightTheme,
//         darkTheme: darkTheme,
//         home: LogInUser(),
//         initialBinding: UserBindings(),
//       ),
//     );
//   }
// }

// class UserBindings implements Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<UserController>(() => UserController());
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavunohub/features/rss.dart';
import 'package:mavunohub/logic/auth/auth_service.dart';
import 'package:mavunohub/firebase_options.dart';
import 'package:mavunohub/models/update_firestore.dart';
import 'package:mavunohub/responsive/desktop_body.dart';
import 'package:mavunohub/responsive/mobile_body.dart';
import 'package:mavunohub/screens/app_screens/log_in_page.dart';
import 'package:mavunohub/screens/app_screens/news.dart';
import 'package:mavunohub/user_controller.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'styles/theme/dark_theme.dart';
import 'styles/theme/light_theme.dart';
// import 'dart:io';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core';

import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //           name: 'mavunohub',
  //           options: const FirebaseOptions(
  //               apiKey: "AIzaSyCi1SJ7abwOZzexunwohYlyXVEmluRXtgU",
  //               appId: "1:914748917180:web:69d19a583a5ae594ddd7b9",
  //               messagingSenderId: "914748917180",
  //               projectId: "mavunohub-37adb"))
  //       .whenComplete(() {
  //     print("completedAppInitialize");
  //   });
  // }
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MpesaFlutterPlugin.setConsumerKey(
      'ksMDZuRG1c9AIUZf3QFdAWjnNll7bM5dbGTuIkH9jGxVkcjv');
  MpesaFlutterPlugin.setConsumerSecret(
      'DIns5VnZxwNFRoioNY8AhMawpwZpIjhAd896KhkCWJDvG37VjHtsWZn8rAripA33');
  // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// For enabling Firebase Emulator Tool
  //
//   @override
  // void initState() {
  //   // String host = Platform.isAndroid ? '10.0.2.2:8080' : 'localhost:8080';
  //   FlutterNativeSplash.remove();
  //   // Firebase.instance.settings(
  //   //   host: host,
  //   //   sslEnabled: false,
  //   //   persistenceEnabled: false,
  //   // );
  //   // super.initState();
  // }

    @override
  void initState() {
    // super.initState();
    initialization();
    // super.initState();
  }
  void initialization() async {
    // await Future.delayed(const Dua
    FlutterNativeSplash.remove();
  }
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
        home: LogInUser(),
        initialBinding: UserBindings(),
      ),
    );
  }
}

class UserBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}
