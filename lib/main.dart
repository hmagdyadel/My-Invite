import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/dependency_injection.dart';
import 'core/helpers/firebase_messaging_handler.dart';
import 'core/routing/routes.dart';
import 'core/services/notification_service.dart';
import 'features/event_calender/logic/event_calender_cubit.dart';
import 'my_invite.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background message: ${message.messageId}');

  // Set the pending route for when the app is launched
  FirebaseMessagingHandler.pendingNavigationRoute = Routes.eventsCalendar;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services
  await _initializeCoreServices();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Set up dependency injection
  setupGetIt();

  runApp(const MyAppWrapper());
}

Future<void> _initializeCoreServices() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize notification service
  await NotificationService().init();

  // Initialize Firebase Messaging handler
  await FirebaseMessagingHandler().initialize();
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