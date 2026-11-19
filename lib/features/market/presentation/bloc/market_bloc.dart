import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_coins.dart';
import 'market_event.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final GetCoins getCoins;

  MarketBloc({required this.getCoins})
      : super(const MarketInitial()) {
    on<FetchCoinsEvent>(_onFetchCoins);
    on<RefreshCoinsEvent>(_onRefreshCoins);
  }

  Future<void> _onFetchCoins(
    FetchCoinsEvent event,
    Emitter<MarketState> emit,
  ) async {
    emit(const MarketLoading());

    try {
      final coins = await getCoins();

      if (coins.isEmpty) {
        emit(const MarketEmpty());
      } else {
        emit(MarketLoaded(coins));
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
      final coins = await getCoins();

      if (coins.isEmpty) {
        emit(const MarketEmpty());
      } else {
        emit(MarketLoaded(coins));
      }
    } catch (e) {
      emit(MarketError(e.toString()));
    }
  }
}