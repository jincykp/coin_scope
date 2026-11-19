
import '../entities/coin_chart.dart';
import '../repositories/coin_chart_repository.dart';

class GetCoinChart {
  final CoinChartRepository repository;

  GetCoinChart({required this.repository});

  Future<CoinChart> call({
    required String coinId,
    required int days,
  }) {
    return repository.getCoinChart(
      coinId: coinId,
      days: days,
    );
  }
}
