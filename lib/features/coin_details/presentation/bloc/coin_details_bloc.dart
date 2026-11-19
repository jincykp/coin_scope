import 'package:flutter_bloc/flutter_bloc.dart';

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
      emit(CoinDetailsError(e.toString()));
    }
  }
}