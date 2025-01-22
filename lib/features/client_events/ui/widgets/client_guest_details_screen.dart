import 'package:app/core/dimensions/dimensions.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/public_appbar.dart';
import '../../data/models/client_messages_status_response.dart';
import '../../data/models/messages_status_conditions.dart';

class ClientGuestDetailsScreen extends StatelessWidget {
  final ClientMessagesStatusDetails clientMessagesStatusDetails;

  const ClientGuestDetailsScreen({super.key, required this.clientMessagesStatusDetails});

  @override
  Widget build(BuildContext context) {
    final messagesConditions = MessagesStatusConditions();
    final invitationStatus = messagesConditions.getInvitationStatus(clientMessagesStatusDetails);
    final qrStatus = messagesConditions.getQrStatus(clientMessagesStatusDetails);
    final eventLocationStatus = messagesConditions.getEventLocationStatus(clientMessagesStatusDetails);
    final reminderMessageStatus = messagesConditions.getReminderMessageStatus(clientMessagesStatusDetails);
    final congratsMessageStatus = messagesConditions.getCongratsMessageStatus(clientMessagesStatusDetails);
    final responseStatus = messagesConditions.getResponseStatus(clientMessagesStatusDetails);
    final responseTime = messagesConditions.getResponseTime(clientMessagesStatusDetails);

    final details = [
      {'title': 'name'.tr(), 'subtitle': '${clientMessagesStatusDetails.firstName ?? ""} ${clientMessagesStatusDetails.lastName ?? ""}'},
      {
        'title': 'phone'.tr(),
        'subtitle': context.locale.languageCode == 'en'
            ? '+${clientMessagesStatusDetails.secondaryContactNo ?? ""}${clientMessagesStatusDetails.primaryContactNo ?? ""}'
            : '${clientMessagesStatusDetails.secondaryContactNo ?? ""}${clientMessagesStatusDetails.primaryContactNo ?? ""}+',
      },
      {'title': 'inv_status'.tr(), 'subtitle': invitationStatus},
      {'title': 'qr_status'.tr(), 'subtitle': qrStatus},
      {'title': 'event_location_status'.tr(), 'subtitle': eventLocationStatus},
      {'title': 'reminder_message_status'.tr(), 'subtitle': reminderMessageStatus},
      {'title': 'congrats_message_status'.tr(), 'subtitle': congratsMessageStatus},
      {'title': 'response'.tr(), 'subtitle': responseStatus},
      {'title': 'response_time'.tr(), 'subtitle': responseTime},
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: publicAppBar(
        context,
        '${clientMessagesStatusDetails.firstName ?? ""} ${clientMessagesStatusDetails.lastName ?? ""}',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(edge * 0.8),
          child: ListView.builder(
            itemCount: details.length,
            itemBuilder: (context, index) {
              final detail = details[index];
              return drawRow(detail['title']!, detail['subtitle']);
            },
          ),
        ),
      ),
    );
  }

  Widget drawRow(String title, String? subTitle) {
    return Container(
      margin: EdgeInsets.only(bottom: edge * 0.5),
      padding: EdgeInsets.all(edge*0.7),
      decoration: BoxDecoration(
        color: bgColorOverlay,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubTitleText(
            text: title,
            color: Colors.white,
            fontSize: 17,
          ),
          if (subTitle != null)
            NormalText(
              text: subTitle,
              color: Colors.white,
              align: TextAlign.start,
            ),
        ],
      ),
    );
  }
}
