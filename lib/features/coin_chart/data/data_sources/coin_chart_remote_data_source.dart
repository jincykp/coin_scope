
import 'package:coin_scope/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';

class CoinChartRemoteDataSource {
  final Dio dio;

  CoinChartRemoteDataSource({Dio? dio})
      : dio = dio ?? DioClient.dio;

  Future<Map<String, dynamic>> getCoinChart({
    required String coinId,
    required int days,
  }) async {
    try {
      final response = await dio.get(
ApiEndpoints.coinMarketChart(coinId),
        queryParameters: {
          'vs_currency': 'usd',
          'days': days,
        },
      );

      return response.data as Map<String, dynamic>;
    } on DioException {
      rethrow;
    }
  }
}
