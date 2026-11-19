import 'package:coin_scope/features/coin_chart/presentation/widgets/coin_price_chart.dart';
import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_bloc.dart';
import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_event.dart';
import 'package:coin_scope/features/watchlist/presentation/bloc/watch_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/data_sources/coin_details_remote_data_source.dart';
import '../../data/repositories/coin_details_repository_impl.dart';
import '../../domain/usecases/get_coin_details.dart';
import '../bloc/coin_details_bloc.dart';
import '../bloc/coin_details_event.dart';
import '../bloc/coin_details_state.dart';

class CoinDetailsScreen extends StatelessWidget {
  final String coinId;

  const CoinDetailsScreen({super.key, required this.coinId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoinDetailsBloc(
        getCoinDetails: GetCoinDetails(
          repository: CoinDetailsRepositoryImpl(
            remoteDataSource: CoinDetailsRemoteDataSource(),
          ),
        ),
      )..add(FetchCoinDetailsEvent(coinId)),
      child: CoinDetailsView(coinId: coinId),
    );
  }
}

class CoinDetailsView extends StatelessWidget {
  final String coinId;

  const CoinDetailsView({super.key, required this.coinId});

  String formatPrice(double value) {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: value < 1 ? 4 : 2,
    ).format(value);
  }

  String formatCompact(double value) {
    return NumberFormat.compactCurrency(
      locale: 'en_US',
      symbol: '\$',
    ).format(value);
  }

  String formatSupply(double? value) {
    if (value == null) return 'Unlimited / Not available';
    return NumberFormat('#,##0.##').format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
    appBar: AppBar(
  title: const Text('Coin Details'),
  backgroundColor: AppColors.background,
  actions: [
    BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, watchlistState) {
        final isFavorite =
            watchlistState is WatchlistLoaded &&
            watchlistState.favoriteIds.contains(coinId);

        return IconButton(
          onPressed: () {
            context.read<WatchlistBloc>().add(
              ToggleWatchlistEvent(coinId),
            );
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite
                ? AppColors.error
                : AppColors.textSecondary,
          ),
        );
      },
    ),
  ],
),
      body: BlocBuilder<CoinDetailsBloc, CoinDetailsState>(
        builder: (context, state) {
          if (state is CoinDetailsInitial || state is CoinDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is CoinDetailsError) {
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
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CoinDetailsBloc>().add(
                        FetchCoinDetailsEvent(coinId),
                      );
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is CoinDetailsLoaded) {
            final coin = state.coinDetails;
            final isPositive = coin.priceChangePercentage24h >= 0;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<CoinDetailsBloc>().add(
                  FetchCoinDetailsEvent(coinId),
                );
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Coin information
                  Row(
                    children: [
                      Image.network(
                        coin.image,
                        width: 52,
                        height: 52,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.currency_bitcoin,
                          color: AppColors.textSecondary,
                          size: 45,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coin.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              coin.symbol.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Current price
                  Text(
                    formatPrice(coin.currentPrice),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${isPositive ? '+' : ''}${coin.priceChangePercentage24h.toStringAsFixed(2)}% (24h)',
                    style: TextStyle(
                      color: isPositive ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 28),
                  CoinPriceChart(coinId: coin.id),
                  const SizedBox(height: 28),

                  // Market statistics
                  const Text(
                    'Market Statistics',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _infoCard([
                    _infoRow('Market Cap', formatCompact(coin.marketCap)),
                    _infoRow('24h Volume', formatCompact(coin.totalVolume)),
                    _infoRow('24h High', formatPrice(coin.high24h)),
                    _infoRow('24h Low', formatPrice(coin.low24h)),
                    _infoRow('All-Time High', formatPrice(coin.ath)),
                    _infoRow('All-Time Low', formatPrice(coin.atl)),
                  ]),

                  const SizedBox(height: 24),

                  // Supply information
                  const Text(
                    'Supply Information',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _infoCard([
                    _infoRow(
                      'Circulating Supply',
                      formatSupply(coin.circulatingSupply),
                    ),
                    _infoRow('Total Supply', formatSupply(coin.totalSupply)),
                    _infoRow('Max Supply', formatSupply(coin.maxSupply)),
                  ]),

                  const SizedBox(height: 24),

                  // Price changes
                  const Text(
                    'Price Changes',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _infoCard([
                    _infoRow(
                      '24 Hours',
                      '${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                    ),
                    _infoRow(
                      '7 Days',
                      '${coin.priceChangePercentage7d.toStringAsFixed(2)}%',
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'About',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      coin.description.isEmpty
                          ? 'No description available.'
                          : coin.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Website
                  if (coin.website.isNotEmpty) ...[
                    const Text(
                      'Official Website',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: SelectableText(
                        coin.website,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  if (coin.lastUpdated != null)
                    Text(
                      'Last updated: ${DateFormat('dd MMM yyyy, hh:mm a').format(coin.lastUpdated!.toLocal())}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
