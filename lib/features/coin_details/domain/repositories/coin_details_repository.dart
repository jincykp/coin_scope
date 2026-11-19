import '../entities/coin_details.dart';

abstract class CoinDetailsRepository {
  Future<CoinDetails> getCoinDetails(String coinId);
}