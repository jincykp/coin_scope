import '../../domain/entities/coin.dart';

class CoinModel extends Coin {
  const CoinModel({
    required super.id,
    required super.symbol,
    required super.name,
    required super.image,
    required super.currentPrice,
    required super.marketCap,
    super.marketCapRank,
    required super.fullyDilutedValuation,
    required super.totalVolume,
    super.high24h,
    super.low24h,
    super.priceChange24h,
    super.priceChangePercentage24h,
    super.marketCapChange24h,
    super.marketCapChangePercentage24h,
    required super.circulatingSupply,
    super.totalSupply,
    super.maxSupply,
    super.ath,
    super.athChangePercentage,
    super.athDate,
    super.atl,
    super.atlChangePercentage,
    super.atlDate,
    super.lastUpdated,
    super.priceChangePercentage1h,
    super.priceChangePercentage7d,
    super.priceChangePercentage14d,
    super.priceChangePercentage30d,
    super.priceChangePercentage200d,
    super.priceChangePercentage1y,
    super.sparklinePrices,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) =>
        (value as num?)?.toDouble() ?? 0.0;

    double? toNullableDouble(dynamic value) =>
        (value as num?)?.toDouble();

    final sparkline = json['sparkline_in_7d'] as Map<String, dynamic>?;

    return CoinModel(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',

      currentPrice: toDouble(json['current_price']),
      marketCap: toDouble(json['market_cap']),
      marketCapRank: json['market_cap_rank'] as int?,
      fullyDilutedValuation:
          toDouble(json['fully_diluted_valuation']),
      totalVolume: toDouble(json['total_volume']),

      high24h: toNullableDouble(json['high_24h']),
      low24h: toNullableDouble(json['low_24h']),
      priceChange24h: toNullableDouble(json['price_change_24h']),
      priceChangePercentage24h:
          toNullableDouble(json['price_change_percentage_24h']),

      marketCapChange24h:
          toNullableDouble(json['market_cap_change_24h']),
      marketCapChangePercentage24h:
          toNullableDouble(json['market_cap_change_percentage_24h']),

      circulatingSupply: toDouble(json['circulating_supply']),
      totalSupply: toNullableDouble(json['total_supply']),
      maxSupply: toNullableDouble(json['max_supply']),

      ath: toNullableDouble(json['ath']),
      athChangePercentage:
          toNullableDouble(json['ath_change_percentage']),
      athDate: json['ath_date'],

      atl: toNullableDouble(json['atl']),
      atlChangePercentage:
          toNullableDouble(json['atl_change_percentage']),
      atlDate: json['atl_date'],

      lastUpdated: json['last_updated'],

      priceChangePercentage1h:
          toNullableDouble(json['price_change_percentage_1h_in_currency']),
      priceChangePercentage7d:
          toNullableDouble(json['price_change_percentage_7d_in_currency']),
      priceChangePercentage14d:
          toNullableDouble(json['price_change_percentage_14d_in_currency']),
      priceChangePercentage30d:
          toNullableDouble(json['price_change_percentage_30d_in_currency']),
      priceChangePercentage200d:
          toNullableDouble(json['price_change_percentage_200d_in_currency']),
      priceChangePercentage1y:
          toNullableDouble(json['price_change_percentage_1y_in_currency']),

      sparklinePrices: (sparkline?['price'] as List<dynamic>?)
              ?.map((price) => toDouble(price))
              .toList() ??
          [],
    );
  }
}