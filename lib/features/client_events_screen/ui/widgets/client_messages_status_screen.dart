import 'package:app/core/helpers/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dimensions/dimensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/public_appbar.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../logic/client_events_cubit.dart';
import '../../logic/client_events_states.dart';
import 'client_messages_status_item.dart';

class ClientMessagesStatusScreen extends StatefulWidget {
  final String eventId;

  const ClientMessagesStatusScreen({super.key, required this.eventId});

  @override
  State<ClientMessagesStatusScreen> createState() => _ClientMessagesStatusScreenState();
}

class _ClientMessagesStatusScreenState extends State<ClientMessagesStatusScreen> {
  final _scrollController = ScrollController();

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
      if (cubit.hasMoreMessages) {
        cubit.getClientMessagesStatus(widget.eventId, isNextPage: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: publicAppBar(
          context,
          "message_status".tr(),
        ),
        body: BlocBuilder<ClientEventsCubit, ClientEventsStates>(
          buildWhen: (previous, current) => current != previous,
          bloc: context.read<ClientEventsCubit>()..getClientMessagesStatus(widget.eventId),
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              emptyInput: () => _buildCenteredMessage("no_available_events".tr()),
              error: (error) => _buildCenteredMessage(error),
              loading: () => const Center(child: CupertinoActivityIndicator(color: Colors.white)),
              success: (response, isLoadingMore) {
                final events = response.clientMessagesDetailsList ?? [];
                if (events.isEmpty) {
                  return _buildCenteredMessage("no_available_events".tr());
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: edge),
                  itemCount: events.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator at the bottom
                    if (isLoadingMore && index == events.length) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: CupertinoActivityIndicator(color: Colors.white),
                        ),
                      );
                    }

                    // Show event items
                    return GestureDetector(
                      onTap: () {
                        context.pushNamed(Routes.clientGuestDetailsScreen, arguments: events[index]);
                      },
                      child: ClientMessagesStatusItem(
                        clientMessagesStatusDetails: events[index],
                      ),
                    );
                  },
                );
              },
            );
          },
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
