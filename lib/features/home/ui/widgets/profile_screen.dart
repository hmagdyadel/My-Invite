import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/dimensions/dimensions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../data/models/profile_response.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_states.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _profileAppBar(context),
      body: BlocBuilder<HomeCubit, HomeStates>(
        buildWhen: (previous, current) => previous != current,
        bloc: context.read<HomeCubit>()..getProfileData(),
        builder: (context, current) {
          return current.when(
            error: (error) => _buildErrorState(context, error),
            emptyInput: () => _buildEmptyState(context),
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CupertinoActivityIndicator(
                color: Colors.white,
                radius: 30,
              ),
            ),
            success: (response) => _buildSuccessState(response),
          );
        },
      ),
    );
  }

  AppBar _profileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      title: SubTitleText(
        text: 'profile'.tr(),
        color: Colors.white,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NormalText(
            text: '${"unexpected_error".tr()}:',
            color: Colors.redAccent,
          ),
          ElevatedButton(
            onPressed: () => context.read<HomeCubit>().getProfileData(),
            child: NormalText(
              text: 'Retry'.tr(),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: NormalText(
        text: 'emptyInput'.tr(),
        color: Colors.grey,
      ),
    );
  }

  Widget _buildSuccessState(ProfileResponse response) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(edge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: bgColorOverlay),
          SizedBox(height: edge),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SubTitleText(
                text: '${response.firstName} ${response.lastName}',
                color: Colors.white,
                fontSize: 20,
              ),
            ],
          ),
          SizedBox(height: edge),
          if (response.createdOn != null) ...[
            NormalText(
              text: 'member_since'.tr(),
              color: Colors.white.withAlpha(150),
            ),
            NormalText(
              text: _getDateInWords(response.createdOn ?? ""),
              color: Colors.white,
            ),
            SizedBox(height: edge),
          ],
          _buildInfoSection(response),
        ],
      ),
    );
  }

  Widget _buildInfoSection(ProfileResponse profile) {
    String address = profile.address ?? '';
    List<String> addressParts = address.split(" | ");
    String country = addressParts.isNotEmpty ? addressParts[0] : '';
    String city = addressParts.length > 1 ? addressParts[1] : '';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColorOverlay,
      ),
      padding: EdgeInsets.all(edge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('username'.tr(), profile.userName),
          _infoRow('email'.tr(), profile.email),
          _infoRow('phone'.tr(), profile.primaryContactNo),
          _infoRow('country'.tr(), country),
          _infoRow('city'.tr(), city),
          _infoRow(
            'gender'.tr(),
            profile.gender?.toLowerCase() == 'm' ? 'male'.tr() : 'female'.tr(),
            showDivider: false, // Disable divider for the last item
          ),
        ],
      ),
    );
  }


  Widget _infoRow(String label, String? value, {bool showDivider = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          text: label,
          color: Colors.white.withAlpha(170),
          fontSize: 12,
        ),
        NormalText(
          text: value ?? '-',
          color: Colors.white,
          fontSize: 16,
        ),
        if (showDivider)
          Divider(
            height: edge,
            color: bgColor.withAlpha(128),
          ),
      ],
    );
  }


  String _getDateInWords(String date) {
    List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    DateTime dt = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}