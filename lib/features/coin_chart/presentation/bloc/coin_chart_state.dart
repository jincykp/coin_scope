
import '../../domain/entities/coin_chart.dart';

abstract class CoinChartState {}

class CoinChartInitial extends CoinChartState {}

class CoinChartLoading extends CoinChartState {}

class CoinChartLoaded extends CoinChartState {
  final CoinChart chart;
  final int days;

  CoinChartLoaded({
    required this.chart,
    required this.days,
  });
}

class CoinChartError extends CoinChartState {
  final String message;

  CoinChartError(this.message);
}
