import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/public_methods.dart';
import '../../../../core/dimensions/dimensions.dart';
import '../../../../core/theming/colors.dart';
import '../../data/models/event_details_response.dart';

class EventDetailsItem extends StatelessWidget {
  final EventDetails eventDetails;

  const EventDetailsItem({super.key, required this.eventDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(edge * 0.5),
      margin: EdgeInsets.fromLTRB(edge, edge, edge, 0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: edge * 0.5,
        children: [
          nameAndTime(),
          scanStatus(),
          NormalText(
            text: "${'no_of_members'.tr()}: ${eventDetails.noOfMembers}",
            color: Colors.white,
            fontSize: 16,
            align: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget scanStatus() {
    return Row(
      children: [
        responseCode(eventDetails.responseCode ?? ""),
        Expanded(
          child: NormalText(
            text: eventDetails.response?.contains('Maximum') == true
                ? "scanned_before".tr()
                : eventDetails.response ?? "",
            color: Colors.white,
            fontSize: 16,
            align: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget nameAndTime() {
    return Row(
      children: [
        Expanded(
          child: SubTitleText(
            text: eventDetails.guestFullName ?? "",
            color: Colors.white,
            fontSize: 16,
            align: TextAlign.start,
          ),
        ),
        NormalText(
          text: getDateAndTime(eventDetails.scannedOn ?? ""),
          color: Colors.white,
          fontSize: 14,
          align: TextAlign.end,
        ),
      ],
    );
  }

  Widget responseCode(String responseCode) {
    Color clr = Colors.red;
    IconData icon = Icons.cancel;
    String text = "declined".tr();

    if (responseCode.toLowerCase() == "allowed") {
      clr = Colors.green;
      icon = Icons.check_circle;
      text = "allowed".tr();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        NormalText(
          text: text,
          fontSize: 16,
          color: clr,
          align: TextAlign.start,
        ),
        const SizedBox(
          width: 5,
        ),
        Icon(
          icon,
          color: clr,
          size: 18,
        ),
      ],
    );
  }
}

