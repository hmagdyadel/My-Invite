import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/public_appbar.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions.dart';
import '../../../../core/theming/colors.dart';

class EventInstructionsScreen extends StatelessWidget {
  const EventInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: publicAppBar(context, 'event_instructions'.tr()),
      body: ListView(
        padding: EdgeInsets.all(edge * 1.5),
        children: [
          // Heading
          SubTitleText(
            text: 'event_instructions_heading'.tr(),
            color: Colors.white,
            align: TextAlign.center,
            fontSize: titleFontSize,
          ),
          SizedBox(height: edge),

          // Intro Paragraph
          NormalText(
            text: 'event_instructions_para1'.tr(),
            fontSize: bodyFontSize,
            color: Colors.white,
            align: TextAlign.start,
          ),
          SizedBox(height: edge),

          // Instructions List
          ..._buildSteps(),

          // Notes Section
          SubTitleText(
            text: 'event_instructions_notes'.tr(),
            fontSize: titleFontSize,
            color: Colors.white,
            align: TextAlign.start,
          ),
          SizedBox(height: edge),
          _buildBullet('*', 'event_instructions_note1'.tr()),
          SizedBox(height: bulletSpacing),
          _buildBullet('*', 'event_instructions_note2'.tr()),
          SizedBox(height: edge),

          // End Text
          SubTitleText(
            text: 'event_instructions_end'.tr(),
            color: Colors.white,
            align: TextAlign.start,
            fontSize: titleFontSize + 2,
          ),
        ],
      ),
    );
  }

  // Generates a list of steps dynamically
  List<Widget> _buildSteps() {
    const stepCount = 6; // Total number of steps
    return List<Widget>.generate(stepCount, (index) {
      final stepKey = 'event_instructions_step_${index + 1}'.tr();
      return Padding(
        padding: EdgeInsets.symmetric(vertical: bulletSpacing / 2),
        child: _buildBullet('${index + 1}', stepKey),
      );
    });
  }

  // A reusable widget for numbered or bulleted items
  Widget _buildBullet(String num, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: NormalText(
            text: num,
            color: Colors.white,
            fontSize: bodyFontSize,
          ),
        ),
        SizedBox(width: edge),
        Expanded(
          child: NormalText(
            text: text,
            color: Colors.white,
            fontSize: bodyFontSize,
            align: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
