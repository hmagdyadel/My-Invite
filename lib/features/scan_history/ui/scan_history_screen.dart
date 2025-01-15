import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/loaders.dart';
import '../../../core/widgets/public_appbar.dart';
import '../logic/gatekeeper_events_cubit.dart';
import '../logic/scan_history_states.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gatekeeperCubit = context.read<GatekeeperEventsCubit>();

    return Stack(
      children: [
        // Public AppBar
        SizedBox(
          height: 110,
          child: publicAppBar(
            context,
            "scan_history".tr(),
          ),
        ),

        // BlocBuilder for State Management
        BlocBuilder<GatekeeperEventsCubit, ScanHistoryStates>(
          buildWhen: (previous, current) => previous != current,
          bloc: gatekeeperCubit..getGatekeeperEvents(),
          builder: (context, state) {
            return state.when(
              // Initial State
              initial: () => const SizedBox.shrink(),

              // Empty Input State
              emptyInput: () {
                _navigateBackIfPossible(context);
                return _buildCenteredMessage(context,"no_available_events".tr());
              },

              // Error State
              error: (error) => const SizedBox.shrink(),

              // Loading State
              loading: () {
                _showLoadingDialog(context, "wait".tr());
                return const SizedBox.shrink();
              },

              // Success State
              success: (success) {
                _navigateBackIfPossible(context);
                return const SizedBox.shrink(); // Leave this unchanged as per your request
              },
            );
          },
        ),
      ],
    );
  }

  /// Navigates back if the navigator can pop.
  void _navigateBackIfPossible(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Navigator.canPop(context)) {
        context.pop();
      }
    });
  }

  /// Displays a loading dialog with a given title.
  void _showLoadingDialog(BuildContext context, String title) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animatedLoaderWithTitle(context: context, title: title);
    });
  }

  /// Builds a centered text widget for messages while keeping the AppBar visible.
  Widget _buildCenteredMessage(BuildContext context, String message) {
    return Scaffold(
      backgroundColor: bgColorOverlay,
      appBar: publicAppBar(
        context,
        "scan_history".tr(),
      ),
      body: Center(
        child: SubTitleText(text:
          message,
          color: Colors.white,
          align: TextAlign.center,
        ),
      ),
    );
  }

}
