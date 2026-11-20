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
        default:
          return 'Unable to load price chart. Please try again.';
      }
    }

    return 'Unable to load price chart. Please try again.';
  }
}
