import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/workout/data/datasources/workout_local_data_source.dart';
import 'package:fitness_trakcer/features/workout/data/mappers/workout_mapper.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: WorkoutRepository)
class WorkoutRepositoryImpl implements WorkoutRepository {
  const WorkoutRepositoryImpl(this._localDataSource);

  final WorkoutLocalDataSource _localDataSource;

  @override
  Stream<List<Workout>> watchCompletedWorkouts() => _localDataSource
      .watchCompleted()
      .map((aggregates) => aggregates.map((a) => a.toEntity()).toList());

  @override
  Stream<Workout?> watchActiveWorkout() =>
      _localDataSource.watchActive().map((aggregate) => aggregate?.toEntity());

  @override
  Future<Result<Workout?>> getActiveWorkout() => guard(() async {
    final aggregate = await _localDataSource.getActive();
    return aggregate?.toEntity();
  });

  @override
  Future<Result<Workout>> getWorkout(String id) => guard(() async {
    final aggregate = await _localDataSource.getById(id);
    if (aggregate == null) {
      throw const FailureException(NotFoundFailure('Workout not found.'));
    }
    return aggregate.toEntity();
  });

  @override
  Future<Result<List<Workout>>> getCompletedWorkouts(DateRange range) =>
      guard(() async {
        final aggregates = await _localDataSource.getCompleted(range);
        return aggregates.map((a) => a.toEntity()).toList();
      });

  @override
  Future<Result<int>> countCompletedWorkouts() =>
      guard(_localDataSource.countCompleted);

  @override
  Future<Result<void>> saveWorkout(Workout workout) =>
      guard(() => _localDataSource.saveWorkout(workout));

  @override
  Future<Result<Workout>> updateWorkout(
    String id,
    Workout Function(Workout current) transform,
  ) => guard(() => _localDataSource.updateWorkout(id, transform));

  @override
  Future<Result<void>> deleteWorkout(String id) =>
      guard(() => _localDataSource.deleteWorkout(id));
}
