import '../entities/coin_details.dart';
import '../repositories/coin_details_repository.dart';

class GetCoinDetails {
  final CoinDetailsRepository repository;

  GetCoinDetails({required this.repository});

  Future<CoinDetails> call(String coinId) async {
    return await repository.getCoinDetails(coinId);
  }
}