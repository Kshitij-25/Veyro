import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart';
import 'package:fitness_trakcer/features/gps_tracking/data/datasources/tracked_activity_local_data_source.dart';
import 'package:fitness_trakcer/features/gps_tracking/data/mappers/tracked_activity_mapper.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity_type.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/repositories/tracked_activity_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TrackedActivityRepository)
class TrackedActivityRepositoryImpl implements TrackedActivityRepository {
  const TrackedActivityRepositoryImpl(
    this._localDataSource,
    this._healthDataSource,
  );

  final TrackedActivityLocalDataSource _localDataSource;
  final HealthDataSource _healthDataSource;

  @override
  Stream<List<TrackedActivity>> watchActivities() => _localDataSource
      .watchAll()
      .map((rows) => rows.map((row) => row.toEntity()).toList());

  @override
  Future<Result<List<TrackedActivity>>> getActivities(DateRange range) =>
      guard(() async {
        final rows = await _localDataSource.getRange(range);
        return rows.map((row) => row.toEntity()).toList();
      });

  @override
  Future<Result<TrackedActivity>> getActivity(String id) => guard(() async {
    final row = await _localDataSource.getById(id);
    if (row == null) {
      throw const FailureException(NotFoundFailure('Activity not found.'));
    }
    return row.toEntity();
  });

  @override
  Future<Result<void>> saveActivity(TrackedActivity activity) =>
      guard(() => _localDataSource.upsert(activity.toCompanion()));

  @override
  Future<Result<void>> deleteActivity(String id) =>
      guard(() => _localDataSource.delete(id));

  @override
  Future<Result<int>> importFromHealth(DateRange range) => guard(() async {
    final workouts = await _healthDataSource.getWorkouts(range);
    var imported = 0;
    for (final w in workouts) {
      final seconds = w.end.difference(w.start).inSeconds;
      // Skip glitches: under a minute, or longer than a day.
      if (seconds < 60 || seconds > 86400) continue;
      await _localDataSource.upsert(
        TrackedActivity(
          // Stable id: syncing the same workout again overwrites itself.
          id: 'health-${w.uuid}',
          type: TrackedActivityType.values.byName(w.kind),
          title: w.kind == 'other' ? w.title : null,
          startedAt: w.start,
          endedAt: w.end,
          movingDuration: Duration(seconds: seconds),
          distanceMeters: w.distanceMeters,
          caloriesKcal: w.caloriesKcal,
        ).toCompanion(),
      );
      imported++;
    }
    return imported;
  });
}
