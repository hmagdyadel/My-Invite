import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'core/di/dependency_injection.dart';
import 'core/services/background_notifications_service.dart';
import 'core/services/battery_optimization_helper.dart';
import 'core/services/notification_service.dart';
import 'features/event_calender/logic/event_calender_cubit.dart';
import 'my_invite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Request explicit notification permissions
  if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
  }

  // Initialize notification service
  await NotificationService().init();

  // Initialize background service
  await BackgroundNotificationService.initializeService();

  // Request battery optimization bypass
  await BatteryOptimizationHelper.disableBatteryOptimizations();
  setupGetIt();
  runApp(
      MultiBlocProvider(
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
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyInvite();
  }
}
