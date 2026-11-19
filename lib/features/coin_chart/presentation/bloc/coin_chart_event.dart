
abstract class CoinChartEvent {}

class FetchCoinChartEvent extends CoinChartEvent {
  final String coinId;
  final int days;

  FetchCoinChartEvent({
    required this.coinId,
    required this.days,
  });
}
