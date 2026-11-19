import 'package:coin_scope/core/routes/app_routes.dart';
import 'package:coin_scope/features/market/data/data_sources/coin_remote_data_source.dart';
import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_bloc.dart';
import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_event.dart';
import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/coin_repository_impl.dart';
import '../../domain/usecases/get_coins.dart';
import '../bloc/market_bloc.dart';
import '../bloc/market_event.dart';
import '../bloc/market_state.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MarketBloc(
        getCoins: GetCoins(
          repository: CoinRepositoryImpl(
            remoteDataSource: CoinRemoteDataSource(),
          ),
        ),
      )..add(const FetchCoinsEvent()),
      child: const MarketView(),
    );
  }
}

class MarketView extends StatefulWidget {
  const MarketView({super.key});

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {
  final TextEditingController _searchController = TextEditingController();

  String formatPrice(double price) {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: price < 1 ? 4 : 2,
    ).format(price);
  }

  String formatMarketCap(double value) {
    return NumberFormat.compactCurrency(
      locale: 'en_US',
      symbol: '\$',
    ).format(value);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchCoins(String query) {
    context.read<MarketBloc>().add(SearchCoinsEvent(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Crypto Market'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            onPressed: () {
              _searchController.clear();
              _searchCoins('');
              context.read<MarketBloc>().add(const RefreshCoinsEvent());
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              // onChanged: _searchCoins,
              onChanged: (value) {
                setState(() {});
                _searchCoins(value);
              },
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search coins by name or symbol',
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _searchCoins('');
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),

          // Coin List
          Expanded(
            child: BlocBuilder<MarketBloc, MarketState>(
              builder: (context, state) {
                if (state is MarketInitial || state is MarketLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (state is MarketError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<MarketBloc>().add(
                              const FetchCoinsEvent(),
                            );
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is MarketEmpty) {
                  return Center(
                    child: Text(
                      _searchController.text.isNotEmpty
                          ? 'No coins found'
                          : 'No coins available',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                if (state is MarketLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<MarketBloc>().add(const RefreshCoinsEvent());
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.coins.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final coin = state.coins[index];

                        final isPositive =
                            (coin.priceChangePercentage24h ?? 0) >= 0;

                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.coinDetails,
                              arguments: coin.id,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Image.network(
                                  coin.image,
                                  width: 42,
                                  height: 42,
                                  errorBuilder: (_, __, ___) {
                                    return const Icon(
                                      Icons.currency_bitcoin,
                                      color: AppColors.textSecondary,
                                      size: 40,
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        coin.name,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        coin.symbol.toUpperCase(),
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Market cap: ${formatMarketCap(coin.marketCap)}',
                                        style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      formatPrice(coin.currentPrice),
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '${isPositive ? '+' : ''}${(coin.priceChangePercentage24h ?? 0).toStringAsFixed(2)}%',
                                      style: TextStyle(
                                        color: isPositive
                                            ? AppColors.success
                                            : AppColors.error,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    const SizedBox(width: 4),

                                    BlocBuilder<WatchlistBloc, WatchlistState>(
                                      builder: (context, watchlistState) {
                                        final isFavorite =
                                            watchlistState is WatchlistLoaded &&
                                            watchlistState.favoriteIds.contains(
                                              coin.id,
                                            );

                                        return IconButton(
                                          onPressed: () {
                                            context.read<WatchlistBloc>().add(
                                              ToggleWatchlistEvent(coin.id),
                                            );
                                          },
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isFavorite
                                                ? AppColors.error
                                                : AppColors.textSecondary,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
