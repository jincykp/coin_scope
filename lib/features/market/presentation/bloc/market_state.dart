
import 'package:equatable/equatable.dart';

import '../../domain/entities/coin.dart';
import 'market_event.dart';

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
  final MarketFilter selectedFilter;
  final MarketSort selectedSort;

  const MarketLoaded(
    this.coins, {
    this.searchQuery = '',
    this.selectedFilter = MarketFilter.all,
    this.selectedSort = MarketSort.marketCapHighToLow,
  });

  @override
  List<Object?> get props => [
        coins,
        searchQuery,
        selectedFilter,
        selectedSort,
      ];
}

class MarketError extends MarketState {
  final String message;

  const MarketError(this.message);

  @override
  List<Object?> get props => [message];
}

class MarketEmpty extends MarketState {
  final String searchQuery;
  final MarketFilter selectedFilter;
  final MarketSort selectedSort;

  const MarketEmpty({
    this.searchQuery = '',
    this.selectedFilter = MarketFilter.all,
    this.selectedSort = MarketSort.marketCapHighToLow,
  });

  @override
  List<Object?> get props => [
        searchQuery,
        selectedFilter,
        selectedSort,
      ];
}
