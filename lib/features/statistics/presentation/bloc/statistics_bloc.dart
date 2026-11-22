
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

      case DioExceptionType.transformTimeout:
        return 'Request took too long. Please try again.';

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        switch (statusCode) {
          case 401:
            return 'Unauthorized. Please check your API key.';
          case 429:
            return 'Too many requests. Please try again later.';
          case 500:
          case 502:
          case 503:
          case 504:
            return 'Server is currently unavailable. Please try again later.';
          default:
            return 'Unable to load market statistics. Please try again.';
        }

      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badCertificate:
        return 'Secure connection failed.';
      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }

  return 'Unable to load market statistics. Please try again.';
}
}
