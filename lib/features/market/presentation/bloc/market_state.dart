
import 'package:equatable/equatable.dart';

import '../../domain/entities/coin.dart';

abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object?> get props => [];
}

class MarketInitial extends MarketState {
  const MarketInitial();
}

class MarketLoading extends MarketState {
  const MarketLoading();
}

class MarketLoaded extends MarketState {
  final List<Coin> coins;
  final String searchQuery;

  const MarketLoaded(
    this.coins, {
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [coins, searchQuery];
}

class MarketError extends MarketState {
  final String message;

  const MarketError(this.message);

  @override
  List<Object?> get props => [message];
}

class MarketEmpty extends MarketState {
  const MarketEmpty();
}
