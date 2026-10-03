import 'package:fitness_trakcer/core/extensions/date_time_extensions.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/activity_local_data_source.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart';
import 'package:fitness_trakcer/features/activity/data/mappers/daily_activity_mapper.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/daily_activity.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';
import 'package:fitness_trakcer/features/activity/domain/repositories/activity_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ActivityRepository)
class ActivityRepositoryImpl implements ActivityRepository {
  const ActivityRepositoryImpl(
    this._localDataSource,
    this._healthDataSource,
    this._clock,
  );

  final ActivityLocalDataSource _localDataSource;
  final HealthDataSource _healthDataSource;
  final Clock _clock;

  @override
  Stream<DailyActivity?> watchDay(DateTime date) =>
      _localDataSource.watchDay(date).map((row) => row?.toEntity());

  @override
  Future<Result<List<DailyActivity>>> getRange(DateRange range) =>
      guard(() async {
        final rows = await _localDataSource.getRange(range);
        return rows.map((row) => row.toEntity()).toList();
      });

  @override
  Future<Result<void>> saveDay(DailyActivity activity) => guard(
    () => _localDataSource.upsert(
      activity
          .copyWith(date: activity.date.startOfDay)
          .toCompanion(_clock.now()),
    ),
  );

  @override
  Future<Result<HealthAccessStatus>> getHealthAccessStatus() =>
      guard(_healthDataSource.getAccessStatus);

  @override
  Future<Result<HealthAccessStatus>> requestHealthAccess() =>
      guard(_healthDataSource.requestAccess);

  @override
  Future<Result<void>> syncFromHealth(DateRange range) => guard(() async {
    final summaries = await _healthDataSource.getDailySummaries(range);
    final now = _clock.now();
    await _localDataSource.upsertAll([
      for (final summary in summaries) summary.toEntity().toCompanion(now),
    ]);
  });
}
