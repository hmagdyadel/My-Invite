import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/networking/api_result.dart';
import '../../client_events/data/models/client_event_response.dart';
import '../data/repo/client_statistics_repo.dart';
import 'client_statistics_states.dart';

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

class ClientStatisticsCubit extends Cubit<ClientStatisticsStates> {
  final ClientStatisticsRepo _clientStatisticsRepo;

  ClientStatisticsCubit(this._clientStatisticsRepo) : super(const ClientStatisticsStates.initial());
  final _eventsHandler = PaginationHandler<ClientEventDetails>();

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
        emit(const ClientStatisticsStates.loading());
      } else {
        handler.currentPage++;
        emit(ClientStatisticsStates.success(
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

            emit(ClientStatisticsStates.success(
              createResponse(handler.items, handler.totalPages),
              isLoadingMore: false,
            ));
          } else if (handler.currentPage == 0) {
            emit(const ClientStatisticsStates.emptyInput());
          }
        },
        failure: (error) {
          emit(ClientStatisticsStates.error(message: error.toString()));
        },
      );
    } catch (e) {
      emit(ClientStatisticsStates.error(message: 'some_error'.tr()));
    } finally {
      handler.isLoading = false;
    }
  }

  /// Fetch paginated Client Events
  Future<void> getClientEvents({bool isNextPage = false}) async {
    await _handlePaginatedRequest<ClientEventDetails, ClientEventResponse>(
      handler: _eventsHandler,
      apiCall: _clientStatisticsRepo.getClientEvents,
      getItems: (response) => (response as ClientEventResponse).eventDetailsList ?? [],
      getPages: (response) => (response as ClientEventResponse).noOfPages ?? 1,
      createResponse: (items, totalPages) => ClientEventResponse(eventDetailsList: List<ClientEventDetails>.from(items), noOfPages: totalPages),
      isNextPage: isNextPage,
    );
  }

  // Public getters for state information
  bool get hasMoreEvents => _eventsHandler.hasMore;
}
