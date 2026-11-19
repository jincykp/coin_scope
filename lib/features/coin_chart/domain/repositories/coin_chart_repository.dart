
import '../entities/coin_chart.dart';

abstract class CoinChartRepository {
  Future<CoinChart> getCoinChart({
    required String coinId,
    required int days,
  });
}
