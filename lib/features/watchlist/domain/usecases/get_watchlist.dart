import '../repositories/watchlist_repository.dart';

class GetWatchlist {
  final WatchlistRepository repository;

  GetWatchlist({required this.repository});

  Future<List<String>> call() async {
    return await repository.getWatchlist();
  }
}