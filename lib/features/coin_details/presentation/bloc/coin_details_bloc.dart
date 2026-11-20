
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
        default:
          return 'Unable to load coin details. Please try again.';
      }
    }

    return 'Unable to load coin details. Please try again.';
  }
}
