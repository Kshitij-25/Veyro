import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_day_summary.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';

/// Access to the platform health store (HealthKit / Health Connect).
abstract interface class HealthDataSource {
  Future<HealthAccessStatus> getAccessStatus();

  Future<HealthAccessStatus> requestAccess();

  Future<List<HealthDaySummary>> getDailySummaries(DateRange range);
}
