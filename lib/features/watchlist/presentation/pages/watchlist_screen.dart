
import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_bloc.dart';
import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_event.dart';
import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../market/data/data_sources/coin_remote_data_source.dart';
import '../../../market/data/repositories/coin_repository_impl.dart';
import '../../../market/domain/entities/coin.dart';
import '../../../market/domain/usecases/get_coins.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late Future<List<Coin>> _coinsFuture;

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  void _loadCoins() {
    final getCoins = GetCoins(
      repository: CoinRepositoryImpl(
        remoteDataSource: CoinRemoteDataSource(),
      ),
    );

    _coinsFuture = getCoins();
  }

  Future<void> _refreshCoins() async {
    setState(() {
      _loadCoins();
    });

    await _coinsFuture;
  }

  String formatPrice(double price) {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: price < 1 ? 4 : 2,
    ).format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Watchlist'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            onPressed: _refreshCoins,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistInitial ||
              state is WatchlistLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (state is WatchlistError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  color: AppColors.error,
                ),
              ),
            );
          }

          if (state is WatchlistLoaded) {
            if (state.favoriteIds.isEmpty) {
              return const Center(
                child: Text(
                  'Your watchlist is empty',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }

            return FutureBuilder<List<Coin>>(
              future: _coinsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to load coins: ${snapshot.error}',
                      style: const TextStyle(
                        color: AppColors.error,
                      ),
                    ),
                  );
                }

                final allCoins = snapshot.data ?? [];

                final favoriteCoins = allCoins
                    .where(
                      (coin) => state.favoriteIds.contains(coin.id),
                    )
                    .toList();

                if (favoriteCoins.isEmpty) {
                  return const Center(
                    child: Text(
                      'No saved coins found in the market data.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshCoins,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: favoriteCoins.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final coin = favoriteCoins[index];

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
                                errorBuilder: (_, __, ___) =>
                                    const Icon(
                                  Icons.currency_bitcoin,
                                  color: AppColors.textSecondary,
                                  size: 40,
                                ),
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
                                  ],
                                ),
                              ),

                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
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
                                    ),
                                  ),
                                ],
                              ),

                              IconButton(
                                onPressed: () {
                                  context.read<WatchlistBloc>().add(
                                    ToggleWatchlistEvent(coin.id),
                                  );
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
