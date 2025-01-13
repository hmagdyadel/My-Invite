import 'package:app/core/dimensions/dimensions.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:app/features/home/logic/home_cubit.dart';
import 'package:app/features/home/logic/home_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/colors.dart';
import '../../data/models/profile_response.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: profileAppBar(context),
      body: BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (previous, current) => previous != current,
          bloc: context.read<HomeCubit>()..getProfileData(),
          builder: (context, current) {
            return current.when(
              error: (error) => Center(child: NormalText(text: error)),
              emptyInput: () => Center(
                child: NormalText(
                  text: 'emptyInput'.tr(),
                ),
              ),
              initial: () => SizedBox.shrink(),
              loading: () => const Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 30,
                ),
              ),
              success: (response) => Padding(
                padding: EdgeInsets.all(edge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: edge,
                    ),
                    const Divider(
                      height: 0,
                      color: bgColorOverlay,
                    ),
                    SizedBox(
                      height: edge,
                    ),
                    SubTitleText(
                      text: '${response.firstName} ${response.lastName}',
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: edge,
                    ),
                    if (response.createdOn != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NormalText(
                            text: "member_since".tr(),
                            color: Colors.white.withAlpha(140),
                            align: TextAlign.center,
                          ),
                          NormalText(
                            text: getDateInWords(response.createdOn ?? ""),
                            color: Colors.white.withAlpha(140),
                            align: TextAlign.center,
                          ),
                          SizedBox(
                            height: edge,
                          ),
                        ],
                      ),
                    otherInfo(response),
                  ],
                ),
              ),
            );
          }),
    );
  }

  String getDateInWords(String date) {
    List<String> months = ['Jan', 'Feb', 'March', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
    var inputDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    DateTime dt = inputDateFormat.parse(date, true).toLocal();

    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  AppBar profileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      title: SubTitleText(
        text: 'profile'.tr(),
        color: Colors.white,
      ),
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          context.pop();
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            radius: 15,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: secondaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget otherInfo(ProfileResponse profile) {
    String address = profile.address!;
    String city = address;
    String country = address;

    List<String> addressArr = address.split(" | ");
    if (addressArr.length > 1) {
      city = addressArr[1];
      country = addressArr[0];
    }

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: bgColorOverlay),
      padding: EdgeInsets.all(edge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalText(
            text: "username".tr(),
            color: Colors.white,
            fontSize: 12,
          ),
          NormalText(
            text: profile.userName ?? "",
            color: Colors.white,
            fontSize: 16,
          ),
          Divider(
            height: edge,
            color: bgColor,
          ),
          NormalText(
            text: "email".tr(),
            color: Colors.white,
            fontSize: 12,
          ),
          NormalText(
            text: profile.email ?? "",
            color: Colors.white,
            fontSize: 16,
          ),
          Divider(
            height: edge,
            color: bgColor,
          ),
          NormalText(
            text: "phone".tr(),
            color: Colors.white,
            fontSize: 12,
          ),
          NormalText(
            text: profile.primaryContactNo ?? "",
            color: Colors.white,
            fontSize: 16,
          ),
          Divider(
            height: edge,
            color: bgColor,
          ),
          NormalText(
            text: "country".tr(),
            color: Colors.white,
            fontSize: 12,
          ),
          NormalText(
            text: country,
            color: Colors.white,
            fontSize: 16,
          ),
          Divider(
            height: edge,
            color: bgColor,
          ),
          NormalText(
            text: "city".tr(),
            color: Colors.white,
            fontSize: 12,
          ),
          NormalText(
            text: city,
            color: Colors.white,
            fontSize: 16,
          ),
          Divider(
            height: edge,
            color: bgColor,
          ),
          NormalText(
            text: "gender".tr(),
            color: Colors.white,
            fontSize: 12,
          ),
          NormalText(
            text: profile.gender == "m" || profile.gender == "M" || profile.gender == null ? "male".tr() : 'female'.tr(),
            color: Colors.white,
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}
