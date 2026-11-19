import '../../domain/entities/coin_details.dart';
import '../../domain/repositories/coin_details_repository.dart';
import '../data_sources/coin_details_remote_data_source.dart';

class CoinDetailsRepositoryImpl implements CoinDetailsRepository {
  final CoinDetailsRemoteDataSource remoteDataSource;

  CoinDetailsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<CoinDetails> getCoinDetails(String coinId) async {
    return await remoteDataSource.getCoinDetails(coinId);
  }
}