import 'package:dio/dio.dart';

class DioClient {
  DioClient._();

  static const String apiKey = 'CG-iVhXiTxn5dyzZCtkWpCSQuHx';

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.coingecko.com/api/v3',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'x-cg-demo-api-key': apiKey,
      },
    ),
  );
}