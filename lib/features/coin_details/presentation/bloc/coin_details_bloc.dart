
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../domain/usecases/get_coin_details.dart';
import 'coin_details_event.dart';
import 'coin_details_state.dart';

class CoinDetailsBloc
    extends Bloc<CoinDetailsEvent, CoinDetailsState> {
  final GetCoinDetails getCoinDetails;

  CoinDetailsBloc({
    required this.getCoinDetails,
  }) : super(CoinDetailsInitial()) {
    on<FetchCoinDetailsEvent>(_onFetchCoinDetails);
  }

  Future<void> _onFetchCoinDetails(
    FetchCoinDetailsEvent event,
    Emitter<CoinDetailsState> emit,
  ) async {
    emit(CoinDetailsLoading());

    try {
      final result = await getCoinDetails(event.coinId);
      emit(CoinDetailsLoaded(result));
    } catch (e) {
      emit(CoinDetailsError(_getErrorMessage(e)));
    }
  }

 String _getErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Please check your internet connection and try again.';

      case DioExceptionType.transformTimeout:
        return 'Request took too long. Please try again.';

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        switch (statusCode) {
          case 401:
            return 'Unauthorized. Please check your API key.';
          case 429:
            return 'Too many requests. Please try again later.';
          case 500:
          case 502:
          case 503:
          case 504:
            return 'Server is currently unavailable. Please try again later.';
          default:
            return 'Unable to load coin details. Please try again.';
        }

      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badCertificate:
        return 'Secure connection failed.';
      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }

  return 'Unable to load coin details. Please try again.';
}
}
