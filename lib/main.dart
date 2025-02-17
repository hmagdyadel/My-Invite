import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/di/dependency_injection.dart';
import 'core/services/new_notification_service.dart';
import 'features/event_calender/logic/event_calender_cubit.dart';
import 'my_invite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp();
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
