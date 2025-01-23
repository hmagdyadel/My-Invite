import 'package:app/core/dimensions/dimensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theming/colors.dart';
import '../../../../../core/widgets/normal_text.dart';
import '../../../../../core/widgets/public_appbar.dart';
import '../../../../../core/widgets/subtitle_text.dart';
import '../../../data/models/client_confirmation_service_response.dart';
import '../../../logic/client_statistics_cubit.dart';
import '../../../logic/client_statistics_states.dart';

class ClientConfirmationServicesScreen extends StatelessWidget {
  final String eventId;

  const ClientConfirmationServicesScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: publicAppBar(context, "confirmation_service".tr()),
      body: BlocBuilder<ClientStatisticsCubit, ClientStatisticsStates>(
        buildWhen: (previous, current) => current != previous,
        bloc: context.read<ClientStatisticsCubit>()..getClientConfirmationService(eventId),
        builder: (context, current) {
          return current.when(
            initial: () => const SizedBox.shrink(),
            emptyInput: () => _buildCenteredMessage("no_available_events".tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () => const Center(child: CupertinoActivityIndicator(color: Colors.white)),
            successFetchData: (success) {
              final ClientConfirmationServiceResponse events = success;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        _buildItemRow("type".tr(), "number".tr(),isHeader: false),
                        _buildItemRow("total_guests".tr(), events.totalGuestsNumber.toString()),
                        _buildItemRow("total_accepted_guests".tr(), events.acceptedGuestsNumber.toString()),
                        _buildItemRow("total_declined_guests".tr(), events.declienedGuestsNumber.toString()),
                        _buildItemRow("total_not_answered_guests".tr(), events.noAnswerGuestsNumber.toString()),
                        _buildItemRow("total_failed_guests".tr(), events.failedGuestsNumber.toString()),
                        _buildItemRow("total_not_sent_guests".tr(), events.notSentGuestsNumber.toString()),
                        _buildItemRow("total_attended_guests".tr(), events.attendedGuestsNumber.toString()),
                      ],
                    ),
                  ),
                ],
              );
            },
            success: (success, loading) => Container(),
          );
        },
      ),
    );
  }

  Widget _buildItemRow(String type, String number,{bool isHeader=true}) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: edge, vertical: edge),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: edge * 0.5),
      decoration: BoxDecoration(color: navBarBackground.withAlpha(128), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          _buildRowItem(type, flex: 3),
          _buildRowItem(number),
          if(isHeader)
            Icon(
              Icons.chevron_right,
              color: whiteTextColor,
            )else
            Icon(
              Icons.chevron_right,
              color: Colors.transparent,
            )
        ],
      ),
    );
  }

  Expanded _buildRowItem(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: NormalText(
        text: text,
        color: whiteTextColor,
        align: TextAlign.start,
      ),
    );
  }

  Widget _buildTableHeader(String type, String number, {Color backgroundColor = bgColor}) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          _buildHeaderCell(type, flex: 2),
          _buildHeaderCell(number),
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
        align: TextAlign.start,
      ),
    );
  }

  Widget _buildCenteredMessage(String message) {
    return Center(
      child: SubTitleText(
        text: message,
        color: Colors.white,
        align: TextAlign.center,
      ),
    );
  }
}
