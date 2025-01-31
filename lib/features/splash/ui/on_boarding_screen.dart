import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/routing/routes.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/dimensions/dimensions.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/change_language.dart';
import '../../../core/widgets/go_button.dart';
import '../../../generated/assets.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: bgColorOverlay,
        width: width.w,
        height: height.h,
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: imageContainer(),
            ),
            Expanded(
              flex: 2,
              child: buttons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageContainer() {
    return Stack(
      children: [
        Container(
          width: width.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imagesSplashBg),
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.all(edge * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubTitleText(
                text: "hello".tr(),  // Using tr() directly
                color: Colors.white,
              ),
              NormalText(
                text: tr("loginOrRegister"),  // Using tr() directly
                color: Colors.white,
              )
            ],
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 16, right: 24),
              child: LocaleDropdown(
                onLanguageChanged: () {
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buttons() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: edge,vertical: edge*0.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GoButton(
            titleKey: tr("login"),  // Using tr() directly
            fun: () {
              context.pushNamed(Routes.loginScreen);
            },
            btColor: primaryColor,
            textColor: Colors.white,
            fontSize: 18,
            gradient: true,
          ),
          SizedBox(
            height: edge * 0.7,
          ),
          GoButton(
            titleKey: tr("register"),  // Using tr() directly
            fun: () {
              context.pushNamed(Routes.registerScreen);
            },
            btColor: Colors.white,
            fontSize: 18,
          ),
          SizedBox(
            height: edge * 0.5,
          ),
        ],
      ),
    );
  }
}