import 'package:app/core/dimensions/dimensions.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/public_methods.dart';
import '../../../../core/theming/colors.dart';
import '../../data/models/gatekeeper_events_response.dart';

class ScanHistoryItem extends StatelessWidget {
  final EventsList? event;

  const ScanHistoryItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(edge, edge, edge, 0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: edge * 0.5,
        children: [
          Padding(
            padding: EdgeInsets.all(edge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: edge * 0.5,
              children: [
                eventCodeAndTitle(),
                eventLocation(context),
                greyDivider(),
                eventDateAndTime(context),
                contactDetails(),
              ],
            ),
          ),
          eventStatistics()
        ],
      ),
    );
  }

  Container eventStatistics() {
    return Container(
          padding: EdgeInsets.all(edge),
          decoration: BoxDecoration(
            color: navBarBackground,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NormalText(
                    text: 'scanned'.tr(),
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  NormalText(
                    text: event?.scanned.toString() ?? "0",
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NormalText(
                    text: 'allocated'.tr(),
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  NormalText(
                    text: event?.totalAllocated.toString() ?? "0",
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NormalText(
                    text: 'pending'.tr(),
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  NormalText(
                    text: getPending(event!),
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ],
              ),
            ],
          ),
        );
  }

  Column contactDetails() {
    return Column(
                children: [
                  Row(
                    children: [
                      NormalText(text: "contact".tr(), color: Colors.white),
                      SizedBox(width: edge * 0.6),
                      Expanded(child: Divider())
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: NormalText(
                          text: event?.contactName ?? "",
                          color: Colors.white,
                          align: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: NormalText(
                          text: event?.contactPhone ?? "",
                          color: Colors.white,
                          align: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ],
              );
  }

  Column eventDateAndTime(BuildContext context) {
    return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: edge * 0.5,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NormalText(text: 'start_time'.tr(), color: Colors.white),
                      NormalText(text: 'end_time'.tr(), color: Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      NormalText(
                          text: getDateInWords(event?.eventFrom ?? ""),
                          color: Colors.white),
                      Expanded(
                        child: Transform.rotate(
                          angle: context.locale.languageCode == 'en' ? 0 : 3.14,
                          child: Icon(
                            Icons.arrow_right_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      NormalText(
                          text: getDateInWords(event?.eventTo ?? ""),
                          color: Colors.white),
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
                          NormalText(
                              text: event?.attendanceTime ?? "",
                              color: Colors.white),
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
                          NormalText(
                              text: event?.leaveTime ?? "", color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ],
              );
  }

  Divider greyDivider() {
    return Divider(
                color: Colors.grey.shade400,
              );
  }

  ElevatedButton eventLocation(BuildContext context) {
    return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: navBarBackground),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
              );
  }

  Column eventCodeAndTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: edge * 0.5,
      children: [
        SubTitleText(
          text: event?.eventCode ?? "",
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

  String getPending(EventsList event) {
    String pending = "";
    int allocated = event.totalAllocated ?? 0;
    int scanned = event.scanned ?? 0;
    pending = (allocated - scanned).toString();
    return pending;
  }
}
