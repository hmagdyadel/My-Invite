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
      debugPrint("Starting initialization...");
      await AppUtilities().initialize();
      debugPrint("AppUtilities initialized");

      FlutterNativeSplash.remove();
      debugPrint("Splash removed");

      if (!mounted) {
        debugPrint("Widget not mounted");
        return;
      }

      final expirationStr = AppUtilities().loginData.expiration;
      debugPrint("Expiration string: $expirationStr");

      String nextRoute;
      if (expirationStr == null) {
        nextRoute = Routes.onBoardingScreen;
        debugPrint("No expiration, going to onboarding");
      } else {
        try {
          final expirationDate = DateTime.parse(expirationStr).subtract(const Duration(hours: 10));
          final now = DateTime.now();
          nextRoute = expirationDate.isAfter(now) ? Routes.homeScreen : Routes.onBoardingScreen;
          debugPrint("Expiration: $expirationDate, Now: $now, Route: $nextRoute");
        } catch (e) {
          debugPrint("Date parsing error: $e");
          nextRoute = Routes.onBoardingScreen;
        }
      }

      debugPrint("Navigating to $nextRoute");
      if (mounted) {
        context.pushNamedAndRemoveUntil(nextRoute, predicate: false);
      }
    } catch (e) {
      debugPrint("Initialization error: $e");
      if (mounted) {
        context.pushNamedAndRemoveUntil(Routes.onBoardingScreen, predicate: false);
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
