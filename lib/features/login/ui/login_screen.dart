import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/routing/routes.dart';
import 'package:app/core/services/audio_service.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/go_button.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/dimensions/dimensions.dart';
import '../../../core/widgets/loaders.dart';
import '../../../core/widgets/text_field_with_icon.dart';
import '../logic/login_cubit.dart';
import '../logic/login_states.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(gradient: gradient1),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
          body: Stack(
            children: [
              // Main content
              Positioned(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titles(),
                    loginInputTexts(context),
                  ],
                ),
              ),
              // Login button at the bottom
              Positioned(
                bottom: edge * 3, // Add some padding from the bottom
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: edge * 1.5),
                  child: GoButton(
                    fun: () {
                      context.read<LoginCubit>().login();
                    },
                    titleKey: "login_sm".tr(),
                    btColor: primaryColor,
                    textColor: Colors.white,
                    gradient: true,
                    fontSize: 18,
                  ),
                ),
              ),
              BlocListener<LoginCubit, LoginStates>(
                listenWhen: (previous, current) => previous != current,
                listener: (context, current) {
                  if (current is Loading) {
                    animatedLoaderWithTitle(context: context, title: "logging_in".tr());
                  } else if (current is Error) {
                    popDialog(context);
                    context.showErrorToast(current.message);
                  } else if (current is Success) {
                    popDialog(context);
                    AudioService().playAudio(
                        src: 'sounds/audSuccess.mp3',
                        onComplete: () {
                          context.pushNamedAndRemoveUntil(Routes.homeScreen,
                              predicate: false);
                        });
                  } else if (current is EmptyInput) {
                      popDialog(context);
                    context.showErrorToast('enter_required_fields'.tr());
                  }
                },
                child: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded loginInputTexts(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(edge * 1.5),
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(curvyRadius * 1.5),
            topRight: Radius.circular(curvyRadius * 1.5),
          ),
        ),
        child: loginInputsData(context),
      ),
    );
  }

  Column loginInputsData(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SubTitleText(text: "username".tr(), color: Colors.white, fontSize: 16),
        SizedBox(height: edge * 0.3),
        textFieldWithIcon(
            controller: context.read<LoginCubit>().param,
            icon: Icon(
              Icons.email_outlined,
              color: Colors.white,
            ),
            hint: "username_hint".tr()),
        SizedBox(height: edge),
        SubTitleText(text: "password".tr(), color: Colors.white, fontSize: 16),
        SizedBox(height: edge * 0.3),
        textFieldWithIcon(
          controller: context.read<LoginCubit>().password,
          obscureText: hidePassword,
          suffix: IconButton(
            icon: Icon(
              hidePassword ? Icons.visibility : Icons.visibility_off_rounded,
              color: hidePassword ? Colors.white : primaryColor,
            ),
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
          ),
          icon: Icon(
            Icons.password,
            color: Colors.white,
          ),
          hint: "password_hint".tr(),
        ),
        SizedBox(height: edge * 0.5),
      ],
    );
  }

  Widget titles() {
    return Container(
      width: width.w,
      padding: EdgeInsets.all(edge * 1.5),
      decoration: const BoxDecoration(gradient: gradient1),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubTitleText(
              text: "login_sm".tr(),
              color: Colors.white,
              fontSize: 32,
            ),
            NormalText(
              text: "login_dt".tr(),
              color: Colors.white,
              fontSize: 16,
              align: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
