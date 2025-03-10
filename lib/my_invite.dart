import 'package:app/core/helpers/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/dimensions/dimensions.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/services/navigation_service.dart';
import 'core/widgets/no_internet_widget.dart';

class MyInvite extends StatelessWidget {
  const MyInvite({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(width, height),
      minTextAdapt: true,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          final NavigatorState navigator =
              NavigationService.navigatorKey.currentState!;
          if (navigator.canPop()) {
            navigator.pop(result);
          } else {
            debugPrint("Cannot pop - no pages left in the navigation stack.");
            context.showErrorToast("Cannot go back further.");
          }
        },
        child: MaterialApp(
          //theme: ThemeData(useMaterial3: true),
          debugShowCheckedModeBanner: false,
          title: 'My Invite',
          onGenerateRoute: AppRouter().generateRoute,
          initialRoute: Routes.splashScreen,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          navigatorKey: NavigationService.navigatorKey,
          builder: (context, widget) {
            return FutureBuilder<bool>(
              future: InternetConnectionChecker.instance.hasConnection,
              builder: (context, initialSnapshot) {
                // If we're still checking the initial connection, show the regular app
                if (!initialSnapshot.hasData) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.noScaling,
                    ),
                    child: widget!,
                  );
                }

                return StreamBuilder<InternetConnectionStatus>(
                  stream: InternetConnectionChecker.instance.onStatusChange,
                  initialData: initialSnapshot.data == true
                      ? InternetConnectionStatus.connected
                      : InternetConnectionStatus.disconnected,
                  builder: (context, snapshot) {
                    final isConnected =
                        snapshot.data == InternetConnectionStatus.connected;

                    if (isConnected) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: TextScaler.noScaling,
                        ),
                        child: widget!,
                      );
                    } else {
                      return const NoInternetWidget();
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
