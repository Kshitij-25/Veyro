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
      .map((rows) => _dedupe(rows.map((row) => row.toEntity()).toList()));

  @override
  Future<Result<List<TrackedActivity>>> getActivities(DateRange range) =>
      guard(() async {
        final rows = await _localDataSource.getRange(range);
        return _dedupe(rows.map((row) => row.toEntity()).toList());
      });

  /// iPhone and Watch can each record the same session. Of Health-imported
  /// activities that overlap by more than half, keep the fuller one.
  static List<TrackedActivity> _dedupe(List<TrackedActivity> all) {
    bool overlaps(TrackedActivity a, TrackedActivity b) {
      final from = a.startedAt.isAfter(b.startedAt) ? a.startedAt : b.startedAt;
      final to = a.endedAt.isBefore(b.endedAt) ? a.endedAt : b.endedAt;
      final shared = to.difference(from).inSeconds;
      if (shared <= 0) return false;
      final shorter = [
        a.endedAt.difference(a.startedAt).inSeconds,
        b.endedAt.difference(b.startedAt).inSeconds,
      ].reduce((x, y) => x < y ? x : y);
      return shorter <= 0 || shared / shorter > 0.5;
    }

    double weight(TrackedActivity a) => a.caloriesKcal + a.distanceMeters / 100;

    final kept = <TrackedActivity>[];
    for (final a in all) {
      if (!a.id.startsWith('health-')) {
        kept.add(a);
        continue;
      }
      final i = kept.indexWhere(
        (k) => k.id.startsWith('health-') && overlaps(k, a),
      );
      if (i == -1) {
        kept.add(a);
      } else if (weight(a) > weight(kept[i])) {
        kept[i] = a;
      }
    }
    return kept;
  }

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
