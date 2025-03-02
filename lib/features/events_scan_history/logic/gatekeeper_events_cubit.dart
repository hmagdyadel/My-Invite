import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/notification_scheduler.dart';
import '../../event_calender/data/models/calender_events.dart';
import '../data/models/gatekeeper_events_response.dart';
import '../data/models/event_details_response.dart';
import '../data/repo/gatekeeper_events_repo.dart';
import 'scan_history_states.dart';

class GatekeeperEventsCubit extends Cubit<ScanHistoryStates> {
  final GatekeeperEventsRepo _gatekeeperEventsRepo;

  // For Gatekeeper Events Pagination
  final List<EventsList> _events = [];
  int _currentPageEvents = 0; // Changed to start from 0 like old code
  int _totalPagesEvents = 1;
  bool _isLoadingEvents = false;

  // For Event Details Pagination
  final List<EventDetails> _eventDetails = [];
  int _currentPageDetails = 0; // Changed to start from 0 like old code
  int _totalPagesDetails = 1;
  bool _isLoadingDetails = false;

  GatekeeperEventsCubit(this._gatekeeperEventsRepo) : super(const ScanHistoryStates.initial());

  /// Reset events pagination
  void resetEventsPage() {
    _currentPageEvents = 0;
    _events.clear();
    _totalPagesEvents = 1;
  }

  /// Reset details pagination
  void resetDetailsPage() {
    _currentPageDetails = 0;
    _eventDetails.clear();
    _totalPagesDetails = 1;
  }

  /// Check if more events pages are available
  bool get hasMoreEvents => _currentPageEvents < _totalPagesEvents - 1;

  /// Check if more details pages are available
  bool get hasMoreDetails => _currentPageDetails < _totalPagesDetails - 1;

  /// Fetch paginated Gatekeeper Events
  Future<void> getGatekeeperEvents({bool isNextPage = false}) async {
    // Don't proceed if already loading or trying to load next page when no more pages
    if (_isLoadingEvents || (!hasMoreEvents && isNextPage)) return;

    try {
      _isLoadingEvents = true;

      if (!isNextPage) {
        resetEventsPage();
        emit(const ScanHistoryStates.loading());
      } else {
        _currentPageEvents++;
        emit(ScanHistoryStates.success(
          GatekeeperEventsResponse(entityList: _events),
          isLoadingMore: true,
        ));
      }

      final response = await _gatekeeperEventsRepo.getGatekeeperEvents(
        (_currentPageEvents + 1).toString(), // Adding 1 because API expects 1-based index
      );

      await response.when(
        success: (data) async {
          if (data.entityList != null && data.entityList!.isNotEmpty) {
            if (_currentPageEvents == 0) {
              _events.clear();
              _totalPagesEvents = data.noOfPages ?? 1;
            }

            _events.addAll(data.entityList!);

            // Schedule notifications for new events
            _scheduleNotificationsForEvents(data.entityList!);

            emit(ScanHistoryStates.success(
              GatekeeperEventsResponse(
                entityList: _events,
                noOfPages: _totalPagesEvents,
              ),
              isLoadingMore: false,
            ));
          } else if (_currentPageEvents == 0) {
            emit(const ScanHistoryStates.emptyInput());
          }
        },
        failure: (error) {
          emit(ScanHistoryStates.error(message: error.toString()));
        },
      );
    } catch (e) {
      emit(ScanHistoryStates.error(message: 'some_error'.tr()));
    } finally {
      _isLoadingEvents = false;
    }
  }

  /// Fetch paginated Event Details
  Future<void> getEventDetails(String eventId, {bool isNextPage = false}) async {
    // Don't proceed if already loading or trying to load next page when no more pages
    if (_isLoadingDetails || (!hasMoreDetails && isNextPage)) return;

    try {
      _isLoadingDetails = true;

      if (!isNextPage) {
        resetDetailsPage();
        emit(const ScanHistoryStates.loading());
      } else {
        _currentPageDetails++;
        emit(ScanHistoryStates.success(
          EventDetailsResponse(eventDetailsList: _eventDetails),
          isLoadingMore: true,
        ));
      }

      final response = await _gatekeeperEventsRepo.getEventDetails(
        eventId,
        (_currentPageDetails + 1).toString(), // Adding 1 because API expects 1-based index
      );

      await response.when(
        success: (data) async {
          if (data.eventDetailsList != null && data.eventDetailsList!.isNotEmpty) {
            if (_currentPageDetails == 0) {
              _eventDetails.clear();
              _totalPagesDetails = data.noOfPages ?? 1;
            }

            _eventDetails.addAll(data.eventDetailsList!);

            emit(ScanHistoryStates.success(
              EventDetailsResponse(
                eventDetailsList: _eventDetails,
                noOfPages: _totalPagesDetails,
              ),
              isLoadingMore: false,
            ));
          } else if (_currentPageDetails == 0) {
            emit(const ScanHistoryStates.emptyInput());
          }
        },
        failure: (error) {
          emit(ScanHistoryStates.error(message: error.toString()));
        },
      );
    } catch (e) {
      emit(ScanHistoryStates.error(message: 'some_error'.tr()));
    } finally {
      _isLoadingDetails = false;
    }
  }

  List<EventsList> get currentEvents => _events;

  List<EventDetails> get currentDetails => _eventDetails;

  void eventCheckOut(String eventId, Position position) async {
    emit(const ScanHistoryStates.loadingCheckOut());
    final response = await _gatekeeperEventsRepo.eventCheckOut(eventId, position);
    response.when(success: (response) {
      emit(ScanHistoryStates.successCheck(response));
    }, failure: (error) {
      debugPrint(' in error: $error');
      if (error == "not_yet_checked") {
        debugPrint('Emitting errorCheck with message: ${"not_yet_checked".tr()}');
        emit(
          ScanHistoryStates.errorCheck(
            message: "not_yet_checked".tr(),
          ),
        );
      } else {
        emit(
          ScanHistoryStates.errorCheck(
            message: error.toString(),
          ),
        );
      }
    });
  }

  void eventCheckIn(String eventId, Position position, XFile? profileImage) async {
    emit(const ScanHistoryStates.loadingCheckIn());
    final response = await _gatekeeperEventsRepo.eventCheckIn(eventId, position, profileImage);
    response.when(success: (response) {
      debugPrint('in success $response');
      emit(ScanHistoryStates.successCheck(response));
    }, failure: (error) {
      debugPrint('in failure $response');
      emit(
        ScanHistoryStates.errorCheck(
          message: error.toString(),
        ),
      );
    });
  }

// Add this property at the top of the class with other properties
  final Set<String> _scheduledEventIds = {};

  /// Schedule notifications for events that haven't been scheduled yet
  Future<void> _scheduleNotificationsForEvents(List<EventsList> events) async {
    final notificationScheduler = NotificationScheduler();

    for (final event in events) {
      if (event.id != null && !_scheduledEventIds.contains(event.id.toString())) {
        try {
          debugPrint("Scheduling notifications for event: ${event.eventTitle}");

          // Convert EventsList to the format expected by NotificationScheduler
          await notificationScheduler.scheduleNotifications(
            event: _convertToCalendarEvent(event),
          );

          // Mark this event as scheduled
          _scheduledEventIds.add(event.id.toString());

          debugPrint("Notifications scheduled successfully for event ID: ${event.id}");
        } catch (e) {
          debugPrint("Failed to schedule notification for event ID: ${event.id}, error: $e");
        }
      }
    }
  }

  /// Convert EventsList to CalenderEventsResponse format
  CalenderEventsResponse _convertToCalendarEvent(EventsList event) {
    return CalenderEventsResponse(
      id: event.id,
      eventTitle: event.eventTitle,
      eventFrom: event.eventFrom,
      eventTo: event.eventTo,
      // Add other required fields as needed
    );
  }

  // Add this method to the class
  Future<void> scheduleNotificationForEvent(EventsList event) async {
    if (event.id != null) {
      try {
        debugPrint("Manually scheduling notifications for event: ${event.eventTitle}");

        final notificationScheduler = NotificationScheduler();
        await notificationScheduler.scheduleNotifications(
          event: _convertToCalendarEvent(event),
        );

        _scheduledEventIds.add(event.id.toString());

        debugPrint("Notifications manually scheduled successfully for event ID: ${event.id}");
      } catch (e) {
        debugPrint("Failed to manually schedule notification for event ID: ${event.id}, error: $e");
      }
    }
  }
}
