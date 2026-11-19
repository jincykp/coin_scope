import '../../domain/entities/coin_details.dart';

class CoinDetailsModel extends CoinDetails {
  const CoinDetailsModel({
    required super.id,
    required super.name,
    required super.symbol,
    required super.image,
    required super.description,
    required super.website,
    required super.currentPrice,
    required super.marketCap,
    required super.totalVolume,
    required super.high24h,
    required super.low24h,
    required super.ath,
    required super.atl,
    required super.circulatingSupply,
    super.totalSupply,
    super.maxSupply,
    required super.priceChangePercentage24h,
    required super.priceChangePercentage7d,
    super.lastUpdated,
  });

  factory CoinDetailsModel.fromJson(Map<String, dynamic> json) {
    final marketData =
        json['market_data'] as Map<String, dynamic>? ?? {};

    final imageData =
        json['image'] as Map<String, dynamic>? ?? {};

    final links =
        json['links'] as Map<String, dynamic>? ?? {};

    final description =
        json['description'] as Map<String, dynamic>? ?? {};

    final currentPrice =
        marketData['current_price'] as Map<String, dynamic>? ?? {};

    final marketCap =
        marketData['market_cap'] as Map<String, dynamic>? ?? {};

    final high24h =
        marketData['high_24h'] as Map<String, dynamic>? ?? {};

    final low24h =
        marketData['low_24h'] as Map<String, dynamic>? ?? {};

    final ath =
        marketData['ath'] as Map<String, dynamic>? ?? {};

    final atl =
        marketData['atl'] as Map<String, dynamic>? ?? {};

    final homepage = links['homepage'] as List? ?? [];

    double getDouble(Map<String, dynamic> map, String key) {
      return (map[key] as num?)?.toDouble() ?? 0.0;
    }

    double? getNullableDouble(String key) {
      return (marketData[key] as num?)?.toDouble();
    }

    return CoinDetailsModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      image: imageData['large'] ?? '',
      description: description['en'] ?? '',
      website: homepage
          .whereType<String>()
          .firstWhere(
            (url) => url.isNotEmpty,
            orElse: () => '',
          ),

      currentPrice: getDouble(currentPrice, 'usd'),
      marketCap: getDouble(marketCap, 'usd'),
      totalVolume: getDouble(
        marketData['total_volume'] as Map<String, dynamic>? ?? {},
        'usd',
      ),
      high24h: getDouble(high24h, 'usd'),
      low24h: getDouble(low24h, 'usd'),

      ath: getDouble(ath, 'usd'),
      atl: getDouble(atl, 'usd'),

      circulatingSupply:
          getNullableDouble('circulating_supply') ?? 0.0,
      totalSupply: getNullableDouble('total_supply'),
      maxSupply: getNullableDouble('max_supply'),

      priceChangePercentage24h:
          getNullableDouble('price_change_percentage_24h') ?? 0.0,
      priceChangePercentage7d:
          getNullableDouble('price_change_percentage_7d') ?? 0.0,

      lastUpdated: DateTime.tryParse(
        json['last_updated'] ?? '',
      ),
    );
  }
}