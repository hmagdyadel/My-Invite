import 'package:app/core/helpers/extensions.dart';
import 'package:app/features/register/logic/register_cubit.dart';
import 'package:app/features/register/logic/register_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dimensions/dimensions.dart';
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              pinned: true,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                background: buildFlexibleSpace(context),
              ),
              leading: buildBackButton(context),
            ),
            SliverToBoxAdapter(
              child: buildRegistrationForm(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFlexibleSpace(BuildContext context) {
    return Container(
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
    );
  }

  Widget buildBackButton(BuildContext context) {
    return GestureDetector(
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
    );
  }

  Widget buildRegistrationForm(BuildContext context) {
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
          buildTextFieldSection(context, "first_name", "first_name_hint", context.read<RegisterCubit>().firstNameController, Icons.person_outline),
          buildTextFieldSection(context, "last_name", "last_name_hint", context.read<RegisterCubit>().lastNameController, Icons.person_outline),
          buildTextFieldSection(context, "username", "username_in_english", context.read<RegisterCubit>().usernameController, Icons.person_outline, formatter: [englishOnlyFilter]),
          buildTextFieldSection(context, "email", "email_hint", context.read<RegisterCubit>().emailController, Icons.email_outlined),
          buildTextFieldSection(context, "phone", "phone_no_hint", context.read<RegisterCubit>().phoneController, Icons.phone),
          buildPasswordSection(context),
          buildAddressSection(context),
          buildGenderSection(context),
          SizedBox(height: edge * 2),
          buildRegisterButton(context),
        ],
      ),
    );
  }

  Widget buildTextFieldSection(BuildContext context, String labelKey, String hintKey, TextEditingController controller, IconData icon, {List<TextInputFormatter>? formatter}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(
          text: labelKey.tr(),
          color: Colors.white,
          fontSize: 16,
        ),
        SizedBox(height: edge * 0.3),
        textFieldWithIcon(
          controller: controller,
          formatter: formatter ?? [],
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          hint: hintKey.tr(),
        ),
      ],
    );
  }

  Widget buildPasswordSection(BuildContext context) {
    return buildTextFieldSection(
      context,
      "password",
      "password_hint",
      context.read<RegisterCubit>().passwordController,
      Icons.password,
      formatter: [],
    );
  }

  Widget buildAddressSection(BuildContext context) {
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
            context.read<LocationCubit>().setSelectedCountry(country);
          },
          onCityChange: (CityResponse city) {
            context.read<LocationCubit>().setSelectedCity(city);
          },
        ),
      ],
    );
  }

  Widget buildGenderSection(BuildContext context) {
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
            buildGenderButton(context, Icons.male, "male", true),
            buildGenderButton(context, Icons.female, "female", false),
          ],
        ),
      ],
    );
  }

  Widget buildGenderButton(BuildContext context, IconData icon, String genderKey, bool isMaleGender) {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: isMale == isMaleGender ? primaryColor : Colors.white.withAlpha(5)),
      onPressed: () {
        setState(() {
          isMale = isMaleGender;
        });
      },
      child: Row(
        children: [
          Icon(
            icon,
            color: isMale == isMaleGender ? primaryColor : Colors.white.withAlpha(128),
            size: 24,
          ),
          const SizedBox(width: 4),
          NormalText(
            text: genderKey.tr(),
            color: isMale == isMaleGender ? primaryColor : Colors.white.withAlpha(128),
            fontSize: 18,
          ),
        ],
      ),
    );
  }

  Widget buildRegisterButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GoButton(
          fun: () {
            if (context.read<RegisterCubit>().state is! Loading) {
              context.read<RegisterCubit>().register(
                cityId: context.read<LocationCubit>().selectedCity?.id ?? 0,
                isMale: isMale,
              );
            }
          },
          titleKey: "register_sm".tr(),
          btColor: primaryColor,
          textColor: Colors.white,
          gradient: true,
          fontSize: 18,
        ),
        BlocListener<RegisterCubit, RegisterStates>(
          listener: (context, state) {
            if (state is Loading) {
              animatedLoaderWithTitle(context: context, title: "creating_account".tr());
            } else if (state is Error) {
              popDialog(context);
              context.showErrorToast(state.message);
            } else if (state is Success) {
              popDialog(context);
              dialogWithSingleAction(context: context, title: "pending_approval".tr(), msg: 'pending_approval_msg'.tr());
            } else if (state is EmptyInput) {
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
