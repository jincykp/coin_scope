import 'package:coin_scope/core/constants/api_constants.dart';
import 'package:coin_scope/features/market/data/model/coin_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';

class CoinRemoteDataSource {
  final Dio dio;

  CoinRemoteDataSource({Dio? dio}) : dio = dio ?? DioClient.dio;

  Future<List<CoinModel>> getCoins() async {
    try {
      final response = await dio.get(
ApiEndpoints.coins,
        queryParameters: {
          'vs_currency': 'usd',
          'order': 'market_cap_desc',
          'per_page': 20,
          'page': 1,
          'sparkline': true,
          'price_change_percentage': '1h,24h,7d,14d,30d,200d,1y',
        },
      );

      return (response.data as List)
          .map((json) => CoinModel.fromJson(
                json as Map<String, dynamic>,
              ))
          .toList();
    } on DioException {
      rethrow;
    }
  }
}