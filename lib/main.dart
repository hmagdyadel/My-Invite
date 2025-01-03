import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'core/di/dependency_injection.dart';
import 'my_invite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setupGetIt();
  runApp(
    EasyLocalization(
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
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyInvite();
  }
}
