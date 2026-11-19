
import '../../domain/entities/coin_chart.dart';
import '../../domain/repositories/coin_chart_repository.dart';
import '../data_sources/coin_chart_remote_data_source.dart';
import '../model/coin_chart_model.dart';

class CoinChartRepositoryImpl implements CoinChartRepository {
  final CoinChartRemoteDataSource remoteDataSource;

  CoinChartRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<CoinChart> getCoinChart({
    required String coinId,
    required int days,
  }) async {
    final response = await remoteDataSource.getCoinChart(
      coinId: coinId,
      days: days,
    );

    return CoinChartModel.fromJson(response);
  }
}
