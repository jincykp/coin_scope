
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../domain/usecases/get_statistics.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final GetStatistics getStatistics;

  StatisticsBloc({required this.getStatistics})
      : super(const StatisticsInitial()) {
    on<FetchStatisticsEvent>(_onFetchStatistics);
    on<RefreshStatisticsEvent>(_onRefreshStatistics);
  }

  Future<void> _onFetchStatistics(
    FetchStatisticsEvent event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(const StatisticsLoading());

    try {
      final statistics = await getStatistics();
      emit(StatisticsLoaded(statistics));
    } catch (e) {
      emit(StatisticsError(_getErrorMessage(e)));
    }
  }

  Future<void> _onRefreshStatistics(
    RefreshStatisticsEvent event,
    Emitter<StatisticsState> emit,
  ) async {
    try {
      final statistics = await getStatistics();
      emit(StatisticsLoaded(statistics));
    } catch (e) {
      emit(StatisticsError(_getErrorMessage(e)));
    }
  }

  String _getErrorMessage(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return 'Please check your internet connection and try again.';
        default:
          return 'Unable to load market statistics. Please try again.';
      }
    }

    return 'Unable to load market statistics. Please try again.';
  }
}
