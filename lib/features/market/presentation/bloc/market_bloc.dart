import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/coin.dart';
import '../../domain/usecases/get_coins.dart';
import 'market_event.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final GetCoins getCoins;

  List<Coin> _allCoins = [];

  String _searchQuery = '';
  MarketFilter _selectedFilter = MarketFilter.all;
  MarketSort _selectedSort = MarketSort.marketCapHighToLow;

  MarketBloc({required this.getCoins}) : super(const MarketInitial()) {
    on<FetchCoinsEvent>(_onFetchCoins);
    on<RefreshCoinsEvent>(_onRefreshCoins);
    on<SearchCoinsEvent>(_onSearchCoins);
    on<UpdateMarketFilterEvent>(_onUpdateFilter);
    on<UpdateMarketSortEvent>(_onUpdateSort);
  }

  Future<void> _onFetchCoins(
    FetchCoinsEvent event,
    Emitter<MarketState> emit,
  ) async {
    emit(const MarketLoading());

    try {
      _allCoins = await getCoins();
      _emitFilteredCoins(emit);
    } catch (e) {
      emit(MarketError(_getErrorMessage(e)));
    }
  }

  Future<void> _onRefreshCoins(
    RefreshCoinsEvent event,
    Emitter<MarketState> emit,
  ) async {
    try {
      _allCoins = await getCoins();
      _emitFilteredCoins(emit);
    } catch (e) {
      emit(MarketError(_getErrorMessage(e)));
    }
  }

  void _onSearchCoins(SearchCoinsEvent event, Emitter<MarketState> emit) {
    _searchQuery = event.query.trim();
    _emitFilteredCoins(emit);
  }

  void _onUpdateFilter(
    UpdateMarketFilterEvent event,
    Emitter<MarketState> emit,
  ) {
    _selectedFilter = event.filter;
    _emitFilteredCoins(emit);
  }

  void _onUpdateSort(UpdateMarketSortEvent event, Emitter<MarketState> emit) {
    _selectedSort = event.sort;
    _emitFilteredCoins(emit);
  }

  // Apply search, filter, and sorting together.
  void _emitFilteredCoins(Emitter<MarketState> emit) {
    List<Coin> filteredCoins = List.from(_allCoins);

    // 1. Search by coin name or symbol.
    if (_searchQuery.isNotEmpty) {
      filteredCoins = filteredCoins.where((coin) {
        return coin.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            coin.symbol.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // 2. Apply gainers or losers filter.
    switch (_selectedFilter) {
      case MarketFilter.all:
        break;

      case MarketFilter.gainers:
        filteredCoins = filteredCoins.where((coin) {
          return (coin.priceChangePercentage24h ?? 0) > 0;
        }).toList();
        break;

      case MarketFilter.losers:
        filteredCoins = filteredCoins.where((coin) {
          return (coin.priceChangePercentage24h ?? 0) < 0;
        }).toList();
        break;
    }

    // 3. Apply sorting.
    switch (_selectedSort) {
      case MarketSort.marketCapHighToLow:
        filteredCoins.sort((a, b) => b.marketCap.compareTo(a.marketCap));
        break;

      case MarketSort.priceHighToLow:
        filteredCoins.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
        break;

      case MarketSort.priceLowToHigh:
        filteredCoins.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
        break;

      case MarketSort.changeHighToLow:
        filteredCoins.sort(
          (a, b) => (b.priceChangePercentage24h ?? 0).compareTo(
            a.priceChangePercentage24h ?? 0,
          ),
        );
        break;

      case MarketSort.changeLowToHigh:
        filteredCoins.sort(
          (a, b) => (a.priceChangePercentage24h ?? 0).compareTo(
            b.priceChangePercentage24h ?? 0,
          ),
        );
        break;
    }

    // 4. Emit the final result.
    if (filteredCoins.isEmpty) {
      emit(
        MarketEmpty(
          searchQuery: _searchQuery,
          selectedFilter: _selectedFilter,
          selectedSort: _selectedSort,
        ),
      );
    } else {
      emit(
        MarketLoaded(
          filteredCoins,
          searchQuery: _searchQuery,
          selectedFilter: _selectedFilter,
          selectedSort: _selectedSort,
        ),
      );
    }
  }

  String _getErrorMessage(Object error) {
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
            return 'Unable to load cryptocurrencies. Please try again.';
        }

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.badCertificate:
        return 'Secure connection failed.';

      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }

  return 'Unable to load cryptocurrencies. Please try again.';
}
}
