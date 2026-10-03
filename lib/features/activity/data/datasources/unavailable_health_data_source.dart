import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_day_summary.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';

/// Used on platforms without a health store (web, desktop). Activity can
/// still be logged manually.
class UnavailableHealthDataSource implements HealthDataSource {
  const UnavailableHealthDataSource();

  @override
  Future<HealthAccessStatus> getAccessStatus() async =>
      HealthAccessStatus.unavailable;

  @override
  Future<HealthAccessStatus> requestAccess() async =>
      HealthAccessStatus.unavailable;

  @override
  Future<List<HealthDaySummary>> getDailySummaries(DateRange range) async =>
      const [];
}
