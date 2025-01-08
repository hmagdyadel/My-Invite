import 'package:app/core/di/dependency_injection.dart';
import 'package:app/core/routing/routes.dart';
import 'package:app/features/home/ui/home_screen.dart';
import 'package:app/features/login/logic/login_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );

      case Routes.registerScreen:
        return _buildRoute(
          const RegisterScreen(),
        );
      case Routes.onBoardingScreen:
        return _buildRoute(
          const OnBoardingScreen(),
        );
      case Routes.homeScreen:
        return _buildRoute(
          const HomeScreen(),
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
