import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/daily_activity.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';

abstract interface class ActivityRepository {
  /// Emits `null` when nothing has been recorded for the day yet.
  Stream<DailyActivity?> watchDay(DateTime date);

  /// Stored days inside [range], oldest first. Days without data are omitted.
  Future<Result<List<DailyActivity>>> getRange(DateRange range);

  Future<Result<void>> saveDay(DailyActivity activity);

  Future<Result<HealthAccessStatus>> getHealthAccessStatus();

  Future<Result<HealthAccessStatus>> requestHealthAccess();

  /// Reads the days in [range] from the platform health store and caches them.
  Future<Result<void>> syncFromHealth(DateRange range);
}
