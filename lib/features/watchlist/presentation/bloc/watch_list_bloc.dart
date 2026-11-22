import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_event.dart';
import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_state.dart';
import 'package:dio/dio.dart';
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
      emit(WatchlistError(_getErrorMessage(e)));
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
      emit(WatchlistError(_getErrorMessage(e)));
    }
  }String _getErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Please check your internet connection and try again.';

      case DioExceptionType.transformTimeout:
        return 'Request took too long. Please try again.';

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        switch (statusCode) {
          case 401:
            return 'Unauthorized. Please check your API key.';
          case 429:
            return 'Too many requests. Please try again later.';
          case 500:
          case 502:
          case 503:
          case 504:
            return 'Server is currently unavailable. Please try again later.';
          default:
            return 'Unable to load watchlist. Please try again.';
        }

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.badCertificate:
        return 'Secure connection failed.';

      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }

  return 'Unable to load watchlist. Please try again.';
}
}