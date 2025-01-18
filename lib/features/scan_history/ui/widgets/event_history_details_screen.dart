import 'package:app/core/helpers/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/dimensions/dimensions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/public_appbar.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../data/models/gatekeeper_events_response.dart';
import '../../logic/gatekeeper_events_cubit.dart';
import '../../logic/scan_history_states.dart';

class EventHistoryDetailsScreen extends StatefulWidget {
  final EventsList? event;

  const EventHistoryDetailsScreen({super.key, required this.event});

  @override
  State<EventHistoryDetailsScreen> createState() =>
      _EventHistoryDetailsScreenState();
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
        buildWhen: (previous, current) => previous != current,
        bloc: context.read<GatekeeperEventsCubit>()
          ..getEventDetails(widget.event?.id.toString() ?? "0"),
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            emptyInput: () => _buildCenteredMessage("no_available_events".tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () => const Center(
                child: CupertinoActivityIndicator(color: Colors.white)),
            success: (response, isLoadingMore) {
              final events = response.eventDetailsList ?? [];
              if (events.isEmpty) {
                return _buildCenteredMessage("no_available_events".tr());
              }

              return Column(
                children: [
                  Container(
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
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(vertical: edge),
                      itemCount: events.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == events.length && isLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CupertinoActivityIndicator(
                                  color: Colors.white),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
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
                text: widget.event?.scanned.toString() ?? "0",
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
                text: widget.event?.totalAllocated.toString() ?? "0",
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
                text: getPending(widget.event!),
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
                    text: widget.event?.eventVenue ?? "",
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  NormalText(
                    text: widget.event?.eventlocation ?? "",
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
    if (widget.event?.gmapCode == null) {
      context.showErrorToast("location_not_available".tr());
      return;
    }
    String googleUrl = widget.event?.gmapCode ?? "https://maps.google.com";
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
          text: widget.event?.eventCode ?? "",
          color: Colors.white,
          fontSize: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SubTitleText(
                text: widget.event?.eventTitle ?? "",
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

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final cubit = context.read<GatekeeperEventsCubit>();
      if (cubit.hasMoreDetails) {
        cubit.getEventDetails(widget.event?.id.toString() ?? "0",
            isNextPage: true);
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
