import 'package:app/core/helpers/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/dimensions/dimensions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../data/models/gatekeeper_events_response.dart';

class ScanDetailsHeader extends StatelessWidget {
  final EventsList? event;

  const ScanDetailsHeader({super.key, required this.event});

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
              children: [
                eventCodeAndTitle(),
                SizedBox(height: edge * 0.5),
                eventLocation(context),
              ],
            ),
          ),
          eventStatistics(),
        ],
      ),
    );
  }

  Widget eventStatistics() {
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

  String getPending(EventsList event) {
    String pending = "";
    int allocated = event.totalAllocated ?? 0;
    int scanned = event.scanned ?? 0;
    pending = (allocated - scanned).toString();
    return pending;
  }

  Widget eventLocation(BuildContext context) {
    return ElevatedButton(
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
                text: event?.systemEventTitle ?? "",
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
}
