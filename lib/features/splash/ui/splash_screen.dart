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
    await AppUtilities().initialize();

    FlutterNativeSplash.remove();

    if (mounted) {
      try {
        final expirationStr = AppUtilities().loginData.expiration;

        if (expirationStr != null) {
          DateTime expirationDate = DateTime.parse(expirationStr);

          final nextRoute = expirationDate.isAfter(DateTime.now())
              ? Routes.onBoardingScreen // If expiration is in the future, go to onboarding
              : Routes.homeScreen; // If expired, go to home screen

          context.pushReplacementNamed(nextRoute);
        } else {
          context.pushReplacementNamed(Routes.onBoardingScreen); // Or whatever is appropriate
        }
      } catch (e) {
        debugPrint("Error parsing expiration date: $e");
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
