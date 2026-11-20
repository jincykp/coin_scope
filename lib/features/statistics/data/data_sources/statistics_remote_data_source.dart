
import 'package:coin_scope/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../model/statistics_model.dart';

class StatisticsRemoteDataSource {
  final Dio dio;

  StatisticsRemoteDataSource({Dio? dio})
      : dio = dio ?? DioClient.dio;

  Future<StatisticsModel> getStatistics() async {
    try {
      final response = await dio.get(ApiEndpoints.global);

      final data = response.data['data'] as Map<String, dynamic>;

      return StatisticsModel.fromJson(data);
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch global statistics: $e');
    }
  }
}
