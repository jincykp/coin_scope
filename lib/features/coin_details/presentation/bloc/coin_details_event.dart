abstract class CoinDetailsEvent {}

class FetchCoinDetailsEvent extends CoinDetailsEvent {
  final String coinId;

  FetchCoinDetailsEvent(this.coinId);
}