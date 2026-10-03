import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_body_reading.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_day_summary.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_heart_rate_sample.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_recovery_day.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_recovery_record.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_sleep_night.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_workout.dart';
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

  @override
  Future<List<HealthRecoveryDay>> getRecoveryDays(DateRange range) async =>
      const [];

  @override
  Future<List<HealthBodyReading>> getBodyReadings(DateRange range) async =>
      const [];

  @override
  Future<List<String>> getSourceNames(DateRange range) async => const [];

  @override
  Future<void> installProvider() async {}

  @override
  Future<List<HealthSleepNight>> getSleepNights(DateRange range) async =>
      const [];

  @override
  Future<List<HealthHeartRateSample>> getHeartRateSamples(
    DateRange range,
  ) async => const [];

  @override
  Future<List<HealthWorkout>> getWorkouts(DateRange range) async => const [];

  @override
  Future<List<HealthRecoveryRecord>> getRecoveryHistory(
    DateRange range,
  ) async => const [];

  @override
  Future<bool> requestHistoryAccess() async => false;
}
