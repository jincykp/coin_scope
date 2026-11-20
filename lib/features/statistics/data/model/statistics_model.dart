
import '../../domain/entities/statistics.dart';

class StatisticsModel extends Statistics {
  const StatisticsModel({
    required super.activeCryptocurrencies,
    required super.markets,
    required super.ongoingIcos,
    required super.totalMarketCap,
    required super.totalVolume,
    required super.marketCapChangePercentage24h,
    required super.volumeChangePercentage24h,
    required super.bitcoinDominance,
    required super.ethereumDominance,
    required super.fearAndGreedValue,
    required super.fearAndGreedSentiment,
    required super.updatedAt,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    final marketCap = json['total_market_cap'] as Map<String, dynamic>;
    final volume = json['total_volume'] as Map<String, dynamic>;
    final dominance =
        json['market_cap_percentage'] as Map<String, dynamic>;
    final fearAndGreed =
        json['fear_and_greed_index'] as Map<String, dynamic>;

    return StatisticsModel(
      activeCryptocurrencies:
          (json['active_cryptocurrencies'] as num).toInt(),
      markets: (json['markets'] as num).toInt(),
      ongoingIcos: (json['ongoing_icos'] as num).toInt(),
      totalMarketCap: (marketCap['usd'] as num).toDouble(),
      totalVolume: (volume['usd'] as num).toDouble(),
      marketCapChangePercentage24h:
          (json['market_cap_change_percentage_24h_usd'] as num).toDouble(),
      volumeChangePercentage24h:
          (json['volume_change_percentage_24h_usd'] as num).toDouble(),
      bitcoinDominance: (dominance['btc'] as num).toDouble(),
      ethereumDominance: (dominance['eth'] as num).toDouble(),
      fearAndGreedValue: (fearAndGreed['value'] as num).toInt(),
      fearAndGreedSentiment: fearAndGreed['sentiment'] as String,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (json['updated_at'] as num).toInt() * 1000,
      ),
    );
  }
}
