import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dimensions/dimensions.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/public_appbar.dart';
import '../../../core/widgets/subtitle_text.dart';
import '../../scan_history/ui/widgets/event_check_dialog_box.dart';
import '../../scan_history/ui/widgets/scan_history_item.dart';
import '../logic/client_events_cubit.dart';
import '../logic/client_events_states.dart';

class ClientEventsScreen extends StatefulWidget {
  const ClientEventsScreen({super.key});

  @override
  State<ClientEventsScreen> createState() => _ClientEventsScreenState();
}

class _ClientEventsScreenState extends State<ClientEventsScreen> {
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      final cubit = context.read<ClientEventsCubit>();
      if (cubit.hasMoreEvents) {
        cubit.getClientEvents(isNextPage: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorOverlay,
      appBar: publicAppBar(context, "events_calendar".tr()),
      body: BlocBuilder<ClientEventsCubit, ClientEventsStates>(
        buildWhen: (previous, current) => current != previous,
        bloc: context.read<ClientEventsCubit>()..getClientEvents(),
        builder: (context, current) {
          return current.when(
            initial: () => const SizedBox.shrink(),
            emptyInput: () => _buildCenteredMessage("no_available_events".tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () => const Center(child: CupertinoActivityIndicator(color: Colors.white)),
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
                              child: CupertinoActivityIndicator(color: Colors.white),
                            ),
                          );
                        }
                        return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return BlocProvider.value(
                                    value: context.read<ClientEventsCubit>(),
                                    child: EventCheckDialogBox(
                                      event: events[index],
                                    ),
                                  );
                                },
                              );
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
}
