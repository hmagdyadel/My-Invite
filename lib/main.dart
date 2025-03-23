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


void setFirebase() async {
  try {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');

      // Get the token and handle refreshes
      String? token = await FirebaseMessaging.instance.getToken();
      debugPrint("FCM Token: $token");

      // Save token to your backend here
      // sendTokenToBackend(token);

      // Handle token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        debugPrint("New FCM token: $newToken");
        // Update token on your backend here
      });
    }

    // Set up message handlers
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("FCM MESSAGE RECEIVED!");
      debugPrint("Message ID: ${message.messageId}");
      debugPrint("Notification: ${message.notification?.title}, ${message.notification?.body}");
      debugPrint("Data: ${message.data}");
      debugPrint("Foreground message received: ${message.notification?.title}");



      final notification = message.notification;
      if (notification != null) {
        NewNotificationService().showNotificationWithActions(
          id: message.messageId.hashCode,
          title: notification.title ?? "",
          body: notification.body ?? "",
          payload: message.data.toString(),
        );
      }
    });

    // Check for initial message (app opened from terminated state)
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint("App opened from terminated state with message: ${message.messageId}");
        // Handle the initial message - perhaps navigate to a specific screen
      }
    });

    // Handle message when app is in background but opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("App opened from background state with message: ${message.messageId}");
      // Handle the message - perhaps navigate to a specific screen
    });

  } catch (e) {
    debugPrint("FCM setup error: $e");

  }
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

  // Get APNs token (iOS only)
  String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  print("APNs Token: $apnsToken");

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
  setFirebase();

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
