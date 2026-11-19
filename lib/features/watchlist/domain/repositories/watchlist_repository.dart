abstract class WatchlistRepository {
  Future<List<String>> getWatchlist();

  Future<void> toggleWatchlist(String coinId);
}