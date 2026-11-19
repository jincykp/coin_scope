import 'package:coin_scope/features/market/data/data_sources/coin_remote_data_source.dart';
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

class MarketView extends StatelessWidget {
  const MarketView({super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Crypto Market'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            onPressed: () {
              context.read<MarketBloc>().add(
                    const RefreshCoinsEvent(),
                  );
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<MarketBloc, MarketState>(
        builder: (context, state) {
          if (state is MarketInitial || state is MarketLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
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
            return const Center(
              child: Text(
                'No coins available',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          if (state is MarketLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<MarketBloc>().add(
                      const RefreshCoinsEvent(),
                    );
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.coins.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final coin = state.coins[index];
                  final isPositive =
                      (coin.priceChangePercentage24h ?? 0) >= 0;

                  return Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}