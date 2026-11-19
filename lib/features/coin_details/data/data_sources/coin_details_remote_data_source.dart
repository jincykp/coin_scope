import 'package:coin_scope/core/constants/api_constants.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../model/coin_details_model.dart';

class CoinDetailsRemoteDataSource {
  final Dio dio;

  CoinDetailsRemoteDataSource({Dio? dio})
      : dio = dio ?? DioClient.dio;

  Future<CoinDetailsModel> getCoinDetails(String coinId) async {
    try {
      final response = await dio.get(
       ApiEndpoints.coinDetails(coinId),
        queryParameters: {
          'localization': false,
          'tickers': false,
          'market_data': true,
          'community_data': false,
          'developer_data': false,
          'sparkline': true,
        },
      );

      return CoinDetailsModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException {
      rethrow;
    }
  }
}