import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/dimensions/dimensions.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/services/navigation_service.dart';

class MyInvite extends StatelessWidget {
  const MyInvite({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(width, height),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Invite',
        onGenerateRoute: AppRouter().generateRoute,
        initialRoute: Routes.splashScreen,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        // Use context.locale instead of direct AppUtilities
        navigatorKey: NavigationService.navigatorKey,
        builder: (context, widget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
            ),
            child: widget!,
          );
        },
      ),
    );
  }
}
