import 'package:app/core/dimensions/dimensions.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theming/colors.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient1),
      padding:  EdgeInsets.all(edge),
      child: Column(
        children: [
          SizedBox(height: 150),
          Icon(
            Icons.wifi_off,
            size: 200,
            color: Colors.white,
          ),
          SubTitleText(
            text: 'no_internet'.tr(),
            color: Colors.white,
            fontSize: 16,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
