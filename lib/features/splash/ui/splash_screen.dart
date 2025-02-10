import 'package:app/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../../core/routing/routes.dart';
import '../../../core/dimensions/dimensions.dart';
import '../../../core/helpers/app_utilities.dart';
import '../../../generated/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    try {
      // Initialize app utilities
      await AppUtilities().initialize();

      // Remove native splash screen
      FlutterNativeSplash.remove();

      if (!mounted) return;

      // Get expiration date from login data
      final expirationStr = AppUtilities().loginData.expiration;

      // Determine which screen to navigate to
      String nextRoute;

      if (expirationStr == null) {
        // If no expiration date exists, go to onboarding
        nextRoute = Routes.onBoardingScreen;
      } else {
        try {
          final expirationDate = DateTime.parse(expirationStr);
          final now = DateTime.now();

          // If expiration date is in the future, go to home
          // If expired or in the past, go to onboarding
          nextRoute = expirationDate.isAfter(now)
              ? Routes.homeScreen
              : Routes.onBoardingScreen;

          debugPrint('Expiration date: $expirationDate');
          debugPrint('Current date: $now');
          debugPrint('Navigating to: $nextRoute');
        } catch (e) {
          debugPrint('Error parsing expiration date: $e');
          // If there's an error parsing the date, default to onboarding
          nextRoute = Routes.onBoardingScreen;
        }
      }

      // Navigate to the determined route
      if (mounted) {
        context.pushNamedAndRemoveUntil(nextRoute, predicate: false);
      }
    } catch (e) {
      debugPrint('Error during initialization: $e');
      // In case of any error, default to onboarding
      if (mounted) {
        context.pushNamedAndRemoveUntil(Routes.onBoardingScreen,
            predicate: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff162d2b),
      body: Center(
        child: Image.asset(
          Assets.imagesAppLogo,
          width: width,
          height: height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
