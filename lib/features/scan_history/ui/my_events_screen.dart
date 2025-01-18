import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:app/features/scan_history/ui/widgets/get_gatekeeper_position.dart';
import 'package:app/features/scan_history/ui/widgets/scan_history_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/dimensions/dimensions.dart';
import '../../../core/widgets/normal_text.dart';
import '../../../core/widgets/public_appbar.dart';
import '../logic/gatekeeper_events_cubit.dart';
import '../logic/scan_history_states.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
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

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final cubit = context.read<GatekeeperEventsCubit>();
      if (cubit.hasMoreEvents) {
        cubit.getGatekeeperEvents(isNextPage: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorOverlay,
      appBar: publicAppBar(
        context,
        "events".tr(),
      ),
      body: BlocBuilder<GatekeeperEventsCubit, ScanHistoryStates>(
        buildWhen: (previous, current) => previous != current,
        bloc: context.read<GatekeeperEventsCubit>()..getGatekeeperEvents(),
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            emptyInput: () => _buildCenteredMessage("no_available_events".tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () => const Center(
                child: CupertinoActivityIndicator(color: Colors.white)),
            success: (response, isLoadingMore) {
              final events = response.entityList ?? [];
              if (events.isEmpty) {
                return _buildCenteredMessage("no_available_events".tr());
              }

              return Column(
                children: [
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
                        return GestureDetector(
                            onTap: () {
                              _showColoredAlert(
                                  context: context,
                                  eventId: events[index].id.toString());
                            },
                            child: ScanHistoryItem(event: events[index]));
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

  Widget _buildCenteredMessage(String message) {
    return Center(
      child: SubTitleText(
        text: message,
        color: Colors.white,
        align: TextAlign.center,
      ),
    );
  }

  void _showColoredAlert(
      {required BuildContext context, required String eventId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          title: Column(
            children: [
              const Icon(
                Icons.check_circle,
                color: primaryColor,
                size: 60,
              ),
              const SizedBox(
                height: 12,
              ),
              SubTitleText(
                text: "event_check".tr(),
                color: Colors.grey.shade900,
                fontSize: 20,
              ),
            ],
          ),
          content: NormalText(
            text: "event_check_hint".tr(),
            fontSize: 16,
            color: Colors.grey.shade900,
          ),
          actions: [
            BlocBuilder<GatekeeperEventsCubit, ScanHistoryStates>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, current) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(primaryColor),
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: edge, vertical: edge * 0.7)),
                        ),
                        onPressed: () {
                          context.pop();
                        },
                        child: SubTitleText(
                          text: "check_in".tr(),
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.red),
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: edge, vertical: edge * 0.7)),
                        ),
                        onPressed: () async {
                          final position = await _getUserPosition();
                          context.read<GatekeeperEventsCubit>().eventCheckOut(
                                eventId,
                                position,
                              );
                        },
                        child: SubTitleText(
                          text: "check_out".tr(),
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                }),
          ],
        );
      },
    );
  }

  Future<Position> _getUserPosition() async {
    final position = await LocationService.getPosition(context);
    if (position.latitude == -1 || position.longitude == -1) {
      return Position(
          longitude: 0,
          latitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0);
    }
    return position;
  }
}
