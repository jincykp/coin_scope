
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/data_sources/coin_chart_remote_data_source.dart';
import '../../data/repositories/coin_chart_repository_impl.dart';
import '../../domain/usecases/get_coin_chart.dart';
import '../bloc/coin_chart_bloc.dart';
import '../bloc/coin_chart_event.dart';
import '../bloc/coin_chart_state.dart';

class CoinPriceChart extends StatelessWidget {
  final String coinId;

  const CoinPriceChart({
    super.key,
    required this.coinId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoinChartBloc(
        getCoinChart: GetCoinChart(
          repository: CoinChartRepositoryImpl(
            remoteDataSource: CoinChartRemoteDataSource(),
          ),
        ),
      )..add(
          FetchCoinChartEvent(
            coinId: coinId,
            days: 7,
          ),
        ),
      child: CoinPriceChartView(coinId: coinId),
    );
  }
}

class CoinPriceChartView extends StatefulWidget {
  final String coinId;

  const CoinPriceChartView({
    super.key,
    required this.coinId,
  });

  @override
  State<CoinPriceChartView> createState() =>
      _CoinPriceChartViewState();
}

class _CoinPriceChartViewState extends State<CoinPriceChartView> {
  int selectedDays = 7;

  final List<Map<String, dynamic>> periods = [
    {'label': '1D', 'days': 1},
    {'label': '7D', 'days': 7},
    {'label': '1M', 'days': 30},
    {'label': '3M', 'days': 90},
    {'label': '1Y', 'days': 365},
  ];

  void changePeriod(int days) {
    setState(() {
      selectedDays = days;
    });

    context.read<CoinChartBloc>().add(
          FetchCoinChartEvent(
            coinId: widget.coinId,
            days: days,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Chart',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Period selection
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: periods.map((period) {
            final days = period['days'] as int;
            final isSelected = selectedDays == days;

            return GestureDetector(
              onTap: () => changePeriod(days),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  period['label'] as String,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.background
                        : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        BlocBuilder<CoinChartBloc, CoinChartState>(
          builder: (context, state) {
            if (state is CoinChartInitial ||
                state is CoinChartLoading) {
              return const SizedBox(
                height: 250,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              );
            }

            if (state is CoinChartError) {
              return SizedBox(
                height: 250,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 35,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => changePeriod(selectedDays),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is CoinChartLoaded) {
              final prices = state.chart.prices;

              if (prices.isEmpty) {
                return const SizedBox(
                  height: 250,
                  child: Center(
                    child: Text(
                      'No chart data available.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }

              final spots = prices.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value.value,
                );
              }).toList();

              final values = prices.map((point) => point.value);
              final minPrice = values.reduce(
                (a, b) => a < b ? a : b,
              );
              final maxPrice = values.reduce(
                (a, b) => a > b ? a : b,
              );

              final difference = maxPrice - minPrice;
              final padding = difference == 0
                  ? maxPrice.abs() * 0.01 + 0.01
                  : difference * 0.15;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 230,
                    child: LineChart(
                      LineChartData(
                        minY: minPrice - padding,
                        maxY: maxPrice + padding,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: AppColors.divider,
                              strokeWidth: 0.5,
                            );
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 65,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  NumberFormat.compact().format(value),
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 10,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: (prices.length / 4)
                                  .ceilToDouble()
                                  .clamp(1, double.infinity),
                              getTitlesWidget: (value, meta) {
                                final index = value.round();

                                if (index < 0 ||
                                    index >= prices.length) {
                                  return const SizedBox.shrink();
                                }

                                final date = prices[index].timestamp
                                    .toLocal();

                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    selectedDays == 1
                                        ? DateFormat('HH:mm').format(date)
                                        : DateFormat('dd MMM').format(date),
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 9,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((spot) {
                                final index = spot.x.round();

                                if (index < 0 ||
                                    index >= prices.length) {
                                  return null;
                                }

                                final point = prices[index];

                                return LineTooltipItem(
                                  '${NumberFormat.currency(
                                    symbol: '\$',
                                    decimalDigits: 2,
                                  ).format(point.value)}\n'
                                  '${DateFormat('dd MMM, HH:mm').format(point.timestamp.toLocal())}',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: AppColors.primary,
                            barWidth: 2.5,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.primary.withValues(
                                alpha: 0.12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Showing ${prices.length} price points',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
