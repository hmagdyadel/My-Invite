

import 'package:flutter/material.dart';



// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

// Future handleForegroundMessages() async {
//   await Firebase.initializeApp();
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );
//
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     if (message.notification != null) {
//       Get.snackbar(
//           message.notification!.title ?? "", message.notification!.body ?? "",
//           backgroundColor: Colors.white);
//     }
//   });
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize AuthController before anything else
  // Get.put(AuthController());
  // if (!kIsWeb) {
  //   await NotificationService().init();
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   handleForegroundMessages();
  // }
  //
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //     statusBarColor: bgColor, statusBarBrightness: Brightness.light));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Invite',
        debugShowCheckedModeBanner: false,
        //translations: Language(),
        locale: const Locale('en', 'US'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        //home: ScanScreenWithOverlay()
        home: const Scaffold());
  }

  // ThemeData themeData() {
  //   return ThemeData(
  //       textButtonTheme: TextButtonThemeData(
  //           style: TextButton.styleFrom(
  //               backgroundColor: Colors.transparent,
  //               foregroundColor: Colors.white)),
  //       primaryColor: primaryColor,
  //       fontFamily: "SFPro",
  //       textTheme: const TextTheme(
  //         bodyLarge: TextStyle(color: Colors.black, fontFamily: "SFPro"),
  //       ),
  //       colorScheme: ThemeData()
  //           .colorScheme
  //           .copyWith(primary: primaryColor, secondary: secondaryColor),
  //       appBarTheme:
  //           const AppBarTheme(backgroundColor: primaryColor, elevation: 0));
  // }
}
