
import 'package:equatable/equatable.dart';

abstract class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object?> get props => [];
}

// Filter options
enum MarketFilter {
  all,
  gainers,
  losers,
}

// Sorting options
enum MarketSort {
  marketCapHighToLow,
  priceHighToLow,
  priceLowToHigh,
  changeHighToLow,
  changeLowToHigh,
}

class FetchCoinsEvent extends MarketEvent {
  const FetchCoinsEvent();
}

class RefreshCoinsEvent extends MarketEvent {
  const RefreshCoinsEvent();
}

class SearchCoinsEvent extends MarketEvent {
  final String query;

  const SearchCoinsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class UpdateMarketFilterEvent extends MarketEvent {
  final MarketFilter filter;

  const UpdateMarketFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class UpdateMarketSortEvent extends MarketEvent {
  final MarketSort sort;

  const UpdateMarketSortEvent(this.sort);

  @override
  List<Object?> get props => [sort];
}
