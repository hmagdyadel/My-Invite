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
    return Scaffold(
      backgroundColor: bgColor,
      appBar: publicAppBar(
        context,
        '${clientMessagesStatusDetails.firstName ?? ""} ${clientMessagesStatusDetails.lastName ?? ""}',
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(edge * 0.8),
        child: SingleChildScrollView(
          child: Column(
            spacing: edge * 0.3,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              drawRow('${'name'.tr()}:', '${clientMessagesStatusDetails.firstName ?? ""} ${clientMessagesStatusDetails.lastName ?? ""}'),
              drawRow(
                '${'phone'.tr()}:',
                context.locale.languageCode == 'en' ? '+${clientMessagesStatusDetails.secondaryContactNo ?? ""}${clientMessagesStatusDetails.primaryContactNo ?? ""}' : '${clientMessagesStatusDetails.secondaryContactNo ?? ""}${clientMessagesStatusDetails.primaryContactNo ?? ""}+',
              ),
              drawRow('${'inv_status'.tr()}:', MessagesStatusConditions().getInvitationStatus(clientMessagesStatusDetails)),
              drawRow('${'qr_status'.tr()}:', MessagesStatusConditions().getQrStatus(clientMessagesStatusDetails)),
              drawRow('${'event_location_status'.tr()}:', MessagesStatusConditions().getEventLocationStatus(clientMessagesStatusDetails)),
              drawRow('${'reminder_message_status'.tr()}:', MessagesStatusConditions().getReminderMessageStatus(clientMessagesStatusDetails)),
              drawRow('${'congrats_message_status'.tr()}:', MessagesStatusConditions().getCongratsMessageStatus(clientMessagesStatusDetails)),
              drawRow('${'response'.tr()}:', MessagesStatusConditions().getResponseStatus(clientMessagesStatusDetails)),
              drawRow('${'response_time'.tr()}:', MessagesStatusConditions().getResponseTime(clientMessagesStatusDetails)),
            ],
          ),
        ),
      )),
    );
  }

  Widget drawRow(String title, String? subTitle) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(edge),
      decoration: BoxDecoration(
        color: bgColorOverlay,
        borderRadius: BorderRadius.circular(12),
      ),
      child: subTitle != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubTitleText(
                  text: title,
                  color: Colors.white,
                  fontSize: 17,
                ),
                NormalText(
                  text: subTitle,
                  color: Colors.white,
                  align: TextAlign.start,
                ),
              ],
            )
          : null,
    );
  }
}
