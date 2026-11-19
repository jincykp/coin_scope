
class CoinChart {
  final List<ChartDataPoint> prices;
  final List<ChartDataPoint> marketCaps;
  final List<ChartDataPoint> totalVolumes;

  const CoinChart({
    required this.prices,
    required this.marketCaps,
    required this.totalVolumes,
  });
}

class ChartDataPoint {
  final DateTime timestamp;
  final double value;

  const ChartDataPoint({
    required this.timestamp,
    required this.value,
  });
}
