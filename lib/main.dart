import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/di/dependency_injection.dart';

import 'core/services/notification_service.dart';
import 'features/event_calender/logic/event_calender_cubit.dart';
import 'my_invite.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

Future handleForegroundMessages() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permissions first
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  debugPrint("iOS notification permissions status: ${settings.authorizationStatus}");

  if (Platform.isIOS) {
    // Add retry logic for APNS token
    int maxRetries = 3;
    String? apnsToken;

    for (int i = 0; i < maxRetries; i++) {
      // Wait a bit before trying
      await Future.delayed(Duration(seconds: 2));

      apnsToken = await messaging.getAPNSToken();
      debugPrint("Attempt ${i + 1}: APNS Token: $apnsToken");

      if (apnsToken != null) {
        break;
      }
    }

    if (apnsToken == null) {
      debugPrint("Failed to get APNS token after $maxRetries attempts");
      return;
    }
  }

  try {
    String? token = await messaging.getToken();
    debugPrint("FCM Token: $token");
  } catch (error) {
    debugPrint("Error getting FCM token: $error");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first
  await Firebase.initializeApp();

  // Initialize notifications
  await NotificationService().init();

  // Handle messages setup
  await handleForegroundMessages();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  setupGetIt();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => getIt<EventCalenderCubit>(),
      ),
    ],
    child: EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      saveLocale: true,
      startLocale: Locale(Platform.localeName.split('_')[0]),
      path: 'assets/translations',
      fallbackLocale: Locale(Platform.localeName.split('_')[0]),
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyInvite();
  }
}
