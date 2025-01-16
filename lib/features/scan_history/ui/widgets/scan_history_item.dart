import 'package:app/core/dimensions/dimensions.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theming/colors.dart';
import '../../data/models/gatekeeper_events_response.dart';

class ScanHistoryItem extends StatelessWidget {
  final EventsList? event;

  const ScanHistoryItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Determine the text direction based on Arabic content
    final isTitleArabic = textContainsLettersInArabic(event?.eventTitle ?? "");
    final isVenueArabic = textContainsLettersInArabic(event?.eventVenue ?? "");

    return Container(
      padding: EdgeInsets.all(edge),
      margin: EdgeInsets.fromLTRB(edge, edge, edge, 0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: isTitleArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        spacing: edge * 0.5,
        children: [
          SubTitleText(
            text: event?.eventCode ?? "",
            color: Colors.white,
            fontSize: 16,
          ),
          Row(
            mainAxisAlignment: isTitleArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              SubTitleText(
                text: event?.eventTitle ?? "",
                color: Colors.white,
                fontSize: 16,
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: navBarBackground),
            onPressed: () {
              viewMap(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.map,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isVenueArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        NormalText(
                          text: event?.eventVenue ?? "",
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        NormalText(
                          text: event?.eventlocation ?? "",
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey.shade400,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NormalText(text: 'start_time'.tr(), color: Colors.white),
              NormalText(text: 'end_time'.tr(), color: Colors.white),
            ],
          )
        ],
      ),
    );
  }

  // Utility function to check for Arabic characters
  bool textContainsLettersInArabic(String text) {
    final arabicRegExp = RegExp(r'[\u0600-\u06FF]');
    return arabicRegExp.hasMatch(text);
  }

  // Function to handle map viewing
  Future viewMap(BuildContext context) async {
    if (event?.gmapCode == null) {
      context.showErrorToast("location_not_available".tr());
      return;
    }
    String googleUrl = event?.gmapCode ?? "https://maps.google.com";
    try {
      await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.platformDefault);
    } catch (e) {
      // Handle exceptions appropriately
    }
  }
}
