import 'package:app/core/helpers/extensions.dart';
import 'package:app/features/register/logic/register_cubit.dart';
import 'package:app/features/register/logic/register_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dimensions/dimensions.dart';
import '../../../core/routing/routes.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/go_button.dart';
import '../../../core/widgets/loaders.dart';
import '../../../core/widgets/normal_text.dart';
import '../../../core/widgets/subtitle_text.dart';
import '../../../core/widgets/text_field_with_icon.dart';
import '../../location/data/models/city_response.dart';
import '../../location/data/models/country_response.dart';
import '../../location/logic/location_cubit.dart';
import '../../location/ui/gate_keeper_location_selector.dart';
import '../data/models/saudi_cities.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool hidePassword = true;
  var selectedCity = cities[0];
  bool isMale = true;
  late FilteringTextInputFormatter englishOnlyFilter;
  @override
  void initState() {
    RegExp englishOnly = RegExp(r'^[a-zA-Z0-9]+$');
    englishOnlyFilter = FilteringTextInputFormatter.allow(englishOnly);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: BoxDecoration(gradient: gradient1),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                pinned: true,
                expandedHeight: 200.0,
                // Height when fully expanded
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(gradient: gradient1),
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(edge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SubTitleText(
                              text: "register_sm".tr(),
                              color: Colors.white,
                              fontSize: 32,
                            ),
                            NormalText(
                              text: "register_dt".tr(),
                              color: Colors.white,
                              fontSize: 16,
                              align: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                leading: GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade100,
                      radius: 15,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: registerPanel(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget registerPanel(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(edge * 1.5),
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(curvyRadius * 1.5),
          topRight: Radius.circular(curvyRadius * 1.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: edge,
        children: [
          firstNameSection(context),
          lastNameSection(context),
          userNameSection(context),
          emailSection(context),
          phoneSection(context),
          passwordSection(context),
          addressSection(context),
          genderSection(context),
          SizedBox(height: edge * 2),
          registerButton(context),
        ],
      ),
    );
  }

  Widget firstNameSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(
          text: "first_name".tr(),
          color: Colors.white,
          fontSize: 16,
        ),
        SizedBox(height: edge * 0.3),
        textFieldWithIcon(
          controller: context.read<RegisterCubit>().firstNameController,
          icon: Icon(
            Icons.person_outline,
            color: Colors.white,
          ),
          hint: "first_name_hint".tr(),
        ),
      ],
    );
  }

  Widget lastNameSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(
          text: "last_name".tr(),
          color: Colors.white,
          fontSize: 16,
        ),
        SizedBox(height: edge * 0.3),
        textFieldWithIcon(
          controller: context.read<RegisterCubit>().lastNameController,
          icon: Icon(
            Icons.person_outline,
            color: Colors.white,
          ),
          hint: "last_name_hint".tr(),
        ),
      ],
    );
  }

  Widget userNameSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(
          text: "username".tr(),
          color: Colors.white,
          fontSize: 16,
        ),
        SizedBox(height: edge * 0.3),
        textFieldWithIcon(
          controller: context.read<RegisterCubit>().usernameController,
          formatter: [englishOnlyFilter],
          icon: Icon(
            Icons.person_outline,
            color: Colors.white,
          ),
          hint: "username_in_english".tr(),
        ),
      ],
    );
  }

  Widget emailSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(
          text: "email".tr(),
          color: Colors.white,
          fontSize: 16,
        ),
        SizedBox(height: edge * 0.3),
        textFieldWithIcon(
          controller: context.read<RegisterCubit>().emailController,
          icon: Icon(
            Icons.email_outlined,
            color: Colors.white,
          ),
          hint: "email_hint".tr(),
        ),
      ],
    );
  }

  Widget phoneSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(
          text: "phone".tr(),
          color: Colors.white,
          fontSize: 16,
        ),
        SizedBox(height: edge * 0.3),
        textFieldWithIcon(
          controller: context.read<RegisterCubit>().phoneController,
          icon: Icon(
            Icons.phone,
            color: Colors.white,
          ),
          hint: "phone_no_hint".tr(),
        ),
      ],
    );
  }

  Widget passwordSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(
          text: "password".tr(),
          color: Colors.white,
          fontSize: 16,
        ),
        SizedBox(height: edge * 0.3),
        textFieldWithIcon(
          controller: context.read<RegisterCubit>().passwordController,
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
      ],
    );
  }

  Widget addressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(
          text: "address".tr(),
          color: Colors.white,
          fontSize: 16,
        ),
        SizedBox(height: edge * 0.3),
        GatekeeperLocationSelector(
          onCountryChange: (CountryResponse country) {
            // Handle country selection
            context.read<LocationCubit>().setSelectedCountry(country);
          },
          onCityChange: (CityResponse city) {
            // Handle city selection
            context.read<LocationCubit>().setSelectedCity(city);
          },
        ),
      ],
    );
  }

  Widget genderSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(
          text: "gender".tr(),
          color: Colors.white,
          fontSize: 16,
        ),
        SizedBox(height: edge * 0.3),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor:
                      isMale ? primaryColor : Colors.white.withAlpha(5)),
              onPressed: () {
                setState(() {
                  isMale = true;
                });
              },
              child: Row(
                children: [
                  Icon(
                    Icons.male,
                    color: isMale ? primaryColor : Colors.white.withAlpha(128),
                    size: 24,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  NormalText(
                    text: "male".tr(),
                    color: isMale ? primaryColor : Colors.white.withAlpha(128),
                    fontSize: 18,
                  ),
                ],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor:
                      !isMale ? Colors.pink : Colors.white.withAlpha(5)),
              onPressed: () {
                setState(() {
                  isMale = false;
                });
              },
              child: Row(
                children: [
                  Icon(
                    Icons.female,
                    color: isMale ? Colors.white.withAlpha(128) : Colors.pink,
                    size: 24,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  NormalText(
                    text: "female".tr(),
                    color: isMale ? Colors.white.withAlpha(128) : Colors.pink,
                    fontSize: 18,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget registerButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GoButton(
          fun: () {
            context.read<RegisterCubit>().register(

                cityId:
                    context.read<LocationCubit>().selectedCity?.id ?? 0,
                isMale: isMale);
          },
          titleKey: "register_sm".tr(),
          btColor: primaryColor,
          textColor: Colors.white,
          gradient: true,
          fontSize: 18,
        ),
        BlocListener<RegisterCubit, RegisterStates>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, current) {
            if (current is Loading) {
              animatedLoaderWithTitle(
                  context: context, title: "creating_account".tr());
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
    );
  }
}
