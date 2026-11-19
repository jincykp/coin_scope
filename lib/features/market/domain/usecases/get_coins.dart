import '../entities/coin.dart';
import '../repositories/coin_repository.dart';

class GetCoins {
  final CoinRepository repository;

  GetCoins({required this.repository});

  Future<List<Coin>> call() async {
    return await repository.getCoins();
  }
}