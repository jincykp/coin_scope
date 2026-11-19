import 'package:shared_preferences/shared_preferences.dart';

class WatchlistLocalDataSource {
  static const String _watchlistKey = 'watchlist_coin_ids';

  Future<List<String>> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_watchlistKey) ?? [];
  }

  Future<void> toggleWatchlist(String coinId) async {
    final prefs = await SharedPreferences.getInstance();

    final savedCoins = prefs.getStringList(_watchlistKey) ?? [];

    if (savedCoins.contains(coinId)) {
      savedCoins.remove(coinId);
    } else {
      savedCoins.add(coinId);
    }

    await prefs.setStringList(_watchlistKey, savedCoins);
  }
}