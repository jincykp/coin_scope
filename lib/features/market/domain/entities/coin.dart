class Coin {
  final String id;
  final String symbol;
  final String name;
  final String image;

  final double currentPrice;
  final double marketCap;
  final int? marketCapRank;
  final double fullyDilutedValuation;
  final double totalVolume;

  final double? high24h;
  final double? low24h;
  final double? priceChange24h;
  final double? priceChangePercentage24h;

  final double? marketCapChange24h;
  final double? marketCapChangePercentage24h;

  final double circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;

  final double? ath;
  final double? athChangePercentage;
  final String? athDate;

  final double? atl;
  final double? atlChangePercentage;
  final String? atlDate;

  final String? lastUpdated;

  final double? priceChangePercentage1h;
  final double? priceChangePercentage7d;
  final double? priceChangePercentage14d;
  final double? priceChangePercentage30d;
  final double? priceChangePercentage200d;
  final double? priceChangePercentage1y;

  final List<double> sparklinePrices;

  const Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    this.marketCapRank,
    required this.fullyDilutedValuation,
    required this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.marketCapChange24h,
    this.marketCapChangePercentage24h,
    required this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
    this.lastUpdated,
    this.priceChangePercentage1h,
    this.priceChangePercentage7d,
    this.priceChangePercentage14d,
    this.priceChangePercentage30d,
    this.priceChangePercentage200d,
    this.priceChangePercentage1y,
    this.sparklinePrices = const [],
  });
}