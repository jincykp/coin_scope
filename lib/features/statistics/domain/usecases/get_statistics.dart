import '../entities/statistics.dart';
import '../repositories/statistics_repository.dart';

class GetStatistics {
  final StatisticsRepository repository;

  GetStatistics({required this.repository});

  Future<Statistics> call() {
    return repository.getStatistics();
  }
}