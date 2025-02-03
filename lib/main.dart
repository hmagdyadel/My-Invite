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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future handleForegroundMessages() async {
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      NotificationService().showInstantNotification(body: message.notification!.body ?? "", title: message.notification!.title ?? "");
    }
  });
  messaging.getToken().then((onValue){
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await NotificationService().init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  handleForegroundMessages();

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
