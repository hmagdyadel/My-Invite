import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/dimensions/dimensions.dart';
import '../../core/theming/colors.dart';
import '../../core/widgets/change_language.dart';
import '../../generated/assets.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: bgColorOverlay,
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageContainer(),
            buttons(),
          ],
        ),
      ),
    );
  }

  Widget imageContainer() {
    return Stack(
      children: [
        Container(
          width: width,
          height: height * 0.7,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Assets.imagesSplashBg),
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter)),
          padding: EdgeInsets.all(edge * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubTitleText(
                text: "welcome".tr(),
                color: Colors.white,
              ),
              NormalText(
                text: "loginOrRegister".tr(),
                color: Colors.white,
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          alignment: Alignment.topRight,
          child: const LocaleDropdown(),
        ),
      ],
    );
  }

  Widget buttons() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      padding:  EdgeInsets.all(edge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // GoButton(
          //     onTap: () {
          //       Get.to(() => const LoginScreen());
          //     },
          //     title: "login".tr),
          // const SizedBox(
          //   height: 6,
          // ),
          // coloredButton(
          //     bgColor: Colors.white,
          //     textColor: bgColorOverlay,
          //     onTap: () {
          //       Get.to(() => const RegisterScreen());
          //     },
          //     title: "register".tr),
        ],
      ),
    );
  }
}
