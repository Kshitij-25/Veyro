import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/gps_tracking/data/datasources/tracked_activity_local_data_source.dart';
import 'package:fitness_trakcer/features/gps_tracking/data/mappers/tracked_activity_mapper.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/repositories/tracked_activity_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TrackedActivityRepository)
class TrackedActivityRepositoryImpl implements TrackedActivityRepository {
  const TrackedActivityRepositoryImpl(this._localDataSource);

  final TrackedActivityLocalDataSource _localDataSource;

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
}
