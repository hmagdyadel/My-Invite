import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dimensions/dimensions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../core/widgets/public_appbar.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../data/models/client_event_response.dart';
import '../../logic/client_events_cubit.dart';
import '../../logic/client_events_states.dart';
import 'client_event_details_item.dart';

class ClientEventDetailsScreen extends StatefulWidget {
  final ClientEventDetails clientEventDetailsItem;

  const ClientEventDetailsScreen({super.key, required this.clientEventDetailsItem});

  @override
  State<ClientEventDetailsScreen> createState() => _ClientEventDetailsScreenState();
}

class _ClientEventDetailsScreenState extends State<ClientEventDetailsScreen> {
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
      if (cubit.hasMoreDetails) {
        // Changed from hasMoreEvents to hasMoreDetails
        cubit.getEventDetails(widget.clientEventDetailsItem.id.toString(), isNextPage: true); // Changed from getClientEvents to getEventDetails
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorOverlay,
      appBar: publicAppBar(context, "attendance_info".tr()),
      body: BlocBuilder<ClientEventsCubit, ClientEventsStates>(
        buildWhen: (previous, current) => current != previous,
        bloc: context.read<ClientEventsCubit>()..getEventDetails(widget.clientEventDetailsItem.id.toString()),
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            emptyInput: () => _buildCenteredMessage("no_available_events".tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () =>  Center(child: Loader(color: whiteTextColor)),
            success: (response, isLoadingMore) {
              final events = response.eventDetailsList ?? [];
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
                        child: Loader(color: whiteTextColor),
                      ),
                    );
                  }

                  // Show event items
                  return ClientEventDetailsItem(
                    clientEventDetailsList: events[index],
                  );
                },
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
