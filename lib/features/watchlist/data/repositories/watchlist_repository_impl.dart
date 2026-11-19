import '../../domain/repositories/watchlist_repository.dart';
import '../data_sources/watchlist_local_data_source.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  WatchlistRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<String>> getWatchlist() async {
    return await localDataSource.getWatchlist();
  }

  @override
  Future<void> toggleWatchlist(String coinId) async {
    await localDataSource.toggleWatchlist(coinId);
  }
}