
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_statistics.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final GetStatistics getStatistics;

  StatisticsBloc({required this.getStatistics})
      : super(const StatisticsInitial()) {
    on<FetchStatisticsEvent>(_onFetchStatistics);
    on<RefreshStatisticsEvent>(_onRefreshStatistics);
  }

  Future<void> _onFetchStatistics(
    FetchStatisticsEvent event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(const StatisticsLoading());

    try {
      final statistics = await getStatistics();
      emit(StatisticsLoaded(statistics));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }

  Future<void> _onRefreshStatistics(
    RefreshStatisticsEvent event,
    Emitter<StatisticsState> emit,
  ) async {
    try {
      final statistics = await getStatistics();
      emit(StatisticsLoaded(statistics));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }
}
