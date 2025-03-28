import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/theming/colors.dart';
import '../../../../../core/widgets/normal_text.dart';
import '../../../../../core/widgets/subtitle_text.dart';
import '../../../data/models/client_messages_statistics_response.dart';

class MessagesStatisticsTable extends StatelessWidget {
  final ClientMessagesStatisticsDetails details;

  const MessagesStatisticsTable({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTableHeader(),
        ..._buildTableRows(),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: bgColorOverlay,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          _buildHeaderCell(
            "type".tr(),
          ),
          _buildHeaderCell("number".tr()),
        ],
      ),
    );
  }

  Expanded _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: NormalText(
        text: text,
        color: Colors.white.withAlpha(180),
        align: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildTableRows() {
    final rows = [
      {"label": "read_number".tr(), "value": details.readNumber},
      {"label": "delivered_number".tr(), "value": details.deliverdNumber},
      {"label": "sent_number".tr(), "value": details.sentNumber},
      {"label": "failed_number".tr(), "value": details.failedNumber},
      {"label": "not_sent_number".tr(), "value": details.notSentNumber},
    ];

    return rows.map((row) => _buildTableRow(row['label'] as String, row['value'] as int)).toList();
  }

  Widget _buildTableRow(String label, int? value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: bgColorOverlay)),
      ),
      child: Row(
        children: [
          Expanded(
            child: NormalText(
              text: label,
              color: Colors.white,
              fontSize: 14,
              align: TextAlign.center,
            ),
          ),
          Expanded(
            child: SubTitleText(
              text: value?.toString() ?? '0',
              color: Colors.white,
              fontSize: 16,
              align: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
