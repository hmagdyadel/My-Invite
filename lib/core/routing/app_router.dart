import 'package:app/core/routing/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../features/login/ui/login_screen.dart';
import '../../features/register/ui/register_screen.dart';
import '../../features/splash/on_boarding_screen.dart';
import '../../features/splash/splash_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    // final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.splashScreen:
        return _buildRoute(const SplashScreen());

      case Routes.loginScreen:
        return _buildRoute(const LoginScreen());

      case Routes.registerScreen:
        return _buildRoute(
          const RegisterScreen(),
        );
      case Routes.onBoardingScreen:
        return _buildRoute(
          const OnBoardingScreen(),
        );
      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  Route _buildRoute(Widget page, {bool useCupertino = false}) {
    if (useCupertino || TargetPlatform.iOS == defaultTargetPlatform) {
      return CupertinoPageRoute(builder: (_) => page);
    } else {
      return MaterialPageRoute(builder: (_) => page);
    }
  }
}
