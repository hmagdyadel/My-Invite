import 'package:app/core/helpers/app_utilities.dart';
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
  void initState() {
    // Pre-fill credentials if available
    context.read<LoginCubit>().param.text = AppUtilities().username;
    context.read<LoginCubit>().password.text = AppUtilities().password;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return

        GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: width.w,
          height: height.h,
          // Add a fallback color in case gradient fails to render
          //
          decoration: const BoxDecoration(
            color: primaryColor,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, secondaryColor],
            ),
          ),
          child: Scaffold(
            // Use transparent background to let the container gradient show through
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0, // Reduce shadow
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              leading: GestureDetector(
                onTap: () {
                  context.pushNamedAndRemoveUntil(Routes.onBoardingScreen, predicate: false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade100,
                    radius: 15,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: primaryColor,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titles(),
                Expanded(
                  child: Container(
                    // Add a fallback color in case the decoration fails

                    decoration: const BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(curvyRadius * 1.5),
                        topRight: Radius.circular(curvyRadius * 1.5),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Scrollable content area
                        SingleChildScrollView(
                          padding: EdgeInsets.all(edge * 1.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              loginInputsData(context),
                              // Add extra space for button
                              SizedBox(height: edge * 7),
                            ],
                          ),
                        ),
                        // Fixed bottom button
                        Positioned(
                          bottom: edge * 3,
                          left: edge * 1.5,
                          right: edge * 1.5,
                          child: GoButton(
                            fun: () {
                              context.read<LoginCubit>().login();
                            },
                            titleKey: "login_sm".tr(),
                            btColor: primaryColor, // Fallback if gradient fails
                            textColor: Colors.white,
                            gradient: true,
                            fontSize: 18,
                          ),
                        ),
                        // BlocListener moved to the end of the stack to ensure it's registered properly
                        BlocConsumer<LoginCubit, LoginStates>(
                          listenWhen: (previous, current) => previous != current,
                          listener: (context, current) {
                            if (current is Loading) {
                              animatedLoaderWithTitle(context: context, title: "logging_in".tr());
                            } else if (current is Error) {
                              popDialog(context);
                              context.showErrorToast(current.message);
                            } else if (current is Success) {
                              popDialog(context);
                              context.pushNamedAndRemoveUntil(Routes.homeScreen, predicate: false);
                              AudioService().playAudio(
                                  src: 'sounds/audSuccess.mp3',
                                  onComplete: () {
                                    debugPrint('audio played');
                                  });
                            } else if (current is EmptyInput) {
                              popDialog(context);
                              context.showErrorToast('enter_required_fields'.tr());
                            }
                          },
                          // Use BlocConsumer instead of BlocListener to handle UI updates
                          builder: (context, state) {
                            // If we're explicitly in a loading state, we could show a small indicator
                            // though the dialog is handling this too
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      //;


  }

  Widget loginInputsData(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SubTitleText(text: "username".tr(), color: Colors.white, fontSize: 16),
        SizedBox(height: edge * 0.3),
        textFieldWithIcon(
            controller: context.read<LoginCubit>().param,
            icon: const Icon(
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
          icon: const Icon(
            Icons.password,
            color: Colors.white,
          ),
          hint: "password_hint".tr(),
        ),
      ],
    );
  }

  Widget titles() {
    return Container(
      width: width.w,
      padding: EdgeInsets.all(edge * 1.5),
      // Add fallback color and explicit gradient parameters

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor, secondaryColor],
        ),
      ),
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