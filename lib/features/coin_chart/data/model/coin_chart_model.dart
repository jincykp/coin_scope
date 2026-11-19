
import '../../domain/entities/coin_chart.dart';

class CoinChartModel extends CoinChart {
  const CoinChartModel({
    required super.prices,
    required super.marketCaps,
    required super.totalVolumes,
  });

  factory CoinChartModel.fromJson(Map<String, dynamic> json) {
    return CoinChartModel(
      prices: _parseChartData(json['prices']),
      marketCaps: _parseChartData(json['market_caps']),
      totalVolumes: _parseChartData(json['total_volumes']),
    );
  }

  static List<ChartDataPoint> _parseChartData(dynamic data) {
    if (data == null) return [];

    return (data as List).map((item) {
      return ChartDataPoint(
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          (item[0] as num).toInt(),
          isUtc: true,
        ),
        value: (item[1] as num).toDouble(),
      );
    }).toList();
  }
}
