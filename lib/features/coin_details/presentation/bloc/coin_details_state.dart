import '../../domain/entities/coin_details.dart';

abstract class CoinDetailsState {}

class CoinDetailsInitial extends CoinDetailsState {}

class CoinDetailsLoading extends CoinDetailsState {}

class CoinDetailsLoaded extends CoinDetailsState {
  final CoinDetails coinDetails;

  CoinDetailsLoaded(this.coinDetails);
}

class CoinDetailsError extends CoinDetailsState {
  final String message;

  CoinDetailsError(this.message);
}