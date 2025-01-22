import 'package:app/core/widgets/normal_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/public_methods.dart';
import '../../../../core/dimensions/dimensions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../data/models/client_event_response.dart';

class ClientEventItem extends StatelessWidget {
  final ClientEventDetails? event;

  const ClientEventItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(edge, edge, edge, 0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: edge * 0.5,
        children: [
          Padding(
            padding: EdgeInsets.all(edge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                eventCodeAndTitle(),
                NormalText(
                  text: event?.eventVenue ?? "",
                  color: Colors.white,
                  fontSize: 16,
                ),
              ],
            ),
          ),
          eventDateAndTime(context),
        ],
      ),
    );
  }

  Column eventCodeAndTitle() {
    String eventId = "";
    String targetId = "E000000";

    String idString = event?.id.toString() ?? "";
    if (idString.length >= 6) {
      //6 zeros
      eventId = 'E$idString';
    } else {
      int length = idString.length;
      targetId = targetId.substring(0, 7 - length);
      eventId = '$targetId$idString';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: edge * 0.5,
      children: [
        SubTitleText(
          text: eventId,
          color: Colors.white,
          fontSize: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SubTitleText(
                text: event?.eventTitle ?? "",
                color: Colors.white,
                fontSize: 16,
                align: TextAlign.start,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget eventDateAndTime(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(edge),
      decoration: BoxDecoration(
        color: navBarBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: edge * 0.5,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NormalText(text: 'start_time'.tr(), color: Colors.white,align: TextAlign.center,),
              NormalText(text: 'end_time'.tr(), color: Colors.white,align: TextAlign.center,),
            ],
          ),
          Row(
            children: [
              NormalText(text: getDateInWords(event?.eventFrom ?? ""), color: Colors.white),
              Expanded(
                child: Icon(
                  Icons.arrow_right_alt,
                  color: Colors.white,
                ),
              ),
              NormalText(text: getDateInWords(event?.eventTo ?? ""), color: Colors.white),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.blue,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  NormalText(text: getTimeInAMPM(event?.eventFrom ?? ""), color: Colors.white),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.red,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  NormalText(text: getTimeInAMPM(event?.eventFrom ?? ""), color: Colors.white),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
