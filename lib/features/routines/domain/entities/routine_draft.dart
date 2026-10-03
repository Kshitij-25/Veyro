import 'package:fitness_trakcer/features/routines/domain/entities/routine.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'routine_draft.freezed.dart';

/// Editable form of a [Routine]: ids are optional and assigned on save.
@freezed
abstract class RoutineDraft with _$RoutineDraft {
  const factory RoutineDraft({
    String? id,
    @Default('') String name,
    String? notes,
    @Default([]) List<RoutineExerciseDraft> exercises,
    @Default({}) Set<int> scheduledWeekdays,
  }) = _RoutineDraft;

  factory RoutineDraft.fromRoutine(Routine routine) => RoutineDraft(
    id: routine.id,
    name: routine.name,
    notes: routine.notes,
    scheduledWeekdays: routine.scheduledWeekdays,
    exercises: [
      for (final e in routine.exercises)
        RoutineExerciseDraft(
          exercise: e.exercise,
          targetSets: e.targetSets,
          targetReps: e.targetReps,
          targetWeightKg: e.targetWeightKg,
          restSeconds: e.restSeconds,
        ),
    ],
  );
}

@freezed
abstract class RoutineExerciseDraft with _$RoutineExerciseDraft {
  const factory RoutineExerciseDraft({
    required Exercise exercise,
    @Default(3) int targetSets,
    @Default(10) int targetReps,
    double? targetWeightKg,
    @Default(90) int restSeconds,
  }) = _RoutineExerciseDraft;
}
