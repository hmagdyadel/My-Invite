import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:app/features/scan_history/ui/widgets/scan_history_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/public_appbar.dart';
import '../logic/gatekeeper_events_cubit.dart';
import '../logic/scan_history_states.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gatekeeperCubit = context.read<GatekeeperEventsCubit>();

    return Scaffold(
      backgroundColor: bgColorOverlay,
      appBar: publicAppBar(
        context,
        "scan_history".tr(),
      ),
      body: BlocBuilder<GatekeeperEventsCubit, ScanHistoryStates>(
        buildWhen: (previous, current) => previous != current,
        bloc: gatekeeperCubit..getGatekeeperEvents(),
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            emptyInput: () => _buildCenteredMessage(context, "no_available_events".tr()),
            error: (error) => _buildCenteredMessage(context, error),
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (response) {
              final events = response.entityList ?? [];
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    gatekeeperCubit.getGatekeeperEvents(isNextPage: true);
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 110), // Adjust for AppBar
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return ScanHistoryItem(event: events[index]);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Builds a centered text widget for messages while keeping the AppBar visible.
  Widget _buildCenteredMessage(BuildContext context, String message) {
    return Center(
      child: SubTitleText(
        text: message,
        color: Colors.white,
        align: TextAlign.center,
      ),
    );
  }
}

