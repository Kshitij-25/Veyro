import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/id_generator.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/routines/domain/repositories/routine_repository.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_set.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

/// Starts a workout pre-filled with a routine's exercises and target sets.
@lazySingleton
class StartWorkoutFromRoutine implements UseCase<Workout, String> {
  const StartWorkoutFromRoutine(
    this._routines,
    this._workouts,
    this._ids,
    this._clock,
  );

  final RoutineRepository _routines;
  final WorkoutRepository _workouts;
  final IdGenerator _ids;
  final Clock _clock;

  @override
  Future<Result<Workout>> call(String params) async {
    final active = await _workouts.getActiveWorkout();
    if (active case Fail(:final failure)) return Fail(failure);
    if (active.dataOrNull != null) {
      return const Fail(ValidationFailure('A workout is already in progress.'));
    }

    final routineResult = await _routines.getRoutine(params);
    if (routineResult case Fail(:final failure)) return Fail(failure);
    final routine = routineResult.dataOrNull!;

    final workout = Workout(
      id: _ids.generate(),
      name: routine.name,
      startedAt: _clock.now(),
      routineId: routine.id,
      exercises: [
        for (final entry in routine.exercises)
          WorkoutExercise(
            id: _ids.generate(),
            exercise: entry.exercise,
            position: entry.position,
            sets: [
              for (var i = 0; i < entry.targetSets; i++)
                WorkoutSet(
                  id: _ids.generate(),
                  position: i,
                  reps: entry.exercise.trackingType.tracksReps
                      ? entry.targetReps
                      : null,
                  weightKg: entry.exercise.trackingType.tracksWeight
                      ? entry.targetWeightKg
                      : null,
                ),
            ],
          ),
      ],
    );
    final saved = await _workouts.saveWorkout(workout);
    return saved.map((_) => workout);
  }
}
