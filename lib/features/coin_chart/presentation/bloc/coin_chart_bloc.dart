import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../domain/usecases/get_coin_chart.dart';
import 'coin_chart_event.dart';
import 'coin_chart_state.dart';

class CoinChartBloc extends Bloc<CoinChartEvent, CoinChartState> {
  final GetCoinChart getCoinChart;

  CoinChartBloc({required this.getCoinChart}) : super(CoinChartInitial()) {
    on<FetchCoinChartEvent>(_onFetchCoinChart);
  }

  Future<void> _onFetchCoinChart(
    FetchCoinChartEvent event,
    Emitter<CoinChartState> emit,
  ) async {
    emit(CoinChartLoading());

    try {
      final chart = await getCoinChart(coinId: event.coinId, days: event.days);

      if (chart.prices.isEmpty) {
        emit(CoinChartError('No chart data available.'));
        return;
      }

      emit(CoinChartLoaded(chart: chart, days: event.days));
    } catch (e) {
      emit(CoinChartError(_getErrorMessage(e)));
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
            return 'Unable to load price chart. Please try again.';
        }

      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badCertificate:
        return 'Secure connection failed.';
      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }

  return 'Unable to load price chart. Please try again.';
}
}
