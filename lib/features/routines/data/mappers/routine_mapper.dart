import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/extensions/date_time_extensions.dart';
import 'package:fitness_trakcer/features/routines/data/models/routine_aggregate.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine_exercise.dart';
import 'package:fitness_trakcer/features/workout/data/mappers/exercise_mapper.dart';

extension RoutineAggregateMapper on RoutineAggregate {
  Routine toEntity() => Routine(
    id: routine.id,
    name: routine.name,
    notes: routine.notes,
    createdAt: routine.createdAt,
    scheduledWeekdays: routine.scheduledWeekdaysMask.toWeekdaySet(),
    exercises: [
      for (final e in exercises)
        RoutineExercise(
          id: e.routineExercise.id,
          exercise: e.exercise.toEntity(),
          position: e.routineExercise.position,
          targetSets: e.routineExercise.targetSets,
          targetReps: e.routineExercise.targetReps,
          targetWeightKg: e.routineExercise.targetWeightKg,
          restSeconds: e.routineExercise.restSeconds,
        ),
    ],
  );
}

extension RoutineEntityMapper on Routine {
  RoutinesCompanion toCompanion() => RoutinesCompanion(
    id: Value(id),
    name: Value(name),
    notes: Value(notes),
    scheduledWeekdaysMask: Value(scheduledWeekdays.toWeekdayMask()),
    createdAt: Value(createdAt),
  );
}

extension RoutineExerciseEntityMapper on RoutineExercise {
  RoutineExercisesCompanion toCompanion(String routineId) =>
      RoutineExercisesCompanion(
        id: Value(id),
        routineId: Value(routineId),
        exerciseId: Value(exercise.id),
        position: Value(position),
        targetSets: Value(targetSets),
        targetReps: Value(targetReps),
        targetWeightKg: Value(targetWeightKg),
        restSeconds: Value(restSeconds),
      );
}
