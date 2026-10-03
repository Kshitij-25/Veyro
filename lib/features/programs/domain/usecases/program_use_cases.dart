import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/id_generator.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/programs/data/seed/training_catalogue.dart';
import 'package:fitness_trakcer/features/programs/domain/entities/training_plan.dart';
import 'package:fitness_trakcer/features/programs/domain/repositories/program_repository.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_set.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/exercise_repository.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

/// The active program with progress counted from finished workouts named
/// after it since enrolling. `null` when not enrolled.
@lazySingleton
class GetProgramProgress implements UseCase<ProgramProgress?, NoParams> {
  const GetProgramProgress(this._programs, this._workouts, this._clock);

  final ProgramRepository _programs;
  final WorkoutRepository _workouts;
  final Clock _clock;

  @override
  Future<Result<ProgramProgress?>> call(NoParams params) => guard(() async {
    final enrollment = (await _programs.getEnrollment()).getOrThrow();
    if (enrollment == null) return null;
    final program = trainingPrograms
        .where((p) => p.id == enrollment.programId)
        .firstOrNull;
    if (program == null) return null;
    final now = _clock.now();
    final done = (await _workouts.getCompletedWorkouts(
      DateRange(enrollment.startedAt, now.add(const Duration(days: 1))),
    )).getOrThrow();
    final count = done
        .where((w) => w.name.startsWith(program.workoutPrefix))
        .length;
    return ProgramProgress(
      program: program,
      startedAt: enrollment.startedAt,
      sessionsDone: count,
    );
  });
}

@lazySingleton
class EnrollInProgram implements UseCase<void, String> {
  const EnrollInProgram(this._programs, this._clock);

  final ProgramRepository _programs;
  final Clock _clock;

  @override
  Future<Result<void>> call(String params) =>
      _programs.enroll(params, _clock.now());
}

@lazySingleton
class LeaveProgram implements UseCase<void, NoParams> {
  const LeaveProgram(this._programs);

  final ProgramRepository _programs;

  @override
  Future<Result<void>> call(NoParams params) => _programs.leave();
}

class PlannedWorkout {
  const PlannedWorkout(this.name, this.exercises);

  final String name;
  final List<PlanExercise> exercises;
}

/// Starts a workout pre-filled from a plan.
@lazySingleton
class StartPlannedWorkout implements UseCase<Workout, PlannedWorkout> {
  const StartPlannedWorkout(
    this._exercises,
    this._workouts,
    this._ids,
    this._clock,
  );

  final ExerciseRepository _exercises;
  final WorkoutRepository _workouts;
  final IdGenerator _ids;
  final Clock _clock;

  @override
  Future<Result<Workout>> call(PlannedWorkout params) => guard(() async {
    final active = (await _workouts.getActiveWorkout()).getOrThrow();
    if (active != null) {
      throw const FailureException(
        ValidationFailure('A workout is already in progress.'),
      );
    }
    final entries = <WorkoutExercise>[];
    for (final (i, plan) in params.exercises.indexed) {
      final exercise = (await _exercises.getExercise(plan.exerciseId))
          .getOrThrow();
      final type = exercise.trackingType;
      entries.add(
        WorkoutExercise(
          id: _ids.generate(),
          exercise: exercise,
          position: i,
          sets: [
            for (var s = 0; s < plan.sets; s++)
              WorkoutSet(
                id: _ids.generate(),
                position: s,
                reps: type.tracksReps ? plan.target : null,
                durationSeconds:
                    type.tracksDuration &&
                        !type.tracksDistance &&
                        plan.target > 0
                    ? plan.target
                    : null,
              ),
          ],
        ),
      );
    }
    final workout = Workout(
      id: _ids.generate(),
      name: params.name,
      startedAt: _clock.now(),
      exercises: entries,
    );
    (await _workouts.saveWorkout(workout)).getOrThrow();
    return workout;
  });
}
