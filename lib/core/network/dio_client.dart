import 'package:dio/dio.dart';

class DioClient {
  DioClient._();

  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: 'https://api.coingecko.com/api/v3',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'x-cg-demo-api-key': 'CG-iVhXiTxn5dyzZCtkWpCSQuHx'},
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            request: true,
            requestHeader: false,
            requestBody: true,
            responseHeader: false,
            responseBody: true,
            error: true,
            logPrint: (object) => print(object),
          ),
        );
}
