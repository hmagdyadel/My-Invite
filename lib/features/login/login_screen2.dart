import 'package:app/core/dimensions/dimensions.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/helpers/app_utilities.dart';
import '../../core/routing/routes.dart';
import '../../core/services/audio_service.dart';
import '../../core/widgets/go_button.dart';
import '../../core/widgets/loaders.dart';
import '../../core/widgets/normal_text.dart';
import '../../core/widgets/subtitle_text.dart';
import '../../core/widgets/text_field_with_icon.dart';
import 'logic/login_cubit.dart';
import 'logic/login_states.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final loginCubit = context.read<LoginCubit>();
        loginCubit.param.text = AppUtilities().username;
        loginCubit.password.text = AppUtilities().password;
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    // Force a runtime error
    // throw throwException("Forced Runtime Error for Testing!");
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: edge),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: edge, vertical: edge * 2),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () {
                      context.pushNamedAndRemoveUntil(Routes.onBoardingScreen, predicate: false);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      radius: 20,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: primaryColor,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildTitles(),
            // Remaining screen with bgColor
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: EdgeInsets.all(edge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: edge),
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
                        SizedBox(height: edge * 2),
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
                          child: const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Bottom navigation bar with login button
        bottomNavigationBar: Container(
          color: bgColor,
          padding: EdgeInsets.symmetric(horizontal: edge, vertical: edge * 2),
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
    );
  }

  Widget buildTitles() {
    return Padding(
      padding: EdgeInsets.all(edge),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        SizedBox(height: edge),
      ]),
    );
  }
}
