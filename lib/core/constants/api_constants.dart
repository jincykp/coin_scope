class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl =
      'https://api.coingecko.com/api/v3';

  // Market
  static const String coins = '/coins/markets';

  // Coin Details
  static String coinDetails(String coinId) =>
      '/coins/$coinId';

  // Coin Price Chart
  static String coinMarketChart(String coinId) =>
      '/coins/$coinId/market_chart';

  // Global Market Statistics
  static const String global = '/global';
  
}