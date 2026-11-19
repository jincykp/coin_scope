
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/coin.dart';
import '../../domain/usecases/get_coins.dart';
import 'market_event.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final GetCoins getCoins;

  List<Coin> _allCoins = [];

  MarketBloc({required this.getCoins})
      : super(const MarketInitial()) {
    on<FetchCoinsEvent>(_onFetchCoins);
    on<RefreshCoinsEvent>(_onRefreshCoins);
    on<SearchCoinsEvent>(_onSearchCoins);
  }

  Future<void> _onFetchCoins(
    FetchCoinsEvent event,
    Emitter<MarketState> emit,
  ) async {
    emit(const MarketLoading());

    try {
      _allCoins = await getCoins();

      if (_allCoins.isEmpty) {
        emit(const MarketEmpty());
      } else {
        emit(MarketLoaded(_allCoins));
      }
    } catch (e) {
      emit(MarketError(e.toString()));
    }
  }

  Future<void> _onRefreshCoins(
    RefreshCoinsEvent event,
    Emitter<MarketState> emit,
  ) async {
    try {
      _allCoins = await getCoins();

      if (_allCoins.isEmpty) {
        emit(const MarketEmpty());
      } else {
        emit(MarketLoaded(_allCoins));
      }
    } catch (e) {
      emit(MarketError(e.toString()));
    }
  }

  void _onSearchCoins(
    SearchCoinsEvent event,
    Emitter<MarketState> emit,
  ) {
    final query = event.query.trim().toLowerCase();

    final filteredCoins = _allCoins.where((coin) {
      return coin.name.toLowerCase().contains(query) ||
          coin.symbol.toLowerCase().contains(query);
    }).toList();

    if (filteredCoins.isEmpty) {
      emit(const MarketEmpty());
    } else {
      emit(MarketLoaded(
        filteredCoins,
        searchQuery: event.query,
      ));
    }
  }
}
