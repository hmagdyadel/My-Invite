import 'package:flutter_bloc/flutter_bloc.dart';

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
}
