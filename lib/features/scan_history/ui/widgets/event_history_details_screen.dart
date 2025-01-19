import 'event_details_item.dart';
import 'scan_details_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dimensions/dimensions.dart';
import '../../../../core/theming/colors.dart';

import '../../../../core/widgets/public_appbar.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../data/models/gatekeeper_events_response.dart';
import '../../logic/gatekeeper_events_cubit.dart';
import '../../logic/scan_history_states.dart';

class EventHistoryDetailsScreen extends StatefulWidget {
  final EventsList? event;

  const EventHistoryDetailsScreen({super.key, required this.event});

  @override
  State<EventHistoryDetailsScreen> createState() => _EventHistoryDetailsScreenState();
}

class _EventHistoryDetailsScreenState extends State<EventHistoryDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorOverlay,
      appBar: publicAppBar(
        context,
        "scan_history".tr(),
      ),
      body: BlocBuilder<GatekeeperEventsCubit, ScanHistoryStates>(
        buildWhen: (previous, current) => current is EmptyInputScanHistory || current is LoadingScanHistory || current is SuccessScanHistory || current is ErrorScanHistory,
        bloc: context.read<GatekeeperEventsCubit>()..getEventDetails(widget.event?.id.toString() ?? "0"),
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            errorCheck: (error) => const SizedBox.shrink(),
            successCheck: (success) => const SizedBox.shrink(),
            loadingCheck: () => const Center(child: CupertinoActivityIndicator(color: Colors.white)),
            emptyInput: () => _buildCenteredMessage("no_available_events".tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () => const Center(child: CupertinoActivityIndicator(color: Colors.white)),
            success: (response, isLoadingMore) {
              final events = response.eventDetailsList ?? [];
              if (events.isEmpty) {
                return _buildCenteredMessage("no_available_events".tr());
              }

              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: edge),
                itemCount: events.length + (isLoadingMore ? 2 : 1), // +2 for header and loader
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ScanDetailsHeader(event: widget.event);
                  }
                  if (index == events.length + 1 && isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CupertinoActivityIndicator(color: Colors.white),
                      ),
                    );
                  }
                  return EventDetailsItem(
                    eventDetails: events[index - 1], // Adjust for header index
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      final cubit = context.read<GatekeeperEventsCubit>();
      if (cubit.hasMoreDetails) {
        cubit.getEventDetails(widget.event?.id.toString() ?? "0", isNextPage: true);
      }
    }
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
