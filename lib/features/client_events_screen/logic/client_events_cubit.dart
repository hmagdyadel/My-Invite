import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/networking/api_result.dart';
import '../data/models/client_event_details_response.dart';
import '../data/models/client_event_response.dart';
import '../data/models/client_messages_status_response.dart';
import '../data/repo/client_events_repo.dart';
import 'client_events_states.dart';

/// Base class for handling pagination logic
class PaginationHandler<T> {
  final List<T> items = [];
  int currentPage = 0;
  int totalPages = 1;
  bool isLoading = false;

  bool get hasMore => currentPage < totalPages - 1;

  void reset() {
    currentPage = 0;
    items.clear();
    totalPages = 1;
    isLoading = false;
  }
}

class ClientEventsCubit extends Cubit<ClientEventsStates> {
  final ClientEventsRepo _clientEventsRepo;

  final _eventsHandler = PaginationHandler<ClientEventDetails>();
  final _eventDetailsHandler = PaginationHandler<ClientEventDetailsList>();
  final _messagesHandler = PaginationHandler<ClientMessagesStatusDetails>();

  ClientEventsCubit(this._clientEventsRepo) : super(const ClientEventsStates.initial());

  /// Generic method to handle paginated API calls
  Future<void> _handlePaginatedRequest<T, R>({
    required PaginationHandler<T> handler,
    required Future<ApiResult> Function(String page) apiCall,
    required List<T> Function(dynamic response) getItems,
    required int Function(dynamic response) getPages,
    required R Function(List<T>, int) createResponse,
    bool isNextPage = false,
  }) async {
    if (handler.isLoading || (!handler.hasMore && isNextPage)) return;

    try {
      handler.isLoading = true;

      if (!isNextPage) {
        handler.reset();
        emit(const ClientEventsStates.loading());
      } else {
        handler.currentPage++;
        emit(ClientEventsStates.success(
          createResponse(handler.items, handler.totalPages),
          isLoadingMore: true,
        ));
      }

      final response = await apiCall((handler.currentPage + 1).toString());

      await response.when(
        success: (data) async {
          final items = getItems(data);
          if (items.isNotEmpty) {
            if (handler.currentPage == 0) {
              handler.items.clear();
              handler.totalPages = getPages(data);
            }

            handler.items.addAll(items);

            emit(ClientEventsStates.success(
              createResponse(handler.items, handler.totalPages),
              isLoadingMore: false,
            ));
          } else if (handler.currentPage == 0) {
            emit(const ClientEventsStates.emptyInput());
          }
        },
        failure: (error) {
          emit(ClientEventsStates.error(message: error.toString()));
        },
      );
    } catch (e) {
      emit(ClientEventsStates.error(message: 'some_error'.tr()));
    } finally {
      handler.isLoading = false;
    }
  }

  /// Fetch paginated Client Events
  Future<void> getClientEvents({bool isNextPage = false}) async {
    await _handlePaginatedRequest<ClientEventDetails, ClientEventResponse>(
      handler: _eventsHandler,
      apiCall: _clientEventsRepo.getClientEvents,
      getItems: (response) => (response as ClientEventResponse).eventDetailsList ?? [],
      getPages: (response) => (response as ClientEventResponse).noOfPages ?? 1,
      createResponse: (items, totalPages) => ClientEventResponse(
          eventDetailsList: List<ClientEventDetails>.from(items),
          noOfPages: totalPages
      ),
      isNextPage: isNextPage,
    );
  }

  /// Fetch paginated Client Event Details
  Future<void> getEventDetails(String eventId, {bool isNextPage = false}) async {
    await _handlePaginatedRequest<ClientEventDetailsList, ClientEventDetailsResponse>(
      handler: _eventDetailsHandler,
      apiCall: (page) => _clientEventsRepo.getClientEventDetails(eventId, page),
      getItems: (response) => (response as ClientEventDetailsResponse).eventDetailsList ?? [],
      getPages: (response) => (response as ClientEventDetailsResponse).noOfPages ?? 1,
      createResponse: (items, totalPages) => ClientEventDetailsResponse(
          eventDetailsList: List<ClientEventDetailsList>.from(items),
          noOfPages: totalPages
      ),
      isNextPage: isNextPage,
    );
  }

  /// Fetch paginated Client Messages Status
  Future<void> getClientMessagesStatus(String eventId, {bool isNextPage = false}) async {
    await _handlePaginatedRequest<ClientMessagesStatusDetails, ClientMessagesStatusResponse>(
      handler: _messagesHandler,
      apiCall: (page) => _clientEventsRepo.getClientMessagesStatus(eventId, page),
      getItems: (response) => (response as ClientMessagesStatusResponse).clientMessagesDetailsList ?? [],
      getPages: (response) => (response as ClientMessagesStatusResponse).noOfPages ?? 1,
      createResponse: (items, totalPages) => ClientMessagesStatusResponse(
          clientMessagesDetailsList: List<ClientMessagesStatusDetails>.from(items),
          noOfPages: totalPages
      ),
      isNextPage: isNextPage,
    );
  }

  // Public getters for pagination state
  bool get hasMoreEvents => _eventsHandler.hasMore;
  bool get hasMoreDetails => _eventDetailsHandler.hasMore;
  bool get hasMoreMessages => _messagesHandler.hasMore;
}