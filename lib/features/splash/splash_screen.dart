import 'package:app/core/dimensions/dimensions.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:app/generated/assets.dart';
import 'package:flutter/material.dart';

import '../../core/routing/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        if (mounted) {
          context.pushReplacementNamed(Routes.loginScreen);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff162d2b),
        body: Center(
            child: Image.asset(Assets.imagesAppLogo,
          width: width,
          height: height,
          fit: BoxFit.cover,
        )));
  }
}
