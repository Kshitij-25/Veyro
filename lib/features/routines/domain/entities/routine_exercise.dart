import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'routine_exercise.freezed.dart';

@freezed
abstract class RoutineExercise with _$RoutineExercise {
  const factory RoutineExercise({
    required String id,
    required Exercise exercise,
    required int position,
    required int targetSets,
    required int targetReps,
    double? targetWeightKg,
    @Default(90) int restSeconds,
  }) = _RoutineExercise;
}
