import '../repositories/watchlist_repository.dart';

class ToggleWatchlist {
  final WatchlistRepository repository;

  ToggleWatchlist({required this.repository});

  Future<void> call(String coinId) async {
    await repository.toggleWatchlist(coinId);
  }
}