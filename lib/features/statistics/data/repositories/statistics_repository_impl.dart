import '../../domain/entities/statistics.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../data_sources/statistics_remote_data_source.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsRemoteDataSource remoteDataSource;

  StatisticsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Statistics> getStatistics() {
    return remoteDataSource.getStatistics();
  }
}