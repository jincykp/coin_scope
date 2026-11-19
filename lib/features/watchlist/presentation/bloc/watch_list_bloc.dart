import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_event.dart';
import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_watchlist.dart';
import '../../domain/usecases/toggle_watchlist.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlist getWatchlist;
  final ToggleWatchlist toggleWatchlist;

  WatchlistBloc({
    required this.getWatchlist,
    required this.toggleWatchlist,
  }) : super(const WatchlistInitial()) {
    on<LoadWatchlistEvent>(_onLoadWatchlist);
    on<ToggleWatchlistEvent>(_onToggleWatchlist);
  }

  Future<void> _onLoadWatchlist(
    LoadWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(const WatchlistLoading());

    try {
      final savedIds = await getWatchlist();

      emit(WatchlistLoaded(savedIds.toSet()));
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onToggleWatchlist(
    ToggleWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    try {
      await toggleWatchlist(event.coinId);

      final savedIds = await getWatchlist();

      emit(WatchlistLoaded(savedIds.toSet()));
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }
}