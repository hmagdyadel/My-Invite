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
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed
    await AppUtilities().initialize();

    // After initialization, remove the native splash screen
    FlutterNativeSplash.remove();

    // Navigate to the appropriate screen
    if (mounted) {
      final nextRoute = AppUtilities().username.isEmpty
          ? Routes.onBoardingScreen
          : Routes.homeScreen;

      context.pushReplacementNamed(nextRoute);
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