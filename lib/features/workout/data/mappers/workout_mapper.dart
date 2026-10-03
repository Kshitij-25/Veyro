import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/features/workout/data/mappers/exercise_mapper.dart';
import 'package:fitness_trakcer/features/workout/data/models/workout_aggregate.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_set.dart';

extension WorkoutAggregateMapper on WorkoutAggregate {
  Workout toEntity() => Workout(
    id: workout.id,
    name: workout.name,
    startedAt: workout.startedAt,
    endedAt: workout.endedAt,
    routineId: workout.routineId,
    notes: workout.notes,
    caloriesBurned: workout.caloriesBurned,
    exercises: [for (final e in exercises) e.toEntity()],
  );
}

extension WorkoutExerciseAggregateMapper on WorkoutExerciseAggregate {
  WorkoutExercise toEntity() => WorkoutExercise(
    id: workoutExercise.id,
    exercise: exercise.toEntity(),
    position: workoutExercise.position,
    notes: workoutExercise.notes,
    sets: [for (final s in sets) s.toEntity()],
  );
}

extension WorkoutSetRowMapper on WorkoutSetRow {
  WorkoutSet toEntity() => WorkoutSet(
    id: id,
    position: position,
    reps: reps,
    weightKg: weightKg,
    durationSeconds: durationSeconds,
    distanceMeters: distanceMeters,
    isWarmup: isWarmup,
    isCompleted: isCompleted,
  );
}

extension WorkoutEntityMapper on Workout {
  WorkoutsCompanion toCompanion() => WorkoutsCompanion(
    id: Value(id),
    name: Value(name),
    startedAt: Value(startedAt),
    endedAt: Value(endedAt),
    routineId: Value(routineId),
    notes: Value(notes),
    caloriesBurned: Value(caloriesBurned),
  );
}

extension WorkoutExerciseEntityMapper on WorkoutExercise {
  WorkoutExercisesCompanion toCompanion(String workoutId) =>
      WorkoutExercisesCompanion(
        id: Value(id),
        workoutId: Value(workoutId),
        exerciseId: Value(exercise.id),
        position: Value(position),
        notes: Value(notes),
      );
}

extension WorkoutSetEntityMapper on WorkoutSet {
  WorkoutSetsCompanion toCompanion(String workoutExerciseId) =>
      WorkoutSetsCompanion(
        id: Value(id),
        workoutExerciseId: Value(workoutExerciseId),
        position: Value(position),
        reps: Value(reps),
        weightKg: Value(weightKg),
        durationSeconds: Value(durationSeconds),
        distanceMeters: Value(distanceMeters),
        isWarmup: Value(isWarmup),
        isCompleted: Value(isCompleted),
      );
}
