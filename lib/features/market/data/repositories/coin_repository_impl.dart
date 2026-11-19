import 'package:coin_scope/features/market/data/data_sources/coin_remote_data_source.dart';

import '../../domain/entities/coin.dart';
import '../../domain/repositories/coin_repository.dart';

class CoinRepositoryImpl implements CoinRepository {
  final CoinRemoteDataSource remoteDataSource;

  CoinRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Coin>> getCoins() async {
    return await remoteDataSource.getCoins();
  }
}