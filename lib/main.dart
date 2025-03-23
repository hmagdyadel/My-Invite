import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/di/dependency_injection.dart';
import 'core/services/new_notification_service.dart';
import 'features/event_calender/logic/event_calender_cubit.dart';
import 'my_invite.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  // // Catch Flutter errors
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   FlutterError.presentError(details);
  //   // Show error screen
  //   runApp(ErrorDisplayScreen(
  //     errorMessage: details.exception.toString(),
  //     stackTrace: details.stack.toString(),
  //   ));
  // };

  // // Catch asynchronous errors
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   // Show error screen
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     runApp(ErrorDisplayScreen(
  //       errorMessage: error.toString(),
  //       stackTrace: stack.toString(),
  //     ));
  //   });
  //   return true;
  // };

  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp();
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint("FCM Token: $fcmToken");
  if (Platform.isIOS) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  if (kDebugMode) {
    FirebaseMessaging.instance.setDeliveryMetricsExportToBigQuery(true);
    debugPrint("Firebase Messaging initialized in debug mode");
  }
  await EasyLocalization.ensureInitialized();

  // Add this to your app initialization
  await NewNotificationService().init();
  tz.initializeTimeZones();
  setupGetIt();

  runApp(const MyAppWrapper());
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<EventCalenderCubit>(),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        saveLocale: true,
        startLocale: Locale(Platform.localeName.split('_')[0]),
        path: 'assets/translations',
        fallbackLocale: Locale(Platform.localeName.split('_')[0]),
        child: const MyInvite(),
      ),
    );
  }
}
