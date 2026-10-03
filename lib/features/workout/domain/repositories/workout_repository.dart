import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';

abstract interface class WorkoutRepository {
  /// Finished workouts, newest first.
  Stream<List<Workout>> watchCompletedWorkouts();

  /// Emits the in-progress workout, or `null` when none is running.
  Stream<Workout?> watchActiveWorkout();

  Future<Result<Workout?>> getActiveWorkout();

  Future<Result<Workout>> getWorkout(String id);

  /// Finished workouts that started inside [range], oldest first.
  Future<Result<List<Workout>>> getCompletedWorkouts(DateRange range);

  Future<Result<int>> countCompletedWorkouts();

  /// Inserts or replaces the whole workout including exercises and sets.
  Future<Result<void>> saveWorkout(Workout workout);

  /// Atomically loads the workout, applies [transform] and stores the result.
  Future<Result<Workout>> updateWorkout(
    String id,
    Workout Function(Workout current) transform,
  );

  Future<Result<void>> deleteWorkout(String id);
}
