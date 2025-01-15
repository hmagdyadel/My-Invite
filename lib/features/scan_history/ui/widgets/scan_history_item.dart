import 'package:app/core/dimensions/dimensions.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';

import '../../data/models/gatekeeper_events_response.dart';

class ScanHistoryItem extends StatelessWidget {
  final EventsList? event;

  const ScanHistoryItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(edge, edge, edge, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubTitleText(
            text: event?.eventCode ?? "",
            color: Colors.white,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}
