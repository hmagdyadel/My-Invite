import 'package:app/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
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

  /// Initialization logic for the splash screen.
  void initialization() async {
    try {
      // Simulate a loading delay (e.g., for logo animation or splash duration)
      await Future.delayed(const Duration(seconds: 3));

      // Initialize app utilities (e.g., load user data, settings, etc.)
      await AppUtilities().initialize();

      if (!mounted) return;

      // Determine the next route based on the user's data
      final expirationStr = AppUtilities().loginData.expiration;
      String nextRoute;

      if (expirationStr == null) {
        // No expiration date? Navigate to onboarding screen.
        nextRoute = Routes.onBoardingScreen;
      } else {
        try {
          final expirationDate = DateTime.parse(expirationStr);
          final now = DateTime.now();

          // If expiration date is in the future, go to home screen.
          // If expired or invalid, navigate to onboarding.
          nextRoute = expirationDate.isAfter(now) ? Routes.homeScreen : Routes.onBoardingScreen;

          debugPrint('Expiration date: $expirationDate');
          debugPrint('Current date: $now');
          debugPrint('Navigating to: $nextRoute');
        } catch (e) {
          debugPrint('Error parsing expiration date: $e');
          nextRoute = Routes.onBoardingScreen;
        }
      }

      // Navigate to the determined route
      if (mounted) {
        context.pushReplacementNamed(nextRoute);
      }
    } catch (e) {
      debugPrint('Error during initialization: $e');
      if (mounted) {
        context.pushReplacementNamed(Routes.onBoardingScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff162d2b), // Splash background color
      body: Center(
        child: Image.asset(
          Assets.imagesAppLogo, // Path to your app logo
          width: width, // Adjust size as needed
          height: height, // Adjust size as needed
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
