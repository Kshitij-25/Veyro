import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_body_reading.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_day_summary.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_heart_rate_sample.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_recovery_day.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_recovery_record.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_sleep_night.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_workout.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';

/// Access to the platform health store (HealthKit / Health Connect).
abstract interface class HealthDataSource {
  Future<HealthAccessStatus> getAccessStatus();

  Future<HealthAccessStatus> requestAccess();

  Future<List<HealthDaySummary>> getDailySummaries(DateRange range);

  /// Sleep, HRV and resting heart rate for each day in [range].
  Future<List<HealthRecoveryDay>> getRecoveryDays(DateRange range);

  /// Weight and body-fat readings recorded inside [range], oldest first.
  Future<List<HealthBodyReading>> getBodyReadings(DateRange range);

  /// Readable names of the apps and devices that wrote data inside [range].
  Future<List<String>> getSourceNames(DateRange range);

  /// Sends the user to install Health Connect (Android only).
  Future<void> installProvider();

  /// Nights of sleep (with stages when the device reports them) for the days
  /// in [range]. Nights without data are omitted.
  Future<List<HealthSleepNight>> getSleepNights(DateRange range);

  /// Heart-rate samples inside [range], oldest first.
  Future<List<HealthHeartRateSample>> getHeartRateSamples(DateRange range);

  /// Every workout inside [range], oldest first.
  Future<List<HealthWorkout>> getWorkouts(DateRange range);

  /// Sleep, HRV and resting heart rate for every day in [range], read in
  /// bulk. Days with nothing recorded are omitted.
  Future<List<HealthRecoveryRecord>> getRecoveryHistory(DateRange range);

  /// Asks for access to data older than 30 days (Android 14+ / Health
  /// Connect). Returns whether it is available to the app.
  Future<bool> requestHistoryAccess();
}
