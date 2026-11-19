class CoinDetails {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final String description;
  final String website;

  final double currentPrice;
  final double marketCap;
  final double totalVolume;
  final double high24h;
  final double low24h;

  final double ath;
  final double atl;

  final double circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;

  final double priceChangePercentage24h;
  final double priceChangePercentage7d;

  final DateTime? lastUpdated;

  const CoinDetails({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.description,
    required this.website,
    required this.currentPrice,
    required this.marketCap,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.ath,
    required this.atl,
    required this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    required this.priceChangePercentage24h,
    required this.priceChangePercentage7d,
    this.lastUpdated,
  });
}