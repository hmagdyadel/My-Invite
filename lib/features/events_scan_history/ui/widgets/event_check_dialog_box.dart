import 'dart:io';

import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/widgets/go_button.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/public_methods.dart';
import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../data/models/gatekeeper_events_response.dart';
import '../../logic/gatekeeper_events_cubit.dart';
import '../../logic/scan_history_states.dart';
import 'camera_screen.dart';
import 'get_gatekeeper_position.dart';

class EventCheckDialogBox extends StatefulWidget {
  final EventsList event;

  const EventCheckDialogBox({super.key, required this.event});

  @override
  State<EventCheckDialogBox> createState() => _EventCheckDialogBoxState();
}

class _EventCheckDialogBoxState extends State<EventCheckDialogBox> {
  bool _isProcessing = false;
  String? _initialHintText;
  static const String _checkInStatusKey = 'event_check_in_status_';

  Future<bool> _hasCheckedIn(String eventId) async {
    final status = await AppUtilities.instance.getSavedBool(_checkInStatusKey + eventId, false);
    return status;
  }

  Future<void> _markAsCheckedIn(String eventId) async {
    await AppUtilities.instance.setSavedString("event_id", eventId);

    await AppUtilities.instance.setSavedBool(_checkInStatusKey + eventId, true);
  }

  Future<void> _markAsCheckedOut(String eventId) async {
    await AppUtilities.instance.setSavedBool(_checkInStatusKey + eventId, false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GatekeeperEventsCubit, ScanHistoryStates>(
      buildWhen: (previous, current) => previous != current,
      listenWhen: (previous, current) => current is ErrorCheck || current is SuccessCheck || current is LoadingCheckOut || current is LoadingCheckIn,
      builder: (context, state) => _buildDialog(context, state),
      listener: _handleStateChanges,
    );
  }

  Widget _buildDialog(BuildContext context, ScanHistoryStates state) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade200,
      title: _buildDialogTitle(),
      content: _buildDialogContent(),
      actions: [
        _buildActionButtons(context, state),
      ],
    );
  }

  Widget _buildDialogTitle() {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: primaryColor, size: 60),
        const SizedBox(height: 12),
        SubTitleText(
          text: "event_check".tr(),
          color: Colors.grey.shade900,
          fontSize: 20,
        ),
      ],
    );
  }

  Widget _buildDialogContent() {
    return FutureBuilder<bool>(
      future: _hasCheckedIn(widget.event.id.toString()),
      builder: (context, snapshot) {
        // If initial hint text hasn't been set yet, determine it based on check-in status
        if (_initialHintText == null) {
          final bool hasCheckedIn = snapshot.data ?? false;
          _initialHintText = hasCheckedIn ? "event_check_out_hint".tr() : "event_check_in_hint".tr();
        }

        return NormalText(
          text: _initialHintText.toString(),
          fontSize: 16,
          color: Colors.grey.shade900,
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, ScanHistoryStates state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCheckButton(
          context: context,
          isCheckIn: true,
          state: state,
        ),
        _buildCheckButton(
          context: context,
          isCheckIn: false,
          state: state,
        ),
      ],
    );
  }

  Widget _buildCheckButton({
    required BuildContext context,
    required bool isCheckIn,
    required ScanHistoryStates state,
  }) {
    final bool isLoading = isCheckIn ? state is LoadingCheckIn : state is LoadingCheckOut;

    return FutureBuilder<bool>(
      future: _hasCheckedIn(widget.event.id.toString()),
      builder: (context, snapshot) {
        final bool hasCheckedIn = snapshot.data ?? false;
        final bool shouldDisableCheckIn = isCheckIn && hasCheckedIn;
        final bool shouldDisableCheckOut = !isCheckIn && !hasCheckedIn;

        return GoButton(
          fun: () {
            if (shouldDisableCheckIn) {
              context.showErrorToast("already_checked_in".tr());
            } else if (shouldDisableCheckOut) {
              context.showErrorToast("must_check_in_first".tr());
            } else if (!_isProcessing) {
              _handleCheckAction(context, isCheckIn);
            }
          },
          titleKey: isCheckIn ? "check_in".tr() : "check_out".tr(),
          textColor: Colors.white,
          btColor: isCheckIn ? primaryColor : Colors.red,
          loading: isLoading,
          loaderColor: Colors.white,
          w: 110,
        );
      },
    );
  }

  Future<void> _handleCheckAction(BuildContext context, bool isCheckIn) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      // if you want to test check in come here
      // this is will disable the check of time
      if (!_isWithinEventTimeWindow(widget.event)) {
        _showOutsideTimeWindowError(context);
        return;
      }

      final position = await _getValidatedPosition(context);
      if (position == null) return;

      if (isCheckIn) {
        await _processCheckIn(context, position);
      } else {
        await _processCheckOut(context, position);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  bool _isWithinEventTimeWindow(EventsList event) {
    final DateTime start = getDateTimeFromString(event.eventFrom ?? DateTime.now().toString());
    final DateTime end = getDateTimeFromString(event.eventTo ?? DateTime.now().toString());

    final startWindow = DateTime(start.year, start.month, start.day, 0, 0, 0);
    final endWindow = DateTime(end.year, end.month, end.day, 23, 59, 59);

    final now = DateTime.now();

    return now.isAfter(startWindow) && now.isBefore(endWindow) || now.isAtSameMomentAs(startWindow) || now.isAtSameMomentAs(endWindow);
  }

  void _showOutsideTimeWindowError(BuildContext context) {
    context.pop();
    context.showSuccessToast("can_not_check_in_or_out".tr());
  }

  Future<Position?> _getValidatedPosition(BuildContext context) async {
    final position = await LocationService.getPosition(context);
    if (position.latitude == -1 || position.longitude == -1) {
      if (mounted) context.pop();
      return null;
    }
    return position;
  }

  Future<void> _processCheckIn(BuildContext context, Position position) async {
    final hasCheckedIn = await _hasCheckedIn(widget.event.id.toString());
    if (hasCheckedIn) {
      if (mounted) {
        context.showErrorToast("already_checked_in".tr());
        context.pop();
      }
      return;
    }

    final image = await Navigator.push<XFile>(
      context,
      MaterialPageRoute(builder: (context) => const CameraScreen()),
    );

    if (image != null && mounted) {
      context.showSuccessToast("captureSuccess".tr());
      context.read<GatekeeperEventsCubit>().eventCheckIn(
            widget.event.id.toString(),
            position,
            image,
          );
      await _markAsCheckedIn(widget.event.id.toString());
    }
  }

  Future<void> _processCheckOut(BuildContext context, Position position) async {
    final hasCheckedIn = await _hasCheckedIn(widget.event.id.toString());
    if (!hasCheckedIn) {
      if (mounted) {
        context.showErrorToast("must_check_in_first".tr());
        context.pop();
      }
      return;
    }

    if (!mounted) return;
    context.read<GatekeeperEventsCubit>().eventCheckOut(
          widget.event.id.toString(),
          position,
        );
    await _markAsCheckedOut(widget.event.id.toString());
  }

  void _handleStateChanges(BuildContext context, ScanHistoryStates state) {
    state.whenOrNull(
      errorCheck: (error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.pop();
          context.showErrorToast(error);
        });
      },
      successCheck: (response) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.pop();
          _handleSuccessResponse(context, response);
        });
      },
    );
  }

  void _handleSuccessResponse(BuildContext context, String response) {
    if (response.contains("In")) {
      if (Platform.isIOS) context.pop();
      context.showSuccessToast("checkInSuccess".tr());
    } else if (response.contains("Out")) {
      context.showSuccessToast("checkOutSuccess".tr());
    } else {
      context.showSuccessToast(response);
    }
  }
}
