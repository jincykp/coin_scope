
class Statistics {
  final int activeCryptocurrencies;
  final int markets;
  final int ongoingIcos;
  final double totalMarketCap;
  final double totalVolume;
  final double marketCapChangePercentage24h;
  final double volumeChangePercentage24h;
  final double bitcoinDominance;
  final double ethereumDominance;
  final int fearAndGreedValue;
  final String fearAndGreedSentiment;
  final DateTime updatedAt;

  const Statistics({
    required this.activeCryptocurrencies,
    required this.markets,
    required this.ongoingIcos,
    required this.totalMarketCap,
    required this.totalVolume,
    required this.marketCapChangePercentage24h,
    required this.volumeChangePercentage24h,
    required this.bitcoinDominance,
    required this.ethereumDominance,
    required this.fearAndGreedValue,
    required this.fearAndGreedSentiment,
    required this.updatedAt,
  });
}
