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

  final Map<String, FocusNode> focusNodes = {
    'email': FocusNode(),
    'phone': FocusNode(),
    'password': FocusNode(),
    'confirmPassword': FocusNode(),
    'firstName': FocusNode(),
    'lastName': FocusNode(),
    'username': FocusNode(),
  };

  @override
  void initState() {
    RegExp englishOnly = RegExp(r'^[a-zA-Z0-9]+$');
    englishOnlyFilter = FilteringTextInputFormatter.allow(englishOnly);

    // Initialize focus nodes
    for (var node in focusNodes.values) {
      node.addListener(() {
        setState(() {}); // Rebuild the UI when focus changes
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    for (var node in focusNodes.values) {
      node.dispose();
    }
    super.dispose();
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

  Widget buildRegistrationForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(edge * 1.5),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(curvyRadius * 1.5),
          topRight: Radius.circular(curvyRadius * 1.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: edge,
        children: [
          buildTextFieldWithConditions(
            context,
            labelKey: "first_name",
            hintKey: "first_name_hint",
            controller: context.read<RegisterCubit>().firstNameController,
            icon: Icons.person_outline,
            focusNode: focusNodes['firstName']!,
            conditions: {
              "invalid_first_name": (text) =>
                  text.isNotEmpty &&
                  context.read<RegisterCubit>().isValidName(text),
            },
            conditionMessages: {
              "invalid_first_name": "invalid_first_name",
            },
          ),
          buildTextFieldWithConditions(
            context,
            labelKey: "last_name",
            hintKey: "last_name_hint",
            controller: context.read<RegisterCubit>().lastNameController,
            icon: Icons.person_outline,
            focusNode: focusNodes['lastName']!,
            conditions: {
              "invalid_last_name": (text) =>
                  text.isNotEmpty &&
                  context.read<RegisterCubit>().isValidName(text),
            },
            conditionMessages: {
              "invalid_last_name": "invalid_last_name",
            },
          ),
          buildTextFieldWithConditions(
            context,
            labelKey: "username",
            hintKey: "username_in_english",
            controller: context.read<RegisterCubit>().usernameController,
            icon: Icons.person_outline,
            formatter: [englishOnlyFilter],
            focusNode: focusNodes['username']!,
            conditions: {
              "username_in_english": (text) => text.isNotEmpty,
            },
            conditionMessages: {
              "username_in_english": "username_in_english",
            },
          ),
          buildTextFieldWithConditions(
            context,
            labelKey: "email",
            hintKey: "email_hint",
            controller: context.read<RegisterCubit>().emailController,
            icon: Icons.email_outlined,
            focusNode: focusNodes['email']!,
            conditions: {
              "invalid_email": (text) =>
                  text.isNotEmpty &&
                  context.read<RegisterCubit>().isValidEmail(text),
            },
            conditionMessages: {
              "invalid_email": "invalid_email",
            },
          ),
          buildTextFieldWithConditions(
            context,
            labelKey: "phone",
            hintKey: "phone_no_hint",
            controller: context.read<RegisterCubit>().phoneController,
            icon: Icons.phone,
            focusNode: focusNodes['phone']!,
            conditions: {
              "phone_number_invalid_format": (text) =>
                  text.isNotEmpty &&
                  context.read<RegisterCubit>().isValidPhoneFormat(text),
              "phone_number_too_short": (text) =>
                  text.isNotEmpty && text.length >= 6,
            },
            conditionMessages: {
              "phone_number_invalid_format": "phone_number_invalid_format",
              "phone_number_too_short": "phone_number_too_short",
            },
          ),
          buildPasswordSection(context),
          buildConfirmPasswordSection(context),
          buildAddressSection(context),
          buildGenderSection(context),
          SizedBox(height: edge * 2),
          buildRegisterButton(context),
        ],
      ),
    );
  }

  Widget buildFlexibleSpace(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //gradient: gradient1,
        color: primaryColor,
      ),
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

  Widget buildTextFieldWithConditions(
    BuildContext context, {
    required String labelKey,
    required String hintKey,
    required TextEditingController controller,
    required IconData icon,
    List<TextInputFormatter>? formatter,
    required FocusNode focusNode,
    required Map<String, bool Function(String)> conditions,
    required Map<String, String> conditionMessages,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(
          text: labelKey.tr(),
          color: Colors.white,
          fontSize: 16,
        ),
        const SizedBox(height: 8),
        textFieldWithIcon(
          controller: controller,
          formatter: formatter ?? [],
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          hint: hintKey.tr(),
          focusNode: focusNode,
        ),
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, TextEditingValue value, _) {
            final text = value.text;
            final showConditionRow = focusNode.hasFocus ||
                text.isNotEmpty; // Show row if focused or has input

            if (showConditionRow) {
              return Column(
                children: [
                  for (var entry in conditions.entries)
                    if (!entry.value(text) && text.isNotEmpty) ...[
                      // Show red row for invalid conditions
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              conditionMessages[entry.key]?.tr() ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else if (focusNode.hasFocus &&
                        text.isNotEmpty &&
                        entry.value(text)) ...[
                      // Show green row for valid conditions while focused
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${"correct".tr()}: ${conditionMessages[entry.key]?.tr()}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                ],
              );
            } else {
              return const SizedBox
                  .shrink(); // Hide all rows when not focused and valid
            }
          },
        ),
      ],
    );
  }

  Widget buildPasswordSection(BuildContext context) {
    return buildTextFieldWithConditions(
      context,
      labelKey: "password",
      hintKey: "password_hint",
      controller: context.read<RegisterCubit>().passwordController,
      icon: Icons.password,
      focusNode: focusNodes['password']!,
      conditions: {
        "password_too_short": (text) => text.isNotEmpty && text.length >= 6,
      },
      conditionMessages: {
        "password_too_short": "password_too_short",
      },
    );
  }

  Widget buildConfirmPasswordSection(BuildContext context) {
    return buildTextFieldWithConditions(
      context,
      labelKey: "confirm_password",
      hintKey: "confirm_password_hint",
      controller: context.read<RegisterCubit>().confirmPasswordController,
      icon: Icons.password,
      focusNode: focusNodes['confirmPassword']!,
      conditions: {
        "passwords_do_not_match": (text) =>
            text.isNotEmpty &&
            text == context.read<RegisterCubit>().passwordController.text,
      },
      conditionMessages: {
        "passwords_do_not_match": "passwords_do_not_match",
      },
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
        const SizedBox(height: 8),
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
        const SizedBox(height: 8),
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

  Widget buildGenderButton(BuildContext context, IconData icon,
      String genderKey, bool isMaleGender) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor:
            isMale == isMaleGender ? primaryColor : Colors.white.withAlpha(5),
      ),
      onPressed: () {
        setState(() {
          isMale = isMaleGender;
        });
      },
      child: Row(
        children: [
          Icon(
            icon,
            color: isMale == isMaleGender
                ? primaryColor
                : Colors.white.withAlpha(128),
            size: 24,
          ),
          const SizedBox(width: 4),
          NormalText(
            text: genderKey.tr(),
            color: isMale == isMaleGender
                ? primaryColor
                : Colors.white.withAlpha(128),
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
          gradient: false,
          fontSize: 18,
        ),
        BlocListener<RegisterCubit, RegisterStates>(
          listener: (context, state) {
            if (state is Loading) {
              animatedLoaderWithTitle(
                  context: context, title: "creating_account".tr());
            } else if (state is Error) {
              popDialog(context);
              context.showErrorToast(state.message);
            } else if (state is Success) {
              popDialog(context);
              dialogWithSingleAction(
                  context: context,
                  title: "pending_approval".tr(),
                  msg: 'pending_approval_msg'.tr());
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
