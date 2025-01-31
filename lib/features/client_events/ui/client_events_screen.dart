import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/routing/routes.dart';
import 'widgets/client_event_item.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dimensions/dimensions.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/public_appbar.dart';
import '../../../core/widgets/subtitle_text.dart';
import '../data/models/client_event_response.dart';
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
      appBar: publicAppBar(context, "events".tr(),),
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
              final events = response.eventDetailsList ?? [];
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
                            showEventBottomSheet(events[index]);
                          },
                          child: ClientEventItem(
                            event: events[index],
                          ),
                        );
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

  void showEventBottomSheet(ClientEventDetails? event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: height * 0.75,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBottomSheetOption(
                text: "attendance_info".tr(),
                onTap: () {
                  context.pop();
                  context.pushNamed(Routes.clientEventsDetailsScreen, arguments: event);
                },
              ),
              SizedBox(height: edge * 0.5),
              buildBottomSheetOption(
                text: "show_message_status".tr(),
                onTap: () {
                  context.pop();
                  context.pushNamed(Routes.clientMessagesStatusScreen, arguments: event?.id.toString());
                },
              ),
              SizedBox(height: edge * 0.5),
              buildBottomSheetOption(
                  text: "cancel".tr(),
                  onTap: () {
                    context.pop();
                  },
                  color: Colors.red),
              SizedBox(height: edge),
            ],
          ),
        );
      },
    );
  }

  Widget buildBottomSheetOption({
    required String text,
    required VoidCallback onTap,
    Color? color, // Optional color parameter
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: edge * 0.5, horizontal: edge),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color ?? navBarBackground, // Use the passed color or fallback to bgColor
          borderRadius: BorderRadius.circular(12),
        ),
        child: SubTitleText(
          text: text,
          color: Colors.white,
          fontSize: 18,
        ),
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
