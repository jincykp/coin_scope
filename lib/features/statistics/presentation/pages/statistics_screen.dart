import 'package:coin_scope/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/data_sources/statistics_remote_data_source.dart';
import '../../data/repositories/statistics_repository_impl.dart';
import '../../domain/usecases/get_statistics.dart';
import '../bloc/statistics_bloc.dart';
import '../bloc/statistics_event.dart';
import '../bloc/statistics_state.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatisticsBloc(
        getStatistics: GetStatistics(
          repository: StatisticsRepositoryImpl(
            remoteDataSource: StatisticsRemoteDataSource(),
          ),
        ),
      )..add(const FetchStatisticsEvent()),
      child: const StatisticsView(),
    );
  }
}

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  String formatCurrency(double value) {
    return NumberFormat.compactCurrency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    ).format(value);
  }

  String formatNumber(int value) {
    return NumberFormat('#,##,###').format(value);
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDominanceCard({
    required String title,
    required double percentage,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${percentage.toStringAsFixed(2)}%',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFearGreedCard({required int value, required String sentiment}) {
    final Color sentimentColor;

    switch (sentiment.toLowerCase()) {
      case 'extreme_fear':
      case 'fear':
        sentimentColor = AppColors.error;
        break;
      case 'neutral':
        sentimentColor = AppColors.warning;
        break;
      case 'greed':
      case 'extreme_greed':
        sentimentColor = AppColors.success;
        break;
      default:
        sentimentColor = AppColors.textSecondary;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.psychology_outlined, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Fear & Greed Index',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$value',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sentiment.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        color: sentimentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Market sentiment',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (value / 100).clamp(0.0, 1.0),
              minHeight: 9,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(sentimentColor),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Extreme Fear',
                style: TextStyle(color: AppColors.textMuted, fontSize: 10),
              ),
              Text(
                'Extreme Greed',
                style: TextStyle(color: AppColors.textMuted, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsContent(StatisticsLoaded state) {
    final statistics = state.statistics;

    final marketChange = statistics.marketCapChangePercentage24h;
    final volumeChange = statistics.volumeChangePercentage24h;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Global Market Overview',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),

        // Market overview cards
        _buildStatCard(
          title: 'Total Market Cap',
          value: formatCurrency(statistics.totalMarketCap),
          icon: Icons.public,
          subtitle:
              '${marketChange >= 0 ? '+' : ''}${marketChange.toStringAsFixed(2)}% (24h)',
        ),
        const SizedBox(height: 12),

        _buildStatCard(
          title: '24h Trading Volume',
          value: formatCurrency(statistics.totalVolume),
          icon: Icons.bar_chart,
          subtitle:
              '${volumeChange >= 0 ? '+' : ''}${volumeChange.toStringAsFixed(2)}% volume change',
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Active Cryptocurrencies',
                value: formatNumber(statistics.activeCryptocurrencies),
                icon: Icons.currency_bitcoin,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Active Markets',
                value: formatNumber(statistics.markets),
                icon: Icons.storefront_outlined,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Text(
          'Market Dominance',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: _buildDominanceCard(
                title: 'Bitcoin (BTC)',
                percentage: statistics.bitcoinDominance,
                color: const Color(0xFFF7931A),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDominanceCard(
                title: 'Ethereum (ETH)',
                percentage: statistics.ethereumDominance,
                color: const Color(0xFF627EEA),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Text(
          'Market Sentiment',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),

        _buildFearGreedCard(
          value: statistics.fearAndGreedValue,
          sentiment: statistics.fearAndGreedSentiment,
        ),

        const SizedBox(height: 20),

        Text(
          'Last updated: ${DateFormat('dd MMM yyyy, hh:mm a').format(statistics.updatedAt.toLocal())}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            onPressed: () {
              context.read<StatisticsBloc>().add(
                const RefreshStatisticsEvent(),
              );
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh statistics',
          ),
        ],
      ),
      body: BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsInitial || state is StatisticsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is StatisticsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outlined,
                      color: AppColors.error,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<StatisticsBloc>().add(
                          const FetchStatisticsEvent(),
                        );
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is StatisticsLoaded) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                final bloc = context.read<StatisticsBloc>();

                bloc.add(const RefreshStatisticsEvent());

                await bloc.stream.firstWhere(
                  (state) =>
                      state is StatisticsLoaded || state is StatisticsError,
                );
              },
              child: _buildStatisticsContent(state),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
